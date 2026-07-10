# T-P3-01 — Output

Implemented C07/RA3 (file-level artifact ownership split), C08 (runtime capability 4-dimension record), and C09 (deterministic role-to-asset route) in three owner files. No file outside the writable set was touched (git diff confirms exactly 3 files). P1/P2 changes preserved; no description/trigger wording changed; no broad naming cleanup.

## Per-file change summary

### 1. `enloom-skill/references/landing-contract.md` (C07/RA3)

**1a. Gate table (Stage 4/5/6 exit + Law 5) — RA3 file-level gates.**
- Stage 4 exit gate: "Review Result exists (currently the `report.md` Review Result section; will become `review-result.md` in P3)" → "`runs/<TASK>/review-result.md` exists with verdict + conclusion".
- Stage 5 entry gate: "every task of this phase has its Review Result filled" → "every task of this phase has its `review-result.md` filled".
- Stage 6 Close entry gate: "Integrate exit gates all pass" → "Integrate exit gates all pass — every task's `review-result.md` is present".
- Law 5 mechanized gate: "every task's Review Result is filled" → "every task's `review-result.md` exists".

**1b. RA2 V0→V3 states — "writes Review Result" → "writes review-result.md".**
- `V2_VERIFY_RUN_LANDED` action: "writes its Review Result … writes the target Review Result" → "writes its `review-result.md` … writes the target `review-result.md`".
- `V3_CONTROL_FINALIZED` entry: "target Review Result exists AND every Verify-worker run has its own Review Result" → "target `review-result.md` exists AND every Verify-worker run has its own `review-result.md`".

**1c. NEW §6 Artifact Ownership — file-level split (RA3).** Added after §5 Sub-agent requirement, before §See Also. Contains:
- 7-row file-level ownership table (writer count = 1 each), with `review-result.md` as a separate control-owned artifact (`report.md` entirely worker-owned).
- Canonical run join: `task.md + output.md + report.md + review-result.md`; gate-to-file mapping.
- Packet requirements: `report.md` in Writable, `review-result.md` in Forbidden, `Control Review Result Path: runs/<RUN>/review-result.md`.
- Forbidden legacy wording list.

### 2. `enloom-skill/references/scheduler-rules.md` (C08)

**2a. NEW §Runtime Capability and Actual Dispatch Record (C08).** Appended after the virtual-parallelism section. Contains:
- 4-dimension matrix: independent sub-agent availability (hard), concurrent dispatch capability (soft), actual concurrency (soft), model/session diversity (soft).
- Hard/soft unknown policy: `independent_subagent=no|unknown` is the sole hard halt before any `.enloom` write; the other three unknowns are soft, never block, never inferred.
- Hard/soft policy table (4 rows).
- Propagation rule: after preflight=`yes`, control copies evidence into every phase plan/task packet; every dispatch gate validates the frozen `yes`.
- Forbidden legacy wording list.

**2b. Virtual parallelism section updated.** The blind-spot paragraph now references "§Runtime Capability and Actual Dispatch Record 的 actual concurrency 维度,而不是看 strategy 标签" instead of only "顺序发起".

### 3. `enloom-skill/SKILL.md` (C09)

**3a. NEW §Role-to-Prompt-Asset Route (C09).** Added after §References, before §File Protocol. Contains:
- 5-role canonical table: `researcher→prompt-assets/researcher.md`, `coder→prompt-assets/coder.md`, `reviewer→prompt-assets/reviewer.md`, `integrator→packet-only`, `tester→packet-only`.
- Pre-dispatch check: make-prompt MUST resolve Role through this table; mapped asset MUST be read+incorporated; packet-only MUST be recorded explicitly; prompt assets are source assets, not copied into projects.
- Evidence boundary: `ROLE_ROUTE_EVIDENCE_GAP` if host-native evidence unavailable; static packet marker is not host dispatch proof.

## Countable outputs

- RA3 ownership table data rows: **exactly 7** (header + 7 rows).
- C08 dimensions: **exactly 4**.
- C09 role routes: **exactly 5**.

## V01–V06 results

