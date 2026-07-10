# Output: T-P4-02

Task: 2 C13 mechanical fixes + consumer alignment (C10 resolver / C13 owner).

## Per-file change summary

### 1. enloom-skill/references/templates/worker-report.md (C13 fix 1)
- Line 44: `[Registry](../registry-and-compaction.md §1)` → `[Registry §1](../registry-and-compaction.md)`.
- The `§1` was inside the link target (malformed Markdown). Moved to the label; target now holds only the resolvable relative path.

### 2. enloom-skill/references/templates/task-packet.md (C13 fix 2)
- Line 38: `[Ownership Table](../registry-and-compaction.md §2)` → `[Ownership Table §2](../registry-and-compaction.md)`.
- Same defect shape; `§2` moved from target to label.

### 3. enloom-skill/references/workflow-steps.md (C10 consumer)
- Stage 1 Orient, read order rewritten: step 1 now instructs running the C10 resolver — check **both** candidate roots (active `.enloom/<created>-<project>/` and archive `.enloom/archive/<created>-<project>/`) and resolve to the single existing directory, instead of an unconditional active-root path.
- Steps 2–5 changed from hardcoded `.enloom/<project>/...` paths to "the resolved project's `...`".
- Added reference to `templates/task-board.md §Resolver` as the resolver owner.

### 4. enloom-skill/SKILL.md (C10 consumer)
- File Protocol section: added a new paragraph "Locating a project — two-root resolution (C10)." right after the task_board.md namespace entry point paragraph. States: never assume active root; resolver checks both active + archive roots; folded closed projects resolve from archive root. References `references/templates/task-board.md §Resolver`.

### 5. enloom-skill/references/glossary.md (C10 consumer)
- **Project** term: appended C10 two-root resolver note (active + archive candidates; folded closed projects resolve from archive root; never assume active root).
- **task_board** term: appended "再跑 C10 两根 resolver 解析到唯一目录".
- **Fold / 折叠** term: appended "fold 后项目从 archive 根解析（C10 两根 resolver）" + resolver reference to `templates/task-board.md §Resolver`.

### 6. AGENTS.md (C13 owner pointer)
- Discipline item 3 (改 references 时查交叉引用): appended normative statement that the owner of reference-link integrity is `validation.md §Markdown Reference Integrity`. Restates the rule (target holds only resolvable path; `§N` in label/prose not target; inline-code pseudo-links stay code) and points to validation.md as the SSOT owner.

## No-op confirmations (left as-is, correct per task)

- phase-plan.md line 78 `[landing-contract.md](../landing-contract.md) §1` — §1 already outside target. Untouched.
- project-state.md line 3 `[Compaction Protocol](../registry-and-compaction.md) §4` — correct. Untouched.
- task-board.md line 23 `[archive-policy.md](../archive-policy.md) §Project Fold` — correct. Untouched.

## Forbidden files — not written

- enloom-skill/references/templates/task-board.md — Read only (C10 resolver owner). Not edited.
- enloom-skill/references/validation.md — Read only (C11+C13 owner). Not edited.
- Both show `M` in `git status` but those modifications are from the T-P4-01 owner task (uncommitted); this worker made zero edits to either. Verified the Resolver / Markdown Reference Integrity sections are byte-identical to the version read at task start.
