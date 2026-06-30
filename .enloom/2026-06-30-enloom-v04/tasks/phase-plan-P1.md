# Phase Plan: P1 (契约层改写)

## Phase Goal

把 v0.4 的项目级命名空间写进 skill 的契约层结构性文件:SKILL.md File Protocol、workflow-steps.md Orient、task-board 模板、glossary、registry-and-compaction/archive-policy 章节注释。让一个新用户按 skill 文档操作,会自然建出 `.enloom/task_board.md` + `.enloom/<日期>-<项目>/` 而非全局单状态。

## Anti Goal

- 不改 Registry/Evidence/Ownership/Promise/Compaction 的内部语义,只改它们引用的路径与「住址」描述。
- 不动 description 触发词覆盖。
- 不改引用层文件(scheduler-rules/task-packet/phase-plan/review-checklist/eval-guide/prompt-assets)——那是 P2。
- 不动产物层(README/PROGRESS/旧 dogfood)——那是 P3。

## Constraints

- 逻辑层零回归:七段、四要素、三态验收、三阶所有权、compaction 四步语义不变。
- 旧 `.enloom/project_state.md` 冻结留证,不迁移。
- 每个改动文件须能独立读懂(读者按需加载,不依赖一次全读)。

## Strategy

**serial**。单 agent 串行扮演控制面 + worker。理由:

1. 五任务改动的是同一批契约文件,边界相互引用(glossary 定义术语,workflow-steps/SKILL 引用术语)——非 disjoint,不满足并行写区前提。
2. 串行集成区(project_state/decisions)单线程,符合铁律 3 默认。
3. 改动量小、风险低,并行无收益、徒增协调开销。

无并行写 → 不强制 Ownership Table 并行区,但标注串行集成与只读区以守纪律。

## Ownership Table

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| `.enloom/2026-06-30-enloom-v04/project_state.md` + Registry | serial-integration zone | control agent (single-threaded) | Integrate |
| `enloom-skill/SKILL.md`、`references/workflow-steps.md`、`references/templates/*.md`、`references/glossary.md`、`references/registry-and-compaction.md`、`references/archive-policy.md` | serial-integration zone(契约文件,全局唯一可变) | control agent 逐任务串行 | Execute |
| `design/*.md`、旧 `.enloom/project_state.md`(冻结 dogfood)、`AgentOS/` 快照 | read-only zone | no one | All |

## Promise Registry Draft

无前向声明(P1 各任务改的是既有文件,不互相产出新标识符供对方引用)。跳过。

Reference-layer decision: 不适用(无跨任务 forward declaration)。

## Tasks

- **P1-A** SKILL.md `## File Protocol` 段:整段替换为新目录树(加 task_board + 项目目录层);`For first use` 改为「先建 task_board.md + 当前项目目录」。
- **P1-B** workflow-steps.md Stage 1 Orient(行 42/66-69):路径引用 `.enloom/project_state.md` → `.enloom/<project>/project_state.md`;首步加「读 task_board 定位项目」。
- **P1-C** 新增 `references/templates/task-board.md`:表头 + 一行注释 + 字段语义。
- **P1-D** glossary.md:新增 `Project`(顶层命名空间)、`task_board`(唯一入口表);澄清 `project_state` 现属项目内。
- **P1-E** registry-and-compaction.md §1 开头 + archive-policy.md:注明 Registry/runs/archive 现住项目目录;闭合条件路径加项目前缀。

依赖序:C(定义模板)→ A/B/E(引用结构)→ D(定义术语)。但实际可按 A→B→C→D→E 顺序逐个执行,因同 agent 无并发。

## Review Plan

Stage 4 Verify:逐文件核对改动符合 spec 第 2 节 A 组;再 grep 全包(`grep -rn "\.enloom/project_state"`)确认契约层无残留裸路径引用。Evidence Contract:checks_run=改动的文件清单 + evidence=每个文件改动点 + blind_spots=可能遗漏的引用。

## Human Decisions Needed

(无——spec 决策栈已全部确认)

## Gate Check

- Phase goal is clear: **yes**
- Acceptance criteria are clear: **yes**(spec 第 3 节验证标准 #1/#2/#5)
- Parallel ownership is defined if needed: **not-needed**(serial)
- Promise Registry drafted if forward declarations exist: **not-needed**(无)
