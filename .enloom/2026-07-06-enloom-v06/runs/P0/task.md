# Task Packet: P0 — 叙事翻转六处同批改

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

把 enloom skill 里 6 处"单 agent 自执行合法化"措辞**同批翻转**成"默认 dispatch,无 sub-agent 能力即中断"。这 6 处构成一条互相引用的叙事链,必须一次改完,改后互引仍自洽。

翻转的核心语义:
- **旧**:单 agent 是 baseline reality,worker 可以是"同一个 agent 进入 worker mode",主窗口可自执行。
- **新**:Stage 3 task 默认 dispatch 给 sub-agent。无 sub-agent 能力 → 中断,提示换 opencode/pi/codex 等支持工具。不退化、不自执行。主窗口职责 = triage/orient/plan/review/integrate/archive + 串行集成区写入。

## Anti Goal

- **不删** virtual parallelism 盲区(声明 `strategy: parallel` ≠ 真并发——这与 sub-agent 能力无关,是控制层发起时序问题,保留)。
- **不写**退化路径(无"如何合法自执行"、无"声明的自执行")。
- **不动**六阶段骨架 / 五铁律 / Evidence Contract 四要素本身。
- **不重写**整段——只翻转语义相关句,其余文字保留。

## Inputs

6 个文件,每个标出要翻转的精确位置(行号 + 原文)。所有文件在 `/Users/bigo/.agents/skills/enloom/` 下。

### 1. `references/glossary.md` — Worker 定义(源头)

**当前 L12**(Glossary 核心术语表 Worker 行):
```
| **Worker** | 短生命周期执行单元。可以是 sub-agent、Pi、或当前 agent 进入 worker mode。在 packet 边界内发挥智能。 |
```

**问题**:"或当前 agent 进入 worker mode" 是整条叙事链的源头——它允许 control = worker。

**翻转成**:Worker 是**独立的 sub-agent 执行单元**(sub-agent / Pi / 其他支持 sub-agent dispatch 的运行时)。主窗口(control agent)不进入 worker mode——Stage 3 task 必须 dispatch 给独立 sub-agent;运行时无 sub-agent 能力 → 中断,提示换支持工具(opencode / pi / codex 等),不退化自执行。

### 2. `references/evidence-contract.md` — §The Honest Blind Spots 开头(L88)

**当前 L88**:
```
Enloom runs in a single-agent environment where the worker is the same agent entering worker mode. Several reliability properties that a multi-process system gets for free cannot be guaranteed here. The Evidence Contract requires these to be declared, not hidden — a worker or audit lists each under **Not Checked** with a one-liner. v0.5 expands this from one recorded limitation to three, because the original single statement did not cover the broader unreliability surface:
```

**问题**:"runs in a single-agent environment where the worker is the same agent" 把自执行写成运行基线。

**翻转成**:Enloom 要求 Stage 3 task dispatch 给独立 sub-agent;运行时无 sub-agent 能力时**中断**(不退化自执行)。但即使有独立 sub-agent,仍有一些多进程系统天然具备、单会话编排难以完全保证的可靠性属性——这些必须**声明而非隐藏**。worker 或 audit 把每一项列在 **Not Checked** 下,一行说明。v0.5 从一项扩展为三项:

### 3. `references/evidence-contract.md` — §The Fifth Dimension 单 agent 退化段(L24)

**当前 L24** 整段(以 `> **Single-agent degradation (boundary statement).**` 开头):
```
> **Single-agent degradation (boundary statement).** In a multi-sub-agent runtime this dimension is a genuine cross-runtime check — one process recounts what another process claimed. In single-agent mode (the current default — see `scheduler-rules.md` "单 agent 会话的现实") it degrades to "the agent recounts its own output file." That still catches *claim typos and drift* (the report says 107, the file has 130 — a real, common error), but it does **not** defend against systematic self-misreporting, because the counter and the claimer share one context. Systematic misreporting is covered instead by the Known Blind Spots (cross-role verification), not by this dimension. Name it "Claim Consistency," never "sub-agent count verification" — the latter overstates what single-agent mode can verify.
```

