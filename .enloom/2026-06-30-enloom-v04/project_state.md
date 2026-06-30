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

**Phase: v0.4 全部完成(Close)** — P1 契约层 + P2 引用层 + P3 产物层全过。README/PROGRESS 反映 v0.4;旧 dogfood 冻结;全局重装源/装逐字节一致 + 结构合法。待最终归档 + 用户汇报。

## Accepted Results

> 顶层段(非 Registry 段)。累计已完成阶段的结论。

- **P1 契约层 done 2026-06-30**:落地 v0.4 双腿(命名空间 + 落盘时序契约)。新增 landing-contract.md(闸门表+时序图+铁律 2/5 机械化)+ task-board 模板;改 SKILL.md(File Protocol 新树 + Landing Discipline 段)/ workflow-steps(7 Stage 全闸门 + Orient task_board 定位 + health-check 硬闸门升级)/ glossary(4 术语)/ phase-plan(落盘 gate)/ registry+archive(项目目录 + Review Result 闸门)。conclusion: 铁律 2/5 与铁律 4 统一机械化,落盘契约成文;dogfood 自身 6 任务 task.md/output.md/report.md 全落盘,验证新机制可行。
- **P2 引用层 done 2026-06-30**:eval-guide.md 行 115/128 裸路径加 `<project>/` 前缀,全包裸 `.enloom/runs` 归零。conclusion: B 组文件相对路径形态在项目目录语境正确,无需改;引用层清零。
- **P3 产物层 done 2026-06-30**:README(Status/Two directories/目录树/Five Laws)+ PROGRESS(当前状态 v0.4)反映双腿;旧 dogfood 冻结确认未动;全局重装 25→27 文件,源/装逐字节一致 + quick_validate PASS。conclusion: v0.4 交付完整,全局可用。

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

(无 —— v0.4 三阶段全部完成)

### Broken References

> 发现的断引用:源 → 目标,状态,备注。← Orient 扫描。

(空)

### Known Exceptions

> 刻意保留的例外——白名单,不计为缺陷。

- 旧 `.enloom/project_state.md` + `runs/trigger-eval/`(23 git 跟踪文件)→ **冻结保留**,作 v0.3.3 单状态结构的历史证据,不迁移、不改。参见 spec 迁移策略。

### Accepted With Risk

> 已接受但带风险、需复检的项。← Orient 扫描。

- v0.4 未重跑 trigger-eval(description 未改,理论 20/20 仍有效,但 landing-contract 新增内容对 trigger 的间接影响未验证)。下次单独重跑拿 v0.4 基线。

### Rejected Reports

> 被拒报告索引——失败信号,防止重试同一路径。← Orient 扫描。

(空)

## Archived Phases

> 已压缩阶段索引。每阶段一行。

(空)

## Human Decisions Needed

(空)

## Next Review Point

P3 全包最终验证:全包 grep 无残留裸 `.enloom/<任何子目录>` + 全局重装后触发可用。
