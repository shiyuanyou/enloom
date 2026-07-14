---
playbook_contract: 1
---

# Workspace Playbook

> Project-level cross-skill registry. Detailed truth remains in each row's `state_source`.

> Contract note: field definitions, lifecycle values, and the Archive Index schema
> are owned by Playbook Contract v1. This file is only its compact materialization.

## Source Priority

1. Product SSOT owns product/runtime facts.
2. Each declared `state_source` owns its skill run's detailed state.
3. A handoff artifact owns the relation and closure feedback between runs.
4. This file owns only cross-skill identity, lifecycle summary, and pointers.

If this file conflicts with a source, repair this file.

For a new run, derive its identity, create the local authoritative source, and
write the row in the same user-requested landing change. Do not add a row that
points at a planned source.

## Active Records

| work_id | skill | skill_space | run_dir | lifecycle | stage | summary | state_source | handoff | created_at | updated_at | skill_rev |
|---|---|---|---|---|---|---|---|---|---|---|---|
| v033-rename | enloom | `.enloom` | `.enloom/archive/2026-06-24-v033-rename` | closed | v0.3.3 rename (frozen) | Renamed the product AgentOS/agentos-workflow to Enloom across repo, skill name, and output dir with a global reinstall. | `.enloom/archive/2026-06-24-v033-rename/project_state.md` | — | 2026-06-24 | 2026-06-30 | v0.3.3 |
| enloom-v04 | enloom | `.enloom` | `.enloom/archive/2026-06-30-enloom-v04` | closed | v0.4 全部完成 (Close) | Delivered v0.4 project-level namespace plus landing-timing contract and verified source/installed parity. | `.enloom/archive/2026-06-30-enloom-v04/project_state.md` | — | 2026-06-30 | 2026-06-30 | v0.4 |
| enloom-v05 | enloom | `.enloom` | `.enloom/archive/2026-07-01-enloom-v05` | closed | P1 完成 (Close) | Landed the v0.5 review-ruling seven changes with mandatory compaction gate, three blind-spot items, and two-tier health check. | `.enloom/archive/2026-07-01-enloom-v05/project_state.md` | — | 2026-07-01 | 2026-07-01 | v0.5 |
| enloom-v06 | enloom | `.enloom` | `.enloom/archive/2026-07-06-enloom-v06` | closed | Phase 4 P3 清理 (CLOSED) | Flipped dispatch-default posture, hardened role naming, and promoted recon to a Plan-stage decision gate across v0.6. | `.enloom/archive/2026-07-06-enloom-v06/project_state.md` | — | 2026-07-06 | 2026-07-07 | v0.6 |
| clearmind-align | enloom | `.enloom` | `.enloom/archive/2026-07-06-clearmind-align` | closed | Phase 1 三层轻量对齐 (CLOSED) | Aligned clear-mind skill to enloom v0.6 dispatch-default across narrative, interface, and naming without flipping its runtime default. | `.enloom/archive/2026-07-06-clearmind-align/project_state.md` | — | 2026-07-06 | 2026-07-06 | v0.6 |
| repo-hygiene | enloom | `.enloom` | `.enloom/archive/2026-07-09-repo-hygiene` | closed | Phase 1 元卫生清理 (closed) | Cleaned dev-repo bloat via version-annotation trim, design archive, and PROGRESS compaction using enloom to govern itself. | `.enloom/archive/2026-07-09-repo-hygiene/project_state.md` | — | 2026-07-09 | 2026-07-09 | v0.6 |
| skill-quality-convergence | enloom | `.enloom` | `.enloom/2026-07-10-skill-quality-convergence` | closed | P6 Dogfood/对比/同步/关闭 (accepted) | Converged 2026-07-10 quality-review findings by landing 14 canonical rules and closing 17 findings with source/installed parity. | `.enloom/2026-07-10-skill-quality-convergence/project_state.md` | — | 2026-07-10 | 2026-07-10 | v0.6 |

## Archive Index

| work_id | archived_at | record | summary |
|---|---|---|---|
