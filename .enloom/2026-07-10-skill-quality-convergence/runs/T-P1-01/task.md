# Task Packet: T-P1-01

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Rewrite `enloom-skill/references/evidence-contract.md` to implement C01 (total evidence-derived decision function), C02 (four-field gap taxonomy with disjoint semantics), RA1 (ordered verdict/conclusion table + required_check_spec/required_check_status/issue_status schema), and RA1.2 (status tuple totality). Delete the old two-condition "PASS iff" formula and "typical mapping" wording. The result is the single owner SSOT for verdict logic that all consumers will reference.

## Anti Goal

- Do NOT change lifecycle structure (Stage 0/3/4 descriptions) — that is P2.
- Do NOT change the ownership model (report.md / Review Result split) — that is P3.
- Do NOT rename the four invariant field names (Checks Run / Evidence / Not Checked / Known Blind Spots).
- Do NOT touch any file other than `evidence-contract.md`.
- Do NOT change description/trigger wording — that is P5.
- Preserve the existing §The Honest Blind Spots section and §脚本执行已知坑 section — they are orthogonal to this task and remain unchanged.

## Inputs

1. The canonical rule definitions in `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/output.md` — specifically:
   - C01 (lines 33-44): Total Evidence Decision Function rule
   - C02 (lines 46-57): Four-Field Gap Taxonomy rule
   - RA1 (lines 355-398): Packet/report contract schema + ordered verdict/conclusion table + counterexample re-derivation
   - RA1.2 (lines 514-545): Status tuple cross-field totality (3 valid tuples, 9 STATUS_INVALID)
2. The current file content of `enloom-skill/references/evidence-contract.md` (98 lines) — to be rewritten.
3. The E01–E08 Evidence truth table in `runs/T-P0-02/output.md` (lines 252-267) — this must be reproducible from the new Decision Function.

## Existing State

Current `evidence-contract.md` structure (98 lines):
- §The Four Elements (lines 5-14) — has the C02 problem: Not Checked = "declared blind spots", Known Blind Spots = "reasons for Not Checked items"
- §The Fifth Dimension — Claim Consistency (lines 16-24) — keep as-is
- §The Hard Constraint (lines 26-38) — has the old "PASS iff" formula to be replaced
- §Three-State Verdict (lines 40-50) — keep, but remove "typical" language
- §Verdict vs Review Conclusion (lines 52-67) — has "mapping is a default, not a rule" to be replaced with mandatory mapping
- §How the Contract Attaches to Work (lines 69-73) — keep, minor update
- §脚本执行已知坑 (lines 75-82) — keep unchanged
- §The Honest Blind Spots (lines 84-92) — keep unchanged
- §See Also (lines 94-98) — keep

## Allowed Tools

Read, Write, Edit (only on the Writable File), Grep, Bash (for verification commands)

## Writable Files

- `enloom-skill/references/evidence-contract.md`

## Forbidden Files

- ALL other files under `enloom-skill/`
- ALL files under `.enloom/`
- ALL files under `design/`
- ALL root docs (`README.md`, `PROGRESS.md`, `CHANGELOG.md`, `AGENTS.md`)
- ALL files under `~/.agents/skills/enloom/`

## Output Files

- `runs/T-P1-01/output.md` — the final content of the rewritten file (full text), plus a summary of what changed
- `runs/T-P1-01/report.md` — Evidence Contract four elements report

## Acceptance Criteria

1. **New §Verdict Decision Function section** exists and contains:
   - RA1 `required_check_spec` table (packet-side: check_id / on_fail=FAIL|ISSUES / ac_refs / count_claim_refs)
   - RA1 `required_check_status` table (report-side: check_id / run_state=run|not-run / outcome=pass|fail|not-run / evidence_ref=present|none)
   - RA1 `issue_status` table (control-side: ac_violation / safety / usability / direction / repair_class=bounded|terminal|unknown)
   - RA1.2: exactly 3 valid tuples declared (`run|pass|present`, `run|fail|present`, `not-run|not-run|none`); all other combinations = STATUS_INVALID
   - RA1 ordered verdict table (4 rows, first-match): row 1 STATUS_INVALID/not-run/empty-evidence/missing-heading → FAIL; row 2 terminal/AC-violation/on_fail=FAIL → FAIL; row 3 on_fail=ISSUES/claim-mismatch-not-AC → ISSUES; row 4 all-pass → PASS
   - RA1 mandatory conclusion mapping: PASS→accepted / ISSUES→accepted-with-risk / FAIL→rejected(if terminal) or needs-rework(if bounded/unknown)
   - RA1 counterexample table (AR-01 through AR-08) as verification examples
   - RA1.2 exhaustive tuple table (12 rows: 3 valid, 9 invalid)

