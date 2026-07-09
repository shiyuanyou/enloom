# 一、Skill / 插件 / Workflow 方法论竞品 · 中文详版

## 总览

这些工具的核心区别在于"方法论 discipline vs 运行时强制执行"。Enloom 最像"轻量控制面 + 文件协议"，下表梳理了 13 个主要项目。

| 项目 | 定位 | 状态落盘 | 并行 | 证据/验证 | 与 Enloom 的差异 |
|---|---|---|---|---|---|
| Superpowers | 跨 harness 通用开发方法论 | Plan docs | subagent/worktree | TDD/review 纪律 | 方法论强但状态/gate 轻 |
| oh-my-openagent | OpenCode 重型 agent OS | .omo ledger/config | Team Mode + parallel | harness 证据 | 大幅超越 skill，是 agent OS |
| PCP Skills | OpenCode 任务队列/backlog | .opencode/pcp events | 无 | 进度历史 | 窄但干净，无子任务执行 |
| fable-long-task | Claude Code 长任务命令 | docs/scripts | Workflow DSL | TDD + review 流水线 | 最像 Enloom 的"薄控制面" |
| longtaskforagent | 多会话 7 阶段流程 | feature-list/progress | 部分 | ATS/config/ST gates | 流程重，适合软件工程 |
| long-running-harness | Anthropic 模式轻量实现 | long_running/* | 无 | fresh evaluator default-fail | 最接近 Enloom 应借鉴的薄 harness |
| jons-plan | Claude Code 本地状态机 | .jons-plan | 有 | artifacts/dead-ends | 状态机重，但 artifact-first 好 |
| claude-workflow | spec→task graph→dispatch | YAML workflows | team mode | validation gates | 更像平台不是 skill |
| claude-corps | worktree 并行团队 | checkpoint + Linear | worktree 强 | PR/review | 强但依赖 Linear/git |
| claude-code-workflow-orchestration | hook 强制 delegation | .claude/state | wave scheduling | hook nudge | 理念好但移植性弱 |
| opencode-processing-skills | 文件协议 planning | plans/* docs | 部分 | review/digest | 文件协议范式最值得借鉴 |
| opencode-skills | 企业 Jira 集成 workflow | Jira/Confluence | wave parallel | ticket gate | 企业重，不适合轻项目 |

---

## 1. Superpowers

**GitHub**: `obra/superpowers`

### 定位
跨 Claude Code、Codex、OpenCode、Pi 等 harness 的通用开发方法论 skill collection。核心是让 agent 在写代码前先搞清楚要做什么，然后拆成小步执行。

### 核心流程
1. brainstorming: 先问需求，生成设计文档
2. using-git-worktrees: 创建隔离工作区
3. writing-plans: 拆成 2-5 分钟完成的小任务
4. subagent-driven-development: 每任务 new subagent + two-stage review
5. test-driven-development: RED-GREEN-REFACTOR
6. requesting-code-review: 按严重等级报告问题
7. finishing-a-development-branch: 验证测试、合并/PR

### 状态落盘
计划保存到 `docs/superpowers/plans/`。任务强调很小粒度（2-5 分钟完成），但缺少全局项目状态文件和风险清单。

### Subagent / 并行
强推 fresh implementer subagent per task；支持 parallel agents；有 `using-git-worktrees` skill。

### 证据机制
TDD、per-task review、whole-branch review、frequent commits——但都是 agent 自觉，不是运行时强制 gate。

### 局限性
- 是方法论不是 scheduler
- 跨会话状态、队列、证据 ledger 都较轻
- 没有"未闭合风险"清单
- agent 需要在每个 session 自己读取计划文件恢复上下文

### 对 Enloom 启发
- 小步计划 + fresh review 值得借鉴
- 但要补更明确的 project state、risk register、worker output contract
- "写代码前先问需求"的纪律可映射到 Enloom Triage 阶段

---

## 2. oh-my-openagent / oh-my-opencode

**GitHub**: `code-yeongyu/oh-my-openagent`

### 定位
面向 OpenCode/Codex/Pi 的重型 agent OS（不是 skill，是 harness OS）。Ultimate OpenCode edition 有 11 agents、54+ lifecycle hooks、Team Mode、ulw-loop、ultrawork、MCPs、hash-anchored edits。

### 核心能力
- 多个 discipline agents：Sisyphus（主协调）、Hephaestus（深度执行）、Prometheus（策略规划）
- Team Mode v4.0：lead + 最多 8 个并行 members，实时 tmux 可视化
- `ultrawork` / `ulw`：一键激活所有 agent
- Ralph Loop：持续直到 100% 完成
- Hash-Anchored Edit Tool：内容哈希防止编辑 stale-line 错误
- Skill-Embedded MCPs：skills 按需加载自己的 MCP server

### 状态落盘
ulw-loop 使用 `.omo/ulw-loop/brief.md`、`goals.json`、`ledger.jsonl`。Team specs 在 `~/.omo/teams/`。

### 局限性
- 配置极重，像安装一个 agent OS
- 强绑定 OpenCode
- 对复杂长任务可靠但引入许多运行时概念
- 不适合只需要"轻量文件协议"的场景

### 对 Enloom 启发
- 不要复制全套运行时
- 但可借鉴 `ledger.jsonl`（append-only event log）、evidence audit
- 任务状态的双层结构（JSON + Markdown）也值得参考

---

## 3. PCP Skills

**GitHub**: `JohnnyHua/pcp-skills`

### 定位
OpenCode 的 Progress Control Plane——只做 task queue + backlog + pivot + handoff。不是 subagent 调度器。

### 核心能力
- 13 个工具：pcp_init/plan/start/sub/done/pivot/status/handoff/capture/backlog/promote/dismiss/history
- 用户计划进入 pcp_plan(tasks)，当前任务 doing，其余 queued
- 中途想法用 pcp_capture 进 backlog
- 方向变化用 pcp_pivot
- 交接用 pcp_handoff

### 状态层
`.opencode/pcp/events.jsonl`（append-only）+ `stack.json`（当前状态缓存）+ `WORKLOG.md` + `HANDOFF.md`。events.jsonl 的设计很干净：只附加，不改写。

### 局限
- 能防止主线程丢任务，但不能保证实现质量
- 没有 subagent 执行模型
- 缺乏证据合约

### 对 Enloom 启发
- append-only event log + compact current state 双层结构非常好
- PCP 的窄范围恰恰是优势——task queue 小但可靠
- Enloom 可借鉴：全量研究任务包（V1-V4）+ 调度摘要任务包（精简）的"双轨分化"理念

---

## 4. fable-long-task

**GitHub**: `iopass4/fable-long-task`

### 定位
Claude Code `/long-task` 命令，来自真实的 Fable 5 大规模工程重写经验。核心是一个 human-gated pipeline + 可选的 Workflow() DSL TDD 脚本。

### 核心流程
强 human-gated，每步需要人工批准：需求澄清 → 设计 → 计划 → TDD 实现 + subagent assembly line。每个任务经过 implement → spec review → quality review → fix → re-review。

### 状态落盘
会生成 task prompt、plan、docs 等项目内文档。可选 `long-task-tdd.js` Workflow 脚本按批次推进（用 `agent()`、`phase()`、`pipeline()`、`parallel()` 等 DSL 函数）。

### 多层设计
核心 SOP 不需额外依赖即可运行。可选层：superpowers 技能 + Codex dual-model adversarial review。

### 对 Enloom 启发
- `DONE|{path}` worker contract 很好——worker 不把内容堆回上下文
- dual-model adversarial review 场景下，Enloom 的 reviewer 角色值得升格
- skill/插件兼容表（fable-long-task 可以接 superpowers 的各种技能）启发 Enloom 做 adapter 层

---

## 5. longtaskforagent

**GitHub**: `suriyel/longtaskforagent`

### 定位
13-skill 的多会话长任务 skill，支持 Claude Code + OpenCode。七阶段软件工程流程 + 质量门禁（覆盖 + mutation）。

### 七阶段
Requirements → UCD (if UI) → Design → ATS → Init → Worker Cycles → System Testing

每个 feature 经过 Orient→Bootstrap→Config Gate→Detailed Design→TDD→Quality→ST→Inline Check→Persist。

### 状态落盘
feature-list.json、task-progress.md、long-task-guide.md、docs/plans/*-srs/design/ats/ucd.md、docs/features/*.md。ATS 把每个 requirement 映射到 acceptance scenarios/test categories。

### auto_loop.py
核心自动循环脚本——重复调用 Claude Code 直到所有 active features 通过或终止条件满足。

### 局限
- 流程极重，进入成本高
- 小任务会被七阶段拖慢
- Codex 版本缺少 hooks 和 Claude Code 原生 subagent 能力
- 更适合正式软件工程，不适合混合域的长任务

### 对 Enloom 启发
- "阶段路由器"概念很好（bootstrap 检测状态，调用正确阶段）
- Feature status 概念可借鉴
- 但 Enloom 必须保留 triage，不把任何任务拖入重流程

---

## 6. long-running-harness

**GitHub**: `eddiearc/long-running-harness`

### 定位
Anthropic "long-running agent harness" 模式的轻量实现。最接近 Enloom 理念的项目。

### 两层设计
Phase 1: Initializer 创建 plan.md、feature_list.json、progress.txt、state.json、handoffs/。
Phase 2: 后续 session 按 Orient→Plan→Implement→Verify→Document 循环。

### Agent 分工
- Main agent: 规划者/指挥者
- Worker subagent: 实现单个 feature，写 handoffs/implementation.md
- Evaluator subagent: 验证 feature，写 handoffs/verification.md

### 关键原则
- 每个周期只做一个 feature
- evaluator 默认 fail，缺少证据就是不通过
- 不自动删除或修改 feature description，只更新 passes 状态

### 对 Enloom 启发
- 这和 Enloom 非常像：状态文件、handoff、fresh evaluator、default-fail
- 差异在于 Enloom 有更强的 Registry、Evidence Contract、Compaction Protocol
- 可以把它当作"轻量参照物"来校准 Enloom 的复杂度不超标

---

## 7. jons-plan

**GitHub**: `jonmmease/jons-plan`

### 定位
Claude Code 的本地状态机 + artifact system + hook + optional viewer 插件。

### 核心能力
- `/new`、`/plan`、`/proceed`、`/switch`、`/status` 等命令
- 多种 workflow：implementation、design、deep-implementation、iteration、code-review、PR review 等
- Planning Panel：Opus + Codex CLI 双 agent 并行规划，再由 senior architect synthesis
- artifact tracking、dead-end tracking、PreCompact hook

### 状态层
`.jons-plan/` 包含 active-plan、session-mode、workflow.toml、state.json、research-brief.md、dead-ends.json、claude-progress.txt。每个 phase 有 tasks.json。

### 局限性
- 依赖 Claude Code plugin 环境
- 复杂度明显高于 skill
- 对非 Claude Code harness 不友好
- 更像产品/平台，不是可移植协议

### 对 Enloom 启发
- artifact-first 和 dead-end tracking 值得借鉴
- PreCompact hook 做 continuity 保存
- Enloom 应避免变成 `.jons-plan` 级状态机，除非用户明确需要

---

## 8. claude-workflow

**GitHub**: `sighup/claude-workflow`

### 定位
把 spec-driven development、task graph、dispatch、validation 统一成一个 Claude Code 插件。

### 流程
research → spec → (gherkin) → plan → dispatch/dispatch-team → validate → review/review-team → testing

### 突出特点
- 每个 task 的元数据完整且自包含（spec_path、scope files、model、executor、dependencies）
- 7 validation gates + coverage matrix
- Concern-partitioned team review：每个 reviewer 从一个角度审同一组文件
- cw-worktree 能自动设置 task list ID 实现隔离

### 对 Enloom 启发
- Concern-partitioned review 可以丰富 Enloom reviewer 角色
- Task metadata 的完整性要求可以直接写入 worker task packet 格式
- Worktree 集成方式可作为 Enloom 外部 runtime adapter 的参考

---

## 9. claude-corps

**GitHub**: `josephneumann/claude-corps`

### 定位
worktree 为中心的并行 agent 框架。核心是 `/dispatch --count 3` 派多个 agent，`/auto-run` 自动循环直到 backlog 清空。

### 核心能力
- parallel + sequential 模式
- 每个 worker 写 session summary
- milestone review phase（迭代式 review-fix loop）
- 集成 Linear MCP 做任务跟踪

### 局限
- 强依赖 Linear / git / PR 流程
- 不适合没有外部 PM 系统的小项目
- 只负责执行，不负责上游规划

### 对 Enloom 启发
- Worktree 并行不是 Enloom 的默认目标，但 worker packet 可预留 isolation 字段
- auto-run 循环对 Enloom 的长时间任务参考意义大
- Enloom 更适合做"控制面告诉 worker 做什么"，claude-corps 是"帮 worker 安全地并行跑"

---

## 10. claude-code-workflow-orchestration

**GitHub**: `barkain/claude-code-workflow-orchestration`

### 定位
hook-based delegation enforcement：主 agent 被软约束不能直接干活，必须把复杂任务委托给专家 agent。

### 机制
- 软约束而非硬 block：按 silent→hint→warning→strong 逐轮升级
- lean SessionStart：stub orchestrator ~1.1KB，完整 orchestrator ~7.5KB 按需加载
- 支持 subagent mode + experimental team mode
- DONE|{path} 是 worker 返回格式

### 对 Enloom 启发
- DONE|{path} contract 和 lean/on-demand context 是两个非常好的设计
- 但 Enloom 不需要实现 hook enforcement——那是 Claude Code 专属的
- Enloom 应该定义输出文件契约，依赖 agent 自律 + 文件存在 gate 验证

---

## 11. opencode-processing-skills

**GitHub**: `DasDigitaleMomentum/opencode-processing-skills`

### 定位
OpenCode 的 structured docs + multi-session planning + gated implementation skill set。

### 核心协议
Discuss→Create Plan→Review Plan→Author Implementation Plan→Review Implementation Plan→Implement→Handover。产物目录在 `plans/<name>/`，包含 phases、implementation、reviews、todo、handovers。

### implementer 协议
BLUEPRINT→GATE→EXECUTE→DIGEST。先提示"你要做什么"，审过后再执行，从上下文清除实现细节，只保留 digest 作为交接证明。

### 对 Enloom 启发
- plan/phase/impl/review/handover 的文件协议路径命名非常干净
- BLUEPRINT→GATE→EXECUTE→DIGEST 四步和 Enloom worker dispatch 高度同构
- "digest-first handover" 就是 Enloom 需要的 worker report 设计

---

## 12. opencode-skills

**GitHub**: `farmage/opencode-skills`

### 定位
OpenCode adaptation of Claude Skills by jeffallan。66 skills + 9 workflow commands，偏企业研发。

### 工作流命令
/ common-ground → /discovery/create→synthesize→approve → /planning/epic-plan→impl-plan → /execution/execute-ticket→complete-ticket → /retrospectives/complete-epic→complete-sprint

### 对 Enloom 启发
- 执行前要求 Jira ticket 自包含（implementation steps, files, tests, AC）——缺失就 STOP
- 这个 gate 和 Enloom "task packet 不存在就不能 dispatch" 是同构的
- 企业集成部分 Enloom 短期不需要，但"ticket self-contained"的 checklist 可以直接借鉴

---

## 横向能力矩阵

| 项目 | 薄/重 | 状态落盘质量 | 子任务执行 | 证据硬度 | Enloom 匹配度 |
|---|---|---|---|---|---|
| Superpowers | 中 | plan 文件 | subagent | TDD 纪律 | 高（方法论互补） |
| oh-my-openagent | 极重 | .omo/ | 原生 team | harness 证据 | 低（不是同层） |
| PCP Skills | 薄 | events+stack | 无 | 历史 | 很高（append-only） |
| fable-long-task | 中 | docs/scripts | Workflow | TDD+pipeline | 高（human-gated） |
| longtaskforagent | 重 | feature/plans | 有限 | 质量门 | 中（流程重） |
| long-running-harness | 薄 | long_running/ | 有 | default-fail | 最高（最像） |
| jons-plan | 中 | .jons-plan/ | 有 | artifacts | 中（状态机） |
| claude-workflow | 中 | YAML files | team mode | validation | 中（平台感） |
| claude-corps | 中 | checkpoint+Linear | worktree 强 | PR/review | 中（并行） |
| workflow-orchestration | 中 | .claude/state | waves | hook nudge | 中（hook） |
| opencode-processing | 薄 | plans/ dir | 有 | review/digest | 很高（协议） |
| opencode-skills | 重 | Jira/Confluence | wave | ticket gate | 低（企业） |
