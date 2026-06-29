AgentOS V2 设计思路总结

一句话定义

AgentOS V2 不是一个常驻框架，也不是一个必须接管所有任务的插件系统。

它应该是一个按需调用的 workflow skill：当任务足够复杂时，临时介入，负责高质量规划、Prompt 预生成、Worker 隔离、Review 压缩和状态归档；任务结束后退场。

核心目标不是让 Agent 变得更复杂，而是让 Agent 在长任务中持续保持清醒。

⸻

V2 核心变化

V1 的重点是：

Project Control
→ Prompt Factory
→ Scheduler
→ Worker

V2 的重点是：

按需 Skill
→ 生成任务包
→ 调用 Pi / Sub Agent
→ Review 压缩
→ 更新状态
→ 归档退出

也就是说，AgentOS 不应该先做成一个大系统。

它更适合先做成一个轻量 workflow skill，用最小侵入的方式，把已经验证有效的工作纪律固化下来。

⸻

我的初衷

在使用 Opencode、Pi 等 Agent 工具时，我发现大型探索性任务、长期项目、多阶段研发任务会逐渐出现明显退化。

现象一：主窗口上下文不断膨胀

主窗口同时承担：

* 目标制定
* 方案讨论
* 任务拆解
* 调度
* 代码实现
* 结果审查

导致：

* Context 越来越长
* Token 成本越来越高
* 注意力被历史信息污染
* 后续决策质量下降

我希望主窗口始终保持简洁，能够随时快速 Review 整个项目。

⸻

现象二：Sub Agent 使用效率低

常见情况有两种。

情况 A：主窗口已经把方案想完了。

主窗口：

* 完整设计方案
* 完整实现思路
* 完整代码框架

然后再交给 Sub Agent 执行。

此时 Sub Agent 没有发挥多少智能，只是在照着做。

情况 B：主窗口什么都不做。

主窗口只说：

去研究一下。

Sub Agent 只能重新阅读全部上下文、重新理解项目、重新设计方案。

导致：

* Token 浪费
* 重复思考
* 上下文污染
* 产物边界不稳定

真正理想的方式是：主窗口给清晰边界，Worker 在边界内发挥智能。

⸻

现象三：长任务中的智力衰减

随着任务推进：

开始：

规划能力 100%

数小时后：

规划能力下降

Context 继续增长：

开始出现错误拆解、错误调度、错误决策。

很多失败并不是模型能力不足，而是：

调度者先变蠢了。

然后它还在继续做决策。

⸻

现象四：Sub Agent Prompt 质量退化

当前大部分 Agent 系统是：

需要时
↓
现场生成 Prompt
↓
启动 Sub Agent

但长期任务中：

调度者能力下降
↓
Prompt 质量下降
↓
Sub Agent 表现下降
↓
任务结果下降

形成负反馈循环。

所以 Prompt 不应该总是现场 improvisation。

对于长期项目，Prompt 应该成为资产。

⸻

V2 核心判断

AgentOS 最小可行形态不是插件系统，而是 workflow skill。

它的职责不是接管所有任务，而是在必要时提供一套高质量工作协议：

* 预生成 Worker Prompt
* 限定最小必要上下文
* 明确 Goal / Anti Goal / Input / Output
* 约束 Allowed Tools
* 定义 Acceptance Criteria
* 控制 Review Budget
* 压缩结果进入 project_state
* 把过程文档归档，而不是塞回主窗口

这样可以保持前置规划和后置 Review 的质量，同时避免常驻系统带来的额外复杂度。

⸻

为什么不做常驻插件系统

我不希望 AgentOS 变成一种“装上之后不能不用”的东西。

很多插件系统的问题是：

* 改变所有任务路径
* 强制引入自己的抽象
* 简单任务也要走复杂流程
* 装了之后不走它反而显得不规范
* 最后工具本身变成负担

AgentOS V2 应该反过来：

* 默认不介入
* 普通任务直接做
* 复杂任务才显式调用
* 用完即退场
* 不绑定具体执行器
* 不接管 Pi / Opencode / Copilot 的原有能力
* 长期资产留在文件系统，不留在会话里

