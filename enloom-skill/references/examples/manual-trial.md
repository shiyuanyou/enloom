# Manual Trial Guide

Three checks for validating Enloom behavior — run as a health check or after a skill change.

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
