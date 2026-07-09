# Output: T02-X2

Honest Blind Spot 扩为三项。三文件改动落地。

## 改动 1: evidence-contract.md §The Honest Blind Spots(原 §The Honest Blind Spot)

- 段名单数→复数。
- 原 1 项(cross-worker isolation)保留,标注 "Recorded since v0.3"。
- 新增第 2 项:cross-role verification(verdict/review/audit 可能同 context,独立推理链不保证)。
- 新增第 3 项:virtual parallelism(单 agent 下 strategy:parallel 只是协议形式,执行实际串行;实证依据 scheduler-rules.md)。
- 加尾段:三项不使 enloom 不可用,而是让它诚实。

## 改动 2: scheduler-rules.md「单 agent 会话的现实」

- 段首加 ⚠️ 架构盲区回写标记:明示该事实是盲区(非埋藏),指向 evidence-contract §The Honest Blind Spots 第 3 项。
- 原文保留不动,仅前置声明。

## 改动 3: templates/worker-report.md Known Blind Spots

- 从单行示例扩为三项编号清单(cross-worker isolation / cross-role verification / virtual parallelism)。
- 加注:不必每报告都列三项,只列对该任务风险面适用的。

## 未动

- Evidence Contract 四要素 + 硬约束(PASS iff checks ran + evidence 非空)未动。
- scheduler-rules 三阶所有权 / 串行默认语义未动。
