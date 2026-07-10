# Registry, Ownership, Promise, and Compaction

State governance, in one place. These four mechanisms all answer the same question — how does the control agent keep `project_state.md` a live, recoverable truth instead of a write-only log that balloons until it is unreadable. They share one reference because they share one subject.

The core insight: state that records only "what was completed" leaves systematic gaps. What actually lets you recover a project is the **list of unclosed risks**. The Registry is that list. Ownership, Promise, and Compaction are the disciplines that keep it honest.

## 1. Registry — Seven Sections

The Registry is a fixed structure of `project_state.md`, not a separate file. `project_state.md` lives **inside a project directory** (`.enloom/<created>-<project>/project_state.md`), so the Registry is per-project — each project keeps its own unclosed-risk list, and cross-project risks are never co-mingled. The Compaction Protocol (§4) likewise operates within a single project's state. Seven sections, in this order:

| Section | Meaning |
|---------|---------|
| `## Active Tasks` | In-flight tasks, with status. |
| `## Promised Outputs` | Declared-but-unfulfilled outputs: who promised, who depends on it, verify-at point. (Promise Registry lives here — see §3.) |
| `## Pending Dependencies` | Unmet cross-task / cross-phase dependencies. |
| `## Broken References` | Discovered broken references: source → target, status, note. (Dead links, failed imports, dangling symbol refs, stale TODO pointers.) |
| `## Known Exceptions` | Intentionally retained exceptions — the whitelist, not counted as defects. |
| `## Accepted With Risk` | Accepted items that carry risk and need re-checking. |
| `## Rejected Reports` | Index of rejected reports — failure signals, to prevent retrying the same failed path. |

### Generalization

The wiki-domain words (dead link, promise page) become domain-neutral:

- **Broken References** covers anything where "a product declared a pointer, but the target is missing or broken" — dead links, failed imports, references to non-existent functions, dangling TODO pointers.
- **Promised Outputs** covers anything where "worker A declared it will produce X, and worker B already references X" — a forward declaration.

`## Rejected Reports` exists so failure reports leave an index — the same failed path is not retried blindly.

### Update Discipline

The Registry is only useful if it is actually updated. Three lifecycle obligations:

- **Verify stage (Stage 4)**: after review, the control agent **must** log discovered problems into the matching section (broken reference, accepted-with-risk, rejected). This is what turns the registry from write-only to live.
- **Integrate stage (Stage 5)**: registry update is a precondition for archive (law 5 extended). No archive while open risks are unprocessed.
- **Orient stage (Stage 1)**: the control agent **must scan the four risk sections** on reading project_state — Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports. This is the landing point of "the main agent can be thin but never blind." A thin orchestrator's value is holding the global invariants.

### Interaction with Compaction

The Registry is the live part of project_state. At compaction, Registry sections are preserved first; an item is only moved to archive when it is marked resolved/closed. The unclosed-risk list is always the current truth.

## 2. Ownership Table — Three Tiers

Parallel safety rests on file ownership. Parallel work is not a strategy, it is an exception optimization that becomes possible once ownership is explicit. The universal root is "globally unique mutable state cannot be parallelized."

### Three-Tier Model

| Tier | Semantics | Who can write |
|------|-----------|---------------|
| **Parallel-write zone** | Each worker's exclusive new outputs. | The corresponding worker, exclusively; sets are disjoint. |
| **Serial-integration zone** | Globally unique mutable state. | A single-threaded worker (usually the control agent), exclusively. |
| **Read-only zone** | Immutable input. | No one, ever. |

### Two-List Discipline

A packet given to a worker must provide **both**:

- `Writable Files` — the exclusive list, precise to the path.
- `Forbidden Files` — the do-not-touch list, **explicitly enumerating the serial-integration files** (project_state, decisions, registry-bearing files). Not just "don't touch shared files."

The failure mode this prevents: a worker casually edits the global index/log and breaks ownership. The fix is explicit prohibition in the packet.

