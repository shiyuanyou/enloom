# Worker Report: TASK_ID

> The report shape aligns with the [Evidence Contract](../evidence-contract.md) four elements. Missing any element blocks `PASS`.

## Result

done | blocked | failed

## Files Changed


## Boundary Check

> Worker self-attestation for reviewer lookup: report actual scope, not proof of runtime isolation, permission enforcement, independent verification, or a stronger `PASS`. This does not change the Evidence Contract fields or control-owned `review-result.md`.

- Actual inputs investigated:
- Packet-boundary deviations and reasons:
- Source / config / state modifications:
- Out-of-scope questions:


## Checks Run

> Evidence Contract element 1 — which verifications were executed, named. Aligns with the packet's Required Verification.


## Evidence

> Evidence Contract element 2 — the proof for each check: command output / file path / citation. Not "trust me." A bare PASS with empty evidence auto-downgrades to FAIL/needs-rework.


## Not Checked

> Evidence Contract element 3 — **packet-declared required-check IDs that were not executed** (or an explicit `None` when every declared check ran). Not a place for structural limitations. A non-empty entry here blocks `PASS`. C02: this field is reserved for required omissions only.


## Known Blind Spots

> Evidence Contract element 4 — **structural / runtime / out-of-scope limitations**, NOT explanations for Not Checked items. Each row carries a `blocks_check_ids` field: empty array `[]` names no blocked check and may coexist with `PASS`; a non-empty array MUST project to matching `not-run` IDs listed in Not Checked. C02 disjoint semantics: a structural limitation may *explain* an omission (via `blocks_check_ids`) but MUST NOT *replace* the omitted check ID in Not Checked.
>
> Three structural limitations belong in this field (never in the required-omission field above), each with `blocks_check_ids=[]` because they block no required check — see [evidence-contract.md §The Honest Blind Spots](../evidence-contract.md):
> 1. **cross-worker file isolation** — `blocks_check_ids=[]`; enforced by packet field discipline (Writable / Forbidden), not by process boundary; a worker touching a forbidden file is caught by later audit, not blocked at runtime.
> 2. **cross-role verification** — `blocks_check_ids=[]`; verdict / review may share model or session; independent reasoning-chain verification is not guaranteed even when worker and reviewer are separate sub-agents.
> 3. **virtual parallelism** — `blocks_check_ids=[]`; declared `strategy: parallel` is protocol form only; the control agent spawns tasks sequentially within one session, so no runtime concurrency occurs.
>
> Not every report needs all three — list the ones that actually apply to this task's risk surface.


## Risks


## Registry Updates

> Broken references / accepted-with-risk / rejected / promised outputs discovered. Lands in the matching [Registry §1](../registry-and-compaction.md) section.


## State Update


## Next


## Return To Caller (trim rule)

The control agent receives only: **Result + Checks Run summary + verdict-level Evidence + named risks**. Do not paste full raw output, full command logs, or worker process narrative back into the main window — detail sinks into `output.md` / `raw-notes.md` on disk, where the control agent reads only on evidence-shortfall or failure. This mirrors [audit-task-packet.md §Return To Caller](audit-task-packet.md).

---

> **Review Result lives in a sibling file.** Verdict (PASS / ISSUES / FAIL) + review conclusion (accepted | accepted-with-risk | needs-rework | rejected) is written by **control** to a sibling `review-result.md` (RA3 file-level ownership) — **not in this file.** This report is entirely worker-owned; see [landing-contract.md §6 Artifact Ownership](../landing-contract.md) and [review-checklist.md](../review-checklist.md).
