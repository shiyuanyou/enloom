# Task Packet: TASK_ID

Task Packet Version: 0.2
Mode: emergent | recorded | audited
Role: researcher | coder | reviewer | integrator | tester

> **Mode-differentiated field requirements (v0.5).** Not every field is mandatory for every mode — constraint density should match task complexity. Pick the row for this packet's mode and fill accordingly. The `make-prompt` self-check (workflow-steps Stage 3) enforces the **required** cells; optional cells may be left blank without blocking dispatch.
>
> | Field | `emergent` | `recorded` | `audited` |
> |-------|-----------|-----------|-----------|
> | Goal / Anti-Goal / Inputs / Output / Done Signal | required | required | required |
> | Writable Files | required (may be brief) | required (complete) | required (complete + how-checked) |
> | Forbidden Files | optional | required | required (explicitly enumerate serial-integration) |
> | Acceptance Criteria | required (may be brief) | required | required |
> | Review Budget | optional | required | required |
> | Required Verification | optional | optional | **required** (with check_item list) |
> | Countable outputs (Claim Consistency) | optional | optional | **required** |
>
> **Self-check rule**: an `audited` packet missing Required Verification or Countable outputs fails `make-prompt` and cannot dispatch (Stage 3 gate). An `emergent` packet with Forbidden blank is still legal.

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
>
> **Countable outputs (v0.5 · Claim Consistency, 5th Evidence dimension)**: list any countable quantity this task's report will assert — entry counts, pass rates, file counts, coverage numbers. The Verify stage independently recounts these against the actual output (`grep -c` / `awk` / `git diff --stat`); a mismatch > 0 → ISSUES. **Mandatory in `audited` mode; optional in `recorded`/`emergent`.** See [evidence-contract.md §The Fifth Dimension](../evidence-contract.md).

Countable outputs:


## Evidence Required


## Review Budget


## Pending / Promise Registry Updates


## Human Decision Gate


## Done Signal

Return `done`, `blocked`, or `failed` with a short reason and paths to produced outputs.
