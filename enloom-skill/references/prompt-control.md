# Prompt Control — Route Pre-fill, Multi-Layer Dispatch, Script Pitfalls

Three orchestration lessons that the five core mechanisms (Registry / Evidence Contract / Ownership+Promise / Compaction / Audit) do not cover. All three were distilled from a real large-scale task *after* v0.3 was internalized (2026-06-24 → 06-28), so they are recorded here rather than retro-fitted into the v0.3 references. Each follows the same shape as the other references: a concrete failure observed in the field, the general mechanism it reveals, and when to apply it.

These are **prompt-construction technique**, not new law. They refine *how* the control agent builds and hands off a task packet — they sit one layer above the [task-packet template](templates/task-packet.md) fields.

## 1. Route Pre-fill — main window decides routing, worker only executes

### The failure

A batch split/migrate operation was dispatched to workers with the instruction "split these canon lines and redirect the rest." Workers independently *decided* the routing (which line goes to which file, what redirects where). Result: each worker re-derived routing from its local bundle, routes contradicted across workers, and a global redirect one worker applied ate the exact strings another worker's structured edits needed — every structured edit missed.

### The mechanism

There are two kinds of decisions in a batch task, and they must be separated:

| Decision type | Who handles it | Why |
|---------------|----------------|-----|
| **Routing** — redirect targets, file destinations, split points, where each unit lands | The **control agent** (main window), pre-filled into a script's data structure | Routing needs the global picture (the full file map, the full redirect table). A worker only sees its bundle. |
| **Execution** — write the content markdown, run the script, verify the count | The **worker** | Execution needs only the bundle. |

The control agent pre-fills the routing into a data structure (a `BATCH_PLANS` table, a redirects map, a splits list) *before* dispatch. The worker then has **zero routing decisions** — it writes content and calls the script. "Needs the global to decide" is separated from "needs only the bundle to execute."

### When to apply

Use route pre-fill when **all** hold:

- The task is a split / migrate / merge / rename batch (units moving between files).
- Each unit's destination is **mechanically decidable** (a rule the control agent can compute up front, not a judgment call).
- A script or data file can carry the routing table.

Do **not** use it when the destination is a judgment call (e.g. "is this concept important enough to split out?") — that is content work, not routing, and belongs in the worker's bundle.

### Relation to the Ownership Table

The two are complementary, not overlapping:

- **Ownership Table** ([registry-and-compaction.md §2](registry-and-compaction.md)) answers **who may write which file** — it prevents write conflicts.
- **Route pre-fill** answers **what content goes where, decided by whom** — it prevents routing contradiction.

A parallel batch with an Ownership Table but without route pre-fill can still produce workers that each route differently. For split/migrate/merge batches, you want both.

## 2. Multi-Layer Dispatch Distortion — the telephone game in closed-set constraints

### The failure

