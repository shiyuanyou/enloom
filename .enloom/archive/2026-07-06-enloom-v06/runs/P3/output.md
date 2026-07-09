# P3 Output — per-file old→new

Three cleanup edits to `enloom-skill/`, synced to install copy `~/.agents/skills/enloom/`. Zero structural change; pure polish.

## ① `references/templates/archive-entry.md` — Raw Material Handling lock annotation

**old** (lines 34–37):

```
## Raw Material Handling


## Next Step
```

**new** (lock annotation inserted as `>` blockquote, matching phase-plan.md annotation style):

```
## Raw Material Handling

> **What this section records:** HOW raw material was isolated — not the raw material itself. Do **not** paste raw Edit-call history, complete diffs, or sub-agent process into this section (or into the main window). The control agent reads only the worker's `report.md`. Record one or two lines stating where the full change log lives (e.g. `runs/<TASK>/output.md`), that it stayed out of the main window, and that the raw Edit history remained in sub-agent context. For filled examples, see `archive/phase-1-entry.md` · `phase-2-entry.md` · `phase-3-entry.md`. This is the Review Posture discipline in action: report-first, compress accepted conclusions, never paste raw process into long-term state.

## Next Step
```

Rationale: the section was an empty heading with no explanation. A new worker/agent could mistake it for "paste raw material here" and flood the main window with Edit-call history / diffs. The annotation locks in (a) it records isolation method only, (b) raw process stays in sub-agent context, (c) the control agent reads only `report.md`, (d) pointers to the three filled examples. Matches the existing `>` annotation convention used in phase-plan.md (e.g. the Reference Tolerance Decision Table note at line 35).

## ② `references/examples/art-lab-worked-example.md` — "the agent" at :9 (choice (a): keep + annotate)

**old** (line 9):

```
In the original task, a state file recorded completed batches. After a context reset, the agent could not recover: the file said "X done" but did not record the 16+ broken references those batches had left behind. Recovery required re-scanning everything.
```

**new** (line 9 unchanged + new `>` Naming note at line 11):

```
In the original task, a state file recorded completed batches. After a context reset, the agent could not recover: the file said "X done" but did not record the 16+ broken references those batches had left behind. Recovery required re-scanning everything.

> **Naming note:** "the agent" above refers to the **operator of the original art_lab task** (a real external wiki/civilization-map build), not Enloom's control agent or worker. This example is a faithful historical record; the wording is preserved as-is rather than re-mapped onto Enloom role names.
```

See `report.md` for the (a)-vs-(b) choice and reasoning.

## ③ `references/examples/manual-trial.md` — "The agent" → "The control agent" (4 sites)

**old → new:**

| Line | old | new |
|------|-----|-----|
| :16 | `- The agent completes the tiny edit normally.` | `- The control agent completes the tiny edit normally.` |
| :28 | `- The agent reads only minimal state.` | `- The control agent reads only minimal state.` |
| :29 | `- The agent produces a current phase plan.` | `- The control agent produces a current phase plan.` |
| :30 | `- The agent produces at least one complete Task Packet.` | `- The control agent produces at least one complete Task Packet.` |

All four describe Enloom's post-triage behavior (triage, read-minimal-state, phase plan, Task Packet) — these are control-agent responsibilities per the P1 role baseline. No "the agent" remains in this file.

## Sync + diff

All three source files `cp`'d to the matching paths under `~/.agents/skills/enloom/`. `diff -r enloom-skill/ ~/.agents/skills/enloom/` → clean (no differences).