**问题**:"single-agent mode (the current default)" 把单 agent 写成默认;"degrades to the agent recounts its own output" 是退化许可。

**翻转成**:Claim Consistency 在多 sub-agent 运行时是真正的跨运行时校验(一个 sub-agent 重数另一个声称的数)。它抓 claim 笔误/漂移(report 写 107、文件实 130 是常见真实错误),也抓跨上下文的不一致。**系统性谎报**的防线在 Known Blind Spots 的 cross-role verification,不在本维。仍叫 "Claim Consistency"。

(删掉"single-agent mode current default"和"degrades to agent recounts own output"——这些在新 posture 下不再是 baseline。)

### 4. `references/landing-contract.md` — §5 Single-agent reality(L88-92 整段)

**当前 L88-92**:
```
## 5. Single-agent reality

In a single control-agent session (no real sub-processes), the worker is the same agent entering worker mode. The gates still apply unchanged: the agent must still write `task.md` before "dispatching to itself," and `output.md` / `report.md` before "returning." The hand-off being virtual does not relax the landing — the files must still exist on disk. This is exactly the failure art_lab hit: the agent played both roles and skipped the disk writes entirely. The gate table exists to prevent precisely that.

The one honest blind spot to declare in worker reports under single-agent mode: "no independent runtime verified that the worker did not touch forbidden files" — real cross-worker isolation requires a separate process, which the file protocol cannot provide. The [worker-report template](templates/worker-report.md) already captures this.
```

**问题**:整段是单 agent 兜底的"合法自执行"说明。

**翻转成**:
```
## 5. Sub-agent requirement

Stage 3 dispatch hands the worker a path to `task.md`; the worker is an **independent sub-agent** that writes `output.md` / `report.md` to disk. If the runtime cannot dispatch a sub-agent, Enloom **halts** — it does not degrade to the control agent executing the task itself. The control agent's job is orchestration (triage / orient / plan / review / integrate / archive) and serial-integration writes, not worker execution. Halting is the honest failure: prompt contamination (main window absorbing worker context) is worse than not running.

When dispatch fails (no sub-agent runtime / tool error), the control agent surfaces the failure and suggests switching to a runtime with sub-agent support (opencode / pi / codex, etc.). There is no self-execution fallback.
```

(保留 cross-worker isolation 盲区——它在新 posture 下仍成立:即使有独立 sub-agent,文件协议本身不等于进程隔离验证。挪到 evidence-contract §Honest Blind Spots 第 1 项措辞里,不在这段重复。)

### 5. `references/scheduler-rules.md` — §单 agent 会话的现实(L62-66)

**当前 L62-66**:
```
## 单 agent 会话的现实

> ⚠️ **架构盲区(v0.5 回写)**:本段承认的事实 ——「在单个 control agent 会话里,无法真正并行 dispatch 多个写 worker……执行实际串行」—— 是一项 **明示的架构盲区**,不只是埋在调度规则里的一句话。phase-plan 里声明的 `strategy: parallel` + Ownership Table 在单 agent 下只是**协议形式**,没有任何运行时并行被真正执行。该盲区已纳入 Evidence Contract 的 **Known Blind Spots** 第 3 项(virtual parallelism),见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。Ownership Table 仍有价值——它把意图写明,是真实多 sub-agent 运行时会执行的契约——但不得用 `parallel` 标签暗示已发生真实并行。

在单个 control agent 会话里,无法真正并行 dispatch 多个写 worker。此时 task packet 仍应声明所有权表(满足协议形式),但执行实际串行。这本身是协议的真实表现,不是绕过——在能并行的环境(sub-agent 调度)里所有权表才真正生效。
```

**问题**:第二段(L65-66)"在单个 control agent 会话里,无法真正并行 dispatch...执行实际串行...这本身是协议的真实表现,不是绕过" —— 这段在新 posture 下要**拆**:
- **删**:第一段 v0.5 回写 blockquote 里关于"worker = 同一个 agent"的暗示(其实这段主要讲 virtual parallelism,但措辞要清理)。
- **删**:第二段整段(讲单 agent 自执行的"协议真实表现")。
- **留**:virtual parallelism 盲区本身(声明 parallel ≠ 真并发)——但重述为:即使每个 task 都真 dispatch 给独立 sub-agent,control agent 在一个会话里**顺序发起**这些 dispatch,并行标签 ≠ 真并发执行。

