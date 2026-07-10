# Archive Entry: P1 — Evidence Contract Totality

## Completed

P1 landed C01 (total evidence-derived decision function), C02 (four-field gap taxonomy with disjoint semantics), RA1 (ordered verdict/conclusion table + packet/report/control schema), and RA1.2 (status tuple totality) into the live skill. The Evidence Contract is now a single total function with no competing formulae.

## Outputs

- `enloom-skill/references/evidence-contract.md` — rewritten (98 → 183 lines). New §Verdict Decision Function (required_check_spec / required_check_status / issue_status schema, RA1.2 12-row tuple table, 4-row ordered verdict table, mandatory conclusion mapping, AR-01~AR-08 counterexamples). Revised §The Four Elements (C02 disjoint: Not Checked = required omissions / Known Blind Spots = structural limitations with `blocks_check_ids`). Deleted old "PASS iff" formula and "typical mapping."
- 8 consumer files aligned: `review-checklist.md`, `templates/worker-report.md`, `templates/audit-task-packet.md`, `prompt-assets/reviewer.md`, `prompt-assets/coder.md`, `prompt-assets/researcher.md`, `glossary.md`, `workflow-steps.md`.
- Source/installed parity verified (`diff -qr` exit 0).

## Evidence

- T-P1-01: V01–V06 all pass; 8 AR counterexamples; 9 STATUS_INVALID rows; 3 valid tuples; 22 RA1 schema terms; 0 legacy formula residue.
- T-P1-02: V01–V04 all pass; 0 legacy residue across 8 consumers; 3/3 primary consumers reference §Verdict Decision Function; 0 C02 conflation residue; forbidden file not touched.

## Verification

- `rg 'if and only if|当且仅当|Typical review conclusion|mapping is a default' enloom-skill/` → 0 hits
- E01–E08 truth table manually traced through §Verdict Decision Function — unique verdict/conclusion per fixture
- Four-field semantics disjoint across all consumers

## Decisions

- Two "preserved" sections got minor alignment edits (§Three-State Verdict gained `/ STATUS_INVALID`; §The Honest Blind Spots reframed from Not Checked to Known Blind Spots with `blocks_check_ids=[]`). Both are necessary C01/C02 consistency repairs — leaving them would reintroduce the defects this phase closes.

## State

- P1 accepted; project_state + Registry updated.
- T-P1-01 PASS/accepted; T-P1-02 PASS/accepted.

## Registry

No new broken references, accepted-with-risk, or rejected reports from P1.

## Open Risks

- RA3 file-level split (report.md / review-result.md) not yet reflected — P3 scope.
- Runtime dispatch/move/validator/install/trigger evidence remains deferred to P3–P6.

## Raw Material Handling

- `runs/T-P1-01/` and `runs/T-P1-02/` retained with task.md, output.md, report.md, review-result.md.

## Next Step

P2 — Lifecycle/Dispatch/Fold 去环化 (C03+C04+C06+RA2+RA4/RA4.2+C05 guard).
