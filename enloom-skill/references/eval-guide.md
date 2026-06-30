# Eval Guide

How to run the Enloom eval suite. The suite lives at [evals/evals.json](../evals/evals.json) and covers nine cases spanning the triage, review, and verification decisions.

## What the evals test

| # | Case | Expected | What it gates |
|---|------|----------|---------------|
| 1 | Complex multi-session migration | `enloom` | Does the skill enter when it should? |
| 2 | Typo fix | `direct` | Does it stay out of trivial tasks? |
| 3 | One-off rename script | `direct` | Does it avoid ceremony for throwaway scripts? |
| 4 | Three researchers + merge | `serial` (not parallel-default) | Does it default to serial when there's a dependency? |
| 5 | Bare-PASS report (no evidence) | `needs-rework` | Does review enforce the evidence gate? |
| 6 | 900-line raw transcript | `needs-rework` + demand compression | Does review enforce report-first + budget? |
| 7 | Audit PASS with empty evidence | downgrade to FAIL / needs-rework | Does the Evidence Contract hard constraint hold? (v0.3) |
| 8 | Unfulfilled promised output | broken ref logged + resolution path | Does the Promise Registry cycle work? (v0.3) |
| 9 | Compaction that dropped risk items | rollback | Does the Compaction anti-error rule hold? (v0.3) |

The most important cases are 2, 3, 6, 7, and 9 — over-triggering, over-reading, evidence-free PASS, and risk-loss on compaction are the failure modes that hurt most.

## Path A — Manual eval (works anywhere)

For each case:

1. In a fresh agent turn, hand the model the `prompt`.
2. Either let the skill's `description` trigger it, or force-load it.
3. Observe the trace: what did triage return? What did review return? Did it create files it shouldn't have? Did it read raw transcripts?
4. Score each `expectations[]` item as pass/fail against what actually happened.
5. Record results (pass/fail per expectation + notes).

This path needs no external tooling. It is the honest default when no headless subagent dispatch is available. **Known bias**: in a single-agent session the same agent that wrote the skill also grades it — this is a self-graded upper bound, not a validated number. Flag it in the results; do not pretend it is independent.

## Path B — Automated eval (needs headless subagent dispatch)

This path removes the Path A self-grading bias by spawning a **fresh-context subagent per query** that has not seen the protocol being tested. It requires one capability:

> The environment can run an agent **non-interactively (headless)**, giving each query a clean context, so the subagent does not inherit the author's knowledge of the expected answer.

Different tools satisfy this differently. **Any one of them works** — the skill does not depend on a specific CLI. Pick the one your environment has:

| Tool | Headless dispatch | Notes |
|------|-------------------|-------|
| **opencode** | `opencode run -p "prompt"` (no TUI); `--agent <name>` to pick a subagent profile; `--model` to pin a model | The author's primary coding agent. Supports configurable agents in `opencode.json`. |
| **pi** | `pi --mode json "prompt"` — single run, stdout JSONL event stream | earendil-works SDK. Good for scripted/CI use; can switch models at runtime. |
| **Claude Code** | `claude -p --stream-json "prompt"` | The original skill-creator target. Equivalent capability, different vendor. |
| **zcode** | (current runtime) interactive session | Use Path A inside it; or shell out to one of the above for Path B. |

What matters is the **capability** (fresh context per query, non-interactive), not the tool name. If your tool can do that, you can run automated eval.

When you have such a tool:

1. Run the eval set headlessly: feed each `prompt` to a fresh subagent, observe triage/review decisions, score `expectations[]`.
2. For description-optimization (tuning the `description` field for trigger accuracy), use a 60/40 train/test split over a ~20-query set — only after the skill body is stable, not before.

The skill-creator distribution ships helper scripts (`run_eval.py`, `run_loop.py`) that do this orchestration **for Claude Code specifically**. They live at `~/.agents/skills/skill-creator/scripts/`. They are *one implementation*, not the requirement — they hard-bind to `claude -p`. In an opencode or pi environment, write the equivalent orchestration for your tool (a shell loop over `opencode run -p`, or a small pi script), or just run cases manually-but-independently by dispatching each to a fresh headless session.

The point of Path B is **independence**: the subagent grading the case has no memory of writing the skill. Achieve that however your environment allows.

## Trigger Eval — tuning the description field

