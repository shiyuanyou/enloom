# output.md — P0 叙事翻转六处改动记录

Task: 把 enloom skill 里 6 处"单 agent 自执行合法化"措辞同批翻转成"默认 dispatch 给独立 sub-agent,无 sub-agent 能力即中断(不退化自执行)"。

文件数(修改):5。措辞位置数(翻转):6(evidence-contract.md 内含 2 处)。所有 6 处 old_string 均唯一精确匹配,无猜测。

---

## 1. `references/glossary.md` — L12,Worker 定义(叙事链源头)

**句子**:Glossary 核心术语表 Worker 行。

**旧**:
```
| **Worker** | 短生命周期执行单元。可以是 sub-agent、Pi、或当前 agent 进入 worker mode。在 packet 边界内发挥智能。 |
```

**新**:
```
| **Worker** | 短生命周期执行单元,是**独立的 sub-agent 执行单元**(sub-agent / Pi / 其他支持 sub-agent dispatch 的运行时)。主窗口(control agent)不进入 worker mode——Stage 3 task 必须 dispatch 给独立 sub-agent;运行时无 sub-agent 能力 → 中断,提示换支持工具(opencode / pi / codex 等),不退化自执行。在 packet 边界内发挥智能。 |
```

**语义**:删去"或当前 agent 进入 worker mode"(control=worker 合法化源头)→ Worker = 独立 sub-agent;无 sub-agent 能力即中断,不退化。

---

## 2. `references/evidence-contract.md` — L88,§The Honest Blind Spots 开头

**句子**:Honest Blind Spots 段落的开场描述句。

**旧**:
```
Enloom runs in a single-agent environment where the worker is the same agent entering worker mode. Several reliability properties that a multi-process system gets for free cannot be guaranteed here. The Evidence Contract requires these to be **declared, not hidden** — a worker or audit lists each under **Not Checked** with a one-liner. v0.5 expands this from one recorded limitation to three, because the original single statement did not cover the broader unreliability surface:
```

**新**:
```
Enloom 要求 Stage 3 task dispatch 给独立 sub-agent;运行时无 sub-agent 能力时**中断**(不退化自执行)。但即使有独立 sub-agent,仍有一些多进程系统天然具备、单会话编排难以完全保证的可靠性属性——这些必须**声明而非隐藏**。worker 或 audit 把每一项列在 **Not Checked** 下,一行说明。v0.5 从一项扩展为三项:
```

**语义**:删去"runs in a single-agent environment where the worker is the same agent"(自执行运行基线)→ 默认 dispatch 给独立 sub-agent,无能力即中断;三条盲区仍需声明(盲区本身在编号列表里保留)。

---

## 3. `references/evidence-contract.md` — L24,§The Fifth Dimension 的 boundary statement blockquote

**句子**:Dimension 5 下方的整段 blockquote。

**旧**:
```
> **Single-agent degradation (boundary statement).** In a multi-sub-agent runtime this dimension is a genuine cross-runtime check — one process recounts what another process claimed. In single-agent mode (the current default — see `scheduler-rules.md` "单 agent 会话的现实") it degrades to "the agent recounts its own output file." That still catches *claim typos and drift* (the report says 107, the file has 130 — a real, common error), but it does **not** defend against systematic self-misreporting, because the counter and the claimer share one context. Systematic misreporting is covered instead by the Known Blind Spots (cross-role verification), not by this dimension. Name it "Claim Consistency," never "sub-agent count verification" — the latter overstates what single-agent mode can verify.
```

**新**:
```
> **Claim Consistency (boundary statement).** In a multi-sub-agent runtime this dimension is a genuine cross-runtime check — one sub-agent recounts what another claimed. It catches *claim typos and drift* (the report says 107, the file has 130 — a real, common error), and also catches cross-context inconsistencies. **Systematic self-misreporting** is not defended against by this dimension — that line of defense lives in the Known Blind Spots (cross-role verification), not here. Name it "Claim Consistency," never "sub-agent count verification" — the latter overstates what can be verified.
```

**语义**:删去"single-agent mode (the current default)"与"degrades to the agent recounts its own output file"(单 agent 默认 + 退化许可)→ 重述为多 sub-agent 跨运行时校验,系统性谎报防线明确归于 Known Blind Spots。命名"Claim Consistency"保留。

