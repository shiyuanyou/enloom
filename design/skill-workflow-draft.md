# AgentOS Skill Workflow 草案 v0.1

日期：2026-06-15

目标：先把 AgentOS V2 做成一个轻量 workflow skill 的可运行草案。不要平台化，不做复杂 CLI，不接管普通任务。先靠文件协议和 prompt 纪律跑起来，边用边调。

## 核心定位

AgentOS skill 是一个按需进入、按需退场的控制面。

它只在任务足够复杂时介入，负责：

- 判断是否值得进入 AgentOS。
- 把复杂目标压成当前阶段目标。
- 生成 Worker task packet。
- 控制 Worker 上下文、权限和输出格式。
- 用 report 优先的方式 review。
- 把结论压缩进 project state。
- 把过程材料归档，然后退出。

它默认不编码、不深读所有 raw、不长期持有 Worker 上下文。

## 借鉴 superpowers 的方式

不照搬 `brainstorming` 那种“所有任务都必须设计审查”，也不照搬 `systematic-debugging` 的完整 debug 流程。

只借三件事：

1. **硬门禁**：某些条件没满足，就不能进入下一步。
2. **阶段顺序**：先定义目标和验收，再派 Worker，再 review。
3. **失败升级**：连续失败不是继续重试，而是回到任务包或架构假设。

AgentOS 的语气应该是：普通任务放行，复杂任务收束。

## 五条铁律

### 1. No AgentOS Without Trigger

如果任务能直接做，就直接做。

进入 AgentOS 需要至少满足以下两项：

- 预计超过 3 个阶段。
- 需要 2 个以上 Worker 或角色。
- 需要跨会话状态。
- 需要 review / archive / 复盘。
- 上下文可能膨胀到影响判断。
- 任务产物会成为长期资产。

不满足时，只做轻量 triage，不创建文件。

### 2. No Worker Without Task Packet

没有完整 task packet，不派 Worker。

最小 task packet 必须包含：

- Goal
- Anti Goal
- Inputs
- Allowed Tools
- Writable Files / Forbidden Files
- Output
- Acceptance Criteria
- Review Budget
- Done Signal

### 3. No Parallel Without Ownership

没有文件所有权表，不并行写任务。

允许并行：研究、只读分析、写独占产物。

默认串行：集成、更新 project_state、更新 decisions、修改共享文件。

### 4. No PASS Without Evidence

Review 不能只看 Worker 自称完成。

PASS 必须包含：

- 执行了哪些验证。
- 证据是什么。
- 哪些没有验证。
- 有哪些已知风险。

没有证据的 PASS 一律降级为 `needs-rework`。

### 5. No Archive Without State Update

任务归档前必须完成：

- report 已 review。
- project_state 已更新。
- decisions 已更新，若有关键决策。
- registry 已更新，若有 pending / promised / failed。
- raw notes 已归档或声明丢弃。
- 下一步明确。

## 最小目录协议

第一版只需要这些文件。没有必要一开始做工具层。

```text
AgentOS/
  project_state.md
  decisions.md
  tasks/
    T001.md
  runs/
    T001/
      task.md
      output.md
      report.md
      raw-notes.md        # 可选，默认不读
  archive/
    task-history.md
  prompt-assets/
    researcher.md
    coder.md
    reviewer.md
```

如果项目还没有这些文件，AgentOS 第一次进入时只创建最小集合：`project_state.md`、`tasks/`、`runs/`。`prompt-assets/` 可以后续沉淀，不急。

## Workflow 总览

```text
0. Triage
   ↓
1. Orient
   ↓
2. Plan Current Phase
   ↓
3. Make Task Packet
   ↓
4. Dispatch Worker
   ↓
5. Review Report
   ↓
6. Integrate State
   ↓
7. Archive / Exit
```

第一版可以手动跑，不需要自动 scheduler。

## Step 0: Triage

### 目标

判断当前请求是否值得进入 AgentOS。

### 输入

- 用户当前请求。
- 已知项目状态，若已经有 `project_state.md`。

### 输出

三选一：

- `direct`：直接做，不进 AgentOS。
- `light-plan`：只给一个简短计划，不创建文件。
- `agentos`：进入完整 workflow。

### 门禁

如果是单文件改动、明确 bug fix、一次性脚本、直接问答，默认 `direct`。

## Step 1: Orient

### 目标

读取最小必要状态，让主窗口快速恢复判断。

### 默认读取顺序

1. `AgentOS/project_state.md`
2. `AgentOS/tasks/` 当前任务
3. `AgentOS/decisions.md`
4. 最近一个相关 `runs/*/report.md`

默认不读：

- raw logs
- raw notes
- Worker 完整过程
- 无关旧任务

### 输出

一段 5-10 行的 current state summary。

## Step 2: Plan Current Phase

### 目标

只规划当前阶段，不把整个项目一次性规划死。

### 输出格式

```markdown
## Phase Goal

## Anti Goal

## Constraints

## Strategy
serial | parallel | hybrid

## Tasks
- T001 ...
- T002 ...

## Review Plan

## Human Decisions Needed
```

### 门禁

如果当前阶段目标说不清，不派 Worker。

如果需要并行，必须先写文件所有权表。

## Step 3: Make Task Packet

### 目标

把一个任务变成 Worker 可以独立执行、Review 可以低成本验收的契约。

### 模板

