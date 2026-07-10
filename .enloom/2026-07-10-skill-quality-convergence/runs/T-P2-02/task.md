# Task Packet: T-P2-02

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Align 4 consumer files with the P2 owner rewrites in landing-contract.md and archive-policy.md. Each consumer must reflect: C03 (Stage 3 entry = phase plan, not task.md; make-prompt creates task.md before dispatch), C04 (Triage side-effect-free; fold after enloom decision, control-owned), C06 (health-check two-axis), RA2 (Verify-worker V0→V3), and C05 phrase guard.

## Anti Goal

- Do NOT modify landing-contract.md or archive-policy.md — they are locked by T-P2-01.
- Do NOT change Evidence Contract semantics (P1).
- Do NOT change ownership model report.md/review-result.md split (P3).
- Do NOT do broad naming cleanup (P5). But any NEW or MODIFIED lifecycle sentence must carry the "Stage 0 Triage + six-stage lifecycle" qualifier.
- Do NOT change description/trigger wording.
- For workflow-steps.md: update lifecycle gate timing and fold timing to match the new owners. Do NOT change Evidence-related text (already aligned in P1).

## Inputs

1. The rewritten owners: `landing-contract.md` and `archive-policy.md` (read them first).
2. Canonical rules in `runs/T-P0-02/output.md`: C03, C04, C06, RA2, RA4/RA4.2, C05 phrase guard (line 465).
3. Current content of the 4 consumer files.

## Existing State

### workflow-steps.md (273 lines):
- **Stage 0** (lines 36-65): Has "Workspace hygiene check（进新任务前）" that dispatches fold BEFORE Triage — this is the C04 defect. Must move fold to AFTER the `enloom` decision.
- **Stage 3** (line 125): "Entry gate (per task, Law 2 mechanized): runs/<TASK>/task.md exists. Missing → fall back to Plan" — this is the C03 circular dependency. Entry should be "accepted phase plan present"; task.md existence is the pre-dispatch gate after make-prompt.
- **Stage 4** (lines 152-177): References "report.md's Review Result section" for gates — RA2 V0→V3 should be referenced. Also the Verify handshake should mention RA2 states.
- **Health Check** (lines 246-272): Has the two-tier concept but may need the C06 two-axis framing (periodic homes vs transition executor).
- The lifecycle overview (lines 5-13) lists "0. Triage → ... 6. Close" — C05 phrase guard: this should note "Stage 0 Triage entry decision + six-stage lifecycle (Stages 1–6)" somewhere.

### SKILL.md (126 lines):
- **Lifecycle** (lines 22-35): Lists "0. Triage → 1. Orient → ... 6. Close" — C05 phrase guard needed.
- **Stage sub-actions table** (lines 39-49): `fold` listed as "0 Triage" with "堆积 ≥3 时" — needs C04 timing update (after enloom decision, not during Triage). `health-check` listed as "1 Orient + 4 Verify" — needs C06 note about transition execution.
- **Landing Discipline** (lines 109-117): References Stage 3 entry gate as task.md — needs C03 update.

### glossary.md (73 lines):
- **Lifecycle Stage** entry (line 10): "6 阶段:0 Triage / 1 Orient / ... / 6 Close" — C05 phrase guard needed.
- **Gate / 闸门** entry (line 42): "Stage 3 入口:runs/<TASK>/task.md 必存在" — C03 update needed.
- **Fold / 折叠** entry (line 44): "由 fold sub-action 执行(Stage 0 Triage 时堆积 ≥3 触发)" — C04 update needed (after enloom decision, control-owned, not sub-agent).
- **health-check 两档** entry (line 51): Needs C06 two-axis note.

### AGENTS.md (root doc):
- Check for lifecycle timing references and fold references. The fold mention in "归档证据" section describes historical fold behavior — this is historical evidence, but any normative sentence should align with C04.
- The "开发即 dogfood" section references fold timing — align with C04.
- Any lifecycle description should carry the C05 phrase guard.

## Allowed Tools

Read, Write, Edit (only on Writable Files), Grep, Bash

## Writable Files

- `enloom-skill/references/workflow-steps.md`
- `enloom-skill/SKILL.md`
- `enloom-skill/references/glossary.md`
- `AGENTS.md`

## Forbidden Files

