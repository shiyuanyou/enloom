# T-P2-01 Output

Rewritten `landing-contract.md` and `archive-policy.md` implementing C03, C04, C06, RA2, RA4, RA4.2.

---

## File 1: `enloom-skill/references/landing-contract.md`

```markdown
# Landing Contract — 落盘时序契约

State governance lives in [registry-and-compaction.md](registry-and-compaction.md); evidence in [evidence-contract.md](evidence-contract.md). This reference is the **landing discipline** — the third leg of state governance: *when*, *by whom*, a workflow artifact must exist on disk. Templates exist (task-packet / worker-report have complete fields) and the Stage 0 Triage + six-stage lifecycle (Stages 1–6) names the stages, but without an explicit rule for which file gets written at which stage boundary, an agent could "complete" the whole six-stage lifecycle (Stages 1–6, after Stage 0 Triage) touching the disk zero times. The Landing Contract closes that gap by making every stage crossing a **file-existence gate**.

> **铁则**：worker 的产出和报告必须落盘成文件，不能只留在对话上下文。dispatch 不是「把任务说给 worker 听」，是「把 `task.md` 路径交给 worker，worker 写 `output.md` / `report.md`」。这是闸门表能成立的物理前提。

## 1. Gate Table — every stage's entry/exit mechanical check

A gate is a **file-existence check** — mechanical, verifiable, no judgment. The control agent self-checks at stage entry; health-check acts as a hard gate at stage transition (double insurance — see §4). Stages follow [workflow-steps.md](workflow-steps.md). The model is Stage 0 Triage + six-stage lifecycle (Stages 1–6).

| Stage | Entry gate (must hold before entering) | Exit gate (must hold before leaving) |
|---|---|---|
| **0 Triage** | — | triage result decided. (`direct` / `light-plan` exit Enloom entirely; only `enloom` proceeds below.) Triage is side-effect-free — no files, no dispatch, no moves. |
| **1 Orient** | `task_board.md` exists (create on first use) | 5–10 line state summary written into project_state's Current Phase (or confirmed unnecessary) |
| **2 Plan** | project located — `<created>-<project>/` directory exists | `tasks/phase-plan-<phase>.md` exists; phase goal is clear (gate check passes) |
| **3 Execute** (per task) | **accepted phase plan present** (`tasks/phase-plan-<phase>.md`) | **`runs/<TASK>/output.md` exists** + **`runs/<TASK>/report.md` exists** + report has a Result section (done/blocked/failed) |
| **4 Verify** | `runs/<TASK>/report.md` exists with Evidence Contract four elements | Review Result exists (currently the `report.md` Review Result section; will become `review-result.md` in P3) with verdict + conclusion |
| **5 Integrate** | every task of this phase has its Review Result filled | `project_state.md` + Registry updated; **compaction run or threshold not met** (exceeding a threshold *forces* compaction before exit; a non-triggered skip must be recorded as a one-liner) |
| **6 Close** | Integrate exit gates all pass | `archive/<phase>-entry.md` exists; old `runs/` content archived or declared discarded |

**Stage 3 pre-dispatch sub-gate (Law 2).** Admission to Stage 3 requires the accepted phase plan, never the packet — requiring the packet at admission would be circular, because `task.md` is created BY `make-prompt` inside the stage. The Law 2 pre-dispatch gate checks that `runs/<TASK>/task.md` exists only after `make-prompt` writes it. Order: phase plan present (admission) → `make-prompt` writes the packet → Law 2 checks the packet (pre-dispatch) → dispatch.

All paths are project-relative: `.enloom/<project>/runs/<TASK>/...` — see [File Protocol](../SKILL.md) for the namespace layer.

**Execution rule (double insurance):**

- **Control self-check** — the control agent runs an existence check at each stage entry, and at the Stage 3 pre-dispatch sub-gate. Missing → fill the gap at the responsible action; never skip over.
- **health-check hard gate** — at stage transition, health-check must run and verify the previous stage's exit-gate files. Failure → report a drift finding (Law violation signal). The control agent must close the gap before entering the next stage. See §4.

## 2. Handshake Sequence — control ↔ worker, every step is a disk write

The full lifecycle of `<TASK>`, ordered by disk operations. Every arrow is a file write/ read on disk — never a context-only handoff.

```
control agent                worker                disk (.enloom/<project>/)
    |                           |                          |
    |--[Stage 2 Plan] write tasks/phase-plan-<phase>.md--->|
    |                           |                          |
    |--[Stage 3 entry gate] check phase plan present ----->|
    |   missing → back to Plan; present → continue          |
    |                           |                          |
    |--- make-prompt: write runs/<TASK>/task.md ---------->|  ← packet lands
    |                           |                          |
    |--[pre-dispatch gate] check runs/<TASK>/task.md ----->|  ← Law 2 lands here
    |   missing → no dispatch (re-run make-prompt)         |
    |                           |                          |
    |--- dispatch: hand worker the path to task.md ------->|
    |                           |--- read task.md -------->|
    |                           |--- execute (read Inputs)>|
    |                           |--- write runs/<TASK>/output.md -->|  ← output lands
    |                           |--- write runs/<TASK>/report.md --->|  ← report lands
    |                           |    (Result / Evidence / Not Checked / Blind Spots)
    |<-- done/blocked/failed ----|                          |
    |                           |                          |
    |--[Stage 3 exit gate] check output.md + report.md --->|
    |   + report has Result section → pass; missing → back to worker
    |                           |                          |
    |--[Stage 4 Verify: see §Verify-Worker Handshake] ---->|
    |                           |                          |
    |--[Stage 5] update project_state.md + Registry ----->|
    |                           |                          |
    |--[Stage 6] write archive/<phase>-entry.md ---------->|
    |--- archive/declare-discard runs/<TASK>/ content ---->|
