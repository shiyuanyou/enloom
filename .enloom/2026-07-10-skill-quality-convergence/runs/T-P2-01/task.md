# Task Packet: T-P2-01

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Rewrite `enloom-skill/references/landing-contract.md` and `enloom-skill/references/archive-policy.md` to implement C03 (non-circular packet/dispatch gate), C06 (health-check two-axis), RA2 (Verify-worker V0→V3 non-recursive termination), C04 (side-effect-free triage + post-decision fold), and RA4/RA4.2 (resolver precedence + fold-move-state recovery). These two files become the frozen owners for lifecycle gate timing and fold/namespace discipline.

## Anti Goal

- Do NOT touch Evidence Contract semantics (P1, already landed).
- Do NOT change the ownership model report.md/review-result.md split (P3).
- Do NOT do broad naming cleanup (C05 broad cleanup is P5). However, any NEW or MODIFIED lifecycle sentence you write MUST use "Stage 0 Triage + six-stage lifecycle (Stages 1–6)" or equivalent qualified phrasing — this is the C05 phrase guard.
- Do NOT touch any file other than the two Writable Files.
- Do NOT change description/trigger wording.

## Inputs

1. Canonical rules in `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/output.md`:
   - C03 (lines 59-70): Non-circular packet and dispatch gate
   - C04 (lines 72-83): Side-effect-free triage and post-decision fold
   - C06 (lines 98-109): health-check homes and executor
   - RA2 (lines 400-415): C03/C07 non-recursive Verify-worker termination (V0→V3 state machine)
   - RA4 (lines 439-459): C04/C10 resolver precedence and move recovery (7-level precedence table + fold-move-state.md)
   - RA4.2 (lines 547-574): Operation-intent precedence and effects
   - Lifecycle walkthrough (lines 269-279): the corrected 7-row walkthrough showing Stage 0 entry/sequence/writer/health-check timing/exit
2. Current content of `landing-contract.md` (100 lines) and `archive-policy.md` (59 lines).
3. C05 phrase guard amendment (output.md line 465): "P2 MUST apply a phrase guard to every added/changed lifecycle sentence."

## Existing State

### landing-contract.md (100 lines) — key problems to fix:
1. **§2 Handshake Sequence** (lines 28-64): Stage 3 entry gate currently checks `runs/<TASK>/task.md` exists (line 37), which creates a circular dependency — task.md is created BY make-prompt inside Stage 3. Per C03: Stage 3 entry = accepted phase plan; make-prompt writes task.md → THEN Law 2 pre-dispatch gate checks it.
2. **§1 Gate Table** (line 16): Stage 3 entry gate says "`runs/<TASK>/task.md` exists ← Law 2 gate" — this is the entry gate, but per C03 task.md existence is the *pre-dispatch* gate, not the *entry* gate. Entry should be the accepted phase plan.
3. **§3 Law 2/Law 5 mechanization** (line 68): says "verdict = PASS iff all declared checks ran" — this is the old Evidence formula. Should reference the Verdict Decision Function from P1.
4. **§4 health-check** (lines 77-86): Has the light/full tier distinction (good), but needs C06's explicit two-axis framing: periodic HOMES (Orient + periodic Verify) vs transition INVOCATIONS (control at 5 boundaries). Currently mixes "run on Stage transition" with "periodic" without the clean two-axis split.
5. **Missing RA2**: No V0→V3 Verify-worker state machine. The current text has no concept of the non-recursive Verify sub-state. Stage 4 entry/exit gates need to reflect RA2.
6. **Missing RA3 note**: archive-policy references "Review Result section" in report.md. This will change in P3 (RA3 splits to review-result.md), but for P2 just note it in archive-policy's closure conditions as "Review Result (currently in report.md; will become review-result.md in P3)".

### archive-policy.md (59 lines) — key problems to fix:
1. **§Project Fold** (lines 43-58): Currently says fold runs "在 Stage 0 Triage 进新任务前" (before Triage) — per C04, fold must run AFTER the `enloom` decision, not before Triage. Triage itself must be side-effect-free.
2. **Fold execution** (line 54): Currently says "派 sub-agent" (dispatch sub-agent). Per C04: "Fold MUST NOT require a worker and MUST NOT alter the task_board row." It should be a control-owned serial move.
3. **Missing RA4/RA4.2**: No resolver precedence table, no fold-move-state.md snapshot protocol, no PROJECT_OPERATION_INVALID.
4. **Reopen** (line 56): Currently says "git mv 回顶层 + task_board phase 改回" — per RA4, reopen must use the resolver, preserve `created`, and update the same row (not create a duplicate).

