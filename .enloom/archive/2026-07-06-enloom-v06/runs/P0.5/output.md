# P0.5 Output — evidence-contract.md 残留旧叙事 + 断链修补

文件:`/Users/bigo/.agents/skills/enloom/references/evidence-contract.md`
修改位置数 = 3(L91 / L92 / L94)

## 位置 1 — L91,编号第 2 项正文

**OLD:**
> 2. **Cross-role verification — verdict / review / audit may share one context.** In a single-agent run, the same model context that produced the output often also produces the verdict, the review conclusion, and the audit. Independent reasoning-chain verification (a second model genuinely re-deriving the conclusion) is **not guaranteed**. A PASS from the same context that did the work is weaker evidence than a PASS from a fresh one. *(v0.5 — fills the gap the original statement left.)*

**NEW:**
> 2. **Cross-role verification — verdict / review may share model or session.** Even when worker and reviewer are separate sub-agents, they may run on the same model or be spawned within one session. Independent reasoning-chain verification (a genuinely fresh re-derivation) is **not guaranteed**. A PASS is stronger evidence when reviewer and worker differ in model or session than when they are closely coupled. *(v0.5 — fills the gap the original statement left.)*

## 位置 2 — L92,编号第 3 项正文(含断链修复)

**OLD:**
> 3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** In single-agent mode, a phase-plan may declare `parallel` with a full Ownership Table, but execution is actually serial (`scheduler-rules.md` "单 agent 会话的现实"). The Ownership Table still has value — it makes the intended ownership explicit and is what a real multi-sub-agent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened. *(v0.5 — empirical basis: `scheduler-rules.md` already admits this, but the admission was buried in the rules, not surfaced as a named blind spot.)*

**NEW:**
> 3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** Even with every task dispatched to an independent sub-agent, the control agent spawns them sequentially within one session — so a phase-plan may declare `parallel` with a full Ownership Table without runtime concurrency actually occurring (`scheduler-rules.md` "并行调度的真实时序"). The Ownership Table still has value — it makes the intended ownership explicit and is what a truly concurrent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened. *(v0.5 — empirical basis: `scheduler-rules.md` already admits this, but the admission was buried in the rules, not surfaced as a named blind spot.)*

**关键变更:**scheduler-rules 引用串 `"单 agent 会话的现实"` → `"并行调度的真实时序"`(标题已在 P0 改名)。

## 位置 3 — L94,收尾句

**OLD:**
> These do not make Enloom unusable in single-agent mode — they make it honest. A control agent that proceeds knowing these limits makes better decisions than one that assumes isolation, independent review, and real parallelism are guaranteed.

**NEW:**
> These do not make Enloom weaker — they make it honest. A control agent that proceeds knowing these limits makes better decisions than one that assumes process isolation, independent review, and real concurrency are guaranteed.
