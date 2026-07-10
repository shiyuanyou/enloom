# T-P5-02 — Consumer Alignment Output

Aligns 4 consumer files with C05 (lifecycle naming), C12 (compatibility preflight), and C14 (install) from T-P5-01/T-P0-02.

## Per-File Change Summary

### 1. `enloom-skill/references/glossary.md` — C05 (1 edit)

**Defect found:** The `Control Skill` entry used unqualified "生命周期 6 阶段编排(triage → orient → plan → execute → verify → integrate → close)" — that parenthetical lists **7** items under "6 阶段", the exact C05 seven-under-six collision.

**Fix:** Line 9 now reads "Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6)编排(...)". The trailing parenthetical walk-through is retained because it is now explicitly qualified by the one-plus-six lead-in, matching the C05 allowance ("'Stages 0–6' MAY describe the full seven-row walkthrough only when it explicitly says one entry stage plus six lifecycle stages").

**No change needed:**
- `Lifecycle Stage` entry (line 10) already used correct one-plus-six terminology ("Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6)...Triage 是入口决策,不计入六阶段").
- `health-check 两档` entry (line 53) uses "六阶段生命周期的五个边界 `1→2/2→3/3→4/4→5/5→6`" — mathematically correct (six stages ⇒ five internal boundaries) and not an unqualified six/seven collision. Left unchanged.

### 2. `enloom-skill/references/trigger-contract.md` — C12 (1 edit)

**Defect found:** The "与 triage 子动作的关系" section mapped `enloom → 进入生命周期,从阶段 1 Orient 开始` with no mention of the C12 compatibility preflight that MUST run between the `enloom` decision and the first `.enloom` write.

**Fix:** Added a blockquote note immediately after the `enloom` mapping bullet. It states that after Triage returns `enloom` and before any `.enloom` write (task_board/project/project_state/fold/dispatch), control MUST run the compatibility preflight (independent sub-agent availability check); `no`/`unknown` halts with a minimal runtime-switch message and zero `.enloom` delta; only `yes` proceeds to Orient and copies preflight evidence into the phase plan and every task packet's dispatch gate. It clarifies that concurrency and model/session diversity are optional C08 records, not compatibility gates. References `[SKILL.md §Compatibility Preflight](../SKILL.md)`, matching the existing `../SKILL.md` link convention used in `references/`.

### 3. `PROGRESS.md` — C05 (1 edit, 2 lines)

**Defect found:** The "相关文档" table described SKILL.md and workflow-steps.md as "生命周期 6 阶段" (unqualified).

**Fix:** Lines 40–41 now use "Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6)" for both rows.

**C14 — not applicable:** PROGRESS.md contains no install procedure. It points to README.md as SSOT and does not duplicate install commands, so no C14 change is needed (C14 owner is README.md, which is locked by T-P5-01).

### 4. `enloom-skill/references/review-checklist.md` — no change

**Checked:** grep for `preflight|compatibility|sub-agent|兼容性` returned 0 hits. The file is a Stage 4 Verify gate checklist covering evidence four-fields, verdict decision function, claim consistency, and registry update obligations. C12's compatibility preflight runs at the Stage 0→1 transition (before any `.enloom` write), which is entirely outside the Verify stage scope the checklist governs. No compatibility/preflight content exists to align.

**Disposition:** left unchanged, per task instruction "If not applicable, leave unchanged."

## Scope Boundary

- Only the 4 Writable Files were eligible; 3 were edited, 1 (review-checklist.md) intentionally unchanged.
- Forbidden files (`workflow-steps.md`, `SKILL.md`, `README.md`, all `.enloom/`, `design/`) were NOT touched by this task. (README.md/SKILL.md/workflow-steps.md appear modified in git from the T-P5-01 owner task, not from T-P5-02.)
- No description/trigger wording, Evidence/lifecycle/ownership/namespace/validation semantics changed.

## Countable Outputs

- Consumer files changed: **3** (≤ 4).
- Files with unqualified "6 阶段" describing 7 rows in writable scope: **0** (was 2: glossary line 9, PROGRESS lines 40–41; decreased).

## Verification

- **V01** (`rg 'six-stage lifecycle|Stage 0 Triage.*six|六阶段|one.*plus.*six' glossary.md`): **3 hits**, exit 0. PASS.
- **V02** (`rg 'preflight|compatibility|independent.sub.agent' trigger-contract.md`): **1 hit**, exit 0. PASS.
