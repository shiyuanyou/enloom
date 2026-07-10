# Task Packet: T-P4-02

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Fix the 2 C13 mechanical defects (§ written into Markdown link targets) in templates, and align consumers with the C10 resolver and C13 owner.

## Anti Goal

- Do NOT touch task-board.md or validation.md — locked by T-P4-01.
- Do NOT change Evidence/lifecycle/ownership/validation semantics.
- Do NOT change description/trigger wording.

## Inputs

1. The P4 owners: `templates/task-board.md` (C10 resolver), `validation.md` (C11+C13 owner).
2. The 2 C13 defects to fix (found by `rg '\]\([^)]*\.md §[0-9]+\)' enloom-skill/references/templates/`):
   - `templates/worker-report.md` line 44: `[Registry](../registry-and-compaction.md §1)` — the `§1` is inside the link target
   - `templates/task-packet.md` line 38: `[Ownership Table](../registry-and-compaction.md §2)` — the `§2` is inside the link target

## Existing State — Key Changes

### templates/worker-report.md:
- Line 44: `[Registry](../registry-and-compaction.md §1)` → fix to `[Registry §1](../registry-and-compaction.md)` (move §1 to label)

### templates/task-packet.md:
- Line 38: `[Ownership Table](../registry-and-compaction.md §2)` → fix to `[Ownership Table §2](../registry-and-compaction.md)` (move §2 to label)

### Other C13 instances to check:
- `phase-plan.md` line 78: `[landing-contract.md](../landing-contract.md) §1` — this is CORRECT (§1 is outside the target, in adjacent prose). Leave as-is.
- `project-state.md` line 3: `[Compaction Protocol](../registry-and-compaction.md) §4` — CORRECT (§4 outside target). Leave as-is.
- `task-board.md` line 23: `[archive-policy.md](../archive-policy.md) §Project Fold` — CORRECT. Leave as-is.

### Consumer alignment for C10 resolver:
- `workflow-steps.md` Stage 1 Orient: check if it references the old unconditional project path — update to reference resolver.
- `SKILL.md` File Protocol: check if namespace resolution needs resolver reference.
- `glossary.md`: Project/task_board/Fold terms — ensure two-root resolver mentioned.

### Consumer alignment for C13:
- `AGENTS.md`: C13 owner moved to validation.md. Update any normative reference-link guidance in AGENTS.md to point to validation.md §Markdown Reference Integrity as the owner.

## Allowed Tools

Read, Write, Edit, Grep, Bash

## Writable Files

- `enloom-skill/references/templates/worker-report.md`
- `enloom-skill/references/templates/task-packet.md`
- `enloom-skill/references/workflow-steps.md`
- `enloom-skill/SKILL.md`
- `enloom-skill/references/glossary.md`
- `AGENTS.md`

## Forbidden Files

- `enloom-skill/references/templates/task-board.md` (LOCKED)
- `enloom-skill/references/validation.md` (LOCKED)
- All other references and templates
- All `.enloom/`, `design/`, other root docs

## Output Files

- `runs/T-P4-02/output.md` — per-file change summary
- `runs/T-P4-02/report.md` — Evidence Contract four elements

## Acceptance Criteria

1. **C13 defect fix**: `rg '\]\([^)]*\.md §[0-9]+\)' enloom-skill/references/templates/` returns 0 hits across ALL template files.

2. **worker-report.md**: The Registry link has §1 moved to label: `[Registry §1](../registry-and-compaction.md)` or equivalent.

3. **task-packet.md**: The Ownership Table link has §2 moved to label.

4. **workflow-steps.md**: Stage 1 Orient references resolver-based project location (not unconditional active-root path).

5. **SKILL.md**: File Protocol section mentions two-root resolution if applicable.

6. **glossary.md**: Project/task_board/Fold terms reference two-root resolver.

7. **AGENTS.md**: C13 reference-link guidance points to validation.md as owner.

## Required Verification

```
- id: V01
  command: rg '\]\([^)]*\.md §[0-9]+\)' enloom-skill/references/templates/
  pass_condition: zero hits (ALL C13 mechanical defects fixed)
  fail_signal: any hit
  named_list: c13_defects_remaining

- id: V02
  command: rg '\.\./registry-and-compaction\.md §' enloom-skill/references/templates/worker-report.md enloom-skill/references/templates/task-packet.md
  pass_condition: zero hits (old malformed pattern gone from these 2 files)
  fail_signal: any hit
  named_list: old_malformed_pattern

- id: V03
  command: rg 'resolver|two.root|两根|archive/.*active|active.*archive' enloom-skill/references/workflow-steps.md enloom-skill/references/glossary.md
  pass_condition: at least 1 hit per file (C10 resolver referenced)
  fail_signal: any file with 0 hits
  named_list: c10_consumer_refs
```

Countable outputs:
- C13 defects fixed (should be exactly 2)
- C13 defects remaining (should be 0)

## Done Signal

Return `done` with paths.