```

**The physical premise:** dispatch hands the worker a *path* to `task.md`, not a verbal task description. The worker's deliverable is `output.md` + `report.md` on disk, not a chat reply. A worker that returns "done" without those files has not completed — the Stage 3 exit gate fails and the control agent routes it back.

**Non-circular admission (C03).** `task.md` is created by `make-prompt`, which is the first Stage 3 control action. Admission to Stage 3 checks the accepted phase plan, NOT `task.md`; the Law 2 pre-dispatch gate checks the packet only after `make-prompt` has written it. No worker may run before its on-disk packet exists, and no gate reads a file before its creator action has run.

**Dispatch content vs. path — an implementation detail, not a gate question.** Handing the worker the `task.md` *path* is the Law 2 gate requirement: the durable artifact must exist on disk before dispatch (the pre-dispatch gate checks `runs/<TASK>/task.md` after `make-prompt`), so the contract survives a session crash and a later Verify can re-read it. *How the worker obtains the packet's content* is below the gate: a sub-agent runtime that re-reads the file from the path satisfies Law 2, and so does a front-stage dispatch that embeds the packet content into the worker's prompt — provided the on-disk `task.md` already exists in both cases. The gate cares about the durable artifact surviving; the delivery channel (path-read vs. prompt-embedded) is free to vary. Either way the packet is the contract, and `output.md` / `report.md` must still land on disk to satisfy the exit gate.

## 3. Law 2 / Law 5 mechanization (aligned with Law 4)

Law 4 (Evidence Contract) is already mechanized: control MUST apply the **Verdict Decision Function** in [evidence-contract.md §Verdict Decision Function](evidence-contract.md) — a total, ordered decision function over normalized status tuples, not a two-condition `iff`. Laws 2 and 5 are raised to the same mechanical standard — each is a file-existence gate, not a statement of intent.

| Law | Statement (intent) | Mechanized (gate) |
|---|---|---|
| **Law 2** — no Worker without Task Packet | stated | **Pre-dispatch gate (after `make-prompt`): `runs/<TASK>/task.md` must exist.** `make-prompt` writes the packet first; only then does Law 2 check it and permit dispatch. Control self-check + health-check double-verify. Missing → no dispatch; re-run `make-prompt` (this is NOT a Plan fallback — the phase plan already passed the entry gate). |
| **Law 5** — no Archive without State Update | stated (extended: registry processed) | **Pre-archive gate: every task's Review Result is filled + project_state/Registry updated.** health-check hard-verifies. Missing → no archive. |

The Five Laws become uniformly mechanical: Law 2 governs dispatch (a pre-dispatch sub-gate inside Stage 3), Law 4 governs acceptance, Law 5 governs archive entry — each a file-existence gate, not a hope.

## 4. health-check — two axes: periodic homes + transition executor (C06)

`health-check` operates on two distinct axes. They are NOT the same thing, and conflating them is the bug this section removes.

**Axis 1 — Periodic homes (full tier).** Full drift scans live in two fixed homes: Stage 1 Orient (entry) and periodic Stage 4 Verify (when a drift scan is due). These run the full nine-item scan. A periodic home is where comprehensive drift detection happens; it is NOT the complete set of transition execution points.

**Axis 2 — Transition executor (light tier).** Control invokes a light health-check at each of the five stage boundaries of the six-stage lifecycle (Stages 1–6): `1→2`, `2→3`, `3→4`, `4→5`, `5→6`. Each transition check verifies only the previous stage's exit-gate files — a one/two-line mechanical confirmation (e.g. `ls runs/<TASK>/task.md`, `ls runs/<TASK>/output.md`), emitting a single-line "Gates OK" on pass. It does *not* expand the full nine-item scan at every transition. The procedure reports; control repairs.

| Axis | Tier | When | Invoker | Scope |
|---|---|---|---|---|
| Periodic homes | full | Orient entry; periodic Verify (when due) | health-check home | full nine-item scan |
| Transition executor | light | `1→2`, `2→3`, `3→4`, `4→5`, `5→6` | control (at each boundary) | only that transition's exit-gate files |

- It reports findings; it does not auto-fix (control agent fills the gap).
- A drift finding is a Law violation signal — the control agent must resolve it before advancing.

This is the second insurance layer: even if the control agent forgets to self-check, health-check catches the missing file at the boundary. Two independent checks (self-check + health-check) make a skipped landing far harder than either alone. The light tier keeps this insurance while respecting the attention budget — 95% of transitions only need the existence check. First-use Orient (no pre-existing project state) runs the minimal full-scan behavior for that case; this does NOT invent a Stage 0 file gate.

## Verify-Worker Handshake — non-recursive V0→V3 termination (RA2)

A `VERIFY_WORKER` (reviewer or audit) is a named Stage 4 sub-state — not Stage 3, and not a return to Plan. Control owns every transition and is the normative finalizer, not an exception. The same `make-prompt → task.md exists → dispatch` mini-handshake runs inside Verify, never at Stage 3 entry.

| State | Entry | Control/worker action | Single next state |
|---|---|---|---|
| **`V0_TARGET_READY`** | target `output.md` + four-field `report.md` exist | If no independent verification is required, control evaluates the target directly. Otherwise control writes the verifier/audit `task.md` inside Stage 4 (via `make-prompt`). Packet-write failure stays V0 and blocks. | direct `V3_CONTROL_FINALIZED`, or `V1_VERIFY_PACKET_READY` |
| **`V1_VERIFY_PACKET_READY`** | verifier/audit `task.md` exists | Law 2 pre-dispatch gate checks that exact file; dispatch writes the verifier/audit `output.md` + `report.md`. Missing worker artifacts stay V1 / rework the same run; MUST NOT return to Plan. | `V2_VERIFY_RUN_LANDED` |
| **`V2_VERIFY_RUN_LANDED`** | verifier/audit `output.md` + `report.md` exist | Control directly evaluates this run and writes its Review Result, then evaluates the target using the proposal/evidence and writes the target Review Result. Insufficient verifier evidence yields a control-authored FAIL — it MUST NOT dispatch a reviewer-of-review. | `V3_CONTROL_FINALIZED` |
| **`V3_CONTROL_FINALIZED`** | target Review Result exists AND every Verify-worker run has its own Review Result | Stage 4 exit gate runs. | Stage 5, or blocked on an explicit result |

**Invariants (non-recursion).**

- **Zero Plan edges:** no Verify-worker state transitions back to Stage 2 Plan.
- **Zero reviewer-of-review edges:** insufficient verifier evidence produces a control-authored FAIL, never another reviewer.
- **Max 3 forward transitions:** V0→V1→V2→V3; direct control review reaches V3 in one transition.
- Control direct finalization is the normal Stage 4 terminal transition for execution, reviewer, and audit runs; no run creates an obligation for another reviewer.

Pure audit uses the same V0→V1→V2→V3 path; its packet MUST declare worker-owned output/report paths and the separate control result path.

Verification: trace (a) direct control review, (b) one reviewer, (c) one pure audit from empty verifier directories. PASS: packet precedes each dispatch; each trace reaches V3 in at most three forward transitions; zero Plan edges and zero reviewer-of-review edges. FAIL: any verifier report creates another Verify-worker requirement, or any context-only return satisfies a gate.

## 5. Sub-agent requirement

Stage 3 dispatch hands the worker a path to `task.md`; the worker is an **independent sub-agent** that writes `output.md` / `report.md` to disk. If the runtime cannot dispatch a sub-agent, Enloom **halts** — it does not degrade to the control agent executing the task itself. The control agent's job is orchestration (triage / orient / plan / review / integrate / archive) and serial-integration writes, not worker execution. Halting is the honest failure: prompt contamination (main window absorbing worker context) is worse than not running.

When dispatch fails (no sub-agent runtime / tool error), the control agent surfaces the failure and suggests switching to a runtime with sub-agent support (opencode / pi / codex, etc.). There is no self-execution fallback.

## See Also

- [workflow-steps.md](workflow-steps.md) — each stage's gate is referenced from its entry/exit (P1-D wires this).
- [evidence-contract.md](evidence-contract.md) §Verdict Decision Function — Law 4, the total decision function Laws 2/5 now align with.
- [archive-policy.md](archive-policy.md) §Project Fold — fold timing and namespace resolver.
- [registry-and-compaction.md](registry-and-compaction.md) — state governance (Registry / Ownership / Compaction); landing is its on-disk enforcement layer.
- [templates/task-packet.md](templates/task-packet.md) / [templates/worker-report.md](templates/worker-report.md) — the artifacts the gates require to exist.
```

