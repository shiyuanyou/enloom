# Landing Contract — 落盘时序契约

State governance lives in [registry-and-compaction.md](registry-and-compaction.md); evidence in [evidence-contract.md](evidence-contract.md). This reference is the **landing discipline** — the third leg of state governance: *when*, *by whom*, a workflow artifact must exist on disk. It exists because a real large-scale run left `tasks/` and `runs/` entirely empty while `project_state.md` claimed three completed phases — every packet, every worker report, every mid-run decision lived only in the agent's runtime context and vanished at session end.

The core failure: templates exist (task-packet / worker-report have complete fields), the lifecycle names the stages, but **nothing commanded which file gets written at which stage boundary**. An agent could "complete" all six stages touching the disk zero times. The Landing Contract closes that gap by making every stage crossing a **file-existence gate**.

> **铁则**：worker 的产出和报告必须落盘成文件，不能只留在对话上下文。dispatch 不是「把任务说给 worker 听」，是「把 `task.md` 路径交给 worker，worker 写 `output.md` / `report.md`」。这是闸门表能成立的物理前提。

## 1. Gate Table — every stage's entry/exit mechanical check

A gate is a **file-existence check** — mechanical, verifiable, no judgment. The control agent self-checks at stage entry; health-check acts as a hard gate at stage transition (double insurance — see §3). Stages follow [workflow-steps.md](workflow-steps.md).

| Stage | Entry gate (must hold before entering) | Exit gate (must hold before leaving) |
|---|---|---|
| **0 Triage** | — | triage result decided. (`direct` / `light-plan` exit Enloom entirely; only `enloom` proceeds below.) |
| **1 Orient** | `task_board.md` exists (create on first use) | 5–10 line state summary written into project_state's Current Phase (or confirmed unnecessary) |
| **2 Plan** | project located — `<created>-<project>/` directory exists | `tasks/phase-plan-<phase>.md` exists; phase goal is clear (gate check passes) |
| **3 Execute** (per task) | **`runs/<TASK>/task.md` exists** ← Law 2 gate | **`runs/<TASK>/output.md` exists** + **`runs/<TASK>/report.md` exists** + report has a Result section (done/blocked/failed) |
| **4 Verify** | `runs/<TASK>/report.md` exists with Evidence Contract four elements | `runs/<TASK>/report.md`'s Review Result section is filled (verdict + conclusion) |
| **5 Integrate** | every task of this phase has its report's Review Result section filled | `project_state.md` + Registry updated; **compaction run or threshold not met** (exceeding a threshold *forces* compaction before exit; a non-triggered skip must be recorded as a one-liner) |
| **6 Close** | Integrate exit gates all pass | `archive/<phase>-entry.md` exists; old `runs/` content archived or declared discarded |

All paths are project-relative: `.enloom/<project>/runs/<TASK>/...` — see [File Protocol](../SKILL.md) for the namespace layer.

**Execution rule (double insurance):**

- **Control self-check** — the control agent runs an existence check (`ls runs/<TASK>/task.md`) at each stage entry. Missing → fall back to the previous stage and fill the gap; never skip over.
- **health-check hard gate** — at stage transition, health-check must run and verify the previous stage's exit-gate files. Failure → report a drift finding (Law violation signal). The control agent must close the gap before entering the next stage. See §3.

## 2. Handshake Sequence — control ↔ worker, every step is a disk write

The full lifecycle of `<TASK>`, ordered by disk operations. Every arrow is a file write/ read on disk — never a context-only handoff.

```
control agent                worker                disk (.enloom/<project>/)
    |                           |                          |
    |--[Stage 2 Plan] write tasks/phase-plan-<phase>.md--->|
    |                           |                          |
    |--[Stage 3 entry gate] check runs/<TASK>/task.md ---->|
    |   missing → back to Plan; present → continue          |
    |                           |                          |
    |--- make-prompt: write runs/<TASK>/task.md ---------->|  ← Law 2 lands here
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
    |--[Stage 4 review] read report.md ------------------->|
    |--- write report.md's Review Result (verdict+concl) ->|  ← review lands
    |                           |                          |
    |--[Stage 5] update project_state.md + Registry ----->|
    |                           |                          |
    |--[Stage 6] write archive/<phase>-entry.md ---------->|
    |--- archive/declare-discard runs/<TASK>/ content ---->|
```

