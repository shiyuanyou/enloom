# AgentOS V2 Skill 参考与补充思路

日期：2026-06-15

这份笔记用于给 `AgentOS V2` 做 skill 设计参考。它不是最终方案，而是把当前公开 skill 生态、本地已安装 skill、以及一些容易漏掉的 workflow 设计点压缩到一个本地参考文件里，方便后续继续沉淀成真正的 `SKILL.md`。

## 结论先行

AgentOS V2 的方向是对的：它更像一个按需触发的 workflow skill，而不是常驻框架或插件系统。

从现有 skill 生态看，直接命中“长任务调度 + worker task packet + review budget + project state”的成熟 skill 不多。值得参考的不是某一个完整实现，而是几个成熟 skill 的设计纪律：

- `skill-creator`：借鉴 skill 生命周期、progressive disclosure、eval 迭代。
- `agent-customization`：借鉴 skill / prompt / custom agent / instructions 的选择边界。
- `llm-wiki`：借鉴 raw source / compiled state / schema 这类分层知识治理。
- `brainstorming`：借鉴阶段门禁和用户确认，但不要照搬“所有任务都必须设计审查”。
- `systematic-debugging`：借鉴失败阈值、根因优先、停止继续乱试的协议。
- `improve-codebase-architecture`：借鉴统一词汇表、并行产出多方案、最后集中 review。
- `find-skills`：借鉴质量筛选规则和 skill 发现路径。

一句话：AgentOS V2 可以把这些模式合成一个“上下文治理 + worker 调度 + review 压缩”的 workflow skill。

## 已验证的重点参考

### 1. skill-creator

- 来源：`anthropics/skills`
- 安装量：约 269.6K
- GitHub stars：约 150.7K
- 链接：https://www.skills.sh/anthropics/skills/skill-creator
- 安装命令：

```bash
npx skills add https://github.com/anthropics/skills --skill skill-creator
```

可借鉴点：

- 把 skill 创建视为一个生命周期，而不是一次性写文件。
- 先捕获 intent：触发场景、输入输出、成功标准、是否需要 eval。
- 使用 progressive disclosure：`SKILL.md` 保持短，复杂模板放到 `references/`。
- 为 skill 准备 realistic test prompts，用有 skill / 无 skill 对比质量。
- 评估触发准确率，而不只是评估输出内容。

对 AgentOS 的启发：

- AgentOS 的第一版不应该只写 workflow 说明，还应该准备一组 eval prompt。
- Eval 不一定要复杂，至少要覆盖：复杂任务进入 AgentOS、简单任务不进入 AgentOS、worker report 不合格时 review 拒绝、并行条件不满足时保持串行。
- `description` 是触发面。AgentOS 的 description 必须同时写清“Use when”和“Do NOT use when”，否则容易过度触发。

### 2. agent-customization

- 来源：VS Code / Copilot 本地 workflow skill
- 本地位置：VS Code 内置 customization skill
- 链接：无公开 skills.sh 页面，本地已可参考

可借鉴点：

- 它有一个很清晰的 primitive 决策表：instructions、prompt、skill、custom agent、hook、MCP 各自什么时候使用。
- 它明确指出 skill 适合“按需 workflow + bundled assets”。
- 它把常见坑写得很直接：description 是发现面、YAML frontmatter 容易静默失败、全局 applyTo 会烧上下文。

对 AgentOS 的启发：

- AgentOS 不一定要把所有东西都做成 skill body。
- 推荐形态是：
  - `SKILL.md`：只放控制流程和触发条件。
  - `references/`：放任务包模板、review checklist、scheduler rules。
  - `agents/` 或 `prompt-assets/`：放 researcher / coder / reviewer 等 worker prompt 模板。
  - 可选 custom agents：当确实需要工具限制或上下文隔离时再使用。

### 3. llm-wiki

- 来源：本地已安装 skill
- 链接：本地 `/Users/bigo/.agents/skills/llm-wiki/SKILL.md`

