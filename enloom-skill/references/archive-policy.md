# Archive Policy

archive 是闭合。没有闭合,不算完成。闭合标准机械化,逐条核对。

## 闭合条件(全部满足才能 archive)

> 所有路径均在项目目录内(`.enloom/<created>-<project>/`)。

- [ ] task packet 存在。
- [ ] output 和 report 存在。
- [ ] `review-result.md` 存在(RA3:verdict + conclusion 是 control 写的独立文件,不在 `report.md` 内)。
- [ ] **每个 task 的 `review-result.md` 已存在**(铁律 5 机械化:archive 前 health-check 硬验此条——见 [landing-contract.md](landing-contract.md) §3)。无 `review-result.md` → 不准 archive。
- [ ] project_state 已更新(压缩结论,不是 raw 过程)。
- [ ] decisions 已更新(若有关键决策)。
- [ ] **registry 风险区段已处理**(铁律 5 扩展):open risks 已转为 active task、known risk 或 accepted exception;broken references 已解决或登记;rejected reports 已索引。具体四个风险区段(Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports)逐项确认状态。
- [ ] raw 材料已归档或声明丢弃(进 `runs/` 或 `archive/`,不进主窗口)。
- [ ] **compaction 触发检查**:若 project_state 超阈值(>200 行 / Accepted Results >10 / Orient 读不完),archive 前先跑一次 [Compaction Protocol](registry-and-compaction.md),保证退出时 state 干净。

任一缺失,不能 archive(铁律 5)。

## 归档输出

用 [templates/archive-entry.md](templates/archive-entry.md)。条目含:Completed / Outputs / Evidence / Verification / Decisions Updated / Project State Updated / Registry Updates / Open Risks Carried Forward / Raw Material Handling / Next Step。

## 主窗口退场

archive 后,control 只向用户汇报:
- 当前阶段完成了什么。
- 验收结论。
- 还剩什么风险。
- 下一步是什么。

不汇报 raw 过程、不复述日志、不粘贴大段 evidence。

## 状态压缩

project_state 不能只是越来越长的总结。每次 review 只追加或替换对应小节;过期细节移入 archive。

compaction 是完整 [Compaction Protocol](registry-and-compaction.md) §4:触发条件(>200 行 / Accepted Results 阈值 / 可读性)→ 四步流程(扫描 → 迁移 → 收口 → 校验)→ 防错规则(**压缩前后 registry 四个风险区段条目数只能持平或减少,仅当 genuinely resolved;否则回滚**)。

核心原则:**压缩的是已闭合的过程细节,绝不压缩未闭合风险。** Registry 七区段是活性真相,compaction 时优先保留。

## Project Fold（项目级折叠）

上面的闭合条件都是 **phase 级**（归档 `archive/<phase>-entry.md`）。Project Fold 是**项目级**：整个 closed 项目目录退出工作区。

### 触发时机（C04：post-decision，非 pre-triage）

Project Fold 发生在 Stage 0 Triage 决定 `enloom` **之后**，且仅在 `enloom` 路径才运行。`direct` / `light-plan` 退出 Enloom，不触发 fold。

- **Stage 0 Triage 是 side-effect-free**：不做任何写文件、不 dispatch agent、不移动目录。Triage 只决定 `direct | light-plan | enloom`。
- 只有 `enloom` 决定后，control（namespace 的串行 owner）才读取 `task_board`、应用 C10 resolver、对符合 fold 条件的 closed 顶层项目执行 fold，然后进入 Orient。
- Fold 与 Orient 串行——不并发。

触发条件(全部满足):
- task_board 中该项目 phase = closed。
- 该项目目录仍在 `.enloom/` 顶层(未折叠)。
- `.enloom/` 顶层 closed 项目 ≥ 3 个(堆积阈值)。

### Fold 是 control-owned 串行操作（C04）

Fold 是 control 直接执行的串行 namespace 操作，**不派 sub-agent**。Fold 只做目录移动，**不修改 task_board 行**（行已标 `closed`，`project` 列用名字索引；两根 resolver 让路径变化对查找透明——见 §Namespace Resolver）。

Fold 与 phase-close 不自动绑定——phase 标 `closed` 只是标记，fold 是独立的 post-decision workspace-hygiene 动作。下次新请求进入 Stage 0 Triage + six-stage lifecycle (Stages 1–6) 时，若 Triage 返回 `enloom`，control 在进入 Stage 1 Orient 前按需 fold（详见 [workflow-steps.md](workflow-steps.md) §Stage 0）。

### Namespace Resolver —— 两根定位（RA4）

Resolver 输入是稳定 project slug。`task_board` 对每个 project 至多一行；推导 `<created>-<project>` 后检查恰好两个候选：`.enloom/<created>-<project>/`（active root）和 `.enloom/archive/<created>-<project>/`（archive root）。搜索两根而非依赖 schema 列，使 fold 位置显式。

Resolver 按以下优先级返回**恰好一个 enum**。设 `rows` = 匹配的 task_board 行数，`A` = active root 存在，`R` = archive root 存在。操作意图（`lookup|fold|reopen`）**不可绕过任何 error**。

