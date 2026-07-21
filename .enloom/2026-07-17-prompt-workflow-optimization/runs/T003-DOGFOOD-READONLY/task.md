# Task Packet: T003-DOGFOOD-READONLY

Task Packet Version: 0.2
Mode: audited
Role: researcher

## Goal

Read the current Enloom source and determine whether the newly added P1/P3 rules preserve existing contract boundaries: P1 remains packet/mode/role-gated and P3 remains self-attestation separate from Evidence Contract fields and control ownership.

## Anti Goal

- Do not modify any source, installed copy, state, archive, Clear-Mind artifact, or external project.
- Do not decide broader adoption beyond this single dogfood sample.
- Do not report self-attestation as runtime isolation, permission enforcement, independent verification, or stronger PASS evidence.

## Inputs

- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/prompt-assets/researcher.md`
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/references/templates/task-packet.md`
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/references/templates/worker-report.md`
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/references/prompt-control.md`
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/references/evidence-contract.md`

## Existing State

The three P1/P3 source additions are installed. These SHA-256 baselines are frozen in this packet and must stay unchanged during this read-only task:

- `enloom-skill/prompt-assets/researcher.md`: `1f1f470cac6e2e06b54c1c8a9d40ad415d79eb01ac9c742040dfb18a207e1298`
- `enloom-skill/references/templates/task-packet.md`: `7c558642047becded9e5597e37315d2a3885fdd7adb30b2c3d280b1e80052329`
- `enloom-skill/references/templates/worker-report.md`: `ce5929c1cd55166c89e0d4116fe57345f6d95a713b7021f81b63fd752dde418e`

## Allowed Tools

Read, rg, sed, nl, shasum, and git read-only commands.

## Writable Files

- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/output.md`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/report.md`

## Forbidden Files

- `enloom-skill/**`, `~/.agents/skills/enloom/**`, `../clear-mind/**`, `design/**`, `.clear-mind/**`, `/Users/bigo/bigo-projects/mediascripts/**`
- `.enloom/task_board.md`, this project's `project_state.md`, `decisions.md`, `tasks/**`, `archive/**`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/review-result.md`

## Output Files

Worker Output Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/output.md`
Worker Report Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/report.md`
Control Review Result Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/review-result.md`

## Acceptance Criteria

1. `output.md` contains a compact Evidence Record with 3–5 material findings, each typed fact / hypothesis / open question and located by `path + heading/line range`.
2. The record demonstrates P1 is gated by `audited` + `researcher` + packet-declared locators, not a universal rule.
3. The report uses Boundary Check to declare actual inputs, deviations, modifications, and out-of-scope questions, and says it is self-attestation only.
4. The report preserves Checks Run / Evidence / Not Checked / Known Blind Spots semantics and does not touch the control-owned review result.
5. Source-file SHA-256 values match P3 baseline after the task.

## Required Verification

- `V1`: Evidence Record contains 3–5 material findings and each has the required type + locator form.
- `V2`: locate the three P1 gates in source and explain their joint effect.
- `V3`: locate Boundary Check and explain why it does not replace Evidence Contract or control ownership.
- `V4`: run SHA-256 on the three source files and compare to the P3 baseline.

Countable outputs:

- Material findings: 3–5.
- Source files modified by the worker: 0.

## Evidence Required

For fact use `path + heading/line range`; for hypothesis name dependent facts + reasoning; for open question name the missing evidence or next check. Keep only material findings. This packet intentionally activates P1.

## Review Budget

Control should be able to sample every Evidence Record locator and read the Boundary Check in under 5 minutes.

## Pending / Promise Registry Updates

None.

## Human Decision Gate

No additional user decision. The control review decides whether P1 remains the default for audited researcher packets or returns to packet opt-in.

## Done Signal

Return `done`, `blocked`, or `failed` with a short reason and paths to produced outputs.
