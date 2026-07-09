# Phase Plan: Phase 1 — P0 叙事翻转

## Phase Goal

把 enloom skill 里"单 agent 自执行合法化"的叙事链(六处互引)同批翻转成"默认 dispatch,无 sub-agent 即中断"。这是整个 v06 的承重墙——P1/P2/P3 都建立在 dispatch 真的发生这个前提上。

## Anti Goal

- 不删除 virtual parallelism 盲区(声明 parallel ≠ 真并发)。
- 不写退化路径(无"如何合法自执行")。
- 不改六阶段骨架 / 五铁律 / Evidence Contract 四要素。

## Constraints

- **同批改**:六处必须一次改完。分批改 = 残留旧叙事互相拉回。
- **互引一致**:glossary 定义 → evidence-contract → landing-contract → scheduler-rules → worker-report 的引用链必须改后仍自洽。
- **措辞基准**:正面样例用 `audit-task-packet.md:65`("The control agent receives only...")和 `phase-plan.md:23`("control agent (single-threaded)")。

## Strategy

**serial**(单 worker 单 task packet)。六处互引,改一处需看其他五处当前措辞,串行最安全。

## Ownership Table

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/2026-07-06-enloom-v06/project_state.md` + Registry | 控制 agent 独占 |
| 并行写 | `~/.agents/skills/enloom/` 下 P0 六文件 | P0-worker 独占 |
| 只读 | `design/`、前序项目目录 | 谁都不改 |

**Writable Files**(P0-worker):
- `/Users/bigo/.agents/skills/enloom/references/glossary.md`
- `/Users/bigo/.agents/skills/enloom/references/evidence-contract.md`
- `/Users/bigo/.agents/skills/enloom/references/landing-contract.md`
- `/Users/bigo/.agents/skills/enloom/references/scheduler-rules.md`
- `/Users/bigo/.agents/skills/enloom/references/templates/worker-report.md`

**Forbidden Files**(P0-worker,显式枚举串行集成区):
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/**`(所有 enloom 编排文件)
- project_state / decisions / registry 承载文件

## Tasks

| ID | Task | Packet | Mode |
|----|------|--------|------|
| P0 | 六处叙事翻转同批改 | runs/P0/task.md | audited |

## Review Plan

- **Evidence Contract gate**:report 必须含四要素。Countable outputs:声称改了 6 处 → Verify 用 `grep -c` 独立数残留的"single-agent"/"worker mode"/"same agent"措辞,偏差 >0 → ISSUES。
- **Claim Consistency**(audited 必填):report 声称的修改文件数 vs `git diff --stat` 实际。
- **互引一致性检查**:改后 glossary 的 Worker 定义 ↔ evidence-contract/landing-contract/scheduler-rules/worker-report 的引用,必须自洽(无残留旧叙事)。

## Human Decisions Needed

- 无(方向已在对话中确认:无 sub-agent 即中断,不退化)。

## Promise Registry

- (无跨 task 前向声明;P0 是单 task)
