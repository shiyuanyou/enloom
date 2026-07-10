# T-P0-02 — Canonical Contract Matrix

## Input Gate

- Accepted baseline: `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/report.md` contains exactly one `Verdict: PASS` and one `Conclusion: accepted` (lines 131–132).
- HEAD: `318944b1ff715049a71ebcb21f3e16fe21afc07f`, equal to the accepted baseline HEAD.
- Fact boundary: only the accepted T-P0-01 output/report supplies finding facts. Live files were read only to choose owner/consumer boundaries; T-P0-01 repair candidates were not treated as decisions.
- Source boundary: `enloom-skill/` is the single live source package. `/Users/bigo/.agents/skills/enloom/` is an installed copy and was parity-only input, never an owner.
- P0 boundary at matrix start: live/root diff empty; `diff -qr enloom-skill /Users/bigo/.agents/skills/enloom` empty; archives and serial-integration files read-only.
- Baseline challenge: none. The 17 accepted finding headings and live owner anchors are mutually consistent enough to adjudicate.

## Canonical Rule Index

| ID | One-line rule | Unique owner SSOT | Phase |
|---|---|---|---|
| C01 | Verdict and review conclusion MUST be a total, evidence-derived decision function. | `enloom-skill/references/evidence-contract.md` §Verdict Decision Function (planned) | P1 |
| C02 | The four Evidence fields MUST separate required-check omissions from structural limitations. | `enloom-skill/references/evidence-contract.md` §The Four Elements | P1 |
| C03 | `make-prompt` MUST precede the Law 2 pre-dispatch gate; `task.md` MUST NOT be an Execute entry prerequisite. | `enloom-skill/references/landing-contract.md` §Handshake Sequence | P2 |
| C04 | Triage MUST be side-effect-free; fold MAY run only after `enloom` and compatibility decisions. | `enloom-skill/references/archive-policy.md` §Project Fold | P2 |
| C05 | The lifecycle MUST be named “Stage 0 Triage + six-stage lifecycle (Stages 1–6).” | `enloom-skill/references/workflow-steps.md` §Enloom Lifecycle (planned vocabulary paragraph) | P5 |
| C06 | `health-check` MUST distinguish periodic homes from control-invoked transition execution. | `enloom-skill/references/landing-contract.md` §health-check as the stage-transition hard gate | P2 |
| C07 | Every review/audit artifact MUST land durably with one writer; only control writes Review Result and Registry. | `enloom-skill/references/landing-contract.md` §Artifact Ownership and Verify Handshake (planned) | P3 |
| C08 | Runtime capability, scheduling intent, actual concurrency, and model/session diversity MUST be recorded separately. | `enloom-skill/references/scheduler-rules.md` §Runtime Capability and Actual Dispatch Record (planned) | P3 |
| C09 | `Role` MUST deterministically load its prompt asset or explicitly select packet-only behavior. | `enloom-skill/SKILL.md` §Role-to-Prompt-Asset Route (planned) | P3 |
| C10 | `task_board` plus a two-root resolver MUST locate active/folded/reopened projects uniquely. | `enloom-skill/references/templates/task-board.md` §Resolver (planned) | P4 |
| C11 | Full validation and flat fallback MUST advertise only the checks each path can execute. | `enloom-skill/references/validation.md` §Validation Paths and Promise Boundary (planned) | P4 |
| C12 | Full Enloom MUST preflight independent-sub-agent availability before any Enloom write and disclose it in compatibility metadata/prose. | `enloom-skill/SKILL.md` §Compatibility Preflight (planned) | P5 |
| C13 | Markdown link targets MUST contain only resolvable paths; section hints belong outside the target. | `AGENTS.md` §改 skill 的纪律 (planned reference-link sentence) | P4 |
| C14 | README Install MUST contain an executable supported procedure and parity check, not a comment-only block. | `README.md` §Install · 安装 | P5 |

## Canonical Rules

### C01 — Total Evidence Decision Function

- **canonical rule**: Control MUST derive exactly one result as follows: `FAIL` when Result is not `done`, any of the four required report headings is absent, any required check is not run, evidence for an executed required check is empty, an acceptance criterion is unmet/rewritten/waived, or an unresolved high-severity issue exists; otherwise `ISSUES` when a medium/low defect exists (including a claim mismatch that is not itself an acceptance failure); otherwise `PASS`. Control MUST map `PASS→accepted`, `ISSUES→accepted-with-risk`, and `FAIL→needs-rework` when a bounded in-scope correction/evidence request exists or `FAIL→rejected` when the output is unusable, unsafe, wrong-direction, or not repairable within the packet.
- **unique owner SSOT**: `enloom-skill/references/evidence-contract.md` §Verdict Decision Function (planned; exactly one owner file).
- **consumers**: `references/workflow-steps.md`; `references/review-checklist.md`; `references/templates/audit-task-packet.md`; `references/templates/worker-report.md`; `prompt-assets/reviewer.md`; README may summarize but MUST link to the owner.
- **finding coverage**: F-D1-01.
- **rationale and rejected alternatives**: A total function closes the current incomplete `iff` and keeps verdict separate from integration disposition. Rejected: the two-condition `iff`; “mapping is only typical”; allowing control to waive packet acceptance after execution.
- **minimal migration boundary**: owner—replace the competing formulas with one ordered decision function; workflow/checklist—a short reference plus identical state names; audit/report/reviewer templates—collect the inputs, do not restate a second formula.
- **forbidden legacy wording/behavior**: “PASS iff checks ran and evidence is non-empty” as a complete formula; “typical mapping” without repairability criteria; changing expected counts after seeing output.
- **executable verification**: P0 static—`rg -n 'if and only if|当且仅当|Typical review conclusion|mapping is a default' enloom-skill/references/{evidence-contract,workflow-steps,review-checklist}.md` must expose the current competing text (confirmed). Future P1 candidate—run the Evidence truth table below through every consumer; pass = identical verdict/conclusion for every fixture, fail = any divergent or multi-valued result.
- **landing phase**: P1 only.
- **residual risk / evidence still needed**: P1 must specify how packets label a failed check as acceptance-blocking versus medium/low; P6 must regrade the three frozen dogfood reports without rewriting them.

### C02 — Four-Field Gap Taxonomy

- **canonical rule**: A completion report MUST contain the four existing headings. `Checks Run` maps every executed required-check ID to outcome; `Evidence` maps each executed ID to concrete proof; `Not Checked` contains only packet-declared required-check IDs that were not executed (or explicit `None`) and therefore blocks PASS; `Known Blind Spots` contains structural/runtime/out-of-scope limitations with reason, risk, and impact (or explicit `None`) and MAY coexist with PASS when no required check or acceptance criterion is compromised. A structural limitation MUST NOT be placed in `Not Checked`, and a required omission MUST NOT be softened into a blind spot.
- **unique owner SSOT**: `enloom-skill/references/evidence-contract.md` §The Four Elements.
- **consumers**: `references/review-checklist.md`; `references/workflow-steps.md`; `references/templates/worker-report.md`; `references/templates/audit-task-packet.md`; `prompt-assets/researcher.md`; `prompt-assets/coder.md`; `prompt-assets/reviewer.md`; `references/glossary.md`.
- **finding coverage**: F-D1-02.
- **rationale and rejected alternatives**: This preserves all four invariant field names while giving omissions and limitations disjoint semantics. Rejected: renaming the invariant fields; listing the three runtime limitations under `Not Checked`; allowing a missing heading because its set is empty.
- **minimal migration boundary**: owner—define disjoint field semantics; worker/audit templates—change prompts and examples; role assets—route omissions/limitations correctly; checklist/workflow/glossary—reference the owner instead of duplicating old definitions.
- **forbidden legacy wording/behavior**: “Not Checked = declared blind spots”; “Known Blind Spots = reasons only for Not Checked”; mandatory structural limitations in both fields; silent empty/missing headings.
- **executable verification**: P0 static—`rg -n 'Not Checked|Known Blind Spots|structural|Virtual parallelism' enloom-skill/references/evidence-contract.md enloom-skill/references/templates/worker-report.md enloom-skill/prompt-assets/*.md` confirms the current overlap. Future P1 candidate—schema-check the eight fixtures below; pass = every item classifies into exactly one field and only required omissions block, fail = duplicate/zero classification.
- **landing phase**: P1 only.
- **residual risk / evidence still needed**: Structural limitations may still imply an acceptance failure when they prevent a required check; P1 fixtures must cover that edge explicitly.

### C03 — Non-Circular Packet and Dispatch Gate

