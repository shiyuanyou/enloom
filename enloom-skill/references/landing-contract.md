# Landing Contract — 落盘时序契约

State governance lives in [registry-and-compaction.md](registry-and-compaction.md); evidence in [evidence-contract.md](evidence-contract.md). This reference is the **landing discipline** — the third leg of state governance: *when*, *by whom*, a workflow artifact must exist on disk. Templates exist (task-packet / worker-report have complete fields) and the Stage 0 Triage + six-stage lifecycle (Stages 1–6) names the stages, but without an explicit rule for which file gets written at which stage boundary, an agent could "complete" the whole six-stage lifecycle (Stages 1–6, after Stage 0 Triage) touching the disk zero times. The Landing Contract closes that gap by making every stage crossing a **file-existence gate**.

> **铁则**：worker 的产出和报告必须落盘成文件，不能只留在对话上下文。dispatch 不是「把任务说给 worker 听」，是「把 `task.md` 路径交给 worker，worker 写 `output.md` / `report.md`」。这是闸门表能成立的物理前提。

## 1. Gate Table — every stage's entry/exit mechanical check

A gate is a **file-existence check** — mechanical, verifiable, no judgment. The control agent self-checks at stage entry; health-check acts as a hard gate at stage transition (double insurance — see §4). Stages follow [workflow-steps.md](workflow-steps.md). The model is Stage 0 Triage + six-stage lifecycle (Stages 1–6).

| Stage | Entry gate (must hold before entering) | Exit gate (must hold before leaving) |
|---|---|---|
| **0 Triage** | — | triage result decided. (`direct` / `light-plan` exit Enloom entirely; only `enloom` proceeds below.) Triage is side-effect-free — no files, no dispatch, no moves. |
| **1 Orient** | `task_board.md` exists (create on first use) | 5–10 line state summary written into project_state's Current Phase (or confirmed unnecessary) |
| **2 Plan** | project located — `<created>-<project>/` directory exists | `tasks/phase-plan-<phase>.md` exists; phase goal is clear (gate check passes) |
| **3 Execute** (per task) | **accepted phase plan present** (`tasks/phase-plan-<phase>.md`) | **`runs/<TASK>/output.md` exists** + **`runs/<TASK>/report.md` exists** + report has a Result section (done/blocked/failed) |
| **4 Verify** | `runs/<TASK>/report.md` exists with Evidence Contract four elements | Review Result exists (currently the `report.md` Review Result section; will become `review-result.md` in P3) with verdict + conclusion |
| **5 Integrate** | every task of this phase has its Review Result filled | `project_state.md` + Registry updated; **compaction run or threshold not met** (exceeding a threshold *forces* compaction before exit; a non-triggered skip must be recorded as a one-liner) |
| **6 Close** | Integrate exit gates all pass | `archive/<phase>-entry.md` exists; old `runs/` content archived or declared discarded |

**Stage 3 pre-dispatch sub-gate (Law 2).** Admission to Stage 3 requires the accepted phase plan, never the packet — requiring the packet at admission would be circular, because `task.md` is created BY `make-prompt` inside the stage. The Law 2 pre-dispatch gate checks that `runs/<TASK>/task.md` exists only after `make-prompt` writes it. Order: phase plan present (admission) → `make-prompt` writes the packet → Law 2 checks the packet (pre-dispatch) → dispatch.

All paths are project-relative: `.enloom/<project>/runs/<TASK>/...` — see [File Protocol](../SKILL.md) for the namespace layer.

**Execution rule (double insurance):**

- **Control self-check** — the control agent runs an existence check at each stage entry, and at the Stage 3 pre-dispatch sub-gate. Missing → fill the gap at the responsible action; never skip over.
- **health-check hard gate** — at stage transition, health-check must run and verify the previous stage's exit-gate files. Failure → report a drift finding (Law violation signal). The control agent must close the gap before entering the next stage. See §4.

## 2. Handshake Sequence — control ↔ worker, every step is a disk write

The full lifecycle of `<TASK>`, ordered by disk operations. Every arrow is a file write/ read on disk — never a context-only handoff.

