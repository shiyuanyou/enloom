# Evidence Contract

This is the hardest lesson internalized from a real large-scale task: an audit run that reported all-PASS nonetheless left 16+ broken references in the product. The root cause was that the audit template relied on structure to indirectly prevent evidence-free PASS — every check bound a command, but nothing explicitly forbade a PASS with no evidence. Enloom writes that rule down explicitly here.

The dividing line: anything an agent can avoid by reading docs is **protocol**; anything you can only find by actually running a command and checking file-system state is **executable evidence**. The Evidence Contract governs the second kind. It verifies worker results; the task packet constrains worker behavior. The two are orthogonal.

## The Four Elements

Any worker that claims completion must produce all four. Missing any one blocks `PASS`.

1. **Checks Run** — which verifications were executed, named explicitly.
2. **Evidence** — the proof for each check: command output / file path / citation. Not "trust me."
3. **Not Checked** — which verifications should have run but did not. Declared blind spots, explicitly, not hidden.
4. **Known Blind Spots** — for each Not Checked item: why it was not checked, and how large the risk is.

The distinction between elements 3 and 4 matters: element 3 names the gap, element 4 sizes the risk. A worker that silently skips a check (leaving element 3 empty when it should not be) is worse than one that declares the skip and explains it.

## The Fifth Dimension — Report-vs-Output Claim Consistency (v0.5)

The four elements cover "did the checks run + is the evidence non-empty," but leave a gap: a report can *claim* a countable quantity ("processed 107 entries", "12 checks passed", "5 files changed") that disagrees with the actual output file. The direction of the disagreement is not fixed — the report may under-count or over-count — so it cannot be calibrated away by a fudge factor. The four elements have no way to catch it, because the claim is written into the evidence section and the gate treats it as trusted.

**Dimension 5 — Claim Consistency.** For any countable output a worker's report asserts (entry counts, pass rates, file counts, coverage numbers), the Verify stage compares the **claimed** number against an **independent recount** of the actual output (`grep -c`, `awk` line-count, `git diff --stat`). A mismatch > 0 is logged as an ISSUES finding (not an automatic PASS) and registered in `## Broken References` if it points at a structural defect.

> **Single-agent degradation (boundary statement).** In a multi-sub-agent runtime this dimension is a genuine cross-runtime check — one process recounts what another process claimed. In single-agent mode (the current default — see `scheduler-rules.md` "单 agent 会话的现实") it degrades to "the agent recounts its own output file." That still catches *claim typos and drift* (the report says 107, the file has 130 — a real, common error), but it does **not** defend against systematic self-misreporting, because the counter and the claimer share one context. Systematic misreporting is covered instead by the Known Blind Spots (cross-role verification), not by this dimension. Name it "Claim Consistency," never "sub-agent count verification" — the latter overstates what single-agent mode can verify.

This dimension attaches via the task packet's `Required Verification` → "Countable outputs" field (see [templates/task-packet.md](templates/task-packet.md)); it is **mandatory for `audited` mode** and optional otherwise.

## The Hard Constraint

This is the mechanization of law 4 (No PASS without Evidence):

> `verdict = PASS` **if and only if** all declared checks have run and the evidence is non-empty.
>
> Any declared check marked `NOT RUN` → verdict cannot be PASS.
>
> Any high-severity issue left unexplained → verdict cannot be PASS.
>
> A bare PASS without evidence auto-downgrades to `FAIL` / `needs-rework`.

Why explicit, when a structure already implies it: structure is a nudge, not a gate. An agent that wants to conclude PASS can fill in plausible-looking sections while leaving the command output empty. The hard constraint makes "non-empty evidence for every declared check" a checkable, binary fact — either the evidence field has content or it does not.

## Three-State Verdict

Do not collapse to a binary. The middle state is load-bearing:

| Verdict | Meaning |
|---------|---------|
| `PASS` | All required checks ran, evidence complete, blind spots declared, no unexplained high-severity issue. |
| `ISSUES` | Defects present but workable — medium/low severity, logged in the Registry. The control agent may continue with known defects. |
| `FAIL` | High-severity unresolved / required check not run / evidence missing. |

The `ISSUES` middle state is what lets a control agent "proceed with known defects" — a real and necessary decision. A binary verdict forces an all-or-nothing stop: either pretend everything is fine, or halt entirely. `ISSUES` lets the orchestrator keep moving while the Registry carries the defect forward to a later fix.

## Verdict vs. Review Conclusion

