# T-P0-03 — Independent adversarial review

## Independence and Input Gate

- This is a fresh reviewer context. The packet at `runs/T-P0-03/task.md` was read first and is the only task contract; no T-P0-01/T-P0-02 file was edited.
- The prior accepted pair is present exactly once: T-P0-01 `report.md:131-132` and T-P0-02 `report.md:144-145` each contain `Verdict: PASS` and `Conclusion: accepted`.
- `git rev-parse HEAD` returned `318944b1ff715049a71ebcb21f3e16fe21afc07f`, matching T-P0-01/T-P0-02 input evidence. `git diff --name-only -- enloom-skill README.md PROGRESS.md CHANGELOG.md AGENTS.md` was empty before this run.
- `diff -qr enloom-skill /Users/bigo/.agents/skills/enloom` was empty before this run. Source is the live owner; the installed copy was parity-only.
- T-P0-02 matrix is the challenged object, not independent proof. Its 14-rule index is at `output.md:14-29`; the 17-row Finding Coverage is at `output.md:217-235`; its fixtures, lifecycle, ownership, runtime, namespace, validation, and phase claims are at `output.md:250-330`.
- All findings below are independent counterexamples against the matrix. A matrix row that names a future test is an evidence gap until the test can produce one unique outcome.

## Challenge Summary

| Rule | Result | Severity | Counterexample | Independent conclusion |
|---|---|---|---|---|
| C01 | fail | high | CE-01, CE-04, CE-05 | Repairability, usability, high-issue precedence, and claim-mismatch classification are not packet-mechanical; verdict/conclusion remains multi-valued. |
| C02 | issue | high | CE-02 | A structural limitation that prevents a required check can be hidden in `Known Blind Spots`; the matrix does not force the check ID into `Not Checked`. |
| C03 | fail | high | CE-03 | Stage 4 local packet creation is described, but its relationship to the Stage 4 entry/exit gate has no terminating state-machine rule. |
| C04 | issue | high | CE-05 | Fold ordering is improved, but failed/partial moves and the pre-Orient namespace state have no unique recovery/block result. |
| C05 | issue | medium | CE-11 | P5 deferral permits P2 behavior edits to emit the old unqualified “six stages” wording; the dependency graph does not freeze the required phrase early enough. |
| C06 | survives | medium evidence-gap | CE-12 | The matrix separates periodic homes from five transition checks; live runtime execution is still absent, but no internal contradiction was found. |
| C07 | fail | high | CE-04, CE-06 | Reviewer/audit termination and section ownership of one physical `report.md` are not executable with file-level packet permissions. |
| C08 | issue | medium | CE-07 | The four dimensions are named, but only independent-sub-agent `unknown` is a hard pre-write gate; this exception is not expressed as a machine-level write policy. |
| C09 | issue | medium | CE-08 | Packet-only roles are named, but marker verification may inspect a constructed packet rather than the host dispatch prompt; deterministic loading is unproven. |
| C10 | fail | high | CE-09, CE-10 | Six resolver inputs lack named outcomes and precedence when multiple error predicates overlap; move failure can leave an unresolved two-root state. |
| C11 | issue | medium | CE-13 | `UNSUPPORTED`/`INVALID` is specified, but V01 has no named unavailable/rule-gap status and no implementation exists to enforce the vocabulary. |
| C12 | issue | medium | CE-07 | Independent capability timing is clear in prose, but the matrix does not prove every possible `.enloom` writer observes the preflight result before mutation. |
| C13 | issue | medium | CE-14 | `AGENTS.md` governs reference style, not a general Markdown link-target contract; it is a weak/misplaced owner for the two broken template links. |
| C14 | survives | medium evidence-gap | CE-14 | P0 correctly leaves the supported installer command unknown; no command was incorrectly frozen, but the future acceptance test is not runnable yet. |

## Adversarial Challenges

### EVID-1 — C01/C02 total decision function and five boundaries

The matrix says C01 is an ordered function (`output.md:33-44`) and supplies E01–E08 (`output.md:252-267`). Replaying the five required boundary classes exposes two non-unique branches:

| Boundary input | Expected result | Observed matrix ambiguity | Severity |
|---|---|---|---|
| Required-check omission: packet declares `R2`; report has `R1` evidence and `Not Checked: None`; `R2` is absent from Checks Run | `FAIL / needs-rework` because the required check is not run | C01 says required omission fails, but C02 does not state whether a capability-caused omission must be reclassified into `Not Checked` when the worker calls it a structural blind spot. | high |
| Structural limitation blocking a required check: `R2` requires a YAML validator; validator unavailable; report puts only `validator unavailable` in Known Blind Spots | `FAIL / needs-rework` (the required check still did not run) | E03 allows a structural blind spot to coexist with PASS when it does not compromise a required check, but there is no explicit predicate that turns “limitation blocks R2” into a required omission. Two reviewers can choose PASS/FAIL from the same four fields. | high |
| Medium defect: all required checks/evidence/AC pass; one nonblocking medium issue is registered | `ISSUES / accepted-with-risk` | E05 is correct, but “medium defect” has no severity vocabulary or registry-field contract in the packet; a report can call the same defect a blind spot and obtain PASS. | medium |
| High unusable output: all checks run with non-empty evidence, but output is unsafe/wrong-direction and cannot be repaired inside packet | `FAIL / rejected` | C01 introduces `repairable?` in the fixture, but no packet/report field or precedence rule computes repairability. A high issue can be both “bounded correction exists” and “unusable” depending on reviewer judgment. | high |
| Claim mismatch: product checks/AC pass; independently recounted count differs from the report by one; product remains usable | `ISSUES / accepted-with-risk` | E08 calls it low/medium, while the matrix has no threshold or rule that distinguishes a harmless typo from an acceptance failure. C01 can therefore return ISSUES or FAIL. | medium |

Current live anchors show why this is not hypothetical: the live owner still says `PASS iff` checks/evidence (`evidence-contract.md:26-36`), while its mapping is explicitly “a default” (`evidence-contract.md:52-67`), and the checklist repeats both forms (`review-checklist.md:15-21`). T-P0-02's fixtures are a proposal, not an executable decision function.

### LIFE-1 — C03 Stage 3 make-prompt → task gate order

The matrix correctly writes an execution sequence in `output.md:269-279` and C03 in `output.md:59-70`: phase plan → `make-prompt` writes `task.md` → Law 2 check → dispatch. Starting from an empty `runs/<TASK>/` therefore works for an execution worker. The live contract still has the circular old order (`landing-contract.md:35-42`, `workflow-steps.md:119-128`), which is expected to be repaired later.

The unresolved edge is Stage 4. The matrix says a reviewer/audit worker repeats a local handshake inside Verify (`output.md:277`), but Stage 4 entry is already defined as the target report existing (`landing-contract.md:17`, `workflow-steps.md:151-158`). There is no state transition named “enter Verify, create reviewer packet, then dispatch” nor a rule saying the reviewer run is exempt from the outer Stage 3 entry gate. A literal state-machine walker can either dispatch before a packet exists or route back to Plan, reintroducing the cycle. C03 therefore remains high until the local Verify handshake has an explicit non-recursive entry and exit state.

### LIFE-2 — C07 Stage 4 reviewer/audit local handshake

The matrix's claim “no recursive reviewer required for control’s final decision” (`output.md:277`) is a conclusion, not a terminating rule. C07 requires a dedicated reviewer run with its own packet/output/report and says a pure audit is also a complete durable run (`output.md:111-122`). A reviewer run's report has a blank Review Result subsection by the worker contract (`templates/worker-report.md:55-61`), while Stage 4 exit requires that subsection filled (`landing-contract.md:17-18`).

There are only two possible walks for a reviewer run: (a) control fills its Review Result directly, which is a control-as-reviewer exception not stated in C07; or (b) dispatch another reviewer to fill it, which is reviewer-of-review recursion. The matrix does not choose and mechanically encode one. A pure audit has the same gap: its live packet only returns verdict/counts (`templates/audit-task-packet.md:50-75`) and has no output/report paths or Review Result owner. This is a high blocking handshake ambiguity.

### OWNER-1 — physical `report.md` body vs Review Result writer

The ownership matrix counts the following as one writer each (`output.md:281-293`): the worker writes the `report.md` body excluding Review Result, while control writes the Review Result subsection. The packet discipline is file-level (`templates/task-packet.md:36-45` and `scheduler-rules.md:39-43`); it has no section-level permission primitive. A worker with `report.md` in Writable Files can overwrite or truncate the control-owned section; a worker forbidden from the file cannot append its own body. The live reviewer asset is internally contradictory—“Modify any file” is forbidden but it also says to “Log discovered problems into the Registry” (`prompt-assets/reviewer.md:11-20,39-46`).

This is not fixed by counting logical regions. The minimum rework is an artifact split (for example worker-owned `report.md` plus control-owned `review-result.md`, with a canonical join/read rule) or an explicitly control-only report writer. Until that is in the matrix, C07 is FAIL/high and P0 cannot be accepted.

### FOLD-1 — C04/C10 triage → compatibility → fold → Orient

