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
2. No Worker without Task Packet. (dispatch gate requires `task.md` to exist) / 无任务包不派 worker。
3. No Parallel without Ownership Table. (three-tier model) / 无所有权表不并行。
4. No PASS without Evidence. (Evidence Contract hard constraint) / 无证据不得 PASS。
5. No Archive without State Update. (archive gate requires every report's Review Result filled) / 无状态更新不归档。

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

**v0.6**（2026-07-07）。版本历史与变更细节见 [CHANGELOG.md](CHANGELOG.md)。未闭合风险见 [PROGRESS.md § Registry](PROGRESS.md)。

## Install · 安装

Skill name: `enloom`. Installed globally at `~/.agents/skills/enloom/`. It triggers from its `description`; invoke it by running a long task in any agent runtime that loads skills.

```bash
# from this repo, package + install (uses skill-creator tooling)
```

See [enloom-skill/](enloom-skill/) for the runnable skill package.

## Two directories, two audiences · 两个目录,两个"看见"主体

| Directory / 目录 | What it holds / 装什么 | Who sees it / 谁看 |
|---|---|---|
| `enloom/` (this repo) | The skill source, design docs, progress — the development repo. / skill 源码、设计文档、进度——开发仓库。 | You (the developer) / 你(开发者) |
| `.enloom/` (in a user's project) | Runtime working files, organized as a **project-level namespace** (v0.4): `task_board.md` (the entry table) + one `<created>-<project>/` directory per project, each holding that project's `project_state.md`, `tasks/`, `runs/`, `archive/`. Worker output **lands as files** through stage gates (landing contract). Hidden by default. / 运行时工作文件;v0.4 起按项目隔离 + 落盘时序契约。默认隐藏。 | The end user (hidden) / 终端用户(默认看不到) |

## Directory · 目录

```
enloom/
├── README.md                          this file / 本文件
├── AGENTS.md                          agent working guide (what to touch, what's frozen)
├── PROGRESS.md                        progress, next steps, roadmap / 进度、下一步
├── .enloom/                           ★ dogfood workspace (v0.4 namespace: task_board + per-project dirs) / 自举工作区
│   ├── task_board.md                    project-level entry table (v0.4)
│   ├── project_state.md                 frozen v0.3.3 single-state dogfood (historical)
│   ├── runs/                            trigger-eval (v0.3.3 rename 产物)
│   └── archive/                         closed dogfood projects 折叠于此 (fold 机制目标; v04/v05/v06/clearmind-align/repo-hygiene)
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
│   │   ├── review-checklist.md · archive-policy.md · validation.md · glossary.md
│   │   ├── templates/                   fill-in contracts (phase-plan, task-packet, audit, worker-report, task-board, ...)
│   │   └── examples/                    triage tree + manual trial
│   ├── prompt-assets/                   worker role assets (researcher / coder / reviewer)
└── design/                            design archive (closed, not runtime — see design/index.md)
    ├── index.md                         archive index (8 closed docs + AgentOS/clear-mind 过程快照)
    └── _archive/                        design specs + AgentOS v0.3 自举快照 + clear-mind 工作痕迹
```

> Note: `AgentOS/` v0.3 自举快照与 `.clear-mind/` 历史产物已归档至 `design/_archive/`（正文不动，证据真实性靠 git 历史）。The runnable skill package lives in `enloom-skill/`.

## Controls (sub-actions) · 子动作

Operations are sub-actions within lifecycle stages:

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
