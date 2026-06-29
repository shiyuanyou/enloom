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

These are the hard constraints from the [Evidence Contract](../evidence-contract.md):

- Any declared `check_item` marked `NOT RUN` that is critical → verdict = FAIL.
- Any high-severity issue left unexplained → verdict = FAIL.
- `verdict = PASS` requires: every declared check run + non-empty evidence + blind spots declared.

## Severity Levels

- high (blocking) — stops the phase.
- medium (deferrable) — logged in Registry, phase may continue.
- low (just log) — registry entry only.

## Output Lists

Named lists produced by the checks, for Registry intake. Each list's items land in the matching Registry section (Broken References / Accepted With Risk / Rejected Reports):

- dead_links / broken_refs / malformed_outputs / ...

## Not Checked

Blind spots — checks that should have run but did not, with why and the risk size (Evidence Contract element 3 + 4):

-


## Return To Caller (trim rule)

The control agent receives only: **verdict + counts per named list**. Detail sinks into the Registry. Do not paste full check output back into the main window.

## Done Signal

Return one verdict:

- `PASS` — all required checks run, evidence complete, blind spots declared, no unexplained high-severity issue.
- `ISSUES` — defects present but workable (medium/low), logged in Registry.
- `FAIL` — high severity unresolved / required check not run / evidence missing.

Plus the named-list counts and any new Registry entries (broken refs, accepted-with-risk items).
