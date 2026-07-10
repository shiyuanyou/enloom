# Archive Entry: P2 — Lifecycle / Dispatch / Fold 去环化

## Completed

P2 eliminated lifecycle/dispatch/fold circular entry points and pre-triage side effects. C03 (Stage 3 entry = phase plan, not task.md), C04 (Triage side-effect-free, fold after enloom decision), C06 (health-check two-axis), RA2 (Verify-worker V0→V3 non-recursive), RA4/RA4.2 (resolver precedence + fold-move-state recovery) all landed in live owners. C05 phrase guard applied to all new/modified lifecycle sentences.

## Outputs

- `landing-contract.md` — Stage 3 entry gate changed to phase plan; make-prompt→task.md→pre-dispatch gate→dispatch order; RA2 V0→V3 four-state machine; C06 two-axis health-check; L4 reference updated to Verdict Decision Function.
- `archive-policy.md` — Fold moved to after enloom decision; control-owned not sub-agent; RA4 7-level resolver precedence; fold-move-state.md snapshot protocol; RA4.2 operation-intent validation; reopen semantics.
- 4 consumers aligned: `workflow-steps.md`, `SKILL.md`, `glossary.md`, `AGENTS.md`.
- Source/installed parity verified.

## Evidence

- T-P2-01: V01–V09 all pass; 4 RA2 states; 6 RA4 error enums; 3 RA4 success enums; 0 circular entry; 0 old fold timing; 0 fold sub-agent dispatch.
- T-P2-02: V01–V06 all pass; 0 old fold-timing residue; 0 circular entry; C05 phrase guard 2/2/2 per file; RA2 referenced in Stage 4.

## Decisions

- "admission" wording used in anti-circular paragraphs to disambiguate from Gate Table "Entry gate" column header — meaning preserved.

## State

- P2 accepted; project_state + Registry updated.

## Registry

No new broken references or accepted-with-risk from P2.

## Open Risks

- RA3 file-level split (report.md/review-result.md) not yet landed — P3 scope.
- C05 broad naming cleanup deferred to P5; P2 applied phrase guard only to new/modified sentences.

## Next Step

P3 — Ownership/Runtime/Role-Asset 冻结 (C07/RA3 + C08 + C09).
