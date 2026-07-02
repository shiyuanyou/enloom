# Long Task Control Competitors - Explore

Date: 2026-07-02
Scope: market and adjacent-system scan for long-task control skills/plugins/runtimes around Enloom.

## Local Baseline

Enloom README defines the current project as a lightweight control-plane workflow skill, not a scheduler, CLI, model resolver, or automatic worker runtime. Its core mechanisms are file protocol, phase lifecycle, worker task packets, evidence contract, ownership table, promise registry, registry of unclosed risks, and compaction protocol.

dev-wiki supplied the evaluation frame:

- Long task failure is an engineering problem, not only a model intelligence problem.
- Relevant concepts: task decomposition and long planning, context engineering, AI agent design patterns, orchestration handoff, landing timing contract, three-mode persistence choice, audit blind spots, sub-agent count unreliability, modular instruction files, decision stacks, long-task scheduling P1-P8.
- Strong local principles: gate-first, state file as SSOT, thin orchestration, file ownership isolation, route prefill, pre-research delegation, explicit task packets, Orient-before-work, agent-vs-script task classification.

## Source Types Used

- Local project SSOT: `README.md` in Enloom.
- Local wiki: `~/cloudDocs/dev-wiki/wiki/concepts` and `wiki/synthesis/长程任务调度原则.md`.
- Web/Exa search and fetch: representative GitHub READMEs and official docs.
- Built-in LLM knowledge used only as synthesis glue, not as sole evidence for concrete project claims.

## Competitor / Adjacent Landscape

### 1. Skill / Plugin Workflow Packs

These live inside Claude Code, OpenCode, Codex, Pi, Cursor, etc. They mostly encode process as commands, skills, hooks, and subagents.

| Project | URL | Relevant capability | Enloom-relative note |
|---|---|---|---|
| oh-my-openagent / oh-my-opencode | https://github.com/code-yeongyu/oh-my-openagent | OpenCode-centric multi-agent harness, ultrawork, team mode, task system, hooks, skill-embedded MCPs, hash-anchored edits, LSP/AST/tmux | Much heavier than Enloom; closer to harness OS than workflow method. Strong on tool integration, weak if user wants small auditable protocol. |
| Superpowers | https://github.com/obra/superpowers | Brainstorm -> worktree -> plan -> subagent-driven development -> TDD -> review -> finish branch | Strong methodology; less focused on cross-session unclosed risk registry and file landing gates. |
| PCP Skills | https://github.com/JohnnyHua/pcp-skills | OpenCode task queue/backlog/pivot/handoff using `.opencode/pcp` event log and stack | Good narrow control-plane for main-thread preservation and scope creep. Less full lifecycle/evidence/audit than Enloom. |
| fable-long-task | https://github.com/iopass4/fable-long-task | Claude Code long-task command, human-gated pipeline, optional Workflow DSL, dual-model review | Similar spirit to Enloom but more command/playbook and less persistent project namespace/risk registry. |
| longtaskforagent | https://github.com/suriyel/longtaskforagent | Seven-phase Claude/OpenCode long-task workflow, SRS/UCD/design/ATS/init/work/ST, coverage/mutation gates, auto loop | Very rigorous but heavyweight and software-project-specific; more waterfall/QA process than general orchestrator. |
| long-running-harness | https://github.com/eddiearc/long-running-harness | `long_running/` plan, feature_list, progress, state, handoffs; one feature per cycle; worker/evaluator split | Very close to Enloom's file-based continuity, but narrower and simpler. |
| jons-plan | https://github.com/jonmmease/jons-plan | `.jons-plan` state, workflow phases, task JSON, progress log, PreCompact hook, planning panel | Strong cross-session task system and dead-end tracking; Claude Code specific. |
| claude-workflow | https://github.com/sighup/claude-workflow | Spec-driven flow, dependency-aware task graph, dispatch/team execution, validation gates, worktree task lists | Strong competitor in Claude ecosystem; more feature-dev focused and command-rich. |
| claude-corps | https://github.com/josephneumann/claude-corps | Deep planning, orient/dispatch/auto-run, worktree-isolated workers, Linear sync, multi-review | Strong on worktree execution and autonomous loops; external PM dependency makes it heavier. |
| workflow-orchestration | https://github.com/barkain/claude-code-workflow-orchestration | Hook-based delegation enforcement, plan mode, wave scheduling, task metadata, team mode | Strong on enforcing delegation inside Claude Code; less portable to OpenCode/Codex. |

### 2. PM / Spec / Issue Graph Systems

These externalize task state into files, GitHub Issues, Linear, Jira, or spec artifacts. They are not direct runtimes, but are critical competitors for the SSOT layer.

