# Task Packet: T-P3-01

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

Implement C07/RA3 (file-level artifact ownership split), C08 (runtime capability 4-dimension record), and C09 (deterministic role-to-asset route) in three owner files: landing-contract.md, scheduler-rules.md, and SKILL.md.

## Anti Goal

- Do NOT touch templates, prompt-assets, or other reference files — those are T-P3-02 consumers.
- Do NOT change Evidence Contract semantics (P1) or lifecycle/dispatch structure (P2).
- Do NOT change description/trigger wording.
- Do NOT do broad naming cleanup (P5).

## Inputs

1. Canonical rules in `runs/T-P0-02/output.md`:
   - C07 (lines 111-122): Durable Review/Audit Ownership
   - C08 (lines 124-135): Runtime Capability vs. Actual Execution
   - C09 (lines 137-148): Deterministic Role-to-Asset Route
   - RA3 (lines 417-437): C07 file-level artifact split — THE KEY AMENDMENT
   - RA3 ownership table (lines 421-429): 7-row file-level ownership with review-result.md as separate artifact
   - Runtime capability matrix (lines 296-302): 4 dimensions
   - Hard/soft runtime policy (lines 473-480): independent_subagent hard / others soft
   - C08/C12 amendment (line 466): hard/soft unknown policy
   - C09 amendment (line 467): host-native evidence required, ROLE_ROUTE_EVIDENCE_GAP if unavailable

2. Current content of the 3 owner files (read them).

## Existing State

### landing-contract.md (post-P2):
- Already has RA2 V0→V3 states and C03/C06 from P2.
- MISSING: C07/RA3 file-level artifact ownership. The RA2 states reference "writes Review Result" but don't define the file-level split (report.md = worker, review-result.md = control).
- The §5 Sub-agent requirement section exists but doesn't have the artifact ownership table.
- Gate table Stage 4 exit gate says "report.md's Review Result section is filled" — per RA3 this should be "review-result.md exists."

### scheduler-rules.md (78 lines):
- §并行调度的真实时序 (lines 73-77): Has the virtual parallelism blind spot — good. But C08 needs the 4-dimension runtime capability matrix and hard/soft unknown policy. Currently it just says "sequential spawn" without separating capability from actual execution.
- MISSING: C08 Runtime Capability and Actual Dispatch Record section with 4 dimensions.

### SKILL.md (126 lines):
- MISSING: C09 Role-to-Prompt-Asset Route section. The 5 roles (researcher/coder/reviewer/integrator/tester) need a deterministic loading table.
- References section lists prompt-assets but doesn't route roles to them.

## Allowed Tools

Read, Write, Edit, Grep, Bash

## Writable Files

- `enloom-skill/references/landing-contract.md`
- `enloom-skill/references/scheduler-rules.md`
- `enloom-skill/SKILL.md`

## Forbidden Files

- ALL templates, prompt-assets, and other references under `enloom-skill/`
- ALL files under `.enloom/`, `design/`
- Root docs
- `~/.agents/skills/enloom/`

## Output Files

- `runs/T-P3-01/output.md` — per-file change summary + full rewritten content
- `runs/T-P3-01/report.md` — Evidence Contract four elements

## Acceptance Criteria

### landing-contract.md (C07/RA3):

1. **New §Artifact Ownership section** (or equivalent): The RA3 7-row file-level ownership table:
   - Task/review/audit packet → `runs/<RUN>/task.md` → control → writer count 1
   - Execution output/evidence → `runs/<TASK>/output.md`, `raw-notes.md`(opt), `report.md` → assigned worker → 1
   - Review proposal/evidence → reviewer run `output.md`, `raw-notes.md`(opt), `report.md` → reviewer worker → 1
   - **Review Result → `runs/<RUN>/review-result.md` → control → 1** (THIS IS THE KEY RA3 CHANGE)
   - Audit output/evidence → audit run `output.md`, `raw-notes.md`(opt), `report.md` → audit worker → 1
   - Registry/integration truth → `project_state.md`, Registry, `decisions.md`, `task_board.md` → control → 1
   - Archive/fold → archive entries, namespace moves → control → 1