---

## 4. `references/landing-contract.md` — L88-92,§5 整段(含标题)

**句子**:整个 §5 小节(标题 + 两段正文)。

**旧**:
```
## 5. Single-agent reality

In a single control-agent session (no real sub-processes), the worker is the same agent entering worker mode. The gates still apply unchanged: the agent must still write `task.md` before "dispatching to itself," and `output.md` / `report.md` before "returning." The hand-off being virtual does not relax the landing — the files must still exist on disk. This is exactly the failure art_lab hit: the agent played both roles and skipped the disk writes entirely. The gate table exists to prevent precisely that.

The one honest blind spot to declare in worker reports under single-agent mode: "no independent runtime verified that the worker did not touch forbidden files" — real cross-worker isolation requires a separate process, which the file protocol cannot provide. The [worker-report template](templates/worker-report.md) already captures this.
```

**新**:
```
## 5. Sub-agent requirement

Stage 3 dispatch hands the worker a path to `task.md`; the worker is an **independent sub-agent** that writes `output.md` / `report.md` to disk. If the runtime cannot dispatch a sub-agent, Enloom **halts** — it does not degrade to the control agent executing the task itself. The control agent's job is orchestration (triage / orient / plan / review / integrate / archive) and serial-integration writes, not worker execution. Halting is the honest failure: prompt contamination (main window absorbing worker context) is worse than not running.

When dispatch fails (no sub-agent runtime / tool error), the control agent surfaces the failure and suggests switching to a runtime with sub-agent support (opencode / pi / codex, etc.). There is no self-execution fallback.
```

