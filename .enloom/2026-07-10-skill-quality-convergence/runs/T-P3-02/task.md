# Task Packet: T-P3-02

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Align all consumer files with the RA3 file-level ownership split (report.md = worker, review-result.md = control), C08 runtime capability references, and C09 role-to-asset route. The key mechanical change: remove `## Review Result` section from `worker-report.md` template; add `review-result.md` to all packet template Forbidden lists; update all gate references from "report.md Review Result section" to "review-result.md."

## Anti Goal

- Do NOT modify landing-contract.md, scheduler-rules.md, or SKILL.md — locked by T-P3-01.
- Do NOT change Evidence Contract semantics (P1) or lifecycle/dispatch structure (P2).
- Do NOT change description/trigger wording.
- Do NOT do broad naming cleanup (P5).

## Inputs

1. The rewritten P3 owners (read them): landing-contract.md (RA3 7-row table), scheduler-rules.md (C08 4-dimension), SKILL.md (C09 5-role route).
2. Canonical rules: C07/RA3, C08, C09 from `runs/T-P0-02/output.md`.
3. Current content of the 9 consumer files.

## Existing State — Key Problems Per File

### templates/worker-report.md:
- Has `## Review Result` section at the bottom (lines 55-62) — per RA3, this MUST be REMOVED. The report is now entirely worker-owned; Review Result lives in a sibling `review-result.md` written by control.
- Should add a note/link pointing to `review-result.md` as the sibling artifact.

### templates/task-packet.md:
- Missing `review-result.md` in Forbidden Files list example.
- Missing `Control Review Result Path: runs/<RUN>/review-result.md` declaration.

### templates/audit-task-packet.md:
- Same as task-packet: needs review-result.md in Forbidden and Control Review Result Path.

### registry-and-compaction.md:
- Ownership section may reference "report body excluding Review Result" — update to RA3 file-level split.

### review-checklist.md:
- May reference "report.md Review Result section" for gate conditions — update to review-result.md.

### prompt-assets/reviewer.md:
- §Permissions says "Modify any file: ❌ (review is read-only + writes only its conclusion)" — per RA3, reviewer writes its OWN run's output.md + report.md (not the target's). Update permissions to reflect this.
- Should NOT reference writing to target report — reviewer writes to its own run.

### workflow-steps.md:
- Stage 4 exit gate: "report.md's Review Result section is filled" → "review-result.md exists."
- Stage 5 entry gate: same update.
- Stage 6 Close gate: same update.

### archive-policy.md:
- Closure conditions: "review result exists (写入 report 的 Review Result 段)" → "review-result.md exists."
- Other Review Result references updated.

### glossary.md:
- Add/update terms for review-result.md, file-level ownership.

## Allowed Tools

Read, Write, Edit, Grep, Bash

## Writable Files

- `enloom-skill/references/templates/worker-report.md`
- `enloom-skill/references/templates/task-packet.md`
- `enloom-skill/references/templates/audit-task-packet.md`
- `enloom-skill/references/registry-and-compaction.md`
- `enloom-skill/references/review-checklist.md`
- `enloom-skill/prompt-assets/reviewer.md`
- `enloom-skill/references/workflow-steps.md`
- `enloom-skill/references/archive-policy.md`
- `enloom-skill/references/glossary.md`

## Forbidden Files

- `enloom-skill/references/landing-contract.md` (LOCKED)
- `enloom-skill/references/scheduler-rules.md` (LOCKED)
- `enloom-skill/SKILL.md` (LOCKED)
- `enloom-skill/references/evidence-contract.md` (LOCKED by P1)
- All other files
- All `.enloom/`, `design/`, root docs

## Output Files

- `runs/T-P3-02/output.md` — per-file change summary
- `runs/T-P3-02/report.md` — Evidence Contract four elements

## Acceptance Criteria

1. **worker-report.md**: `## Review Result` section REMOVED. Added a note that Review Result lives in sibling `review-result.md` written by control.

2. **task-packet.md**: Forbidden Files note includes `review-result.md`. Has `Control Review Result Path` declaration example.

3. **audit-task-packet.md**: Same as task-packet.

4. **registry-and-compaction.md**: Ownership references updated to RA3 file-level model (no "report body excluding Review Result").

5. **review-checklist.md**: Gate references updated from "report.md Review Result section" to "review-result.md."

6. **reviewer.md**: Permissions updated — reviewer writes to its OWN run's output.md + report.md, NOT the target's files. Target report and Registry are read-only for reviewer.

7. **workflow-steps.md**: Stage 4 exit / Stage 5 entry / Stage 6 Close gates reference `review-result.md`, not report subsection.

8. **archive-policy.md**: Closure conditions reference `review-result.md`.

9. **glossary.md**: Terms updated for file-level ownership / review-result.md.

## Required Verification

```
- id: V01
  command: rg '## Review Result' enloom-skill/references/templates/worker-report.md
  pass_condition: zero hits (section removed from template)
  fail_signal: any hit
  named_list: review_result_section_residue

- id: V02
  command: rg 'review-result\.md' enloom-skill/references/templates/task-packet.md enloom-skill/references/templates/audit-task-packet.md
  pass_condition: at least 1 hit per file (Forbidden + Control Review Result Path)
  fail_signal: any file with 0 hits
  named_list: packet_review_result_path

- id: V03
  command: rg 'report.*Review Result|Review Result.*section|report.md.*Review Result' enloom-skill/references/review-checklist.md enloom-skill/references/workflow-steps.md enloom-skill/references/archive-policy.md
  pass_condition: zero hits matching old "report Review Result section" pattern
  fail_signal: any hit
  named_list: old_review_result_ref

- id: V04
  command: rg 'review-result\.md' enloom-skill/references/review-checklist.md enloom-skill/references/workflow-steps.md enloom-skill/references/archive-policy.md enloom-skill/references/templates/worker-report.md
  pass_condition: at least 1 hit per file (new artifact referenced)
  fail_signal: any file with 0 hits
  named_list: new_review_result_ref

- id: V05
  command: rg 'exclusion.*Review Result|excluding.*Review Result|body.*excluding' enloom-skill/references/registry-and-compaction.md
  pass_condition: zero hits (old dual-ownership model gone)
  fail_signal: any hit
  named_list: old_dual_ownership
```

Countable outputs:
- Number of consumer files changed (should be exactly 9)
- Number of files with `## Review Result` in worker-report template (should be 0)

## Evidence Required

V01–V05 command outputs.

## Done Signal

Return `done` with paths.
