# Scheduler Rules

串行是默认。并行是例外优化,不是策略。

## 默认 strategy: serial

共享集成、project_state 更新、decisions 写入、archive 写入——一律串行。

## 允许并行(全部满足)

- 输入互不依赖。
- 输出能独立验收。
- 每个 report 足够短(在 review budget 内)。
- 合并结果有清晰规则。

典型场景:只读研究、独占产物文件、多方案比较。

## 禁止并行(任一命中)

- 一个任务的输出会改变另一个任务的输入。
- 需要共享同一文件写入(除非有所有权表)。
- review 方无法在预算内审完所有结果。
- 当前阶段目标本身还没定清。

## Ownership Table(三阶所有权模型)

v0.3 把「ownership 概念」升级为显式的 **Ownership Table**(铁律 3 升级:No Parallel without Ownership Table)。完整纪律见 [registry-and-compaction.md §2](registry-and-compaction.md)。

三阶所有权模型:

| 阶 | 语义 | 谁能写 |
|----|------|--------|
| **并行写区** | 各 worker 独占的新产物,集合互不相交 | 对应 worker 独占 |
| **串行集成区** | 全局唯一可变状态(project_state / decisions / registry 承载文件) | 单线程(通常 control agent)独占 |
| **只读区** | 不可变输入 | 无人 |

并行写任务必须先写所有权表(见 [templates/phase-plan.md](templates/phase-plan.md) 的 Ownership Table 段)。没有这张表,并行任务不许派发(铁律 3)。

**双清单纪律**:给 worker 的 packet 必须同时提供 `Writable Files`(独占清单,精确到路径)和 `Forbidden Files`(禁碰清单,**显式枚举串行集成区文件**,不能只说「别碰共享文件」)。这是 art_lab「worker 顺手改 index/log 破坏所有权」坑的正解。

**选型约束**:串行集成区默认强制单线程。只有当 plan 阶段显式论证该全局状态可设计为 append-only log(无冲突合并)时,集成区才可能并行。守住「并行是例外」。

## 路由预填(批处理编排)

Ownership Table 管「**谁**能写哪个文件」(防写冲突);但 split / migrate / merge 类批处理还有第二维——「**什么内容/去向**由谁决定」。如果一个 worker 只看自己的 bundle 却要自己推导路由(重定向/拆分点/文件去向),各 worker 会各自推导、路由相互矛盾。

正解见 [prompt-control.md §1 Route Pre-fill](prompt-control.md):主窗口把路由决策预填进脚本数据结构(redirects 表 / splits 清单 / 文件去向映射),worker **零路由决策**,只写 content + 调脚本。适用判据:目标是机械化可判定的(规则可预先计算,非判断题)。判断题仍归 worker bundle。

并行 split/migrate/merge 批处理:Ownership Table + 路由预填**两者都要**。

## 单 agent 会话的现实

在单个 control agent 会话里,无法真正并行 dispatch 多个写 worker。此时 task packet 仍应声明所有权表(满足协议形式),但执行实际串行。这本身是协议的真实表现,不是绕过——在能并行的环境(sub-agent 调度)里所有权表才真正生效。
