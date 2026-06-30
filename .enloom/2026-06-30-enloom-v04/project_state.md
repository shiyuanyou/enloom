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

**Phase: P1 planning(范围扩大后重做)** — spec 已从「只命名空间」扩为「命名空间 + 落盘时序契约」双腿。待用户 review 更新后的 spec,再重算阶段切分。

## Accepted Results

> 顶层段(非 Registry 段)。累计已完成阶段的结论。

(空)

## Registry

### Active Tasks

> 进行中任务,带状态。

| ID | Task | Status |
|----|------|--------|
| P1-A | SKILL.md File Protocol 段整段重写为新目录树 + For first use 改写 | pending |
| P1-B | workflow-steps.md Stage 1 Orient:加「读 task_board 定位项目」首步 + 路径加项目前缀(行 42/66-69) | pending |
| P1-C | 新增 templates/task-board.md 模板(表头+注释) | pending |
| P1-D | glossary.md:新增 Project / task_board 术语,澄清 project_state 现属项目内 | pending |
| P1-E | registry-and-compaction.md §1 开头 + archive-policy.md:注明 Registry/runs/archive 现住项目目录 | pending |

### Promised Outputs

> 前向声明但未交付的产出(Promise Registry)。

(空)

### Pending Dependencies

> 未满足的跨任务/跨阶段依赖。← Orient 扫描。

- 范围扩大(加落盘时序契约)后,原 P1 五任务分解过时,需 review 新 spec 后重做阶段切分。
- 待用户确认更新后的 v0.4 spec。

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
