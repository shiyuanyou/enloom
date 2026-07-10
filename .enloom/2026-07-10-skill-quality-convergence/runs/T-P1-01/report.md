# T-P1-01 — report.md

Task: Rewrite `enloom-skill/references/evidence-contract.md` to implement C01 (total evidence decision function), C02 (four-field gap taxonomy with disjoint semantics), RA1 (ordered verdict/conclusion table + packet/report/control schema), and RA1.2 (status tuple totality).

Writable file touched: `enloom-skill/references/evidence-contract.md` (only). No other file was modified.

## Checks Run

| Check | Command | Outcome |
|---|---|---|
| V01 legacy-formula residue | `rg 'if and only if\|当且仅当\|Typical review conclusion\|mapping is a default' enloom-skill/references/evidence-contract.md` | pass (zero hits, exit 1) |
| V02 RA1 schema terms present | `rg -c 'required_check_spec\|required_check_status\|issue_status\|STATUS_INVALID\|repair_class' …` | pass (22 ≥ 5) |
| V03 C02 blocks_check_ids introduced | `rg 'blocks_check_ids' …` | pass (5 hits ≥ 1) |
| V04 RA1.2 valid tuples present | `rg -c 'run \| pass \| present\|run \| fail \| present\|not-run \| not-run \| none' …` | pass (9 ≥ 3) |
| V05 new section exists | `rg -c 'Verdict Decision Function' …` | pass (5 ≥ 1) |
| V06 file size band | `wc -l …` | pass (183 lines, within ~180–250) |
| AR counterexample count | `rg -c 'AR-0[1-8]' …` | pass (exactly 8) |
| STATUS_INVALID tuple-table rows | `rg '\| \`STATUS_INVALID\` \|' … \| wc -l` | pass (exactly 9) |

All 6 required verifications (V01–V06) pass; all 4 countable outputs match their expected values.

## Evidence

Raw command output, copied from the verification run:

```
=== V01 ===                                  # rg legacy residue
exit: 1                                      # zero hits — PASS

=== V02 ===                                  # rg -c RA1 schema terms
22                                           # ≥ 5 — PASS

=== V03 ===                                  # rg blocks_check_ids
4. **Known Blind Spots** — … `blocks_check_ids` field …
A structural limitation may *explain* an omission … (via `blocks_check_ids`) …
| report `Known Blind Spots` row | … `blocks_check_ids=[]\|[IDs]` … |
| AR-02 … blind spot `blocks_check_ids=[R2]` … |
| AR-03 … blind spot `blocks_check_ids=[]` …
… Known Blind Spots 下(`blocks_check_ids=[]` …) …
exit: 0                                      # ≥ 1 hit — PASS

=== V04 ===                                  # rg -c RA1.2 valid tuples
9                                            # ≥ 3 — PASS

=== V05 ===                                  # rg -c new section
5                                            # ≥ 1 — PASS

=== V06 ===                                  # wc -l
183 enloom-skill/references/evidence-contract.md   # ~180–250 band — PASS
```

Countable outputs:
- RA1 schema terms introduced: 5 (`required_check_spec`, `required_check_status`, `issue_status`, `STATUS_INVALID`, `repair_class`).
- RA1.2 valid tuples: exactly 3 (`run | pass | present`, `run | fail | present`, `not-run | not-run | none`).
- AR counterexamples: exactly 8 (AR-01 … AR-08).
- STATUS_INVALID tuple-table rows: exactly 9 (3 valid + 9 invalid = 12 exhaustive rows).

Additional structural evidence (acceptance criteria trace):

- **AC1 — §Verdict Decision Function** exists and contains: the 4-row packet/report/control schema table (required_check_spec / required_check_status / Known Blind Spots row / issue_status); RA1.2 status tuple totality (3 valid + 9 invalid in a 12-row exhaustive table); the 4-row ordered verdict table (first-match); the mandatory conclusion mapping (PASS→accepted / ISSUES→accepted-with-risk / FAIL→rejected-if-terminal else needs-rework); the AR-01…AR-08 counterexample table.
- **AC2 — §The Four Elements revised per C02**: Checks Run maps executed IDs to outcome; Evidence maps executed IDs to proof; Not Checked = ONLY packet-declared unrun required-check IDs (or explicit None), blocks PASS; Known Blind Spots = structural limitations with `blocks_check_ids` (empty coexists with PASS, non-empty projects to Not Checked). Both disjointness prohibitions stated explicitly.
- **AC3 — §The Hard Constraint replaced**: old "PASS iff …" formula removed; section now points to §Verdict Decision Function as the complete and only formula.
- **AC4 — §Verdict vs Review Conclusion**: "mapping is a default" replaced with "mapping is mandatory"; conclusion determined by the RA1 mapping.
- **AC5 — Deleted/absent**: V01 confirms zero occurrences of `if and only if`, `当且仅当`, `Typical review conclusion`, `mapping is a default`.
- **AC6 — Preserved unchanged**: §The Fifth Dimension, §How the Contract Attaches to Work, §脚本执行已知坑, §The Honest Blind Spots (three items), §See Also all preserved. (Two minor alignment edits noted below.)

## Not Checked

`None`. Every verification defined in the task packet (V01–V06) was executed and passed. All four countable outputs were checked against their exact expected values.

## Known Blind Spots

`blocks_check_ids=[]` — no required check is blocked. Two items are worth flagging as low-risk judgment calls that do not affect the verdict:

1. **Two minor alignment edits to "preserved" sections.** Per the packet, §Three-State Verdict and §The Honest Blind Spots were in the "keep" set, and §How the Contract Attaches to Work was "keep, minor update." To keep the new SSOT internally consistent and avoid contradicting the new C01/C02 rules:
   - §Three-State Verdict: the `FAIL` row gained `/ STATUS_INVALID` and the closing sentence now points to §Verdict Decision Function (no semantic change to the three states).
   - §The Honest Blind Spots: the one-line framing now states the three blind spots are listed under Known Blind Spots with `blocks_check_ids=[]` (their original home in the prose said Not Checked, which would directly contradict the new C02 disjoint semantics). The three blind-spot item bodies are byte-for-byte unchanged.
   - §How the Contract Attaches to Work: the Verify-stage bullet changed "applies the hard constraint" → "applies the Verdict Decision Function" so the cross-reference stays live.
   These are consistency repairs required by C01/C02, not content changes; a reviewer who wants the "preserved" sections byte-frozen should flag this. The alternative (leaving the old Not Checked framing in §The Honest Blind Spots) would reintroduce the exact C02 defect the task is closing.

2. **RA3 file-level split not reflected here.** RA3 (T-P0-02) moves Review Result out of `report.md` into a sibling `review-result.md`. This file's §How the Contract Attaches to Work and §See Also still describe the worker report as a single artifact; that ownership split is a P3 landing (C07/RA3), out of scope for this P1 task. The §Verdict Decision Function itself is ownership-agnostic and will compose cleanly with RA3 when it lands.
