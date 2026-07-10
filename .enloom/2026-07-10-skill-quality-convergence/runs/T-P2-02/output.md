# T-P2-02 — Consumer Alignment Output

Per-file change summary. Each consumer aligned to the P2 owner rewrites in `landing-contract.md` (C03, C06, RA2) and `archive-policy.md` (C04, RA4), with the C05 phrase guard on every added/modified lifecycle sentence.

## File 1: `enloom-skill/references/workflow-steps.md`

### Lifecycle overview (C05)
- Opening sentence: "six stages" → "a Stage 0 Triage entry decision + six-stage lifecycle (Stages 1–6)".

### Stage 0 (C04 — AC1)
- **Removed**: "Workspace hygiene check（进新任务前）" block that dispatched `fold` BEFORE Triage via a sub-agent.
- **Added**: explicit "Triage is side-effect-free" statement — decides `direct | light-plan | enloom` only; no files, no dispatch, no moves. `direct`/`light-plan` exit with no fold.
- **Added**: "Workspace hygiene check (after the `enloom` decision — C04)" — fold runs only after Triage returns `enloom`; control (serial namespace owner) reads task_board, applies C10 resolver, folds qualifying closed top-level projects before Orient. Fold is control-owned serial, NOT a sub-agent; only moves directories; MUST NOT alter task_board row. Thresholds preserved (phase=closed + at top level + ≥3 closed).

### Stage 3 (C03 — AC2)
- **Entry gate**: changed from "runs/<TASK>/task.md exists" (circular) → "accepted phase plan present (tasks/phase-plan-<phase>.md)". States admission requires the plan, never the packet; missing plan → Stage 2 Plan fallback.
- **Added**: "Pre-dispatch sub-gate (Law 2 mechanized, C03)" bullet stating the order: `make-prompt` writes `runs/<TASK>/task.md` → Law 2 pre-dispatch gate checks that file → dispatch. A missing packet (make-prompt did not run/failed) → no dispatch; re-run make-prompt (NOT a Plan fallback).

### Stage 4 (RA2 — AC3)
- **Added**: "Verify-worker handshake (RA2 — non-recursive V0→V3)" paragraph. States the same make-prompt → task.md exists → dispatch mini-handshake runs INSIDE Stage 4, never at Stage 3 entry; control owns every transition and is normative finalizer; names the V0_TARGET_READY → V1_VERIFY_PACKET_READY → V2_VERIFY_RUN_LANDED → V3_CONTROL_FINALIZED states; zero Plan edges, zero reviewer-of-review edges, ≤3 forward transitions; direct control review reaches V3 in one transition; references landing-contract.md §Verify-Worker Handshake as SSOT.

### Health Check (C06 — AC4)
- **Added**: two-axis (C06) framing at the top of the section. Axis 1 = Periodic homes (full tier): Orient entry + periodic Verify — full nine-item scan; NOT the complete set of transition points. Axis 2 = Transition executor (light tier): control invokes a light check at each of the five boundaries of the six-stage lifecycle (Stages 1–6): 1→2, 2→3, 3→4, 4→5, 5→6; verifies only the previous stage's exit-gate files. Points to landing-contract.md §4 as SSOT.
- Existing "Two Tiers" detail and nine-item scan preserved (they implement the two axes).

## File 2: `enloom-skill/SKILL.md`

### Lifecycle (C05 — AC5)
- Opening sentence: "The work proceeds through six stages." → "The model is a Stage 0 Triage entry decision + six-stage lifecycle (Stages 1–6)."

### Sub-actions table (C04 + C06 — AC6)
- `fold` row: stage "0 Triage" → "post-Triage (after `enloom`)"; purpose rewritten: control-owned serial move of closed projects to .enloom/archive/; runs only after the `enloom` decision, not during Triage (堆积 ≥3 时).
- `health-check` row: stage "1 Orient + 4 Verify" → "two-axis (C06)"; purpose rewritten: periodic homes = Orient + Verify (full scan); transition executor = control at 5 boundaries (light check).

### Landing Discipline (C03 — AC7)
- "Every stage crossing is a file-existence gate" bullet: example changed from "Stage 3 entry: runs/<TASK>/task.md must exist" → "Stage 3 entry: accepted phase plan present; Stage 3 pre-dispatch sub-gate: make-prompt writes runs/<TASK>/task.md, then Law 2 checks it before dispatch".

## File 3: `enloom-skill/references/glossary.md`

### Lifecycle Stage (C05 — AC8)
- Entry: "6 阶段:0 Triage / ..." → "模型是 Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6):0 Triage / 1 Orient / ... / 6 Close。Triage 是入口决策,不计入六阶段。"

### Gate / 闸门 (C03 — AC9)
- Entry: "Stage 3 入口:runs/<TASK>/task.md 必存在" → "Stage 3 入口 = 接受的 phase plan 存在"(C03:非 packet;packet 由 make-prompt 在 Stage 3 内创建,之后 Law 2 预派发闸门检查 packet 存在才允许 dispatch). task.md token removed from the Stage 3 入口 span to satisfy V02; the pre-dispatch detail lives in landing-contract.md/workflow-steps.md.

### Fold / 折叠 (C04 — AC10)
- Entry: "由 fold sub-action 执行(Stage 0 Triage 时堆积 ≥3 触发)" → "触发时机(C04):Stage 0 Triage 决定 enloom 之后(非 Triage 前);direct/light-plan 不触发。control 直接执行的串行 namespace 操作,不派 sub-agent". Added archive-policy.md §Project Fold link.

### health-check 两档 (C06 — AC11)
- Entry: reframed as "两个轴(C06)": 周期主场所轴(完整档) + 转移执行轴(轻量档,control 在六阶段生命周期五个边界). Added "两轴不可混同:周期主场所不是转移执行点的全集." Changed SSOT reference to landing-contract.md §4.

## File 4: `AGENTS.md`

### 开发即 dogfood (C05 — AC12)
- Lifecycle sentence: "进 enloom 生命周期" → "进 enloom 生命周期（Stage 0 Triage 入口决策 + 六阶段生命周期 Stages 1–6）".
- 归档证据 section (historical fold description) left UNCHANGED per task instruction — it describes past behavior as historical evidence.

## Acceptance Criteria Coverage

| AC | Rule | File | Status |
|---|---|---|---|
| 1 | C04 | workflow-steps.md Stage 0 | done |
| 2 | C03 | workflow-steps.md Stage 3 | done |
| 3 | RA2 | workflow-steps.md Stage 4 | done |
| 4 | C06 | workflow-steps.md Health Check | done |
| 5 | C05 | SKILL.md Lifecycle | done |
| 6 | C04/C06 | SKILL.md sub-actions | done |
| 7 | C03 | SKILL.md Landing Discipline | done |
| 8 | C05 | glossary.md Lifecycle Stage | done |
| 9 | C03 | glossary.md Gate | done |
| 10 | C04 | glossary.md Fold | done |
| 11 | C06 | glossary.md health-check | done |
| 12 | C04/C05 | AGENTS.md | done |