## Allowed Tools

Read, Write, Edit (only on Writable Files), Grep, Bash

## Writable Files

- `enloom-skill/references/landing-contract.md`
- `enloom-skill/references/archive-policy.md`

## Forbidden Files

- ALL other files under `enloom-skill/`
- ALL files under `.enloom/`
- ALL files under `design/`
- ALL root docs EXCEPT none — no root docs
- ALL files under `~/.agents/skills/enloom/`

## Output Files

- `runs/T-P2-01/output.md` — final content of both rewritten files + change summary
- `runs/T-P2-01/report.md` — Evidence Contract four elements report

## Acceptance Criteria

### landing-contract.md:

1. **§1 Gate Table**: Stage 3 entry gate changed from "task.md exists" to "accepted phase plan present" (the located project + tasks/phase-plan-<phase>.md). task.md existence becomes the pre-dispatch gate (a sub-gate within Stage 3, after make-prompt).

2. **§2 Handshake Sequence**: Reordered to show: [Stage 2 Plan] → [Stage 3 entry: phase plan present] → [make-prompt: write task.md] → [pre-dispatch gate: check task.md exists] → [dispatch] → [worker writes output/report]. The OLD order where entry gate checks task.md before make-prompt creates it is removed.

3. **§3 Law 2/Law 5**: The Law 4 reference updated from old "PASS iff" to "Verdict Decision Function in evidence-contract.md §Verdict Decision Function".

4. **§4 health-check**: Explicit two-axis framing per C06:
   - Axis 1 — Periodic homes: Stage 1 Orient (full tier) + periodic Stage 4 Verify (full tier).
   - Axis 2 — Transition executor: control invokes light-tier check at each boundary 1→2, 2→3, 3→4, 4→5, 5→6.
   - Make clear these are two different axes, not one.

5. **New §Verify-Worker Handshake (RA2)** or equivalent: The V0→V3 state machine:
   - V0_TARGET_READY: target output+report exist; control either directly reviews or writes verifier/audit task.md
   - V1_VERIFY_PACKET_READY: verifier task.md exists; Law 2 checks it; dispatch
   - V2_VERIFY_RUN_LANDED: verifier output+report exist; control evaluates, writes review-result; insufficient evidence = control-authored FAIL (NOT reviewer-of-review)
   - V3_CONTROL_FINALIZED: target review-result exists + all verify-worker runs have their review-result; Stage 4 exit
   - Key invariant: zero Plan edges, zero reviewer-of-review edges, max 3 forward transitions

6. **C05 phrase guard**: Any lifecycle sentence you add or modify uses "Stage 0 Triage + six-stage lifecycle (Stages 1–6)" or equivalent.

### archive-policy.md:

7. **§Project Fold**: Trigger moved from "before Triage" to "after `enloom` decision". Triage itself is side-effect-free (no files, no dispatch, no moves). Fold is control-owned serial work, NOT a sub-agent dispatch. Fold MUST NOT alter the task_board row.

8. **New resolver precedence (RA4)**: The 7-level precedence table:
   - 1: FOLD_MOVE_PARTIAL (non-complete fold-move-state.md marker)
   - 2: PROJECT_DUPLICATE_ROW (rows > 1)
   - 3: PROJECT_ORPHAN_ROOT (rows = 0 but A or R exists)
   - 4: PROJECT_BOTH_ROOTS (rows = 1 but both active and archive exist)
   - 5: PROJECT_MISSING_ROOT (rows = 1 but neither exists)
   - 6: PROJECT_NEW (rows = 0, nothing exists → create after gates)
   - 7: PROJECT_ACTIVE or PROJECT_FOLDED (rows = 1, exactly one exists → resolve)

