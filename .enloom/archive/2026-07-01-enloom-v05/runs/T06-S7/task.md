# Task Packet: T06-S7

Mode: audited | Role: coder

## Goal

task-packet 三模式差异化字段表 + scheduler-rules mode 指引 + workflow-steps Stage 3 make-prompt 自检规则。audited 独立校验字段名随 S1 定性 = Claim Consistency。

## Acceptance Criteria

1. task-packet 含 mode-differentiated field 表;audited 行 Required Verification + Countable outputs 必填。
2. workflow-steps Stage 3 含 make-prompt 自检规则(audited 缺 RV/Countable 不准 dispatch)。
3. scheduler-rules 含 mode 约束密度指引。

## Countable outputs
3 文件改动(task-packet / workflow-steps / scheduler-rules)。

## Writable Files
- enloom-skill/references/templates/task-packet.md
- enloom-skill/references/workflow-steps.md
- enloom-skill/references/scheduler-rules.md

## Forbidden Files
.enloom/**; 其他 reference/template

## Done Signal
done + 路径。