可借鉴点：

- 它把知识库分成 raw sources、compiled wiki、schema 三层。
- 它要求 operation log，且把 ingest / query / lint / log 明确分成操作。
- 它强调“好回答可以回填到知识库”，让产物持续复利。
- 它有 lint 概念：死链、孤页、索引不一致、过大页面、陈旧内容。

对 AgentOS 的启发：

- AgentOS 也可以有自己的三层：
  - raw：worker raw notes、logs、未压缩过程材料。
  - state：`project_state.md`、`decisions.md`、`tasks/`。
  - schema：AgentOS skill、task packet 模板、report 模板、review checklist。
- `archive` 之外还应该有轻量 `lint` 或 `health-check`，专门检查文档膨胀、未关闭任务、缺少 report、project_state 太长、decisions 没有结论。

### 4. brainstorming

- 来源：`obra/superpowers`
- 安装量：约 222.5K
- GitHub stars：约 227.8K
- 链接：https://www.skills.sh/obra/superpowers/brainstorming
- 安装命令：

```bash
npx skills add https://github.com/obra/superpowers --skill brainstorming
```

可借鉴点：

- 它把“先设计、再实现”写成强流程门禁。
- 它要求在实现前呈现设计并获得确认。
- 它反对未经检查的“这太简单了，不需要设计”。

对 AgentOS 的启发：

- AgentOS 可以借鉴“门禁”，但不能照搬它的绝对规则。
- 更适合的门禁是复杂度门禁：
  - 简单任务：直接做。
  - 长任务、多 worker、跨模块、高不确定性任务：先进入 AgentOS plan。
- 对长期项目来说，用户确认点应该放在：阶段目标、任务拆解、worker 任务包、验收标准，而不是每一步细节。

### 5. systematic-debugging

- 来源：`obra/superpowers`
- 安装量：约 144.1K
- GitHub stars：约 227.8K
- 链接：https://www.skills.sh/obra/superpowers/systematic-debugging
- 安装命令：

```bash
npx skills add https://github.com/obra/superpowers --skill systematic-debugging
```

可借鉴点：

- 四阶段流程：证据收集、模式分析、假设测试、实现验证。
- 没有根因前不允许修。
- 多次失败后停止继续打补丁，转向重新质疑架构或假设。

对 AgentOS 的启发：

- Worker 失败不是简单重试。
- AgentOS 应该有失败协议：
  - 第一次失败：要求 worker 补 evidence 或缩小任务。
  - 第二次失败：调整任务包或验收标准。
  - 第三次失败：暂停调度，进入 architecture / assumption review。
- 这能防止长任务后期“调度者已经不清醒但还在持续派工”。

### 6. improve-codebase-architecture

- 来源：`mattpocock/skills`
- 安装量：约 259.0K
- GitHub stars：约 129.1K
- 链接：https://www.skills.sh/mattpocock/skills/improve-codebase-architecture
- 安装命令：

```bash
npx skills add https://github.com/mattpocock/skills --skill improve-codebase-architecture
```

可借鉴点：

- 先定义严格词汇表，避免概念漂移。
- 用多个并行子 agent 产出不同设计，再由主流程 review。
- 输出 RFC 风格文档，包含问题、取舍、建议。

对 AgentOS 的启发：

- AgentOS 需要自己的 glossary，并坚持使用同一组词。
- 例如：Control Skill、Prompt Asset、Task Packet、Worker、Report、Review Budget、Project State、Archive、Done Signal。
- 并行 worker 不应该只为速度服务，也可以用于“多方案探索”，但必须提前声明 review budget。

### 7. find-skills

- 来源：`vercel-labs/skills`
- 安装量：约 2.0M
- GitHub stars：约 22.4K
- 链接：https://www.skills.sh/vercel-labs/skills/find-skills
- 安装命令：

```bash
npx skills add https://github.com/vercel-labs/skills --skill find-skills
```

