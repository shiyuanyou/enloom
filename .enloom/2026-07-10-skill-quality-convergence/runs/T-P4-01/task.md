# Task Packet: T-P4-01

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Implement C10 (deterministic two-root project namespace resolver) in `task-board.md` template, and C11 (honest validation paths with V01/V02 enum) + C13 owner (Markdown reference integrity rule) in `validation.md`.

## Anti Goal

- Do NOT touch templates other than task-board.md — worker-report.md and task-packet.md fixes are T-P4-02.
- Do NOT change Evidence/lifecycle/ownership semantics.
- Do NOT change description/trigger wording.
- Do NOT do broad naming cleanup (P5).

## Inputs

1. Canonical rules in `runs/T-P0-02/output.md`:
   - C10 (lines 150-161): Deterministic Project Namespace Resolver
   - C11 (lines 163-174): Honest Validation Paths
   - C13 (lines 189-200): Valid Markdown Reference Targets
   - RA4 (lines 439-459): resolver 7-level precedence table
   - RA4.2 (lines 547-574): operation-intent precedence
   - Namespace resolver examples (lines 304-312): N01-N03 + negative cases
   - Validation decision table (lines 314-319): V01/V02 paths
   - C11 amendment (line 468): V01 enum expansion + V02 selector
   - C13 amendment (line 469): owner moves from AGENTS.md to validation.md

2. Current content of `templates/task-board.md` (29 lines) and `validation.md` (92 lines).
3. The P2 archive-policy.md (already has RA4 resolver precedence — task-board.md should reference it, not duplicate).

## Existing State

### task-board.md (29 lines):
- §用法 (lines 20-23): Has `cd .enloom/<created>-<project>/` (line 20) — unconditional active-root assumption. Per C10, resolver must check BOTH `.enloom/<dir>` and `.enloom/archive/<dir>`.
- §复用 (line 22): "同名 project 已有行 → 复用其目录" — doesn't mention two-root resolution or folded projects.
- §闭合 (line 23): "closed 项目目录会在堆积 ≥3 时由 fold 折叠到 .enloom/archive/" — mentions archive but doesn't describe resolution.
- MISSING: C10 resolver algorithm, RA4 error enum references, reopen semantics.

### validation.md (92 lines):
- §What to check (lines 8-22): Lists 11 rules. The problem is C11: the bash implementation (lines 41-82) claims to handle flat key:value lines, but the 11-rule contract implies full YAML validation capability. Per C11, need to separate V01 (full official-capable) from V02 (flat fallback) with explicit promise boundaries.
- §Reference: bash implementation (lines 41-82): The bash script claims to validate everything but actually only handles flat scalars.
- MISSING: C11 V01/V02 enum, C11 promise boundary statement, C13 Markdown Reference Integrity rule.

## Allowed Tools

Read, Write, Edit, Grep, Bash

## Writable Files

- `enloom-skill/references/templates/task-board.md`
- `enloom-skill/references/validation.md`

## Forbidden Files

- ALL other files under `enloom-skill/`
- ALL `.enloom/`, `design/`, root docs

## Output Files

- `runs/T-P4-01/output.md` — full rewritten content + change summary
- `runs/T-P4-01/report.md` — Evidence Contract four elements

## Acceptance Criteria

### task-board.md (C10):

1. **New §Resolver section**: The two-root algorithm:
   - Input: stable project slug from `project` column.
   - `task_board` MUST contain at most one row for it.
   - Derive `<created>-<project>` and check exactly two candidates: `.enloom/<dir>` and `.enloom/archive/<dir>`.
   - Exactly one existing candidate resolves; both or neither with an existing row = blocking namespace error.
   - A directory without a row is an orphan and blocks creation.
   - No row and no candidate = create one new project.

