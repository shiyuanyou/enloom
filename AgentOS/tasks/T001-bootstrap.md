# Task Packet: T001

Task Packet Version: 0.1
Mode: recorded
Role: integrator

## Goal

建立 AgentOS 自举工作区的最小骨架,让后续 T002–T006 能在协议内派发。产出 `agentos/AgentOS/` 下的 `project_state.md`、`decisions.md`、`tasks/`、`runs/`、`archive/`,以及本任务 packet。

## Anti Goal

- 不写 skill 产物(SKILL.md / references / prompt-assets 是 T002–T004 的范围)。
- 不做全局安装(D2)。
- 不预先写 architect/tester 角色资产(D4)。
- 不在 repo root 建 sibling `AgentOS/`(大小写碰撞风险)。

## Inputs

- `agentos/agentos-workflow-skill/SKILL.md`(File Protocol:71-93)
- `agentos/PROGRESS.md`(deferred 项 + 已知风险)
- 已批准的计划(版本 v0.2 / 真自举 / 范围 / 不全局安装)

## Existing State

- 工作区目录已建:`AgentOS/tasks`、`AgentOS/runs`、`AgentOS/archive`(空)。
- v0.1 skill 完整,工作树干净。

## Allowed Tools

- 文件读写(Write/Edit/Read)
- 只读 Bash(ls/mkdir)

## Writable Files

- `AgentOS/project_state.md`
- `AgentOS/decisions.md`
- `AgentOS/tasks/T001-bootstrap.md`
- `AgentOS/runs/T001/*`

## Forbidden Files

- `agentos-workflow-skill/` 下任何文件(T002–T004 范围)
- `README.md`、`PROGRESS.md`(T006 范围)
- repo root 任何文件
- 其他项目的任何文件

## Output Files

- `AgentOS/project_state.md`
- `AgentOS/decisions.md`
- `AgentOS/tasks/T001-bootstrap.md`
- `AgentOS/runs/T001/report.md`

## Acceptance Criteria

- `AgentOS/` 下有 project_state + decisions + tasks/T001 + runs/T001/report。
- project_state.md 结构符合 v0.1 模板(Goal/Current Phase/Active Tasks/Accepted Results/Open Risks/Pending Registry/Promises/Failed/Known Exceptions/Human Decisions/Next Review Point)。
- decisions.md 记录 D1–D5 五条已定决策。
- 不触碰 Forbidden Files。

## Required Verification

- `find agentos/AgentOS -type f | sort` 列出预期文件。
- `git status` 确认改动只在 `agentos/AgentOS/`。

## Evidence Required

- 文件清单 + git status 输出。

## Review Budget

- Required: 本 packet + `runs/T001/report.md`(≤60 行)
- Optional: 无

## Pending / Promise Registry Updates

- 无(Pending Registry 保持空)

## Human Decision Gate

- 无(已通过 plan 批准)

## Done Signal

返回 `done` + 列出产出路径。Review 结论写进 `runs/T001/report.md`。