| ID | Command | Required | Actual | Result |
|---|---|---|---|---|
| V01 | `rg 'review-result\.md' landing-contract.md` | ≥ 3 hits | 12 hits | PASS |
| V02 | `rg 'writer count.*1\|Writer count.*1\|writer.*=.*1' landing-contract.md` | ≥ 5 hits | 9 hits | PASS |
| V03 | 4 C08 dimensions present in scheduler-rules.md | all 4 | all 4 (3/2/4/3 hits) | PASS |
| V04 | `rg 'hard.halt\|soft\|hard.*unknown\|sole hard' scheduler-rules.md` | ≥ 2 hits | 7 hits | PASS |
| V05 | 5 C09 role routes present in SKILL.md | all 5 | all 5 (1 each) | PASS |
| V06 | `rg 'Control Review Result Path' landing-contract.md` | ≥ 1 hit | 1 hit | PASS |

All V01–V06 PASS.

## Full rewritten content

### `enloom-skill/references/landing-contract.md`

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
| **4 Verify** | `runs/<TASK>/report.md` exists with Evidence Contract four elements | `runs/<TASK>/review-result.md` exists with verdict + conclusion |
| **5 Integrate** | every task of this phase has its `review-result.md` filled | `project_state.md` + Registry updated; **compaction run or threshold not met** (exceeding a threshold *forces* compaction before exit; a non-triggered skip must be recorded as a one-liner) |
| **6 Close** | Integrate exit gates all pass — every task's `review-result.md` is present | `archive/<phase>-entry.md` exists; old `runs/` content archived or declared discarded |

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
| **Law 5** — no Archive without State Update | stated (extended: registry processed) | **Pre-archive gate: every task's `review-result.md` exists + project_state/Registry updated.** health-check hard-verifies. Missing → no archive. |

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
| **`V2_VERIFY_RUN_LANDED`** | verifier/audit `output.md` + `report.md` exist | Control directly evaluates this run and writes its `review-result.md`, then evaluates the target using the proposal/evidence and writes the target `review-result.md`. Insufficient verifier evidence yields a control-authored FAIL — it MUST NOT dispatch a reviewer-of-review. | `V3_CONTROL_FINALIZED` |
| **`V3_CONTROL_FINALIZED`** | target `review-result.md` exists AND every Verify-worker run has its own `review-result.md` | Stage 4 exit gate runs. | Stage 5, or blocked on an explicit result |

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

## 6. Artifact Ownership — file-level split (RA3)

Every durable artifact has exactly **one sole writer**. This is the file-level ownership table — it supersedes the earlier section-level model where one physical `report.md` was shared between worker (evidence body) and control (Review Result subsection). Under RA3 the split is at the file level: `report.md` is entirely worker-owned; `review-result.md` is a separate control-owned artifact. No physical file has two writers.

| Artifact | Path | Sole writer | writer count = 1 |
|---|---|---|---|
| Task/review/audit packet | `runs/<RUN>/task.md` | control | writer count = 1 |
| Execution output/evidence | `runs/<TASK>/output.md`, `raw-notes.md`(opt), `report.md` | assigned worker | writer count = 1 |
| Review proposal/evidence | reviewer run `output.md`, `raw-notes.md`(opt), `report.md` | reviewer worker | writer count = 1 |
| **Review Result** | `runs/<RUN>/review-result.md` | **control** | writer count = 1 |
| Audit output/evidence | audit run `output.md`, `raw-notes.md`(opt), `report.md` | audit worker | writer count = 1 |
| Registry/integration truth | `project_state.md`, Registry, `decisions.md`, `task_board.md` | control | writer count = 1 |
| Archive/fold | archive entries, namespace moves | control | writer count = 1 |

Seven rows, each writer count = 1 (pairwise writer intersections empty). Reviewer and audit workers write their proposals/evidence into their *own* run's `output.md` / `report.md`; they MUST NOT edit the target's `report.md` or Registry. Only control integrates — it writes `review-result.md` for the target run and for every Verify-worker run.

**Canonical run join.** A completed run is the four-file join `task.md + output.md + report.md + review-result.md`; `raw-notes.md` is optional. The gates map onto these files: Stage 3 exit requires `output.md` + `report.md`; Stage 4 entry requires the four-field `report.md`; Stage 4 exit requires the target plus all Verify-worker `review-result.md` files; Stage 5 entry and Close/archive gates inspect `review-result.md`, never a `report.md` subsection.

**Packet requirements (mandatory).** Every ordinary / reviewer / audit packet MUST:

- list `report.md` in the worker **Writable Files**;
- list `review-result.md` in the worker **Forbidden Files**;
- declare the worker's `output.md` / `report.md` paths; and
- declare `Control Review Result Path: runs/<RUN>/review-result.md`.