The matrix puts the order at `output.md:269-279`: side-effect-free Triage, C12 preflight, then control-owned C10/fold before Orient. This removes the original pre-triage dispatch in live text (`workflow-steps.md:64-65`). Two counterexamples remain:

1. Three `closed` active directories qualify for fold; the first `mv` succeeds, the second fails after creating an archive candidate, and the third has both active/archive candidates. C10 says both candidates block (`output.md:150-161`), but it does not state whether control stops immediately, rolls back successful moves, or records a row-specific error before Orient. The failed move can leave an active+archive pair that produces a different error on retry.
2. A row is `closed`, active candidate exists, archive candidate exists, and fold threshold is met. C10's “exactly one candidate” rule blocks, while C04's “fold qualifying closed top-level projects” could treat the active directory as the intended source. No precedence says resolver error wins before any move.

The required unique result for move failure is only a residual-risk sentence (`output.md:83,161`), not a named blocking state. C04/C10 need a pre-move snapshot, deterministic error precedence, and a no-Orient-on-partial-move rule.

### RUNTIME-1 — C08/C12 capability, concurrency, execution, diversity

The four dimensions are orthogonal in `output.md:295-302`; C12 makes independent-sub-agent `no|unknown` halt before `.enloom` writes (`output.md:176-187`). This is directionally sound, but the write policy is not explicit enough to replay:

- `independent-sub-agent=unknown` blocks before any `.enloom` mutation.
- `concurrent-dispatch=unknown` does not block; it is an optional capability fact.
- `actual execution=unknown` is allowed when no runtime observation exists.
- `model/session diversity=unknown` is allowed and is not isolation proof.

The matrix never states this as a four-row pre-write policy, so “unknown must block before every `.enloom` write” can be read as all four dimensions. It also does not identify how a control-owned preflight result is propagated to every later writer. Marked medium evidence-gap, not a claim that concurrency occurred. The live scheduler still universalizes sequential spawn (`scheduler-rules.md:73-77`), so P3/P5 must record observed values rather than infer them.

### ASSET-1 — C09 five Role routes

C09 supplies the five-role table (`output.md:137-148`): researcher/coder/reviewer map to assets; integrator/tester are explicit packet-only. This is better than silent discovery, but the acceptance test is not yet sufficient: “generate five packets with unique asset markers” can inspect the packet text generated by control rather than the actual host prompt received by a worker. `SKILL.md` currently exposes only a generic on-demand references list (`SKILL.md:61-76`) and no role route; the three assets identify themselves but do not prove loading.

The minimum evidence must observe the dispatch boundary (host-native prompt or runtime dispatch record), and for packet-only roles must prove an explicit `packet-only` marker survives dispatch. If host inspection is unavailable, the result is `evidence-gap`, not PASS. The matrix acknowledges this at `output.md:146-148` but does not make it an acceptance blocker.

### VALID-1 — C11 V01 full validator vs V02 flat fallback

The matrix distinguishes paths and `UNSUPPORTED`/`INVALID` (`output.md:163-174` and `output.md:314-319`), which survives the main false-equivalence challenge. A near-miss remains: V01 failure is described as “no full verdict; halt or explicitly choose V02,” while V02 has named statuses. There is no named status for “official validator absent/rule gap,” no rule for who selects V02, and no evidence that the reference bash block can emit `UNSUPPORTED` rather than generic non-zero. The live reference still claims bash/awk can do every YAML check (`validation.md:25-39`) and calls `quick_validate.py` the same checks (`validation.md:84-87`). P4 must make the fallback/error vocabulary executable; until then this is medium evidence-gap, not a full-path PASS.

### NS-1 — C10 active/folded/reopen/both-root/neither-root/orphan

The matrix gives three positive examples N01–N03 and bundles four negative signals (`output.md:304-312`). Replaying the six required inputs yields:

| Input | Expected unique result | Matrix result |
|---|---|---|
| active: one row, active candidate only | resolve active | explicit N01 |
| folded: one row, archive candidate only | resolve archive read-only | explicit N02 |
| reopen: one row, archive only + reopen request | move exact archive → active, update same row | explicit N03 |
| both-root: one row, both candidates | one named blocking namespace error | “both … blocking” but no error ID/message |
| neither-root: one row, no candidates | one named blocking namespace error | “neither … blocking,” but no precedence/recovery |
| orphan: no row, one candidate | block creation and identify orphan | stated only in combined negative sentence |

Overlapping input (`duplicate rows + both roots`) has at least two predicates and no precedence. “One named blocking error” is asserted, not defined. This is a high deterministic-resolver gap even though the three positive examples are internally consistent.

