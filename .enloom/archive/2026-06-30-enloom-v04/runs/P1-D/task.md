# Task Packet: P1-D

Task Packet Version: 0.2
Mode: audited
Role: integrator

## Goal

改 `references/workflow-steps.md`:(1) Stage 1 Orient 首步加「读 task_board.md 定位项目」;(2) 现有 `.enloom/project_state.md` 等路径引用改为 `.enloom/<project>/project_state.md`(行 42/66-69);(3) 每个 Stage(0-6)加「入口闸门 / 出口闸门」两行,引用 landing-contract;(4) health-check 段从「周期性 drift detector」升级为「stage-transition 硬闸门执行器」。

## Anti Goal

- 不改 SKILL.md / glossary / templates / registry+archive(P1 其他任务)。
- 不动铁律 1/3/4 的语义表述(只接线 landing-contract 到生命周期)。
- 不重述 landing-contract 的闸门表(只引用链接)。

## Inputs

- references/workflow-steps.md(现有 6 阶段结构)。
- references/landing-contract.md(P1-C 产出,闸门表权威)。
- spec 第 1 节(Orient 流程改写)+ 第 2 节(落盘)。

## Existing State

workflow-steps.md 行 42「Existing .enloom/project_state.md」、行 66-69 引用裸路径;无 task_board 定位步骤;无 stage 闸门;health-check(行 216-232)是周期性 drift detector。

## Allowed Tools

Read / Edit / Bash(grep 验证)。

## Writable Files

- `references/workflow-steps.md`

## Forbidden Files

- project_state.md / Registry
- SKILL.md / glossary.md / templates/ / landing-contract.md(已定稿)/ registry-and-compaction.md / archive-policy.md
- design/ / 旧 .enloom/

## Output Files

- `references/workflow-steps.md`(改后)

## Acceptance Criteria

- Stage 1 Orient 第 1 步是「读 task_board.md 定位项目」,后续读项目目录内文件。
- 行 42/66-69 路径加 `<project>/` 前缀,无残留裸 `.enloom/project_state.md`(workflow-steps 内)。
- 7 Stage(0-6)各有入口/出口闸门引用(指向 landing-contract §1)。
- health-check 段表述升级为 stage-transition 硬闸门 + 保留周期性 drift 检测职责。

## Required Verification

- check_item:Orient 首步为 task_board 定位。
- check_item:workflow-steps 内 grep `\.enloom/project_state` 无残留裸路径(应有 `<project>` 前缀)。
- check_item:7 Stage 各有闸门引用。

## Evidence Required

改后 grep 输出 + 关键段内容。

## Review Budget

只读 workflow-steps.md 改动段。

## Done Signal

done + 改动点清单。
