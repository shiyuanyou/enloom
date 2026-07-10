# Phase Plan: P5 — 命名 / 兼容性 / 安装

## Phase Goal

在行为契约稳定后（P1–P4 全部 accepted），对齐入口元数据与发布文案：C05 全量命名清理（"Stage 0 Triage + six-stage lifecycle"）、C12 兼容性 preflight（SKILL.md 明示 full Enloom 需独立 sub-agent + 在任何 .enloom write 前 preflight）、C14 Install 文档（可执行安装命令 + parity check）。F-D7-02 trigger 证据不足 → description 不改。

## Anti-Goal

- 不改 Evidence/lifecycle/ownership/namespace 语义（P1–P4）。
- 不改 `description` 字段（F-D7-02 trigger 证据不足；P0 契约明确 description 编辑需先有 host-native trigger evidence）。
- 不碰 C05 phrase guard 已在 P2 落地的新增句子——P5 做全量清理。

## Constraints

- description 不动（F-D7-02 = deferred-evidence）。
- C12 preflight timing：Triage 返回 enloom 后、任何 .enloom 写入前。
- C14：Install 段必须有可执行命令 + parity check。当前 install 段是 comment-only block（README line 74-76）。

## Strategy

Serial（T-P5-01 写 3 owner；T-P5-02 consumer 对齐）。

## Ownership Table

| File | Owner Task | Tier |
|------|-----------|------|
| `references/workflow-steps.md` | T-P5-01 | serial-write (C05 broad naming cleanup) |
| `SKILL.md` | T-P5-01 | serial-write (C12 compatibility preflight) |
| `README.md` | T-P5-01 | serial-write (C14 install) |
| `references/glossary.md` | T-P5-02 | serial-write (C05 consumer) |
| `references/trigger-contract.md` | T-P5-02 | serial-write (C12 consumer) |
| `PROGRESS.md` | T-P5-02 | serial-write (C05/C14 consumer) |
| `references/review-checklist.md` | T-P5-02 | serial-write (C12 consumer) |

## Tasks

### T-P5-01 — Owner rewrite: workflow-steps (C05) + SKILL (C12) + README (C14)
- **Mode**: audited
- **Role**: coder
- **Writable**: `references/workflow-steps.md`, `SKILL.md`, `README.md`
- **Forbidden**: all other files

### T-P5-02 — Consumer alignment: glossary + trigger-contract + PROGRESS + review-checklist
- **Mode**: audited
- **Role**: coder
- **Writable**: `references/glossary.md`, `references/trigger-contract.md`, `PROGRESS.md`, `references/review-checklist.md`
- **Forbidden**: workflow-steps.md, SKILL.md, README.md (locked by T-P5-01)

## Exit Gate (Phase)

- C05: one-plus-six 术语在全仓库一致（不出现未限定的 "six stages / 六阶段" 指代七行 walkthrough）
- C12: SKILL.md compatibility metadata/prose 明示 full Enloom 需独立 sub-agent + preflight timing
- C14: README Install 段有可执行命令 + parity check（不是 comment-only block）
- F-D7-02: description 未改（证据不足）
- `diff -qr` 一致

## Human Decisions Needed

- F-D7-02 trigger 证据：当前无 host-native positive/near-miss trigger evidence，因此 description 不改。P6 dogfood 可收集行为证据。