### TEXT-1 — C05/C13/C14 and deferred findings

- C05 is assigned to P5 (`output.md:85-96`), but P2 is allowed to edit workflow/SKILL landing behavior before the P5 vocabulary owner is changed. The live owner still says “six stages” and enumerates 0–6 (`workflow-steps.md:1-15`, `SKILL.md:21-33`). P2 needs a frozen phrase guard or it can add new contradictory prose while C05 is “deferred.”
- C13 names `AGENTS.md` as owner (`output.md:189-200`), but the current line only says references use human-readable `§Section Title` and no `.md#slug` anchors (`AGENTS.md:31-36`); it does not define Markdown target syntax. The two broken targets are in live templates (`templates/task-packet.md:38`, `templates/worker-report.md:42`). A dedicated link-integrity owner or a narrower template rule is more truthful.
- C14 correctly leaves the installer unknown (`output.md:202-213`). The current README block is comment-only (`README.md:70-78`), and no command is asserted in P0. This is an evidence gap for P5, not a reason to invent an install command now.
- D006-2/3/4/5/6/7/8 remain planned revisions only (`output.md:237-248`); F-D7-02 stays evidence-only and F-D8-02 stays superseded/no-live-change (`output.md:231-235`). No deferred item was silently promoted to live scope.

### C06 boundary check

C06's two-axis contract is coherent on paper: full scans at Orient/periodic Verify and light transition checks at five boundaries (`output.md:98-109`, `output.md:269-279`). The live details already describe the same split (`workflow-steps.md:246-272`). No high ambiguity was found; runtime execution remains unrun.

## Counterexample Table

| ID | Input state | Matrix rule | Expected outcome | Observed ambiguity | Severity | Minimal rework |
|---|---|---|---|---|---|---|
| CE-01 | Required R2 absent from Checks Run and Not Checked | C01/C02 | FAIL/needs-rework | Required-check identity is packet-dependent but no missing-ID rule is stated | high | Add `required_check_status` table and fail on any declared ID not `run` |
| CE-02 | Validator unavailable blocks required R2; only Known Blind Spots mentions it | C02 | FAIL/needs-rework | Structural cause can be treated as a nonblocking blind spot instead of an omitted required check | high | Require the blocked check ID in Not Checked; Known Blind Spots may explain cause only |
| CE-03 | Empty run directory; Verify dispatch requested before local packet creation | C03 | Create packet, gate, then dispatch | Stage 4 has no explicit local entry state; literal gate can fall back to Plan | high | Add a named Verify-worker sub-state with one exit to dispatch and no Plan loop |
| CE-04 | Reviewer run has output/report body but blank Review Result | C03/C07 | Control finalizes once without reviewer-of-review | Either recursive reviewer or unstated control exception | high | Define control-only finalization for reviewer/audit runs or split result artifact and exempt it explicitly |
| CE-05 | Fold `mv` succeeds once, fails second time, leaves active+archive candidates | C04/C10 | Stop, record deterministic block, preserve recoverable state | No rollback/idempotency/error precedence | high | Add pre/post candidate snapshot, named `FOLD_MOVE_PARTIAL`, Orient blocked |
| CE-06 | Worker Writable list includes report.md; control owns Review Result section | C07 | Two writers cannot overwrite each other | File-level lists cannot express section ownership | high | Separate worker report from control Review Result artifact |
| CE-07 | Capability tuple `(independent=unknown, concurrent=unknown, actual=unknown, diversity=unknown)` | C08/C12 | Halt only for independent unknown; record other unknowns | “unknown blocks every write” is not stated as a dimension-specific policy | medium | Add explicit hard/soft matrix and preflight propagation field |
| CE-08 | Role=reviewer; packet contains marker but host prompt omits reviewer asset | C09 | Dispatch must be blocked or asset load observed | Packet-generation marker is not host-dispatch evidence | medium | Require host-native prompt/dispatch record or label inferred route as unverified |
| CE-09 | One row, both active/archive candidates, reopen requested | C10 | One named blocking result before move | Reopen intent and both-root error precedence unspecified | high | Define resolver precedence before any fold/reopen action |
| CE-10 | Duplicate task_board rows plus orphan directory, no matching active candidate | C10 | One blocking namespace error | Multiple error predicates can produce multiple plausible blockers | high | Define ordered resolver error enum and one selected result |
| CE-11 | P2 edits Stage 3 text while C05 vocabulary waits for P5 | C05 | New text uses frozen one-plus-six phrase | Phase graph permits contradictory wording until P5 | medium | Add P2 phrase invariant and P5 only broad cleanup |
| CE-12 | Five stage transitions run, no periodic Verify scan due | C06 | Five light records, no full scan | No runtime trace yet; static contract is coherent | medium evidence-gap | P2 transition walkthrough with recorded light/full invocation counts |
| CE-13 | V01 validator absent; V02 flat input nested metadata | C11 | V01 unavailable status; V02 `UNSUPPORTED` | No named V01 unavailable/rule-gap result or selector | medium | Add error enum and selector ownership; test both fixtures |
| CE-14 | `AGENTS.md` style rule vs broken target `../registry-and-compaction.md §2` | C13/C14 | C13 owner defines target syntax; C14 leaves install unknown | AGENTS sentence is not a general link-target SSOT; README has no executable installer | medium | Move syntax owner to a link-integrity reference or narrow AGENTS rule; defer install command discovery |

