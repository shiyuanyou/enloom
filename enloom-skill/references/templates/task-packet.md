# Task Packet: TASK_ID

Task Packet Version: 0.2
Mode: emergent | recorded | audited
Role: researcher | coder | reviewer | integrator | tester

## Goal


## Anti Goal


## Inputs


## Existing State


## Allowed Tools


## Writable Files

> Exclusive list, precise to the path. Derived from the [Ownership Table](../registry-and-compaction.md §2).


## Forbidden Files

> Do-not-touch list. **Must explicitly enumerate the serial-integration files** (project_state, decisions, registry-bearing files), not just say "don't touch shared files." This is the two-list discipline (registry-and-compaction.md §2).
>
> **Split / migrate / merge batches**: if this task moves units between files, route destinations should be pre-filled by the control agent, not decided here — see [prompt-control.md §1 Route Pre-fill](../prompt-control.md). The worker executes routing, it does not invent it.


## Output Files


## Acceptance Criteria


## Required Verification

> Each item aligns with a `check_item` (id / command / pass_condition / fail_signal / named_list — see [audit-task-packet.md](audit-task-packet.md)). May be inline or a reference to an audit packet. The report must answer each with the [Evidence Contract](../evidence-contract.md) four elements.


## Evidence Required


## Review Budget


## Pending / Promise Registry Updates


## Human Decision Gate


## Done Signal

Return `done`, `blocked`, or `failed` with a short reason and paths to produced outputs.