- `enloom-skill/references/landing-contract.md` (LOCKED)
- `enloom-skill/references/archive-policy.md` (LOCKED)
- `enloom-skill/references/evidence-contract.md` (LOCKED by P1)
- All other files under `enloom-skill/`
- All files under `.enloom/`
- All files under `design/`
- `README.md`, `PROGRESS.md`, `CHANGELOG.md`
- All files under `~/.agents/skills/enloom/`

## Output Files

- `runs/T-P2-02/output.md` — per-file change summary
- `runs/T-P2-02/report.md` — Evidence Contract four elements report

## Acceptance Criteria

1. **workflow-steps.md Stage 0**: Fold trigger moved from "进新任务前" (before Triage) to AFTER the `enloom` decision. Triage itself described as side-effect-free.

2. **workflow-steps.md Stage 3**: Entry gate changed from "task.md exists" to "accepted phase plan present." make-prompt → task.md → pre-dispatch gate → dispatch order stated. No circular dependency.

3. **workflow-steps.md Stage 4**: References RA2 V0→V3 Verify-worker states or the landing-contract.md section that defines them.

4. **workflow-steps.md Health Check**: C06 two-axis framing (periodic homes vs transition executor) reflected.

5. **SKILL.md Lifecycle**: C05 phrase guard — the lifecycle section notes "Stage 0 Triage entry decision + six-stage lifecycle (Stages 1–6)."

6. **SKILL.md sub-actions table**: fold updated for C04 timing; health-check updated for C06 two-axis.

7. **SKILL.md Landing Discipline**: Stage 3 gate reference updated for C03.

8. **glossary.md Lifecycle Stage**: C05 phrase guard applied.

9. **glossary.md Gate/闸门**: C03 update (Stage 3 entry = phase plan; task.md = pre-dispatch gate).

10. **glossary.md Fold**: C04 update (after enloom decision, control-owned, not sub-agent).

11. **glossary.md health-check**: C06 two-axis note.

12. **AGENTS.md**: Any normative lifecycle/fold references aligned with C04/C05. Historical evidence sections remain unchanged.

## Required Verification

```
- id: V01
  command: rg '进新任务前|再做 Triage|before.*Triage.*fold' enloom-skill/references/workflow-steps.md enloom-skill/references/glossary.md enloom-skill/SKILL.md AGENTS.md
  pass_condition: zero hits (old pre-triage fold timing gone from consumers)
  fail_signal: any hit
  named_list: old_fold_timing_residue

- id: V02
  command: rg 'Stage 3.*入口.*task\.md|Entry gate.*task\.md|entry gate.*task\.md exists' enloom-skill/references/workflow-steps.md enloom-skill/references/glossary.md enloom-skill/SKILL.md
  pass_condition: zero hits matching the old "task.md as Stage 3 entry" pattern
  fail_signal: any hit
  named_list: circular_entry_residue

- id: V03
  command: rg -c 'make-prompt' enloom-skill/references/workflow-steps.md
  pass_condition: count >= 2 (make-prompt appears as the creator of task.md before dispatch)
  fail_signal: count < 2
  named_list: make_prompt_check

- id: V04
  command: rg 'six-stage lifecycle|Stage 0 Triage.*six|六阶段|six stages.*Stages 1' enloom-skill/references/workflow-steps.md enloom-skill/SKILL.md enloom-skill/references/glossary.md
  pass_condition: at least 1 hit per file (C05 phrase guard applied)
  fail_signal: any file with 0 hits
  named_list: c05_phrase_guard

- id: V05
  command: rg 'V0_TARGET_READY|RA2|Verify-worker|V0.*V3' enloom-skill/references/workflow-steps.md
  pass_condition: at least 1 hit (RA2 referenced in Stage 4)
  fail_signal: 0 hits
  named_list: ra2_reference

- id: V06
  command: git diff --name-only | grep -E 'landing-contract|archive-policy|evidence-contract'
  pass_condition: zero hits (locked files not touched)
  fail_signal: any locked file in diff
  named_list: forbidden_file_violation
```

Countable outputs:
- Number of consumer files changed (should be exactly 4)
- Number of files with old fold-timing residue (should be 0)

## Evidence Required

Command outputs for V01–V06.

## Review Budget

report.md + output.md.

## Done Signal

Return `done` with paths.
