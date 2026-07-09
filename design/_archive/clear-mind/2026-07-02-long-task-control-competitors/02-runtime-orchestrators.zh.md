# 二、持久运行时 / 多 Agent 执行器 · 中文详版

## 总览

这些系统解决的核心问题是"让 agent 工作可恢复、可调度、可隔离、可观测"。它们的共同特征是把状态从 agent 聊天上下文里移出来，交给 runtime/daemon/云服务管理。

| 项目 | 类型 | 核心能力 | 定位差异 |
|---|---|---|---|
| Temporal | 通用 durable execution | event history、workflow replay、retries、signals | 基础设施，非 coding-agent 专用 |
| Smithers | coding-agent durable runtime | SQLite 持久、approval、rewind/fork | 最直接的可执行化竞品 |
| Millrace | 本地 runtime governance | daemon、compiled plan、queue authority | 理念最接近但实现更"硬" |
| Taskplane | Pi 多 agent 编排 | worktree waves/lanes、supervisor、dashboard | 局限 Pi 生态 |
| Multi-Agent Orchestrator | 多 CLI worker 协调 | worktree、supervision loop、dashboard | 实用本地层 |
| Citadel | Claude/Codex harness | /do routing、campaigns、fleets | 操作层 |
| Ruflo | 超大 meta-harness | swarms、memory、federation、MCP | 表面积极大 |
| LangGraph | agent workflow runtime | checkpointer、HITL、time travel | 企业应用框架 |
| CrewAI | agent/crew/flow 框架 | @persist、checkpoint、resume/fork | 角色协作 |
| AutoGen/AG2 | 消息传递 agent 框架 | actor/message、pub/sub、distributed | 偏研究 |
| Google ADK | agent 构建/部署 SDK | session、state、artifact、event | Google 生态 |
| Microsoft Agent Framework | 企业 agent workflow | durable task、checkpoint、HITL | Azure 绑定 |
| OpenHands | coding agent runtime/SDK | Docker sandbox、event log、UI | 偏平台 |
| SWE-agent | issue-to-patch agent | trajectory JSON、Docker | 偏基准测试 |
| Devin-like | 托管软件 agent | VM/container、PR、UI | 闭源、黑盒 |

---

## 1. Temporal Durable Agents

**官网**: `temporal.io`

### 定位
通用 durable execution 平台。通过 Workflow + Activity 把 agent loop、LLM 调用、tool 调用包进可恢复的分布式工作流。不是 agent 框架本身，而是 agent 下面的恢复/调度层。

### 状态持久化/恢复
- Workflow 的事件历史由 Temporal Server 持久化
- Activity 结果写入 event history
- 进程崩溃后，Workflow 通过 deterministic replay 重建状态
- 已完成 Activity 不会重复执行（event history 中已有结果）

### 隔离方式
Temporal 本身不提供代码沙箱。隔离来自 worker 部署方式、容器、权限边界。与 OpenAI Agents SDK、Pydantic AI 等有官方集成。

### 可观测性
Temporal Web UI、workflow history、search attributes、metrics、tracing 都很成熟。

### approval / retry / replay
- HITL 用 signal/update/await
- Activity retry policy 一等支持
- Workflow replay 核心能力
- 可 reset 到历史事件点继续

### 局限性
- 运维成本高（需 Temporal Server 或 Temporal Cloud）
- Workflow 代码有确定性约束
- 不自带 prompt、agent memory、代码沙箱
- event history 会膨胀

### 与 Enloom 的关系
Temporal 是极重方案——它解决的是"代码执行一定不丢"而非"agent 怎么工作"。Enloom 和它不构成竞争，反而是 Enloom 未来可对接的底层恢复层。

---

## 2. Smithers

**GitHub**: `smithersai/smithers`

### 定位
面向 coding-agent work 的 durable workflow runtime。目标是让 Claude Code、Codex、Pi、AI SDK agent 在同一个 workflow 中执行多步代码任务。

### 状态持久化/恢复
- 每个完成节点的输出立刻持久化到 SQLite
- 任务输出用 Zod schema 校验后落库
- crash 后 `--resume true` 跳过已完成节点

### 核心组件
用 JSX/React-like 表达 workflow：`Sequence`、`Parallel`、`Branch`、`Loop`、`Task`。workflow 根据已持久化 outputs 重新 render。

### isolation / sandbox
`Sandbox` component 可接 gVisor、Kubernetes、Freestyle、Daytona、Cloudflare 等。

### 可观测性
inspect、timeline、diff、run 状态、SQLite 事件、CLI 输出流。

### approval / retry / replay
- approval gate 一等组件
- rewind/fork/replay 全支持
- 100+ 示例 workflows

### 局限性
- 项目较新，成熟度待验证
- 依赖 Bun/TS/Zod v4 生态
- SQLite 单机模型对分布式高并发有上限
- 主要服务 coding-agent，不是通用企业工作流