## Verdict and P0 Gate

- **verdict:** `FAIL`
- **review conclusion:** `needs-rework`
- **P0 gate:** `not-accepted`

Blocking findings that must return to T-P0-02:

1. **C01/C02 decision totality (high):** add a formal packet-level status table and precedence for required omission, structural limitation that blocks a required check, medium defect, high unusable output, and claim mismatch. The table must compute `needs-rework` vs `rejected` without reviewer intuition.
2. **C03/C07 Stage 4 termination (high):** define the Verify-worker local handshake as a named non-recursive sub-state. State whether control directly finalizes reviewer/audit runs or which single artifact is reviewed; do not leave a reviewer-of-review implication.
3. **C07 physical writer ownership (high):** replace section-level dual ownership with a file-level artifact split or an explicitly control-only report writer. Update the ownership matrix and handshake together.
4. **C04/C10 resolver/fold failure (high):** define error precedence for duplicate/both/neither/orphan combinations and a deterministic partial-move result that blocks Orient and preserves recovery state.

Small residual risks can remain assigned to later phases: runtime timing/diversity (C08), host prompt observation (C09), validator tool availability (C11), C05 phrase cleanup, C13 link owner, C14 installer discovery, and F-D7-02 trigger evidence. They must remain explicit evidence gaps and must not be converted into P0 PASS.

## Counts and Coverage

Independent recounts from T-P0-02 and this output:

| Countable set | Claimed | Recounted | Delta |
|---|---:|---:|---:|
| Canonical rules challenged | 14 | 14 | 0 |
| Finding Coverage rows | 17 | 17 | 0 |
| D006 adjudication rows | 8 | 8 | 0 |
| Evidence fixtures E01–E08 | 8 | 8 | 0 |
| Lifecycle walkthrough rows | 7 | 7 | 0 |
| Ownership artifact rows | 7 | 7 | 0 |
| Runtime dimensions | 4 | 4 | 0 |
| Namespace positive examples N01–N03 | 3 | 3 | 0 |
| Validation paths V01–V02 | 2 | 2 | 0 |
| P1–P6 phase rows | 6 | 6 | 0 |
| Challenge Summary rows | 14 | 14 | 0 |
| Counterexamples | 14 | 14 | 0 |

The required compact sequence `14/17/8/8/7/7/3/2/6` therefore has delta 0. The matrix's field completeness remains 140/140 and owner declarations 14/14 by its own recount (`output.md:34-39`); this review does not mistake structural completeness for semantic closure.

Named-list recount (A01–A10):

| Named list | Count | Result |
|---|---:|---|
| `input_gate_failures` | 0 | A01 pass |
| `coverage_errors` | 0 | A02 pass |
| `shallow_challenges` | 0 | A03 pass; all 14 rules challenged and 14 concrete counterexamples |
| `verdict_ambiguities` | 5 | A04 fail; CE-01/02/04/05/13 |
| `lifecycle_blockers` | 2 | A05 fail; CE-03/04 |
| `writer_conflicts` | 1 | A06 fail; CE-06 |
| `boundary_ambiguities` | 5 | A07 fail; CE-05/07/08/09/10 |
| `phase_order_errors` | 1 | A08 fail; CE-11 |
| `boundary_violations` | 0 | A09 pass at final check |
| `claim_mismatches` | 0 | A10 pass; all recount deltas 0 |

## Known Blind Spots