2. **Canonical run join**: `task.md + output.md + report.md + review-result.md`; `raw-notes.md` optional. Stage 3 exit requires output/report. Stage 4 entry requires four-field report. Stage 4 exit requires target + all verify-worker `review-result.md`. Stage 5/Close gates inspect `review-result.md`, never a report subsection.

3. **Packet requirements**: Every packet MUST list `report.md` in worker Writable Files and `review-result.md` in Forbidden Files; MUST declare `Control Review Result Path: runs/<RUN>/review-result.md`.

4. **Gate table update**: Stage 4 exit gate changes from "report.md Review Result section filled" to "review-result.md exists." Stage 5 entry and Close gate similarly reference review-result.md.

### scheduler-rules.md (C08):

5. **New §Runtime Capability and Actual Dispatch Record section**: The 4-dimension matrix:
   - Independent sub-agent availability: `yes|no|unknown` — `yes` mandatory for full Enloom; `no/unknown` hard halt before any `.enloom` write (C12 preflight, landing in P5)
   - Concurrent dispatch capability: `yes|no|unknown` — optional, soft
   - Actual concurrency: `serial|concurrent|mixed|unknown` — observed truth, never inferred
   - Model/session diversity: `same|different|mixed|unknown` — optional evidence strength

6. **Hard/soft unknown policy**: `independent_subagent=no|unknown` is the sole hard halt. The other three unknowns are soft records that MUST NOT block or be inferred. After hard preflight=`yes`, control copies evidence into every phase plan/task packet; every dispatch gate validates the frozen `yes`.

7. **Relationship to existing virtual parallelism section**: The existing blind spot section stays but is updated to reference the 4-dimension matrix instead of just saying "sequential spawn."

### SKILL.md (C09):

8. **New §Role-to-Prompt-Asset Route section** (or subsection under existing structure): The 5-role canonical table:
   - `researcher` → `prompt-assets/researcher.md` (load + incorporate with packet boundary)
   - `coder` → `prompt-assets/coder.md` (load + incorporate)
   - `reviewer` → `prompt-assets/reviewer.md` (load + incorporate)
   - `integrator` → `packet-only` (no asset, explicitly recorded)
   - `tester` → `packet-only` (no asset, explicitly recorded)

9. **Pre-dispatch check**: make-prompt MUST resolve packet Role through this table before dispatch. A mapped asset MUST be read and incorporated; packet-only MUST be recorded explicitly. Prompt assets remain source assets, NOT copied into each project.

## Required Verification

```
- id: V01
  command: rg 'review-result\.md' enloom-skill/references/landing-contract.md
  pass_condition: at least 3 hits (RA3 file-level split artifact referenced in ownership table + gate table + packet requirements)
  fail_signal: < 3 hits
  named_list: ra3_artifact

- id: V02
  command: rg 'writer count.*1|Writer count.*1|writer.*=.*1' enloom-skill/references/landing-contract.md
  pass_condition: at least 5 hits (7-row table, most rows show writer count 1)
  fail_signal: < 5 hits
  named_list: ra3_writer_counts

- id: V03
  command: rg 'independent.sub.agent|concurrent.dispatch|actual.concurrency|model.session.diversity' enloom-skill/references/scheduler-rules.md
  pass_condition: all 4 C08 dimensions present
  fail_signal: any missing
  named_list: c08_dimensions

- id: V04
  command: rg 'hard.halt|soft|hard.*unknown|sole hard' enloom-skill/references/scheduler-rules.md
  pass_condition: hard/soft policy stated (at least 2 hits)
  fail_signal: < 2 hits
  named_list: c08_hard_soft

- id: V05
  command: rg 'researcher.*researcher\.md|coder.*coder\.md|reviewer.*reviewer\.md|integrator.*packet-only|tester.*packet-only' enloom-skill/SKILL.md
  pass_condition: all 5 C09 role routes present
  fail_signal: any missing
  named_list: c09_routes

- id: V06
  command: rg 'Control Review Result Path' enloom-skill/references/landing-contract.md
  pass_condition: at least 1 hit (packet requirement stated)
  fail_signal: 0 hits
  named_list: ra3_packet_req
```

Countable outputs:
- RA3 ownership table rows (should be exactly 7)
- C08 dimensions (should be exactly 4)
- C09 role routes (should be exactly 5)

## Evidence Required

V01–V06 command outputs + full file texts.

## Done Signal

Return `done` with paths.
