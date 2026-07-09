# Enloom v06 · dispatch-default 翻转 · project_state

> dogfood 项目:用 enloom 修 enloom 自身。核心目标——任务包进 sub-agent,主窗口只设计与规划,无 sub-agent 即中断(不退化)。

## Current Phase

**Phase: 4 — P3 清理(CLOSED 待 archive)**。P0/P0.5/P1/P2 已闭合。P3 收尾 v0.6 遗留两处清理:archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 措辞。三处全落源仓库 + 同步副本,Verify accepted。art-lab "the agent" 经判断保留+加 Naming note(诚实于历史),manual-trial 4 处 "The agent" → control agent。v0.6 全部 phase 闭合。

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
| P1 | 7 处措辞硬化(eval-guide/coder/worker-report trim rule/project-state/task-board/task-packet)+ 源/副本同步 | ✅ completed (PASS) |
| P2-recon | recon 升格(reframe + recommended):phase-plan Human Decision + triage 偏好 + scheduler-rules 三信号 + researcher 分支 + eval case 10 | ✅ completed (PASS, accepted) |
| P3-清理 | archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 措辞 | ✅ completed (PASS, accepted) |

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

- **P2 reframe 诚实边界**:recon 升格防"决策被静默跳过",**不防**"决策做错"(用户可能说不要 recon 然后撞规模偏差)。art_lab #16 根因(人没预研)跨方案恒存,P2 不假装能解。卖点是"给预研一个结构化位置 + 降低主窗口 prompt 污染",非"防漏扫"。写入 scheduler-rules.md 诚实边界段。
- **recommended false positive(新项目)**:Registry 空时三信号之"Registry 无覆盖"会多发 recommended。第一个用户(作者)可接受,记为 Known Limitation,后续按 dogfood 反馈调信号精度。
- **case 10 设计态**:evals.json case 10 未实际跑(无 headless sub-agent dispatch 环境),"信号触发故 recommended"判断有 reviewer 主观空间。Passage 待 Path B 环境就绪后验。
- **recon 标识靠文字**(reframe 有意取舍):task-packet 标 recon 靠 Goal/Anti-Goal 文字,非结构化字段——Plan 派 task 时须在 Goal 明写"recon",researcher 才走 How-to-work 第 6 条。零结构改动的代价,非缺陷。
- (P0 遗留的 eval-guide:31 + coder:37 已在 P1 闭合,清空)

## Rejected Reports

- (无)

## Archived Phases

- **Phase 1 (P0+P0.5)** — dispatch-default 叙事翻转,2026-07-06 closed。结论:核心叙事链六处互引翻转完成,零残留旧叙事;virtual parallelism 盲区保留。详见 `archive/phase-1-entry.md`。
- **Phase 2 (P1)** — 角色命名硬化 + trim rule,2026-07-06 closed。结论:D2 暧昧措辞硬化为显式 control agent/worker;worker-report D3 缺口补齐;源/副本同步纪律跑通。详见 `archive/phase-2-entry.md`。
- **Phase 3 (P2-recon)** — recon 升格(reframe + recommended),2026-07-07 closed。结论:recon 从"调度指引"升级为"人机决策门 + recommended 信号",零结构改动(不碰 v0.5 红线);五件 MVP 落源仓库 + 同步副本,Verify accepted;reframe 规则首次在 phase-plan-3 自身跑通。详见 `archive/phase-3-entry.md`。
- **Phase 4 (P3-清理)** — archive-entry 锁注释 + art-lab/manual-trial 措辞,2026-07-07 closed。结论:Raw Material Handling 段加锁注释(记录隔离方式非粘贴 raw);art-lab "the agent" 保留+加 Naming note(诚实于历史外部任务);manual-trial 4 处 → control agent。v0.6 全 phase 闭合。详见 `archive/phase-4-entry.md`。

## Ownership Table (this phase)

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/2026-07-06-enloom-v06/project_state.md` + Registry | 控制 agent 独占 |
| 并行写 | enloom skill 源文件(`~/.agents/skills/enloom/`)各 batch | 各 worker 独占(按 batch 切分) |
| 只读 | `design/` 历史、前序 v033/v04/v05 项目目录 | 谁都不改 |
