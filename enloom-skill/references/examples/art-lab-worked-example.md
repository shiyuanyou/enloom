# Worked Example: art_lab

This is a reference, not the main trunk. The generic structures (Registry, Ownership Table, Promise Registry, Evidence Contract, Audit Packet, check_item schema) live in the main references and templates. This file shows how those structures filled in on a real large-scale task, so the generic structure is not abstract.

The task behind this example: a large wiki/civilization-map build with many parallel workers producing pages, a global index/log, and a raw input store. It surfaced five hard lessons — the same five Enloom v0.3 internalizes. The domain-specific commands below (dead-link scan, quote-encoding scan, reference count) are **wiki-domain only** and never appear in the generic templates. They appear here as worked examples of the `check_item` 5-tuple.

## Lesson 1 — State that records only "done" leaves systematic gaps (→ Registry)

In the original task, a state file recorded completed batches. After a context reset, the agent could not recover: the file said "X done" but did not record the 16+ broken references those batches had left behind. Recovery required re-scanning everything.

> **Naming note:** "the agent" above refers to the **operator of the original art_lab task** (a real external wiki/civilization-map build), not Enloom's control agent or worker. This example is a faithful historical record; the wording is preserved as-is rather than re-mapped onto Enloom role names.

The generalization: record the **unclosed-risk list**, not the completed-work list. This is why the [Registry](../registry-and-compaction.md) has seven sections, four of them risk-bearing (Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports). What lets you recover is the risk list.

## Lesson 2 — An all-PASS audit that still left 16+ dead links (→ Evidence Contract)

The original AUDIT_TEMPLATE bound a command to every check, which indirectly discouraged evidence-free PASS. But it did not *forbid* it. Result: audits reported all-PASS while dead links accumulated. The fix (now the [Evidence Contract](../evidence-contract.md) hard constraint): `PASS` requires non-empty evidence for every declared check, explicitly, checkably.

## Lesson 3 — A worker casually editing the global index broke ownership (→ Ownership Table, two-list discipline)

In the original task, a worker "helpfully" rewrote the shared `index.md` / `log.md` while producing its own page, silently corrupting the global state. The fix: packets give workers a `Writable Files` list **and** a `Forbidden Files` list that **explicitly names the serial-integration files** (index, log, state), not just "don't touch shared files." See [registry-and-compaction.md §2](../registry-and-compaction.md).

## Lesson 4 — Forward-declared pages referenced before they existed (→ Promise Registry)

The original Promise Pages: a worker wrote a wikilink to a page another worker would create later, non-blocking; a final pass verified every link resolved. This worked because wikilinks tolerate dangling references. It would *not* work for code imports. The generalization: the [Promise Registry](../registry-and-compaction.md §3) with an explicit degradation rule — only use promise + parallel when the reference layer tolerates dangling refs.

## Lesson 5 — State ballooned until unreadable (→ Compaction Protocol)

The original state file grew until a new session could not read it in reasonable time. Compressing it naively risked dropping unclosed risks. The [Compaction Protocol](../registry-and-compaction.md §4) makes the rule explicit: compress resolved detail only, and verify the risk-section item count does not drop after compaction.

---

## How the generic structures filled in (concrete commands)

These commands are **examples of filling the schema**, not reusable code. They are wiki-domain specific. For a code/research task, the `command` slot would hold the relevant check for that domain.

### check_item — dead-link scan (art_lab original one-liner)

```
- id: dead-link-scan
  command: rg --no-heading '\[\[([^]|]+)(\|[^]]*)?\]\]' -or '$1' <scope> | sort -u
            then check each target exists
  pass_condition: every captured target resolves to an existing page
  fail_signal: any target with no matching file → emit "DEAD: <target>"
  named_list: dead_links
```

What this teaches: the `check_item` is domain-agnostic in *shape* (id / command / pass / fail / named_list) but domain-specific in *content*. The generic [audit-task-packet.md](../templates/audit-task-packet.md) provides the shape; the task at hand fills the command.

### check_item — quote-encoding scan (art_lab original)

```
- id: quote-encoding-scan
  command: find <scope> -type f -name '*"*'   # files whose names contain a stray quote
  pass_condition: no files matched
  fail_signal: any matched file → emit "MALFORMED: <path>"
  named_list: malformed_outputs
```

### check_item — reference count (art_lab original)

```
- id: orphan-reference-count
  command: for each declared output, count inbound references; flag those with 0 consumers
  pass_condition: every declared output has ≥1 consumer (or is explicitly a leaf)
  fail_signal: any promised output with 0 consumers and not marked leaf → emit "ORPHAN: <id>"
  named_list: orphans
```

### Ownership Table — filled with art_lab's three tiers

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| Each lane's new pages (`page-A.md`, `page-B.md`) | Parallel-write zone | Worker-A / Worker-B exclusive | Execute |
| `index.md`, `log.md`, backfill files | Serial-integration zone | Single-threaded control agent | Integrate |
| `raw/` inputs | Read-only zone | No one | All |

This is the concrete instance of the [Ownership Table](../registry-and-compaction.md §2) skeleton in [phase-plan.md](../templates/phase-plan.md).

### Promise Registry — filled with a dangling wikilink

```
promised_output:
  declarer: Worker-B (lane B)
  identifier: [[civilization-X]]
  consumers: [Worker-A (lane A page references it)]
  verify_at: Verify (final audit)
  status: promised → (after Worker-B done) fulfilled → (if Worker-B failed) broken
```

Operating cycle: Plan drafted it → Worker-A wrote the dangling link during Execute (non-blocking) → the final audit's `dead-link-scan` check verified it. Because wikilinks tolerate dangling references, promise + parallel was allowed. For a code-import task, this would have forced serial.

### Severity levels in practice

- **high**: a dead link on a *navigation* page (blocks traversal) → FAIL the audit.
- **medium**: a dead link on a *content* page (reader still reaches most material) → ISSUES, log to Registry, continue.
- **low**: a formatting inconsistency with no functional impact → registry entry only.

This is the three-state verdict ([Evidence Contract](../evidence-contract.md)) in action: the medium case is `ISSUES`, which let the build continue with the defect logged, rather than forcing an all-or-nothing stop.

---

## What stays out of the main trunk

Everything domain-specific above stays here. The main references contain only the generic structure:

| In this example only | Generic form in main references |
|----------------------|---------------------------------|
| `rg '\[\[...\]\]'` dead-link one-liner | `check_item.command` slot |
| `find ... -name '*"*'` quote-encoding scan | `check_item.command` slot |
| `index.md` / `log.md` / `raw/` as the three tiers | Ownership Table three-tier model |
| wikilink forward declaration | Promise Registry |
| navigation-page vs content-page severity | three-state verdict + severity levels |

The skill body stays general for code/research work; the art_lab experience is not lost, it lives here as a concrete reference.
