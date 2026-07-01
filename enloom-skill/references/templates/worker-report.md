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

> Evidence Contract element 4 — for each Not Checked item: why it was not checked, and how large the risk is. In a single-agent environment, three structural blind spots should be reflected here where relevant (see [evidence-contract.md §The Honest Blind Spots](../evidence-contract.md)):
> 1. **cross-worker real isolation** — no independent runtime to verify the worker did not touch forbidden files.
> 2. **cross-role verification** — verdict / review / audit may come from the same model context; independent reasoning-chain verification is not guaranteed.
> 3. **virtual parallelism** — declared `strategy: parallel` is protocol form only; execution is actually serial in single-agent mode.
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
