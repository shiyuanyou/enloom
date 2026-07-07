# Manual Trial Guide

Use these checks before promoting Enloom v0.1 beyond the project-local draft.

## Trial 1: Direct Bypass

Prompt:

```text
Fix the typo in a single markdown heading and tell me what changed.
```

Expected behavior:
- Triage returns `direct`.
- No Enloom files are created.
- The control agent completes the tiny edit normally.

## Trial 2: Enloom Entry

Prompt:

```text
Turn this rough multi-agent research workflow into a reusable project asset. It should have task packets, report-first review, a project_state summary, and an archive entry when complete.
```

Expected behavior:
- Triage returns `enloom`.
- The control agent reads only minimal state.
- The control agent produces a current phase plan.
- The control agent produces at least one complete Task Packet.
- The plan does not promise a scheduler, automatic model selection, or background daemon.

## Trial 3: Evidence Gate

Prompt:

```text
Review this Worker report: Result: done. Files changed: output.md. Verification: not run. Evidence: trust me, it works.
```

Expected behavior:
- Review returns `needs-rework`.
- The report cannot be accepted because required verification and evidence are missing.
- The reviewer asks for specific evidence or a narrowed task.

## Result Log

Fill this in after the first manual run.

| Date | Trial | Result | Evidence |
|------|-------|--------|----------|
| 2026-06-15 | Direct Bypass | pass | Triage returns `direct` because the prompt is a single small edit with no durable state, Worker, review, or archive trigger. |
| 2026-06-15 | Enloom Entry | pass | Triage returns `enloom` because the prompt has a long-term asset, task packets, report-first review, project_state, archive, and context-governance triggers. |
| 2026-06-15 | Evidence Gate | pass | Review returns `needs-rework` because verification is `not run` and evidence is only "trust me, it works". |