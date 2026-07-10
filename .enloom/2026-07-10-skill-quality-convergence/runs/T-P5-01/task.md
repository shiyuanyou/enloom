# Task Packet: T-P5-01

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Implement C05 (broad lifecycle naming cleanup — "Stage 0 Triage + six-stage lifecycle (Stages 1–6)"), C12 (compatibility preflight in SKILL.md), and C14 (executable Install documentation in README.md) in three owner files.

## Anti-Goal

- Do NOT change the `description` field in SKILL.md frontmatter (F-D7-02: trigger evidence insufficient).
- Do NOT touch Evidence/lifecycle/ownership/namespace semantics.
- Do NOT touch consumer files (glossary, trigger-contract, PROGRESS, review-checklist are T-P5-02).

## Inputs

1. Canonical rules in `runs/T-P0-02/output.md`:
   - C05 (lines 85-96): Lifecycle Count and Naming
   - C12 (lines 176-187): Early Full-Mode Compatibility Preflight
   - C14 (lines 202-213): Reproducible Install Documentation
   - C05 amendment (line 465): phrase guard (already applied in P2; P5 does broad cleanup)
   - C12 amendment (line 466): hard/soft unknown — independent sub-agent is sole hard halt
   - C14 amendment (line 470): installer invocation unknown until P5 executes

2. Current content of the 3 owner files (read them).
3. The C12 rule: SKILL.md frontmatter is machine-facing summary. Full Enloom requires independent sub-agent dispatch. After Triage returns `enloom` but before creating/updating `.enloom/`, folding, or dispatching, control MUST preflight independent-sub-agent availability. `no` or `unknown` MUST halt with a minimal runtime-switch message.

## Existing State

### workflow-steps.md (post-P2):
- Lines 1-13: The lifecycle overview shows "0. Triage → ... 6. Close" (7 numbered rows). The header says "six stages" but there are 7 rows. Per C05: the normative name is "Stage 0 Triage entry decision + six-stage lifecycle, Stages 1 Orient through 6 Close."
- P2 applied C05 phrase guard to new/modified sentences, but there are still pre-existing sentences that say "six stages" while showing 7 rows.

### SKILL.md (post-P3):
- Frontmatter (lines 1-4): `name: enloom`, `description: ...`. DO NOT CHANGE description.
- MISSING: C12 compatibility metadata/prose. Full Enloom requires independent sub-agent; this must be stated in the frontmatter compatibility/metadata area AND in the body.
- MISSING: C12 preflight timing (after Triage=enloom, before any .enloom write).

### README.md (136 lines):
- §Install (lines 70-78): Currently says "Installed globally at ~/.agents/skills/enloom/" but has a comment-only code block (lines 74-76: `# from this repo, package + install (uses skill-creator tooling)`). Per C14: MUST identify supported packaging/install mechanism, provide executable command, state destination, provide parity check.
- §How it works (line 35): Says "六阶段生命周期" — C05 broad cleanup needed.
- §Five Laws (line 52): Says "archive gate requires every report's Review Result filled" — P3 changed this to review-result.md. Update for consistency.

## Allowed Tools

Read, Write, Edit, Grep, Bash

## Writable Files

- `enloom-skill/references/workflow-steps.md`
- `enloom-skill/SKILL.md`
- `README.md`

## Forbidden Files

- ALL other files under `enloom-skill/` and root
- ALL `.enloom/`, `design/`
- `~/.agents/skills/enloom/`

## Output Files

- `runs/T-P5-01/output.md` — per-file change summary
- `runs/T-P5-01/report.md` — Evidence Contract four elements

## Acceptance Criteria

### workflow-steps.md (C05):

1. The lifecycle overview header/framing uses "Stage 0 Triage entry decision + six-stage lifecycle (Stages 1–6)" or equivalent. The 7-row walkthrough is explicitly qualified as "one entry stage (Stage 0) plus six lifecycle stages (Stages 1–6)."

2. No unqualified "six stages / 六阶段" that actually describes all seven rows. Where "six stages" appears, it must be qualified or the sentence must be rephrased.

### SKILL.md (C12):

3. **Compatibility metadata/prose**: Full Enloom requires dispatch to an independent sub-agent; there is no control-self-execution fallback. This MUST be stated in a §Compatibility Preflight section (or equivalent). The frontmatter may get a `compatibility` field if appropriate (but DO NOT change `description`).

4. **Preflight timing**: After Triage returns `enloom` but before creating/updating `.enloom/`, folding, or dispatching, control MUST preflight independent-sub-agent availability. `no` or `unknown` MUST halt with a minimal runtime-switch message. Concurrent dispatch and model/session diversity are optional C08 facts, not compatibility requirements.

5. **C12 amendment**: Independent sub-agent `no|unknown` is the sole hard halt before any `.enloom` write. The other three C08 unknowns are soft.

### README.md (C14):

6. **Install section**: Replace the comment-only code block with an executable procedure. The supported mechanism is `cp -r enloom-skill/ ~/.agents/skills/enloom/` (this is the actual sync method used in practice). State the destination (`~/.agents/skills/enloom/`). Provide a parity check (`diff -qr enloom-skill/ ~/.agents/skills/enloom/`).

7. **C05 in README**: §How it works "六阶段生命周期" qualified or updated to "Stage 0 Triage + 六阶段生命周期" or equivalent.

8. **Five Laws update**: Line 52 "archive gate requires every report's Review Result filled" → "archive gate requires every review-result.md to exist" (P3 consistency).

## Required Verification

```
- id: V01
  command: rg -c 'six-stage lifecycle|Stage 0 Triage.*six|六阶段' enloom-skill/references/workflow-steps.md
  pass_condition: at least 2 hits (C05 broad cleanup applied)
  fail_signal: < 2 hits
  named_list: c05_workflow

- id: V02
  command: rg 'compatibility|Compatibility Preflight|independent.sub.agent.*require|preflight' enloom-skill/SKILL.md
  pass_condition: at least 2 hits (C12 section exists)
  fail_signal: < 2 hits
  named_list: c12_skill

- id: V03
  command: rg 'no.*fallback|halt.*runtime|no control.*self.*execution|self-execution fallback' enloom-skill/SKILL.md
  pass_condition: at least 1 hit (no self-execution fallback stated)
  fail_signal: 0 hits
  named_list: c12_no_fallback

- id: V04
  command: rg 'cp.*enloom-skill|diff.*qr.*enloom' README.md
  pass_condition: at least 2 hits (executable install command + parity check)
  fail_signal: < 2 hits
  named_list: c14_install

- id: V05
  command: rg '# from this repo|#.*skill-creator tooling' README.md
  pass_condition: zero hits (comment-only block replaced)
  fail_signal: any hit
  named_list: c14_comment_block

- id: V06
  command: rg 'description:' enloom-skill/SKILL.md
  pass_condition: exactly 1 hit (description NOT changed — count stays at 1)
  fail_signal: > 1 hit would mean description was duplicated
  named_list: f_d7_02_guard

- id: V07
  command: rg 'Review Result filled|report.*Review Result' README.md
  pass_condition: zero hits (P3 consistency — review-result.md)
  fail_signal: any hit
  named_list: p3_readme_consistency
```

Countable outputs:
- C05 qualified phrases (should increase from P2 baseline)
- C12 compatibility statements (should be >= 2)
- C14 executable commands (should be >= 2: install + parity)
- description field count (should be exactly 1, unchanged)

## Done Signal

Return `done` with paths.
