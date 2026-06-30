# Archive Entry: P1 (契约层合并)

Date: 2026-06-30
Review Result: accepted

## Completed

v0.4 契约层 7 任务全过,落地双腿(命名空间 + 落盘时序契约)的全部结构性文件:

- 新增 `references/landing-contract.md`(闸门表 7 Stage + 握手时序图 + 铁律 2/5 机械化)。
- 新增 `references/templates/task-board.md`(项目级入口表模板)。
- 改 `SKILL.md`(File Protocol 新目录树 + Landing Discipline 段)。
- 改 `references/workflow-steps.md`(Orient task_board 定位 + 7 Stage 全闸门 + health-check 硬闸门升级)。
- 改 `references/glossary.md`(Project/task_board/Gate/Landing 4 术语 + Project State 更新)。
- 改 `references/templates/phase-plan.md`(落盘 gate 项)。
- 改 `references/registry-and-compaction.md`(§1 项目目录注记)。
- 改 `references/archive-policy.md`(Review Result 闸门 + 项目前缀)。

## Outputs

8 个文件改动(2 新增 + 6 改),全在 enloom-skill/ 契约层。

## Evidence

- V1:8 契约文件 grep `\.enloom/project_state\.md` 全 0 残留。
- V4:dogfood 自身 6 任务目录(P1-C/D/AB/E/F/G)各含 task.md/output.md/report.md,Review Result 段全填 PASS——**落盘契约的活样本**。
- V5:landing-contract 在 5 个引用文件中共 10 处引用,一致。

## Verification

- checks_run: V1(残留裸路径)/ V2(landing-contract 存在)/ V3(task-board 模板存在)/ V4(落盘)/ V5(引用一致)/ V6(P2 残留)/ V7(旧 dogfood 冻结)
- passed: V1-V5, V7
- failed: (无)
- not_run: (无)

## Decisions Updated

(无独立 decisions.md 写入;关键决策已在 spec 决策栈 1-9)

## Project State Updated

✓ Current Phase → P1 已完成;Accepted Results 加 P1 结论;Active Tasks 全标 completed;Pending Dependencies 加 P2 eval-guide 残留。

## Registry Updates

Pending Dependencies 加 P2 引用层待办(eval-guide 2 处裸路径)。无 broken/rejected。

## Open Risks Carried Forward

- P2 引用层:eval-guide.md 2 处裸 `.enloom/runs/<TASK>/` 待改项目前缀。
- 单 agent 会话的闸门仍靠自律 + health-check 双保险,无外部强制器(Non-Goals 约束,已知)。

## Raw Material Handling

6 任务的 task.md/output.md/report.md 落盘于 runs/<TASK>/,不进主窗口。归档后保留(本 dogfood 是新结构首个样本)。

## Next Step

P2(引用层 B 组):eval-guide 路径修复 + 其余引用文件 Forbidden 列表项目前缀复核。
