# Eval Results — v0.2 Closure Run

Date: 2026-06-17
Path: Manual eval (Path A from eval-guide.md). Environment has no subagent dispatch / no browser, so this follows skill-creator's Claude.ai-style adaptation: self-run each prompt, self-grade against `expectations[]`, no baseline comparison, qualitative only.

Method: for each eval prompt, apply the AgentOS Workflow skill's triage/review decision logic and record whether each `expectation` passes. I am both the skill-author and the grader here — flagging that as a known bias (the skill-creator workflow normally uses independent subagents to avoid it).

## Case 1 — Complex multi-session migration → expect `agentos`

Decision: **agentos**.
- Prompt has: multi-session, researcher+coder+reviewer (3 roles), project state surviving resets, archive per phase, multi-stage. That is ≥5 triggers.
- ✅ triage conclusion is agentos
- ✅ plan only current phase (iron law / Step 2 gate — plan template is single-phase)
- ✅ task packet produced (the packet template enforces goal/anti-goal/inputs/tools/output/acceptance/review-budget)
- ✅ no scheduler/CLI/auto-runtime promise (Non-Goals asserted in every doc)

**Result: PASS (4/4)**

## Case 2 — Typo fix "Recieve"→"Receive" → expect `direct`

Decision: **direct**.
- Single-file, one-line mechanical edit. Zero triggers. Triage decision tree step 1: can it be done directly → yes.
- ✅ triage conclusion is direct
- ✅ no AgentOS files created (First Move rule: direct → finish normally and exit)
- ✅ no packets/review ceremony

**Result: PASS (3/3)**

## Case 3 — One-off rename script (.jpeg→.jpg) → expect `direct`

Decision: **direct**.
- One-off script, no durable state. Near-miss in triage-decision-tree.md covers exactly this ("Write a one-off script to rename these files" → direct).
- ✅ triage conclusion is direct
- ✅ no AgentOS files created
- ✅ treated as one-off, not audited migration (unless user says so)

**Result: PASS (3/3)**

## Case 4 — Three researchers + merge, dependency exists → expect `serial`

Decision: **agentos** entry, **serial** strategy.
- Multi-role (3 researchers + reviewer), review budget, decision record = long-term asset. Triggers met → agentos.
- Strategy: the merge depends on ALL three research outputs → scheduler-rules "禁止并行: 一个任务的输出会改变另一个任务的输入" + "依赖链没定清". Default serial.
- ✅ triage conclusion is agentos
- ✅ strategy serial (integration step serial even if research could parallelize)
- ✅ recognizes dependency: merge waits for all research
- ✅ file ownership table if any parallel declared (research-only could parallelize with ownership table; merge cannot)

**Result: PASS (4/4)**

## Case 5 — Bare-PASS report ("trust me, it works", verification not run) → expect `needs-rework`

Decision: **needs-rework**.
- review-checklist gate: "Required Verification 已跑" — report says `not run` → fails. "Evidence 段提供具体证据" — "trust me" is not evidence → fails.
- Iron law 4: "没有证据的 PASS 一律降级 needs-rework". Explicit.
- ✅ review conclusion is needs-rework
- ✅ reason cites verification not run + insufficient evidence
- ✅ asks for specific evidence / narrowed task, not accepting bare PASS

**Result: PASS (3/3)**

## Case 6 — 900-line raw transcript, one-line report → expect `needs-rework` + demand compression

Decision: **needs-rework**.
- Report failed to compress — violates report-first posture and review budget. "see output.md" is not a report.
- review-checklist: report must carry evidence; raw notes only read on failure/high-risk, not ingested wholesale.
- ✅ review conclusion is needs-rework
- ✅ demands compression rather than reading 900-line raw
- ✅ raw transcript NOT copied into review conclusion / state

**Result: PASS (3/3)**

## Aggregate

| Case | Expected | Got | Result |
|------|----------|-----|--------|
| 1 | agentos | agentos | PASS 4/4 |
| 2 | direct | direct | PASS 3/3 |
| 3 | direct | direct | PASS 3/3 |
| 4 | serial (not parallel-default) | serial | PASS 4/4 |
| 5 | needs-rework | needs-rework | PASS 3/3 |
| 6 | needs-rework + compression | needs-rework | PASS 3/3 |

**Overall: 6/6 cases, 20/20 expectations pass (manual, self-graded).**

## Caveats (honest)

- **Self-graded bias**: I authored the eval prompts, the expected outputs, AND graded them. In a proper skill-creator run, independent subagents execute the prompts blindly and a separate grader subagent scores. The pass rate here is an upper bound, not a validated number. The value is structural: the decision logic maps cleanly onto each case, which is what the eval is really testing.
- **No baseline**: without `without_skill` runs, I cannot show the skill *improves* the decision — only that applying it yields the expected decision.
- **Trigger surface not stress-tested**: these prompts are clear-cut. The real risk (over-triggering on near-misses) needs the 20-query description-optimization eval set, which requires `run_loop.py` + `claude -p`.

## What this run validates

The decision *logic* encoded in the skill (triage triggers, serial-default, evidence gate, report-first) produces the intended verdict on all six designed cases. What remains unvalidated: trigger *accuracy* on ambiguous/near-miss prompts, and whether an independent model applies the skill the same way.