**翻转成**:
```
## 并行调度的真实时序(virtual parallelism 盲区)

> ⚠️ **架构盲区**:即使每个 task 都真 dispatch 给独立 sub-agent,control agent 在单个会话里**顺序发起**这些 dispatch——phase-plan 里声明的 `strategy: parallel` + Ownership Table 是**协议形式**,不代表运行时真并发执行。该盲区纳入 Evidence Contract 的 **Known Blind Spots** 第 3 项(virtual parallelism),见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。Ownership Table 仍有价值——它把意图写明,是真实并发运行时会执行的契约——但不得用 `parallel` 标签暗示已发生真实并行。

(注:无 sub-agent 能力的运行时,Enloom 直接中断,见 [landing-contract.md §5](landing-contract.md)。本段只讨论"有 sub-agent 但顺序发起"的情况。)
```

### 6. `references/templates/worker-report.md` — L29-34 single-agent blind spots 段

**当前 L29-34**(worker-report 模板里的 Known Blind Spots 指引段):
```
In a single-agent environment, three structural blind spots should be reflected here (see evidence-contract.md §The Honest Blind Spots):

1. **Cross-worker real isolation — no independent runtime.** Worker isolation is enforced by packet field discipline (Writable / Forbidden), not by execution isolation. There is no independent subagent runtime to verify a worker did not touch forbidden files.
2. **Cross-role verification — verdict / review / audit may share one context.** In a single-agent run, the same model context that produced the output often also produces the verdict, the review conclusion, and the audit. Independent reasoning-chain verification (a second model genuinely re-deriving the conclusion) is **not guaranteed**. A PASS from the same context that did the work is weaker evidence than a PASS from a fresh one.
3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** In single-agent mode, a phase-plan may declare `parallel` with a full Ownership Table, but execution is actually serial (`scheduler-rules.md` "单 agent 会话的现实"). The Ownership Table still has value — it makes the intended ownership explicit and is what a real multi-sub-agent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened.
```

**问题**:
- 开头 "In a single-agent environment" 是 D4 默认。
- 第 1 项 "no independent subagent runtime" —— 新 posture 下有 sub-agent,但文件协议 ≠ 进程隔离,这条**保留但重述**。
- 第 2 项 "may share one context" —— 新 posture 下 worker 和 reviewer 是不同 sub-agent,但"同模型同会话"风险仍在(尤其 reviewer 也可能是同会话 sub-agent),**保留但重述**。
- 第 3 项 virtual parallelism —— **保留**。

**翻转成**:
```
Three structural blind spots should be reflected here when applicable (see evidence-contract.md §The Honest Blind Spots):

1. **Cross-worker file isolation — enforced by packet, not by process boundary.** Worker isolation is enforced by packet field discipline (Writable / Forbidden). Even with independent sub-agents, the file protocol itself does not equal process-level isolation verification — a worker touching a forbidden file is caught by later audit, not blocked at runtime. Declare this when the task writes files.
2. **Cross-role verification — verdict / review may share model or session.** Even when worker and reviewer are separate sub-agents, they may share the same model or be spawned within one session. Independent reasoning-chain verification (a genuinely fresh re-derivation) is **not guaranteed**. A PASS is stronger when reviewer and worker differ; declare when review and execution are closely coupled.
3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** Even with every task dispatched to an independent sub-agent, the control agent spawns them sequentially within one session. The Ownership Table has value (it makes intended ownership explicit; a truly concurrent runtime would enforce it), but declaring `parallel` does not mean runtime concurrency occurred.
```

## Existing State

- 6 文件当前都是 v0.5 措辞,互引自洽(旧叙事)。
- 改后必须保持互引自洽(新叙事)。
- `audit-task-packet.md:65` 和 `phase-plan.md:23` 是正面角色命名样例,参考。

