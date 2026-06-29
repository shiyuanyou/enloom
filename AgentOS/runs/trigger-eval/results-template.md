# Trigger Eval — Results

**Eval set**: [`evals/trigger-evals.json`](../../../agentos-workflow-skill/evals/trigger-evals.json) (20 queries, 60/40 train/test)
**Method**: description-only protocol (see [eval-guide.md → Trigger Eval](../../../agentos-workflow-skill/references/eval-guide.md))
**Status**: ⬜ not yet run

> Copy this template per run. Keep runs under `AgentOS/runs/trigger-eval/`, not in the skill package — the skill ships the prompts; the runs are workflow state.

## Run meta

| Field | Value |
|-------|-------|
| Date | |
| Description version | (commit hash of SKILL.md description, or first/last N chars) |
| Tool | (opencode / pi / Claude Code / ...) |
| Model | |
| System prompt | (the description-only wrapper actually used) |

## Train split (12) — run until clean

| id | category | expected_invoke | actual | verdict | failure mode |
|----|----------|-----------------|--------|---------|--------------|
| 1 | should-AGENTOS | true | | | |
| 2 | should-AGENTOS | true | | | |
| 3 | should-AGENTOS | true | | | |
| 4 | should-AGENTOS | true | | | |
| 5 | should-DIRECT | false | | | |
| 6 | should-DIRECT | false | | | |
| 7 | should-DIRECT | false | | | |
| 8 | should-DIRECT | false | | | |
| 9 | near-miss | false | | | |
| 10 | near-miss | false | | | |
| 11 | near-miss | false | | | |
| 12 | near-miss | false | | | |

**Train summary**: __ / 12 PASS

### Iteration log (train)

| Iter | description change | over-trigger (false INVOKE) | under-trigger (false BYPASS) | train pass |
|------|--------------------|-----------------------------|------------------------------|-----------|
| 1 | (baseline) | | | |

## Test split (8) — run ONCE after train clean

| id | category | expected_invoke | actual | verdict | failure mode |
|----|----------|-----------------|--------|---------|--------------|
| 13 | should-AGENTOS | true | | | |
| 14 | should-AGENTOS | true | | | |
| 15 | should-AGENTOS | true | | | |
| 16 | should-DIRECT | false | | | |
| 17 | should-DIRECT | false | | | |
| 18 | near-miss | false | | | |
| 19 | near-miss | false | | | |
| 20 | near-miss | false | | | |

**Test summary**: __ / 8 PASS

## Verdict

- [ ] **PASS** — train 12/12 + test 8/8. Description trigger accuracy validated.
- [ ] **NEEDS-REWORK** — iterate. If test failed after clean train, the description overfit train: fix by *generalizing* (loosening discriminators), not tightening.

## Notes / failure patterns