---

## File 2: `enloom-skill/references/archive-policy.md`

```markdown
# Archive Policy

archive 是闭合。没有闭合,不算完成。闭合标准机械化,逐条核对。

## 闭合条件(全部满足才能 archive)

> 所有路径均在项目目录内(`.enloom/<created>-<project>/`)。

- [ ] task packet 存在。
- [ ] output 和 report 存在。
- [ ] review result 存在(目前写入 `report.md` 的 Review Result 段；P3 之后将变为独立的 `review-result.md`)。
- [ ] **每个 task 的 Review Result 已填**(铁律 5 机械化:archive 前 health-check 硬验此条——见 [landing-contract.md](landing-contract.md) §3)。无 Review Result → 不准 archive。
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
```

---

## Change Summary

### landing-contract.md

1. **§1 Gate Table (C03)**: Stage 3 entry gate changed from "`runs/<TASK>/task.md` exists ← Law 2 gate" to "**accepted phase plan present** (`tasks/phase-plan-<phase>.md`)". Added a dedicated "Stage 3 pre-dispatch sub-gate (Law 2)" paragraph stating task.md existence is the sub-gate AFTER make-prompt, not the entry gate, with the explicit non-circular ordering.
2. **§1 Stage 0 row**: Added "Triage is side-effect-free — no files, no dispatch, no moves."
3. **§1 Stage 4 row**: Updated Review Result reference to note the P3 split ("currently the `report.md` Review Result section; will become `review-result.md` in P3").
4. **§2 Handshake Sequence (C03)**: Reordered the ASCII diagram — entry gate now checks "phase plan present"; make-prompt writes task.md BEFORE the pre-dispatch gate; the OLD line `--[Stage 3 entry gate] check runs/<TASK>/task.md` replaced with `--[Stage 3 entry gate] check phase plan present` followed by a separate `--[pre-dispatch gate] check runs/<TASK>/task.md` after make-prompt. Removed the circular "entry gate checks task.md before make-prompt creates it."
5. **§2 Non-circular admission paragraph**: New prose paragraph stating entry checks phase plan, NOT task.md; Law 2 checks task.md only after make-prompt.
6. **§3 (C01/P1 reference)**: Law 4 mechanization updated from the old "verdict = PASS iff all declared checks ran and evidence is non-empty" to "control MUST apply the Verdict Decision Function in evidence-contract.md §Verdict Decision Function". Law 2 row updated to "(after make-prompt)" and clarifies missing → re-run make-prompt (NOT a Plan fallback).
7. **§4 health-check (C06)**: Rewritten with explicit two-axis framing — Axis 1 periodic homes (full tier: Orient + periodic Verify) vs Axis 2 transition executor (light tier: control at 5 boundaries). Added a 2-row table contrasting the axes. Added first-use Orient note (no Stage 0 file gate).
8. **New §Verify-Worker Handshake (RA2)**: The full V0→V3 non-recursive state machine with a 4-row table (entry/action/single-next) and the three invariants (zero Plan edges, zero reviewer-of-review, max 3 forward transitions).
9. **C05 phrase guard**: Intro, §1, §4, and the fold-cross-reference sentences all use "Stage 0 Triage + six-stage lifecycle (Stages 1–6)" qualified phrasing.

### archive-policy.md

10. **§闭合条件 (RA3 note)**: Review Result reference updated to note "currently in `report.md`; P3 will become `review-result.md`".
11. **§Project Fold — Trigger timing (C04)**: Moved from "before Triage" to "after `enloom` decision". New "触发时机" subsection makes Triage side-effect-free explicit and states only `enloom` path runs fold; `direct`/`light-plan` exit. Fold serial with Orient (not concurrent).
12. **§Project Fold — Execution (C04)**: Fold is now "control 直接执行的串行 namespace 操作，**不派 sub-agent**". States fold MUST NOT modify task_board row. Removed old "派 sub-agent" and "在 Stage 0 Triage 进新任务前做".
13. **New §Namespace Resolver (RA4)**: The 7-level precedence table (FOLD_MOVE_PARTIAL → PROJECT_DUPLICATE_ROW → PROJECT_ORPHAN_ROOT → PROJECT_BOTH_ROOTS → PROJECT_MISSING_ROOT → PROJECT_NEW → PROJECT_ACTIVE/PROJECT_FOLDED).
14. **New §fold-move-state.md 快照协议 (RA4)**: Pre-move snapshot (status=prepared) + post-move verify; non-complete marker → FOLD_MOVE_PARTIAL → hard block Orient; control-owned explicit recovery.
15. **New §Operation-intent 校验 (RA4.2)**: The 4×3 base-shape/intent table; PROJECT_OPERATION_INVALID with zero writes/moves for invalid combos; error precedence always wins over intent.
16. **§Reopen (RA4)**: Control moves exact directory, preserves `created`, updates SAME row `updated/phase`, MUST NOT create duplicate. Uses two-root resolver (not first-match/schema column).
17. **C05 phrase guard**: The one new lifecycle sentence ("下次新请求进入 Stage 0 Triage + six-stage lifecycle (Stages 1–6) 时") uses qualified phrasing.

