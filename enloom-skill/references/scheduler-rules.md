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

## recon 调度(v0.6 P2 reframe:人机决策门 + recommended 信号)

> v0.5 的"一段调度指引"在 v0.6 升格为**人机决策门 + recommended 信号**——零结构改动(不新增 stage / 顶层字段 / Role 枚举值 / Pre-flight 子阶段),只复用既有 phase-plan Human Decision 机制。

踩坑实录(art_lab #16):对**不熟的门类 / 不熟的代码库**直接按 Plan 阶段的切分派执行 worker,常因实际规模与规划偏差(原规划 3 agent ~100 条,预研后发现 ~180 条)导致返工。Plan 阶段读的是已有 Registry 风险段,**不是对新任务的领域预研**。

**recon 决策现在是 phase-plan Human Decision 的一行**(机制 a),不再是"Plan 自觉派"——每个 phase 的 phase-plan 都把 recon 摆成显式 Human Decision([templates/phase-plan.md](templates/phase-plan.md) §Human Decisions Needed 的 recon decision 行,P2-A);用户也可在 triage 时直接声明要/不要 recon(机制 b,见 [trigger-contract.md](trigger-contract.md) §recon 偏好)。Plan 不自动派,只把决策摆出来等人定。**P2-C(本段) ↔ P2-A(phase-plan Human Decision)双向交叉引用。**

**recommended 三信号规则(机制 c,P2 第一版核心——salience 层)**:Plan 在以下**任一**信号出现时,把该 phase 的 recon Human Decision 标 `recommended`,否则作为 standing option(不标 recommended、不强制):

1. **Registry 无该域风险段(新 domain)**—— Orient 读 project_state.md Registry 段(Pending Dependencies / Broken References / Accepted With Risk)时的副产物,无相关项即触发。
2. **出现新文件类型(扩展名/结构未见过)**—— Plan 读 input 时的自然观察。
3. **Plan 读 input 时规模/边界不明**—— Plan 本来就要做的判断。

> recommended 是"salience(agent 廉价可错)与决策(人)分离"——agent 只判"要不要标 recommended",不判"做不做 recon"。**已知裂缝**:新项目 Registry 空时 false positive 多,第一个用户可接受,记为 Known Limitation。

**recon task 仍是普通 emergent task**(非新 Role/Mode):用现有 task-packet(`mode: emergent`,`Allowed Tools: Read / Grep / Web`),Goal/Anti-Goal 写明产物=规模素描,recon 的 done signal 是「一份可读的规模/结构素描」。researcher 拿到这种 task 时按 [prompt-assets/researcher.md](../prompt-assets/researcher.md) How-to-work 第 6 条产出素描(非完整 research)。

**诚实边界(跨方案恒定)**:recon 升格防的是"**决策被静默跳过**"(从可能跳过变成有结构位提醒),**不防**"决策做错"(用户可能说不要 recon 然后撞规模偏差),也不防"覆盖不完整"(recon task 读的也是 packet 列出的 input,packet 外的东西它照样会漏)。art_lab #16 的根因(人没预研)在所有方案里都存在,P2 不假装能解。recon 升格的卖点是"**给 Plan 一个结构化的预研位置 + 降低主窗口 prompt 污染**",不是"防漏扫"。

## 并行调度的真实时序(virtual parallelism 盲区)

> ⚠️ **架构盲区**:即使每个 task 都真 dispatch 给独立 sub-agent,control agent 在单个会话里**顺序发起**这些 dispatch——phase-plan 里声明的 `strategy: parallel` + Ownership Table 是**协议形式**,不代表运行时真并发执行。该盲区纳入 Evidence Contract 的 **Known Blind Spots** 第 3 项(virtual parallelism),见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。Ownership Table 仍有价值——它把意图写明,是真实并发运行时会执行的契约——但不得用 `parallel` 标签暗示已发生真实并行。

(注:无 sub-agent 能力的运行时,Enloom 直接中断,见 [landing-contract.md §5](landing-contract.md)。本段只讨论"有 sub-agent 但顺序发起"的情况。)
