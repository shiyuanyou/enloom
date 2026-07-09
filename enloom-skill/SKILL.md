---
name: enloom
description: Use this workflow skill for Enloom, complex multi-stage work, worker task packets, report-first review, project_state updates, archiving, context governance, or when a task may need multiple roles, cross-session state, explicit evidence, or controlled worker boundaries. Trigger it when the user asks to run Enloom, plan a long task, dispatch workers, review a worker report, audit evidence, archive a phase, or health-check workflow state. Do not use for simple direct Q&A, one-file edits, obvious bug fixes, tiny scripts, or tasks that can be completed cleanly without state, review, or workers.
---

# Enloom

Enloom is a methodology for orchestrating complex AI work — a lightweight control-plane workflow for tasks that are too large or stateful to keep in one undisciplined agent context. It enters only when the task benefits from phase goals, worker task packets, evidence-based review, state compression, and archive discipline.

The skill does not provide a scheduler, CLI, model resolver, or automatic worker runtime. It gives the agent a file protocol and decision discipline. If the task can be done directly, do it directly.

## First Move

1. Run `triage` (Stage 0) before creating files or dispatching workers.
2. If the result is `direct`, finish the user task normally and exit Enloom.
3. If the result is `light-plan`, give a short plan and do not create Enloom files.
4. If the result is `enloom`, enter the lifecycle: Orient (restore state) → Plan (the current phase) → Execute (dispatch workers) → Verify (accept on evidence) → Integrate (compress into state) → Close (archive and exit).

Plan only the current phase, never the whole project.

## Lifecycle

The work proceeds through six stages. Operations are sub-actions that belong to a stage, not a flat menu.

```
0. Triage    → direct / light-plan / enter lifecycle
1. Orient    → read project_state + Registry risk sections + latest report
2. Plan      → phase goal + Ownership Table + Promise Registry draft
3. Execute   → make task packet / dispatch / worker plays inside boundary
4. Verify    → review report + audit packet + Evidence Contract gate
5. Integrate → update project_state + Registry + compaction check
6. Close     → archive + closure check + user report
```

Read [references/workflow-steps.md](references/workflow-steps.md) for the full six-stage workflow, the five laws, and the gates at each stage.

### Stage sub-actions

| Sub-action | Stage | Purpose |
|---|---|---|
| `triage` | 0 | decide direct / light-plan / enloom |
| `plan` | 2 | define the current phase + Ownership Table |
| `make-prompt` | 3 Execute | build the task packet (contract) |
| `dispatch` | 3 Execute | run the worker inside the packet boundary |
| `review` | 4 Verify | accept every worker on evidence |
| `audit` | 4 Verify | periodic / pre-release verification (new) |
| `archive` | 6 Close | close the phase after state update |
| `health-check` | 1 Orient + 4 Verify | periodic drift / risk-section check |

health-check is no longer a top-level operation; it is a periodic trigger in Orient and Verify.

## The Five Laws

The laws constrain the lifecycle. v0.3 hardens laws 3–5:

1. **No Enloom without trigger.**
2. **No Worker without Task Packet.**
3. **No Parallel without Ownership Table.** (upgraded: three-tier model)
4. **No PASS without Evidence.** (mechanized: Evidence Contract hard constraint)
5. **No Archive without State Update.** (extended: Registry risk sections processed)

## References

Read these on demand — do not load them all into context at once:

- [references/workflow-steps.md](references/workflow-steps.md) — the full six-stage lifecycle and the five laws.
- [references/trigger-contract.md](references/trigger-contract.md) — when to enter Enloom, when to bypass, and how to handle ambiguous cases.
- [references/glossary.md](references/glossary.md) — fixed terminology; every reference and template uses these terms.
- [references/scheduler-rules.md](references/scheduler-rules.md) — serial is default; parallel is an exception requiring an Ownership Table (three-tier model).
- [references/evidence-contract.md](references/evidence-contract.md) — the four evidence elements, the "no PASS without evidence" hard constraint, the three-state verdict, and the v0.5 fifth dimension (Claim Consistency) + three honest blind spots.
- [references/prompt-control.md](references/prompt-control.md) — orchestration technique (route pre-fill, multi-layer dispatch distortion, script-execution pitfalls) — how to build a task packet that survives hand-off.
- [references/registry-and-compaction.md](references/registry-and-compaction.md) — Registry seven sections, Ownership Table, Promise Registry, and the Compaction Protocol (state governance in one place).
- [references/review-checklist.md](references/review-checklist.md) — the gate conditions for `accepted` / `needs-rework` / `rejected`.
- [references/archive-policy.md](references/archive-policy.md) — the mechanical closure conditions; no archive without state update.
- [references/landing-contract.md](references/landing-contract.md) — the stage gate table, control↔worker handshake, and health-check as the stage-transition gate (v0.5: light tier at transitions, full tier at Orient + Verify).
- [references/validation.md](references/validation.md) — language-neutral structural validation (bash / node / python, no PyYAML).
- [references/templates/](references/templates/) — the fill-in contracts (phase-plan, task-packet, audit-task-packet, worker-report, project-state, archive-entry).
- [references/examples/triage-decision-tree.md](references/examples/triage-decision-tree.md) — worked triage examples.
- [references/examples/art-lab-worked-example.md](references/examples/art-lab-worked-example.md) — how the generic structures fill in on a real large-scale task (reference, not main trunk).

## File Protocol

Recommended project-local layout. Enloom writes its working files under a **hidden `.enloom/` directory** so they stay out of the user's way by default. v0.4 organizes `.enloom/` as a **project-level namespace**: a single `task_board.md` entry table at the root, and one directory per project:

```text
.enloom/
  task_board.md                       # the single entry table — one row per project
  2026-06-29-<projectName>/           # a project directory; timestamp = creation date; name dedupes
    project_state.md                  # that project's truth (<200 lines) — includes Registry seven sections
    decisions.md
    tasks/
      phase-plan-<phase>.md
    runs/
      <TASK>/
        task.md
        output.md
        report.md
        raw-notes.md
    archive/
      <phase>-entry.md
    prompt-assets/
      researcher.md
      coder.md
      reviewer.md
```

`task_board.md` is the namespace entry point — the first thing Orient reads to locate the target project. Each project keeps its own `project_state.md`, Registry, tasks, runs, and archive; cross-project state is never co-mingled. A same-named project entered a second time **reuses** its existing directory (timestamp = creation date, fixed) and only updates the `updated` column — it does not create a new one.

For first use, create `.enloom/task_board.md` and the current project's directory (`<today>-<projectName>/`) with its `project_state.md`; add the rest (`tasks/`, `runs/`, `archive/`) as the current phase needs them.

## Landing Discipline

Templates and stages define *what* artifacts exist; the Landing Contract defines *when, by whom*, they must exist **on disk**. It exists because a real run left `tasks/` and `runs/` entirely empty while `project_state.md` claimed completed phases — every packet and report lived only in the agent's context and vanished at session end.

Two load-bearing rules:

- **Every stage crossing is a file-existence gate.** Entry/exit gates per stage are mechanical checks (e.g. Stage 3 entry: `runs/<TASK>/task.md` must exist; exit: `output.md` + `report.md` must exist). The control agent self-checks at each entry; health-check hard-verifies at each transition. Full table + control↔worker handshake sequence: [references/landing-contract.md](references/landing-contract.md).
- **Worker output must land as files, not chat replies.** Dispatch hands the worker a *path* to `task.md`; the worker writes `output.md` / `report.md` to disk. This mechanizes Law 2 (no dispatch before `task.md` exists) and Law 5 (no archive before every report's Review Result is filled), bringing them to the same standard Law 4 already held.
- **Compaction is a mandatory gate, not an optional check (v0.5).** At the Integrate exit, if a compaction trigger threshold is met, the Compaction Protocol *must* run before the stage passes — "check the trigger and defer" is no longer acceptable. This closes the loophole where an optional check lets the Registry balloon indefinitely. See [references/registry-and-compaction.md](references/registry-and-compaction.md) §4.

## Review Posture

Prefer report-first review. The control agent should keep worker context out of the main window unless evidence is missing or risk is high. Compress accepted conclusions into project state; do not paste raw process material back into long-term state. A thin orchestrator is valuable only if it holds the global invariants — so always scan the Registry risk sections on Orient.

## Manual Trial

Before promoting this skill globally, run the manual checks in [references/examples/manual-trial.md](references/examples/manual-trial.md). The acceptance target is practical behavior on real tasks, not an automated benchmark.