```markdown
# Task Packet: T001

Task Packet Version: 0.1
Mode: emergent | recorded | audited
Role: researcher | coder | reviewer | integrator | tester

## Goal

## Anti Goal

## Inputs

## Existing State

## Allowed Tools

## Writable Files

## Forbidden Files

## Output Files

## Acceptance Criteria

## Required Verification

## Evidence Required

## Review Budget

## Pending / Promise Registry Updates

## Human Decision Gate

## Done Signal
```

### Mode 选择

- `emergent`：快速探索，中间材料可丢弃。
- `recorded`：关键中间材料落盘。
- `audited`：必须跑验证命令，适合高风险或共享产物。

默认：长期项目用 `recorded`，高风险修改用 `audited`。

## Step 4: Dispatch Worker

### 目标

调用 Pi / sub-agent / 当前 agent 执行 task packet。

### 规则

- Worker 只能在 task packet 边界内发挥智能。
- Worker 可以提出建议，但不能改写 project goal。
- Worker 不能擅自修改 forbidden files。
- Worker 如果发现任务包不完整，应返回 `blocked`，不要自行扩大范围。

### 并行规则

并行只适合这些任务：

- 只读研究。
- 独占文件写入。
- 多方案比较。

并行不适合这些任务：

- 多个 Worker 写同一文件。
- 更新全局状态。
- 依赖链没定清。
- Review Budget 不够。

## Step 5: Review Report

### 目标

用最小阅读量判断 Worker 结果是否可合并。

### 默认读取顺序

1. `runs/T001/report.md`
2. `runs/T001/output.md`，仅当 report 证据不足
3. `runs/T001/raw-notes.md`，仅当失败、高风险、或复盘需要

### Worker Report 模板

```markdown
## Result

## Files Changed

## Evidence

## Verification
- checks_run:
- passed:
- failed:
- not_run:

## Known Blind Spots

## Risks

## Registry Updates

## State Update

## Next
```

### Review 结论

- `accepted`：通过，可合并状态。
- `accepted-with-risk`：可推进，但风险写入 project_state。
- `needs-rework`：不合并，要求补证据或返工。
- `rejected`：不可用，归档为失败样本。

### 门禁

Required Verification 没跑，不能 `accepted`。

High severity issue 未解释，不能 `accepted`。

## Step 6: Integrate State

### 目标

把 review 结论压缩进长期状态，而不是把过程塞回主窗口。

### 更新对象

- `project_state.md`：当前真相。
- `decisions.md`：影响后续的关键决策。
- `tasks/`：未完成任务。
- registry：pending / promise / failed / known exception。

### project_state 建议结构

```markdown
# Project State

## Goal

## Current Phase

## Active Tasks

## Accepted Results

## Open Risks

## Pending Registry

## Human Decisions Needed

## Next Review Point
```

## Step 7: Archive / Exit

### 目标

AgentOS 完成当前阶段后退场。

### 归档条件

- task packet 存在。
- output/report 存在。
- review result 存在。
- state update 已合并。
- open risks 已转为任务或风险。
- 过程材料在 `runs/` 或 `archive/`，不进入主窗口。

### 退出输出

AgentOS 最终只向用户汇报：

- 当前阶段完成了什么。
- 验收结论。
- 还剩什么风险。
- 下一步是什么。

## Failure Protocol

### Worker blocked

如果 Worker 说任务包不完整：

1. Control Skill 补 task packet。
2. 不读取无关 raw docs。
3. 重新派发。

### Worker failed once

补充 evidence 或缩小任务。

### Worker failed twice

重写 task packet，检查 Goal / Anti Goal / Inputs / Acceptance Criteria。

### Same phase failed three times

暂停执行，生成 `assumption-review.md`，重新评估目标或架构。

## Health Check v0

先做只读检查，不做自动修复。

检查项：

- Active task 是否都有 task packet。
- runs 是否缺 report。
- report 是否缺 review result。
- project_state 是否记录了未验收结果。
- pending / promise 是否长期未处理。
- review budget 是否被突破。
- prompt 临时改动是否值得沉淀进 prompt-assets。

## 第一版 skill 操作菜单

真正写成 `SKILL.md` 时，先暴露这些操作：

- `triage`：判断是否进入 AgentOS。
- `plan`：生成当前阶段计划。
- `make-prompt`：生成 Worker task packet。
- `review`：审查 Worker report。
- `archive`：闭合任务并更新状态。
- `health-check`：只读检查状态漂移。

不要第一版就做自动 scheduler。

## v0.1 使用方式

下一次遇到复杂任务时这样用：

1. 先让 AgentOS 做 `triage`。
2. 如果进入，创建或读取 `project_state.md`。
3. 只规划当前阶段。
4. 为第一个 Worker 生成 task packet。
5. 执行后只读 report 做 review。
6. 更新 state。
7. 阶段完成后 archive，并退出 AgentOS。

## 先不做的事

- 不做常驻后台。
- 不做自动模型选择。
- 不做复杂 DAG 引擎。
- 不做无限 sub-agent 嵌套。
- 不做全自动修复。
- 不强制所有任务都进入 AgentOS。

## 下一步可调点

先用这个草案跑 1-2 个真实任务，再调整：

- Trigger 是否过度触发。
- Task Packet 是否太重。
- Review Budget 是否真能省上下文。
- Worker 是否能在边界内发挥智能。
- Registry 是否足够少而有用。
- Archive 是否真的让主窗口退场。