可借鉴点：

- 先查 leaderboard，再用 CLI 搜索。
- 不只看搜索结果，要看安装量、来源信誉、GitHub stars、安全审计。
- 搜索不到高质量 skill 时，不强行推荐。

对 AgentOS 的启发：

- AgentOS 自己也应该有“是否值得进入流程”的质量门槛。
- 不是所有复杂感强的任务都值得进入 AgentOS。判断标准应该包括：任务长度、上下文膨胀风险、worker 隔离收益、review 成本、是否需要归档复用。

## 可看但暂不建议直接安装的样本

这些是 CLI 搜索到的结果，可以作为样本观察，但不建议现在直接依赖。

### agent workflow 搜索

命令：

```bash
npx skills find agent workflow
```

结果摘要：

- `ruvnet/ruflo@agent-workflow`：932 installs，低于 1K，但仓库 stars 较高。可看事件驱动 workflow 表达方式。
- `sickn33/antigravity-awesome-skills@ai-agent-development`：524 installs。
- `webmaxru/agent-skills@github-agentic-workflows`：185 installs。
- `ruvnet/claude-flow@agent-workflow`：80 installs。
- `oimiragieo/agent-studio@workflow-creator`：67 installs。
- `moonbitlang/skills@moonbit-agent-guide`：63 installs。

判断：这个方向还没有很强的公开标准样本。AgentOS 的差异化空间比较大。

### prompt engineering 搜索

命令：

```bash
npx skills find prompt engineering
```

结果摘要：

- `aradotso/trending-skills@agency-agents-ai-specialists`：1.8K installs。
- `farmage/opencode-skills@prompt-engineer`：94 installs。
- `thedesignproject/agent-skills@prompt-engineer`：26 installs。

判断：安装量较低，且可能偏通用 prompt 技巧，不一定适合 AgentOS 的 workflow 协议。

### project planning / writing plans 搜索

命令：

```bash
npx skills find project planning
npx skills find writing plans
```

结果摘要：

- `project planning` 方向多为几十到一百多 installs。
- `plan-writing` 方向最高约 664 installs。

判断：可作为低优先级样本，不建议作为 AgentOS 第一版核心参考。

## AgentOS V2 可能还可以补的点

### 1. Trigger Contract 要独立成设计对象

现在设计里已经有“什么时候使用 / 不使用”，但真正做成 skill 时，触发描述会变成系统最重要的入口。

建议把 trigger contract 独立写成一节：

- Use when：大型探索、多阶段研发、多 worker、需要 review 压缩、需要状态归档。
- Do NOT use when：单文件改动、明确 bug fix、一次性脚本、无需长期状态的问题。
- Ambiguous case：先问一个问题或直接轻量 plan，不要立刻创建完整目录。

可以考虑给 AgentOS 一个“轻触发模式”：只输出 3-5 行判断和是否进入 AgentOS，不创建任何文件。

### 2. Skill Body 要短，模板下沉到 references

不要把完整 worker 模板、report 模板、scheduler 规则都塞进 `SKILL.md`。

建议：

```text
agentos-control/
  SKILL.md
  references/
    trigger-contract.md
    task-packet-template.md
    report-template.md
    review-checklist.md
    scheduler-rules.md
    archive-policy.md
    eval-guide.md
  prompt-assets/
    researcher.md
    architect.md
    coder.md
    reviewer.md
    tester.md
  evals/
    evals.json
```

`SKILL.md` 只负责：判断是否进入、选择操作、读取必要 reference、执行当前动作。

### 3. Worker Task Packet 需要版本号

长期迭代后，任务包格式会变。建议从第一版就加版本号。

示例：

```markdown
Task Packet Version: 0.1
Task ID: T001
Role: researcher
Goal:
Anti Goal:
Input:
Allowed Tools:
Output:
Acceptance Criteria:
Review Budget:
Done Signal:
```

好处：