2. **§The Four Elements revised** per C02:
   - `Checks Run`: maps every executed required-check ID to outcome
   - `Evidence`: maps each executed ID to concrete proof
   - `Not Checked`: contains ONLY packet-declared required-check IDs not executed (or explicit `None`); blocks PASS
   - `Known Blind Spots`: contains structural/runtime/out-of-scope limitations with `blocks_check_ids` field (empty array can coexist with PASS; non-empty must project to Not Checked)
   - Explicit statement: structural limitation MUST NOT be placed in Not Checked; required omission MUST NOT be softened into blind spot

3. **§The Hard Constraint** replaced: old "PASS iff checks ran and evidence non-empty" → reference to the new §Verdict Decision Function as the complete and only formula

4. **§Verdict vs Review Conclusion**: "mapping is a default, not a rule" → "mapping is mandatory" (matching the RA1 conclusion mapping)

5. **Deleted/absent**: `if and only if`, `当且仅当`, `Typical review conclusion`, `mapping is a default` as formula statements (these exact phrases must not appear as the formula definition)

6. **Preserved unchanged**: §The Fifth Dimension (Claim Consistency), §How the Contract Attaches to Work, §脚本执行已知坑, §The Honest Blind Spots, §See Also

## Required Verification

```
- id: V01
  command: rg 'if and only if|当且仅当|Typical review conclusion|mapping is a default' enloom-skill/references/evidence-contract.md
  pass_condition: zero hits (the old formula wording is gone)
  fail_signal: any hit means old formula residue remains
  named_list: legacy_formula_residue

- id: V02
  command: rg -c 'required_check_spec|required_check_status|issue_status|STATUS_INVALID|repair_class' enloom-skill/references/evidence-contract.md
  pass_condition: count >= 5 (all RA1 schema terms present)
  fail_signal: count < 5 means schema not fully introduced
  named_list: ra1_schema_terms

- id: V03
  command: rg 'blocks_check_ids' enloom-skill/references/evidence-contract.md
  pass_condition: at least 1 hit (C02 disjoint semantic field introduced)
  fail_signal: zero hits means blocks_check_ids not introduced
  named_list: c02_field_check

- id: V04
  command: rg -c 'run \| pass \| present|run \| fail \| present|not-run \| not-run \| none' enloom-skill/references/evidence-contract.md
  pass_condition: count >= 3 (all three RA1.2 valid tuples present)
  fail_signal: count < 3 means RA1.2 tuple table incomplete
  named_list: ra12_tuples

- id: V05
  command: rg -c 'Verdict Decision Function' enloom-skill/references/evidence-contract.md
  pass_condition: count >= 1 (new section exists)
  fail_signal: zero means section not created
  named_list: new_section_check

- id: V06
  command: wc -l enloom-skill/references/evidence-contract.md
  pass_condition: line count reasonable (the file will grow from 98 to ~180-250 lines to accommodate the new Decision Function)
  fail_signal: not a hard gate, informational
  named_list: file_size
```

Countable outputs:
- Number of RA1 schema terms introduced (should be >= 5: required_check_spec, required_check_status, issue_status, STATUS_INVALID, repair_class)
- Number of RA1.2 valid tuples (should be exactly 3)
- Number of AR counterexamples (should be exactly 8: AR-01 through AR-08)
- Number of STATUS_INVALID tuple rows in RA1.2 table (should be exactly 9)

## Evidence Required

Command outputs for V01–V06 above, plus the full rewritten file text in output.md.

## Review Budget

report.md + output.md. No raw-notes needed unless verification fails.

## Pending / Promise Registry Updates

None.

## Human Decision Gate

None. Rules frozen by P0.

## Done Signal

Return `done` with paths to output.md and report.md, or `blocked`/`failed` with reason.