- **canonical rule**: Entry to Stage 3 Execute MUST require the accepted Stage 2 phase plan, not `task.md`. For an execution worker, `make-prompt` is the first Stage 3 control action and writes a complete `runs/<TASK>/task.md`; only then MUST the Law 2 pre-dispatch gate check that file and permit dispatch. A Stage 4 review/audit worker MUST use the same local `make-prompt → task.md exists → dispatch` mini-handshake inside Verify. No worker may run before its on-disk packet exists.
- **unique owner SSOT**: `enloom-skill/references/landing-contract.md` §2 Handshake Sequence.
- **consumers**: `enloom-skill/SKILL.md` Lifecycle/sub-action table; `references/workflow-steps.md` Stage 3 and Stage 4; `references/glossary.md` Gate/Landing; `references/templates/task-packet.md`; `references/templates/audit-task-packet.md`.
- **finding coverage**: F-D2-01.
- **rationale and rejected alternatives**: The dispatch gate remains hard while packet creation becomes reachable. Rejected: moving packet construction back to Plan; treating a missing task packet as an Execute entry failure that sends control to Plan; context-only review/audit prompts.
- **minimal migration boundary**: landing owner—replace Stage 3 entry and reorder handshake; workflow/SKILL/glossary—distinguish stage entry from pre-dispatch; templates—state their stage-local landing path.
- **forbidden legacy wording/behavior**: “Stage 3 entry gate: task.md exists”; entry check before make-prompt; verbal dispatch without durable packet; claiming make-prompt is only usable before Stage 3.
- **executable verification**: P0 static—`rg -n 'Stage 3 entry gate|Entry gate.*task.md|make-prompt' enloom-skill/{SKILL.md,references/workflow-steps.md,references/landing-contract.md}` confirms the current order. Future P2 candidate—start with an empty run directory and trace writes; pass = phase plan → task.md → dispatch → output/report, fail = any read/check of task.md before its creator action or any dispatch before it exists.
- **landing phase**: P2 only.
- **residual risk / evidence still needed**: P2 must verify the Stage 4 mini-handshake does not create a recursive requirement to review the reviewer with another reviewer.

### C04 — Side-Effect-Free Triage and Post-Decision Fold

- **canonical rule**: Stage 0 Triage MUST decide `direct | light-plan | enloom` without creating files, dispatching agents, or moving directories. `direct`/`light-plan` MUST exit with no fold. Only after `enloom` MAY control (the serial namespace owner) read `task_board`, apply C10, and fold qualifying closed top-level projects before Orient. Fold MUST NOT require a worker and MUST NOT alter the task_board row. When C12 lands in P5, its earlier compatibility preflight composes before this post-decision fold without changing fold ownership.
- **unique owner SSOT**: `enloom-skill/references/archive-policy.md` §Project Fold.
- **consumers**: `references/workflow-steps.md` Stage 0; `enloom-skill/SKILL.md` First Move/sub-action table; `references/glossary.md` Fold; `AGENTS.md` archived-evidence guidance.
- **finding coverage**: F-D2-02.
- **rationale and rejected alternatives**: Namespace moves are serial control work and need no pre-triage worker. Rejected: “hygiene first, triage second”; automatic fold at phase close; preserving sub-agent dispatch merely because the old prose used it.
- **minimal migration boundary**: archive owner—move trigger after `enloom` and assign control; workflow/SKILL/glossary/AGENTS—summarize the post-decision timing and point back to owner.
- **forbidden legacy wording/behavior**: “before Triage, dispatch fold”; any pre-result `mv`; fold on direct/light-plan; concurrent fold with Orient; deleting/upserting the task_board row during fold.
- **executable verification**: P0 static—`rg -n '再做 Triage|进新任务前|派 sub-agent|Stage 0 Triage 时' enloom-skill/references/{workflow-steps,archive-policy,glossary}.md AGENTS.md` confirms current pre-decision behavior. Future P2 candidate—snapshot filesystem, run a direct and light-plan case with ≥3 foldable rows, then an enloom case; pass = zero delta for the first two and control-owned moves only after decision for the third.
- **landing phase**: P2 only.
- **residual risk / evidence still needed**: Cross-platform atomicity of the directory move is runtime-dependent; a failed move must leave the row/path ambiguity visible and block Orient.

### C05 — Lifecycle Count and Naming

- **canonical rule**: All normative text MUST call the model “Stage 0 Triage entry decision + six-stage lifecycle, Stages 1 Orient through 6 Close.” “Six-stage lifecycle” MUST NOT enumerate Triage as one of its six stages; “Stages 0–6” MAY describe the full seven-row walkthrough only when it explicitly says one entry stage plus six lifecycle stages.
- **unique owner SSOT**: `enloom-skill/references/workflow-steps.md` §Enloom Lifecycle (planned vocabulary paragraph).
- **consumers**: `enloom-skill/SKILL.md` Lifecycle; `README.md` How it works; `references/glossary.md` Lifecycle Stage; other references link or use the exact owner phrase.
- **finding coverage**: F-D2-03.
- **rationale and rejected alternatives**: The numbering remains stable while the count becomes true. Rejected: renumbering 1–7; calling all seven rows “six stages”; treating Triage as both outside and inside the six without qualification.
- **minimal migration boundary**: owner—define the phrase once; SKILL/README/glossary—replace count summaries; no stage logic changes in this phase.
- **forbidden legacy wording/behavior**: “six stages: 0 Triage … 6 Close”; “lifecycle Stage 0–6” without the one-plus-six qualifier.
- **executable verification**: P0 static—`rg -n 'six stages|6 阶段|六阶段|0\. Triage|6\. Close' enloom-skill/SKILL.md enloom-skill/references/{workflow-steps,glossary}.md README.md` currently shows seven numbered rows under six-stage wording. Future P5 candidate—fixed-phrase grep plus a row count; pass = one Stage 0 and exactly six Stage 1–6 rows with the qualifier, fail = any unqualified six/seven collision.
- **landing phase**: P5 only.
- **residual risk / evidence still needed**: P2 behavior edits must use the frozen terminology even though broad wording cleanup waits until P5.

### C06 — health-check Homes and Executor

- **canonical rule**: `health-check` MUST have two non-conflicting invocation contracts: full periodic drift scans have homes in Stage 1 Orient and periodic Stage 4 Verify; light transition checks are invoked by control at each boundary `1→2`, `2→3`, `3→4`, `4→5`, `5→6` and verify only the previous stage exit gate. The procedure reports; control repairs. A periodic home MUST NOT be presented as the complete set of transition execution points.
- **unique owner SSOT**: `enloom-skill/references/landing-contract.md` §4 health-check as the stage-transition hard gate.
- **consumers**: `references/workflow-steps.md` Health Check; `enloom-skill/SKILL.md` sub-action table/Landing Discipline; `README.md` Controls; `references/glossary.md` health-check two tiers.
- **finding coverage**: F-D2-04.
- **rationale and rejected alternatives**: “Where full scans live” and “who invokes transition checks” are different axes. Rejected: mapping health-check only to Orient/Verify; full nine-item scans on every transition; health-check auto-fixing drift.
- **minimal migration boundary**: owner—state homes, executor, five boundaries; workflow—implementation detail; SKILL/README/glossary—two-axis summary and owner link.
- **forbidden legacy wording/behavior**: a stage column containing only `1 Orient + 4 Verify` without transition note; “health-check owns every stage”; transition checks with no invoker.
- **executable verification**: P0 static—`rg -n 'health-check' enloom-skill/SKILL.md README.md enloom-skill/references/{workflow-steps,landing-contract,glossary}.md` confirms the index/detail mismatch. Future P2 candidate—walk the five transitions; pass = five light records plus full records only at Orient/when Verify periodic is due, fail = a skipped boundary or full scan required at every boundary.
- **landing phase**: P2 only.
- **residual risk / evidence still needed**: First-use Orient has no pre-existing project state; P2 must define the minimal full-scan behavior for that case without inventing a Stage 0 file gate.

### C07 — Durable Review/Audit Ownership

- **canonical rule**: Control MUST write every task/review/audit packet and is the only durable writer of each target `report.md` Review Result subsection, `project_state.md`/Registry, decisions, and archive entries. The assigned execution worker MUST write only its `output.md`, `raw-notes.md` (optional), and `report.md` body excluding Review Result. When independent review is required, a dedicated reviewer run MUST receive its own packet and the reviewer MUST write its verdict/conclusion/Registry proposals to that run’s `output.md` plus Evidence report; it MUST NOT edit the target report or Registry. A pure audit MUST likewise be a complete run with packet boundaries and durable output/report; context-only return is invalid.
- **unique owner SSOT**: `enloom-skill/references/landing-contract.md` §Artifact Ownership and Verify Handshake (planned).
- **consumers**: `references/workflow-steps.md` Verify; `references/review-checklist.md`; `references/registry-and-compaction.md` Update Discipline/Ownership; `references/templates/task-packet.md`; `references/templates/audit-task-packet.md`; `references/templates/worker-report.md`; `prompt-assets/reviewer.md`; `references/archive-policy.md`.
- **finding coverage**: F-D3-01, F-D3-02.
- **rationale and rejected alternatives**: Reviewer judgment remains independent while final integration stays serial. Rejected: reviewer writes Registry; reviewer edits target Review Result; pure audit returns only chat; audit packet omits Writable/Forbidden/output paths; control rewrites worker report evidence.
- **minimal migration boundary**: landing owner—artifact/writer table and review/audit handshake; audit/worker/task templates—complete paths and blank control subsection; reviewer asset—write only own run; workflow/checklist/registry/archive—reference owner and preserve control intake.
- **forbidden legacy wording/behavior**: “reviewer logs Registry”; “reviewer modifies no files but writes conclusion” without a writable run; pure audit only returns caller counts; shared writer for a durable artifact; audit without Review Result.
- **executable verification**: P0 static—`rg -n 'Log discovered|Modify any file|pure audit worker|Return To Caller|Review Result|control agent.*log' enloom-skill/prompt-assets/reviewer.md enloom-skill/references/{landing-contract,workflow-steps,review-checklist}.md enloom-skill/references/templates/{audit-task-packet,worker-report}.md` confirms the conflict. Future P3 candidate—instantiate one execution, one reviewer, one audit run and recount writer columns; pass = every artifact writer count 1 and all output/report files exist, fail = count 0/>1 or context-only evidence.
- **landing phase**: P3 only.
- **residual risk / evidence still needed**: Report body and Review Result share one physical file but are distinct durable sections; P3 must test that packet permissions make the section boundary unambiguous and detect worker overwrite.

