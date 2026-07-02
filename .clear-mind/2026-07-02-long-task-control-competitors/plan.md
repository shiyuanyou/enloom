# Long Task Control Competitors - Plan

## Core Demand

The real question is not "which skill is similar to Enloom". The deeper question is:

> For long-running AI work, which layer should own control: a lightweight skill protocol, a task/spec SSOT, a memory/context layer, or a durable runtime?

Enloom currently lives in the lightweight control-plane layer. It coordinates agent judgment through files and gates, but deliberately avoids owning scheduler/runtime/model execution.

## First-Principles Frame

Long-task control must solve five separable problems:

1. Decomposition: what work exists, what depends on what, and what can run in parallel.
2. Continuity: what the next session/agent must read to recover true state.
3. Boundary: who may write which files, which decisions are global, and which are local.
4. Verification: what evidence proves a task is done, and what risk remains unclosed.
5. Runtime: who actually schedules, retries, isolates, pauses, resumes, and observes execution.

Most tools solve only one or two of these. Tools fail when they claim to solve all five but only implement prompt discipline.

## Evaluation Criteria

For each competitor, judge by these questions:

- Does it persist state outside chat?
- Does it have a real task graph or only a todo list?
- Does it separate global decisions from local execution?
- Does it enforce file ownership or only recommend it?
- Does it require evidence before PASS?
- Does it handle interruption/resume mechanically?
- Does it provide true runtime isolation through worktrees/sandboxes/processes?
- Does it make context smaller through projection, not bigger through memory dumping?
- Can a human audit what happened after the fact?
- Does it remain useful without binding to one vendor/harness?

## User-Facing Categories

1. Skill/process packs: easiest to adopt, weakest mechanical enforcement.
2. PM/spec systems: strongest task/requirements traceability, weak runtime.
3. Context/memory systems: strongest continuity support, weak task execution.
4. Durable runtimes: strongest recovery/scheduling, highest complexity.
5. Hosted autonomous agents: strongest product experience, weakest local control/customization.

## askBQ Summary

### A. What is the job-to-be-done?

Keep a long AI task recoverable, auditable, and bounded even when context, session, or worker reliability fails.

### B. What must not be lost?

The unclosed risk list, current phase, active tasks, ownership boundaries, evidence, decisions, and next safe action.

### C. What is the primary contradiction?

Users want the reliability of a runtime but the portability and transparency of Markdown files. Heavy runtimes solve enforcement but add adoption cost. Lightweight skills solve adoption but depend on agent discipline.

### D. What false comparison should be avoided?

Do not compare Enloom only to Superpowers or oh-my-opencode. The real alternatives include Task Master/CCPM/Spec Kit on the SSOT side and Smithers/Millrace/Taskplane/Citadel on the runtime side.

### E. What should Enloom likely not become?

It should not become a giant all-in-one harness with models, tmux, LSP, task queues, memory DB, dashboard, and runtime daemon unless that is a deliberate product pivot.

### F. What should Enloom become instead?

It should become the best thin, auditable, harness-neutral control protocol for long tasks, with optional adapters into stronger runtime/PM/memory systems.
