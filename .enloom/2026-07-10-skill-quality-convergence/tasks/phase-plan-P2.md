# Phase Plan: P2 — Lifecycle / Dispatch / Fold 去环化

## Phase Goal

消除 lifecycle/dispatch/fold 中的循环入口和 pre-triage 副作用，使 transition gate 类型和执行者明确。具体落实 C03（make-prompt 在 dispatch gate 之前，task.md 不是 Stage 3 entry 前提）、C04（Triage 无副作用，fold 在 enloom 决定后）、C06（health-check 两轴：periodic homes vs transition invocations）、RA2（Verify-worker V0→V3 非递归终止）、RA4/RA4.2（resolver precedence + fold-move-state recovery），并应用 C05 phrase guard。

## Anti-Goal

- 不改 Evidence Contract 语义（那是 P1，已落地）。
- 不改 ownership 模型 report.md/review-result.md 分割（那是 P3）。
- 不做全量命名清理（C05 广泛清理留 P5；P2 只加 phrase guard——新增/改动的 lifecycle 句子带 "Stage 0 Triage + six-stage lifecycle" 限定语）。
- 不改 description/trigger 措辞。
- 不碰 namespace resolver 的 task-board.md 模板（C10 owner 是 task-board.md，那是 P4）；P2 只改 archive-policy.md 中 fold 相关的 resolver 描述。

## Constraints

- 串行：T-P2-01 先写两个 owner（landing-contract + archive-policy）；T-P2-02 改 consumer（workflow-steps + SKILL + glossary + AGENTS）。
- C05 phrase guard：任何新增/修改的 lifecycle 描述句必须使用 "Stage 0 Triage + six-stage lifecycle (Stages 1–6)" 或等价措辞，不得引入新的未限定 "six stages / 六阶段"。
- 改段标题前 grep 确认引用方。

## Strategy

Serial（owner → consumers）。

## Ownership Table

| File | Owner Task | Tier |
|------|-----------|------|
| `references/landing-contract.md` | T-P2-01 | serial-write |
| `references/archive-policy.md` | T-P2-01 | serial-write |
| `references/workflow-steps.md` | T-P2-02 | serial-write |
| `SKILL.md` | T-P2-02 | serial-write |
| `references/glossary.md` | T-P2-02 | serial-write |
| `AGENTS.md` | T-P2-02 | serial-write |

## Tasks

### T-P2-01 — Owner rewrite: landing-contract.md + archive-policy.md
- **Mode**: audited
- **Role**: coder
- **Writable**: `references/landing-contract.md`, `references/archive-policy.md`
- **Forbidden**: all other live files, all `.enloom/`

### T-P2-02 — Consumer alignment: workflow-steps + SKILL + glossary + AGENTS
- **Mode**: audited
- **Role**: coder
- **Writable**: `references/workflow-steps.md`, `SKILL.md`, `references/glossary.md`, `AGENTS.md`
- **Forbidden**: landing-contract.md, archive-policy.md (locked by T-P2-01), all `.enloom/`

## Review Plan

每个 task worker 产出后，control 做 report-first review + exit gate 命令验证。

## Exit Gate (Phase)

- Stage 3 entry gate 不再要求 task.md 存在；make-prompt → task.md → dispatch 顺序明确
- Triage 无副作用：direct/light-plan 零 delta；fold 在 enloom 之后
- V0→V3 trace：≤3 前向转移，零 Plan 回边
- health-check 两轴明确（periodic homes = Orient + Verify；transition invocations = 5 边界 by control）
- RA4 resolver precedence 7 级存在 + fold-move-state.md 快照协议
- `diff -qr` 一致

## Human Decisions Needed

无。C03/C04/C06/RA2/RA4 已由 P0 冻结。
