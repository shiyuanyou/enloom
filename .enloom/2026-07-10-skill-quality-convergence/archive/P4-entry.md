# Archive Entry: P4 — Namespace / Validation / 机械链接

## Completed

P4 made namespace deterministic (C10 two-root resolver), validation honest (C11 V01/V02 enum with promise boundary), and fixed mechanical link defects (C13). C13 owner moved from AGENTS.md to validation.md.

## Outputs

- `templates/task-board.md` — C10 two-root resolver algorithm; RA4 error enum references; reopen semantics; removed unconditional active-root cd. (29 → 60 lines)
- `validation.md` — C11 V01 (5-enum) + V02 (3-enum) promise boundary; flat fallback returns UNSUPPORTED not INVALID; C13 §Markdown Reference Integrity owner. (92 → 146 lines)
- 2 C13 mechanical fixes: worker-report `[Registry §1](...)` + task-packet `[Ownership Table §2](...)`.
- 4 consumers: workflow-steps, SKILL, glossary, AGENTS aligned for C10/C13.
- Source/installed parity verified.

## Evidence

- T-P4-01: V01–V07 all pass; V01 = 5 enums, V02 = 3 enums; C13 defect regex 0 on owners.
- T-P4-02: V01–V03 all pass; C13 defect regex 0 across ALL templates; C10 resolver in 2 consumers.

## State

- P4 accepted; project_state + Registry updated.

## Registry

Broken References section: C13 defects (2 `§` in targets) now resolved.

## Next Step

P5 — 命名/兼容性/安装 (C05 + C12 + C14).
