# Task Packet: T-P5-02

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Align 4 consumer files with C05 (lifecycle naming), C12 (compatibility preflight references), and C14 (install command references).

## Anti Goal

- Do NOT modify workflow-steps.md, SKILL.md, or README.md — locked by T-P5-01.
- Do NOT change description/trigger wording.
- Do NOT change Evidence/lifecycle/ownership/namespace/validation semantics.

## Inputs

1. The P5 owners: workflow-steps.md (C05), SKILL.md (C12), README.md (C14).
2. Canonical rules: C05, C12, C14 from `runs/T-P0-02/output.md`.

## Existing State

### glossary.md:
- Lifecycle Stage entry: needs C05 broad cleanup (one-plus-six terminology).
- Any health-check entry may need C12/C08 consistency check.

### trigger-contract.md:
- §与 triage 子动作的关系: references lifecycle entry but may need C12 preflight reference (Triage → enloom → C12 preflight → Orient).

### PROGRESS.md:
- May reference lifecycle naming or install — align with C05/C14.

### review-checklist.md:
- May reference compatibility or preflight — ensure C12 consistency if applicable.

## Allowed Tools

Read, Write, Edit, Grep, Bash

## Writable Files

- `enloom-skill/references/glossary.md`
- `enloom-skill/references/trigger-contract.md`
- `PROGRESS.md`
- `enloom-skill/references/review-checklist.md`

## Forbidden Files

- `enloom-skill/references/workflow-steps.md` (LOCKED)
- `enloom-skill/SKILL.md` (LOCKED)
- `README.md` (LOCKED)
- All other files
- All `.enloom/`, `design/`

## Output Files

- `runs/T-P5-02/output.md` — per-file change summary
- `runs/T-P5-02/report.md` — Evidence Contract four elements

## Acceptance Criteria

1. **glossary.md**: Lifecycle Stage entry uses one-plus-six terminology. No unqualified "six stages" when describing 7 rows.

2. **trigger-contract.md**: Triage → enloom mapping mentions C12 preflight (after enloom decision, before .enloom write, independent sub-agent availability check).

3. **PROGRESS.md**: Any lifecycle naming or install references aligned with C05/C14.

4. **review-checklist.md**: Any compatibility/preflight references consistent with C12.

## Required Verification

```
- id: V01
  command: rg 'six-stage lifecycle|Stage 0 Triage.*six|六阶段|one.*plus.*six' enloom-skill/references/glossary.md
  pass_condition: at least 1 hit (C05 applied)
  fail_signal: 0 hits
  named_list: c05_glossary

- id: V02
  command: rg 'preflight|compatibility|independent.sub.agent' enloom-skill/references/trigger-contract.md
  pass_condition: at least 1 hit (C12 referenced)
  fail_signal: 0 hits
  named_list: c12_trigger
```

Countable outputs:
- Consumer files changed (should be at most 4)
- Files with unqualified "six stages" (should decrease)

## Done Signal

Return `done` with paths.
