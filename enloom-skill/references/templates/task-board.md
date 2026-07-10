# Task Board

> 项目级入口表。一行一 Project。control agent 在 Orient 第一步读本表定位目标项目;任务详情进各项目的 `project_state.md`,不在此索引。
> 命名空间层的唯一全局文件——位于 `.enloom/task_board.md`(项目目录之外)。

| project | created | updated | phase | desc |
|---|---|---|---|---|
| example-project | 2026-06-29 | 2026-06-30 | v0.1 | 一句话简介 |

## 字段语义

- **project**:稳定标识,去重键。slug 形态(如 `enloom-dev`)。同名 Project 第二次进入据此复用已有目录。
- **created**:创建日期,**永不变**。决定项目目录名 `YYYY-MM-DD-<project>`。
- **updated**:最近一次进入该 Project 的日期。control agent 每次 Orient/Integrate 后更新。
- **phase**:当前阶段标签(自由文本,如 `v0.3.4` / `ingest` / `closed`)。`closed` 表示项目已闭合,行保留可查。
- **desc**:一句话简介。

## Resolver —— 两根定位（C10）

Resolver 输入是稳定 project slug（来自 `project` 列）。`task_board` 对每个 project **至多一行**。推导 `<created>-<project>` 后检查**恰好两个候选**：

- **active root**:`.enloom/<created>-<project>/`
- **archive root**:`.enloom/archive/<created>-<project>/`

搜索两根而非依赖 schema 列,使 fold 位置显式——closed 目录可能已被 fold 到 archive,也可能还在顶层。Resolver 返回**恰好一个 enum**;操作意图（`lookup|fold|reopen`）**不可绕过任何 error**。

完整优先级表（7 级,error 优先于 success）在 [archive-policy.md](../archive-policy.md) §Namespace Resolver。关键 error enum（任一命中 = blocking namespace error,MUST NOT 选/建 project）:

- `FOLD_MOVE_PARTIAL` — move 未完成/失败/post-state 与 intent 不符
- `PROJECT_DUPLICATE_ROW` — `rows > 1`
- `PROJECT_ORPHAN_ROOT` — 无行但存在 active 或 archive 目录
- `PROJECT_BOTH_ROOTS` — 单行 + 两根同时存在
- `PROJECT_MISSING_ROOT` — 单行 + 两根都不存在
- `PROJECT_OPERATION_INVALID` — base-shape/intent/predicate 无效组合（见 [archive-policy.md](../archive-policy.md) §Operation-intent 校验）

Success enum:`PROJECT_NEW`（无行无根 → 通过正常 gate 后创建一行/一目录）、`PROJECT_ACTIVE`（active 独存）、`PROJECT_FOLDED`（archive 独存）。

Resolver 示例:

| Case | task_board 行 | 候选状态 | 唯一结果 |
|---|---|---|---|
| N01 active | 一行:`project=alpha`,`created=2026-07-01` | active 存在;archive 不存在 | resolve `.enloom/2026-07-01-alpha/` |
| N02 folded closed | 同一唯一行,`phase=closed` | active 不存在;archive 存在 | resolve `.enloom/archive/2026-07-01-alpha/`(read-only,除非 reopen) |
| N03 reopen 同名 | 同 N02 行;用户请求 reopen | 仅 archive 存在 | control 移动精确目录回 active,保留 `created`,更新同一行 `updated/phase`,再 resolve active;不建 duplicate |

Negative signals:duplicate rows / both candidates / neither candidate with row / orphan directory without row —— 每个产生一个命名 blocking error,MUST NOT 选/建 project。

## 用法

- **Orient(Stage 1)** — control agent reads this:读本表 → 定位目标 project 行（用户指明 / 唯一活跃 / 最近 updated）→ 跑 C10 resolver（同时检查 `.enloom/<created>-<project>/` 和 `.enloom/archive/<created>-<project>/`）→ resolve 到唯一目录 → 读该项目的 `project_state.md`。**不要无条件**进入 active 根（`.enloom/<created>-<project>/`）——必须走 resolver,因为目录可能在任一根。
- **新项目**(`PROJECT_NEW`):无匹配行且无候选目录 → 建 `<今天>-<projectName>/` 目录 + 初始化 project_state.md + 在本表加一行（`created`=今天）。
- **复用**(`PROJECT_ACTIVE`):同名 project 已有行且 active root 存在 → 复用其目录,只更新 `updated`,不新建目录、不改 `created`。
- **Reopen**(`PROJECT_FOLDED` + `ALLOW_REOPEN`):folded 同名项目重新激活 → control 移动**精确目录**（`.enloom/archive/<created>-<project>/` → `.enloom/<created>-<project>/`）,**保留 `created`**,更新**同一行**的 `updated/phase`。**MUST NOT 创建 duplicate**（不新建行、不新建目录）。详见 [archive-policy.md](../archive-policy.md) §Reopen。
- **闭合**:phase 列标 `closed`,行不删（历史可查）。closed 项目目录会在堆积 ≥3 时由 `fold` 折叠到 `.enloom/archive/`（见 [archive-policy.md](../archive-policy.md) §Project Fold）。fold **只移目录,不改本表行**——两根 resolver 让路径变化对查找透明。

## 不要

- 不在本表索引任务/阶段（那是各项目 project_state 的 Active Tasks）。
- 不删行（用 `closed` 标记）。
- 不无条件假设项目在 active root——永远走 C10 两根 resolver。
