# Project State · enloom-v04

> 本项目是新结构的首个 dogfood 样本:用 v0.4 协议(项目级命名空间)实现 v0.4 本身。
> 目标 3 分钟读、<200 行。Registry 七段是活性真相,compaction 时优先保留。

## Goal

v0.4 修 enloom 实跑暴露的两块缺口:(1) 项目级命名空间 + (2) 落盘时序契约。详见 [design/v0.4-project-namespace-spec.md](../../design/v0.4-project-namespace-spec.md)。

- (1) 命名空间:`.enloom/` 改为 task_board 入口表 + 每项目一目录。
- (2) 落盘:每 Stage 加入口/出口闸门(文件存在性)+ 主流程↔worker 握手时序图 + 铁律 2/5 机械化。根因:art_lab 实跑 tasks/runs 全空,中间状态从未落盘。

## Anti Goal

- 不引入 CLI / scheduler / runtime(守 v0.3 Non-Goals 线)。
- 不改 Registry / Evidence / Ownership / Promise / Compaction 的内部语义。
- 不做跨项目状态聚合(task_board 只索引项目,不碰任务)。
- 不动 description 触发词覆盖。
- 不引入真正的多进程隔离(仍单/多 agent 在文件协议上协作)。

## Current Phase

**Phase: P1 已完成,待 Close** — 契约层 7 任务全过(命名空间 A + 落盘 D+E 合并)。Stage 4 验收通过:8 契约文件 0 残留裸路径、landing-contract 引用一致、dogfood 自身 6 任务全落盘。待 Stage 6 归档。

## Accepted Results

> 顶层段(非 Registry 段)。累计已完成阶段的结论。

- **P1 契约层 done 2026-06-30**:落地 v0.4 双腿(命名空间 + 落盘时序契约)。新增 landing-contract.md(闸门表+时序图+铁律 2/5 机械化)+ task-board 模板;改 SKILL.md(File Protocol 新树 + Landing Discipline 段)/ workflow-steps(7 Stage 全闸门 + Orient task_board 定位 + health-check 硬闸门升级)/ glossary(4 术语)/ phase-plan(落盘 gate)/ registry+archive(项目目录 + Review Result 闸门)。conclusion: 铁律 2/5 与铁律 4 统一机械化,落盘契约成文;dogfood 自身 6 任务 task.md/output.md/report.md 全落盘,验证新机制可行。

## Accepted Results

> 顶层段(非 Registry 段)。累计已完成阶段的结论。

(空)

## Registry

### Active Tasks

> 进行中任务,带状态。

| ID | Task | Status |
|----|------|--------|
| P1-A | SKILL.md File Protocol:整段替换为新目录树 + For first use 改写 | ✅ completed |
| P1-B | SKILL.md 新增 Landing Discipline 段 | ✅ completed |
| P1-C | 新增 references/landing-contract.md | ✅ completed |
| P1-D | workflow-steps.md:Orient task_board + 7 Stage 闸门 + health-check 升级 | ✅ completed |
| P1-E | glossary.md:4 新术语 + Project State 更新 | ✅ completed |
| P1-F | templates/:task-board.md 新增 + phase-plan gate 补项 | ✅ completed |
| P1-G | registry-and-compaction §1 + archive-policy:项目目录 + Review Result 闸门 | ✅ completed |

### Promised Outputs

> 前向声明但未交付的产出(Promise Registry)。

(空)

### Pending Dependencies

> 未满足的跨任务/跨阶段依赖。← Orient 扫描。

- **P2(引用层 B 组)待办**:eval-guide.md 行 115/128 残留 2 处裸 `.enloom/runs/<TASK>/`,需改 `.enloom/<project>/runs/<TASK>/`。其余 B 组文件(scheduler-rules/task-packet/worker-report/review-checklist/prompt-assets)经 grep 无残留裸路径,但需复核 Forbidden files 列表是否需项目前缀意识。
- P3(产物层 C 组)依赖 P1+P2:README/PROGRESS 描述需与最终结构一致。

### Broken References

> 发现的断引用:源 → 目标,状态,备注。← Orient 扫描。

(空)

### Known Exceptions

> 刻意保留的例外——白名单,不计为缺陷。

- 旧 `.enloom/project_state.md` + `runs/trigger-eval/`(23 git 跟踪文件)→ **冻结保留**,作 v0.3.3 单状态结构的历史证据,不迁移、不改。参见 spec 迁移策略。

### Accepted With Risk

> 已接受但带风险、需复检的项。← Orient 扫描。

(空)

### Rejected Reports

> 被拒报告索引——失败信号,防止重试同一路径。← Orient 扫描。

(空)

## Archived Phases

> 已压缩阶段索引。每阶段一行。

(空)

## Human Decisions Needed

(空)

## Next Review Point

P1 执行完进 Stage 4 Verify:grep 全包确认无残留裸 `.enloom/project_state.md` 路径引用。