- No Stage 4 reviewer/audit dispatch was run; packet tools were read-only shell tools and this task forbade runtime, installation, formatter, generator, and fixture writes. The recursion finding is a state-machine counterexample, not a claim about an observed host execution.
- No directory move was executed. Fold failure and two-root cases were simulated in memory from the matrix; cross-platform atomicity and actual `mv` behavior remain unverified.
- No YAML-capable validator, fallback implementation, Markdown renderer, host-native prompt inspection, install command, or trigger runtime was executed. These are evidence gaps, not passes.
- Shared workspace is not process-isolated. Before/after status and hashes can detect many mutations but cannot prove another actor did not race between checks.
- Reviewer and control may share model family or parent session. This is a separate context and independent reasoning, not proof of model/session isolation.
- No claim is made that P0 ran concurrent workers; C08 actual concurrency and diversity remain unknown/serial by observation.

## Recheck Addendum

### Recheck scope and method

- This is an independent recheck of the append-only T-P0-02 `## Rework Amendment` (RA1–RA4 and the absorbed non-blocking amendments), not a new matrix or a trust of its closure table. The original 198 output lines and 84 report lines were left unchanged before this addendum.
- Evidence was recomputed from `T-P0-02/output.md:351-508`, using in-memory status tuples/state walks only. No live skill, control file, prior run, task packet, archive, or installed copy was written.
- The recheck deliberately tested malformed-but-representable packet/report states and operation intents that the amendment's prose must classify, rather than replaying only AR-01–AR-08 or the 14 claimed closure rows.

### Recheck checks

| Check | Result | Independent finding |
|---|---|---|
| RA1 verdict totality | **FAIL / high** | ID set-diff and first-match precedence close the five original boundaries, but the status schema admits `run_state=run, outcome=not-run, evidence_ref=ref` (or `run_state=run, outcome=pass, evidence_ref=none`); it is neither `STATUS_INVALID` nor a row-1/2/3 predicate, while row 4 requires `run/pass`. No verdict is selected. Cross-field consistency and malformed-status handling are not defined at `output.md:364,376-379`. |
| RA2 Stage 4 termination | PASS | V0→V1→V2→V3 has no Plan edge and V2 explicitly forbids reviewer-of-review (`output.md:400-415`). Direct, reviewer, and pure-audit traces terminate through control-owned results. The direct V0 branch should say explicitly that control writes the target result required by V3, but this is a clarity gap, not recursion. |
| RA3 physical writer ownership | PASS | Worker `report.md` and control `review-result.md` are disjoint physical artifacts, and every packet is required to list the latter as forbidden (`output.md:417-437`). The seven rows therefore have one writer each; the former section-level dual writer is actually removed from the amended contract. |
| RA4 resolver/move recovery | **FAIL / high** | Marker/duplicate/orphan/both/missing precedence is ordered and partial moves stop with `FOLD_MOVE_PARTIAL` (`output.md:439-459`). But row 7 returns `PROJECT_ACTIVE`/`PROJECT_FOLDED` without a resolver result for illegal operation intent: `reopen` on active, `fold` on folded, or `fold` on active without closed/threshold predicates. The effect sentence (“reopen only…”, “fold only…”) is not a predicate or blocking enum, so the same input can be treated as a resolved project or an operation block. |
| C05 phrase guard | evidence-gap, non-blocking | The amendment freezes the phrase guard for P2 before P5 cleanup (`output.md:461-466`), but no live diff check has run. |
| C08/C12 hard/soft unknown policy | PASS statically; runtime-gap | The four dimensions and sole hard pre-write gate are explicit, including propagation of `yes` (`output.md:466,473-480`). Actual host timing remains unobserved. |
| C09 role route | evidence-gap, non-blocking | Host-native prompt/dispatch evidence and `ROLE_ROUTE_EVIDENCE_GAP` are explicitly required (`output.md:467`); packet text alone is no longer accepted. |
| C11 validation status | PASS statically; runtime-gap | V01 unavailable/rule-gap/execution states and control-owned V02 selection are named (`output.md:468`); no validator execution was authorized. |
| C13/C14/deferred findings | PASS as disposition | C13 owner move, C14 command deferral, and D7-02/D8-02 no-live-change remain explicit (`output.md:469-471`). |

### RA1 counterexample (new)

| Input state | Applicable amendment rows | Result required for totality | Recheck result |
|---|---|---|---|
| Packet has `required_check_spec=[R1,on_fail=ISSUES]`; report has `required_check_status=[R1,run_state=run,outcome=not-run,evidence_ref=ref:x]`; all headings present; no issue/AC/claim defect | Row 1 does not match (`STATUS_INVALID` is not defined for the cross-field tuple; no `not-run` run state; evidence is non-empty); row 2 and 3 do not match; row 4 requires `run/pass` | Exactly one FAIL or STATUS_INVALID | No row matches: verdict is undefined. This is a remaining high totality blocker. |

