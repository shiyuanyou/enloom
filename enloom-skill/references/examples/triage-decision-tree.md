# Triage Decision Tree

Use triage before Enloom creates files or packets.

## Outputs

- `direct`: do the work normally and exit Enloom.
- `light-plan`: give a short plan, do not create Enloom files.
- `enloom`: enter the full workflow.

## Trigger Rule

Choose `enloom` when at least two triggers apply:

- More than three phases are likely.
- Two or more Workers or roles are useful.
- Cross-session state is needed.
- Review, archive, or retrospective work is required.
- Context may grow enough to hurt judgment.
- The output becomes a long-term asset.

If only one trigger applies, usually choose `light-plan`. If no triggers apply, choose `direct`.

## Decision Tree

1. Can the task be completed directly in the current context?
   - yes: `direct`
   - no: continue

2. Does the user explicitly ask to run Enloom or use task packets?
   - yes: `enloom`, unless the request is obviously harmful or impossible
   - no: continue

3. Count complexity triggers.
   - zero: `direct`
   - one: `light-plan`
   - two or more: `enloom`

4. If entering Enloom, identify the first phase and stop broad planning.

## Examples

### Direct

Prompt: "Fix the typo in README."

Decision: `direct`

Reason: single-file mechanical edit, no worker or state needed.

### Direct

Prompt: "What does this function do?"

Decision: `direct`

Reason: direct Q&A, no durable asset or review workflow.

### Light Plan

Prompt: "Help me refactor this module; I think it may need two or three small commits."

Decision: `light-plan`

Reason: some planning helps, but there is not enough evidence for Worker packets or cross-session state.

### Enloom

Prompt: "Turn this research workflow into a reusable skill, test it on real tasks, and archive the result."

Decision: `enloom`

Reason: long-term asset, review/archive, multi-phase construction, and context governance.

### Enloom

Prompt: "Use separate researchers to compare three architectures, then have a reviewer merge the findings into a decision record."

Decision: `enloom`

Reason: multiple roles, parallel research, review budget, and decision state.

### Enloom

Prompt: "This migration will take several sessions. Keep project state, define packets for each worker, and only accept reports with evidence."

Decision: `enloom`

Reason: explicit Enloom behavior, cross-session state, Worker packets, and evidence gates.

### Near Miss

Prompt: "Write a one-off script to rename these files."

Decision: `direct`

Reason: one-off script. Do not invoke Enloom unless the rename is part of a broader audited migration.

### Near Miss

Prompt: "Make a checklist for tomorrow's work."

Decision: `light-plan`

Reason: planning output is useful, but no Worker boundary, review, archive, or state protocol is needed.