### Selection Constraint

The serial-integration zone exists on the premise that "global state cannot be append-only parallel." If a task's global state can be designed as an append-only log (conflict-free merge), the integration zone could in theory parallelize — but the default is to **keep the serial-integration zone single-threaded** unless the Plan stage explicitly argues it can parallelize. This holds the "parallel is the exception" law.

### File-level sole-writer (RA3)

The three-tier model above governs parallel *zones*. RA3 governs ownership at the *artifact* level: every durable artifact has exactly **one sole writer** — no physical file has two writers. `report.md` is entirely worker-owned; `review-result.md` is a separate control-owned artifact. Reviewer/audit workers write proposals into their *own* run's `output.md` / `report.md`; only control integrates — it writes `review-result.md` for the target run and every Verify-worker run. The canonical seven-row table lives in [landing-contract.md §6 Artifact Ownership](landing-contract.md). This supersedes any section-level model: the verdict + conclusion are their own file, not a region of the worker report reserved for control to fill.

### Lifecycle Hooks

- **Plan stage (Stage 2)**: choosing a parallel/hybrid strategy makes the Ownership Table a **hard prerequisite** (law 3 upgraded: No Parallel without Ownership Table).
- **Execute stage (Stage 3)**: `make-prompt` derives each worker's Writable/Forbidden from the table.

The Ownership Table skeleton lives in [templates/phase-plan.md](templates/phase-plan.md).

## 3. Promise Registry — Forward Declarations

A Promise Registry is the generalization of "forward-declare an output + tolerate dangling references + verify at the end." It occupies the Registry's `## Promised Outputs` section.

### Fields

```
promised_output:
  declarer:    who promises (which worker/task will create it)
  identifier:  target identifier (product name / path / symbol)
  consumers:   who depends on it (which workers already reference it)
  verify_at:   verification point (usually the Verify stage)
  status:      promised | fulfilled | broken
```

### Operating Cycle

1. **Plan stage**: the control agent drafts the Promise Registry (which outputs will be forward-declared, who depends on them).
2. **Execute stage**: worker A may reference an output worker B will create (write a dangling reference), non-blocking; each reference logs into `## Promised Outputs`.
3. **Verify stage**: an audit check verifies all promised outputs are fulfilled. Unfulfilled = broken, logged into `## Broken References`, triggering point-fix or downgrade.

### Scope — Promise Registry vs. dangling references by convention

The Promise Registry is scoped to **forward declarations made within one phase by one worker that another worker already references** (worker A declares it will produce X; worker B has already written a reference to X). It is the cross-worker, in-phase contract surface.

A dangling reference that a deliverable carries **by convention** is a different animal: a canon page that forward-declares `[[Djembe]]` because the wiki tolerates dangling links is not promising anything to a sibling worker — it is just exercising the storage format's tolerance. Such convention-borne dangling references do **not** enter the Promise Registry. They are tracked as risk: logged in `## Known Exceptions` if intentionally retained, or in `## Accepted With Risk` if they carry a re-check obligation. The dividing question is "did a *worker* promise this to another *worker* in this phase?" — if not, it is convention, not a Promise Registry entry.

### Degradation Mechanism

Not all storage tolerates dangling references:

- **Storage tolerates dangling references** (e.g. wiki / filesystem dangling links) → write the reference first, verify fulfillment at the end. Promise mechanism + parallel allowed.
- **Storage does not tolerate** (e.g. code imports, strongly-typed symbols) → the promise mechanism cannot be used; the relevant tasks are forced serial (worker B must finish before worker A can reference).

The Plan stage decides "does this task's reference layer tolerate dangling references" — only if it does may promise + parallel be used. This makes an implicit storage constraint an explicit, general decision point.

> The Plan stage does not make this decision from scratch each time — it fills the **Reference Tolerance Decision Table** in [templates/phase-plan.md](templates/phase-plan.md), which walks 3–5 common reference types (wikilinks / markdown links / code imports / file paths / schema `$ref`) as worked examples. The table is scaffolding, not a new gate; it saves the agent re-deriving the tolerance call per project.