- 旧任务包可追溯。
- Prompt assets 改版时不会混淆。
- Review 可以知道自己面对的是哪一版契约。

### 4. Review Budget 不只是长度限制，而是路由规则

可以把 review budget 写成可执行的阅读顺序。

建议格式：

```markdown
Review Budget:
  Required:
    - runs/T001/report.md <= 120 lines
  Optional:
    - runs/T001/output.md <= 300 lines, only if report evidence is insufficient
    - runs/T001/raw-notes.md, only if review fails or risk is high
  Do Not Read By Default:
    - raw logs
    - inner subagent transcripts
```

这比单纯写“控制 review 成本”更稳定。

### 5. Worker 权限需要按角色分级

AgentOS 的 worker prompt 里可以明确角色权限。

示例：

- Researcher：只读仓库和资料，不改文件，输出 `research.md` 和 `report.md`。
- Architect：可写设计文档，不改生产代码。
- Coder：只改 task packet 允许的路径。
- Tester：可运行测试，可新增测试，不随意修业务逻辑。
- Reviewer：只读产物，输出通过 / 不通过 / 需要补证据。

这比只写 `Allowed Tools` 更贴近实际执行。

### 6. 加入 Failure Protocol

长任务真正危险的不是失败，而是失败后继续扩大上下文、继续派工。

建议规则：

- 一个 worker 缺证据：退回补 report，不吞 raw notes。
- 一个任务失败 2 次：Control Skill 必须重写 task packet。
- 一个阶段失败 3 次：停止执行，生成 `assumption-review.md`。
- Review 成本超过预算：停止并要求压缩，不继续读取更多过程材料。

### 7. 加入 State Compaction Protocol

`project_state.md` 不能只是越来越长的总结。

建议固定结构：

```markdown
# Project State

## Goal

## Current Phase

## Known Decisions

## Active Tasks

## Blockers

## Latest Accepted Results

## Next Review Point
```

规则：

- 每次 review 只追加或替换对应小节。
- 过期细节移入 archive。
- `project_state.md` 目标是 3 分钟读完。
- 如果超过约 200 行，触发 compaction。

### 8. 加入 AgentOS Health Check

可以先不做复杂工具，但 workflow 里应该有健康检查概念。

检查项：

- 是否有 active task 没有对应 task packet。
- 是否有 runs 缺 `report.md`。
- 是否有 report 没有验收结论。
- 是否有 project_state 记录了未验收结果。
- 是否有 raw notes 被直接复制进 project_state。
- 是否有 tasks 已完成但未归档。
- 是否有 review budget 被多次突破。
- 是否有 worker prompt 被临场大改但未回收进 prompt assets。

### 9. Prompt Asset 要有 Change Log

既然 prompt 要成为资产，就需要记录为什么改。

建议每个 prompt asset 顶部保留简短 metadata：

```markdown
Prompt Asset: researcher
Version: 0.1
Last Updated: 2026-06-15
Purpose: bounded research worker for AgentOS tasks
Change Log:
  - 0.1: initial template
```

不要把完整任务历史写进去，只写 prompt 本身的设计变化。

### 10. Eval 要覆盖“不触发”

很多 workflow skill 的问题不是做不好，而是过度触发。

AgentOS eval 至少应该包含：

1. 复杂研发任务：应该进入 plan。
2. 简单 bug fix：应该直接做，不创建 AgentOS 目录。
3. 一次性脚本：应该直接写脚本，不进入 workflow。
4. 多 worker 但强依赖任务：应该选择 serial。
5. worker report 缺 evidence：review 应该 fail。
6. output 太长：review 应该要求 report 压缩，而不是默认吞全文。

### 11. Glossary 可以减少概念漂移

建议固定术语，尤其长期设计讨论时很有用。

