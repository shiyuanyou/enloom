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

## Reference Tolerance Decision Table

> Before drafting the Promise Registry, decide whether this phase's deliverable reference layer **tolerates dangling references** — that decision gates whether promise + parallel is even available. Fill the table by analogy to the project's actual reference types. See [registry-and-compaction.md §3](../registry-and-compaction.md).

| Reference type in this project | Tolerates dangling? | Handling | Forces serial? |
|--------------------------------|---------------------|----------|----------------|
| _e.g. Obsidian wikilinks `[[x]]`_ | yes | write ref first, verify at end | no |
| _e.g. markdown links `[x](path)`_ | yes | grep target exists at verify | no |
| _e.g. code `import` / strongly-typed symbol_ | **no** | worker B must finish before A references | **yes** |
| _e.g. file-system path (build expects it)_ | **no** | promise mechanism unusable; serial | **yes** |
| _e.g. JSON schema `$ref`_ | depends | if validator runs at build, no; if runtime-only, yes | depends |
| _(add project-specific rows)_ |  |  |  |

**Decision**: does this phase's deliverable reference layer tolerate dangling references? (yes → promise + parallel allowed; no → relevant tasks forced serial)

## Promise Registry Draft

Fill when any worker will forward-declare an output another references. Skip if no forward declarations. See [registry-and-compaction.md §3](../registry-and-compaction.md).

| declarer | identifier | consumers | verify_at | status |
|----------|-----------|-----------|-----------|--------|
|  |  |  | Verify | promised |


## Tasks

- T001:

## Review Plan


## Human Decisions Needed

- **recon decision**: 该 phase 域是否需要先 recon？规模/结构/边界是否已明？（机制 a — Plan 把决策摆出来，不自动派。信号规则见 [scheduler-rules.md §recon](../scheduler-rules.md)。）
  - [ ] yes — 派 recon task（普通 emergent task，Goal 写明产物=规模素描，喂回 Plan 修正切分）
  - [ ] no — 已有把握，跳过
  - [ ] recommended（若 Plan 触发三信号之一：新 domain / 新文件类型 / 规模边界不明）—— agent 标 salience，人定决策

## Gate Check

- Phase goal is clear: yes | no
- Acceptance criteria are clear: yes | no
- Parallel ownership is defined if needed: yes | no | not-needed
- Promise Registry drafted if forward declarations exist: yes | no | not-needed
- recon considered: yes | no
- **Landing gate confirmed**: this phase-plan is written to `tasks/phase-plan-<phase>.md` (Stage 2 exit gate — see [landing-contract.md](../landing-contract.md) §1): yes | no
