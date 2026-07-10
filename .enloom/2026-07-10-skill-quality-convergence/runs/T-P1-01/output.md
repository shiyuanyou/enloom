# T-P1-01 — output.md

Rewritten file: `enloom-skill/references/evidence-contract.md`

## Verification Results (V01–V06)

| ID | Command | Result | Pass? |
|---|---|---|---|
| V01 | `rg 'if and only if\|当且仅当\|Typical review conclusion\|mapping is a default'` | zero hits (exit 1) | PASS |
| V02 | `rg -c 'required_check_spec\|required_check_status\|issue_status\|STATUS_INVALID\|repair_class'` | 22 (>= 5) | PASS |
| V03 | `rg 'blocks_check_ids'` | 5 hits (>= 1) | PASS |
| V04 | `rg -c 'run \| pass \| present\|run \| fail \| present\|not-run \| not-run \| none'` | 9 (>= 3) | PASS |
| V05 | `rg -c 'Verdict Decision Function'` | 5 (>= 1) | PASS |
| V06 | `wc -l` | 183 lines (in ~180–250 band) | PASS (informational) |

Countable outputs:
- RA1 schema terms introduced: 5 (`required_check_spec`, `required_check_status`, `issue_status`, `STATUS_INVALID`, `repair_class`).
- RA1.2 valid tuples: exactly 3 (`run | pass | present`, `run | fail | present`, `not-run | not-run | none`).
- AR counterexamples: exactly 8 (AR-01 through AR-08).
- STATUS_INVALID tuple rows in RA1.2 table: exactly 9.

## Change Summary

### Added

- **§Verdict Decision Function** (new section) — the single owner SSOT for verdict and conclusion logic (C01). Contains:
  - Packet/report contract: four-row schema table (`required_check_spec`, `required_check_status`, `Known Blind Spots` row, `issue_status`) with all required fields and rules, including the frozen `on_fail`, `STATUS_INVALID` on ID-set mismatch, `blocks_check_ids` projection, and `repair_class` terminal/bounded/unknown precedence.
  - **Status tuple totality (RA1.2)**: declares the 3 valid tuples and the 9 invalid ones (`STATUS_INVALID`), with the exhaustive 12-row normalized tuple table (3 valid + 9 invalid), and the rule that tuple validation precedes every verdict predicate.
  - **Ordered verdict table** (4 rows, first-match wins): row 1 STATUS_INVALID/not-run/empty-evidence/missing-heading → FAIL; row 2 terminal/AC-violation/on_fail=FAIL → FAIL; row 3 on_fail=ISSUES/claim-mismatch-not-AC → ISSUES; row 4 all-pass → PASS.
  - **Mandatory conclusion mapping**: PASS→accepted / ISSUES→accepted-with-risk / FAIL→rejected (if terminal) or needs-rework (if bounded or unknown).
  - **Counterexamples**: AR-01 through AR-08, each with normalized facts and a unique verdict/conclusion pair; includes the PASS/FAIL signal for re-derivation.

### Revised

- **§The Four Elements** (C02):
  - `Checks Run` now maps every executed required-check ID to outcome.
  - `Evidence` maps each executed ID to concrete proof.
  - `Not Checked` redefined: ONLY packet-declared required-check IDs not executed (or explicit `None`); blocks PASS. (Was: "declared blind spots".)
  - `Known Blind Spots` redefined: structural/runtime/out-of-scope limitations with a `blocks_check_ids` field. Empty array can coexist with PASS; non-empty must project to matching not-run IDs in Not Checked. (Was: "reasons for Not Checked items".)
  - Added the two explicit prohibitions: a structural limitation MUST NOT be placed in Not Checked; a required omission MUST NOT be softened into a blind spot.
