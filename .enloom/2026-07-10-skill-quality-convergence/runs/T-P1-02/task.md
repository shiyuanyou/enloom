# Task Packet: T-P1-02

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Align all Evidence Contract consumer files with the new §Verdict Decision Function (C01/RA1/RA1.2) and the revised §The Four Elements (C02) that T-P1-01 just landed in `evidence-contract.md`. Every consumer must reference the owner instead of restating an independent formula, and every four-field usage must reflect the disjoint semantics (Not Checked = required omissions only; Known Blind Spots = structural limitations with `blocks_check_ids`).

## Anti Goal

- Do NOT modify `evidence-contract.md` — it is locked by T-P1-01 and is now the frozen owner.
- Do NOT change lifecycle structure, ownership model, namespace, validation, or install docs — those belong to P2–P5.
- Do NOT introduce any new verdict formula in consumers — consumers reference the owner, they do not restate it.
- Do NOT rename the four field names.
- Do NOT change description/trigger wording.
- For `workflow-steps.md`: ONLY update Evidence/Verify-related references. Do NOT touch lifecycle stage descriptions.

## Inputs

1. The rewritten owner file: `enloom-skill/references/evidence-contract.md` (183 lines) — read this first.
2. The canonical rules in `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/output.md` — C01 (lines 33-44), C02 (lines 46-57), RA1 (lines 355-398), RA1.2 (lines 514-545).
3. The consumer files themselves (their current content).

## Existing State

Each consumer currently has its own restatement of the verdict formula or four-field semantics, which now contradicts the new owner. Key issues per file:

### `references/review-checklist.md`
- §三态 verdict table (line 15-19) restates the PASS formula independently
- §accepted 的必要条件 (line 24-31) describes Not Checked / Known Blind Spots with old semantics
- The "硬约束" paragraph (line 21) restates the old "PASS iff" formula

### `references/templates/worker-report.md`
- §Not Checked comment (line 24): "which verifications should have run but did not. Declared blind spots, explicitly, not hidden."
- §Known Blind Spots comment (line 29): "for each Not Checked item: why it was not checked" — this conflates the two fields
- The three structural blind spots listed in the template (lines 30-32) are framed as if they go in Not Checked

### `references/templates/audit-task-packet.md`
- §Conclusion Rules (lines 38-42): restates the old PASS formula ("verdict = PASS requires: every declared check run + non-empty evidence")
- §Not Checked (line 58): "checks that should have run but did not, with why and the risk size (Evidence Contract element 3 + 4)" — conflates elements 3 and 4

### `prompt-assets/reviewer.md`
- §Output (lines 26-35): restates verdict definitions and conclusion mappings independently
- §How to review step 2 (line 42): restates the hard constraint

### `prompt-assets/coder.md`
- §Output bullet 2 (line 25): references the four elements — needs to confirm it points to the owner's disjoint semantics
- §How to work step 3-4 (lines 31-33): restates four-field usage

### `prompt-assets/researcher.md`
- §Output bullet 2 (line 25): references the four elements

### `references/glossary.md`
- **Verdict** entry (line 32): "三态验收结论" — needs to reference the total decision function
- **Evidence Contract** entry (line 29): "详见 evidence-contract.md" — OK but may need the "total function" note
- Lines 63-64: "不要把「Verdict」和 review 结论混用" — keep, ensure consistency with mandatory mapping

### `references/workflow-steps.md`
- Only the Verify stage Evidence-related references. Search for "Evidence Contract", "PASS", "four elements", "hard constraint", "verdict" references and update them to point to §Verdict Decision Function.

## Allowed Tools

Read, Write, Edit (only on Writable Files), Grep, Bash

## Writable Files

- `enloom-skill/references/review-checklist.md`
- `enloom-skill/references/templates/worker-report.md`
- `enloom-skill/references/templates/audit-task-packet.md`
- `enloom-skill/prompt-assets/reviewer.md`
- `enloom-skill/prompt-assets/coder.md`
- `enloom-skill/prompt-assets/researcher.md`
- `enloom-skill/references/glossary.md`
- `enloom-skill/references/workflow-steps.md`

## Forbidden Files