Pure audit MUST NOT omit these fields. Reviewer/audit Registry entries remain *proposals* living in their own `output.md` / `report.md`; only control integrates them.

**Forbidden legacy wording/behavior:** "report body excluding Review Result"; a blank Review Result section left inside the worker `report.md` for control to fill; two writers on one physical file; an archive or integrate gate that checks a `report.md` subsection; a reviewer that writes the target `report.md` or Registry.

## See Also

- [workflow-steps.md](workflow-steps.md) — each stage's gate is referenced from its entry/exit (P1-D wires this).
- [evidence-contract.md](evidence-contract.md) §Verdict Decision Function — Law 4, the total decision function Laws 2/5 now align with.
- [archive-policy.md](archive-policy.md) §Project Fold — fold timing and namespace resolver.
- [registry-and-compaction.md](registry-and-compaction.md) — state governance (Registry / Ownership / Compaction); landing is its on-disk enforcement layer.
- [templates/task-packet.md](templates/task-packet.md) / [templates/worker-report.md](templates/worker-report.md) — the artifacts the gates require to exist.
```

### `enloom-skill/references/scheduler-rules.md`

(Full rewritten content: original 78 lines + new C08 section + updated virtual-parallelism paragraph. The complete current file text is the source of truth on disk; the new/changed regions are the §Runtime Capability and Actual Dispatch Record (C08) section and the one-sentence update inside §并行调度的真实时序 pointing to that section's actual-concurrency dimension.)

Key new region:

```markdown
## Runtime Capability and Actual Dispatch Record (C08)

能力(capability)、调度意图(strategy)、真实执行(actual)、模型/会话差异(diversity)是**四个独立事实**，不得互相推导。`strategy: parallel` 只是 scheduling intent；它既不证明运行时有并发能力，也不代表真实发生了并发。

| 维度 (Dimension) | 取值 (Values) | 协议要求 (Protocol requirement) | 记录规则 (Recording rule) |
|---|---|---|---|
| **independent sub-agent availability** | `yes\|no\|unknown` | `yes` 是 full Enloom 的强制前提；`no` / `unknown` 在任何 `.enloom` 写入之前 **hard halt**（C12 preflight）。 | 记录 preflight 证据来源；不得从 "skill 能加载" 推断 `yes`。 |
| **concurrent dispatch capability** | `yes\|no\|unknown` | 可选，不 gate full Enloom。 | 独立于 phase strategy 记录宿主能力。 |
| **actual concurrency** | `serial\|concurrent\|mixed\|unknown` | 无强制取值；如实描述本次运行。 | `concurrent` 必须有运行时原生证据或重叠时间戳；否则按观测记录 `unknown` / `serial`。 |
| **model/session diversity** | `same\|different\|mixed\|unknown` | 可选，是证据强度，不是隔离证明。 | 只记录已知的 model/session 关系；未知保持 `unknown`。 |

**Hard / soft unknown policy.** 四个维度中只有 **independent sub-agent availability** 是 hard：`no` 或 `unknown` 在 task_board 创建/更新、fold marker/move、project state、packet 或任何其他 `.enloom` 写入之前 **hard halt**（sole hard halt）。其余三个维度的 `unknown` 都是 **soft**——只如实记录，**绝不 block、也绝不推断**。
```

### `enloom-skill/SKILL.md`

(Full rewritten content: original 126 lines + new §Role-to-Prompt-Asset Route (C09). The complete current file text is the source of truth on disk; the new region is the C09 section inserted between §References and §File Protocol.)

New region:

```markdown
## Role-to-Prompt-Asset Route (C09)

Before dispatch, `make-prompt` MUST resolve the packet's `Role` through one canonical table.

| Role | Prompt asset | Behavior |
|---|---|---|
| `researcher` | `prompt-assets/researcher.md` | load + incorporate with the packet boundary |
| `coder` | `prompt-assets/coder.md` | load + incorporate |
| `reviewer` | `prompt-assets/reviewer.md` | load + incorporate |
| `integrator` | `packet-only` | no asset; recorded explicitly |
| `tester` | `packet-only` | no asset; recorded explicitly |

**Pre-dispatch check.** `make-prompt` MUST run this resolution before dispatch. A mapped asset MUST be read and incorporated; a `packet-only` role MUST be recorded explicitly. Prompt assets are source assets and MUST NOT be copied into each project by default.
```
