# Project State

> Target: 3-minute read, <200 lines. Over the threshold → run the [Compaction Protocol](../registry-and-compaction.md §4). The Registry sections (below) are the live truth — preserve them first at compaction; only move an item to archive when it is resolved/closed.

## Goal


## Current Phase


## Accepted Results

> Top-level section (not a Registry section). Accumulates completed-phase conclusions. When this crosses a threshold (e.g. 10 entries), trigger compaction.


## Registry

### Active Tasks

> In-flight tasks, with status.


### Promised Outputs

> Forward-declared but unfulfilled outputs (Promise Registry). Fields:
> ```
> promised_output:
>   declarer:    who promises
>   identifier:  target (product name / path / symbol)
>   consumers:   who depends on it
>   verify_at:   usually the Verify stage
>   status:      promised | fulfilled | broken
> ```


### Pending Dependencies

> Unmet cross-task / cross-phase dependencies. ← control agent scans this on Orient.


### Broken References

> Discovered broken references: source → target, status, note. (Dead links, failed imports, dangling symbol refs, stale TODO pointers.) ← control agent scans this on Orient.


### Known Exceptions

> Intentionally retained exceptions — the whitelist, not counted as defects.


### Accepted With Risk

> Accepted items that carry risk and need re-checking. ← control agent scans this on Orient.


### Rejected Reports

> Index of rejected reports — failure signals, prevent retrying the same path. ← control agent scans this on Orient.


## Archived Phases

> Index of compacted phases. One line each: "Phase X done on Y, conclusion Z, see archive/."


## Human Decisions Needed


## Next Review Point