2. **RA4/RA4.2 error enum references**: Reference the precedence table in archive-policy.md (don't duplicate it). Name the key error states: FOLD_MOVE_PARTIAL, PROJECT_DUPLICATE_ROW, PROJECT_ORPHAN_ROOT, PROJECT_BOTH_ROOTS, PROJECT_MISSING_ROOT, PROJECT_OPERATION_INVALID.

3. **Reopen semantics**: Reopening an archived same-name project = control moves exact directory back to active root, preserves `created`, updates same row `updated/phase`. MUST NOT create a duplicate.

4. **Remove unconditional `cd .enloom/<created>-<project>/`**: Replace with resolver-based resolution that checks both roots.

### validation.md (C11 + C13):

5. **New §Validation Paths and Promise Boundary section** (C11):
   - **V01 Full official-capable path**: A currently available YAML-capable validator executes all documented frontmatter rules. Enum: `FULL_VALID | FULL_INVALID | FULL_VALIDATOR_UNAVAILABLE | FULL_RULE_GAP | FULL_EXECUTION_ERROR`. Exit 0 may mean full contract passed ONLY when validator/version and rule coverage are evidenced.
   - **V02 Flat fallback path**: No dependency. Supports only declared unindented single-line flat scalar subset. Enum: `FLAT_VALID | FLAT_INVALID | FLAT_UNSUPPORTED`. Exit 0 means only "flat subset valid," NEVER full YAML-contract equivalence. Nested/multiline/type-sensitive input → `FLAT_UNSUPPORTED` (non-zero, NOT `INVALID`).
   - If full validation required but unavailable/fails → control halts validation; MUST NOT relabel fallback success as full success.

6. **Update §What to check**: The 11 rules remain the contract, but clarify which rules the flat fallback can actually execute vs. which need a YAML-capable validator.

7. **Update §Reference: bash implementation**: Explicitly state it implements ONLY the flat-fallback subset (V02). It returns `FLAT_UNSUPPORTED` for nested/multiline input, not `INVALID`. Do not claim it does full YAML validation.

8. **New §Markdown Reference Integrity section** (C13): 
   - A Markdown link target MUST contain only a resolvable relative path/URL.
   - A human-readable `§Section Title` hint MUST appear in the label or adjacent prose, NEVER inside the target.
   - Inline code examples like `` `[x](path)` `` MUST remain code, not be "fixed" as links.
   - This section is the unique owner SSOT for reference-link integrity (moved from AGENTS.md).

## Required Verification

```
- id: V01
  command: rg 'cd \.enloom/' enloom-skill/references/templates/task-board.md
  pass_condition: zero hits matching unconditional active-root cd
  fail_signal: any hit
  named_list: old_resolver

- id: V02
  command: rg 'archive/' enloom-skill/references/templates/task-board.md
  pass_condition: at least 1 hit (two-root resolver checks archive)
  fail_signal: 0 hits
  named_list: two_root_check

- id: V03
  command: rg 'FOLD_MOVE_PARTIAL|PROJECT_DUPLICATE_ROW|PROJECT_ORPHAN_ROOT|PROJECT_BOTH_ROOTS|PROJECT_MISSING_ROOT|PROJECT_OPERATION_INVALID' enloom-skill/references/templates/task-board.md
  pass_condition: at least 1 hit (error enum referenced)
  fail_signal: 0 hits
  named_list: c10_error_enum

- id: V04
  command: rg 'FULL_VALID|FULL_INVALID|FULL_VALIDATOR_UNAVAILABLE|FLAT_VALID|FLAT_INVALID|FLAT_UNSUPPORTED' enloom-skill/references/validation.md
  pass_condition: all V01+V02 enums present
  fail_signal: any missing
  named_list: c11_enums

- id: V05
  command: rg 'UNSUPPORTED' enloom-skill/references/validation.md
  pass_condition: at least 1 hit (C11 fallback returns UNSUPPORTED not INVALID for out-of-subset)
  fail_signal: 0 hits
  named_list: c11_unsupported

- id: V06
  command: rg 'Markdown Reference Integrity|reference.integrity|reference-link' enloom-skill/references/validation.md
  pass_condition: at least 1 hit (C13 owner section exists)
  fail_signal: 0 hits
  named_list: c13_owner

- id: V07
  command: rg '§Section.*Title|§.*hint.*label|§.*target' enloom-skill/references/validation.md
  pass_condition: at least 1 hit (C13 rule stated: § belongs in label, not target)
  fail_signal: 0 hits
  named_list: c13_rule
```

Countable outputs:
- C10 resolver cases (should cover: N01 active, N02 folded, N03 reopen, + 4 negative cases referenced)
- V01 enums (should be exactly 5)
- V02 enums (should be exactly 3)

## Done Signal

Return `done` with paths.
