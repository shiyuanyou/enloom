# Output: P1-AB

> 改动文件:`enloom-skill/SKILL.md`(2 段)。

## P1-A:File Protocol

- 目录树整段替换:v0.3.3 单状态树 → v0.4 命名空间树(task_board.md 入口表 + `<created>-<project>/` 项目目录层,内含 project_state/decisions/tasks/runs/archive/prompt-assets)。
- 加 namespace 说明:task_board 是入口点、每项目独立状态不混、同名项目复用(时间戳=创建日固定)。
- `For first use` 改:「先建 task_board.md + 当前项目目录 + project_state.md」。

## P1-B:Landing Discipline(新段)

- 收录两条 load-bearing rule:(1) 每 stage 转移是文件存在性闸门(举例 Stage 3 entry/exit)+ 双保险(control 自检 + health-check 硬闸门);(2) worker 产出落盘成文件,dispatch 交路径非口头。
- 铁律 2/5 机械化一句(dispatch 前 task.md 存在 / archive 前 Review Result 填),对齐铁律 4 标准。
- 引用 landing-contract.md 取全表。

## 验证

- description 行未改 ✓
- task_board 在 File Protocol(4 处)✓
- Landing Discipline 段存在 + landing-contract 引用 ✓
- SKILL.md 内无裸 `.enloom/project_state.md` ✓