## Allowed Tools

Read / Edit / Grep / Bash(仅用于 grep 验证,不改文件外的任何东西)

## Writable Files

> 独占清单,精确到路径。派生自 Ownership Table。

- `/Users/bigo/.agents/skills/enloom/references/glossary.md`
- `/Users/bigo/.agents/skills/enloom/references/evidence-contract.md`
- `/Users/bigo/.agents/skills/enloom/references/landing-contract.md`
- `/Users/bigo/.agents/skills/enloom/references/scheduler-rules.md`
- `/Users/bigo/.agents/skills/enloom/references/templates/worker-report.md`

## Forbidden files

> 显式枚举串行集成区文件。

- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/**`(所有 enloom 编排文件 — project_state / decisions / registry / runs / tasks / archive)
- 任何不在 Writable Files 列表里的 skill 文件(SKILL.md / 其他 references / 其他 templates / prompt-assets / examples)

## Output Files

- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/2026-07-06-enloom-v06/runs/P0/output.md` — 逐文件改动记录(改了哪句、旧→新)
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/2026-07-06-enloom-v06/runs/P0/report.md` — Evidence Contract 四要素 + Review Result(留给 control agent 填)

## Acceptance Criteria

1. 6 处全部翻转(见 Countable outputs)。
2. 无残留旧叙事措辞(见 Required Verification)。
3. 互引自洽:glossary Worker 定义 ↔ evidence-contract §Honest Blind Spots 开头 ↔ landing-contract §5 ↔ scheduler-rules §单agent ↔ worker-report blind spots 段,引用关系改后仍指向正确目标。
4. virtual parallelism 盲区**保留**(声明 parallel ≠ 真并发)。
5. 无新增"如何合法自执行"/"退化路径"措辞。
6. 六阶段骨架 / 五铁律 / Evidence Contract 四要素**未被改动**(只改叙事句)。

## Required Verification

> audited 模式必填。每项对齐 check_item。

| id | command | pass_condition | fail_signal |
|----|---------|----------------|-------------|
| V1 | `grep -rn "same agent entering worker mode\|当前 agent 进入 worker mode\|the agent recounts its own\|single-agent mode.*default\|dispatching to itself" /Users/bigo/.agents/skills/enloom/references/ /Users/bigo/.agents/skills/enloom/SKILL.md` | 0 hits | ≥1 hit |
| V2 | `grep -rn "virtual parallelism\|协议形式" /Users/bigo/.agents/skills/enloom/references/evidence-contract.md /Users/bigo/.agents/skills/enloom/references/scheduler-rules.md` | ≥1 hit each(virtual parallelism 盲区保留) | 0 hit |
| V3 | `grep -rn "无 sub-agent\|halts\|interrupt\|中断" /Users/bigo/.agents/skills/enloom/references/landing-contract.md` | ≥1 hit(中断语义落地) | 0 hit |
| V4 | `grep -rn "六个阶段\|six stages\|Five Laws\|五铁律\|四要素\|Four Elements" /Users/bigo/.agents/skills/enloom/references/evidence-contract.md /Users/bigo/.agents/skills/enloom/references/landing-contract.md` | 原有 hit 数不变(骨架未被误改) | hit 数下降 |

## Countable outputs (Claim Consistency, audited 必填)

- 声称修改的文件数 = 5(glossary / evidence-contract / landing-contract / scheduler-rules / worker-report)。注意 evidence-contract 内有 2 处,但算 1 个文件。
- 声称翻转的措辞位置数 = 6(见 Inputs 编号 1-6)。

## Evidence Required

四要素:Checks Run / Evidence(逐文件改动 diff 摘要)/ Not Checked / Known Blind Spots。

## Review Budget

control agent 只读 report.md + output.md;不读 raw 改动过程的完整 diff(除非 V1-V4 有 fail)。

## Pending / Promise Registry Updates

(无)

## Human Decision Gate

(无)

## Done Signal

返回 `done` / `blocked` / `failed`,附:实际修改文件数、V1-V4 结果、output.md/report.md 路径。