### C08 — Runtime Capability vs. Actual Execution

- **canonical rule**: Every phase that dispatches workers MUST record four independent facts: independent-sub-agent availability (`yes|no|unknown`), concurrent-dispatch capability (`yes|no|unknown`), actual execution (`serial|concurrent|mixed|unknown`, backed by observation), and model/session diversity (`same|different|mixed|unknown`). `strategy: parallel` expresses scheduling intent only. Unknown MUST remain unknown; concurrent capability MUST NOT imply actual concurrency, and model/session diversity MUST NOT be claimed as process isolation.
- **unique owner SSOT**: `enloom-skill/references/scheduler-rules.md` §Runtime Capability and Actual Dispatch Record (planned).
- **consumers**: `references/evidence-contract.md` Honest Blind Spots; `references/glossary.md`; `references/templates/phase-plan.md`; `references/templates/worker-report.md`; `README.md` non-runtime boundary.
- **finding coverage**: F-D4-01.
- **rationale and rejected alternatives**: The protocol works on sequential and concurrent hosts without universalizing either. Rejected: “control always spawns sequentially”; “parallel means concurrent”; treating different agents/models as proven isolation.
- **minimal migration boundary**: owner—capability/actual record; phase/report templates—fields or compact table; evidence/glossary—conditional limitations; README—summary only.
- **forbidden legacy wording/behavior**: universal “virtual parallelism = no concurrency”; capability inferred from one host/session; actual concurrency inferred from strategy; unknown rendered as no/yes.
- **executable verification**: P0 static—`rg -n 'sequential|顺序发起|virtual parallelism|parallel.*protocol' enloom-skill/references/{scheduler-rules,evidence-contract,glossary}.md enloom-skill/references/templates/worker-report.md` confirms universalized wording. Future P3 candidate—fill the Runtime Capability matrix below for sequential, concurrent, and unknown profiles; pass = no derived field changes another, fail = an inference substitutes for observation.
- **landing phase**: P3 only.
- **residual risk / evidence still needed**: Actual concurrency needs timestamps or runtime-native evidence; P0 and the accepted baseline deliberately provide none.

### C09 — Deterministic Role-to-Asset Route

- **canonical rule**: Before dispatch, `make-prompt` MUST resolve packet `Role` through one canonical table: `researcher→prompt-assets/researcher.md`, `coder→prompt-assets/coder.md`, `reviewer→prompt-assets/reviewer.md`, `integrator→packet-only`, `tester→packet-only`. A mapped asset MUST be read and incorporated with the packet boundary; packet-only MUST be recorded explicitly. Prompt assets MUST remain source assets and MUST NOT be copied into each project by default.
- **unique owner SSOT**: `enloom-skill/SKILL.md` §Role-to-Prompt-Asset Route (planned).
- **consumers**: `references/workflow-steps.md` make-prompt; `references/templates/task-packet.md` Role; `references/scheduler-rules.md` recon route; `references/prompt-control.md`; the three `prompt-assets/*.md` files identify themselves but do not own routing.
- **finding coverage**: F-D4-02.
- **rationale and rejected alternatives**: The existing assets become load-bearing without inventing assets for roles that lack one. Rejected: agent discovery; copying assets to every project; silently mapping integrator/tester to a semantically different asset.
- **minimal migration boundary**: owner—add the five-role table and pre-dispatch check; workflow/task template—reference it; scheduler/prompt-control—remove one-off routing as owner; prompt assets need only stable identity markers if P3 verification requires them.
- **forbidden legacy wording/behavior**: Role as documentation-only metadata; “read on demand” with no route; default project-local copies; silent missing asset.
- **executable verification**: P0 static—`rg -n 'Role:|prompt-assets|researcher.md|coder.md|reviewer.md' enloom-skill/SKILL.md enloom-skill/references/{workflow-steps,scheduler-rules,prompt-control}.md enloom-skill/references/templates/task-packet.md` shows no complete table. Future P3 candidate—generate five packets with unique asset markers; pass = three exact markers and two explicit `packet-only` records, fail = absent/wrong/duplicate asset.
- **landing phase**: P3 only.
- **residual risk / evidence still needed**: Host-native prompt inspection may be unavailable; P3 must use the strongest observable dispatch record and label any inference.

### C10 — Deterministic Project Namespace Resolver

- **canonical rule**: Resolver input is the stable project slug. `task_board` MUST contain at most one row for it; derive `<created>-<project>` and check exactly two candidates: `.enloom/<dir>` and `.enloom/archive/<dir>`. Exactly one existing candidate resolves; both or neither with an existing row is a blocking namespace error; a directory without a row is an orphan and blocks creation. No row and no candidate creates one new project. Reopening an archived same-name project MUST move that exact directory back to the active root and update the existing row’s `updated/phase` while preserving `created`; it MUST NOT create a duplicate.
- **unique owner SSOT**: `enloom-skill/references/templates/task-board.md` §Resolver (planned).
- **consumers**: `references/workflow-steps.md` Orient; `references/archive-policy.md` Fold/reopen; `enloom-skill/SKILL.md` File Protocol; `references/glossary.md` Project/task_board/Fold.
- **finding coverage**: F-D5-01.
- **rationale and rejected alternatives**: Searching two fixed roots avoids a schema column while making fold location explicit. Rejected: always deriving only the active root; relying on `phase=closed` (closed directories may be folded or not); creating a new same-name project when lookup fails.
- **minimal migration boundary**: task-board owner—algorithm and error states; workflow—call resolver before project reads; archive policy—use it before fold/reopen; SKILL/glossary—summary/link only.
- **forbidden legacy wording/behavior**: unconditional `cd .enloom/<created>-<project>`; “path change does not affect lookup” without the two-root check; first-match wins; duplicate row/project creation.
- **executable verification**: P0 static—`rg -n 'cd \.enloom|archive/|复用|reopen|路径变化' enloom-skill/references/templates/task-board.md enloom-skill/references/archive-policy.md enloom-skill/{SKILL.md,references/workflow-steps.md}` confirms missing two-root resolution. Future P4 candidate—run the three examples below plus duplicate/both/neither negatives; pass = one path or one named hard error per case, fail = multiple/zero unexplained outcomes.
- **landing phase**: P4 only.
- **residual risk / evidence still needed**: Directory move failure/partial state needs a recoverable error message; P4 should not add automatic repair beyond blocking and naming both candidates.

### C11 — Honest Validation Paths

- **canonical rule**: A full-contract path MAY claim “skill valid” only after a YAML-capable validator executes every documented rule. A no-dependency flat fallback MUST accept only its declared subset (unindented, single-line flat scalar frontmatter), MUST check both fences and only the scalar/name/description/key rules it actually implements, and MUST return `UNSUPPORTED` (non-zero, not `INVALID`) for nested/multiline/type-sensitive inputs it cannot parse. If full validation is required but unavailable/fails to execute, control MUST halt validation rather than relabel fallback success as full success.
- **unique owner SSOT**: `enloom-skill/references/validation.md` §Validation Paths and Promise Boundary (planned).
- **consumers**: `enloom-skill/SKILL.md` compatibility/frontmatter changes; README Install parity/validation instruction; P4/P5 task packets. No external validator becomes an SSOT.
- **finding coverage**: F-D6-01.
- **rationale and rejected alternatives**: Portability is preserved without false equivalence. Rejected: claiming awk manually parses arbitrary YAML; requiring dependency installation; shipping a permanent validator; saying `quick_validate.py` performs identical checks without execution evidence.
- **minimal migration boundary**: validation owner only for contract and reference fallback; SKILL/README merely invoke the chosen path. No permanent script is added.
- **forbidden legacy wording/behavior**: “grep/sed/awk can do every check”; “frontmatter is flat, therefore full YAML contract passes”; EOF as a closing fence; nested metadata reported as unexpected top-level keys; fallback exit 0 outside its subset.
- **executable verification**: P0 static—`sed -n '7,87p' enloom-skill/references/validation.md` confirms the 11-rule/full-equivalence mismatch. Future P4 candidate—fixtures: valid flat, missing close fence, nested metadata, non-string compatibility, legal full YAML; pass = full path decides all and fallback either correctly decides its subset or returns `UNSUPPORTED`, fail = fallback claims full validity/invalidity outside subset.
- **landing phase**: P4 only.
- **residual risk / evidence still needed**: No authorized YAML-capable validator was executed in P0; exact official tool availability and error vocabulary remain environment-specific.

### C12 — Early Full-Mode Compatibility Preflight

- **canonical rule**: `SKILL.md` compatibility metadata/prose MUST disclose that full Enloom requires dispatch to an independent sub-agent and has no control-self-execution fallback. After Triage returns `enloom` but before creating/updating `.enloom`, folding, or dispatching, control MUST preflight independent-sub-agent availability; `no` or `unknown` MUST halt with a minimal runtime-switch message. Concurrent dispatch and model/session diversity are optional C08 facts, not compatibility requirements. This rule MUST NOT change `description` before F-D7-02 evidence exists.
- **unique owner SSOT**: `enloom-skill/SKILL.md` §Compatibility Preflight (planned; frontmatter is its machine-facing summary).
- **consumers**: `references/landing-contract.md` Sub-agent requirement; `references/trigger-contract.md` explicit invocation; README When to use/Install; `references/validation.md` validates the metadata only on the capable path.
- **finding coverage**: F-D7-01.
- **rationale and rejected alternatives**: The hard requirement remains, but failure occurs before state mutation. Rejected: deleting the requirement; discovering it only at Stage 3; putting it only in description; treating concurrency as mandatory.
- **minimal migration boundary**: owner—metadata summary + preflight timing; landing/trigger/README—link and failure behavior; validation—ensure the chosen path can validate the actual frontmatter form.
- **forbidden legacy wording/behavior**: late Stage 3-only discovery; “no automatic runtime” as a substitute for a requirement; unknown capability assumed yes; `.enloom` writes before preflight; description rewrite without trigger evidence.
- **executable verification**: P0 static—`sed -n '1,20p' enloom-skill/SKILL.md` plus `sed -n '88,96p' enloom-skill/references/landing-contract.md` confirms entry metadata omission and late requirement. Future P5 candidate—two host profiles (`subagent=yes/no`) on explicit invocation; pass = yes enters after preflight, no halts with zero `.enloom` delta, fail = late halt/self-execution/state mutation.
- **landing phase**: P5 only.
- **residual risk / evidence still needed**: Some hosts ignore `compatibility`; prose preflight remains mandatory. Target-host metadata syntax must be verified before choosing nested versus flat representation.