The nine-case suite above (Path A / Path B) tests **decisions**: once the skill is loaded, does triage / review / verification decide correctly? It does **not** test **triggering** — given only the `description` field, does the model decide to invoke or bypass? That is a different question and has its own suite: [evals/trigger-evals.json](../evals/trigger-evals.json) (20 queries, 60/40 train/test split).

Do not conflate the two. The 9-case suite always feeds the full skill as context; the trigger suite deliberately withholds the body to isolate the description's effect. Running the 9-case suite tells you nothing about trigger accuracy, and vice versa.

### Why this matters most

Over-triggering — the skill entering for a typo fix or a one-off script — is the single most damaging failure mode (see the "most important cases" note above). Under-triggering (bypassing when it should enter) is bad but recoverable. So the 20-query set weights **near-miss** heaviest: prompts that use heavy-sounding verbs (`orchestrate`, `architect`, `coordinate`, `deep-dive`) but are actually bypassable. A weak `description` over-triggers on these.

### Composition

| Category | Count | What it tests |
|----------|-------|---------------|
| should-AGENTOS | 7 | Under-triggering — does it enter when it should? |
| should-DIRECT | 6 | Over-triggering — does it stay out of trivial work? |
| near-miss | 7 | Discriminator — heavy verbs but bypassable. The real test of description quality. |

Split: **train 12** (4/4/4) + **test 8** (3/2/3). Both splits cover all three categories.

### The description-only protocol

This isolates the description's effect from everything else, and is reproducible across tools:

1. Spawn a fresh-context headless agent (any Path B tool works).
2. Give it a system prompt containing **only**: `You have a skill named "<name>". Its description is: "<description>". For the following request, decide whether to INVOKE the skill or BYPASS it. Output only INVOKE or BYPASS and one sentence why.` — **not** the skill body.
3. Feed the query `prompt`.
4. Score `expected_invoke`: INVOKE matches `expected_invoke=true`, BYPASS matches `false`.

This is a **unit test for the description**. The alternative — installing the skill and observing its native trigger — is a tool-dependent *integration test*; run it as a supplement, not the primary measure, because its result is entangled with the host's trigger runtime.

### The tuning loop

```
train (12 queries, description-only)
  → record failure modes:
      over-trigger = invoked on a DIRECT / near-miss (false INVOKE)
      under-trigger = bypassed on a should-AGENTOS (false BYPASS)
  → edit description:
      sharpen the "Do NOT use" list, add discriminator words
      but do NOT over-narrow (see below)
  → re-run train until clean
test (8 queries, description-only) — run ONCE
  → PASS = trigger accuracy validated
  → FAIL on test after clean train = description overfit the train set.
      Fix by generalizing (loosening), not tightening.
```

The one-shot test is the whole point of the holdout: it catches descriptions tuned to pass train by memorizing rather than generalizing. A description that passes train but fails test was over-narrowed — fix it by widening the discriminators, not by adding more specific exclusions.

### When to run this

Only **after** the skill body is stable. Editing `SKILL.md` body mid-tuning invalidates the description test (the description must describe the current behavior). The 9-case Path B suite validates the body; the trigger suite validates the entry door. Body first, then door.

### Acceptance

Train 12/12 PASS **and** test 8/8 PASS = description trigger accuracy validated. Anything else = iterate. Record results in `.enloom/<project>/runs/trigger-eval/` (project-local, under that project's directory — see "Recording results" below).

## Before either path: structural check

Both paths assume the skill is well-formed. Run a frontmatter structural check first. The contract is described in [validation.md](validation.md) (language-neutral, with a zero-dependency bash reference implementation). `quick_validate.py` (skill-creator, needs Python + PyYAML) implements the same checks and is fine when available — but it is **one implementation**, not the only one. A pass here means "well-formed," not "works" — it is a baseline gate, not an eval.

## What is NOT an eval

- A frontmatter structural check validates the skill is well-formed, not that it triggers or decides correctly. Always run it as a baseline, but never treat its pass as "the skill works." See [validation.md](validation.md).
- The three manual trials in [examples/manual-trial.md](examples/manual-trial.md) are v0.1 acceptance checks, narrower than this nine-case suite.

## Recording results

Keep eval run results under `.enloom/<project>/runs/<TASK>/` (project-local, inside that project's directory), not inside the skill package. The skill package ships the prompts; the runs are workflow state.
