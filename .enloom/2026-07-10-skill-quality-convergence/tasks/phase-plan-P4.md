# Phase Plan: P4 — Namespace / Validation / 机械链接

## Phase Goal

使 namespace 可定位（C10 task-board.md 两根 resolver）、validation 承诺与实现一致（C11 validation paths）、机械链接修复（C13 两处 §写入 target）。同时落实 C13 owner 从 AGENTS.md 移到 validation.md。

## Anti-Goal

- 不改 Evidence/lifecycle/ownership 语义（P1/P2/P3）。
- 不改 description/trigger 措辞（P5）。
- C05 广泛命名清理留 P5。

## Strategy

Serial（owners → consumers）。T-P4-01 写 3 owner；T-P4-02 修 2 处机械链接 + consumer 对齐。

## Ownership Table

| File | Owner Task | Tier |
|------|-----------|------|
| `references/templates/task-board.md` | T-P4-01 | serial-write (C10 resolver) |
| `references/validation.md` | T-P4-01 | serial-write (C11 + C13 owner) |
| `references/templates/worker-report.md` | T-P4-02 | serial-write (C13 mechanical fix) |
| `references/templates/task-packet.md` | T-P4-02 | serial-write (C13 mechanical fix) |
| `references/workflow-steps.md` | T-P4-02 | serial-write (resolver consumer) |
| `SKILL.md` | T-P4-02 | serial-write (File Protocol consumer) |
| `references/glossary.md` | T-P4-02 | serial-write (namespace terms) |
| `AGENTS.md` | T-P4-02 | serial-write (C13 style consumer) |

## Tasks

### T-P4-01 — Owner rewrite: task-board.md (C10) + validation.md (C11+C13)
- **Mode**: audited
- **Writable**: `references/templates/task-board.md`, `references/validation.md`
- **Forbidden**: all other files

### T-P4-02 — Mechanical fix + consumer alignment
- **Mode**: audited
- **Writable**: `references/templates/worker-report.md`, `references/templates/task-packet.md`, `references/workflow-steps.md`, `SKILL.md`, `references/glossary.md`, `AGENTS.md`
- **Forbidden**: task-board.md, validation.md (locked by T-P4-01)

## Exit Gate (Phase)

- C10 resolver: 两根算法（`.enloom/<dir>` + `.enloom/archive/<dir>`）+ RA4 error enum + reopen/fold 规则在 task-board.md
- C11: V01 5-enum + V02 3-enum 在 validation.md；flat fallback 明确 UNSUPPORTED
- C13: `rg '\]\([^)]*\.md §[0-9]+\)' enloom-skill/references/templates` = 0
- `diff -qr` 一致

## Human Decisions Needed

无。