⸻

适用场景

应该使用 AgentOS skill 的情况：

* 大型探索性任务
* 长期项目
* 多阶段研发任务
* 多 Worker 协作任务
* 需要先研究、再设计、再实现、再审查的任务
* 成本敏感，需要控制上下文和模型使用
* 产物需要归档、复盘、迭代

不应该使用 AgentOS skill 的情况：

* 单文件小修改
* 一次性脚本
* 简单 bug fix
* 明确答案型问题
* 不需要长期状态的临时任务

默认规则：

能直接完成的任务，不进入 AgentOS。

只有当任务复杂到“临时聊天会拖垮调度质量”时，才调用 AgentOS。

⸻

核心目标

Goal 1：保持主窗口极简

主窗口只保留：

* 项目目标
* 当前阶段
* 决策记录
* 任务状态
* 下一步选择

目标是：

3 分钟理解项目状态。

而不是阅读几十万 token 历史。

⸻

Goal 2：把规划、执行、Review 分离

避免：

Planner 写代码。

也避免：

Worker 做架构决策。

但 V2 不追求僵硬分层。

更准确的边界是：

* Control Skill 负责定义边界、调度、Review 和状态更新
* Worker 负责在边界内执行
* Worker 可以提出建议，但不能擅自改写项目目标
* Review 只吸收结论，不吸收全部过程

⸻

Goal 3：Sub Agent 使用最小必要上下文

传递：

* Goal
* Anti Goal
* Input
* Allowed Tools
* Output
* Acceptance Criteria
* Review Budget

而不是传递：

* 整个项目历史
* 整个仓库
* 全部聊天记录
* 未压缩的调试过程

⸻

Goal 4：Prompt 成为长期资产

Prompt 不是即时生成物。

应该：

* 设计
* 维护
* 版本化
* 复用
* 通过实际任务反馈持续改进

形成 Prompt 资产库。

最小资产形态：

agents/
  researcher.md
  architect.md
  coder.md
  reviewer.md
  tester.md

这些模板不直接代表常驻 Agent。

它们只是按需生成 Worker Prompt 的素材。

⸻

Goal 5：防止调度者在长任务中持续退化

引入 Context Budget 和 Review Budget。

Context Budget 解决：

* 主窗口越来越长
* 历史细节污染当前判断
* 调度层持续退化

Review Budget 解决：

* Worker 文档越来越多
* Review 成本越来越高
* 主窗口为了审查又重新吞入大量过程细节

AgentOS V2 必须同时控制这两件事。

否则只是把上下文压力从聊天窗口转移到了文档系统。

⸻

V2 分层架构

Layer 1：Control Skill

按需调用的控制流程。

职责：

* 判断任务是否值得进入 AgentOS 流程
* 读取最少项目状态
* 制定当前阶段目标
* 生成 Worker 任务包
* 决定串行 / 并行
* 审查 Worker 产物
* 更新 project_state
* 归档过程材料

默认不做：

* 不编码
* 不深度调研
* 不分析大日志
* 不长期持有执行上下文
* 不接管普通任务

但它可以在 Review 时读取必要证据。

控制面不是盲调度，它要能抽样验证 Worker 是否可信。

⸻

Layer 2：Prompt Assets

Prompt 资产库。

职责：

* 保存角色模板
* 保存任务包格式
* 保存 Review 格式
* 保存常用约束
* 从成功任务中沉淀更好的模板

维护：

agents/
  researcher.md
  architect.md
  coder.md
  reviewer.md
  tester.md

Prompt Assets 不执行任务。

它只负责让每次 Worker 调用从一个高质量起点开始。

⸻

Layer 3：Scheduler Protocol

调度协议，不一定是复杂程序。

职责：

* 任务拆解
* 串行 / 并行判断
* Worker 创建
* Worker 结果收集
* Worker 销毁

默认：

strategy: serial

只有满足以下条件，才允许并行：

* 任务互不依赖
* 输入边界清晰
* 输出可独立验收
* Review 成本不会超过收益

并行不是默认优化。

如果 5 个 Worker 并行产出 5 份复杂报告，但 Control Skill 没有能力快速审查，那么并行只是把瓶颈后移。