### C13 — Valid Markdown Reference Targets

- **canonical rule**: A Markdown link target MUST be only a resolvable relative path/URL; a human-readable `§Section Title` hint MUST appear in the label or adjacent prose, never inside the target. Inline code examples such as `` `[x](path)` `` MUST remain code and MUST NOT be “fixed” as links.
- **unique owner SSOT**: `AGENTS.md` §改 skill 的纪律 (planned reference-link sentence).
- **consumers**: `enloom-skill/references/templates/task-packet.md`; `enloom-skill/references/templates/worker-report.md`; all future reference edits follow the owner.
- **finding coverage**: F-D8-01.
- **rationale and rejected alternatives**: This extends the existing human-readable section-reference discipline with valid Markdown syntax. Rejected: slug anchors; embedding ` §N` in targets; changing the phase-plan code-span example.
- **minimal migration boundary**: owner—one syntax sentence; task/worker templates—repair exactly the two accepted broken targets. No archive or code-span edit.
- **forbidden legacy wording/behavior**: `](../file.md §N)`; renderer-dependent path guessing; editing inline-code pseudo-links as navigation.
- **executable verification**: P0 static—`rg -n '\]\([^)]*\.md §[0-9]+\)' enloom-skill/references/templates` returns exactly 2 accepted defects. Future P4 candidate—same command returns 0 and each extracted relative target exists; fail = any malformed or missing target.
- **landing phase**: P4 only.
- **residual risk / evidence still needed**: A project renderer DOM check for code spans remains optional low-risk evidence; it cannot justify a live change without reproduction.

### C14 — Reproducible Install Documentation

- **canonical rule**: README Install MUST identify the supported packaging/install mechanism, provide at least one executable command sequence from this repository, state its destination, and provide an executable source/installed parity check. If installation is delegated to external tooling, the exact supported invocation MUST be named; a comment-only code block MUST NOT count as a procedure.
- **unique owner SSOT**: `README.md` §Install · 安装.
- **consumers**: `AGENTS.md` source/copy discipline may link to README for first install but remains owner of development synchronization only.
- **finding coverage**: F-D8-03.
- **rationale and rejected alternatives**: First install and developer sync are separate contracts. Rejected: relying on the current machine’s installed copy; a placeholder comment; inventing a new Enloom CLI.
- **minimal migration boundary**: README Install only; AGENTS gets a link only if needed to prevent duplicated commands.
- **forbidden legacy wording/behavior**: empty/comment-only install block; “uses skill-creator tooling” without invocation; claiming parity without `diff` or equivalent.
- **executable verification**: P0 static—`sed -n '68,80p' README.md` shows the comment-only block. Future P5 candidate—execute documented commands in an isolated temporary agent-home and run documented parity check; pass = install succeeds and diff empty, fail = any copied command is non-executable or parity differs.
- **landing phase**: P5 only.
- **residual risk / evidence still needed**: The supported installer command is not established by accepted P0 facts; P5 must verify available tooling rather than guess.

## Finding Coverage

| Finding ID | Accepted status | Rule / disposition | Reason |
|---|---|---|---|
| F-D1-01 | confirmed | C01 | Replaces competing PASS formulas with one total decision function. |
| F-D1-02 | confirmed | C02 | Separates required omissions from structural limitations without renaming four fields. |
| F-D2-01 | confirmed | C03 | Moves task existence from Stage 3 entry to post-make-prompt pre-dispatch. |
| F-D2-02 | confirmed | C04 | Makes Triage side-effect-free and assigns post-decision fold to control. |
| F-D2-03 | confirmed | C05 | Freezes one-plus-six terminology without renumbering. |
| F-D2-04 | confirmed | C06 | Separates periodic homes from five transition invocations. |
| F-D3-01 | confirmed | C07 | Reviewer proposes in its own run; control alone writes final Review Result/Registry. |
| F-D3-02 | confirmed | C07 | Pure audit becomes a complete durable run with explicit boundaries. |
| F-D4-01 | downgraded | C08 | Converts a host-conditional limitation into capability/actual records. |
| F-D4-02 | confirmed | C09 | Adds deterministic routing for all five Role values. |
| F-D5-01 | confirmed | C10 | Resolves both active and folded roots and defines same-name reopen. |
| F-D6-01 | confirmed | C11 | Separates full validator promise from explicit flat fallback subset. |
| F-D7-01 | confirmed | C12 | Exposes and preflights the independent-sub-agent requirement before writes. |
| F-D7-02 | insufficient-evidence | deferred-evidence | P5/P6 must gather host-native positive/near-miss trigger evidence before any description edit; no current live defect asserted. |
| F-D8-01 | confirmed | C13 | Repairs exactly the two targets and establishes target syntax owner. |
| F-D8-02 | superseded | no-live-change | Inline-code `[x](path)` is not a live link; renderer evidence is absent. |
| F-D8-03 | confirmed | C14 | Makes first-install instructions executable and independently checkable. |

## D006 Adjudication

| ID | Disposition | Rule | Reason |
|---|---|---|---|
| D006-1 | retain | C05 | Exact “Stage 0 + six-stage lifecycle” direction is complete and non-destructive. |
| D006-2 | revise | C01, C02 | Keep semantics but preserve canonical field names: `Not Checked` for required omissions, `Known Blind Spots` for limitations; add total conclusion mapping. |
| D006-3 | revise | C07 | “Returns” must land in a reviewer run; reviewer proposes, control writes Review Result and Registry. |
| D006-4 | revise | C03 | Keep make-prompt-before-dispatch, but define it as a stage-local pre-dispatch handshake (including Verify workers), not an Execute entry prerequisite. |
| D006-5 | revise | C08, C12 | Keep independent sub-agent as the sole hard capability; separate concurrency/actual/diversity and preflight before any write. |
| D006-6 | revise | C04, C10 | Keep post-decision fold and two-root location; assign fold to serial control and define blocking ambiguity/reopen behavior. |
| D006-7 | revise | C11 | Keep official-capable preference/flat fallback, but require `UNSUPPORTED` outside the fallback subset and forbid full-pass claims. |
| D006-8 | revise | C09 | Keep SKILL routing/no copies; explicitly map integrator/tester to packet-only until assets exist. |

## Required Decision Fixtures

### Evidence truth table

Decision order is C01. `None` is an explicit field value, not a missing section. “Repairable?” is evaluated from the packet boundary and output usability, not reviewer preference.

| Fixture | Required checks / AC | Evidence | Not Checked | Known Blind Spots | Open issue | Repairable? | Unique verdict | Unique conclusion |
|---|---|---|---|---|---|---|---|---|
| E01 required check omission | R1 pass; R2 not run; AC otherwise unknown | R1 proof present | `R2: tool unavailable, high` | `None` | required omission | yes, run R2 | FAIL | needs-rework |
| E02 empty evidence | R1 claims pass | empty for R1 | `None` | `None` | evidence missing | yes, attach/rerun | FAIL | needs-rework |
| E03 structural limitation | R1/R2 pass; all AC pass | proof per ID | `None` | `same model/session; medium; does not affect required checks` | no product/report defect | n/a | PASS | accepted |
| E04 unexplained high issue | all declared checks ran but packet direction produced unsafe/unusable output | proof exists but does not resolve high issue | `None` | `None` | high, output unusable in packet | no | FAIL | rejected |
| E05 medium defect | all required checks and AC pass | complete | `None` | `None` | one medium defect with Registry proposal | yes later, nonblocking | ISSUES | accepted-with-risk |
| E06 clean pass | all required checks and AC pass | complete per ID | `None` | `None` | none | n/a | PASS | accepted |
| E07 packet expectation rewritten | checks ran against worker-lowered count, original AC fails | proof shows changed expectation | `None` | `None` | acceptance criterion waived | yes, rework to original packet | FAIL | needs-rework |
| E08 audited claim mismatch | product AC/checks pass; independent recount differs from report claim; mismatch not itself an AC | both claim and recount present | `None` | `None` | low/medium report defect with Registry proposal | yes later, product usable | ISSUES | accepted-with-risk |

Pairwise ambiguity check: PASS rows have no defects or required omissions; ISSUES rows have only nonblocking medium/low defects; FAIL rows each hit a distinct blocking predicate. The two FAIL conclusions are separated by the explicit repairability/output-usability field. Required omission (E01) and structural limitation (E03) never share a semantic field.

### Lifecycle walkthrough