9. **fold-move-state.md protocol (RA4)**: Before any fold/reopen move, control MUST write `.enloom/fold-move-state.md` with operation ID, action, targets, row identity, pre-snapshot, intended post-state, status=prepared. After move, update + verify. Non-complete marker → FOLD_MOVE_PARTIAL → hard block Orient. Recovery is control-owned and explicit.

10. **RA4.2 operation-intent**: After error predicates (precedence 1-5) are false, control validates operation intent (lookup|fold|reopen) against base shape. Invalid combos return PROJECT_OPERATION_INVALID with named reason code, zero writes/moves.

11. **Reopen (RA4)**: Reopen from folded = control moves exact directory to active, preserves `created`, updates same row `updated/phase`. MUST NOT create duplicate.

12. **C05 phrase guard**: Any lifecycle sentence uses qualified phrasing.

## Required Verification

```
- id: V01
  command: rg 'Stage 3.*entry.*task\.md|Entry gate.*task\.md' enloom-skill/references/landing-contract.md
  pass_condition: zero hits matching the OLD "task.md as Stage 3 entry gate" pattern (it should now be the pre-dispatch gate, not entry)
  fail_signal: any hit means the circular entry dependency remains
  named_list: circular_entry_residue

- id: V02
  command: rg -c 'make-prompt' enloom-skill/references/landing-contract.md
  pass_condition: count >= 2 (make-prompt appears in the handshake sequence AND as the creator of task.md before dispatch)
  fail_signal: count < 2
  named_list: make_prompt_check

- id: V03
  command: rg 'V0_TARGET_READY|V1_VERIFY_PACKET_READY|V2_VERIFY_RUN_LANDED|V3_CONTROL_FINALIZED' enloom-skill/references/landing-contract.md
  pass_condition: all 4 RA2 states present
  fail_signal: any missing
  named_list: ra2_states

- id: V04
  command: rg 'reviewer-of-review|Plan.*edge|return.*Plan' enloom-skill/references/landing-contract.md
  pass_condition: present as FORBIDDEN (e.g. "zero reviewer-of-review edges", "MUST NOT return to Plan")
  fail_signal: absent entirely (RA2 non-recursion not stated)
  named_list: ra2_non_recursion

- id: V05
  command: rg 'FOLD_MOVE_PARTIAL|PROJECT_DUPLICATE_ROW|PROJECT_ORPHAN_ROOT|PROJECT_BOTH_ROOTS|PROJECT_MISSING_ROOT|PROJECT_OPERATION_INVALID' enloom-skill/references/archive-policy.md
  pass_condition: all RA4 error enums present
  fail_signal: any missing
  named_list: ra4_enums

- id: V06
  command: rg 'fold-move-state' enloom-skill/references/archive-policy.md
  pass_condition: at least 1 hit (RA4 snapshot protocol described)
  fail_signal: zero hits
  named_list: ra4_snapshot

- id: V07
  command: rg '再做 Triage|进新任务前.*fold|before.*Triage.*fold' enloom-skill/references/archive-policy.md
  pass_condition: zero hits (old "fold before Triage" wording gone)
  fail_signal: any hit means pre-triage fold wording remains
  named_list: old_fold_timing

- id: V08
  command: rg '派 sub-agent|dispatch.*sub-agent' enloom-skill/references/archive-policy.md
  pass_condition: zero hits in fold context (fold is control-owned, not sub-agent dispatched)
  fail_signal: any hit means fold still dispatches a worker
  named_list: fold_worker_dispatch

- id: V09
  command: rg 'Verdict Decision Function' enloom-skill/references/landing-contract.md
  pass_condition: at least 1 hit (L4 reference updated to P1's new function)
  fail_signal: zero hits
  named_list: p1_reference_update
```

Countable outputs:
- Number of RA2 states (should be exactly 4)
- Number of RA4 error enums (should be exactly 6: FOLD_MOVE_PARTIAL + 4 namespace errors + PROJECT_OPERATION_INVALID)
- Number of RA4 success enums (should be exactly 3: PROJECT_NEW, PROJECT_ACTIVE, PROJECT_FOLDED)

## Evidence Required

Command outputs for V01–V09, plus the full rewritten file texts in output.md.

## Review Budget

report.md + output.md.

## Done Signal

Return `done` with paths to output.md and report.md.
