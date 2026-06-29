# Phase Plan: PHASE_ID

## Phase Goal


## Anti Goal


## Constraints


## Strategy

serial | parallel | hybrid

## Ownership Table

Required when strategy includes parallel writing (law 3 upgraded: No Parallel without Ownership Table). Three-tier model — see [registry-and-compaction.md §2](../registry-and-compaction.md).

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
|  | parallel-write zone |  | Execute |
|  | serial-integration zone | control agent (single-threaded) | Integrate |
|  | read-only zone | no one | All |

Tiers:
- **parallel-write zone** — each worker's exclusive new outputs; sets disjoint.
- **serial-integration zone** — globally unique mutable state (project_state, decisions, registry-bearing files); single-threaded by default.
- **read-only zone** — immutable input.

Selection constraint: serial-integration zone defaults to single-threaded. It may parallelize only if the Plan stage explicitly argues the state is append-only and conflict-free.

## Promise Registry Draft

Fill when any worker will forward-declare an output another references. Skip if no forward declarations. See [registry-and-compaction.md §3](../registry-and-compaction.md).

| declarer | identifier | consumers | verify_at | status |
|----------|-----------|-----------|-----------|--------|
|  |  |  | Verify | promised |

Reference-layer decision: does this task's deliverable reference layer tolerate dangling references? (yes → promise + parallel allowed; no → relevant tasks forced serial)


## Tasks

- T001:

## Review Plan


## Human Decisions Needed


## Gate Check

- Phase goal is clear: yes | no
- Acceptance criteria are clear: yes | no
- Parallel ownership is defined if needed: yes | no | not-needed
- Promise Registry drafted if forward declarations exist: yes | no | not-needed
