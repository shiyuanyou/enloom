# Task Packet: P1-C

Task Packet Version: 0.2
Mode: audited
Role: integrator

## Goal

新建 `enloom-skill/references/landing-contract.md`——v0.4 落盘时序契约的单一权威文件。收录:(1) 完整闸门表(7 Stage 入口/出口,文件存在性);(2) 主流程↔worker 握手时序图(每步落盘);(3) 铁律 2/5 机械化升级说明(对齐铁律 4 标准);(4) 双保险执行规则(control 自检 + health-check 硬闸门)。

## Anti Goal

- 不改 workflow-steps / SKILL / glossary(那是 P1-D/E/A/B)。
- 不引入真正的多进程隔离(仍是文件协议上的协作)。
- 不重述 Evidence Contract / Ownership Table 的语义(只引用)。

## Inputs

- spec 第 2 节(闸门表 2.1 / 时序图 2.2 / 铁律机械化 2.3)—— 已在 `design/v0.4-project-namespace-spec.md`。
- workflow-steps.md 现有 Stage 结构(6 阶段 + 子动作)。
- evidence-contract.md(铁律 4 的机械化范例,2/5 对齐它)。

## Existing State

enloom 现有协议文件无 landing-contract。task-packet / worker-report 模板字段完整,但「谁、何时、写进哪个文件」从未成文。art_lab 实跑 tasks/runs 全空暴露此缺口。

## Allowed Tools

Read / Write / Edit / Bash(ls/test 验证文件存在性)。

## Writable Files

- `enloom-skill/references/landing-contract.md`(新建)

## Forbidden Files

- project_state.md / Registry 承载文件(本任务不改状态)
- workflow-steps.md / SKILL.md / glossary.md / templates/(P1 其他任务)
- design/ / 旧 .enloom/(只读)

## Output Files

- `enloom-skill/references/landing-contract.md`

## Acceptance Criteria

- 闸门表覆盖全部 7 Stage(0-6),每 Stage 有入口/出口闸门,闸门=文件存在性检查。
- 时序图展示 control→worker→disk 的完整握手,每步箭头是落盘(非上下文传递)。
- 铁律 2(dispatch 前 task.md 必存在)/ 铁律 5(archive 前 Review Result 段必填)机械化,对齐铁律 4 表述风格。
- 双保险规则明确:control 自检 + health-check 硬闸门,两处都跑。
- 文件可独立读懂(读者按需加载,不依赖一次全读)。

## Required Verification

- check_item:闸门表 7 Stage 完整,无遗漏 Stage。
- check_item:铁律 2/5 各有机械化表述(非陈述)。
- check_item:文件存在(落盘)。

## Evidence Required

落地后 ls 确认文件存在 + 内含闸门表/时序图/铁律段。

## Review Budget

只读 landing-contract.md 本身。

## Done Signal

返回 done + landing-contract.md 路径。
