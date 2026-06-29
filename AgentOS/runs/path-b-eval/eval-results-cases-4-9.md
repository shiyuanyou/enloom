# Path B Eval Results — Cases 4-9

**Date**: 2026-06-25
**Method**: Path B independent blind test via `opencode run --format json` (fresh context per case, non-self-graded). Skill files fed as context (skill not globally installed).
**Evaluator**: pi (zcode) dispatching opencode sub-sessions.

## Results Summary

| Case | Expected | Actual | Verdict |
|------|----------|--------|---------|
| 4 | serial (not parallel-default) | agentos, hybrid with serial merge, Ownership Table | ✅ PASS |
| 5 | needs-rework (evidence gate) | FAIL → needs-rework, cites Evidence Contract | ✅ PASS |
| 6 | needs-rework + demand compression | FAIL → needs-rework, refuses raw transcript | ✅ PASS |
| 7 | FAIL (empty evidence, no Not Checked) | FAIL → needs-rework, cites hard constraint | ✅ PASS |
| 8 | broken ref logged + resolution path | Broken References logged, status=broken, 3 options | ✅ PASS |
| 9 | compaction misdelete → rollback | Identified misdelete, rollback, anti-error rule | ✅ PASS |

**6/6 PASS** — all cases independently verified (non-self-graded).

## Case 4 — Serial Default (Ownership Table)

**Prompt**: Compare three database migration architectures with separate researchers + reviewer merge. Note dependency.

**Expectations**:
1. ✅ triage = agentos
2. ✅ strategy is serial (or hybrid with explicit serial integration), NOT parallel-by-default for merge
3. ✅ the plan recognizes dependency: merge task waits for all research outputs
4. ✅ Ownership Table exists (any parallel step declared)

**Actual output**: triage=agentos, hybrid (parallel research, serial synthesis), Ownership Table created with parallel-write / serial-integration / read-only zones. Merge step explicitly serial after all researchers.

## Case 5 — Bare PASS (Evidence Gate)

**Prompt**: Review worker report: "Result: done. Files changed: output.md. Verification: not run. Evidence: trust me, it works."

**Expectations**:
1. ✅ review = needs-rework
2. ✅ reason cites: verification not run + insufficient evidence
3. ✅ reviewer asks for specific evidence, not accepting bare PASS

**Actual output**: verdict=FAIL, conclusion=needs-rework. Cites Evidence Contract hard constraint: "Any declared check marked NOT RUN → cannot be PASS." Calls "trust me, it works" the textbook example of forbidden evidence. All four elements missing, enumerated.

## Case 6 — 900-line Raw Transcript

**Prompt**: Worker returned output.md at 900 lines raw transcript. report.md is one line: "see output.md".

**Expectations**:
1. ✅ review = needs-rework
2. ✅ reviewer demands report compression, not reading 900-line raw output
3. ✅ raw transcript NOT copied into review conclusion or project state

**Actual output**: verdict=FAIL → needs-rework. Explicitly states: "Report-first review means the control agent does NOT wade through raw transcript to reconstruct what the worker should have written." Demands proper report.md with all four Evidence Contract elements.

## Case 7 — Audit PASS with Empty Evidence

**Prompt**: Audit worker verdict=PASS but Evidence section empty ("checks ran, all fine"), no Not Checked section.

**Expectations**:
1. ✅ verdict ≠ PASS (FAIL or needs-rework)
2. ✅ reason cites Evidence Contract: empty evidence, bare PASS without proof
3. ✅ demands concrete evidence (command output / file paths) + Not Checked
4. ✅ does not accept "trust me, checks ran" as evidence

**Actual output**: verdict=FAIL, needs-rework. Cites: "The Evidence Contract hard constraint is explicitly mechanized: verdict=PASS requires non-empty evidence for every declared check." Identifies two fatal failures: empty Evidence element + missing Not Checked section.

## Case 8 — Broken Promise (Promise Registry)

**Prompt**: Worker A forward-referenced output Worker B promised. B failed, output missing. Verify-stage audit finds dangling reference.

**Expectations**:
1. ✅ broken promise logged into Registry (Broken References)
2. ✅ Promised Outputs entry status updated to 'broken'
3. ✅ chooses resolution path (re-dispatch / reassign / downgrade)
4. ⚠️ marginal — recognizes storage tolerated dangling references implicitly (promise mechanism used, end-verification caught failure), though doesn't use the explicit phrase "storage tolerates dangling references"

**Actual output**: Three Registry sections updated (Promised Outputs → broken, Broken References logged, Rejected Reports indexed). Three resolution options: point-fix, downgrade, retry. Worker B verdict=FAIL/rejected, Worker A verdict=ISSUES/accepted-with-risk.

## Case 9 — Compaction Misdelete (Anti-Error Rule)

**Prompt**: project_state.md 240 lines, compacted. Broken References dropped 4→1 but none resolved.

**Expectations**:
1. ✅ identifies as compaction misdelete
2. ✅ rolls back (restores pre-compaction state)
3. ✅ cites anti-error rule: risk sections must not shrink unless resolved
4. ✅ does NOT accept compacted state as correct

**Actual output**: "Compaction misdeletion." Cites anti-error rule: "Risk section item counts may only drop when items are genuinely resolved — never from compression." Four-step recovery: rollback, log as health-check finding, re-compact correctly, re-verify.

## Known Bias / Limitations

- **Skill context fed explicitly** (not triggered via `description` field): the skill is project-local, not globally installed, so Path B sub-sessions received the full skill text as prompt context. This tests decision correctness given the protocol, not trigger accuracy (that was tested in cases 1-3).
- **Single-turn evaluation**: each case was a single prompt→response, not a multi-turn workflow session. This tests the triage/review decision in isolation, not end-to-end lifecycle behavior.
- **Case 8 expectation 4 marginal**: the subagent handled the Promise Registry cycle correctly but did not explicitly use the "storage tolerates dangling references" terminology from the degradation mechanism section. The core behavior (promise → broken → logged → resolution path) is correct.
