# Enloom v06 · dispatch-default 翻转 · project_state

> dogfood 项目:用 enloom 修 enloom 自身。核心目标——任务包进 sub-agent,主窗口只设计与规划,无 sub-agent 即中断(不退化)。

## Current Phase

**Phase: 1 — P0 叙事翻转(CLOSED, 待 archive)**。把"单 agent 自执行"的合法化叙事链(glossary→evidence-contract→landing-contract→scheduler-rules→worker-report 六处互引)同批翻转成"默认 dispatch,无 sub-agent 能力即中断"。P0(ISSUES,accepted-with-risk)+ P0.5(PASS,accepted)已闭合。核心叙事链零残留旧叙事;剩余 eval-guide:31 / coder:37 归 P1 范围。

> **dogfood 回看(D1/D5 痛点复现)**:本 phase 的"扫描阶段"由主窗口直接做(recon 未 dispatch 给 sub-agent),正是 D1/D5 痛点的真实复现——复杂任务的预研究没进 sub-agent。这验证了 P2 recon 升格的必要性:recon 应该是 Plan 阶段的第一个 sub-agent task packet,而不是主窗口顺手做。

## Goal

翻转 enloom 的 dispatch posture:
- **默认**:Stage 3 task 必须 dispatch 给 sub-agent。
- **无 sub-agent 能力**:中断,提示换 opencode/pi/codex 等支持工具。不退化、不自执行、不污染 prompt。
- **主窗口职责**:triage / orient / plan / review / integrate / archive + 串行集成区写入。不进 worker task。
- **recon 升格**:复杂任务的首 task 为 sub-agent recon,产规模/结构素描喂回 Plan。

## Anti Goal

- 不删除 virtual parallelism 盲区(声明 parallel ≠ 真并发,与 sub-agent 能力无关,保留)。
- 不退化机制(声明的自执行/单 agent 兜底一律删,不写"如何合法自执行")。
- 不改 enloom 的六阶段骨架 / 五铁律 / Evidence Contract 四要素。

## Active Tasks

| ID | Task | Status |
|----|------|--------|
| P0 | 叙事翻转六处同批改(glossary / evidence-contract ×2 / landing-contract §5 / scheduler-rules §单agent / worker-report) | ✅ completed (ISSUES→P0.5 补齐) |
| P0.5 | evidence-contract L91/92/94 残留 + 旧标题断链修补 | ✅ completed (PASS) |
| P1-命名 | "the agent"→"control agent"/"worker" 全 skill 硬化 + worker-report 补 trim rule | pending (下一 phase) |
| P2-recon | researcher.md 加 recon 模式 + phase-plan 加 recon 结构位 + eval 加 recon case | pending |
| P3-清理 | archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 措辞过 | pending |

## Promised Outputs

| declarer | identifier | consumers | verify_at | status |
|----------|-----------|-----------|-----------|--------|
| P0 | glossary Worker 定义不含"当前 agent 进入 worker mode" | Stage 4 | Verify | ✅ fulfilled |
| P0 | evidence-contract 无"single-agent environment"运行基线句 | Stage 4 | Verify | ✅ fulfilled |
| P0 | landing-contract §5 翻转为"无 sub-agent 即中断" | Stage 4 | Verify | ✅ fulfilled |
| P0 | scheduler-rules §单 agent 删自执行半句,留 virtual parallelism | Stage 4 | Verify | ✅ fulfilled |
| P0 | worker-report 模板无 single-agent 默认段 | Stage 4 | Verify | ✅ fulfilled |
| P0.5 | evidence-contract L92 断链修(`"单 agent 会话的现实"`→`"并行调度的真实时序"`) | Stage 4 | Verify | ✅ fulfilled |

## Pending Dependencies

- (无)P0+P0.5 闭合。P1/P2/P3 是后续 phase,无跨 phase 依赖。

## Broken References

- ~~evidence-contract L92 引用旧 scheduler-rules 标题串 `"单 agent 会话的现实"`~~ → **P0.5 已修**(`"并行调度的真实时序"`)。

## Known Exceptions

- `design/` 历史文档冻结不改(延续 v033 决策)。
- 根 `.enloom/project_state.md` 是 v0.3.3 旧状态(已知 drift,非本 phase 范围)。

## Accepted With Risk

- **eval-guide.md:31** + **coder.md:37** 仍含 "single-agent session/environment" 措辞。**接受此风险**:两文件不在 P0/P0.5 的 writable 范围(eval-guide 非 5 文件之一;coder.md 属 prompt-assets)。归 P1 处理。风险低——eval-guide 那句是诚实声明 self-grading bias(语义正确,只是措辞需对齐);coder.md 那句是 worker 自报盲区模板。

## Rejected Reports

- (无)

## Archived Phases

- **Phase 1 (P0+P0.5)** — dispatch-default 叙事翻转,2026-07-06 closed。结论:核心叙事链六处互引翻转完成,零残留旧叙事;virtual parallelism 盲区保留。详见 `archive/phase-1-entry.md`。

## Ownership Table (this phase)

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/2026-07-06-enloom-v06/project_state.md` + Registry | 控制 agent 独占 |
| 并行写 | enloom skill 源文件(`~/.agents/skills/enloom/`)各 batch | 各 worker 独占(按 batch 切分) |
| 只读 | `design/` 历史、前序 v033/v04/v05 项目目录 | 谁都不改 |
