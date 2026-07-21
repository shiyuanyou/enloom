# Task Packet: T001-PATCH-AUDIT

Task Packet Version: 0.2
Mode: audited
Role: researcher

## Goal

Independently audit the proposed Enloom P1/P3 changes. Determine the smallest exact wording and placement that makes audited researcher findings traceable and makes boundary deviations review-visible, without duplicating current contracts or changing semantics.

## Anti Goal

- Do not modify any skill, project state, archive, Clear-Mind source, or audit input.
- Do not propose a new lifecycle stage, top-level generic checklist, mandatory Clear-Mind gate, merged verdict vocabulary, or runtime-isolation claim.
- Do not treat dev-wiki history as a live Enloom contract.

## Inputs

- `.clear-mind/2026-07-17-prompt-workflow-optimization/{explore,plan,review}.md`
- `/Users/bigo/bigo-projects/mediascripts/.enloom/2026-07-17-prompt-workflow-quality-audit/final-report.md`
- `enloom-skill/prompt-assets/researcher.md`
- `enloom-skill/references/templates/{task-packet,worker-report}.md`
- `enloom-skill/references/{evidence-contract,prompt-control,workflow-steps}.md`

## Existing State

Source and installed Enloom copies were identical before this phase. P1/P3 have not been implemented.

## Allowed Tools

Read, rg, sed, and git read-only commands only.

## Writable Files

- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T001-PATCH-AUDIT/output.md`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T001-PATCH-AUDIT/report.md`

## Forbidden Files

- `enloom-skill/**`, `../clear-mind/**`, `design/**`, `.clear-mind/**`, and `/Users/bigo/bigo-projects/mediascripts/**`
- `.enloom/task_board.md`, this project's `project_state.md`, `decisions.md`, `tasks/**`, `archive/**`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T001-PATCH-AUDIT/review-result.md`

## Output Files

Worker Output Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T001-PATCH-AUDIT/output.md`
Worker Report Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T001-PATCH-AUDIT/report.md`
Control Review Result Path: `.enloom/2026-07-17-prompt-workflow-optimization/runs/T001-PATCH-AUDIT/review-result.md`

## Acceptance Criteria

1. Map each P1/P3 recommendation to an exact live source section and name any overlap risk.
2. Recommend exact placement and semantic constraints, including a mode-aware P1 trigger and the non-proof status of P3.
3. Produce an Evidence Record that gives a locator for each material finding, separating fact / hypothesis / open question.
4. Do not propose edits; this worker is read-only.

## Required Verification

- `V1`: read all six packet inputs; report an exact locator for each material finding.
- `V2`: verify P1 does not duplicate existing fact/hypothesis/open-question guidance.
- `V3`: verify P3 does not contradict current Files Changed, Known Blind Spots, or sibling review-result ownership.
- `V4`: confirm proposed scope excludes emergent/recon hard requirements and Clear-Mind source edits.

Countable outputs:

- Material findings: report exact count and enumerate them in `output.md`.
- Proposed Enloom edit locations: report exact count and enumerate them in `output.md`.

## Evidence Required

For every material finding, use `path + heading/line range`; for any hypothesis, name its dependent facts and reasoning. The P1 format being audited is not yet a global rule, but this audited task deliberately dogfoods it.

## Review Budget

Control should be able to review `report.md` first in under 5 minutes; open `output.md` only to verify locator or count discrepancies.

## Pending / Promise Registry Updates

None.

## Human Decision Gate

No user decision needed. A control `accepted` review authorizes the next source-patch phase; `issues` or `fail` blocks it.

## Done Signal

Return `done`, `blocked`, or `failed` with a short reason and paths to produced outputs.
