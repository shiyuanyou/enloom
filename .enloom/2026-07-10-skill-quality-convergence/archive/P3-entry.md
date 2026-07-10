# Archive Entry: P3 — Ownership / Runtime / Role-Asset 冻结

## Completed

P3 froze durable file-level ownership (C07/RA3: report.md = worker, review-result.md = control), runtime capability 4-dimension record (C08), and deterministic role-to-asset routing (C09). The old section-level dual-ownership model (report body + Review Result section) is replaced by two physically separate files with single writers.

## Outputs

- `landing-contract.md` — RA3 7-row file-level artifact ownership table; review-result.md as separate control-owned artifact; gate table Stage 4/5/6 updated; packet requirements (Writable/Forbidden/Control Review Result Path).
- `scheduler-rules.md` — C08 Runtime Capability 4-dimension matrix + hard/soft unknown policy.
- `SKILL.md` — C09 Role-to-Prompt-Asset Route 5-role table.
- 9 consumers: worker-report (removed `## Review Result`), task/audit-packet (review-result.md Forbidden + Control Path), registry-and-compaction, review-checklist, reviewer.md (own-run-only permissions), workflow-steps, archive-policy, glossary.
- Source/installed parity verified.

## Evidence

- T-P3-01: V01–V06 all pass; 7 RA3 rows; 4 C08 dimensions; 5 C09 routes.
- T-P3-02: V01–V05 all pass; 0 Review Result sections in worker-report; review-result.md in all consumers; 0 old dual-ownership.

## State

- P3 accepted; project_state + Registry updated.

## Open Risks

- Host-native prompt evidence for C09 route (ROLE_ROUTE_EVIDENCE_GAP) deferred — P6 dogfood.
- C12 preflight timing (independent sub-agent hard halt) lands in P5.

## Next Step

P4 — Namespace/Validation/机械链接 (C10 + C11 + C13).