## 4. Compaction Protocol

### Problem

State documents bloat. "Compress into state" without compaction discipline just moves context bloat from the chat into the document. A bare trigger threshold is not enough — without a *protocol* (when to trigger, what to compress, where it goes, how to guarantee no unclosed risk is lost) the compaction concept does not protect the Registry.

### Core Principle

**Compress resolved process detail. Never compress unclosed risk.** This is the direct interface with the Registry: the seven sections are the live truth, preserved first at compaction; an item only leaves when marked resolved/closed.

### Trigger Conditions (any one)

> **These thresholds are heuristics, not dogma.** 200 lines / 10 results / ~3 minutes are tuned from one large-scale run, not derived from theory. If a project legitimately needs a longer state (e.g. a long risk-section list), compaction is about *drift*, not the raw number — apply judgment. The non-dogma note cuts the other way too: a state that reads fine at 250 lines is not a license to skip compaction when the risk sections have grown stale.

- `project_state.md` exceeds ~200 lines.
- The project_state `## Accepted Results` section crosses a threshold (e.g. 10 archived results) — note this is a top-level section, not one of the Registry seven.
- A new session's Orient cannot read project_state in ~3 minutes (a subjective but important signal).

### Mandatory vs Skipped

Compaction at the Integrate exit gate is **mandatory**. After every integrate:

- **Threshold met → compaction must run** before the stage exits; deferring is not acceptable. This prevents the Registry from ballooning indefinitely — context bloat migrating from the chat window into the document system.
- **Threshold not met → skip and record.** Log a one-liner ("compaction not triggered: state at N lines / M results") so the decision is auditable, not silent.

### Four Steps

| Step | Action | Compresses | Goes to | Keeps |
|------|--------|-----------|---------|-------|
| 1. Scan | Walk project_state sections | resolved/closed Registry items + archived-phase Accepted Results | — | — |
| 2. Migrate | Move the items from step 1 into `archive/` | process detail, completed-task intermediate state | `archive/phase-history.md` | one-line conclusion in state |
| 3. Closeout | Leave one index line per compacted phase | — | add a `## Archived Phases` index to project_state | "Phase X done on Y, conclusion Z, see archive/" |
| 4. Verify | Run health-check after compaction | — | — | Registry risk sections (Pending/Broken/Accepted-with-Risk/Rejected) **item count must not drop** |

### The Anti-Error Rule (step 4)

The most dangerous compaction failure is "deleted an unclosed risk while compressing." The verify rule:

> Before and after compaction, the item count in the four Registry risk sections (Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports) may only stay flat or decrease — and only when an item is genuinely resolved. It must never vanish due to compression. If the count drops unexpectedly, compaction misdeleted and must roll back.

### Lifecycle Hooks

- **Integrate stage (Stage 5)**: after every integrate, **check the trigger conditions**. If a threshold is met, compaction is **mandatory** — it runs within the stage before the exit gate; deferring is not permitted (compaction is enforced, not merely a triggered check). If no threshold is met, record a one-liner ("compaction not triggered") so the skip is auditable.
- **Orient stage (Stage 1)**: on session restore, if project_state is over threshold but not compacted, log a health-check finding (drift signal).
- **Close stage (Stage 6)**: optionally trigger one compaction before archive so the state is clean on exit.

## See Also

- [templates/project-state.md](templates/project-state.md) — the seven-section skeleton.
- [templates/phase-plan.md](templates/phase-plan.md) — the Ownership Table skeleton.
- [templates/task-packet.md](templates/task-packet.md) — Writable/Forbidden derived from the Ownership Table.
- [evidence-contract.md](evidence-contract.md) — how the Promise Registry's `verify_at` check is enforced.
- [archive-policy.md](archive-policy.md) — the closure conditions that include "registry risk sections processed."