| Row | Stage | Entry / sequence | Durable writes and writer | health-check timing | Exit / no-cycle signal |
|---:|---|---|---|---|---|
| 1 | Stage 0 Triage (entry decision) | Read request; decide `direct|light-plan|enloom` with no writes/dispatch/moves. Direct/light exit. Enloom then runs C12 preflight; only after pass may C04 fold run. | Triage result may remain in control context; post-decision fold is a control-owned serial move, not a worker write. | No stage-transition health-check; no project may yet be located. | Signal: result exists; zero pre-result filesystem delta; no circular artifact prerequisite. |
| 2 | Stage 1 Orient | Resolve/create `task_board` only after preflight; apply C10; read project state and risk Registry; reopen exact archived project if requested. | Control writes task_board/project Current Phase summary when needed. | Full periodic home at Orient; control invokes light `1→2` check on exit. | Signal: exactly one project path and state summary (or documented first-use state). |
| 3 | Stage 2 Plan | Located project is the entry; define only current phase and ownership/promise decisions. | Control writes `tasks/phase-plan-<phase>.md`. | Light `2→3` verifies the phase plan, not task.md. | Signal: plan exists and goal/gates pass. |
| 4 | Stage 3 Execute | Plan is present. For each execution worker: make-prompt writes task.md → Law 2 checks task.md → dispatch reads packet → worker writes output/report. | Control owns task.md; assigned worker owns output/report body and optional raw notes. | Light `3→4` verifies output.md + report.md + Result after all required tasks land. | Signal: no task read/check before its creator; no dispatch before packet. |
| 5 | Stage 4 Verify | Target report exists with four explicit fields. Optional reviewer/audit dispatch repeats make-prompt → packet gate inside Verify and lands its own run. Control derives C01 and writes final Review Result/Registry intake. | Reviewer/audit worker owns its run output/report body; control owns all Review Result subsections and Registry writes. | Full periodic home when due; light `4→5` verifies every required Review Result. Full scan does not replace the transition result. | Signal: no context-only audit, no reviewer Registry write, no recursive reviewer required for control’s final decision. |
| 6 | Stage 5 Integrate | All task/audit Review Results filled. Integrate only accepted/accepted-with-risk work. | Control writes project_state, decisions, Registry; performs mandatory compaction or records threshold-not-met. | Light `5→6` verifies state/Registry/compaction exit artifacts. | Signal: unresolved risks preserved; no unreviewed truth enters state. |
| 7 | Stage 6 Close | Integrate exit gate passes. | Control writes archive entry and archives/discards raw material per policy. Project Fold does not run here automatically. | Close verifies its exit conditions; the next request starts a new side-effect-free Stage 0. | Signal: archive exists, all Review Results/state updates present, user receives compressed outcome. |

### Ownership matrix

| Durable artifact | Canonical path/region | Durable writer | Writer count | Non-writers |
|---|---|---|---:|---|
| Task/review/audit packet | `runs/<RUN>/task.md` | control | 1 | all workers read-only |
| Execution worker output/report | `runs/<TASK>/output.md`, optional `raw-notes.md`, and `report.md` body excluding Review Result | assigned execution worker | 1 | reviewer/audit/control do not rewrite evidence body |
| Review verdict proposal | dedicated reviewer run `output.md` + Evidence `report.md` body | reviewer worker | 1 | control reads; target worker/audit do not write |
| Review Result | target/reviewer/audit `report.md` Review Result subsection | control | 1 | every worker leaves it blank |
| Audit output/report | `runs/<AUDIT>/output.md`, optional `raw-notes.md`, and `report.md` body excluding Review Result | audit worker | 1 | reviewer/control do not rewrite evidence body |
| Registry / integration truth | project `project_state.md` Registry and `decisions.md`; root `task_board.md` | control | 1 | all workers propose only in own output/report |
| Archive / fold | project archive entries and post-triage namespace moves | control | 1 | no worker/reviewer/audit write |

Writer uniqueness recount: 7 artifact rows, each `Writer count=1`; anomalies = 0. Physical `report.md` is section-partitioned: worker owns the evidence body, control owns only Review Result; P3 must enforce and test that boundary.

### Runtime capability matrix

| Dimension | Values | Protocol requirement | Recording rule |
|---|---|---|---|
| Independent sub-agent availability | `yes|no|unknown` | `yes` is mandatory for full Enloom; `no/unknown` halts before writes (C12). | Record preflight source; do not infer from skill loading. |
| Concurrent dispatch capability | `yes|no|unknown` | Optional; does not gate full Enloom. | Record host capability separately from phase strategy. |
| Actual concurrency | `serial|concurrent|mixed|unknown` | No required value; truthfully describe this run. | Require runtime-native evidence or overlap timestamps for `concurrent`; otherwise `unknown/serial` as observed. |
| Model/session diversity | `same|different|mixed|unknown` | Optional evidence strength, not isolation proof. | Record only known model/session relationship; unknown remains unknown. |

### Namespace resolver examples

| Case | task_board row | Candidate state | Unique result |
|---|---|---|---|
| N01 active | one row: `project=alpha`, `created=2026-07-01` | active exists; archive absent | resolve `.enloom/2026-07-01-alpha/` |
| N02 folded closed | same unique row, `phase=closed` | active absent; archive exists | resolve `.enloom/archive/2026-07-01-alpha/` read-only unless reopen requested |
| N03 reopen same-name | same N02 row; user requests reopen | archive exists only | control moves exact directory to active, preserves `created`, updates same row `updated/phase`, then resolves active; creates no row/directory duplicate |

Negative resolver signals (part of C10 verification, not extra examples): duplicate rows, both candidates, neither candidate with row, or orphan directory without row each produce one named blocking error and MUST NOT pick/create a project.

### Validation decision table

| Path | Capability / promise | Allowed success | Failure behavior |
|---|---|---|---|
| V01 full official-capable | A currently available YAML-capable validator is shown to execute all documented frontmatter rules. | Exit 0 may mean the full contract passed; evidence lists validator/version and rule coverage. | Tool absent/execution error/rule gap → no full verdict; halt or explicitly choose V02 for a supported flat input. Invalid input → non-zero with failing rule. |
| V02 flat fallback | No dependency; supports only declared unindented single-line flat scalar subset and its implemented rules. | Exit 0 means only “flat subset valid,” never full YAML-contract equivalence. | Nested/multiline/type-sensitive/out-of-subset input → non-zero `UNSUPPORTED`; detected subset violation → non-zero `INVALID`; MUST NOT install dependencies or guess. |

## P1–P6 Dependency Graph

| Phase | Phase goal | Prerequisite rules | Owner file set | Exit verification | Blocked-by |
|---|---|---|---|---|---|
| P1 | Make Evidence fields, verdict, and review conclusion one total contract. | C01, C02 (frozen by P0) | `references/evidence-contract.md`, checklist/workflow consumers, worker/audit templates, role assets | Run E01–E08 against every consumer; zero divergent verdict/conclusion; regrade frozen dogfood without edits. | P0 matrix/review not accepted; any unresolved C01/C02 ambiguity. |
| P2 | Remove lifecycle/dispatch/fold cycles and make transition gates executable. | C01–C04, C06 | `references/landing-contract.md`, `workflow-steps.md`, `archive-policy.md`, SKILL/glossary/AGENTS consumers | Empty-run trace, direct/light/enloom fold trace, five transition checks; zero lifecycle cycles/pre-triage writes. | P1 not accepted; any unresolved Stage 3 or fold ordering cycle. |
| P3 | Freeze durable ownership, runtime truth records, and role asset loading. | C01–C04, C06–C09 (C05 remains P5-only) | landing/scheduler owners, registry/checklist, task/audit/report templates, SKILL role route, prompt assets | Instantiate execution/reviewer/audit runs; writer count=1; five-role marker test; capability/actual fields not inferred. | P2 not accepted; reviewer proposal creates recursive or context-only landing. |
| P4 | Make namespace, validation, and mechanical references deterministic. | C07, C10, C11, C13 | task-board/archive/workflow/SKILL namespace consumers; `validation.md`; AGENTS + two templates | N01–N03 + four negative resolver cases; V01/V02 fixtures; malformed-link count 0; installed parity after source sync. | P3 not accepted; no executable full validator for any claimed full-path test. |
| P5 | Align naming, compatibility metadata/prose, trigger evidence gate, and install docs after behavior stabilizes. | C04, C05, C08, C11, C12, C14; F-D7-02 remains evidence-only | SKILL frontmatter/compatibility/role summary, trigger contract, README/PROGRESS/glossary/workflow wording, validation owner | One-plus-six terminology count; subagent yes/no preflight with zero-write halt before post-decision fold; documented install replay; host-native trigger evidence before any description diff. | P4 not accepted; metadata syntax/tooling unverified; trigger evidence absent (blocks description edit, not other P5 text). |
| P6 | Dogfood the frozen contracts, compare old fixtures, sync source/installed copy, and close/release. | All C01–C14 implemented; F-D7-02 evidence disposition explicit | live source/root release files, installed copy, new dogfood run artifacts, project Registry/archive | Real task passes Evidence/lifecycle/ownership/namespace/validation gates; old three reports regraded; `diff -qr` empty; no open high risk; archive closure passes. | Any P1–P5 phase not accepted; source/installed drift; high Registry risk; dogfood gate failure. |

## Adversarial Review Handoff

T-P0-03 must actively challenge, not merely recount:

1. C01: whether every failed required check versus medium defect is classifiable from a packet without reviewer discretion, and whether `FAIL→needs-rework|rejected` is truly determined by repairability/usability.
2. C02: whether a structural limitation that blocks a required check is forced into `Not Checked` through the check ID rather than allowed to hide only in Known Blind Spots.
3. C03/C07: whether Stage 4 reviewer/audit dispatch can use a local packet gate without reintroducing a stage loop or infinite reviewer-of-review chain.
4. C07: whether section-level ownership of one physical `report.md` is executable under file-level Writable/Forbidden lists; if not, require a separate control-owned review-result artifact rather than accepting dual file ownership.
5. C04/C10: whether post-decision fold can resolve/move projects before Orient without using an unowned namespace state, and whether move failure leaves a deterministic block.
6. C06: whether full periodic homes and five light transition invocations are both represented in SKILL/README indexes without implying health-check auto-fixes.
7. C08/C12: whether independent sub-agent availability is the only universal hard capability and whether `unknown` really halts before every `.enloom` mutation.
8. C09: whether packet-only integrator/tester is a deliberate route rather than an absent asset, and whether marker verification observes the actual host prompt instead of a constructed prompt surrogate.
9. C10: duplicate row, both-root, neither-root, and orphan cases must each have one blocking outcome; “first path wins” is a hidden failure.
10. C11: `UNSUPPORTED` versus `INVALID` must be mechanically distinguishable; an unavailable “official” validator cannot be treated as evidence that fallback equals the full contract.
11. C05/P5 ordering: delaying broad naming edits must not let P2 write new contradictory six/seven prose.
12. F-D7-02 and F-D8-02: verify they remain evidence-gap/no-live-change, not smuggled into implementation scope.
13. C13/C14: verify the link grep and future install command are executable on the target environment; P0 establishes no installer command.
14. Recompute all 17/8/14/8/7/7/3/2/6 counts, rule field completeness, owner uniqueness, and phase mapping directly from this file.

## Rework Amendment

This amendment is append-only. It preserves the original matrix and the T-P0-03 `FAIL / needs-rework` as historical evidence. Where wording conflicts, the rules below supersede the original C01/C02/C03/C04/C07/C10 clauses and the affected fixtures; unchanged canonical IDs, finding mappings, D006 dispositions, and landing phases remain in force. P0 is still not accepted until control reviews this amendment.

### RA1 — C01/C02 total decision function

#### Packet and report contract

Before dispatch, control MUST freeze one `required_check_spec` row per packet-required check. The worker MUST return one `required_check_status` row for exactly the same ID set.

| Artifact | Required fields | Rule |
|---|---|---|
| packet `required_check_spec` | `check_id` (unique), `on_fail=FAIL|ISSUES`, `ac_refs` (possibly `none`), optional `count_claim_refs` | `on_fail=FAIL` whenever failure violates an original AC, is high severity, or makes output unsafe/unusable/wrong-direction; otherwise `ISSUES`. The worker/reviewer MUST NOT change it after dispatch. |
| report `required_check_status` | `check_id`, `run_state=run|not-run`, `outcome=pass|fail|not-run`, `evidence_ref|none` | Control set-diffs against the packet. Missing/duplicate/extra IDs are `STATUS_INVALID`; a missing required ID is also treated as `not-run`. |
| report `Known Blind Spots` row | `limitation_id`, `blocks_check_ids=[]|[IDs]`, `reason`, `risk` | Any non-empty `blocks_check_ids` MUST name matching `not-run` status rows and the same IDs in `Not Checked`. Only `blocks_check_ids=[]` can coexist with PASS. |
| control `issue_status` | `issue_id`, `ac_violation=yes|no`, `safety=safe|unsafe`, `usability=usable|unusable`, `direction=aligned|wrong`, `repair_class=bounded|terminal|unknown`, evidence refs | `terminal` is mandatory for unsafe, unusable, wrong-direction, or no in-scope correction. `bounded` requires an exact correction inside the original Goal/Allowed/Writable scope and is forbidden when any terminal predicate is true. |

`Not Checked` is the projection of all required rows with `run_state=not-run`; worker prose cannot override the set-diff. A structural limitation may explain an omission in Known Blind Spots, but MUST NOT replace the omitted check ID.

#### Ordered verdict and conclusion table

Apply rows top-to-bottom; the first matching verdict row wins. Conclusion is then computed by the separate FAIL rule, so the same facts cannot select two conclusions.

| Order | Predicate | Verdict |
|---:|---|---|
| 1 | `STATUS_INVALID`; any required row `not-run`; any executed row has `evidence_ref=none`; any required report heading absent | `FAIL` |
| 2 | Any `issue_status` has a terminal predicate; any original AC is unmet/rewritten/waived; any check with `outcome=fail` and packet `on_fail=FAIL` | `FAIL` |
| 3 | No FAIL predicate, and any check has `outcome=fail,on_fail=ISSUES`; or an independently recounted claim differs but is not linked to an original AC/output-correctness requirement | `ISSUES` |
| 4 | All required rows are unique, `run/pass` with evidence; all AC pass; no issue/claim predicate above | `PASS` |

Conclusion mapping is mandatory: `PASS→accepted`; `ISSUES→accepted-with-risk`; `FAIL→rejected` iff any evidenced `issue_status.repair_class=terminal`, otherwise `FAIL→needs-rework` (`bounded` or `unknown`, where unknown requests missing evidence). An AC-linked/count-correctness mismatch is row 2 `FAIL`; a report-only claim drift is row 3 `ISSUES`. No numeric threshold substitutes for the pre-dispatch AC link.

#### Counterexample re-derivation

| Case | Normalized facts | Unique result |
|---|---|---|
| AR-01 required ID absent from report | missing status → `STATUS_INVALID` + `not-run`; no terminal issue | `FAIL / needs-rework` |
| AR-02 validator limitation blocks R2 | R2=`not-run`; R2 in Not Checked; blind spot `blocks_check_ids=[R2]` | `FAIL / needs-rework` |
| AR-03 structural limitation blocks no check | every required row `run/pass/evidence`; blind spot `blocks_check_ids=[]` | `PASS / accepted` |
| AR-04 medium non-AC defect | required rows pass; failed check has frozen `on_fail=ISSUES` | `ISSUES / accepted-with-risk` |
| AR-05 unsafe/unusable/wrong output | terminal issue evidenced | `FAIL / rejected` regardless of other omissions |
| AR-06 high but bounded AC failure | AC-linked check fails; repair class bounded | `FAIL / needs-rework` |
| AR-07 count mismatch violates original AC | claim has AC/count-correctness link | `FAIL / needs-rework` |
| AR-08 report-only count typo | no AC link; product checks pass | `ISSUES / accepted-with-risk` |

Verification: derive the packet ID set before reading report prose, compute set differences, then run AR-01–AR-08 through the ordered table. PASS signal: eight unique pairs exactly as listed and pairwise-disjoint first-match rows. FAIL signal: a blocked required check remains only a blind spot, a mismatch selects both FAIL/ISSUES, or a FAIL selects both conclusions.

Forbidden legacy wording/behavior: two-condition `PASS iff`; missing required ID accepted because `Not Checked: None`; structural limitation used instead of a check status; reviewer-chosen mismatch threshold; free-form “repairable?” without `repair_class` and terminal precedence; “typical” conclusion mapping.

### RA2 — C03/C07 non-recursive Verify-worker termination

`VERIFY_WORKER` is a named Stage 4 sub-state, not Stage 3 and not a return to Plan. Control owns every transition and is the normative finalizer, not an exception.

| State | Entry | Control/worker action | Single next state |
|---|---|---|---|
| `V0_TARGET_READY` | target `output.md` + four-field `report.md` exist | If no independent verification is required, control evaluates target; otherwise control writes verifier/audit `task.md` inside Stage 4. Packet-write failure stays V0 and blocks. | direct `V3_CONTROL_FINALIZED`, or `V1_VERIFY_PACKET_READY` |
| `V1_VERIFY_PACKET_READY` | verifier/audit `task.md` exists | Law 2 pre-dispatch gate checks that exact file; dispatch writes verifier/audit `output.md` + `report.md`. Missing worker artifacts stay V1/rework the same run; MUST NOT return Plan. | `V2_VERIFY_RUN_LANDED` |
| `V2_VERIFY_RUN_LANDED` | verifier/audit output/report exist | Control directly evaluates this run, writes its `review-result.md`, then evaluates the target using the proposal/evidence and writes target `review-result.md`. Insufficient verifier evidence yields control-authored FAIL results; it MUST NOT dispatch reviewer-of-review. | `V3_CONTROL_FINALIZED` |
| `V3_CONTROL_FINALIZED` | target `review-result.md` exists and every Verify-worker run has its own `review-result.md` | Stage 4 exit gate runs. | Stage 5 or blocked on explicit result |

Pure audit uses the same V0→V1→V2→V3 path. Its packet MUST declare worker-owned output/report paths and the separate control result path. Control direct finalization is the normal Stage 4 terminal transition for execution, reviewer, and audit runs; no run creates an obligation for another reviewer.

Verification: trace (a) direct control review, (b) one reviewer, and (c) one pure audit from empty verifier directories. PASS signal: packet precedes each dispatch; each trace reaches V3 in at most three forward transitions; zero Plan edges and zero reviewer-of-review edges. FAIL signal: any verifier report creates another Verify worker requirement or any context-only return satisfies a gate.

Forbidden legacy wording/behavior: unnamed “local handshake”; Stage 4 packet absence sends control to Plan; reviewer/audit report requires another reviewer; control finalization described as an exemption; context-only verdict/counts as durable completion.

### RA3 — C07 file-level artifact split

Section-level dual writing is superseded. `report.md` is entirely worker-owned; `review-result.md` is entirely control-owned. Future worker-report templates MUST remove the Review Result subsection and link to the sibling result artifact.

