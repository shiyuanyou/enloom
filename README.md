# Enloom

> A methodology for orchestrating complex AI work.
> 一套编排复杂 AI 工作的方法论。

Enloom is a lightweight **control-plane** workflow skill for tasks that are too large or too stateful to keep in one undisciplined agent context. It enters only when the task genuinely benefits from phase goals, worker task packets, evidence-based review, state compression, and archive discipline.

Enloom 是一个轻量级**控制面** workflow skill——给 agent 处理那些太大、状态太多、单次上下文装不下的长任务。只在不该直接硬干时才进入：需要分阶段目标、worker 任务包、基于证据的 review、状态压缩、归档纪律时。

> Enloom **does not** provide a scheduler, CLI, model resolver, or automatic worker runtime. It gives the agent a file protocol and decision discipline. If the task can be done directly, do it directly.
> Enloom **不提供** scheduler / CLI / model resolver / 自动 worker 运行时。它只给 agent 一套文件协议 + 决策纪律。任务能直接做完就直接做。

---

## What it is / 它是什么

A markdown-based methodology that keeps the orchestrator **thin but never blind** across a long task. The core insight, hardened from a real large-scale task: state that records only "what was completed" leaves systematic gaps. What actually lets you recover a project is the **list of unclosed risks**. Enloom is built around holding that list.

一套基于 markdown 的方法论,让编排者在长任务中**极薄但永不失明**。核心洞察来自一次真实大规模任务:只记录"已完成什么"的状态会留下系统性盲区。真正能让你恢复项目的是**未闭合风险清单**。Enloom 就是围绕守住这份清单建的。

## When to use · 何时不该直接硬干

**Use Enloom** when **two or more** of these apply / **命中 ≥2 个触发器时用 Enloom**:
- More than three phases likely / 预计超过 3 个阶段
- Two or more workers or roles / 需要 2 个以上 worker 或角色
- Cross-session state needed / 需要跨会话状态
- Review, archive, or retrospective discipline / 需要 review、归档或复盘纪律
- Context may grow enough to hurt judgment / 上下文可能膨胀到影响判断
- Output becomes a long-term asset / 产物会成为长期资产

**Do NOT use** for: single-file edits, clear bug fixes, one-off scripts, direct Q&A. / **不要用于**:单文件小改动、明确 bug fix、一次性脚本、明确答案型问答。

> If only one trigger fires → `light-plan` (a short plan, no files). If none fire → `direct` (just do it).

## How it works · 六阶段生命周期

```
0. Triage    → direct / light-plan / enter lifecycle   判断是否进入
1. Orient    → read project_state + Registry risk sections   恢复状态(必扫风险区段)
2. Plan      → phase goal + Ownership Table + Promise Registry   只规划当前阶段
3. Execute   → make task packet / dispatch / worker plays inside boundary   派 worker
4. Verify    → review report + audit packet + Evidence Contract gate   凭证据验收
5. Integrate → update project_state + Registry + compaction check   压缩进状态
6. Close     → archive + closure check + user report   归档退出
```