### 与 Enloom 的关系
Smithers 是最接近把 Enloom "运行时化"的竞品。如果 Enloom 需要更强的执行层，Smithers 是很好的 runtime adapter 候选。

---

## 3. Millrace

**GitHub**: `tim-osterhus/millrace`

### 定位
本地 filesystem-backed workflow runtime/governance layer。核心主张："runtime owns state, not the agent"。

### 状态持久化
运行树在 `millrace-agents/`；queue artifacts、state、compiled plans、recovery counters、run traces、closure evidence 全部落盘。

### 调度模型
daemon 按 compiled plan 选下一 stage：queue→plan→compile→run→trace→apply。默认 serial，Learning-enabled 模式可 parallel。

### 与 Enloom 的哲学差异
Millrace 和 Enloom 都重视文件化状态和证据，但 Millrace 是 runtime owner——有 daemon、compiled plan、queue authority、approval mailbox。Enloom 是 protocol owner——靠 agent 自律 + 文件 gate 验证。

### 局限性
- 强 opinionated，概念和状态树复杂
- Rust 实现标为 experimental/parity prototype
- 偏 coding-agent runtime，不是任意流程

---

## 4. Taskplane

**GitHub**: `HenryLach/taskplane`

### 定位
Pi 生态的多 agent coding batch 编排。tasks 按依赖图分 waves/lanes，每条 lane 一个 git worktree 隔离。

### 核心组件
- 4 种 agent：supervisor、worker、reviewer、merger
- 每条 lane 用 PROMPT.md + STATUS.md 保存状态
- Step boundary commit 防止丢工作
- Worker-driven inline reviews（在任务边界调 review_step 工具）
- Live web dashboard

### 局限性
- 强耦合 Pi
- worktree merge 冲突和依赖环境仍是难点
- 不是通用 durable workflow runtime

---

## 5. Multi-Agent Orchestrator

**GitHub**: `hyw007726/multi-agent-orchestrator-skill`

### 定位
Agent Skill + 无依赖 Node.js runtime，把一个大实现拆成多个 supervised worker 在隔离 worktree 中运行。支持 Claude Code、Codex、Gemini CLI、OpenCode 等。

### 核心设计
- coord/ 目录保存 context.json、DECISIONS.md、CALLER_CONTEXT.md
- 后台 loop 监督 worker 活性、进度、validation、restart
- 终止不丢数据：保留 worktree 和 coord/ 日志
- reviewer agents 可在分解前批评计划

### 对 Enloom 启发
很实用的本地执行层。如果 Enloom 要加 runtime adapter，Multi-Agent Orchestrator 是很好的第一候选。它和 Enloom 互补：Enloom 决定"该做什么怎么验收"，Multi-Agent Orchestrator 负责"真的跑起来并监督"。

---

## 6. Citadel

**GitHub**: `SethGammon/Citadel`

### 定位
Claude Code/Codex 的操作层：/do intent routing、campaigns、hooks、cost telemetry、parallel fleets。

### 路由模型
4 tier cascade：pattern match → active state → keyword table → LLM classifier。大多数请求在 Tier 2 前解决。

### 状态层
.planning/ 保存 campaigns、fleet sessions、intake、coordination、telemetry。Archon 是 multi-session campaign planner。

### 对 Enloom 启发
Citadel 是"skill + hooks + scripts + worktree control plane"。比轻量 skill 多自动 hooks 和 routing，但没有独立 durable runtime。Enloom 可借鉴它的路由分层和 campaign 概念。

---

## 7. Ruflo / Claude Flow

**GitHub**: `ruvnet/ruflo`

### 定位
极大 meta-harness：声称 100+ agents、35+ plugins、HNSW vector memory、swarms、federation、autopilot、workflows。README 和星数都很大，但需求慎重验证。

### 核心能力
- swarm 协调：hierarchical、mesh、adaptive topologies
- 多种记忆：SQLite AgentDB、HNSW、SONA neural patterns
- 多 provider 路由
- 后台 workers、MCP tools、web UI

### 局限性
- 表面积极大，审计成本高
- 许多能力是框架宣称，生产可靠性需独立验证
- 强耦合 Claude Code/MCP
- 可能"做到很全但每一项都不深"

### 对 Enloom 启发
- 学习和审计成本对比：Enloom 的薄是优势不是劣势
- 但 swarm/campaign/autopilot 等概念值得关注走向

---

## 8. LangGraph

**所属**: LangChain 生态

### 定位
低层 agent orchestration runtime：long-running、stateful、HITL、streaming。

### 核心机制
- Checkpointer 按 thread 保存 graph state
- `interrupt()` 一等 HITL 支持
- time travel（replay/fork/update_state）
- node retry policy、timeout、error handler

### 局限性
- replay 从 checkpoint 后重新执行 LLM/tool，不是 Temporal 式 result replay
- node 内 interrupt 前代码会重跑
- 需要小 node、幂等工具，否则 replay 不可靠
- state schema discipline 要求高

