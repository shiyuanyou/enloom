# Phase Plan: P3 — Ownership / Runtime / Role-Asset 冻结

## Phase Goal

冻结 durable ownership（C07/RA3 file-level artifact split：report.md 全归 worker，review-result.md 全归 control）、runtime capability 独立记录（C08：4 维度 + hard/soft unknown policy）、role-to-asset 路由（C09：5 角色确定性加载表）。

## Anti-Goal

- 不改 Evidence Contract 语义（P1）。
- 不改 lifecycle/dispatch/fold 结构（P2）。
- 不改 description/trigger 措辞（P5）。
- 不碰 namespace resolver 的 task-board.md 模板（P4）。
- C05 广泛命名清理留 P5。

## Strategy

Serial（owners → consumers）。

## Ownership Table

| File | Owner Task | Tier |
|------|-----------|------|
| `references/landing-contract.md` | T-P3-01 | serial-write (C07/RA3 artifact ownership section) |
| `references/scheduler-rules.md` | T-P3-01 | serial-write (C08 runtime capability) |
| `SKILL.md` | T-P3-01 | serial-write (C09 role-to-asset route) |
| `references/templates/worker-report.md` | T-P3-02 | serial-write (remove Review Result, link review-result.md) |
| `references/templates/task-packet.md` | T-P3-02 | serial-write (Writable/Forbidden update) |
| `references/templates/audit-task-packet.md` | T-P3-02 | serial-write (Writable/Forbidden update) |
| `references/registry-and-compaction.md` | T-P3-02 | serial-write (ownership alignment) |
| `references/review-checklist.md` | T-P3-02 | serial-write (Review Result → review-result.md) |
| `prompt-assets/reviewer.md` | T-P3-02 | serial-write (write own run only) |
| `references/workflow-steps.md` | T-P3-02 | serial-write (Stage 4/5 gate refs) |
| `references/archive-policy.md` | T-P3-02 | serial-write (Review Result → review-result.md gate) |
| `references/glossary.md` | T-P3-02 | serial-write (ownership terms) |

## Tasks

### T-P3-01 — Owner rewrite: landing-contract (C07/RA3) + scheduler-rules (C08) + SKILL (C09)
- **Mode**: audited
- **Role**: coder
- **Writable**: `references/landing-contract.md`, `references/scheduler-rules.md`, `SKILL.md`
- **Forbidden**: all templates, all prompt-assets, all other references, all `.enloom/`

### T-P3-02 — Consumer alignment: templates + checklist + reviewer + workflow + archive + glossary
- **Mode**: audited
- **Role**: coder
- **Writable**: `references/templates/worker-report.md`, `references/templates/task-packet.md`, `references/templates/audit-task-packet.md`, `references/registry-and-compaction.md`, `references/review-checklist.md`, `prompt-assets/reviewer.md`, `references/workflow-steps.md`, `references/archive-policy.md`, `references/glossary.md`
- **Forbidden**: landing-contract.md, scheduler-rules.md, SKILL.md (locked by T-P3-01), all `.enloom/`

## Exit Gate (Phase)

- RA3 file-level split: worker-report.md has NO `## Review Result` section; review-result.md is the control-owned artifact
- Templates declare `review-result.md` in Forbidden + Control Review Result Path
- C08 4 runtime dimensions recorded independently (independent_subagent hard / concurrent/actual/diversity soft)
- C09 5-role route table in SKILL.md
- `diff -qr` 一致

## Human Decisions Needed

无。
