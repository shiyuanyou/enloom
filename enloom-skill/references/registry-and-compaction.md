# Registry, Ownership, Promise, and Compaction

State governance, in one place. These four mechanisms all answer the same question — how does the control agent keep `project_state.md` a live, recoverable truth instead of a write-only log that balloons until it is unreadable. They share one reference because they share one subject.

The core insight from a real large-scale task: state that records only "what was completed" leaves systematic gaps. What actually lets you recover a project is the **list of unclosed risks**. The Registry is that list. Ownership, Promise, and Compaction are the disciplines that keep it honest.

## 1. Registry — Seven Sections

The Registry is a fixed structure of `project_state.md`, not a separate file. Seven sections, in this order:

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

`## Rejected Reports` is new to v0.3: failure reports leave an index so the same failed path is not retried blindly.

### Update Discipline

The Registry is only useful if it is actually updated. Three lifecycle obligations:

- **Verify stage (Stage 4)**: after review, the control agent **must** log discovered problems into the matching section (broken reference, accepted-with-risk, rejected). This is what turns the registry from write-only to live.
- **Integrate stage (Stage 5)**: registry update is a precondition for archive (law 5 extended). No archive while open risks are unprocessed.
- **Orient stage (Stage 1)**: the control agent **must scan the four risk sections** on reading project_state — Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports. This is the landing point of "the main agent can be thin but never blind." A thin orchestrator's value is holding the global invariants.

### Interaction with Compaction

The Registry is the live part of project_state. At compaction, Registry sections are preserved first; an item is only moved to archive when it is marked resolved/closed. The unclosed-risk list is always the current truth.

## 2. Ownership Table — Three Tiers

Parallel safety rests on file ownership. The lesson: parallel work is not a strategy, it is an exception optimization that becomes possible once ownership is explicit. The universal root is "globally unique mutable state cannot be parallelized."

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

The serial-integration zone exists on the premise that "global state cannot be append-only parallel." If a task's global state can be designed as an append-only log (conflict-free merge), the integration zone could in theory parallelize — but v0.3 conservatively **defaults the serial-integration zone to single-threaded** unless the Plan stage explicitly argues it can parallelize. This holds the "parallel is the exception" law.

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

### Degradation Mechanism

Not all storage tolerates dangling references:

- **Storage tolerates dangling references** (e.g. wiki / filesystem dangling links) → write the reference first, verify fulfillment at the end. Promise mechanism + parallel allowed.
- **Storage does not tolerate** (e.g. code imports, strongly-typed symbols) → the promise mechanism cannot be used; the relevant tasks are forced serial (worker B must finish before worker A can reference).

The Plan stage decides "does this task's reference layer tolerate dangling references" — only if it does may promise + parallel be used. This makes the Obsidian constraint (which was implicit in the original task) an explicit, general decision point.

## 4. Compaction Protocol

### Problem

State documents bloat. "Compress into state" without compaction discipline just moves context bloat from the chat into the document. v0.2 had a compaction *concept* (<200 lines triggers) but no *protocol* — when to trigger, what to compress, where it goes, how to guarantee no unclosed risk is lost.

### Core Principle

**Compress resolved process detail. Never compress unclosed risk.** This is the direct interface with the Registry: the seven sections are the live truth, preserved first at compaction; an item only leaves when marked resolved/closed.

### Trigger Conditions (any one)

- `project_state.md` exceeds ~200 lines.
- The project_state `## Accepted Results` section crosses a threshold (e.g. 10 archived results) — note this is a top-level section, not one of the Registry seven.
- A new session's Orient cannot read project_state in ~3 minutes (a subjective but important signal).

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

- **Integrate stage (Stage 5)**: after every integrate, **check the trigger conditions**. If met, run compaction within the stage (it need not be its own stage).
- **Orient stage (Stage 1)**: on session restore, if project_state is over threshold but not compacted, log a health-check finding (drift signal).
- **Close stage (Stage 6)**: optionally trigger one compaction before archive so the state is clean on exit.

## See Also

- [templates/project-state.md](templates/project-state.md) — the seven-section skeleton.
- [templates/phase-plan.md](templates/phase-plan.md) — the Ownership Table skeleton.
- [templates/task-packet.md](templates/task-packet.md) — Writable/Forbidden derived from the Ownership Table.
- [evidence-contract.md](evidence-contract.md) — how the Promise Registry's `verify_at` check is enforced.
- [archive-policy.md](archive-policy.md) — the closure conditions that include "registry risk sections processed."
- [examples/art-lab-worked-example.md](examples/art-lab-worked-example.md) — how the Ownership Table and Promise Registry filled in on a real task.