### 与 Enloom 的关系
LangGraph 是应用级 workflow runtime，Enloom 是文件协议。LangGraph 更适合"我们自己写 agent app"，Enloom 更适合"让 agent 按纪律工作"。

---

## 9. CrewAI

**官网**: `crewai.com`

### 定位
role-based agent 协作框架 + Flow event-driven workflow + checkpoint/persist。

### 核心机制
- Flow 的 `@persist` 支持 state snapshot、resume/fork
- checkpoint 可捕获 crew/flow 状态
- task human_input、Flow human_feedback、guardrails
- `crewai replay` 可从任务 replay

### 局限性
- checkpoint 自动写入是 best-effort
- 不是确定性分布式 runtime
- agent/task 抽象较高，细粒度恢复要自己设计

---

## 10. AutoGen / AG2

**归属**: Microsoft Research → AG2 社区

### 定位
消息传递式多 agent 框架。AutoGen v0.4+ 用 actor/message-passing；AG2 延续 group chat + subagents。

### 状态管理
AgentRuntime 有 save_state/load_state；AG2 harness 可写 event log。但持久化是手动或半手动。

### 局限性
- 更像 agent framework，不是 durable workflow engine
- 没有内建 durable replay/time travel
- 官方 AutoGen 已 maintenance mode，推荐迁移 MAF

---

## 11. Google ADK

### 定位
Google 的 agent 开发/部署 SDK。核心是 Session、State、Memory、Artifact、Event、Runner。

### 特性
- SessionService 管理 session events 和 state
- Restate 集成可 journal LLM/tool calls
- 原生 Vertex AI/BigQuery/Cloud Run 集成
- A2A 协议跨框架 agent 通信

### 局限性
- durability 依赖 SessionService/Restate 等外部选择
- 不自带 worktree/容器隔离
- GCP 绑定感强

---

## 12. Microsoft Agent Framework

### 定位
Semantic Kernel 和 AutoGen 的直接继承方向。Durable Task Extension 把 Agent Framework 接到持久运行时。

### 核心机制
- Workflow 是 directed graph with BSP supersteps
- checkpoint 可持久化到 InMemory/File/Cosmos
- Durable Task 支持外部事件、timer、retry、长时间等待
- HITL 用 RequestPort 或 ctx.request_info()

### 局限性
- DTS/Azure 绑定感强
- durable agent entity state 有大小限制（~1MB）
- 可靠 streaming 需要额外中间件

---

## 13. OpenHands

**GitHub**: `OpenHands/OpenHands`

### 定位
开源 coding agent platform/SDK：Docker sandbox、Web UI、SDK、event log、security confirmation。

### 核心能力
- Conversation 持久化到 persistence_dir
- events/ 逐事件 append
- Docker runtime 主隔离方式
- security confirmation policy：Always/Never/ConfirmRisky

### 局限性
- 平台较重，不是轻量 skill
- 多 agent orchestration 不是核心
- 持久化 conversation 与 sandbox 生命周期恢复不完全等价

---

## 14. SWE-agent

**GitHub**: `SWE-agent/SWE-agent`

### 定位
SWE-bench issue 修复 research/benchmark agent。最新提示已被 mini-SWE-agent 取代。

### 状态
- 每个实例输出 .traj JSON
- batch rerun 跳过已有 trajectory
- RetryAgent 可多 attempt

### 局限性
- 强 benchmark/issue-fix 导向
- 不是多阶段项目 orchestrator
- 不适合通用长任务控制

---

## 15. Devin-like Hosted Agents

### 代表产品
Devin、Cursor Cloud Agents、OpenAI Codex Cloud、Google Jules、Factory Droid、Codegen 等。

### 共同特征
- 每个任务一个云端 VM/容器环境
- 强大的 UI/可观测性：timeline、logs、screenshots、PR
- 闭源、黑盒、供应商绑定

### 与 Enloom 的关系
不构成直接竞争——它们做的是"完全替代你执行"，Enloom 做的是"给你一套协议让你管理执行过程"。

---

## 横向对比：Enloom 应该注意什么

### 最像 Enloom 理念的
- **Smithers**：durable workflow，但多了 JSX runtime
- **Millrace**：文件化 runtime ownership，和 Enloom 哲学最接近
- **Multi-Agent Orchestrator**：实用本地 worker 协调层

### Enloom 最不应该成为的
- **Ruflo**：什么都要，什么都可能是纸面声明
- **oh-my-openagent**：harness OS，绑定过深
- **Devin**：闭源黑盒

### Enloom 最应该保留的差异化
- **零运行时依赖**：其他工具都引入 daemon/SQLite/MCP server/worker 进程
- **文件协议透明**：人类可读、git diffable、跨 harness 可消费
- **风险评估为核心**：Registry 未闭合风险列表，竞品里几乎没有
- **证据合约硬度**：竞品强调 task 完成状态但很少强制 evidence four elements
