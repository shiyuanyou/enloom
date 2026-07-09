# Review Checklist

Verify 阶段(阶段 4)的 gate 清单。对齐 [Evidence Contract](evidence-contract.md) 四要素 + 三态 verdict。逐条核对。

## 读什么(report-first)

1. `runs/TASK_ID/report.md` —— 必读。
2. `runs/TASK_ID/output.md` —— 仅当 report 证据不足。
3. `runs/TASK_ID/raw-notes.md` —— 仅当失败 / 高风险 / 复盘。

## 三态 verdict(机械化判定)

先按 Evidence Contract 硬约束判定 verdict,再映射到 review 结论:

| Verdict | 判定条件 | 典型 review 结论 |
|---------|---------|-----------------|
| `PASS` | 所有 declared checks 已跑 + evidence 非空 + 盲区已声明 + 无未解释的高严重问题 | accepted |
| `ISSUES` | 有缺陷但可继续(medium/low severity,已登记 registry) | accepted-with-risk |
| `FAIL` | high severity 未解 / 必检未跑 / 证据缺失 | needs-rework 或 rejected |

**硬约束(Evidence Contract)**:`verdict = PASS` 当且仅当所有 declared checks 已执行且 evidence 非空。任何 declared check 标记 `NOT RUN` → 不能 PASS。任何 high-severity issue 未解释 → 不能 PASS。无证据的 PASS → 自动降级。

## accepted 的必要条件(全部满足)

- [ ] report 含 Checks Run(四要素 1,非空)。
- [ ] report 含 Evidence(四要素 2,具体证据,非「trust me」)。
- [ ] report 含 Not Checked(四要素 3,显式声明盲区,即使为「无」)。
- [ ] report 含 Known Blind Spots(四要素 4,盲区理由 + 风险大小)。
- [ ] 无未解释的高严重问题。
- [ ] Acceptance Criteria 逐条对照通过。

## 计数自洽检查(第 5 维 Claim Consistency)

对 report 中任何**可数 claim**(条目数 / 通过率 / 文件数 / 覆盖率),Verify 阶段用独立脚本(`grep -c` / `awk` / `git diff --stat`)对 output 实际重数,比对 report 自报:

- **偏差 = 0** → 通过(claim 一致)。
- **偏差 > 0** → 记 ISSUES(非 PASS),偏差方向(低估/高报)一并登记。若偏差指向结构性缺陷,登记进 Registry `## Broken References`。

> **单 agent 退化**:本检查在单 agent 串行模式下退化为「agent 复核自己 output 条数」,防的是 claim 笔误/漂移(report 写 107、文件实 130 是常见真实错误),**不防系统性谎报**(后者由 Known Blind Spots 的 cross-role verification 覆盖)。详见 [evidence-contract.md §The Fifth Dimension](evidence-contract.md)。
>
> 适用判据:`audited` 模式**必填**(packet 声明了 Countable outputs 就必须比对);`recorded`/`emergent` 可选。

## accepted-with-risk 的情形

- verdict = ISSUES:核心达成,但有已知风险(medium/low severity)。
- 风险必须写入 project_state 的 `## Accepted With Risk` registry 区段。
- 用法:结论 `accepted-with-risk`,风险进 registry,不阻塞推进。这正是三态 verdict 中间态的价值——带已知缺陷继续。

## 降级为 needs-rework 的情形

- verdict = FAIL 但可修复:Required Verification 没跑、Evidence 不足或泛泛、有可修复的问题。
- report 自称 done 但 Checks Run / Evidence 段空缺。

## rejected 的情形

- verdict = FAIL 且不可修复:产物不可用、方向错误。
- 归档为失败样本,不合并状态。
- **必须登记进 registry 的 `## Rejected Reports`**——失败信号,防重试相同路径。

## Registry 更新义务(阶段 4)

review 后,control agent **必须**把发现的问题登记进对应 registry 区段:
- broken reference → `## Broken References`
- 带风险验收 → `## Accepted With Risk`
- 被拒报告 → `## Rejected Reports`
- 未兑现产出 → `## Broken References`(从 `## Promised Outputs` 的 broken 项迁入)

这是把 registry 从「只写」变成「活性真相」的义务。

## 铁律

没有证据的 PASS 一律降级 `needs-rework`(铁律 4,Evidence Contract 机械化)。review 只吸收结论,不把 raw 过程塞回主窗口。
