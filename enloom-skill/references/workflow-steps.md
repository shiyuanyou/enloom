# Enloom Lifecycle

Enloom is a lifecycle-driven control-plane protocol for complex agent work. The work proceeds through six stages; the operations that earlier versions listed as a flat menu (triage / plan / make-prompt / review / archive / health-check) are now sub-actions that belong to specific stages.

```
0. Triage   (entry decision)   → direct / light-plan / enter lifecycle
1. Orient   (restore state)    → read project_state + registry risk sections + latest report
2. Plan     (plan the phase)   → phase goal + ownership table + promise registry draft
3. Execute  (dispatch workers) → make task packet / dispatch / worker plays inside boundary
4. Verify   (accept on evidence)→ review report + audit packet + evidence gate
5. Integrate(compress into state)→ update project_state + registry + compaction check
6. Close    (archive and exit) → archive + closure check + user report
```

## Five Laws

The laws constrain the lifecycle, not individual operations. All five carry into v0.3:

1. **No Enloom without trigger.**
   If the task can be done directly, do it directly. Enter Enloom only when at least two complexity triggers apply.

2. **No Worker without Task Packet.**
   A Worker needs a complete contract: goal, anti-goal, inputs, allowed tools, writable files, forbidden files, output, acceptance criteria, review budget, and done signal.

3. **No Parallel without Ownership Table.**
   Parallel work is allowed for read-only research, isolated outputs, or alternative proposals. Parallel writing requires an explicit file ownership table (three-tier model: parallel-write / serial-integration / read-only). See [registry-and-compaction.md](registry-and-compaction.md).

4. **No PASS without Evidence.**
   A report is not accepted because the Worker says it is done. Acceptance requires the Evidence Contract: checks run, evidence, blind spots declared. Mechanized in [evidence-contract.md](evidence-contract.md).

5. **No Archive without State Update.**
   Archive only after report review, project state update, decision update if needed, registry update (risk sections cleared or carried), raw-material handling, and next-step clarity.

## Stage 0: Triage

Goal: decide whether this request should enter Enloom.

Sub-action: `triage`.

Inputs:
- User request.
- Existing `.enloom/project_state.md`, if already known and cheap to read.

Outputs:
- `direct`: do the work normally.
- `light-plan`: give a short plan, do not create files.
- `enloom`: enter the lifecycle.

Enloom needs at least two of these triggers:
- Expected to exceed three phases.
- Needs two or more Workers or roles.
- Needs cross-session state.
- Needs review, archive, or retrospective discipline.
- Context may grow enough to affect judgment.
- Output becomes a long-term asset.

Gate: single-file edits, clear bug fixes, one-off scripts, and direct Q&A default to `direct`. User explicit request → `enloom`. See [trigger-contract.md](trigger-contract.md).

## Stage 1: Orient

Goal: restore enough state for the control agent to make a good next decision — thin orchestrator, but never blind.

Sub-action: `health-check` (periodic, to detect drift).

Read in this order:
1. `.enloom/project_state.md` — **must scan the Registry risk sections**: Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports. The value of a thin orchestrator is holding the global invariants.
2. Current task in `.enloom/tasks/`.
3. `.enloom/decisions.md`.
4. Latest relevant `.enloom/runs/*/report.md`.

Default not to read:
- raw logs
- raw notes
- full Worker transcripts
- unrelated old tasks

Output: a 5-10 line current state summary.

Gate: if state is missing or contradictory, summarize the gap before planning. If project_state is over the compaction threshold but not compacted, log a health-check finding (drift signal).

## Stage 2: Plan

Goal: define only the next phase of work.

Sub-action: `plan`.

Output: use [templates/phase-plan.md](templates/phase-plan.md).

The plan must include:
- phase goal
- anti-goal
- constraints
- strategy: serial, parallel, or hybrid
- **Ownership Table** (hard prerequisite when strategy includes parallel writing — three-tier model; see [registry-and-compaction.md](registry-and-compaction.md))
- **Promise Registry draft** (when any worker will forward-declare an output that another references — see [registry-and-compaction.md](registry-and-compaction.md))
- tasks
- review plan
- human decisions needed

Gate: unclear phase goals stop worker dispatch. Parallel strategies require the Ownership Table (law 3). If the deliverable's reference layer cannot tolerate dangling references, the relevant tasks are forced serial.

## Stage 3: Execute

Goal: make the work executable and reviewable without expanding the control context.

Sub-actions: `make-prompt` (build task packet) + `dispatch` (run worker).

These were separate steps before (Step 3 Make Packet + Step 4 Dispatch); they are continuous and now merged into one stage. Splitting them was an artificial seam.

Output: use [templates/task-packet.md](templates/task-packet.md) for ordinary work, [templates/audit-task-packet.md](templates/audit-task-packet.md) for verification work.

Mode selection (ordinary packet):
- `emergent`: quick exploration; intermediate material may be discarded.
- `recorded`: important intermediate material should be written down.
- `audited`: verification is required; use for shared files, risky changes, or long-lived outputs.

Default to `recorded` for long-term projects and `audited` for risky shared changes.