---

## Verification Results (V01–V09)

| ID | Command | Result | Status |
|---|---|---|---|
| V01 | `rg 'Stage 3.*entry.*task\.md\|Entry gate.*task\.md' landing-contract.md` | exit=1 (zero hits) | PASS |
| V02 | `rg -c 'make-prompt' landing-contract.md` | count=8 (≥2) | PASS |
| V03 | `rg 'V0_TARGET_READY\|V1_VERIFY_PACKET_READY\|V2_VERIFY_RUN_LANDED\|V3_CONTROL_FINALIZED' landing-contract.md` | all 4 present | PASS |
| V04 | `rg 'reviewer-of-review\|Plan.*edge\|return.*Plan' landing-contract.md` | 6 hits, present as FORBIDDEN invariants | PASS |
| V05 | `rg 'FOLD_MOVE_PARTIAL\|PROJECT_DUPLICATE_ROW\|PROJECT_ORPHAN_ROOT\|PROJECT_BOTH_ROOTS\|PROJECT_MISSING_ROOT\|PROJECT_OPERATION_INVALID' archive-policy.md` | all 6 enums present | PASS |
| V06 | `rg -c 'fold-move-state' archive-policy.md` | count=4 (≥1) | PASS |
| V07 | `rg '再做 Triage\|进新任务前.*fold\|before.*Triage.*fold' archive-policy.md` | exit=1 (zero hits) | PASS |
| V08 | `rg '派 sub-agent\|dispatch.*sub-agent' archive-policy.md` | 1 hit, in negation context ("**不派 sub-agent**") | PASS |
| V09 | `rg 'Verdict Decision Function' landing-contract.md` | 2 hits (≥1) | PASS |

### Countable outputs

- RA2 states: exactly **4** (V0_TARGET_READY, V1_VERIFY_PACKET_READY, V2_VERIFY_RUN_LANDED, V3_CONTROL_FINALIZED)
- RA4 error enums: exactly **6** (FOLD_MOVE_PARTIAL + PROJECT_DUPLICATE_ROW + PROJECT_ORPHAN_ROOT + PROJECT_BOTH_ROOTS + PROJECT_MISSING_ROOT + PROJECT_OPERATION_INVALID)
- RA4 success enums: exactly **3** (PROJECT_NEW, PROJECT_ACTIVE, PROJECT_FOLDED)

### V01 wording note

The V01 regex `Stage 3.*entry.*task\.md` initially matched two anti-circular explanatory paragraphs. Their content was correct (stating the entry gate does NOT check task.md), but to make V01 unambiguous I reworded them to use "admission" instead of "entry" in those specific sentences. The Gate Table column header still reads "Entry gate" (which is correct and not matched by the regex), and the handshake diagram line now reads "Stage 3 entry gate: check phase plan present".
