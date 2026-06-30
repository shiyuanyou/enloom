# Task Packet: P1-AB

Task Packet Version: 0.2
Mode: audited
Role: integrator

## Goal

改 `enloom-skill/SKILL.md` 两处:(A)`## File Protocol` 段整段替换为 v0.4 新目录树(task_board.md 入口表 + 每项目 `<created>-<project>/` 目录),`For first use` 改「先建 task_board.md + 项目目录」;(B)新增 `## Landing Discipline` 段,收录闸门表精要 + 「worker 产出必须落盘成文件」铁则 + 铁律 2/5 机械化一句,引用 landing-contract。

## Anti Goal

- 不改 workflow-steps / glossary / templates(P1 其他任务)。
- 不改 description 触发词覆盖(frontmatter description 不动)。
- 不重述闸门表全文(只精要 + 引用)。

## Inputs

- SKILL.md 现有 File Protocol(行 81-105)。
- landing-contract.md(P1-C)/ spec 第 1 节目录结构 + Orient 流程。

## Existing State

File Protocol 是 v0.3.3 单状态目录树(无 task_board、无项目目录层)。无 Landing Discipline 段。

## Allowed Tools

Read / Edit / Bash(grep)。

## Writable Files

- `enloom-skill/SKILL.md`

## Forbidden Files

- project_state.md / Registry
- workflow-steps.md / glossary.md / templates/ / landing-contract.md / registry+archive
- design/ / 旧 .enloom/

## Output Files

- `enloom-skill/SKILL.md`(改后)

## Acceptance Criteria

- File Protocol 目录树含 task_board.md + `<created>-<project>/` 项目目录层。
- `For first use` 改为「先建 task_board.md + 项目目录」。
- 新增 Landing Discipline 段:闸门精要 + 落盘铁则 + 铁律 2/5 机械化一句 + landing-contract 引用。
- description frontmatter 不变。

## Required Verification

- check_item:File Protocol 含 task_board。
- check_item:Landing Discipline 段存在。
- check_item:description 行未改。

## Evidence Required

改后 grep 输出。

## Done Signal

done + 改动点。