- **§The Hard Constraint**: the old "`verdict = PASS` if and only if…" formula is replaced with a pointer to the §Verdict Decision Function as the complete and only formula. Keeps the spirit (no bare PASS without evidence) but defers the mechanism to the total function.
- **§Verdict vs Review Conclusion**: "The mapping is a default, not a rule" replaced with a mandatory mapping. The conclusion is determined by the RA1 conclusion rule, not a default the control agent may override.
- **§Three-State Verdict**: FAIL row updated to include `STATUS_INVALID`; closing sentence now points to §Verdict Decision Function for the exhaustive selection conditions. (§Three-State Verdict was kept but lightly aligned — removing "typical" language.)
- **§The Honest Blind Spots**: the cross-field reference corrected so the three blind spots are listed under Known Blind Spots (`blocks_check_ids=[]`) rather than Not Checked — consistent with the new C02 disjoint semantics. (Prose content of the three items unchanged.)

### Deleted (absent from final file)

- The old two-condition formula: `verdict = PASS` **if and only if** all declared checks have run and the evidence is non-empty.
- The phrases `Typical review conclusion` and `mapping is a default` (as formula/mapping statements).

### Preserved unchanged

- §The Fifth Dimension — Claim Consistency (byte-for-byte).
- §How the Contract Attaches to Work (minor: "applies the hard constraint" → "applies the Verdict Decision Function" only in the Verify-stage bullet, to keep the cross-reference live; structure and content otherwise unchanged).
- §脚本执行已知坑 (byte-for-byte).
- §The Honest Blind Spots (three blind-spot items byte-for-byte; only the one-line framing of which field they live in was aligned to C02).
- §See Also (byte-for-byte).

## Full Rewritten File Content

```markdown
# Evidence Contract

The dividing line: anything an agent can avoid by reading docs is **protocol**; anything you can only find by actually running a command and checking file-system state is **executable evidence**. The Evidence Contract governs the second kind. It verifies worker results; the task packet constrains worker behavior. The two are orthogonal.

## The Four Elements

Any worker that claims completion must produce all four. Missing any one blocks `PASS`. The four fields have **disjoint semantics** — required-check omissions and structural limitations are separate classes and MUST NOT be mixed.

1. **Checks Run** — maps every executed required-check ID to its outcome (`pass` / `fail`). Named explicitly.
2. **Evidence** — maps each executed required-check ID to concrete proof: command output / file path / citation. Not "trust me."
3. **Not Checked** — contains ONLY packet-declared required-check IDs that were not executed (or an explicit `None` when every declared check ran). A non-empty entry here **blocks `PASS`**.
4. **Known Blind Spots** — structural / runtime / out-of-scope limitations. Each row carries a `blocks_check_ids` field naming the required-check IDs it prevents (empty array when it blocks none). An empty `blocks_check_ids=[]` **may coexist with `PASS`**; a non-empty array MUST project to matching `not-run` IDs listed in Not Checked.

The distinction between elements 3 and 4 is load-bearing: element 3 names a *required omission*; element 4 names a *structural limitation*. A worker that silently skips a check (leaving Not Checked empty when it should not be) is worse than one that declares the skip.

Two prohibitions keep the fields disjoint:

- A **structural limitation MUST NOT be placed in `Not Checked`**. Not Checked is reserved for required-check IDs the packet declared and the worker did not run.
- A **required omission MUST NOT be softened into a blind spot.** If the packet declared a check and it did not run, its ID MUST appear in Not Checked regardless of whether a blind spot explains why.

A structural limitation may *explain* an omission in Known Blind Spots (via `blocks_check_ids`), but it MUST NOT *replace* the omitted check ID in Not Checked.

## The Fifth Dimension — Report-vs-Output Claim Consistency

The four elements cover "did the checks run + is the evidence non-empty," but leave a gap: a report can *claim* a countable quantity ("processed 107 entries", "12 checks passed", "5 files changed") that disagrees with the actual output file. The direction of the disagreement is not fixed — the report may under-count or over-count — so it cannot be calibrated away by a fudge factor. The four elements have no way to catch it, because the claim is written into the evidence section and the gate treats it as trusted.

**Dimension 5 — Claim Consistency.** For any countable output a worker's report asserts (entry counts, pass rates, file counts, coverage numbers), the Verify stage compares the **claimed** number against an **independent recount** of the actual output (`grep -c`, `awk` line-count, `git diff --stat`). A mismatch > 0 is logged as an ISSUES finding (not an automatic PASS) and registered in `## Broken References` if it points at a structural defect.

