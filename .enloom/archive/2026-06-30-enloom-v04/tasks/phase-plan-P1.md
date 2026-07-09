# Phase Plan: P1 (契约层合并 —— 命名空间 + 落盘)

## Phase Goal

一次性改完 v0.4 的全部结构性契约文件(SKILL.md / workflow-steps / glossary / templates / 新增 landing-contract),涵盖命名空间(spec A 组)和落盘时序契约(spec D+E 组)。改完后,一个新用户按 skill 文档操作,会自然:建出 `.enloom/task_board.md` + 项目目录(命名空间),且每个 task 的 task.md/output.md/report.md 真实落盘、Stage 转移过闸门(落盘)。

引用层 B 组(scheduler-rules/task-packet/phase-plan/review-checklist/eval-guide/prompt-assets 的路径前缀)和产物层 C 组留给 P2/P3。

## Anti Goal

- 不改 Registry/Evidence/Ownership/Promise/Compaction 的内部语义,只改路径与住址描述。
- 不动 description 触发词覆盖。
- 不改引用层文件路径(B 组)——那是 P2。
- 不动产物层(README/PROGRESS/旧 dogfood)——那是 P3。
- 不引入真正的多进程隔离。

## Constraints

- 逻辑层零回归:七段、四要素、三态验收、三阶所有权、compaction 四步语义不变。
- 旧 `.enloom/project_state.md` 冻结留证,不迁移。
- 每个改动文件须能独立读懂(读者按需加载)。

## Strategy

**serial**。单 agent 串行扮演 control + worker。任务改动同一批契约文件且相互引用(landing-contract 定义闸门,workflow-steps 引用闸门,glossary 定义术语),非 disjoint,不满足并行写区前提(铁律 3)。串行集成区单线程符合默认。

## Ownership Table

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| 本项目 project_state.md + Registry | serial-integration zone | control agent (single-threaded) | Integrate |
| `enloom-skill/SKILL.md`、`references/workflow-steps.md`、`references/templates/*.md`、`references/glossary.md`、`references/registry-and-compaction.md`、`references/archive-policy.md`、`references/landing-contract.md`(新) | serial-integration zone(契约文件,全局唯一可变) | control agent 逐任务串行 | Execute |
| `design/*.md`、旧 `.enloom/project_state.md`(冻结)、`AgentOS/` 快照 | read-only zone | no one | All |

## Promise Registry Draft

无跨任务 forward declaration。各任务改既有文件或新建独立文件,不互相产出新标识符供对方引用。跳过。

## Tasks

合并 spec A+D+E 组,按文件聚合成 7 个任务:

- **P1-A** `SKILL.md` `## File Protocol`:整段替换为新目录树(加 task_board + 项目目录层);`For first use` 改「先建 task_board.md + 项目目录」。
- **P1-B** `SKILL.md` 新增 `## Landing Discipline` 段(或并入 File Protocol):收录闸门表精要 +「worker 产出必须落盘成文件」铁则 + 铁律 2/5 机械化一句。
- **P1-C** 新增 `references/landing-contract.md`:完整闸门表(7 Stage 入口/出口)+ 握手时序图 + 铁律 2/5 机械化说明。落盘机制单文件集中。
- **P1-D** `references/workflow-steps.md`:Stage 1 Orient 加「读 task_board 定位项目」首步 + 路径加项目前缀(行 42/66-69);每个 Stage 加「入口闸门/出口闸门」两行(引用 landing-contract);health-check 段升级为「Stage 转移硬闸门执行器」。
- **P1-E** `references/glossary.md`:新增 Project / task_board / Gate(闸门) / Landing(落盘)术语;澄清 project_state 现属项目内。
- **P1-F** `references/templates/`:新增 `task-board.md`(表头+注释+字段语义);`phase-plan.md` 的 gate check 段补「落盘闸门已确认」项。
- **P1-G** `references/registry-and-compaction.md` §1 开头 + `archive-policy.md`:注明 Registry/runs/archive 现住项目目录;archive 闭合条件加「Review Result 段已填」闸门(铁律 5 机械化)。

执行序:C(定义落盘协议)→ D(生命周期引用它)→ A/B(SKILL 入口)→ E(术语)→ F(模板)→ G(registry/archive)。同 agent 串行,无并发。

## Review Plan

Stage 4 Verify:
1. 逐文件核对改动符合 spec A+D+E 组描述。
2. grep 全包 `grep -rn "\.enloom/project_state"` —— 契约层应无残留裸路径(引用层 B 组文件本轮不改,允许残留,记入 Pending)。
3. grep 全包 `grep -rn "runs/<TASK>"` 确认新闸门引用一致。
4. Evidence Contract:checks_run=改动文件清单 + evidence=每个文件改动点 + blind_spots=B 组引用层未本轮覆盖。

## Human Decisions Needed

(无——spec 决策栈 1-9 已全部确认)

## Gate Check

- Phase goal is clear: **yes**
- Acceptance criteria are clear: **yes**(spec 第 4 节 #1/#5/#6/#7)
- Parallel ownership is defined if needed: **not-needed**(serial)
- Promise Registry drafted if forward declarations exist: **not-needed**(无)
- 落盘闸门已确认(本 phase-plan 自身遵守):**yes** —— 本文件已落盘于 tasks/phase-plan-P1.md。
