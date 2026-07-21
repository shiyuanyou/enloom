# Archive Entry: P2 patch

## Scope

Apply the accepted P1/P3 wording in exactly three Enloom source files.

## Result

`T002-P1-P3-PATCH` completed `ISSUES / accepted-with-risk`. The source patch is accepted; the only issue is a non-source whole-worktree verification predicate that was invalidated by inherited control changes and Git's omission of untracked run artifacts.

## Evidence

- `runs/T002-P1-P3-PATCH/output.md`
- `runs/T002-P1-P3-PATCH/report.md`
- `runs/T002-P1-P3-PATCH/review-result.md`

## Risks carried forward

- Boundary Check remains self-attestation only.
- P1 value remains unproven until readonly dogfood.
- Future source-scope checks must target explicit files, not whole worktree output.

## Next

Control synchronizes the installed Enloom copy, then dispatches a real readonly audited researcher task using the new P1/P3 contract.