> **Claim Consistency (boundary statement).** In a multi-sub-agent runtime this dimension is a genuine cross-runtime check — one sub-agent recounts what another claimed. It catches *claim typos and drift* (the report says 107, the file has 130 — a real, common error), and also catches cross-context inconsistencies. **Systematic self-misreporting** is not defended against by this dimension — that line of defense lives in the Known Blind Spots (cross-role verification), not here. Name it "Claim Consistency," never "sub-agent count verification" — the latter overstates what can be verified.

This dimension attaches via the task packet's `Required Verification` → "Countable outputs" field (see [templates/task-packet.md](templates/task-packet.md)); it is **mandatory for `audited` mode** and optional otherwise.

## The Hard Constraint

This is the mechanization of law 4 (No PASS without Evidence): a bare `PASS` without non-empty evidence for every declared check is impossible.

The complete and only formula is the total **Verdict Decision Function** in the next section. In spirit: an agent that wants to conclude PASS can fill in plausible-looking sections while leaving the command output empty, so "non-empty evidence for every declared check" must be a checkable, binary fact — either the evidence field has content or it does not. The Decision Function makes that fact the first-match predicate that gates `PASS`.

## Verdict Decision Function

This section is the single owner SSOT for verdict and conclusion logic (C01). Control MUST derive exactly one verdict, then exactly one conclusion, from the packet and report schemas below. The function is **total**: every normalized input selects exactly one verdict row and one conclusion.

### Packet and report contract

Before dispatch, control MUST freeze one `required_check_spec` row per packet-required check. The worker MUST return one `required_check_status` row for exactly the same ID set. The worker/reviewer MUST NOT change `on_fail` after dispatch.

| Artifact | Required fields | Rule |
|---|---|---|
| packet `required_check_spec` | `check_id` (unique), `on_fail=FAIL\|ISSUES`, `ac_refs` (possibly `none`), optional `count_claim_refs` | `on_fail=FAIL` whenever failure violates an original AC, is high severity, or makes output unsafe/unusable/wrong-direction; otherwise `ISSUES`. |
| report `required_check_status` | `check_id`, `run_state=run\|not-run`, `outcome=pass\|fail\|not-run`, `evidence_ref\|none` | Control set-diffs against the packet. Missing/duplicate/extra IDs are `STATUS_INVALID`; a missing required ID is also treated as `not-run`. |
| report `Known Blind Spots` row | `limitation_id`, `blocks_check_ids=[]\|[IDs]`, `reason`, `risk` | Any non-empty `blocks_check_ids` MUST name matching `not-run` status rows and the same IDs in Not Checked. Only `blocks_check_ids=[]` can coexist with PASS. |
| control `issue_status` | `issue_id`, `ac_violation=yes\|no`, `safety=safe\|unsafe`, `usability=usable\|unusable`, `direction=aligned\|wrong`, `repair_class=bounded\|terminal\|unknown`, evidence refs | `terminal` is mandatory for unsafe, unusable, wrong-direction, or no in-scope correction. `bounded` requires an exact correction inside the original Goal/Allowed/Writable scope and is forbidden when any terminal predicate is true. |

`Not Checked` is the projection of all required rows with `run_state=not-run`; worker prose cannot override the set-diff.

### Status tuple totality (RA1.2)

Before the ordered verdict table, control MUST normalize `evidence_ref` to `present|none` (`present` means a non-empty resolvable reference; missing, empty, or null means `none`) and validate every required-check status as one indivisible tuple. The only schema-valid tuples are:

1. `run | pass | present`
2. `run | fail | present`
3. `not-run | not-run | none`

Any value outside the declared enums, or any other cross-field combination, is `STATUS_INVALID`. `STATUS_INVALID` is evaluated before every verdict predicate and selects `FAIL`. A schema-valid `not-run | not-run | none` is not invalid but still selects the required-omission `FAIL` because a required check did not run. Tuple validation occurs per row before ID-set projection, blind-spot projection, `on_fail`, claim-mismatch, or PASS evaluation.

#### Exhaustive normalized tuple table

