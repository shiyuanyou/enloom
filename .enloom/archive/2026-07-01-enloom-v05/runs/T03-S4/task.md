# Task Packet: T03-S4

Mode: audited | Role: coder

## Goal

health-check 拆两档:轻量档(Stage 转移时只跑文件存在性,单行确认)+ 完整档(Orient + 定期 Verify,九项全量)。

## Acceptance Criteria

1. workflow-steps Health Check 段含两档 + 触发条件;九项检查保留但标为完整档。
2. landing-contract §4 health-check 执行方式含轻量档说明。

## Writable Files
- enloom-skill/references/workflow-steps.md
- enloom-skill/references/landing-contract.md

## Forbidden Files
.enloom/**; 其他 reference/template

## Done Signal
done + 路径。
