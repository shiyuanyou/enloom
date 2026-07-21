# Phase Plan: P2

## Phase Goal

Implement the accepted P1/P3 wording in exactly three Enloom source locations, without changing Evidence Contract semantics, lifecycle stages, or Clear-Mind coupling.

## Anti Goal

- No edit to `evidence-contract.md`, `workflow-steps.md`, archive, or Clear-Mind source.
- No automatic source/install sync by the worker; control owns it after source review.
- No requirement for every citation, every role, emergent work, or recon to use an Evidence Record.

## Constraints

- P1 applies only when `Role: researcher`, `Mode: audited`, and the packet explicitly declares material-finding locators.
- Facts use source locators; hypotheses identify dependent facts + reasoning; open questions name missing evidence or next check.
- P3 records actual inputs, deviations, modifications, and out-of-scope questions; it is self-attestation only.
- Compatibility preflight remains **yes** as recorded in P1.

## Strategy

serial

## Ownership Table

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| `enloom-skill/prompt-assets/researcher.md` | parallel-write zone | T002 coder | Execute |
| `enloom-skill/references/templates/task-packet.md` | parallel-write zone | T002 coder | Execute |
| `enloom-skill/references/templates/worker-report.md` | parallel-write zone | T002 coder | Execute |
| `runs/T002-P1-P3-PATCH/output.md`, `report.md` | parallel-write zone | T002 coder | Execute |
| installed copy, project state, decisions, task board, review-result, archive | serial-integration zone | control agent | Verify / Integrate |
| Clear-Mind artifacts, audit report, archive, other source files | read-only zone | no one | All |

## Reference Tolerance Decision Table

| Reference type in this phase | Tolerates dangling? | Handling | Forces serial? |
|------------------------------|---------------------|----------|----------------|
| relative Markdown references | yes | run structural validation / link checks | no |
| source/install parity | no | control sync after source acceptance | yes |

**Decision**: source edits have disjoint files but run serially; no forward declarations.

## Promise Registry Draft

Not needed.

## Tasks

- T002-P1-P3-PATCH: implement exactly the three accepted additions and run packet-declared static checks.

## Review Plan

Control verifies diff scope, checks that critical phrases and ownership boundaries are present, runs whitespace/reference validation, then applies the Evidence Contract verdict.

## Human Decisions Needed

- recon decision: no — P1 audit already mapped the bounded source surface.

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes
- Parallel ownership is defined if needed: not-needed
- Promise Registry drafted if forward declarations exist: not-needed
- recon considered: yes
- Landing gate confirmed: this phase-plan is written to `tasks/phase-plan-P2.md`: yes