The analogous `run_state=run,outcome=pass,evidence_ref=none` state is caught by row 1, so the gap is specifically the missing consistency predicate for `run_state`/`outcome` (and any equivalent malformed enum combination), not a re-litigation of AR-01–AR-08.

### RA2/RA3 state and writer walk

- Direct review: `V0_TARGET_READY` → control result → `V3_CONTROL_FINALIZED`; no worker or reviewer-of-review edge exists.
- Independent reviewer: control writes verifier packet → `V1_VERIFY_PACKET_READY` → worker output/report → `V2_VERIFY_RUN_LANDED` → control writes verifier and target `review-result.md` → `V3_CONTROL_FINALIZED`.
- Pure audit follows the same path and declares its own output/report/result paths (`output.md:406-413`). The physical writer sets are `report.md={worker}` and `review-result.md={control}` (`output.md:419-435`); intersection is empty. No Stage 4 recursion or file-level dual writer remains in the amended rule.

### RA4 resolver and recovery walk

The amendment uniquely handles the six namespace shapes and marker precedence: `FOLD_MOVE_PARTIAL` → duplicate → orphan → both-root → missing-root → new → active/folded (`output.md:443-451`), and a failed batch stops before later moves with recovery required (`output.md:453-457`). Recovery may choose restore or finish, but both paths require snapshot verification and marker clearing; the blocking state remains unique.

The unresolved operation-intent cases are concrete:

| Input | Row 7 output | Missing contract |
|---|---|---|
| `rows=1,A=1,R=0, intent=reopen` | `PROJECT_ACTIVE` | No named block/result for reopen-on-active. |
| `rows=1,A=0,R=1, intent=fold` | `PROJECT_FOLDED` | No named block/result for fold-on-folded. |
| `rows=1,A=1,R=0, intent=fold, closed/threshold=false` | `PROJECT_ACTIVE` | Effect qualifier is prose, not a resolver predicate/enum. |

These are not move-atomicity unknowns; they are missing resolver outcomes. A minimal rework is to add an operation-intent predicate (for example `PROJECT_OPERATION_INVALID`) before the success row and define its effect as a hard block with no move.

### Recheck verdict and P0 gate

- **Recheck verdict:** `FAIL`
- **Recheck conclusion:** `needs-rework`
- **P0 gate:** `not-accepted`
- Blocking rework is limited to RA1 malformed status totality and RA4 operation-intent precedence. RA2's non-recursive termination and RA3's file-level split are accepted as closed. C05/C08/C09/C11/C13/C14 remain evidence gaps or explicit deferred dispositions, not additional P0 blockers.

## Final Recheck Addendum

### Scope and independence

- This is the final recheck of the same T-P0-03 packet. It independently evaluates only T-P0-02 `RA1.2` and `RA4.2`, then checks that RA2/RA3, compact counts, and live boundaries did not drift. The prior output/report prefixes and both historical `FAIL / needs-rework` addenda are preserved byte-for-byte.
- Evidence was recomputed from T-P0-02 `output.md:514-584` and the count/coverage ranges at `output.md:14-29,217-330`; no T-P0-02, live, installed, control, task packet, or archive file was written.

### Final checks

| ID | Check | Result | Independent evidence |
|---|---|---|---|
| F-R1 | RA1.2 exhaustive normalized tuple table | **PASS** | All `2×3×2=12` cells at T-P0-02 `output.md:526-539` were enumerated: exactly 3 valid (`run/pass/present`, `run/fail/present`, `not-run/not-run/none`) and 9 `STATUS_INVALID`; no fallthrough. |
| F-R1-E | RA1.2 out-of-enum and precedence | **PASS** | Unknown/missing `run_state` or `outcome` is explicitly `STATUS_INVALID` before ID-set, blind-spot, `on_fail`, claim-mismatch, or PASS logic (`:541-545`). `STATUS_INVALID` always yields FAIL; terminal issue facts alone select `rejected`, otherwise `needs-rework` (`:522`). |
| F-R4 | RA4.2 error precedence | **PASS** | Marker/transaction error, duplicate row, orphan root, both roots, and missing root are ordered 1–5 before intent/base-shape classification (`:549,443-451`); injected errors override intent. |
| F-R4-I | RA4.2 4×3 intents + unknown | **PASS** | All 12 base-shape/intent cells at `:551-556` have one result+effect. Unknown intent is `PROJECT_OPERATION_INVALID + UNKNOWN_OPERATION` (`:558`). |
| F-R4-E | RA4.2 invalid effects | **PASS** | Every invalid fold/reopen or ineligible intent is `PROJECT_OPERATION_INVALID`; it hard-blocks and performs no snapshot, move, root, or task-board write (`:549,558,562-570`). Only `ALLOW_FOLD`/`ALLOW_REOPEN` authorize move protocol. |
| F-R23 | RA2/RA3 non-regression | **PASS** | RA2 remains V0→V1→V2→V3 with zero Plan/reviewer-of-review edges; RA3 remains worker-only `report.md` plus control-only `review-result.md`, seven writer rows, empty intersections (`T-P0-02/output.md:400-437,578-579`). |
| F-COUNT | Required counts and sets | **PASS** | Independent bounded recount: `14/17/8/8/7/7/3/2/6`; tuple rows `12` (3 valid/9 invalid); operation cells `12`; no delta from required sequence (`T-P0-02/output.md:576-582`). |
| F-BOUNDARY | Live/source-installed boundary | **PASS** | `git diff --name-only -- enloom-skill README.md PROGRESS.md CHANGELOG.md AGENTS.md` empty; `diff -qr enloom-skill /Users/bigo/.agents/skills/enloom` empty; no forbidden/control file was written by this recheck. T-P0-02 `task.md` has the authorized Rework Addendum 2 packet text (current hash `cab75eaf…`, historical pre-addendum hash `4ec64854…`), which is input evolution, not live drift. |