**The physical premise:** dispatch hands the worker a *path* to `task.md`, not a verbal task description. The worker's deliverable is `output.md` + `report.md` on disk, not a chat reply. A worker that returns "done" without those files has not completed — the Stage 3 exit gate fails and the control agent routes it back.

**Dispatch content vs. path — an implementation detail, not a gate question.** Handing the worker the `task.md` *path* is the Law 2 gate requirement: the durable artifact must exist on disk before dispatch (the entry gate checks `runs/<TASK>/task.md`), so the contract survives a session crash and a later Verify can re-read it. *How the worker obtains the packet's content* is below the gate: a sub-agent runtime that re-reads the file from the path satisfies Law 2, and so does a front-stage dispatch that embeds the packet content into the worker's prompt — provided the on-disk `task.md` already exists in both cases. The gate cares about the durable artifact surviving; the delivery channel (path-read vs. prompt-embedded) is free to vary. Either way the packet is the contract, and `output.md` / `report.md` must still land on disk to satisfy the exit gate.

## 3. Law 2 / Law 5 mechanization (aligned with Law 4)

Law 4 (Evidence Contract) is already mechanized: `verdict = PASS` **iff** all declared checks ran and evidence is non-empty. Laws 2 and 5 are raised to the same mechanical standard — each is a file-existence gate, not a statement of intent.

| Law | Statement (intent) | Mechanized (gate) |
|---|---|---|
| **Law 2** — no Worker without Task Packet | stated | **Pre-dispatch gate: `runs/<TASK>/task.md` must exist.** Control self-check + health-check double-verify. Missing → no dispatch; fall back to Plan. |
| **Law 5** — no Archive without State Update | stated (extended: registry processed) | **Pre-archive gate: every task's `report.md` Review Result section is filled + project_state/Registry updated.** health-check hard-verifies. Missing → no archive. |

The Five Laws become uniformly mechanical: Law 2 governs dispatch entry, Law 4 governs acceptance, Law 5 governs archive entry — each a file-existence gate, not a hope.

## 4. health-check as the stage-transition hard gate

`health-check` serves two roles: a periodic drift detector and the **stage-transition gate executor**. At every stage boundary, it verifies the previous stage's exit-gate files and reports drift findings on any gap.

- Run on Stage transition (1→2→3→4→5→6), not only periodically.
- **Light tier at transitions**: at a stage boundary, health-check runs **only the file-existence check for that transition's gate** — a one/two-line mechanical confirmation (e.g. `ls runs/<TASK>/task.md`), emitting a single-line "Gates OK" on pass. It does *not* expand the full nine-item scan at every transition. The full tier runs at Orient entry and periodic Verify drift checks (see [workflow-steps.md §Health Check](workflow-steps.md)). The hard-gate semantics are unchanged; only the execution cost drops.
- It reports findings; it does not auto-fix (control agent fills the gap).
- A drift finding is a Law violation signal — the control agent must resolve it before advancing.

This is the second insurance layer: even if the control agent forgets to self-check, health-check catches the missing file at the boundary. Two independent checks (self-check + health-check) make a skipped landing far harder than either alone. The light tier keeps this insurance while respecting the attention budget — 95% of transitions only need the existence check.

## 5. Sub-agent requirement

Stage 3 dispatch hands the worker a path to `task.md`; the worker is an **independent sub-agent** that writes `output.md` / `report.md` to disk. If the runtime cannot dispatch a sub-agent, Enloom **halts** — it does not degrade to the control agent executing the task itself. The control agent's job is orchestration (triage / orient / plan / review / integrate / archive) and serial-integration writes, not worker execution. Halting is the honest failure: prompt contamination (main window absorbing worker context) is worse than not running.

When dispatch fails (no sub-agent runtime / tool error), the control agent surfaces the failure and suggests switching to a runtime with sub-agent support (opencode / pi / codex, etc.). There is no self-execution fallback.

## See Also

- [workflow-steps.md](workflow-steps.md) — each stage's gate is referenced from its entry/exit (P1-D wires this).
- [evidence-contract.md](evidence-contract.md) — Law 4, the mechanization template Laws 2/5 now follow.
- [registry-and-compaction.md](registry-and-compaction.md) — state governance (Registry / Ownership / Compaction); landing is its on-disk enforcement layer.
- [templates/task-packet.md](templates/task-packet.md) / [templates/worker-report.md](templates/worker-report.md) — the artifacts the gates require to exist.