Ownership discipline (from the Ownership Table):
- Each packet derives its `Writable Files` and `Forbidden Files` from the table.
- **Forbidden must explicitly enumerate the serial-integration files** (project_state, decisions, registry-bearing files), not just say "don't touch shared files." See [registry-and-compaction.md](registry-and-compaction.md).

Dispatch rules:
- The Worker stays inside the packet boundary.
- The Worker may propose changes to scope, but cannot rewrite the project goal.
- The Worker cannot modify forbidden files.
- If blocked, the Worker returns `blocked` with the missing contract details.

Gate: no task packet, no Worker (law 2). Parallel writing without an Ownership Table is forbidden (law 3). Shared integration, project state updates, decisions, and archive writes are serial by default.

## Stage 4: Verify

Goal: decide whether Worker output can be integrated — on evidence, not on assertion.

Sub-actions: `review` (every worker) + `audit` (periodic, every N workers, or pre-release).

Read in this order:
1. `runs/TASK_ID/report.md` — required.
2. `runs/TASK_ID/output.md` — only if report evidence is insufficient.
3. `runs/TASK_ID/raw-notes.md` — only for failure, high risk, or retrospective work.

The report must satisfy the [Evidence Contract](evidence-contract.md) (four elements). The verdict is three-state:

- `PASS` — all declared checks run, evidence non-empty, blind spots declared, no unexplained high-severity issue.
- `ISSUES` — defects present but workable (medium/low severity, logged in registry); the control agent can proceed with known defects.
- `FAIL` — high severity unresolved / required check not run / evidence missing.

Hard constraint (mechanization of law 4): `verdict = PASS` **if and only if** all declared checks have run and evidence is non-empty. Any declared check marked `NOT RUN` → not PASS. Any high-severity issue unexplained → not PASS. A bare PASS without evidence auto-downgrades to FAIL/needs-rework.

After review, the control agent **must log discovered problems into the matching Registry section** (broken reference / accepted-with-risk / rejected). This is the obligation that makes the registry a live truth rather than a write-only log.

Periodic / pre-release audits use an [audit task packet](templates/audit-task-packet.md) with `audit_mode: batch` (sampled) or `final` (full). The audit returns a verdict + named lists (dead_links / broken_refs / malformed_outputs / ...) for registry intake.

Gate: required verification not run means no `accepted`. High-severity unexplained issue means no `accepted`. PASS without evidence becomes `needs-rework`. See [review-checklist.md](review-checklist.md).

## Stage 5: Integrate

Goal: compress accepted results into durable state instead of carrying process material.

Update:
- `project_state.md`
- `decisions.md`, if a decision affects future work
- `tasks/`, for open and completed task status
- **Registry**: log pending / promised / broken / rejected / accepted-with-risk / known-exception into the correct section

Project state should stay short and current. Use [templates/project-state.md](templates/project-state.md). Registry update is a precondition for archive (law 5 extended).

**Compaction check** (run after every integrate):
- If project_state exceeds ~200 lines, or the `## Accepted Results` section crosses a threshold (e.g. 10 archived results), or a new session's Orient cannot read it in ~3 minutes → run the Compaction Protocol (four steps: scan → migrate → closeout → verify). See [registry-and-compaction.md](registry-and-compaction.md).
- Compaction compresses resolved/closed process detail; it **never** removes unresolved risk. The four risk sections (Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports) must not shrink unless an item is genuinely resolved — if they do, the compaction misdeleted and must roll back.

Gate: do not integrate rejected or unreviewed work as project truth.

## Stage 6: Close

Goal: close the current phase and leave the control window small.

Sub-action: `archive`.

Archive conditions (all must hold — see [archive-policy.md](archive-policy.md)):
- task packet exists
- output and report exist
- review result exists
- state update is merged
- **registry risk sections processed** (law 5 extended): open risks are converted into tasks, risks, or exceptions; broken references resolved or logged
- raw material is stored in `runs/` or `archive/`, not copied into main context

Optional: trigger one compaction before archive so the state is clean on exit.

Output: use [templates/archive-entry.md](templates/archive-entry.md).

Final user summary includes:
- what the phase completed
- review conclusion
- remaining risks
- next step

Gate: no archive without state update (law 5).

## Failure Protocol

Worker blocked:
1. Repair the Task Packet.
2. Avoid reading unrelated raw documents.
3. Dispatch again.

Worker failed once:
- Ask for missing evidence or narrow the task.

Worker failed twice:
- Rewrite goal, anti-goal, inputs, or acceptance criteria.

Same phase failed three times:
- Stop dispatch and create an assumption review before continuing.

## Health Check (periodic)

`health-check` is no longer a top-level operation. It is a periodic sub-action triggered in:
- **Stage 1 Orient** — drift detection (state over threshold but not compacted; packets/reports missing).
- **Stage 4 Verify** — periodic risk-section sanity.

Run read-only checks for:
- active tasks without task packets
- runs without reports
- reports without review results
- project state that records unaccepted results as truth
- stale pending or promised items
- exceeded review budgets
- temporary prompts that should become prompt assets
- registry risk sections that grew without a corresponding resolved/closed marker

Health check reports findings and next actions. It does not auto-fix.