An orchestration was structured in three layers: control agent → a "pre-read" agent (summarizes a reference page and the rules) → execution agent (writes pages from the pre-read agent's summary). The pre-read agent returned a *summary of the rules*. That summary became the execution agent's **only** rule source. A closed-set constraint — a 29-item whitelist of concepts, plus a required "reason sentence" format for non-whitelist links — was summarized rather than copied. The summary dropped some whitelist items and loosened the format. Every execution agent then produced non-whitelist links missing the reason sentence, failing the gate.

### The mechanism

Constraints come in two kinds, and they must propagate differently through a multi-layer dispatch:

| Constraint kind | Examples | How it must reach the final worker |
|-----------------|----------|------------------------------------|
| **Closed-set (enumerable)** | whitelists, allowed field names, gate reason-sentence formats, tag vocabularies | The control agent copies it **verbatim from the source** into the execution prompt. **Never** re-summarized. |
| **Open interpretation** | "what makes this reference page good," "what are this bundle's key points," "how do these incoming references relate" | A pre-read agent produces a **rich summary**. Summarizing here is the value, not a loss. |

The discriminator: **can this constraint be exhausted by enumeration?** If yes (a finite list), it is closed-set and must be inlined verbatim. If no (it is a judgment about quality or relationship), it is open interpretation and a summary is appropriate.

The control agent's job in multi-layer dispatch is therefore **adjudicate + copy, not re-summarize**, for closed-set constraints:

1. Read the source constraint from the original (the AGENTS spec, the schema, the gate definition).
2. Copy it **as-is** into the execution prompt.
3. Let the pre-read agent handle only the open-interpretation material.
4. The resulting execution prompt must be **self-contained** — the execution agent should not need to read any further rule source.

### When to apply

This applies the moment your dispatch has more than two layers (control → … → worker), i.e. whenever an intermediate agent's output becomes another agent's rule input. The classic trap is a "research/summarize then execute" pipeline. If you find a pre-read agent returning "here are the rules," treat that as a smell — closed-set rules should never travel through a summary.

In a flat two-layer dispatch (control → worker), the control agent writes the packet directly, so this is automatically satisfied.

### How it interacts with the Evidence Contract

A gate that checks a closed-set constraint (e.g. "every non-whitelist link has a reason sentence") will catch the downstream symptom — workers producing malformed links. But the Evidence Contract catches the *failure*; this lesson prevents the *cause*. If you see the same closed-set violation repeating across many workers, suspect multi-layer distortion, not worker carelessness.

## 3. Script-Execution Pitfalls — derived-output matching and edit ordering

Two field failures from scripts that generate derived analysis or batch-edit files. Both are general beyond their origin domain.

### 3a. Substring matching produces phantom links

**Failure.** A script generated an "influence network" by checking `if token in title` — substring containment. Single-character and short tokens matched almost every title: `假名` hit all Japanese titles, `家` hit nearly everything, a long filename matched many substrings. In-degrees inflated from ~22 to 89. The derived view looked plausible and was nearly shipped.

**Mechanism.** When a script builds a relationship/links/symbol graph by matching names, **use exact parsing, never substring containment.** Extract the real link/symbol syntax with a precise regex (e.g. `\[\[([^\]]+)\]\]` for wikilinks, or the language's actual symbol resolver for code) and match on the parsed identifier. Substring matching manufactures false edges that look structurally valid.

**Check.** After generating any derived relationship view, manually spot-check the **top-N highest-degree nodes** — compare the script's count against a real `grep -c` count of the source. A node whose derived degree is many× its real count is a substring false-positive signature.

### 3b. Structured rewrites must run before global text replacement

**Failure.** A batch script had two kinds of edits over the same files: (a) structured, exact-string rewrites (split a specific canon line, edit a specific frontmatter field) and (b) a global wikilink text replacement (redirect all `[[old]]` → `[[new]]`). The script ran (b) before (a). The global replacement ate the exact strings that (a) needed to match, so every structured edit missed and fell back to "already processed." The batch reported success (no errors) while doing nothing.

**Mechanism.** When a script mixes **structured exact-string matching** with **global text replacement** over the same files, **structured edits must run first.** A global replacement will, by definition, alter the strings a later structured match is looking for. Ordering matters because the two operate on the same text but at different specificity.

**Alternative:** if ordering is hard to control, have the global replacement **explicitly skip** the derived/staging files (those prefixed `_`, or those a downstream script will regenerate) — downstream regeneration means no data loss, and the structured edits on the live files are not disrupted.

### 3c. Diagnosis signals (generalized)

| Symptom | Likely cause |
|---------|--------------|
| Dry-run reports fewer structured-edit hits than expected | A global replacement ran first and consumed the match strings (3b) |
| Live run reports "already processed / not found" with no error | Same as above — fallback path masked the miss (3b) |
| A derived graph node has degree far exceeding its real reference count | Substring matching on a short/common token (3a) |
| Many workers independently produce the same closed-set violation | Multi-layer dispatch distorted the constraint (§2) |

### When to apply

These bite whenever the workflow **generates derived analysis** (influence graphs, dependency maps, cross-reference indexes — §3a) or **batch-edits files with mixed edit types** (refactors, migrations, renames — §3b). Both are common in the Integrate stage (Stage 5) and in audit scripts.

## 4. Epistemic Discipline — separating fact from AI synthesis in research output

### The failure

A research/exploration round produced a set of open "question seeds." Every seed was written up as a **closed conclusion** with `confidence: high`. On review, a large fraction of each conclusion was AI synthesis — philosophical leaps, invented terminology, and extrapolations — dressed up as if they were sourced facts. The conclusions then *closed* questions that should have stayed open, and the fabricated terms propagated downstream as if citable.

### The mechanism

When a worker (or the control agent) generates **research / exploration output** — not code, not a verified artifact, but interpreted findings — the model has a strong tendency to blur three epistemically distinct things:

| Category | What it is | Where it must go |
|----------|-----------|------------------|
| **Fact** | What a source directly states, quotable as-is | The evidence record — **zero synthesis** |
| **Interpretation / extrapolation** | Comparison, causal claim, philosophical leap, invented term | Marked explicitly as **unverified hypothesis**, never cited as fact |
| **Open question** | A tension or gap the material raises | The primary output — kept open, not closed by a premature answer |

The discipline is to **force these into separate, labeled sections** rather than letting them blend into a single "conclusion":

- Facts go into an evidence record with per-source provenance (URL / confidence / type). One source's facts must not be merged with another's without marking the merge.
- Any interpretation, comparison, or invented term is demoted to a labeled "hypothesis (unverified)" section and **may not be cited as fact** downstream.
- The primary deliverable of exploratory work is the **open questions and unresolved tensions it surfaces**, not a closed answer. A conclusion requires all of: research complete, confidence ≥ medium, and explicit sign-off — otherwise the question stays open.

### The signal-word discriminator

The fastest way to catch synthesis masquerading as fact is to flag the words that signal the model is *generating* rather than *reporting*:

| Signal | Example words | Verdict |
|--------|--------------|---------|
| Synthesis / abstraction | "is essentially", "two paths converging", "precisely mirrors", "reduces to", "is nothing but", "a representative of", "stems from X not Y" | → hypothesis (demote) |
| Invented term | A term that does not appear in any source (e.g. a coined "kinesthetic score") | → hypothesis (demote) |
| Source explicitly states it, quotable as-is | — | → fact |
| Uncertain | — | → demote to hypothesis (err conservative) |

Watch especially for: **philosophical leaps** (an empirical claim jumps to an ontological conclusion), **co-occurrence promoted to causation** (A and B appear together → A causes B), and **category slippage** (ground ≠ empty; one concept's frame applied to a different concept).

### When to apply

This applies to any worker whose output is **interpreted research or exploration**, not a mechanically verifiable artifact (code, a passing test, a structured file). The researcher role ([prompt-assets/researcher.md](../prompt-assets/researcher.md)) is the canonical case. It does **not** apply to a coder whose output compiles and passes gates — there, fact and interpretation are not in tension.

### Relation to the Evidence Contract

The Evidence Contract (§"no PASS without evidence") enforces that a *verification claim* carries command evidence. Epistemic discipline is upstream of that: it governs how **research findings themselves** are recorded *before* they reach any gate. A research report that passes an evidence gate can still be epistemically sloppy if its "facts" are quietly AI synthesis. The contract checks verification; this discipline checks the epistemic honesty of the source material.

## 5. Repair-Plan Discipline — a fix plan must verify its own problem statements

### The failure

A repair plan was written to fix a list of alleged defects. On execution, several "defects" turned out not to exist: one item claimed a concept was mis-categorized, but it was in the correct section all along (wrong line number recalled from memory); the plan's verification command used a flag (`grep -P`) the host's BSD grep did not support, so it would have errored regardless. The plan had enumerated problems and fix steps confidently, but **none of its problem statements or verification commands had been re-run against reality** — they were written from recall.

### The mechanism

A repair / remediation / audit-fix plan is itself a kind of assertion, and it is subject to the same evidence rule as the work it critiques:

- **Every problem statement** (line number, section, path, "X is mis-categorized as Y") must be **re-verified against the current file** before the plan is acted on. Memory and inference are not acceptable sources for a fix target.
- **Every verification command** the plan proposes must be **actually run** in the target environment — not assumed to work. A plan that ships a command that fails on the host's tooling is a plan that cannot prove its own fixes.
- If a problem statement does not reproduce, **strike it from the plan** rather than fixing a non-defect. Fixing a phantom problem wastes work and can introduce real defects.

The failure mode this prevents: a confident-looking plan (numbered items, severity labels, fix steps) carries the *air* of rigor while its premises are unverified. The numbering and severity are presentation, not evidence.

### When to apply

This applies whenever the control agent (or a worker) produces a **repair plan, remediation list, or audit-fix proposal** — i.e. a document that asserts "here are the defects, here is how to fix them." It does not apply to a fresh build (no defects claimed yet) or to a simple bounded fix the agent verifies inline as it works.

### Relation to the Evidence Contract and §4

This is the Evidence Contract applied *to the plan itself*, not just to the work: a fix plan is a claim, and claims need evidence. It pairs with §4: §4 says research output must separate fact from synthesis; this says a repair plan must verify its problem statements are facts (not mis-recalled phantoms) before acting on them.

## See Also

- [scheduler-rules.md](scheduler-rules.md) — the Ownership Table (who may write); route pre-fill (§1) complements it with what content goes where.
- [registry-and-compaction.md](registry-and-compaction.md) — §2 Ownership Table, the sibling concept to route pre-fill.
- [evidence-contract.md](evidence-contract.md) — catches the *symptoms* of these failures (gate violations); this reference prevents the *causes*.
- [templates/task-packet.md](templates/task-packet.md) — the packet these techniques shape.
- [examples/art-lab-worked-example.md](examples/art-lab-worked-example.md) — the real task these lessons came from (wiki ingest at scale).
