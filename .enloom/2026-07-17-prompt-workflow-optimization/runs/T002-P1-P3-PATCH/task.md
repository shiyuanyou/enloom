# Task Packet: T002-P1-P3-PATCH

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Implement the accepted P1/P3 patch in exactly these source files: researcher asset, task-packet template, and worker-report template.

## Anti Goal

- Do not modify installed copies, Evidence Contract, lifecycle/workflow docs, Clear-Mind, project state, decisions, task board, archive, or any other source file.
- Do not restate the existing fact/hypothesis/open-question taxonomy.
- Do not make Boundary Check a proof of runtime isolation, independent verification, or a stronger PASS.

## Inputs

- `runs/T001-PATCH-AUDIT/{output,report,review-result}.md`
- `tasks/phase-plan-P2.md`
- `enloom-skill/prompt-assets/researcher.md`
- `enloom-skill/references/templates/{task-packet,worker-report}.md`
- `enloom-skill/references/{prompt-control,evidence-contract,validation}.md`

## Existing State

P1 audit is `PASS / accepted`; source and installed copies were identical before this task. The source patch is not yet applied.

## Allowed Tools

Read, rg, git diff, and `apply_patch`; run only the Required Verification commands.

## Writable Files

- `enloom-skill/prompt-assets/researcher.md`
- `enloom-skill/references/templates/task-packet.md`
- `enloom-skill/references/templates/worker-report.md`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T002-P1-P3-PATCH/output.md`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T002-P1-P3-PATCH/report.md`

## Forbidden Files

- `~/.agents/skills/enloom/**`, `../clear-mind/**`, `design/**`, `.clear-mind/**`, `/Users/bigo/bigo-projects/mediascripts/**`
- `enloom-skill/references/{evidence-contract,workflow-steps}.md`
- `.enloom/task_board.md`, this project's `project_state.md`, `decisions.md`, `tasks/**`, `archive/**`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T002-P1-P3-PATCH/review-result.md`

## Output Files

Worker Output Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T002-P1-P3-PATCH/output.md`
Worker Report Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T002-P1-P3-PATCH/report.md`
Control Review Result Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T002-P1-P3-PATCH/review-result.md`

## Acceptance Criteria

1. Researcher asset says the Evidence Record applies only to an `audited` `researcher` packet that explicitly requires material-finding locators; it refers to existing epistemic discipline rather than restating it.
2. Task-packet Evidence Required helper lets control declare locator granularity and contains the fact/hypothesis/open-question locator distinctions.
3. Worker report adds Boundary Check after Files Changed with actual inputs, deviations/reasons, modifications, and out-of-scope questions; it explicitly says self-attestation is not proof.
4. No other source file changes; no change to Evidence Contract field semantics or sibling review-result ownership.

## Required Verification

- `V1`: `git diff --check -- enloom-skill/prompt-assets/researcher.md enloom-skill/references/templates/task-packet.md enloom-skill/references/templates/worker-report.md` exits 0.
- `V2`: `git diff --name-only --` lists exactly the three writable source files plus this task's output/report artifacts.
- `V3`: `rg -n 'material finding|Boundary Check|self-attestation|not proof'` over the three source files finds all four concepts in their intended locations.
- `V4`: inspect the diff and confirm no `evidence-contract.md`, `workflow-steps.md`, or `review-result.md` ownership semantics changed.

Countable outputs:

- Changed Enloom source files: 3.
- New named source sections/requirements: 3.

## Evidence Required

Report V1–V4 with command output or exact path/line citations. State the count reconciliation for the 3 changed source files and 3 additions. Treat Boundary Check as a worker declaration, never executable isolation evidence.

## Review Budget

Control can review `report.md` and the 3-file diff in under 5 minutes; `output.md` holds detailed patch notes only.

## Pending / Promise Registry Updates

None.

## Human Decision Gate

No additional user decision. A control accepted review authorizes source/install synchronization and the next dogfood phase.

## Done Signal

Return `done`, `blocked`, or `failed` with a short reason and paths to produced outputs.
