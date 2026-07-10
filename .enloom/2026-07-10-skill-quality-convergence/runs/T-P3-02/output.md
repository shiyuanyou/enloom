# T-P3-02 Output — RA3 File-Level Ownership Split Across Consumer Files

Goal: align all 9 consumer files with the RA3 file-level ownership split (`report.md` = worker, `review-result.md` = control), so no consumer file still models Review Result as a section of the worker report.

## Per-File Change Summary

### 1. templates/worker-report.md
- REMOVED the `## Review Result` section (the old Verdict / Conclusion / Reviewer notes block that control was meant to fill).
- Added a bottom note: "Review Result lives in a sibling file. Verdict + review conclusion is written by control to a sibling `review-result.md` (RA3) — not in this file. This report is entirely worker-owned." Links landing-contract.md §6 and review-checklist.md.
- V01 confirms zero `## Review Result` residue.

### 2. templates/task-packet.md
- Forbidden Files note now explicitly requires `runs/<RUN>/review-result.md` (control-owned, RA3) and adds an audited-mode example listing it alongside the serial-integration files.
- Output Files section now declares `Worker Output Path`, `Worker Report Path`, and `Control Review Result Path: runs/<RUN>/review-result.md`.

### 3. templates/audit-task-packet.md
- Added an RA3 file-level ownership block right after the specialization intro: declares `Worker Output Path`, `Worker Report Path`, and `Control Review Result Path: runs/<RUN>/review-result.md`.
- Added Forbidden examples: `review-result.md`, serial-integration files, and the target run's `report.md`/`output.md` (read-only for the audit worker). Notes that pure audit MUST NOT omit these fields.

### 4. registry-and-compaction.md
- Added a `### File-level sole-writer (RA3)` subsection under §2 Ownership Table: every durable artifact has exactly one sole writer; `report.md` is worker-owned, `review-result.md` is control-owned; reviewer/audit workers write proposals into their own run, only control integrates. Cross-references the canonical seven-row table in landing-contract.md §6.
- The file had no pre-existing "report body excluding Review Result" wording, so there was nothing to remove; V05 confirms zero old-dual-ownership residue.

### 5. review-checklist.md
- The report-first reading list now annotates `report.md` as worker-owned (RA3) and added a callout: verdict + conclusion are NOT written in `report.md`; control writes sibling `runs/TASK_ID/review-result.md`. Gate checks target the report's four elements; the result lands as `review-result.md`.
- V03 (old "report Review Result section" pattern) = zero hits; V04 confirms `review-result.md` referenced.

### 6. prompt-assets/reviewer.md (CRITICAL)
- Purpose: rewrote to state the reviewer writes verdict + conclusion as a PROPOSAL into its own run's `output.md`/`report.md`; the target's `review-result.md` is written by CONTROL after integrating the proposal.
- Permissions table fully rewritten: target `report.md`/`output.md`/Registry read-only; reviewer writes ONLY its own run's `output.md`/`report.md`; target `review-result.md` and project_state/Registry are ❌ (control-owned). Added RA3 ownership note above the table.
- Output section: verdict/conclusion are a proposal in the reviewer's own report; Registry entries are proposals, not direct edits.
- How to review: step 5 changed from "log into the Registry" to "write your proposal into your own run's report; do NOT write the target's review-result.md or edit target files — that is control's job."
- Done Signal: notes that control integrates the proposal and writes the target's review-result.md.

### 7. workflow-steps.md
- Stage 4 Exit gate: `runs/<TASK>/review-result.md` exists (verdict + conclusion) — separate control-owned file (RA3), not a section of report.md.
- Stage 5 Entry gate: every task has its `review-result.md` filled (from Stage 4 — RA3 separate file).
- Stage 6 Close Exit gate (Law 5): every task's `review-result.md` exists.

### 8. archive-policy.md
- Closure condition "review result 存在" → "`review-result.md` 存在 (RA3: control 写的独立文件, 不在 report.md 内)".
- "每个 task 的 Review Result 已填" → "每个 task 的 `review-result.md` 已存在" (铁律 5; health-check 硬验).
- Removed the stale "P3 之后将变为独立的 review-result.md" forward-looking language — it is now the present model.

### 9. glossary.md
- Updated **Report** term: entirely worker-owned under RA3; does not contain Review Result.
- Added **Review Result / review-result.md** term: control-owned sole-writer artifact; canonical run join = task.md + output.md + report.md + review-result.md.
- Added **File-level ownership (RA3)** term: every durable artifact has one sole writer; supersedes section-level model.

## Verification Results (V01–V05)

All five pass:
- **V01** `rg '## Review Result' worker-report.md` → exit 1 (zero hits). PASS.
- **V02** `rg 'review-result\.md' task-packet.md audit-task-packet.md` → task-packet.md 3 hits, audit-task-packet.md 3 hits. PASS.
- **V03** `rg 'report.*Review Result|Review Result.*section|report.md.*Review Result' review-checklist.md workflow-steps.md archive-policy.md` → exit 1 (zero hits). PASS.
- **V04** `rg 'review-result\.md' review-checklist.md workflow-steps.md archive-policy.md worker-report.md` → worker-report 1, review-checklist 1, workflow-steps 3, archive-policy 2. PASS.
- **V05** `rg 'exclusion.*Review Result|excluding.*Review Result|body.*excluding' registry-and-compaction.md` → exit 1 (zero hits). PASS.

## Countable Outputs
- Consumer files changed: exactly 9.
- Files with `## Review Result` in worker-report template: 0.
- Forbidden files touched by this task: 0 (SKILL.md / landing-contract.md / scheduler-rules.md / evidence-contract.md all left as-is; their git-modified state predates this task — T-P3-01 froze those owners).

## Out of Scope (preserved)
- Did not touch description/trigger wording.
- Did not change Evidence Contract semantics (P1) or lifecycle/dispatch structure (P2).
- Did not do broad naming cleanup (P5).
- Note: SKILL.md Landing Discipline still says "every report's Review Result is filled" — that file is LOCKED (T-P3-01) and out of writable scope; flagged for a future locked-file amendment, not touched here.
