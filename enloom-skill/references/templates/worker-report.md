# Worker Report: TASK_ID

> The report shape aligns with the [Evidence Contract](../evidence-contract.md) four elements. Missing any element blocks `PASS`.

## Result

done | blocked | failed

## Files Changed


## Checks Run

> Evidence Contract element 1 — which verifications were executed, named. Aligns with the packet's Required Verification.


## Evidence

> Evidence Contract element 2 — the proof for each check: command output / file path / citation. Not "trust me." A bare PASS with empty evidence auto-downgrades to FAIL/needs-rework.


## Not Checked

> Evidence Contract element 3 — which verifications should have run but did not. Declared blind spots, explicitly, not hidden.


## Known Blind Spots

> Evidence Contract element 4 — for each Not Checked item: why it was not checked, and how large the risk is. Three structural blind spots should be reflected here when applicable (see [evidence-contract.md §The Honest Blind Spots](../evidence-contract.md)):
> 1. **cross-worker file isolation** — enforced by packet field discipline (Writable / Forbidden), not by process boundary; even with independent sub-agents, a worker touching a forbidden file is caught by later audit, not blocked at runtime.
> 2. **cross-role verification** — verdict / review may share model or session; independent reasoning-chain verification is not guaranteed even when worker and reviewer are separate sub-agents.
> 3. **virtual parallelism** — declared `strategy: parallel` is protocol form only; the control agent spawns tasks sequentially within one session, so no runtime concurrency occurs.
>
> Not every report needs all three — list the ones that actually apply to this task's risk surface.


## Risks


## Registry Updates

> Broken references / accepted-with-risk / rejected / promised outputs discovered. Lands in the matching [Registry](../registry-and-compaction.md §1) section.


## State Update


## Next


## Review Result

> Verdict (PASS / ISSUES / FAIL) + review conclusion (accepted | accepted-with-risk | needs-rework | rejected). See [review-checklist.md](../review-checklist.md).

Verdict:
Conclusion:
Reviewer notes:
