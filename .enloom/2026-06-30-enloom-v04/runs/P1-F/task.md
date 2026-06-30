# Task Packet: P1-F

Task Packet Version: 0.2
Mode: audited
Role: integrator

## Goal

(1) 新增 `references/templates/task-board.md`:task_board 骨架(表头 + 一行注释 + 字段语义说明 + Orient 用法提示)。(2) 改 `references/templates/phase-plan.md` 的 Gate Check 段:补「落盘闸门已确认」项。

## Anti Goal

- 不改 workflow-steps / SKILL / glossary(P1 其他任务)。
- 不重述 landing-contract(只引用)。

## Inputs

- SKILL.md File Protocol(task_board 结构)/ glossary(task_board 术语)。
- phase-plan.md 现有 Gate Check 段。

## Writable Files

- `references/templates/task-board.md`(新建)
- `references/templates/phase-plan.md`(改)

## Forbidden Files

- 其余 enloom-skill/ 文件 / project_state / design / 旧 .enloom

## Acceptance Criteria

- task-board.md 含表头 + 字段语义 + Orient 用法。
- phase-plan.md Gate Check 加「落盘闸门已确认:phase-plan 本文件已落盘 tasks/phase-plan-<phase>.md」。

## Done Signal

done + 改动点。