```
control agent                worker                disk (.enloom/<project>/)
    |                           |                          |
    |--[Stage 2 Plan] write tasks/phase-plan-<phase>.md--->|
    |                           |                          |
    |--[Stage 3 entry gate] check phase plan present ----->|
    |   missing → back to Plan; present → continue          |
    |                           |                          |
    |--- make-prompt: write runs/<TASK>/task.md ---------->|  ← packet lands
    |                           |                          |
    |--[pre-dispatch gate] check runs/<TASK>/task.md ----->|  ← Law 2 lands here
    |   missing → no dispatch (re-run make-prompt)         |
    |                           |                          |
    |--- dispatch: hand worker the path to task.md ------->|
    |                           |--- read task.md -------->|
    |                           |--- execute (read Inputs)>|
    |                           |--- write runs/<TASK>/output.md -->|  ← output lands
    |                           |--- write runs/<TASK>/report.md --->|  ← report lands
    |                           |    (Result / Evidence / Not Checked / Blind Spots)
    |<-- done/blocked/failed ----|                          |
    |                           |                          |
    |--[Stage 3 exit gate] check output.md + report.md --->|
    |   + report has Result section → pass; missing → back to worker
    |                           |                          |
    |--[Stage 4 Verify: see §Verify-Worker Handshake] ---->|
    |                           |                          |
    |--[Stage 5] update project_state.md + Registry ----->|
    |                           |                          |
    |--[Stage 6] write archive/<phase>-entry.md ---------->|
    |--- archive/declare-discard runs/<TASK>/ content ---->|
```

**The physical premise:** dispatch hands the worker a *path* to `task.md`, not a verbal task description. The worker's deliverable is `output.md` + `report.md` on disk, not a chat reply. A worker that returns "done" without those files has not completed — the Stage 3 exit gate fails and the control agent routes it back.

**Non-circular admission (C03).** `task.md` is created by `make-prompt`, which is the first Stage 3 control action. Admission to Stage 3 checks the accepted phase plan, NOT `task.md`; the Law 2 pre-dispatch gate checks the packet only after `make-prompt` has written it. No worker may run before its on-disk packet exists, and no gate reads a file before its creator action has run.

**Dispatch content vs. path — an implementation detail, not a gate question.** Handing the worker the `task.md` *path* is the Law 2 gate requirement: the durable artifact must exist on disk before dispatch (the pre-dispatch gate checks `runs/<TASK>/task.md` after `make-prompt`), so the contract survives a session crash and a later Verify can re-read it. *How the worker obtains the packet's content* is below the gate: a sub-agent runtime that re-reads the file from the path satisfies Law 2, and so does a front-stage dispatch that embeds the packet content into the worker's prompt — provided the on-disk `task.md` already exists in both cases. The gate cares about the durable artifact surviving; the delivery channel (path-read vs. prompt-embedded) is free to vary. Either way the packet is the contract, and `output.md` / `report.md` must still land on disk to satisfy the exit gate.

## 3. Law 2 / Law 5 mechanization (aligned with Law 4)

Law 4 (Evidence Contract) is already mechanized: control MUST apply the **Verdict Decision Function** in [evidence-contract.md §Verdict Decision Function](evidence-contract.md) — a total, ordered decision function over normalized status tuples, not a two-condition `iff`. Laws 2 and 5 are raised to the same mechanical standard — each is a file-existence gate, not a statement of intent.

| Law | Statement (intent) | Mechanized (gate) |
|---|---|---|
| **Law 2** — no Worker without Task Packet | stated | **Pre-dispatch gate (after `make-prompt`): `runs/<TASK>/task.md` must exist.** `make-prompt` writes the packet first; only then does Law 2 check it and permit dispatch. Control self-check + health-check double-verify. Missing → no dispatch; re-run `make-prompt` (this is NOT a Plan fallback — the phase plan already passed the entry gate). |
| **Law 5** — no Archive without State Update | stated (extended: registry processed) | **Pre-archive gate: every task's Review Result is filled + project_state/Registry updated.** health-check hard-verifies. Missing → no archive. |

The Five Laws become uniformly mechanical: Law 2 governs dispatch (a pre-dispatch sub-gate inside Stage 3), Law 4 governs acceptance, Law 5 governs archive entry — each a file-existence gate, not a hope.

## 4. health-check — two axes: periodic homes + transition executor (C06)

`health-check` operates on two distinct axes. They are NOT the same thing, and conflating them is the bug this section removes.

**Axis 1 — Periodic homes (full tier).** Full drift scans live in two fixed homes: Stage 1 Orient (entry) and periodic Stage 4 Verify (when a drift scan is due). These run the full nine-item scan. A periodic home is where comprehensive drift detection happens; it is NOT the complete set of transition execution points.

**Axis 2 — Transition executor (light tier).** Control invokes a light health-check at each of the five stage boundaries of the six-stage lifecycle (Stages 1–6): `1→2`, `2→3`, `3→4`, `4→5`, `5→6`. Each transition check verifies only the previous stage's exit-gate files — a one/two-line mechanical confirmation (e.g. `ls runs/<TASK>/task.md`, `ls runs/<TASK>/output.md`), emitting a single-line "Gates OK" on pass. It does *not* expand the full nine-item scan at every transition. The procedure reports; control repairs.