| Precedence | Predicate | Resolver result | Effect |
|---:|---|---|---|
| 1 | `.enloom/fold-move-state.md` non-complete、move 失败、或 post-state 与记录 intent 不符 | `FOLD_MOVE_PARTIAL` | hard block Orient/fold/reopen；仅进入 recovery |
| 2 | `rows > 1` | `PROJECT_DUPLICATE_ROW` | hard block；不选择任一根 |
| 3 | `rows = 0` 且 `(A or R)` | `PROJECT_ORPHAN_ROOT` | hard block 创建；报告两个候选路径 |
| 4 | `rows = 1` 且 `A and R` | `PROJECT_BOTH_ROOTS` | 在任何 move（含 reopen）前 hard block |
| 5 | `rows = 1` 且 `not A` 且 `not R` | `PROJECT_MISSING_ROOT` | hard block；MUST NOT 创建同名项目 |
| 6 | `rows = 0` 且 `not A` 且 `not R` | `PROJECT_NEW` | 通过正常 gate 后创建恰好一行/一目录 |
| 7 | `rows = 1` 且 `A xor R` | `PROJECT_ACTIVE` 或 `PROJECT_FOLDED` | resolve 唯一路径；reopen 仅从 FOLDED，fold 仅从 ACTIVE + closed/threshold 谓词 |

### fold-move-state.md 快照协议（RA4）

在任何 fold/reopen move 之前，control **必须**写 `.enloom/fold-move-state.md`，包含：operation ID、action、有序 targets、匹配行 identity、active/archive pre-snapshot、intended post-state、`status=prepared`。

每次 move 后更新 completed targets 并验证两个候选根。任何 move 失败、unexpected candidate state、或中断的 non-complete marker，**必须**立即设为 `FOLD_MOVE_PARTIAL`，停止 batch，block Orient。后续行不再移动。

**Recovery 是 control-owned 且显式的**：比对 durable snapshot，选择 (a) 恢复精确 pre-state 或 (b) 完成记录的 intended state，验证每行恰好一个候选，记录证据，然后清除 marker。在此之前，优先级表始终返回 `FOLD_MOVE_PARTIAL`；不允许自动 first-path 选择或静默 retry。

### Operation-intent 校验（RA4.2）

namespace/transaction error（优先级 1–5）求值完成后，只有当这些 predicate 全为 false，control 才将 base shape 分类为 `PROJECT_NEW`、`PROJECT_ACTIVE`、或 `PROJECT_FOLDED`；在返回 success enum 之前，**必须**校验操作意图（`lookup|fold|reopen`）。任何未声明意图或无效的 base-shape/intent/predicate 组合返回 `PROJECT_OPERATION_INVALID`，hard-block 请求的操作/Orient transition，**不写 snapshot、不 move**。

| Base shape（error 检查后） | `lookup` | `fold` | `reopen` |
|---|---|---|---|
| `PROJECT_NEW` (`rows=0,A=0,R=0`) | `PROJECT_NEW + ALLOW_CREATE_AFTER_NORMAL_GATES` | `PROJECT_OPERATION_INVALID + MOVE_REQUIRES_EXISTING_PROJECT` | `PROJECT_OPERATION_INVALID + MOVE_REQUIRES_EXISTING_PROJECT` |
| `PROJECT_ACTIVE`, `closed && threshold=true` | `PROJECT_ACTIVE + RESOLVE_ACTIVE` | `PROJECT_ACTIVE + ALLOW_FOLD` | `PROJECT_OPERATION_INVALID + REOPEN_REQUIRES_FOLDED` |
| `PROJECT_ACTIVE`, `closed && threshold=false`（任一 predicate false） | `PROJECT_ACTIVE + RESOLVE_ACTIVE` | `PROJECT_OPERATION_INVALID + FOLD_PREDICATE_FALSE` | `PROJECT_OPERATION_INVALID + REOPEN_REQUIRES_FOLDED` |
| `PROJECT_FOLDED` | `PROJECT_FOLDED + RESOLVE_ARCHIVE_READ_ONLY` | `PROJECT_OPERATION_INVALID + FOLD_REQUIRES_ACTIVE` | `PROJECT_FOLDED + ALLOW_REOPEN` |

`lookup|fold|reopen` 之外的 operation 值返回 `PROJECT_OPERATION_INVALID + UNKNOWN_OPERATION`。既有 error/marker 优先级始终高于 operation intent：例如 both-root + reopen 返回 `PROJECT_BOTH_ROOTS`（非 operation-invalid）；non-complete marker + 任何 intent 返回 `FOLD_MOVE_PARTIAL`。`ALLOW_FOLD` 和 `ALLOW_REOPEN` 是唯一授权 RA4 pre-move snapshot 与 move protocol 的 effect。`PROJECT_OPERATION_INVALID` **从不**创建/更新 `.enloom/fold-move-state.md`，**从不**改动 root 或 task_board 行。

### Reopen（RA4）

从 folded 状态 reopen：control 移动**精确目录**（`.enloom/archive/<created>-<project>/` → `.enloom/<created>-<project>/`），**保留 `created`**，更新**同一行**的 `updated/phase`。**MUST NOT 创建 duplicate**（不新建行、不新建目录）。这是 resolver 的 `PROJECT_FOLDED + ALLOW_REOPEN` 路径。

Reopen 复用两根 resolver——不依赖 schema 列或 first-match。Fold 不破坏 reopen：`project_state` / tasks / runs / archive 内部结构完整保留。

Worked example:2026-07-09 一次折叠 5 个 closed 项目(v04/v05/v06/clearmind-align/repo-hygiene)，见 `.enloom/archive/`。