- Control Skill：按需触发的控制流程。
- Task Packet：给 worker 的任务契约。
- Worker：短生命周期执行单元。
- Prompt Asset：可复用 worker prompt 模板。
- Report：worker 给 review 的压缩结论。
- Raw Notes：可追溯但默认不读的过程材料。
- Review Budget：review 方允许读取的材料和成本。
- Project State：当前项目压缩状态。
- Archive：已闭合任务的过程材料。
- Done Signal：worker 完成后的明确标记。

### 12. 并行不是策略，而是例外优化

你原文已经写了这一点。可以继续具体化成判断表：

允许并行：

- 输入互不依赖。
- 输出能独立验收。
- 每个 report 足够短。
- 合并结果有清晰规则。

禁止并行：

- 一个任务输出会改变另一个任务输入。
- 需要共享同一文件写入。
- review 方无法在预算内审完所有结果。
- 当前阶段目标本身还没定清。

### 13. Archive 需要定义“闭合”

可以把阶段闭合标准写得更机械一点：

- 有 task packet。
- 有 output。
- 有 report。
- 有 review result。
- project_state 已更新。
- decisions 已更新，若有关键决策。
- raw docs 已归档，不在主窗口继续展开。

任何一个缺失，就不能 archive。

## AgentOS Skill 第一版建议动作

你原文提出 `plan / make-prompt / review / archive` 四个动作很合适。可以考虑加一个只读动作：`health-check`。

推荐第一版动作：

1. `triage`：判断是否进入 AgentOS。
2. `plan`：生成阶段目标、任务拆解、串并行策略。
3. `make-prompt`：根据 prompt assets 生成 task packet。
4. `review`：读取 report，必要时抽样 output，输出验收结果。
5. `archive`：闭合任务并压缩状态。
6. `health-check`：检查文档膨胀、未闭合任务、状态不一致。

如果要继续保持更小 MVP，可以把 `triage` 合并进 `plan`，把 `health-check` 留到第二版。

## MVP SKILL.md 骨架草案

下面只是骨架，不是最终 skill。

```markdown
---
name: agentos-control
description: "Use when: managing large exploratory tasks, long-running projects, multi-stage research or development, multi-worker coordination, task packet generation, review compression, project state updates, or workflow archiving. Do NOT use for single-file edits, simple bug fixes, one-off scripts, direct Q&A, or tasks that do not need persistent state."
---

# AgentOS Control

AgentOS is an on-demand workflow skill for keeping long agent tasks coherent.
It does not replace normal work. It enters only when the task is complex enough
that planning, worker isolation, review compression, and state archival create
clear value.

## Operations

Choose exactly one operation for the current user request:

- triage: decide whether AgentOS should enter.
- plan: create current phase goal, anti-goal, constraints, tasks, and strategy.
- make-prompt: generate a worker task packet from prompt assets.
- review: evaluate worker report and output against acceptance criteria.
- archive: close accepted tasks and update project state.
- health-check: inspect AgentOS files for drift and bloat.

## Default Rule

If the task can be directly completed with low context risk, do it directly.
Only enter AgentOS when it reduces context growth or improves review quality.

## Read Order

1. project_state.md
2. current task packet
3. relevant report.md
4. output.md only if needed
5. raw notes only if review fails or evidence is insufficient
```

## 建议下一步

如果继续推进，建议不要马上做完整平台，先做一个 workspace draft：

```text
AgentsOS/
  skill-draft/
    SKILL.md
    references/
      trigger-contract.md
      task-packet-template.md
      report-template.md
      review-checklist.md
      scheduler-rules.md
      archive-policy.md
    prompt-assets/
      researcher.md
      architect.md
      coder.md
      reviewer.md
      tester.md
    evals/
      evals.json
```

第一轮只需要验证三件事：

- 它会不会在简单任务中过度触发。
- 它生成的 task packet 是否真的能让 worker 独立执行。
- 它的 review 是否真的只读 report 就能判断大部分任务。

这三件事跑通后，再考虑 CLI、自动归档、Pi 集成或更复杂的 scheduler。