| `run_state` | `outcome` | evidence | Tuple result | Decision entry |
|---|---|---|---|---|
| run | pass | present | valid | continue to later verdict predicates |
| run | pass | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| run | fail | present | valid | apply frozen packet `on_fail` and later verdict predicates |
| run | fail | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| run | not-run | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| run | not-run | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | pass | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | pass | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | fail | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | fail | none | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | not-run | present | `STATUS_INVALID` | `FAIL / needs-rework` absent separate terminal facts |
| not-run | not-run | none | valid required omission | required-omission `FAIL / needs-rework` |

Unknown/missing `run_state` or `outcome` values are outside the enum and therefore `STATUS_INVALID`; no default value is inferred. ID-set errors (missing/duplicate/extra status rows) remain `STATUS_INVALID`.

### Ordered verdict table

Apply rows top-to-bottom; the first matching verdict row wins. Conclusion is then computed by the separate conclusion rule, so the same facts cannot select two conclusions.

| Order | Predicate | Verdict |
|---:|---|---|
| 1 | `STATUS_INVALID`; any required row `not-run`; any executed row has `evidence_ref=none`; any required report heading absent | `FAIL` |
| 2 | Any `issue_status` has a terminal predicate; any original AC is unmet/rewritten/waived; any check with `outcome=fail` and packet `on_fail=FAIL` | `FAIL` |
| 3 | No FAIL predicate, and any check has `outcome=fail, on_fail=ISSUES`; or an independently recounted claim differs but is not linked to an original AC/output-correctness requirement | `ISSUES` |
| 4 | All required rows are unique, `run/pass` with evidence; all AC pass; no issue/claim predicate above | `PASS` |

### Mandatory conclusion mapping

The conclusion is determined by the verdict; it is not a default the control agent may override. Mapping:

| Verdict | Conclusion |
|---|---|
| `PASS` | `accepted` |
| `ISSUES` | `accepted-with-risk` |
| `FAIL` | `rejected` if any evidenced `issue_status.repair_class=terminal`; otherwise `needs-rework` (`bounded` or `unknown`, where `unknown` requests missing evidence) |

An AC-linked/count-correctness mismatch is row 2 `FAIL`; a report-only claim drift is row 3 `ISSUES`. No numeric threshold substitutes for the pre-dispatch AC link.

### Counterexamples

The ordered table must reproduce a unique verdict and conclusion for each case below. Derive the packet ID set before reading report prose, compute set differences, then run each case through the ordered table.

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

PASS signal: eight unique pairs exactly as listed and pairwise-disjoint first-match rows. FAIL signal: a blocked required check remains only a blind spot, a mismatch selects both FAIL/ISSUES, or a FAIL selects both conclusions.

## Three-State Verdict

Do not collapse to a binary. The middle state is load-bearing:

| Verdict | Meaning |
|---------|---------|
| `PASS` | All required checks ran, evidence complete, blind spots declared, no unexplained high-severity issue. |
| `ISSUES` | Defects present but workable — medium/low severity, logged in the Registry. The control agent may continue with known defects. |
| `FAIL` | High-severity unresolved / required check not run / evidence missing / `STATUS_INVALID`. |

The `ISSUES` middle state is what lets a control agent "proceed with known defects" — a real and necessary decision. A binary verdict forces an all-or-nothing stop: either pretend everything is fine, or halt entirely. `ISSUES` lets the orchestrator keep moving while the Registry carries the defect forward to a later fix. The conditions under which each verdict is selected are defined exhaustively by §Verdict Decision Function.

## Verdict vs. Review Conclusion

These are different layers; do not mix them (see [glossary.md](glossary.md)):

- **Verdict** (`PASS` / `ISSUES` / `FAIL`) is the mechanized judgment of the Verify stage — it answers "did the worker meet the Evidence Contract?"
- **Review conclusion** (`accepted` / `accepted-with-risk` / `needs-rework` / `rejected`) is the control agent's integration decision.

The mapping between verdict and conclusion is **mandatory**, determined by the conclusion rule in §Verdict Decision Function:

| Verdict | Conclusion |
|---------|-----------|
| `PASS` | `accepted` |
| `ISSUES` | `accepted-with-risk` (defects logged in Registry) |
| `FAIL` | `needs-rework` (when `repair_class=bounded` or `unknown`) or `rejected` (when `repair_class=terminal`) |

