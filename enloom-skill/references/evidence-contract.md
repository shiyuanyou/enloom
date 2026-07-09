# Evidence Contract

The dividing line: anything an agent can avoid by reading docs is **protocol**; anything you can only find by actually running a command and checking file-system state is **executable evidence**. The Evidence Contract governs the second kind. It verifies worker results; the task packet constrains worker behavior. The two are orthogonal.

## The Four Elements

Any worker that claims completion must produce all four. Missing any one blocks `PASS`.

1. **Checks Run** — which verifications were executed, named explicitly.
2. **Evidence** — the proof for each check: command output / file path / citation. Not "trust me."
3. **Not Checked** — which verifications should have run but did not. Declared blind spots, explicitly, not hidden.
4. **Known Blind Spots** — for each Not Checked item: why it was not checked, and how large the risk is.

The distinction between elements 3 and 4 matters: element 3 names the gap, element 4 sizes the risk. A worker that silently skips a check (leaving element 3 empty when it should not be) is worse than one that declares the skip and explains it.

## The Fifth Dimension — Report-vs-Output Claim Consistency

The four elements cover "did the checks run + is the evidence non-empty," but leave a gap: a report can *claim* a countable quantity ("processed 107 entries", "12 checks passed", "5 files changed") that disagrees with the actual output file. The direction of the disagreement is not fixed — the report may under-count or over-count — so it cannot be calibrated away by a fudge factor. The four elements have no way to catch it, because the claim is written into the evidence section and the gate treats it as trusted.

**Dimension 5 — Claim Consistency.** For any countable output a worker's report asserts (entry counts, pass rates, file counts, coverage numbers), the Verify stage compares the **claimed** number against an **independent recount** of the actual output (`grep -c`, `awk` line-count, `git diff --stat`). A mismatch > 0 is logged as an ISSUES finding (not an automatic PASS) and registered in `## Broken References` if it points at a structural defect.

> **Claim Consistency (boundary statement).** In a multi-sub-agent runtime this dimension is a genuine cross-runtime check — one sub-agent recounts what another claimed. It catches *claim typos and drift* (the report says 107, the file has 130 — a real, common error), and also catches cross-context inconsistencies. **Systematic self-misreporting** is not defended against by this dimension — that line of defense lives in the Known Blind Spots (cross-role verification), not here. Name it "Claim Consistency," never "sub-agent count verification" — the latter overstates what can be verified.

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

Enloom 要求 Stage 3 task dispatch 给独立 sub-agent;运行时无 sub-agent 能力时**中断**(不退化自执行)。但即使有独立 sub-agent,仍有一些多进程系统天然具备、单会话编排难以完全保证的可靠性属性——这些必须**声明而非隐藏**。worker 或 audit 把每一项列在 **Not Checked** 下,一行说明。盲区共三项:

1. **Cross-worker real isolation — no independent runtime.** Worker isolation is enforced by packet field discipline (Writable / Forbidden), not by execution isolation. There is no independent subagent runtime to verify a worker did not touch forbidden files.
2. **Cross-role verification — verdict / review may share model or session.** Even when worker and reviewer are separate sub-agents, they may run on the same model or be spawned within one session. Independent reasoning-chain verification (a genuinely fresh re-derivation) is **not guaranteed**. A PASS is stronger evidence when reviewer and worker differ in model or session than when they are closely coupled. This fills the gap left by cross-worker isolation alone — isolation covers "did it touch forbidden files," this covers "is the verdict independently re-derived."
3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** Even with every task dispatched to an independent sub-agent, the control agent spawns them sequentially within one session — so a phase-plan may declare `parallel` with a full Ownership Table without runtime concurrency actually occurring (`scheduler-rules.md` "并行调度的真实时序"). The Ownership Table still has value — it makes the intended ownership explicit and is what a truly concurrent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened. The empirical basis is `scheduler-rules.md` itself — it admits the sequential spawn, and surfacing it here as a named blind spot keeps it visible rather than buried in the rules.

These do not make Enloom weaker — they make it honest. A control agent that proceeds knowing these limits makes better decisions than one that assumes process isolation, independent review, and real concurrency are guaranteed.

## See Also

- [templates/worker-report.md](templates/worker-report.md) — the report shape aligned to the four elements.
- [templates/audit-task-packet.md](templates/audit-task-packet.md) — the packet specialized for verification.
- [review-checklist.md](review-checklist.md) — the gates that enforce this contract at Verify.