These are different layers; do not mix them (see [glossary.md](glossary.md)):

- **Verdict** (PASS / ISSUES / FAIL) is the mechanized judgment of the Verify stage — it answers "did the worker meet the Evidence Contract?"
- **Review conclusion** (`accepted` / `accepted-with-risk` / `needs-rework` / `rejected`) is the control agent's integration decision.

Mapping:

| Verdict | Typical review conclusion |
|---------|---------------------------|
| PASS | accepted |
| ISSUES | accepted-with-risk (defects logged in Registry) |
| FAIL | needs-rework (fixable) or rejected (not usable) |

The mapping is a default, not a rule — the control agent decides the conclusion using the verdict as input.

## How the Contract Attaches to Work

- **Ordinary task packet** ([templates/task-packet.md](templates/task-packet.md)): the `Required Verification` field lists checks. The worker report ([templates/worker-report.md](templates/worker-report.md)) must answer each with the four elements.
- **Audit task packet** ([templates/audit-task-packet.md](templates/audit-task-packet.md)): the entire packet is a set of `check_item`s, each with a `command`, `pass_condition`, `fail_signal`, and `named_list`. The audit worker runs them and returns a verdict + named lists.
- **Verify stage**: the control agent applies the hard constraint. A report missing evidence for a declared check cannot be accepted, regardless of how confident the worker sounds.

## 脚本执行已知坑(Evidence Contract 抓症状,这里防根因)

Evidence Contract 的 gate 能抓到下游症状(闭集约束违规、链接缺失理由句),但有两类执行失败是 gate 抓不到的根因,且产物常**形式合规但语义错误**:

- **派生产物的链接/符号匹配用子串而非精确解析** → 虚高入度/假边,看着像合规的图实则是假数据。
- **批量脚本里「结构化精确改写」与「全局文本替换」并存,顺序错了** → 结构化改写全 miss,fallback 到"已处理",脚本报成功却啥也没干。

这两类是 Integrate 阶段和审计脚本的常见坑。完整机制 + 诊断信号见 [prompt-control.md §3 Script-Execution Pitfalls](prompt-control.md)。判别:产物看着合理但 top-N 高度节点 degree 远超真实 grep 计数 → 子串伪阳性;dry-run 结构化命中数 < 预期或 live 报"already processed" → 全局替换先吃了精确匹配串。

## The Honest Blind Spots

Enloom runs in a single-agent environment where the worker is the same agent entering worker mode. Several reliability properties that a multi-process system gets for free cannot be guaranteed here. The Evidence Contract requires these to be **declared, not hidden** — a worker or audit lists each under **Not Checked** with a one-liner. v0.5 expands this from one recorded limitation to three, because the original single statement did not cover the broader unreliability surface:

1. **Cross-worker real isolation — no independent runtime.** Worker isolation is enforced by packet field discipline (Writable / Forbidden), not by execution isolation. There is no independent subagent runtime to verify a worker did not touch forbidden files. *(Recorded since v0.3.)*
2. **Cross-role verification — verdict / review / audit may share one context.** In a single-agent run, the same model context that produced the output often also produces the verdict, the review conclusion, and the audit. Independent reasoning-chain verification (a second model genuinely re-deriving the conclusion) is **not guaranteed**. A PASS from the same context that did the work is weaker evidence than a PASS from a fresh one. *(v0.5 — fills the gap the original statement left.)*
3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** In single-agent mode, a phase-plan may declare `parallel` with a full Ownership Table, but execution is actually serial (`scheduler-rules.md` "单 agent 会话的现实"). The Ownership Table still has value — it makes the intended ownership explicit and is what a real multi-sub-agent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened. *(v0.5 — empirical basis: `scheduler-rules.md` already admits this, but the admission was buried in the rules, not surfaced as a named blind spot.)*

These do not make Enloom unusable in single-agent mode — they make it honest. A control agent that proceeds knowing these limits makes better decisions than one that assumes isolation, independent review, and real parallelism are guaranteed.

## See Also

- [templates/worker-report.md](templates/worker-report.md) — the report shape aligned to the four elements.
- [templates/audit-task-packet.md](templates/audit-task-packet.md) — the packet specialized for verification.
- [review-checklist.md](review-checklist.md) — the gates that enforce this contract at Verify.
- [examples/art-lab-worked-example.md](examples/art-lab-worked-example.md) — how real audit commands filled a `check_item` and what a PASS-without-evidence failure looked like in practice.