| Durable artifact | Canonical path | Sole writer | Writer count |
|---|---|---|---:|
| Task/review/audit packet | `runs/<RUN>/task.md` | control | 1 |
| Execution output/evidence report | `runs/<TASK>/output.md`, optional `raw-notes.md`, `report.md` | assigned execution worker | 1 |
| Review proposal/evidence | reviewer run `output.md`, optional `raw-notes.md`, `report.md` | reviewer worker | 1 |
| Review Result | `runs/<RUN>/review-result.md` | control | 1 |
| Audit output/evidence report | audit run `output.md`, optional `raw-notes.md`, `report.md` | audit worker | 1 |
| Registry/integration truth | project `project_state.md`, Registry, `decisions.md`, root `task_board.md` | control | 1 |
| Archive/fold transaction | project archive entries and namespace move state/actions | control | 1 |

Canonical run join: `task.md + output.md + report.md + review-result.md`; `raw-notes.md` is optional. Stage 3 exit requires output/report. Stage 4 entry requires the four-field report. Stage 4 exit requires target and all Verify-worker `review-result.md` files. Stage 5 entry and Close/archive gates inspect `review-result.md`, never a report subsection.

Every ordinary/reviewer/audit packet MUST list `report.md` in worker Writable Files and `review-result.md` in Forbidden Files; it MUST declare worker output/report paths plus `Control Review Result Path: runs/<RUN>/review-result.md`. Pure audit may not omit these fields. Reviewer/audit Registry entries remain proposals in their own output/report; only control integrates them.

Verification: turn every Writable/Forbidden entry into physical-path sets. PASS signal: pairwise writer intersections are empty, all seven writer counts equal 1, every completed run has the four-file join, and no `## Review Result` remains in worker `report.md`. FAIL signal: any section-level ownership, missing audit path, or report-only archive gate.

Forbidden legacy wording/behavior: “report body excluding Review Result”; blank Review Result left for control inside worker report; two writers on one physical file; archive checks `report.md` subsection; reviewer writes target report/Registry.

### RA4 — C04/C10 resolver precedence and move recovery

The resolver returns exactly one enum by the following precedence. Let `rows` be matching task_board rows, `A` active candidate exists, `R` archive candidate exists. Operation intent (`lookup|fold|reopen`) MUST NOT bypass an error.

| Precedence | Predicate | Resolver result | Effect |
|---:|---|---|---|
| 1 | non-complete `.enloom/fold-move-state.md`, failed move, or post-state differs from recorded intent | `FOLD_MOVE_PARTIAL` | hard block Orient/fold/reopen; enter recovery only |
| 2 | `rows > 1` | `PROJECT_DUPLICATE_ROW` | hard block; roots are not selected |
| 3 | `rows = 0` and `(A or R)` | `PROJECT_ORPHAN_ROOT` | hard block creation; report both candidate paths |
| 4 | `rows = 1` and `A and R` | `PROJECT_BOTH_ROOTS` | hard block before any move, including reopen |
| 5 | `rows = 1` and `not A` and `not R` | `PROJECT_MISSING_ROOT` | hard block; MUST NOT create a same-name project |
| 6 | `rows = 0` and `not A` and `not R` | `PROJECT_NEW` | create exactly one row/directory after normal gates |
| 7 | `rows = 1` and `A xor R` | `PROJECT_ACTIVE` or `PROJECT_FOLDED` | resolve the sole path; reopen only from FOLDED, fold only from ACTIVE + closed/threshold predicates |

Before the first fold/reopen move, control MUST write `.enloom/fold-move-state.md` with operation ID, action, ordered targets, matching row identity, active/archive pre-snapshot, intended post-state, and `status=prepared`. After every move it updates completed targets and verifies the two candidates. Any non-zero move, unexpected candidate state, or interrupted non-complete marker MUST immediately set/resolve as `FOLD_MOVE_PARTIAL`, stop the batch, and block Orient. No later row is moved.

Recovery is control-owned and explicit: compare the durable snapshot, choose either restore the exact pre-state or finish the recorded intended state, verify every row has one candidate, record evidence, then clear the marker. Until this succeeds the precedence table always returns `FOLD_MOVE_PARTIAL`; no automatic first-path choice or silent retry is allowed.

Verification: enumerate `rows={0,1,2}`, `A/R={00,01,10,11}` plus marker `{none,non-complete}`, then apply precedence; separately simulate failure after one successful batch move. PASS signal: every input selects one enum, marker always wins, failed batch stops immediately and Orient remains blocked until verified recovery. FAIL signal: multiple/no enums, intent overrides error, first-path wins, or move continues after failure.

Forbidden legacy wording/behavior: unnamed “blocking error”; resolver checks active before archive and accepts first match; reopen overrides both-root; no pre-move snapshot; best-effort continue/automatic retry/implicit rollback after move failure; Orient proceeds with a non-complete marker.

### Non-blocking amendments absorbed

| Rule | Effective amendment | Future acceptance / forbidden behavior |
|---|---|---|
| C05 | P2 MUST apply a phrase guard to every added/changed lifecycle sentence: “Stage 0 Triage + six-stage lifecycle (Stages 1–6).” P5 still owns broad cleanup. | P2 diff check rejects new unqualified “six stages / 6 阶段 / 六阶段”; C05 remains P5-only for repository-wide cleanup. |
| C08/C12 | Hard/soft unknown policy: `independent_subagent=no|unknown` is the sole hard halt before any `.enloom` write; `concurrent_dispatch`, `actual_concurrency`, and `model_session_diversity` unknowns are soft records and MUST NOT block or be inferred. After hard preflight=`yes`, control copies its evidence into every phase plan/task packet; every dispatch gate validates the frozen `yes`. | Forbidden: “all unknowns block,” capability implies actual, or a packet lacks the preflight record. |
| C09 | Packet construction proves only static routing. P3 acceptance requires host-native evidence from the worker-received prompt or runtime dispatch record, including explicit `packet-only` for integrator/tester. If unavailable, status is `ROLE_ROUTE_EVIDENCE_GAP`, not PASS. | Forbidden: generated packet marker presented as host dispatch proof. |
| C11 | V01 enum is `FULL_VALID|FULL_INVALID|FULL_VALIDATOR_UNAVAILABLE|FULL_RULE_GAP|FULL_EXECUTION_ERROR`; only control selects V02, and only for a declared flat-subset input when full validation is not required. V02 remains `FLAT_VALID|FLAT_INVALID|FLAT_UNSUPPORTED`. | Unavailable/rule-gap/error can never become full PASS; fallback selection and result are named. |
| C13 | Unique owner moves from `AGENTS.md` to `enloom-skill/references/validation.md` §Markdown Reference Integrity (planned). AGENTS becomes a style consumer; the two templates remain repair consumers. | Forbidden: developer guidance as runtime validation SSOT; `§` inside link target. Landing phase remains P4. |
| C14 | Installer invocation remains unknown until P5 executes a supported command and parity check. | Evidence gap, not permission to invent a command in P0. |
| F-D7-02 / F-D8-02 | Trigger quality remains `deferred-evidence`; inline-code pseudo-link remains `no-live-change`. | Neither may be promoted to a live defect by this amendment. |

Hard/soft runtime policy table:

| Dimension | `unknown` policy | Propagation |
|---|---|---|
| independent sub-agent availability | hard halt before task_board creation/update, fold marker/move, project state, packet, or any other `.enloom` write | only evidenced `yes` is copied into phase plan and every task packet |
| concurrent dispatch capability | soft; record unknown and use serial-safe scheduling | phase/runtime record, never a compatibility gate |
| actual concurrency | soft; record `unknown` until runtime observation, then actual value | report only; never inferred from strategy/capability |
| model/session diversity | soft; record unknown as an honest limitation | report/blind spot only; never isolation proof |

### T-P0-03 counterexample closure

| Counterexample | Closure in this amendment | Status |
|---|---|---|
| CE-01 | Packet/report ID set-diff normalizes missing R2 to `STATUS_INVALID/not-run`. | closed by RA1 |
| CE-02 | `blocks_check_ids` must project into Not Checked/status; non-empty cannot PASS. | closed by RA1 |
| CE-03 | Named V0→V1→V2→V3 state stays inside Verify and never returns Plan. | closed by RA2 |
| CE-04 | Control finalization is the normative V2→V3 edge; reviewer-of-review forbidden. | closed by RA2/RA3 |
| CE-05 | Durable snapshot + `FOLD_MOVE_PARTIAL` wins precedence and blocks Orient. | closed by RA4 |
| CE-06 | `report.md` and `review-result.md` have separate file-level writers. | closed by RA3 |
| CE-07 | Independent unknown hard-stops; the other three unknowns are explicitly soft. | closed by runtime amendment |
| CE-08 | Host-native prompt/dispatch evidence is future acceptance; absence is named evidence gap. | deferred, nonblocking by C09 amendment |
| CE-09 | `PROJECT_BOTH_ROOTS` precedes reopen intent. | closed by RA4 |
| CE-10 | Partial→duplicate→orphan→both→missing precedence selects one enum. | closed by RA4 |
| CE-11 | P2 phrase guard applies before P5 broad cleanup. | closed by C05 amendment |
| CE-12 | C06 remains coherent statically; runtime transition trace stays future evidence. | deferred, nonblocking |
| CE-13 | V01 unavailable/rule-gap/execution statuses and V02 selector are named. | closed by C11 amendment |
| CE-14 | C13 owner moved to validation; C14 command remains unknown evidence gap. | closed/deferred as specified |

