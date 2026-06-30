# Task Packet: P1-E

Task Packet Version: 0.2
Mode: recorded
Role: integrator

## Goal

改 `references/glossary.md`:新增 v0.4 术语段——`Project`(顶层命名空间)、`task_board`(唯一入口表)、`Gate / 闸门`(stage 文件存在性检查)、`Landing / 落盘`(worker 产出落盘成文件);澄清 `Project State` 现属项目目录内。补「不要混用的词」一条:不把 task_board 叫「任务列表」(它只索引项目)。

## Anti Goal

- 不改 workflow-steps / SKILL / templates(P1 其他任务)。
- 不重述闸门表(只定义术语 + 引用)。

## Inputs

- glossary.md 现有结构(核心术语 + v0.3 新增 + 不要混用)。
- landing-contract.md / SKILL.md File Protocol(术语来源)。

## Writable Files

- `references/glossary.md`

## Forbidden Files

- 其余 enloom-skill/ 文件 / project_state / design / 旧 .enloom

## Acceptance Criteria

- 新增 v0.4 术语段:Project / task_board / Gate / Landing 四词。
- Project State 含义更新为「项目目录内的状态」。
- 「不要混用」加 task_board 一条。

## Done Signal

done + 新增条目。
