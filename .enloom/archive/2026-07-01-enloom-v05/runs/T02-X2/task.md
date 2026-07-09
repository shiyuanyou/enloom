# Task Packet: T02-X2

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Honest Blind Spot 从 1 项扩为 3 项(isolation / cross-role / virtual parallelism),scheduler-rules 回写盲区标记,worker-report 模板对齐。

## Acceptance Criteria

1. evidence-contract §Honest Blind Spot 含三项声明。
2. scheduler-rules.md「单 agent 会话的现实」附近有架构盲区回写标记 + 指向 evidence-contract。
3. worker-report Known Blind Spots 段对齐三项(明示列表)。

## Writable Files
- enloom-skill/references/evidence-contract.md
- enloom-skill/references/scheduler-rules.md
- enloom-skill/references/templates/worker-report.md

## Forbidden Files
- .enloom/**; 其他 reference/template

## Done Signal
done + 路径。
