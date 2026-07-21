# Phase Plan: P1

## Phase Goal

独立审查 P1/P3 的最小文案和放置位置，确认不会重复现有 Evidence Contract、packet ownership 或 mode-differentiated density；通过后实施并 dogfood。

## Anti Goal

- 不重构 lifecycle、五铁律、Evidence Contract 四要素或 prompt-assets 路由。
- 不修改 Clear-Mind sibling source、archive 或 dev-wiki。
- 不把 self-attestation 表述为运行时隔离，不把 P1 强加给 emergent/recon。

## Constraints

- 当前 source `enloom-skill/` 是 SSOT；installed copy 必须在最终保持一致。
- P1 只能增加 source locator 的最低协议，不能复制原文或制造 citation theater。
- 先 review worker 产物，再触碰 shared skill source。
- Compatibility preflight: **yes** — 独立 sub-agent 可调度；`list_agents` 仅显示 control，运行时还有可用 agent slot。并发与独立模型均不作保证。

## Strategy

serial

## Ownership Table

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| `runs/T001-PATCH-AUDIT/output.md`, `report.md` | parallel-write zone | T001 researcher | Execute |
| `project_state.md`, `decisions.md`, `task_board.md`, `review-result.md`, `enloom-skill/**` | serial-integration zone | control agent | Verify / Integrate |
| audit report, `.clear-mind/**`, dev-wiki concepts, archive | read-only zone | no one | All |

## Reference Tolerance Decision Table

| Reference type in this phase | Tolerates dangling? | Handling | Forces serial? |
|------------------------------|---------------------|----------|----------------|
| Markdown links in skill docs | yes | validate targets after edits | no |
| source/install file parity | no | update source then installed copy before verify | yes |
| task/run artifact paths | no | create before dispatch/review | yes |

**Decision**: serial; no forward declarations.

## Promise Registry Draft

Not needed.

## Tasks

- T001-PATCH-AUDIT: read-only independent audit of P1/P3 placement and wording boundaries; return an Evidence Record plus an exact minimal recommendation.

## Review Plan

Control reads T001 report first, verifies its declared source locators against live files, then writes a separate `review-result.md`. Only an accepted report authorizes the source patch.

## Human Decisions Needed

- recon decision: no — the project and target files are already bounded by Clear-Mind explore and a current source read.

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes
- Parallel ownership is defined if needed: not-needed
- Promise Registry drafted if forward declarations exist: not-needed
- recon considered: yes
- Landing gate confirmed: this phase-plan is written to `tasks/phase-plan-P1.md`: yes
