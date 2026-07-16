# Enloom

> A methodology for orchestrating complex AI work.

Enloom is a lightweight **control-plane** workflow skill for tasks that are too large or too stateful to keep in one undisciplined agent context. It enters only when the task genuinely benefits from phase goals, worker task packets, evidence-based review, state compression, and archive discipline.

> Enloom **does not** provide a scheduler, CLI, model resolver, or automatic worker runtime. It gives the agent a file protocol and decision discipline. If the task can be done directly, do it directly.

---

## What it is

A markdown-based methodology that keeps the orchestrator **thin but never blind** across a long task. The core insight, hardened from a real large-scale task: state that records only "what was completed" leaves systematic gaps. What actually lets you recover a project is the **list of unclosed risks**. Enloom is built around holding that list.

## When to use

**Use Enloom** when **two or more** of these apply:
- More than three phases likely
- Two or more workers or roles
- Cross-session state needed
- Review, archive, or retrospective discipline
- Context may grow enough to hurt judgment
- Output becomes a long-term asset

**Do NOT use** for: single-file edits, clear bug fixes, one-off scripts, direct Q&A.

> If only one trigger fires → `light-plan` (a short plan, no files). If none fire → `direct` (just do it).

## How it works · Stage 0 Triage + six-stage lifecycle (Stages 1–6)

```
0. Triage    → direct / light-plan / enter lifecycle
1. Orient    → read project_state + Registry risk sections
2. Plan      → phase goal + Ownership Table + Promise Registry
3. Execute   → make task packet / dispatch / worker plays inside boundary
4. Verify    → review report + audit packet + Evidence Contract gate
5. Integrate → update project_state + Registry + compaction check
6. Close     → archive + closure check + user report
```

**The Five Laws**
1. No Enloom without trigger.
2. No Worker without Task Packet. (dispatch gate requires `task.md` to exist)
3. No Parallel without Ownership Table. (three-tier model)
4. No PASS without Evidence. (Evidence Contract hard constraint)
5. No Archive without State Update. (archive gate requires every review-result.md to exist)

## Core mechanisms

| Mechanism | One line |
|---|---|
| **Registry (seven sections)** | The unclosed-risk list that makes `project_state.md` a live, recoverable truth. |
| **Evidence Contract** | Four evidence elements + three-state verdict; a bare PASS without evidence auto-downgrades to FAIL. |
| **Ownership Table** | Three-tier file ownership (parallel-write / serial-integration / read-only) that makes parallel work safe. |
| **Promise Registry** | Forward-declare outputs + tolerate dangling references + verify at the end. |
| **Compaction Protocol** | Compress resolved process detail; never compress unclosed risk. |

---

## Status

**v0.6** (2026-07-07). Version history and changelog: [CHANGELOG.md](CHANGELOG.md). Unclosed risks: [PROGRESS.md § Registry](PROGRESS.md).

## Install

Skill name: `enloom`. Installed globally at `~/.agents/skills/enloom/`. It triggers from its `description`; invoke it by running a long task in any agent runtime that loads skills.

The supported install mechanism is a source copy to the agent home (this is the same sync method used in development). From the repo root:

```bash
# Install: copy skill source to agent home
cp -r enloom-skill/ ~/.agents/skills/enloom/
```

After installing, verify source/installed parity:

```bash
# Verify source/installed parity
diff -qr enloom-skill/ ~/.agents/skills/enloom/
```

A clean `diff` (no output, exit 0) means the installed copy matches the source. Re-run the `cp` after any source change to keep them in sync.

See [enloom-skill/](enloom-skill/) for the runnable skill package.

## Two directories, two audiences

| Directory | What it holds | Who sees it |
|---|---|---|
| `enloom/` (this repo) | The skill source, design docs, progress — the development repo. | You (the developer) |
| `.enloom/` (in a user's project) | Runtime working files, organized as a **project-level namespace** (v0.4): `task_board.md` (the entry table) + one `<created>-<project>/` directory per project, each holding that project's `project_state.md`, `tasks/`, `runs/`, `archive/`. Worker output **lands as files** through stage gates (landing contract). Hidden by default. | The end user (hidden) |

## Directory

```
enloom/
├── README.md                          this file
├── AGENTS.md                          agent working guide (what to touch, what's frozen)
├── PROGRESS.md                        progress, next steps, roadmap
├── .enloom/                           ★ dogfood workspace (v0.4 namespace: task_board + per-project dirs)
│   ├── task_board.md                    project-level entry table (v0.4)
│   └── archive/                         closed dogfood projects folded here (fold mechanism)
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
    ├── index.md                         archive index (8 closed docs + AgentOS/clear-mind snapshots)
    └── _archive/                        design specs + AgentOS v0.3 snapshots + clear-mind traces
```

> Note: `AgentOS/` v0.3 snapshots and `.clear-mind/` historical artifacts have been archived to `design/_archive/` (content unchanged, evidential integrity via git history). The runnable skill package lives in `enloom-skill/`.

## Controls (sub-actions)

Operations are sub-actions within lifecycle stages:

| Sub-action | Stage |
|---|---|
| `triage` | 0 Triage |
| `plan` | 2 Plan |
| `make-prompt` · `dispatch` | 3 Execute |
| `review` · `audit` | 4 Verify |
| `archive` | 6 Close |
| `health-check` | 1 Orient + 4 Verify (periodic) |

See [enloom-skill/SKILL.md](enloom-skill/SKILL.md).

## Progress

Progress, next steps, and roadmap: [PROGRESS.md](PROGRESS.md). Design reasoning: [design/](design/).
