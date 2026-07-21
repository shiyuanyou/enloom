# Phase Plan: P3

## Phase Goal

Dogfood the new P1/P3 protocol on a real, bounded, read-only audited researcher task and decide whether it is usable without citation theatre or semantic confusion.

## Anti Goal

- Do not modify source, installed copies, state, archive, Clear-Mind, or target project material.
- Do not treat one sample as proof of cross-domain generalization, runtime isolation, or a universal locator requirement.

## Constraints

- Packet role is `researcher`, mode is `audited`, and `Evidence Required` explicitly asks material-finding locators; this is the only condition under which P1 should fire.
- Worker must use the installed researcher asset that was synchronized from source.
- Source baseline SHA-256 values before dispatch: researcher `1f1f470cac6e2e06b54c1c8a9d40ad415d79eb01ac9c742040dfb18a207e1298`; task-packet `7c558642047becded9e5597e37315d2a3885fdd7adb30b2c3d280b1e80052329`; worker-report `ce5929c1cd55166c89e0d4116fe57345f6d95a713b7021f81b63fd752dde418e`.

## Strategy

serial

## Ownership Table

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| `runs/T003-DOGFOOD-READONLY/output.md`, `report.md` | parallel-write zone | T003 researcher | Execute |
| installed/source skill files, project state, decisions, task board, review-result, archive | serial-integration zone | control agent | Verify / Integrate |
| Clear-Mind artifacts, T001/T002 reports, input source files | read-only zone | no one | All |

## Reference Tolerance Decision Table

| Reference type in this phase | Tolerates dangling? | Handling | Forces serial? |
|------------------------------|---------------------|----------|----------------|
| local source locators | no | control resolves each locator sample at Verify | yes |
| report/output artifact paths | no | must exist before review | yes |

**Decision**: serial; no forward declarations.

## Promise Registry Draft

Not needed.

## Tasks

- T003-DOGFOOD-READONLY: investigate whether the three P1/P3 additions preserve current Enloom contract boundaries; write a locator-backed Evidence Record and Boundary Check.

## Review Plan

Control samples every material finding locator, confirms type separation and Boundary Check semantics, compares post-run source checksums to baseline, and decides whether P1 remains an audited-researcher default.

## Human Decisions Needed

- recon decision: no — the audited research scope is deliberately 5 current source files and a bounded question.

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes
- Parallel ownership is defined if needed: not-needed
- Promise Registry drafted if forward declarations exist: not-needed
- recon considered: yes
- Landing gate confirmed: this phase-plan is written to `tasks/phase-plan-P3.md`: yes
