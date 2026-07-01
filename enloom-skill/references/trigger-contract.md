# Trigger Contract

Enloom 的触发面是它最重要的入口。这份契约独立于 triage 决策树,定义「何时进入、何时绕过、何时暧昧」。

## Use Enloom when(命中 ≥2)

- 预计超过 3 个阶段。
- 需要 2 个以上 Worker 或角色。
- 需要跨会话状态(project_state / decisions)。
- 需要 review、archive 或复盘纪律。
- 上下文可能膨胀到影响判断。
- 产物会成为长期资产。

## Do NOT use Enloom when

- 单文件小改动、typo、重命名。
- 明确答案型问答。
- 一次性脚本(除非它是更大 audited 迁移的一部分)。
- 单个明确 bug fix。
- 不需要长期状态的临时任务。

## Ambiguous case(只命中 1 个 trigger)

不要立刻创建完整目录。二选一:

- **轻触发模式**:只输出 3–5 行 triage 判断 + 是否进入 Enloom,不创建任何文件。对应 triage 结果 `light-plan`。
- **问一个问题**:向用户确认是否需要 worker 边界、review、archive。
- **若请求属于新想法/范围不清**:`light-plan` 或 `ask-one-question` 时可建议「可先跑 Clear-Mind 做前置澄清」——不强制，Clear-Mind 是可选 phase -1。

## 用户显式要求

如果用户明确说「用 Enloom」「跑 task packet」「派 worker」,直接进入 `enloom`(除非请求明显有害或不可能)。这是 triage 决策树的第 2 步规则。

## 与 triage 子动作的关系

v0.3 把 `triage` 从顶层操作降为生命周期**阶段 0** 的子动作(见 [workflow-steps.md](workflow-steps.md))。本契约仍是 `triage` 的判断依据。具体 worked examples 见 [examples/triage-decision-tree.md](examples/triage-decision-tree.md)。本文件定义「为什么」,那一份定义「怎么做」。

triage 结果映射到生命周期入口:
- `direct` → 不进入生命周期,直接做完退出。
- `light-plan` → 不进入生命周期,给短计划,不创建文件。
- `enloom` → 进入生命周期,从阶段 1 Orient 开始。