The control agent does not choose the conclusion freely; the verdict and the evidenced `repair_class` determine it. A `FAIL` separates `needs-rework` from `rejected` by whether the output is repairable within the original packet scope, not by reviewer preference.

## How the Contract Attaches to Work

- **Ordinary task packet** ([templates/task-packet.md](templates/task-packet.md)): the `Required Verification` field lists checks. The worker report ([templates/worker-report.md](templates/worker-report.md)) must answer each with the four elements.
- **Audit task packet** ([templates/audit-task-packet.md](templates/audit-task-packet.md)): the entire packet is a set of `check_item`s, each with a `command`, `pass_condition`, `fail_signal`, and `named_list`. The audit worker runs them and returns a verdict + named lists.
- **Verify stage**: the control agent applies the Verdict Decision Function. A report missing evidence for a declared check cannot be accepted, regardless of how confident the worker sounds.

## 脚本执行已知坑(Evidence Contract 抓症状,这里防根因)

Evidence Contract 的 gate 能抓到下游症状(闭集约束违规、链接缺失理由句),但有两类执行失败是 gate 抓不到的根因,且产物常**形式合规但语义错误**:

- **派生产物的链接/符号匹配用子串而非精确解析** → 虚高入度/假边,看着像合规的图实则是假数据。
- **批量脚本里「结构化精确改写」与「全局文本替换」并存,顺序错了** → 结构化改写全 miss,fallback 到"已处理",脚本报成功却啥也没干。

这两类是 Integrate 阶段和审计脚本的常见坑。完整机制 + 诊断信号见 [prompt-control.md §3 Script-Execution Pitfalls](prompt-control.md)。判别:产物看着合理但 top-N 高度节点 degree 远超真实 grep 计数 → 子串伪阳性;dry-run 结构化命中数 < 预期或 live 报"already processed" → 全局替换先吃了精确匹配串。

## The Honest Blind Spots

Enloom 要求 Stage 3 task dispatch 给独立 sub-agent;运行时无 sub-agent 能力时**中断**(不退化自执行)。但即使有独立 sub-agent,仍有一些多进程系统天然具备、单会话编排难以完全保证的可靠性属性——这些必须**声明而非隐藏**。worker 或 audit 把每一项列在 **Known Blind Spots** 下(`blocks_check_ids=[]`,因为它们 block no required check),一行说明。盲区共三项:

1. **Cross-worker real isolation — no independent runtime.** Worker isolation is enforced by packet field discipline (Writable / Forbidden), not by execution isolation. There is no independent subagent runtime to verify a worker did not touch forbidden files.
2. **Cross-role verification — verdict / review may share model or session.** Even when worker and reviewer are separate sub-agents, they may run on the same model or be spawned within one session. Independent reasoning-chain verification (a genuinely fresh re-derivation) is **not guaranteed**. A PASS is stronger evidence when reviewer and worker differ in model or session than when they are closely coupled. This fills the gap left by cross-worker isolation alone — isolation covers "did it touch forbidden files," this covers "is the verdict independently re-derived."
3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** Even with every task dispatched to an independent sub-agent, the control agent spawns them sequentially within one session — so a phase-plan may declare `parallel` with a full Ownership Table without runtime concurrency actually occurring (`scheduler-rules.md` "并行调度的真实时序"). The Ownership Table still has value — it makes the intended ownership explicit and is what a truly concurrent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened. The empirical basis is `scheduler-rules.md` itself — it admits the sequential spawn, and surfacing it here as a named blind spot keeps it visible rather than buried in the rules.

These do not make Enloom weaker — they make it honest. A control agent that proceeds knowing these limits makes better decisions than one that assumes process isolation, independent review, and real concurrency are guaranteed.

## See Also

- [templates/worker-report.md](templates/worker-report.md) — the report shape aligned to the four elements.
- [templates/audit-task-packet.md](templates/audit-task-packet.md) — the packet specialized for verification.
- [review-checklist.md](review-checklist.md) — the gates that enforce this contract at Verify.
```
