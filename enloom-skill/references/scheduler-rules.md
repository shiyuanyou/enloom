# Scheduler Rules

串行是默认。并行是例外优化,不是策略。

> **Mode 与约束密度(v0.5)**:task packet 的三种 mode(emergent / recorded / audited)不只是语义标签,还决定**约束密度**——见 [templates/task-packet.md](templates/task-packet.md) 的 mode-differentiated field 表。调度时:探索/侦察 task 用 `emergent`(Forbidden 可空,降低 make-prompt 负担);长期产物用 `recorded`;共享文件/高风险/需独立校验的用 `audited`(Required Verification + Countable outputs 必填,缺则 make-prompt 自检不通过、不准 dispatch)。约束密度匹配复杂度,而非一刀切。

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

## 新 domain 的侦察调度(v0.5 指引)

踩坑实录(art_lab #16):对**不熟的门类 / 不熟的代码库**直接按 Plan 阶段的切分派执行 worker,常因实际规模与规划偏差(原规划 3 agent ~100 条,预研后发现 ~180 条)导致返工。Plan 阶段读的是已有 Registry 风险段,**不是对新任务的领域预研**。

**调度指引(非新阶段、非新字段、非新术语)**:Plan 遇到不熟领域时,把**第一个 task 设为侦察 task**——用现有 task-packet(`mode: emergent`,`Allowed Tools: Read / Grep / Web`),它的 output 喂回 Plan 修正切分。这吃下约 80% 的「预研前置」价值,且零结构改动(无需 Pre-flight 子阶段、无需 `pre_flight_needed` 字段)。

判据:Plan 阶段若对目标 domain 的规模 / 结构 / 边界没有把握,首 task 应为 recon;已有把握则跳过。recon 的 done signal 是「一份可读的规模/结构素描」,不是产物本身。

## 并行调度的真实时序(virtual parallelism 盲区)

> ⚠️ **架构盲区**:即使每个 task 都真 dispatch 给独立 sub-agent,control agent 在单个会话里**顺序发起**这些 dispatch——phase-plan 里声明的 `strategy: parallel` + Ownership Table 是**协议形式**,不代表运行时真并发执行。该盲区纳入 Evidence Contract 的 **Known Blind Spots** 第 3 项(virtual parallelism),见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。Ownership Table 仍有价值——它把意图写明,是真实并发运行时会执行的契约——但不得用 `parallel` 标签暗示已发生真实并行。

(注:无 sub-agent 能力的运行时,Enloom 直接中断,见 [landing-contract.md §5](landing-contract.md)。本段只讨论"有 sub-agent 但顺序发起"的情况。)