### RA1.2 totality table (independent replay)

| `run_state` | `outcome` | normalized evidence | Result | Verdict/conclusion path |
|---|---|---|---|---|
| run | pass | present | valid | continue RA1 predicates |
| run | pass | none | invalid | FAIL; `needs-rework` unless terminal facts |
| run | fail | present | valid | apply frozen `on_fail` and later predicates |
| run | fail | none | invalid | FAIL; `needs-rework` unless terminal facts |
| run | not-run | present/none | invalid | FAIL; `needs-rework` unless terminal facts |
| not-run | pass/fail | present/none | invalid | FAIL; `needs-rework` unless terminal facts |
| not-run | not-run | present | invalid | FAIL; `needs-rework` unless terminal facts |
| not-run | not-run | none | valid omission | FAIL / `needs-rework` |

The grouped rows expand to all 12 combinations (3 valid, 9 invalid). Explicit out-of-enum probes such as `run_state=paused` or `outcome=skipped`, plus unknown/missing values, cannot default and are invalid. Raw evidence is normalized before this table; it must become `present|none` (an unresolvable reference is not `present`), so contradictory evidence combinations are invalid rather than a third evidence state. A malformed tuple plus an evidenced terminal issue is uniquely `FAIL / rejected`; the same malformed tuple without terminal facts is uniquely `FAIL / needs-rework`. Thus tuple validity, verdict precedence, and conclusion precedence cannot produce two answers.

### RA4.2 intent and no-move replay

| Base shape | `lookup` | `fold` | `reopen` |
|---|---|---|---|
| `PROJECT_NEW` | `PROJECT_NEW + ALLOW_CREATE_AFTER_NORMAL_GATES` | `PROJECT_OPERATION_INVALID + MOVE_REQUIRES_EXISTING_PROJECT` | same invalid/no-move |
| active, `closed && threshold` | `PROJECT_ACTIVE + RESOLVE_ACTIVE` | `PROJECT_ACTIVE + ALLOW_FOLD` | `PROJECT_OPERATION_INVALID + REOPEN_REQUIRES_FOLDED` |
| active, either predicate false | `PROJECT_ACTIVE + RESOLVE_ACTIVE` | `PROJECT_OPERATION_INVALID + FOLD_PREDICATE_FALSE` | `PROJECT_OPERATION_INVALID + REOPEN_REQUIRES_FOLDED` |
| `PROJECT_FOLDED` | `PROJECT_FOLDED + RESOLVE_ARCHIVE_READ_ONLY` | `PROJECT_OPERATION_INVALID + FOLD_REQUIRES_ACTIVE` | `PROJECT_FOLDED + ALLOW_REOPEN` |

Unknown/missing intent is `PROJECT_OPERATION_INVALID + UNKNOWN_OPERATION`. The five namespace/transaction errors win before this table, including partial marker + any intent and both-root + reopen. Every invalid cell and unknown intent has zero snapshot/move/root/task-board effects; only the two `ALLOW_*` effects enter the move protocol. This closes the two prior high blockers without changing RA2/RA3.

### Final verdict

- **verdict:** `PASS`
- **review conclusion:** `accepted`
- **P0 gate:** `accepted for the two returned blockers; no high blocker remains`
- The PASS is limited to this static, deterministic final recheck. Runtime dispatch, filesystem move execution, validator/install/trigger execution, and host-native prompt observation remain declared future evidence gaps; they are not silently promoted to runtime PASS.