### Rework count preservation and verification

- Effective canonical IDs remain exactly C01–C14: `14`; no new canonical heading was created.
- Finding Coverage remains the same accepted 17-ID set; F-D7-02 is still deferred and F-D8-02 still no-live-change.
- D006 remains exactly 8 adjudications; RA1–RA4 sharpen D006-2/3/4/5/6/7/8 without reverting disposition.
- Original required count sequence remains `14/17/8/8/7/7/3/2/6`; the effective ownership writer table is still 7 rows and now has file-level intersections `0`.
- Rework additions: 8 totality re-derivations, 4 Verify states, 8 resolver enum outcomes (3 success + 5 named errors), 4 runtime dimensions, 14 counterexample closure rows.
- Rework PASS signal: all four high blockers have a revised rule, concrete counterexample closure, unique verification, and forbidden legacy list; original 349 lines and T-P0-03 FAIL remain byte-for-byte preserved. Rework FAIL signal: any old prefix changes, any high blocker still multi-valued/recursive/dual-writer/unnamed, or any required compact count changes.

## Rework Amendment 2

This second amendment is also append-only. The original 349-line matrix, the complete first amendment through line 508, and both T-P0-03 `FAIL / needs-rework` findings remain historical evidence. Where it conflicts, RA1.2 supersedes RA1 status-tuple validation and RA4.2 supersedes RA4 success-row operation handling; RA2/RA3 and all other first-amendment clauses remain unchanged.

### RA1.2 — Status tuple cross-field totality

Before the ordered verdict table, control MUST normalize `evidence_ref` to `present|none` (`present` means a non-empty resolvable reference; missing, empty, or null means `none`) and validate every required-check status as one indivisible tuple. The only schema-valid tuples are:

1. `run | pass | present`
2. `run | fail | present`
3. `not-run | not-run | none`

Any value outside the declared enums, or any other cross-field combination, is `STATUS_INVALID`. `STATUS_INVALID` is evaluated before every RA1 verdict predicate and selects `FAIL`; the conclusion remains RA1’s terminal-precedence mapping (`rejected` only when separate evidenced terminal issue facts exist, otherwise `needs-rework`). A schema-valid `not-run|not-run|none` is not invalid but still selects RA1 row 1 `FAIL / needs-rework` because a required check did not run.

#### Exhaustive normalized tuple table

| `run_state` | `outcome` | evidence | Tuple result | Decision entry |
|---|---|---|---|---|
| run | pass | present | valid | continue to later RA1 predicates |
| run | pass | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| run | fail | present | valid | apply frozen packet `on_fail` and later RA1 predicates |
| run | fail | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| run | not-run | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| run | not-run | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | pass | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | pass | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | fail | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | fail | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | not-run | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | not-run | none | valid required omission | RA1 row 1 `FAIL / needs-rework` |

Unknown/missing `run_state` or `outcome` values are outside the enum and therefore `STATUS_INVALID`; no default value is inferred. ID-set errors (missing/duplicate/extra status rows) remain `STATUS_INVALID` under RA1. Tuple validation occurs per row before ID-set projection, blind-spot projection, `on_fail`, claim-mismatch, or PASS evaluation.

Verification: enumerate the full `2×3×2` normalized table plus one out-of-enum value for each field. PASS signal: exactly three tuples are schema-valid; the only valid not-run tuple still produces required-omission FAIL; all nine malformed tuples and all out-of-enum cases select `STATUS_INVALID→FAIL`; zero combinations fall through. FAIL signal: `run|not-run|present`, any dual, or any unknown enum reaches a later verdict row.

Forbidden legacy wording/behavior: validating `run_state`, `outcome`, and evidence independently; allowing `run|not-run|present` to match no rule; inferring `outcome` from `run_state`; treating evidence presence as sufficient for a contradictory tuple; applying `on_fail` before tuple validity.

### RA4.2 — Operation-intent precedence and effects

RA4 namespace/transaction errors keep precedence 1–5: `FOLD_MOVE_PARTIAL`, duplicate row, orphan root, both roots, missing root. Only after those predicates are false may control classify the base shape as `PROJECT_NEW`, `PROJECT_ACTIVE`, or `PROJECT_FOLDED`; before returning that success enum it MUST validate operation intent. Any undeclared intent or invalid base-shape/intent/predicate combination returns `PROJECT_OPERATION_INVALID`, hard-blocks the requested operation/Orient transition, and performs no snapshot write and no move.

| Base shape after error checks | `lookup` | `fold` | `reopen` |
|---|---|---|---|
| `PROJECT_NEW` (`rows=0,A=0,R=0`) | `PROJECT_NEW + ALLOW_CREATE_AFTER_NORMAL_GATES` | `PROJECT_OPERATION_INVALID + MOVE_REQUIRES_EXISTING_PROJECT` | `PROJECT_OPERATION_INVALID + MOVE_REQUIRES_EXISTING_PROJECT` |
| `PROJECT_ACTIVE`, `closed && threshold=true` | `PROJECT_ACTIVE + RESOLVE_ACTIVE` | `PROJECT_ACTIVE + ALLOW_FOLD` | `PROJECT_OPERATION_INVALID + REOPEN_REQUIRES_FOLDED` |
| `PROJECT_ACTIVE`, `closed && threshold=false` (either predicate false) | `PROJECT_ACTIVE + RESOLVE_ACTIVE` | `PROJECT_OPERATION_INVALID + FOLD_PREDICATE_FALSE` | `PROJECT_OPERATION_INVALID + REOPEN_REQUIRES_FOLDED` |
| `PROJECT_FOLDED` | `PROJECT_FOLDED + RESOLVE_ARCHIVE_READ_ONLY` | `PROJECT_OPERATION_INVALID + FOLD_REQUIRES_ACTIVE` | `PROJECT_FOLDED + ALLOW_REOPEN` |

An operation value outside `lookup|fold|reopen` returns `PROJECT_OPERATION_INVALID + UNKNOWN_OPERATION`. Existing error/marker precedence always wins over operation intent: for example, both-root + reopen returns `PROJECT_BOTH_ROOTS`, not operation-invalid; non-complete move marker + any intent returns `FOLD_MOVE_PARTIAL`. `ALLOW_FOLD` and `ALLOW_REOPEN` are the only effects that authorize RA4’s pre-move snapshot and move protocol. `PROJECT_OPERATION_INVALID` never creates/updates `.enloom/fold-move-state.md` and never mutates a root or task_board row.

#### Operation counterexample closure

| Case | Unique result/effect |
|---|---|
| active-only + reopen | `PROJECT_OPERATION_INVALID + REOPEN_REQUIRES_FOLDED`; no move |
| archive-only + fold | `PROJECT_OPERATION_INVALID + FOLD_REQUIRES_ACTIVE`; no move |
| active-only + fold + `closed=false` or `threshold=false` | `PROJECT_OPERATION_INVALID + FOLD_PREDICATE_FALSE`; no move |
| no row/root + fold or reopen | `PROJECT_OPERATION_INVALID + MOVE_REQUIRES_EXISTING_PROJECT`; no create/move |
| valid lookup on new/active/folded | retain respective success enum + explicit resolve/create effect |
| valid active closed/threshold fold | `PROJECT_ACTIVE + ALLOW_FOLD`; then RA4 snapshot/move protocol |
| valid folded reopen | `PROJECT_FOLDED + ALLOW_REOPEN`; then RA4 snapshot/move protocol |

Verification: first evaluate the existing five error predicates, then enumerate the `4×3` table above plus an unknown operation. PASS signal: every non-error input has exactly one result+effect; all required invalid cases select `PROJECT_OPERATION_INVALID` with zero writes/moves; three lookup shapes, eligible fold, and folded reopen retain their listed success enum/effect; injected namespace errors override intent. FAIL signal: active+reopen, folded+fold, ineligible active+fold, or new+fold/reopen reaches a success row or move protocol.

Forbidden legacy wording/behavior: returning `PROJECT_ACTIVE|PROJECT_FOLDED|PROJECT_NEW` before checking intent; prose-only “reopen/fold only” qualifiers; treating invalid reopen/fold as idempotent success; snapshot/move on `PROJECT_OPERATION_INVALID`; operation intent overriding partial/duplicate/orphan/both/missing errors.

### Rework-2 closure and count preservation

- Second recheck RA1 malformed tuple is closed by exhaustive tuple validation; second recheck RA4 illegal operation intents are closed by `PROJECT_OPERATION_INVALID` before success effects.
- RA2 non-recursive termination and RA3 physical split remain accepted as closed; no second amendment changes their states, paths, writers, or gates.
- Original compact sequence remains `14/17/8/8/7/7/3/2/6`; original finding/D006 sets and all 14 canonical IDs remain unchanged.
- Rework-2 additions: 12 normalized tuple rows (3 valid, 9 invalid), 4 operation base rows × 3 intents, 1 named operation error with 5 reason/effect codes, and 7 concrete operation closure cases.
- Rework-2 PASS signal: original 349-line prefix hash and first-amendment 508-line prefix hash are unchanged; first and second T-P0-03 FAIL evidence hashes are unchanged; tuple/intent tables are total and deterministic; forbidden/live boundaries remain clean. Next gate is another independent T-P0-03 recheck, not P1.

Notation clarification: the operation-table row labeled “`closed && threshold=false` (either predicate false)” means `NOT (closed && threshold)`—that is, `closed=false` OR `threshold=false` (or both); only `closed=true AND threshold=true` authorizes `ALLOW_FOLD`.
