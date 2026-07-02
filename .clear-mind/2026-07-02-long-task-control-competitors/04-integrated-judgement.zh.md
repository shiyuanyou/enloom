# 四、整合判断与策略方向

## 核心裁决：CONDITIONAL

Enloom 值得继续做，但必须保持尖锐定位：**最轻但最可靠的长任务控制协议**。

## 竞品给我们的五条关键教训

### 1. 状态不落地 = 不存在
Temporal、Smithers、Millrace、LangGraph 都在说同一件事：完成步骤后立刻落盘到 runtime-owned store。Enloom 的 Landing Contract 已经做了这件事，但需要更系统化——不只是文件存在，还要校验文件内容指向的 evidence 是否可解析。

### 2. 记忆写入需要治理
agent-memory 的 staged update（proposal→human review diff→apply/reject）和 episodic-memory 的 revision chain（错了不直接改，supersede 后出新版本）是竞品中最优秀的治理模型。Enloom 当前 agent 直接改 project_state.md——应该考虑对 Registry 高风险修改引入 diff 审批机制。

### 3. ContextOS 的 continuation pack 抽象非常实用
下一个 session 不需要读完整 project_state.md 和历史档案。需要的是 300-800 token 的代理专用包：当前阶段、未闭合风险、必须先读的文件、下一步安全动作。

### 4. 并行安全的正确方向是"先分析再派工"
CCPM 的 analysis.md（scope、files、can start、conflict risk）和 BMAD 的 owned file scope + waves + handoff-manifest 都在说：parllel safe ≠ just spawn agents，parllel safe = 一个显式的所有权和冲突 DAG。

### 5. 上下文管理应分两层
DCP 处理 chat transcript pruning（发给 LLM 前的投影），Enloom 的 Compaction Protocol 处理 project_state compaction（长期归档）。两者解决不同问题，不应混在一起。

## 策略方向（按优先级）

### 方向一：强化已有的差异化（立即能做）
- Registry 的未闭合风险列表——这是竞品几乎没有的
- Evidence Contract 的硬度——竞品大多靠 agent 自觉，Enloom 有 PASS/ISSUES/FAIL + 四要素
- Landing Contract（worker output 必须落盘的文件存在性 gate）——竞品里只有 fable-long-task 的 DONE|{path} 和 opencode-processing-skills 的 GATE 类似

### 方向二：加薄 CLI / 脚本层（短期能做）
学习 CCPM 和 Task Master：status、next、blocked、validate-gates 命令由确定性的 bash/Node 脚本完成，不烧 LLM token。

### 方向三：project_state 结构化（中期）
借鉴 Project Butler 的三层分离 + agent-memory 的 section IDs + episodic-memory 的 revision chain。让 project_state.md 的每个 section 有稳定 ID，Registry 条目支持 superseded 状态。

### 方向四：外部 adapter（中期）
定义 Enloom 到外部系统的干净接口：
- 输出 handoff-manifest.json（借鉴 BMAD）
- 对接 Task Master / Spec Kit / CCPM 的 task 格式
- 对接 Smithers / Multi-Agent Orchestrator / Millrace 的 runtime adapter

### 方向五：continuation pack（短期）
Orient 阶段生成轻量恢复包，学习 ContextOS。点出当前阶段、阻塞风险、下一安全动作，让其他工具/agent 能在第一分钟接手。

## 不做的事

- 不做 agents/harness OS（保持差异化）
- 不做 runtime daemon 或 scheduler（允许外部 runtime adapter，不在内部实现）
- 不做模型路由或 provider 适配（让用户自己选 agent 和 model）
- 不做 web dashboard 或可视化（保持文件协议纯度）
- 不做一个"万能长任务工具"

## 一句话产品定位

> Enloom 是长任务控制协议：阶段状态、风险清单、任务包、文件所有权、证据闸门、归档纪律——用 Markdown 做可审计接口，用 adapter 接你已有的运行时。
