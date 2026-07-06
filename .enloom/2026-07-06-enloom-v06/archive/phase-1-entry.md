# Archive Entry: Phase 1 — P0 叙事翻转

## Completed

把 enloom skill 的"单 agent 自执行合法化"叙事链(六处互引)翻转成"默认 dispatch 给独立 sub-agent,无 sub-agent 能力即中断"。P0(主链六处)+ P0.5(evidence-contract 残留三处 + 断链)。

## Outputs

- `references/glossary.md` — Worker 定义翻转(源头)
- `references/evidence-contract.md` — §Honest Blind Spots 开头 + §Fifth Dimension boundary + 编号第 2/3 项正文 + 收尾句(共 5 处,P0+P0.5)
- `references/landing-contract.md` — §5 整段重写(Single-agent reality → Sub-agent requirement)
- `references/scheduler-rules.md` — §单 agent 整段重写(→ 并行调度的真实时序)
- `references/templates/worker-report.md` — Known Blind Spots 模板重述

## Evidence

- V1(旧叙事锚短语):0 hits ✅
- V2(virtual parallelism 盲区保留):scheduler-rules + evidence-contract 均命中 ✅
- V3(中断语义):landing-contract "halts" ✅
- V4(骨架未误改):Four Elements / six stages / Five Laws 原样 ✅
- 全 skill `grep -rin single-agent` 终扫:核心 5 文件零残留

## Verification

- P0: ISSUES(accepted-with-risk)— packet 边界漏了编号项正文,worker 诚实声明
- P0.5: PASS(accepted)— 补齐残留 + 修断链
- Claim Consistency:声称 6 文件改动(P0:5 + P0.5:1,去重后 5 唯一文件),与独立 grep 一致

## Decisions Updated

- dispatch posture 翻转:默认 sub-agent,无能力即中断,不退化(取代旧"单 agent baseline")
- virtual parallelism 盲区保留(声明 parallel ≠ 真并发,与 sub-agent 能力正交)
- 主窗口职责明确:triage/orient/plan/review/integrate/archive + 串行集成区写入

## Project State Updated

✅ project_state.md Phase 字段 + Active Tasks + Promised Outputs + Broken References + Accepted With Risk 均已更新。

## Registry Updates

- Broken References:evidence-contract L92 旧标题断链 → resolved(P0.5)
- Accepted With Risk:eval-guide:31 + coder:37 残留措辞 → 转 P1
- 其余风险段:无变动

## Open Risks Carried Forward

1. **eval-guide.md:31** + **coder.md:37** 的 single-agent 措辞 → P1
2. **P1 命名硬化**:"the agent"→"control agent"/"worker" 全 skill 统一
3. **worker-report trim rule**:补 audit-task-packet:65 那样的 Return-To-Caller 段
4. **P2 recon 升格**:researcher.md 加 recon 模式 + phase-plan 结构位 + eval case
5. **P3 清理**:archive-entry Raw Material Handling + art-lab/manual-trial 措辞

## Raw Material Handling

- worker 的完整 diff 摘要存在 runs/P0/output.md + runs/P0.5/output.md(逐处 old→new)
- 未进主窗口;control agent 只读 report.md 做判断
- 改动过程的 raw Edit 调用历史在 sub-agent 上下文里,不复制进 archive

## Next Step

Phase 2 — P1 命名硬化 + worker-report trim rule + eval-guide/coder 措辞收尾。

## Dogfood 验证总结(本次跑 enloom 修 enloom 的关键观察)

1. **dispatch-default posture 首次跑通**:P0 + P0.5 两个 task 都真 dispatch 给独立 sub-agent(general-purpose),主窗口未自执行 worker task。新 posture 在自身首次验证可用。
2. **Evidence Contract 起作用**:P0 worker 诚实声明了 packet 边界外的残留(Not Checked + Known Blind Spots),没被隐瞒 → control agent 据 ISSUES 判定并开 P0.5 补齐。这是四要素机制的真实价值。
3. **暴露 packet 设计缺陷(实证 P2 需求)**:P0 packet 的 6 处边界漏了 evidence-contract 编号项正文,导致 ISSUES。根因是扫描/recon 由主窗口做,没系统化覆盖。这印证了 P2 recon 升格的必要性——recon 应是 sub-agent task,不是主窗口顺手做。
4. **断链被 cross-ref 检查抓到**:scheduler-rules 改名后,evidence-contract 的旧标题引用变断链 → prompt-control §5 的"repair-plan 须验证 problem statement"反例的真实复现。
5. **landing-contract gate 全程生效**:每个 stage crossing 的文件存在性 gate(task.md / output.md / report.md / Review Result 段)都被自检,无一跳过。