⸻

Layer 4：Worker Call

短生命周期执行单元。

可以通过 Pi 调用，也可以通过其他 Agent 工具调用。

职责：

* 调研
* 编码
* 测试
* 分析
* 生成产物
* 生成 report.md

执行完成：

* 输出结果
* 写入报告
* 退出
* 销毁上下文

Worker 上下文不长期保存。

长期保存的是产物和压缩后的状态。

⸻

Pi 与 Sub Agent 的关系

V2 不需要重写 Pi，也不需要替代 Pi。

Pi 可以作为执行器：

AgentOS Skill
→ 生成任务包
→ 调用 Pi
→ Pi 调用具体 skill / sub agent
→ Worker 输出结果
→ AgentOS Review

简单的 Pi 调用已经足够承载执行。

AgentOS 只负责把调用前后的质量做稳：

* 调用前：Prompt 预生成、边界定义、验收标准
* 调用后：Review 压缩、状态更新、归档

每个子调用内部可以再调用 sub agent 或 Pi skill 完成局部隔离。

但不应该默认无限嵌套。

默认最大两层：

Control Skill
→ Worker

只有当 Worker 内部任务明显可拆分、且产物可以独立验收时，才允许：

Control Skill
→ Worker
→ Inner Sub Agent

Inner Sub Agent 的过程文档不进入主项目状态。

Worker 必须把内部结果压缩成自己的 report.md。

⸻

任务包格式

每次 Worker 调用都应该生成一个任务包。

最小格式：

Goal:
  当前任务要完成什么。

Anti Goal:
  当前任务明确不做什么。

Input:
  允许读取的文件、上下文、约束。

Allowed Tools:
  可以使用的工具范围。

Output:
  必须产出的文件或结果。

Acceptance Criteria:
  怎样算完成。

Review Budget:
  Review 方需要阅读多少内容、哪些内容是必读、哪些是可选。

Done Signal:
  Worker 完成后应该留下什么明确信号。

⸻

推荐任务流

阶段 0：判断是否进入 AgentOS

Control Skill 先判断：

* 这是普通任务，直接做
* 还是复杂任务，进入 AgentOS 流程

如果直接做更便宜，就不要启动 AgentOS。

⸻

阶段 1：规划

主窗口或 Control Skill 只产出：

goal:
  xxx
anti_goal:
  xxx
constraints:
  xxx
strategy:
  serial
tasks:
  - T1
  - T2
  - T3

到此停止。

不深入写实现细节。

⸻

阶段 2：Prompt 生产

使用 Prompt Assets 生成 Worker Prompt。

例如：

# Research Worker

Goal:
xxx

Anti Goal:
xxx

Input:
xxx

Allowed Tools:
xxx

Output:
research.md

Acceptance Criteria:
xxx

Review Budget:
report.md 必读，raw notes 可选。

生成任务 Prompt 后，再交给 Pi / Sub Agent 执行。

⸻

阶段 3：执行

Worker 执行：

读取输入
↓
完成任务
↓
输出结果
↓
写 report.md
↓
退出

产物示例：

runs/T001/output.md
runs/T001/report.md
runs/T001/raw-notes.md

其中 raw-notes.md 只用于追溯，不默认进入主窗口。

⸻

阶段 4：Review

Control Skill：

阅读 report.md
↓
必要时抽样阅读 output.md / raw-notes.md
↓
判断是否满足 Acceptance Criteria
↓
生成状态更新
↓
更新 project_state
↓
决定下一步

Review 只保留结论。

不保留执行细节。

⸻

阶段 5：归档

完成任务后：

* project_state.md 只保留结论
* decisions.md 只保留关键决策
* task 文件只保留待完成工作
* runs/ 或 archive/ 保存过程材料
* 主窗口不吞入 raw docs

完成的阶段必须闭合。

闭合标准：

* 有明确输入
* 有明确输出
* 有验收结果
* 有 report.md
* 有状态更新

⸻

文档治理

V2 最大风险不是做不出来，而是文档数量膨胀。

如果每个 Worker、每个 Inner Sub Agent 都产出大量文档，Review 会变成新的瓶颈。