| Project | URL | Relevant capability | Enloom-relative note |
|---|---|---|---|
| Task Master AI | https://github.com/eyaltoledano/claude-task-master | PRD -> tasks, dependencies, next task, subtasks, research, MCP/CLI, selective tool loading | Strong task graph and `next_task`; weaker on evidence contract and worker output audit unless extended. |
| CCPM | https://github.com/automazeio/ccpm | PRD -> epic -> task files -> GitHub issues; `depends_on`, `parallel`, `conflicts_with`; scripts for standup/status | Strong GitHub-native traceability; good model for Enloom external integration. |
| BMAD Planning & Orchestrator | https://github.com/aj-geddes/claude-code-bmad-skills | Analysis -> Planning -> Solutioning -> handoff manifest; story files scoped to disjoint files and dependency waves | Excellent upstream planning; intentionally does not execute code, so complementary to Enloom runtime protocol. |
| GitHub Spec Kit | https://github.com/github/spec-kit | Constitution -> specify -> plan -> tasks -> implement -> converge; 30+ agent integrations | Strongest general spec-driven layer; not primarily a long-task runtime, but good source for clarify/analyze/converge gates. |

### 3. Durable Runtime / Local Orchestrator Layer

These turn orchestration from discipline into runtime fact: scheduler, event log, retries, worktrees, sandboxes, dashboard, approvals.

| Project | URL | Relevant capability | Enloom-relative note |
|---|---|---|---|
| Temporal durable agents | https://learn.temporal.io/tutorials/ai/durable-ai-agent/ | Durable workflows, activities, retries, event history, replay, signals, queries | Strongest generic durability model; not coding-agent-specific and high operational cost. |
| Smithers | https://github.com/smithersai/smithers | SQLite-persisted steps, workflow TSX, approvals, rewind/fork/replay, agents/sandboxes, observability | Closest runtime-level competitor if Enloom grows beyond skill. |
| Millrace | https://github.com/tim-osterhus/millrace | Local runtime daemon, durable queues, compiled plans, stage contracts, recovery, approvals, evidence | Philosophically close to Enloom but implemented as runtime owner, not prompt/file discipline only. |
| Taskplane | https://github.com/HenryLach/taskplane | Pi-based DAG waves/lanes, worktree isolation, supervisor/worker/reviewer/merger, dashboard | Strong for parallel coding batches, less general across harnesses. |
| Multi-Agent Orchestrator | https://github.com/hyw007726/multi-agent-orchestrator-skill | Agent skill + Node runtime; launches Claude/Codex/Gemini/OpenCode workers in worktrees; coord files and dashboard | Very practical local execution layer; caller remains architect and final reviewer. |
| Citadel | https://github.com/SethGammon/Citadel | `/do` routing, `.planning` memory, hooks, cost telemetry, campaigns, fleets/worktrees | Operating layer around Claude/Codex; strong if user wants router + lifecycle enforcement. |
| Ruflo / Claude Flow | https://github.com/ruvnet/ruflo | Meta-harness with swarms, memory, MCP tools, hooks, background workers, federation | Massive surface area; powerful but high complexity and potential overclaim risk. |

### 4. Context / Memory / Handoff Layer

These do not solve execution by themselves, but they address context rot, cross-tool continuity, and memory governance.

| Project | URL | Relevant capability | Enloom-relative note |
|---|---|---|---|
| DCP for OpenCode | https://github.com/Opencode-DCP/opencode-dynamic-context-pruning | Context compression, dedupe, stale error pruning, protected tools/files | Useful complement to Enloom compaction; handles prompt projection rather than project state. |
| Project Butler | https://github.com/JamesShi96/project-butler | CLAUDE.md, PROJECT.md, TODO.md, session-handoff, logs, end/continue/status | Strong simple memory stack; less formal task/evidence lifecycle. |
| agent-memory | https://github.com/xChuCx/agent-memory | Git-native Markdown memory, MCP fetch/propose/status, staged human review, secret scan, merge driver | Strong governance model for durable memory writes; good fit for Enloom decision/risk memory. |
| ContextOS / Checkpoint | https://github.com/bkalyankumar/contextos | `.contextos`, active/completed tasks, decisions, handoffs, agent-specific continuation packs | Good abstraction: project state projected into target-agent continuation pack. |
| episodic-memory | https://github.com/lantisprime/episodic-memory | Cross-tool episodic store, revision chains, proactive recall, hooks/enforcement | Good for lessons/decisions, not a replacement for current task state. |

## Information Sufficiency

Sufficiency: sufficient for product/strategy comparison, not sufficient for implementation-quality claims.

Known limits:

- Many projects are young and README-heavy; actual reliability needs trials.
- Star counts and marketing claims were not treated as proof.
- Some GitHub raw fetches failed or were too large, but representative project docs and search summaries were enough for taxonomy.
- Direct hands-on evaluation of tools was not performed in this pass.
