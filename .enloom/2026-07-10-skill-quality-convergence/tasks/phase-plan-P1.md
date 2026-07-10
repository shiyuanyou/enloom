# Phase Plan: P1 — Evidence Contract Totality

## Phase Goal

把 Evidence Contract 的 verdict 和 review conclusion 变成一个 total decision function（C01/RA1/RA1.2），并使四字段语义不相交（C02）。删除所有 consumer 中残留的旧"PASS iff"两条件公式和"typical mapping"措辞。

## Anti-Goal

- 不碰 lifecycle 结构（Stage 0/3/4 描述）——那是 P2 的范围。
- 不碰 ownership 模型（report.md / Review Result 分割）——那是 P3 的范围。
- 不重命名四字段（Checks Run / Evidence / Not Checked / Known Blind Spots 保持不变）。
- 不改 description / trigger 措辞——那是 P5。

## Constraints

- 串行：T-P1-01 先写 owner；T-P1-02 在 owner 锁定后对齐 consumers。
- 每改一个 live 文件，当 phase 结束时必须 `cp` 到 `~/.agents/skills/enloom/` + `diff -qr` 校验。
- 改段标题前 `grep -r '<旧标题>' enloom-skill/` 确认引用方。

## Strategy

Serial（owner → consumers）。T-P1-02 的 Writable Files 是 T-P1-01 的 Forbidden Files，自然串行。

## Ownership Table

| File | Owner Task | Tier |
|------|-----------|------|
| `references/evidence-contract.md` | T-P1-01 | serial-write (exclusive during T-P1-01) |
| `references/review-checklist.md` | T-P1-02 | serial-write (exclusive during T-P1-02) |
| `references/templates/worker-report.md` | T-P1-02 | serial-write |
| `references/templates/audit-task-packet.md` | T-P1-02 | serial-write |
| `prompt-assets/reviewer.md` | T-P1-02 | serial-write |
| `prompt-assets/coder.md` | T-P1-02 | serial-write |
| `prompt-assets/researcher.md` | T-P1-02 | serial-write |
| `references/glossary.md` | T-P1-02 | serial-write |
| `references/workflow-steps.md` | T-P1-02 | serial-write (Evidence-related refs only) |

## Tasks

### T-P1-01 — Owner rewrite: evidence-contract.md

- **Mode**: audited
- **Role**: coder
- **Writable**: `references/evidence-contract.md`
- **Forbidden**: all other live files, all `.enloom/` control plane

### T-P1-02 — Consumer alignment

- **Mode**: audited
- **Role**: coder
- **Writable**: `references/review-checklist.md`, `references/templates/worker-report.md`, `references/templates/audit-task-packet.md`, `prompt-assets/reviewer.md`, `prompt-assets/coder.md`, `prompt-assets/researcher.md`, `references/glossary.md`, `references/workflow-steps.md`
- **Forbidden**: `references/evidence-contract.md` (locked by T-P1-01), all `.enloom/` control plane

## Review Plan

每个 task worker 产出后，control 做 report-first review：
1. 读 `report.md`，按 Evidence Contract 检查四要素。
2. 跑 Exit Gate 命令（rg 检查旧措辞清除、新措辞落地）。
3. E01–E08 truth table 手动推演验证 totality。

## Exit Gate (Phase)

- `rg 'if and only if|当且仅当|typical.*mapping|Typical review conclusion|mapping is a default' enloom-skill/` → 0 hits
- E01–E08 truth table：每个 consumer 对同一 fixture 产出唯一 verdict/conclusion
- 四字段语义不相交：Not Checked 只含 required omissions
- `diff -qr enloom-skill/ ~/.agents/skills/enloom/` → empty

## Human Decisions Needed

无。C01/C02 规则已由 P0 冻结。