所以必须区分必读文档和追溯文档。

每个任务必须有：

* output.md：正式产物
* report.md：结论、证据、风险、状态更新、下一步

可选才有：

* raw-notes.md
* raw-log.md
* subagent-*.md
* scratch.md

Control Skill 默认只读 report.md。

只有在以下情况才读 raw docs：

* report.md 证据不足
* 结果与预期冲突
* 任务失败
* 风险很高
* 需要复盘 Prompt 或 Worker 表现

⸻

report.md 固定格式

为了控制 Review 成本，每个 Worker 的 report.md 应该短而稳定。

推荐格式：

## Result

完成了什么。

## Evidence

依据是什么。

## Risks

还有什么不确定。

## State Update

应该写入 project_state 的结论。

## Next

建议下一步。

默认要求：

* report.md 优先短
* 不复述完整过程
* 不粘贴大段日志
* 不把 raw notes 当成报告
* 不用文档数量证明任务完成

⸻

Context Budget 与 Review Budget

建议引入：

control_skill:
  max_context: 8k
prompt_assets:
  max_context: 16k
worker:
  max_context: 64k

并设置：

70%
总结

85%
禁止继续扩张

95%
强制重建会话

同时引入 Review Budget。

每个任务必须声明：

* Review 必读文件
* Review 可选文件
* report.md 目标长度
* raw docs 是否需要保留
* 哪些内容可以直接归档

这样才能避免“聊天上下文膨胀”变成“文档上下文膨胀”。

⸻

建议目录结构

第一版不需要复杂项目。

可以从最小文件协议开始：

AgentOS/
  goal.md
  roadmap.md
  project_state.md
  decisions.md
  agents/
    researcher.md
    architect.md
    coder.md
    reviewer.md
    tester.md
  tasks/
    T001.md
  runs/
    T001/
      input.md
      output.md
      report.md
      raw-notes.md

更轻量时，甚至只需要：

AgentOS/
  project_state.md
  agents/
    worker.md
  runs/
    T001/
      output.md
      report.md

先用文件规范跑通，不急着做工具。

等重复模式稳定，再把流程抽成 CLI 或更明确的 skill 行为。

⸻

Non-Goals

AgentOS V2 明确不做：

* 不做常驻插件系统
* 不接管所有任务
* 不强制普通任务文档化
* 不替代 Pi / Opencode / Copilot
* 不维护复杂运行时状态
* 不默认多层 Agent 嵌套
* 不做模型自动评分体系
* 不做 Profile 规则引擎
* 不做热更新 / 文件监听
* 不为了形式完整而制造文档

核心原则：

能不用就不用。

用的时候必须有明显收益。

⸻

第一版 Skill 应该怎么做

AgentOS skill 的第一版只需要覆盖四个动作：

1. plan

判断任务是否值得进入 AgentOS，并生成任务拆解。

2. make-prompt

根据 agents/* 模板生成 Worker 任务包。

3. review

读取 Worker 的 report.md / output.md，判断是否通过验收，并生成状态更新。

4. archive

把完成任务移入归档，只保留 project_state 和待办任务。

这四个动作可以先是人工触发，也可以由一个 workflow skill 串起来。

不要一开始做成完整平台。

⸻

核心观点

当前很多 Agent 系统优化的是：

如何让 Agent 更聪明。

而真正需要解决的是：

如何让 Agent 在长时间任务中持续保持聪明。

因此重点不应该放在：

* 更强模型
* 更长 Context
* 更复杂插件系统
* 更深 Agent 嵌套

而应该放在：

* 角色隔离
* 上下文治理
* Prompt 资产化
* 调度能力稳定
* Review 成本控制
* 会话生命周期管理

AgentOS V2 的最终形态不是一个必须常驻的 OS。

它更像一个按需请出的高质量工作流：

需要时介入，完成后退场。

长期资产不是 Worker 会话，而是：

* project_state.md
* decisions.md
* agents/*
* task packets
* report.md
* 已归档产物

Worker 只是一次性执行单元。

项目状态和 Prompt 资产才是长期积累的核心。

最小侵入，才可能长期可用。