| Axis | Tier | When | Invoker | Scope |
|---|---|---|---|---|
| Periodic homes | full | Orient entry; periodic Verify (when due) | health-check home | full nine-item scan |
| Transition executor | light | `1→2`, `2→3`, `3→4`, `4→5`, `5→6` | control (at each boundary) | only that transition's exit-gate files |

- It reports findings; it does not auto-fix (control agent fills the gap).
- A drift finding is a Law violation signal — the control agent must resolve it before advancing.

This is the second insurance layer: even if the control agent forgets to self-check, health-check catches the missing file at the boundary. Two independent checks (self-check + health-check) make a skipped landing far harder than either alone. The light tier keeps this insurance while respecting the attention budget — 95% of transitions only need the existence check. First-use Orient (no pre-existing project state) runs the minimal full-scan behavior for that case; this does NOT invent a Stage 0 file gate.

## Verify-Worker Handshake — non-recursive V0→V3 termination (RA2)

A `VERIFY_WORKER` (reviewer or audit) is a named Stage 4 sub-state — not Stage 3, and not a return to Plan. Control owns every transition and is the normative finalizer, not an exception. The same `make-prompt → task.md exists → dispatch` mini-handshake runs inside Verify, never at Stage 3 entry.

| State | Entry | Control/worker action | Single next state |
|---|---|---|---|
| **`V0_TARGET_READY`** | target `output.md` + four-field `report.md` exist | If no independent verification is required, control evaluates the target directly. Otherwise control writes the verifier/audit `task.md` inside Stage 4 (via `make-prompt`). Packet-write failure stays V0 and blocks. | direct `V3_CONTROL_FINALIZED`, or `V1_VERIFY_PACKET_READY` |
| **`V1_VERIFY_PACKET_READY`** | verifier/audit `task.md` exists | Law 2 pre-dispatch gate checks that exact file; dispatch writes the verifier/audit `output.md` + `report.md`. Missing worker artifacts stay V1 / rework the same run; MUST NOT return to Plan. | `V2_VERIFY_RUN_LANDED` |
| **`V2_VERIFY_RUN_LANDED`** | verifier/audit `output.md` + `report.md` exist | Control directly evaluates this run and writes its Review Result, then evaluates the target using the proposal/evidence and writes the target Review Result. Insufficient verifier evidence yields a control-authored FAIL — it MUST NOT dispatch a reviewer-of-review. | `V3_CONTROL_FINALIZED` |
| **`V3_CONTROL_FINALIZED`** | target Review Result exists AND every Verify-worker run has its own Review Result | Stage 4 exit gate runs. | Stage 5, or blocked on an explicit result |

**Invariants (non-recursion).**

- **Zero Plan edges:** no Verify-worker state transitions back to Stage 2 Plan.
- **Zero reviewer-of-review edges:** insufficient verifier evidence produces a control-authored FAIL, never another reviewer.
- **Max 3 forward transitions:** V0→V1→V2→V3; direct control review reaches V3 in one transition.
- Control direct finalization is the normal Stage 4 terminal transition for execution, reviewer, and audit runs; no run creates an obligation for another reviewer.

Pure audit uses the same V0→V1→V2→V3 path; its packet MUST declare worker-owned output/report paths and the separate control result path.

Verification: trace (a) direct control review, (b) one reviewer, (c) one pure audit from empty verifier directories. PASS: packet precedes each dispatch; each trace reaches V3 in at most three forward transitions; zero Plan edges and zero reviewer-of-review edges. FAIL: any verifier report creates another Verify-worker requirement, or any context-only return satisfies a gate.

## 5. Sub-agent requirement

Stage 3 dispatch hands the worker a path to `task.md`; the worker is an **independent sub-agent** that writes `output.md` / `report.md` to disk. If the runtime cannot dispatch a sub-agent, Enloom **halts** — it does not degrade to the control agent executing the task itself. The control agent's job is orchestration (triage / orient / plan / review / integrate / archive) and serial-integration writes, not worker execution. Halting is the honest failure: prompt contamination (main window absorbing worker context) is worse than not running.

When dispatch fails (no sub-agent runtime / tool error), the control agent surfaces the failure and suggests switching to a runtime with sub-agent support (opencode / pi / codex, etc.). There is no self-execution fallback.

## See Also

- [workflow-steps.md](workflow-steps.md) — each stage's gate is referenced from its entry/exit (P1-D wires this).
- [evidence-contract.md](evidence-contract.md) §Verdict Decision Function — Law 4, the total decision function Laws 2/5 now align with.
- [archive-policy.md](archive-policy.md) §Project Fold — fold timing and namespace resolver.
- [registry-and-compaction.md](registry-and-compaction.md) — state governance (Registry / Ownership / Compaction); landing is its on-disk enforcement layer.
- [templates/task-packet.md](templates/task-packet.md) / [templates/worker-report.md](templates/worker-report.md) — the artifacts the gates require to exist.