**语义**:标题 "Single-agent reality" → "Sub-agent requirement"。删去"dispatching to itself""same agent entering worker mode"(合法自执行)→ 默认 dispatch 给独立 sub-agent,无能力即 halt,无自执行 fallback。Cross-worker isolation 盲区不再在本段重复(已落到 evidence-contract §Honest Blind Spots 第 1 项措辞,见改动 #6)。

---

## 5. `references/scheduler-rules.md` — L61-65,§单 agent 会话的现实 整段(含标题)

**句子**:整个 §"单 agent 会话的现实" 小节(v0.5 回写 blockquote + 第二段正文)。

**旧**:
```
## 单 agent 会话的现实

> ⚠️ **架构盲区(v0.5 回写)**:本段承认的事实 ——「在单个 control agent 会话里,无法真正并行 dispatch 多个写 worker……执行实际串行」—— 是一项 **明示的架构盲区**,不只是埋在调度规则里的一句话。phase-plan 里声明的 `strategy: parallel` + Ownership Table 在单 agent 下只是**协议形式**,没有任何运行时并行被真正执行。该盲区已纳入 Evidence Contract 的 **Known Blind Spots** 第 3 项(virtual parallelism),见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。Ownership Table 仍有价值——它把意图写明,是真实多 sub-agent 运行时会执行的契约——但不得用 `parallel` 标签暗示已发生真实并行。

在单个 control agent 会话里,无法真正并行 dispatch 多个写 worker。此时 task packet 仍应声明所有权表(满足协议形式),但执行实际串行。这本身是协议的真实表现,不是绕过——在能并行的环境(sub-agent 调度)里所有权表才真正生效。
```

**新**:
```
## 并行调度的真实时序(virtual parallelism 盲区)

> ⚠️ **架构盲区**:即使每个 task 都真 dispatch 给独立 sub-agent,control agent 在单个会话里**顺序发起**这些 dispatch——phase-plan 里声明的 `strategy: parallel` + Ownership Table 是**协议形式**,不代表运行时真并发执行。该盲区纳入 Evidence Contract 的 **Known Blind Spots** 第 3 项(virtual parallelism),见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。Ownership Table 仍有价值——它把意图写明,是真实并发运行时会执行的契约——但不得用 `parallel` 标签暗示已发生真实并行。

(注:无 sub-agent 能力的运行时,Enloom 直接中断,见 [landing-contract.md §5](landing-contract.md)。本段只讨论"有 sub-agent 但顺序发起"的情况。)
```

**语义**:标题改为"并行调度的真实时序(virtual parallelism 盲区)"。删去"在单个 control agent 会话里……执行实际串行……这本身是协议的真实表现,不是绕过"(单 agent 自执行的"协议真实表现"兜底)→ 重述 virtual parallelism 盲区:即使每个 task 都真 dispatch 给独立 sub-agent,control agent 顺序发起,parallel 标签 ≠ 真并发。**virtual parallelism 盲区本身保留**(声明 parallel ≠ 真并发),并新增指向 landing-contract §5 的中断说明注脚。

---

## 6. `references/templates/worker-report.md` — L29-32,Known Blind Spots 模板指引 blockquote

**句子**:Known Blind Spots 区段的 blockquote 指引(开头句 + 编号 1/2/3 + 末句)。

**旧**:
```
> Evidence Contract element 4 — for each Not Checked item: why it was not checked, and how large the risk is. In a single-agent environment, three structural blind spots should be reflected here where relevant (see [evidence-contract.md §The Honest Blind Spots](../evidence-contract.md)):
> 1. **cross-worker real isolation** — no independent runtime to verify the worker did not touch forbidden files.
> 2. **cross-role verification** — verdict / review / audit may come from the same model context; independent reasoning-chain verification is not guaranteed.
> 3. **virtual parallelism** — declared `strategy: parallel` is protocol form only; execution is actually serial in single-agent mode.
>
> Not every report needs all three — list the ones that actually apply to this task's risk surface.
```

**新**:
```
> Evidence Contract element 4 — for each Not Checked item: why it was not checked, and how large the risk is. Three structural blind spots should be reflected here when applicable (see [evidence-contract.md §The Honest Blind Spots](../evidence-contract.md)):
> 1. **cross-worker file isolation** — enforced by packet field discipline (Writable / Forbidden), not by process boundary; even with independent sub-agents, a worker touching a forbidden file is caught by later audit, not blocked at runtime.
> 2. **cross-role verification** — verdict / review may share model or session; independent reasoning-chain verification is not guaranteed even when worker and reviewer are separate sub-agents.
> 3. **virtual parallelism** — declared `strategy: parallel` is protocol form only; the control agent spawns tasks sequentially within one session, so no runtime concurrency occurs.
>
> Not every report needs all three — list the ones that actually apply to this task's risk surface.
```

**语义**:开头 "In a single-agent environment" → "Three structural blind spots ... when applicable"(删 D4 单 agent 默认)。三项盲区**全部保留但重述**为 sub-agent posture 下的措辞:
- #1 "no independent runtime" → "enforced by packet, not by process boundary"(文件协议 ≠ 进程隔离,即便有独立 sub-agent)。
- #2 "same model context" → "may share model or session"(reviewer/worker 即便不同 sub-agent 仍可能同模型同会话)。
- #3 virtual parallelism → "spawns tasks sequentially within one session"(声明 parallel ≠ 真并发,保留)。

---

## 跨引用自洽性

| 引用关系 | 改后状态 |
|---|---|
| glossary Worker 定义 → "无 sub-agent 能力即中断" | 新增,与 landing-contract §5 "halts / no self-execution fallback" 一致 |
| landing-contract §5 标题 "Sub-agent requirement" | scheduler-rules 改后注脚 `见 landing-contract.md §5` 仍指向正确小节(原 §5 → 现 §5) |
| scheduler-rules §标题改为"并行调度的真实时序(virtual parallelism 盲区)" | 指向 evidence-contract §The Honest Blind Spots 第 3 项(virtual parallelism),目标段落未改标题,链接仍成立 |
| worker-report 模板盲区 → evidence-contract §The Honest Spots | 引用 `../evidence-contract.md` 未变,目标段标题未变 |

**已知遗留(未在 6 处范围内,详见 report.md Known Blind Spots)**:evidence-contract.md L92(§Honest Blind Spots 编号第 3 项正文)仍含旧叙事措辞 "single-agent mode" 与对旧 scheduler-rules 标题串 `"单 agent 会话的现实"` 的引用。本 task packet 的 6 处边界未把该编号项列入(只指派了 §开头 L88 与 §Fifth Dimension L24),且 Countable outputs=6,故未改动并声明为遗留盲区。