**The Five Laws · 五条铁律**
1. No Enloom without trigger. / 无触发器不进入。
2. No Worker without Task Packet. (v0.4 mechanized: dispatch gate requires `task.md` to exist) / 无任务包不派 worker。
3. No Parallel without Ownership Table. (three-tier model) / 无所有权表不并行。
4. No PASS without Evidence. (Evidence Contract hard constraint) / 无证据不得 PASS。
5. No Archive without State Update. (v0.4 mechanized: archive gate requires every report's Review Result filled) / 无状态更新不归档。

## Core mechanisms · 核心机制

| Mechanism / 机制 | One line / 一句话 |
|---|---|
| **Registry (七区段)** | The unclosed-risk list that makes `project_state.md` a live, recoverable truth. 让 project_state 成为活的可恢复真相的未闭合风险清单。 |
| **Evidence Contract** | Four evidence elements + three-state verdict; a bare PASS without evidence auto-downgrades to FAIL. 四要素 + 三态验收;无证据的 PASS 自动降级。 |
| **Ownership Table** | Three-tier file ownership (parallel-write / serial-integration / read-only) that makes parallel work safe. 三阶文件所有权,让并行安全。 |
| **Promise Registry** | Forward-declare outputs + tolerate dangling references + verify at the end. 前向声明产出 + 容忍悬空引用 + 末尾验收。 |
| **Compaction Protocol** | Compress resolved process detail; never compress unclosed risk. 压缩已决过程细节,绝不压缩未闭合风险。 |

---

## Status · 状态

**v0.6** (2026-07-07) — dispatch-default 翻转 + recon 升格,review-adjudicated. Four changes from a real-run diagnosis (worker tasks done by the main window instead of dispatched):

1. **Dispatch-default 翻转 (P0+P0.5)** — Stage 3 task 默认必须 dispatch 给 sub-agent;无 sub-agent 能力则中断(提示换 opencode/pi/codex),不退化、不自执行、不污染 prompt。主窗口职责限定为 triage/orient/plan/review/integrate/archive + 串行集成区写入。六处叙事同批改(glossary / evidence-contract / landing-contract / scheduler-rules / worker-report)。
2. **命名硬化 + trim rule (P1)** — 7 处措辞硬化(eval-guide / coder / worker-report / project-state / task-board / task-packet)。worker-report 新增 trim rule:control agent 收 worker 回报只收 Result + Checks summary + verdict-level evidence + named risks,raw output 落 output.md。
3. **recon 升格 (P2)** — recon 从「主窗口顺手做」升格为 Plan 阶段的第一个 sub-agent task packet;phase-plan 加 Human Decision、triage 偏好透传、scheduler-rules 三信号、researcher 分支、eval case 10。
4. **清理 (P3)** — archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 措辞对齐。

**Non-Goals**: virtual parallelism 盲区保留(声明 parallel ≠ 真并发);六阶段骨架/五铁律/Evidence Contract 四要素不变。

See dogfood traces in `.enloom/2026-07-06-enloom-v06/`.

**v0.5** (2026-07-01) — dev-wiki knowledge-base cross-evaluation, review-adjudicated. Seven changes scoped to three blocks, from the review's three-axis verdict (mechanism right / framework right / timing right):

1. **Compaction mandatory gate (S5, HIGH)** — compaction upgraded from an optional "check the trigger" to a mandatory Integrate exit gate: threshold met → must run, no deferring. Closes the loophole where an optional check lets the Registry balloon. Thresholds labeled "heuristic, not dogma."
2. **Three honest blind spots (X2, HIGH)** — the single "no independent runtime" blind spot expanded to three: cross-worker isolation, cross-role verification (verdict/review/audit may share one context), and **virtual parallelism** (single-agent `strategy: parallel` is protocol form only). The last is a review-discovered blind spot with empirical basis in `scheduler-rules.md`.
3. **health-check two-tier (S4, MID)** — split into a light tier (stage transitions: file-existence check only, single-line confirmation) and full tier (Orient + periodic Verify: nine-item scan). Hard-gate semantics unchanged; execution cost drops.
4. **Claim Consistency, 5th Evidence dimension (S1, MID)** — report-vs-output count consistency check (NOT "sub-agent count verification" — that misnames single-agent reality). `audited` mode mandatory.
5. **Reference tolerance decision table (S6, LOW)** — phase-plan scaffolding (≥3 reference-type examples) so the dangling-reference tolerance call isn't re-derived per project.
6. **Mode-differentiated field density (S7, LOW)** — task-packet fields vary by mode: `emergent` may skip Forbidden; `audited` requires Verification + Countable outputs or make-prompt self-check fails.
7. **Recon scheduling guidance (S2, LOW)** — scheduler-rules guidance: unfamiliar domain → first task is a recon task. No new stage / field / term.

**Non-Goals (review-added):** heterogeneous task grouping (S3); formal enloom↔clear-mind failure-downgrade protocol (X1); Pre-flight substage (S2 downgraded to guidance). See [design/2026-07-01-enloom-v0.5-optimization-design.md](design/2026-07-01-enloom-v0.5-optimization-design.md).

**v0.4** (2026-06-30) — two legs, both from real-run diagnosis:

1. **Project-level namespace** — `.enloom/` reorganized from a single global state into a `task_board.md` entry table + one directory per project (`<created>-<project>/`). Same-named projects reuse their directory on second entry (timestamp = creation date, fixed). Solves "second run can't find the task, state from all tasks piled in one file."
2. **Landing time contract** — every lifecycle stage now has entry/exit **gates** (file-existence checks); a control↔worker handshake sequence makes worker output land as files, not chat replies. Mechanizes Laws 2 & 5 (dispatch needs `task.md`; archive needs every `report.md`'s Review Result filled) to the same standard Law 4 already held. Diagnosis: a real run left `tasks/` and `runs/` entirely empty while `project_state.md` claimed completed phases.

See [design/v0.4-project-namespace-spec.md](design/v0.4-project-namespace-spec.md).

**v0.3.3** — renamed `AgentOS / agentos-workflow` → **Enloom**. Zero functional change; pure rename + productization rewrite. The skill's internal `name` is now `enloom`, and its runtime working files now write to a hidden `.enloom/` directory (out of the user's way by default).

**v0.3.2** — absorbed epistemic-discipline + repair-plan-discipline lessons from art_lab `.research/`.

**v0.3.1** — absorbed P7/P8 prompt-control lessons + script-execution pitfalls.

**v0.3** (2026-06-24) — rewrote SKILL.md from a 6-operation menu to a lifecycle of 6 stages; deeply internalized five art_lab hard lessons (Registry / Evidence Contract / Ownership+Promise / Compaction / Audit) as a generic file protocol. Self-bootstrapped: built v0.3 using its own lifecycle, leaving traces in `AgentOS/` (frozen v0.3 snapshot).

**v0.2 / v0.1** — see [PROGRESS.md](PROGRESS.md).

> Honest blind spot / 诚实盲区: the lessons come from art_lab's single domain (wiki ingest); generalization to a second domain is **unverified**. The trigger-eval 20/20 baseline was scored against the pre-rename name+description — Enloom's trigger accuracy is **pending re-run**.

## Install · 安装

Skill name: `enloom`. Installed globally at `~/.agents/skills/enloom/`. It triggers from its `description`; invoke it by running a long task in any agent runtime that loads skills.

```bash
# from this repo, package + install (uses skill-creator tooling)
# package_skill.py auto-strips root evals/ on install
```

See [enloom-skill/](enloom-skill/) for the runnable skill package. See [references/eval-guide.md](enloom-skill/references/eval-guide.md) for the eval suite.

## Two directories, two audiences · 两个目录,两个"看见"主体

| Directory / 目录 | What it holds / 装什么 | Who sees it / 谁看 |
|---|---|---|
| `enloom/` (this repo) | The skill source, design docs, progress — the development repo. / skill 源码、设计文档、进度——开发仓库。 | You (the developer) / 你(开发者) |
| `.enloom/` (in a user's project) | Runtime working files, organized as a **project-level namespace** (v0.4): `task_board.md` (the entry table) + one `<created>-<project>/` directory per project, each holding that project's `project_state.md`, `tasks/`, `runs/`, `archive/`. Worker output **lands as files** through stage gates (landing contract). Hidden by default. / 运行时工作文件;v0.4 起按项目隔离 + 落盘时序契约。默认隐藏。 | The end user (hidden) / 终端用户(默认看不到) |

## Directory · 目录

```
enloom/
├── README.md                          this file / 本文件
├── PROGRESS.md                        progress, next steps, roadmap / 进度、下一步
├── .enloom/                           ★ dogfood workspace (v0.4 namespace: task_board + per-project dirs) / 自举工作区
│   ├── task_board.md                    project-level entry table (v0.4)
│   ├── project_state.md                 frozen v0.3.3 single-state dogfood (historical)
│   ├── 2026-06-30-enloom-v04/           v0.4 dogfood project (namespace + landing-contract self-trial)
│   └── archive/
├── enloom-skill/                      ★ runnable skill package
│   ├── SKILL.md                         skill entry (name: enloom, lifecycle-driven + landing discipline)
│   ├── references/                      lifecycle + contracts + templates + examples
│   │   ├── workflow-steps.md            6-stage lifecycle + five laws + stage gates
│   │   ├── landing-contract.md          ★ v0.4 stage gates + control↔worker handshake + Law 2/5 mechanization
│   │   ├── trigger-contract.md          when to enter / bypass / ambiguous
│   │   ├── evidence-contract.md         ★ evidence four elements + three-state verdict
│   │   ├── registry-and-compaction.md   ★ Registry/Ownership/Promise/Compaction state governance
│   │   ├── prompt-control.md            orchestration technique (route pre-fill, dispatch, pitfalls)
│   │   ├── scheduler-rules.md           serial/parallel (three-tier ownership)
│   │   ├── review-checklist.md · archive-policy.md · eval-guide.md · validation.md · glossary.md
│   │   ├── templates/                   fill-in contracts (phase-plan, task-packet, audit, worker-report, task-board, ...)
│   │   └── examples/                    triage tree + manual trial + art-lab worked example
│   ├── prompt-assets/                   worker role assets (researcher / coder / reviewer)
│   ├── evals/                           9-case decision suite + 20-query trigger suite
│   └── report.md                        v0.1 acceptance report (historical)
├── AgentOS/                           ★ frozen v0.3 self-bootstrap snapshot (legacy naming, intentionally preserved)
└── design/                            design docs (exploration/reference, not runtime)
    ├── design-summary.md                V1→V2 evolution, degradation analysis (the design thesis)
    ├── v0.4-project-namespace-spec.md   ★ v0.4 design spec (namespace + landing time contract)
    ├── v0.3-lifecycle-spec.md           v0.3 design spec (lifecycle + art_lab internalization)
    ├── art-lab-prompt-control-lessons.md prompt-control lessons mined from art_lab
    ├── skill-workflow-draft.md · skill-reference-notes.md
```

> Note: `AgentOS/` keeps its legacy name on purpose — it's a frozen v0.3 self-bootstrap snapshot; renaming it would falsify the historical evidence. The runnable skill package lives in `enloom-skill/`.

## Controls (sub-actions) · 子动作

Since v0.3, operations are sub-actions within lifecycle stages:

| Sub-action / 子动作 | Stage / 阶段 |
|---|---|
| `triage` | 0 Triage |
| `plan` | 2 Plan |
| `make-prompt` · `dispatch` | 3 Execute |
| `review` · `audit` | 4 Verify |
| `archive` | 6 Close |
| `health-check` | 1 Orient + 4 Verify (periodic) |

See [enloom-skill/SKILL.md](enloom-skill/SKILL.md).

## Progress · 进度

Progress, next steps, and roadmap: [PROGRESS.md](PROGRESS.md). Design reasoning: [design/](design/).
