# Audit Task Packet: ATASK_ID

Task Packet Version: 0.2
Mode: audited
Role: reviewer (audit worker)
audit_mode: batch | final
audit_scope:

`audit_mode`:
- `batch` — sample a subset of the current phase's products. Used periodically (e.g. every N workers).
- `final` — run against all products. Used before release / phase close.

This is a specialization of [task-packet.md](task-packet.md). An ordinary packet constrains worker **behavior** (what to do); an audit packet constrains worker **verification** (what to check and what counts as pass). They are orthogonal. A worker may receive both (an ordinary packet's `Required Verification` may reference audit `check_item`s), or a pure audit worker may receive only this packet.

> **RA3 file-level ownership (mandatory).** A pure audit packet MUST NOT omit the path declarations below. The audit worker writes its proposal/evidence to its own `output.md` / `report.md`; it MUST NOT write the target's `report.md`, Registry, or `review-result.md` — those are control-owned. See [landing-contract.md §6 Artifact Ownership](../landing-contract.md).

Worker Output Path: runs/<RUN>/output.md
Worker Report Path: runs/<RUN>/report.md
Control Review Result Path: runs/<RUN>/review-result.md

Forbidden (examples):
- `runs/<RUN>/review-result.md` — control-owned verdict + conclusion (RA3)
- `project_state.md`, `decisions.md`, `task_board.md` — serial-integration files
- the target run's `report.md` / `output.md` — read-only for the audit worker

## Goal


## Anti Goal


## Inputs


## Checks

Each `check_item` is a 5-tuple. The `command` is either an executable check command, or `manual: <description>` for a human/manual check. The `named_list` names the list this check produces (e.g. `dead_links`), for Registry intake.

```
- id:
  command:
  pass_condition:
  fail_signal:
  named_list:
```

## Conclusion Rules

Verdict and conclusion logic are defined by the total **Verdict Decision Function** in [evidence-contract.md §Verdict Decision Function](../evidence-contract.md) (ordered verdict table + mandatory conclusion mapping) — that section is the SSOT and is not restated here. In summary: a declared `check_item` not run or missing evidence selects `FAIL`; a high-severity unexplained issue selects `FAIL`; `PASS` requires every required check `run/pass` with evidence and no FAIL/ISSUES predicate above it.

## Severity Levels

- high (blocking) — stops the phase.
- medium (deferrable) — logged in Registry, phase may continue.
- low (just log) — registry entry only.

## Output Lists

Named lists produced by the checks, for Registry intake. Each list's items land in the matching Registry section (Broken References / Accepted With Risk / Rejected Reports):

- dead_links / broken_refs / malformed_outputs / ...

## Not Checked

**Packet-declared required-check IDs not executed** (Evidence Contract element 3 — required omissions only; a non-empty entry blocks `PASS`). Structural limitations go in Known Blind Spots, not here (C02 disjoint semantics):

-


## Return To Caller (trim rule)

The control agent receives only: **verdict + counts per named list**. Detail sinks into the Registry. Do not paste full check output back into the main window.

## Done Signal

Return one verdict:

- `PASS` — all required checks run, evidence complete, blind spots declared, no unexplained high-severity issue.
- `ISSUES` — defects present but workable (medium/low), logged in Registry.
- `FAIL` — high severity unresolved / required check not run / evidence missing.

Plus the named-list counts and any new Registry entries (broken refs, accepted-with-risk items).