- `enloom-skill/references/evidence-contract.md` (LOCKED — frozen by T-P1-01)
- All files under `.enloom/`
- All files under `design/`
- `README.md`, `PROGRESS.md`, `CHANGELOG.md`, `AGENTS.md`
- `enloom-skill/SKILL.md`
- `enloom-skill/references/landing-contract.md`
- `enloom-skill/references/archive-policy.md`
- `enloom-skill/references/scheduler-rules.md`
- `enloom-skill/references/registry-and-compaction.md`
- `enloom-skill/references/templates/task-packet.md`
- `enloom-skill/references/templates/phase-plan.md`
- `enloom-skill/references/templates/project-state.md`
- `enloom-skill/references/templates/archive-entry.md`
- `enloom-skill/references/templates/task-board.md`
- All files under `~/.agents/skills/enloom/`

## Output Files

- `runs/T-P1-02/output.md` — per-file change summary (what changed in each of the 8 files)
- `runs/T-P1-02/report.md` — Evidence Contract four elements report

## Acceptance Criteria

1. **No consumer restates an independent verdict formula.** Each consumer that previously restated "PASS iff checks ran and evidence is non-empty" or equivalent MUST instead reference `evidence-contract.md §Verdict Decision Function` as the owner.

2. **Four-field semantics aligned** across all consumers:
   - `Not Checked` = packet-declared required-check IDs not executed (blocks PASS)
   - `Known Blind Spots` = structural/runtime/out-of-scope limitations (can coexist with PASS when `blocks_check_ids=[]`)
   - No consumer conflates the two

3. **`review-checklist.md`**: the 三态 verdict table and 硬约束 paragraph reference the owner; accepted 必要条件 updated for C02 disjoint semantics.

4. **`worker-report.md`**: §Not Checked comment updated ("packet-declared required checks not executed"); §Known Blind Spots comment updated ("structural limitations, NOT explanations for Not Checked items"); the three structural blind spots reframed as Known Blind Spots entries with `blocks_check_ids=[]`.

5. **`audit-task-packet.md`**: §Conclusion Rules references §Verdict Decision Function; §Not Checked updated for C02.

6. **`reviewer.md`**: verdict/conclusion definitions reference the owner; the hard constraint reference updated.

7. **`coder.md`** and **`researcher.md`**: four-element references point to the owner's disjoint semantics.

8. **`glossary.md`**: Verdict and Evidence Contract entries updated to mention the total decision function.

9. **`workflow-steps.md`**: Verify-stage Evidence references point to §Verdict Decision Function. (ONLY Evidence-related references; do NOT touch lifecycle structure.)

## Required Verification

```
- id: V01
  command: rg -l 'if and only if|当且仅当|Typical review conclusion|mapping is a default' enloom-skill/references/review-checklist.md enloom-skill/references/templates/worker-report.md enloom-skill/references/templates/audit-task-packet.md enloom-skill/prompt-assets/reviewer.md enloom-skill/prompt-assets/coder.md enloom-skill/prompt-assets/researcher.md enloom-skill/references/glossary.md enloom-skill/references/workflow-steps.md
  pass_condition: zero hits across all 8 consumer files
  fail_signal: any file listed means old formula residue remains
  named_list: legacy_formula_residue

- id: V02
  command: rg -c 'Verdict Decision Function' enloom-skill/references/review-checklist.md enloom-skill/references/templates/audit-task-packet.md enloom-skill/prompt-assets/reviewer.md
  pass_condition: at least 1 hit per file (these 3 are the primary consumers that must reference the new section)
  fail_signal: any of the 3 files with 0 hits
  named_list: owner_reference_check

- id: V03
  command: rg 'Not Checked.*blind spot|blind spot.*Not Checked|for each Not Checked item|checks that should have run but did not, with why' enloom-skill/references/templates/worker-report.md enloom-skill/references/templates/audit-task-packet.md
  pass_condition: zero hits (old conflation language removed)
  fail_signal: any hit means old C02-violating conflation remains
  named_list: c02_conflation_residue

- id: V04
  command: diff -q enloom-skill/references/evidence-contract.md /dev/null 2>&1; git diff --name-only
  pass_condition: evidence-contract.md is NOT in the changed list (forbidden file was not touched)
  fail_signal: evidence-contract.md appears in git diff
  named_list: forbidden_file_violation
```

Countable outputs:
- Number of consumer files changed (should be exactly 8)
- Number of files with old formula residue (should be 0)

## Evidence Required

Command outputs for V01–V04, plus per-file change summary in output.md.

## Review Budget

report.md + output.md.

## Pending / Promise Registry Updates

None.

## Human Decision Gate

None.

## Done Signal

Return `done` with paths to output.md and report.md, or `blocked`/`failed` with reason.
