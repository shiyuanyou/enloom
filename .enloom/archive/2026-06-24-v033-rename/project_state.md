# Enloom · 重命名阶段 project_state

> 本文件是 Enloom skill 自身生命周期的落地示范(dogfood)。隐藏在 `.enloom/` 下,用户项目里默认不可见——这正是 skill 落地时的预期形态。

## Current Phase

**Phase: v0.3.3 rename** — agentos-workflow v0.3.2 → Enloom v0.3.3。零功能改动,纯重命名 + 产品化重写 + 全局重装。单 agent 扮演控制面 + worker。

## Goal

把产品从 `AgentOS / agentos-workflow` 重命名为 `Enloom`,三层命名统一:
- 开发仓库: `agentos/` → `enloom/`
- Skill 内部 name: `agentos-workflow` → `enloom`
- Skill 产出目录: `AgentOS/` → `.enloom/`(隐藏)

定位: **A methodology for orchestrating complex AI work.**

## Anti Goal

- ~~不重跑 trigger-eval~~ → **已执行**(用户指示):trigger-eval re-run 完成,新 description 20/20,验证 rename 在 trigger 层面零功能改动。原 pending 闭合。
- 不动 description 的触发词覆盖(multi-stage/worker packets/evidence/archiving 等保留)
- 不做 compaction/操作记录松绑等设计优化(下一轮)
- 不动 design/ 历史、不冻结旧 `AgentOS/` 自举快照

## Active Tasks

| ID | Task | Status |
|----|------|--------|
| P1 | git mv agentos→enloom + 父级 README/AGENTS.md 引用 | ✅ completed |
| P2 | skill 源包 12 文件 name/desc/路径替换 | ✅ completed |
| P2-tail | skill 源包目录 `agentos-workflow-skill/` → `enloom-skill/`(git mv) | ✅ completed |
| P3 | 全局安装 agentos-workflow→enloom(删旧装新 + quick_validate) | ✅ completed |
| P4 | README 中英双语产品页 + PROGRESS v0.3.3 | ✅ completed |
| P5 | trigger-eval re-run(用户指示,原 Anti Goal 待办已闭合)| ✅ completed |

## Promised Outputs

| declarer | identifier | consumers | verify_at | status |
|----------|-----------|-----------|-----------|--------|
| P2 | SKILL.md frontmatter name=enloom | Stage 4 | Verify | ✅ fulfilled |
| P2 | skill 源包 0 处 `agentos-workflow`(除 report.md 历史路径) | Stage 4 | Verify | ✅ fulfilled |
| P3 | 全局 ~/.agents/skills/enloom/ 25 文件 | Stage 4 | Verify | ✅ fulfilled |

## Pending Dependencies

- (无)P2-tail 目录改名 + P3 全局重装均已完成。全局 `~/.agents/skills/` 现仅 `enloom/`(name: enloom,25 文件,evals/ 按设计剥离),旧 `agentos-workflow/` 已删,源/装逐字节一致(diff 仅 evals/ 之差)。

## Broken References

- **目录名已统一**: skill 源包目录已 `git mv` 为 `enloom-skill/`,README/PROGRESS 活跃引用已同步更新。(冻结区 `AgentOS/` 快照 + `design/` 旧路径引用不动,作历史证据。)

## Known Exceptions

- 旧 `AgentOS/` 自举快照(含大量旧名引用)→ **冻结保留**,不改。v0.3 历史快照,改了反而失真。
- `design/` 5 文件共 119 处 `AgentOS` 引用 → **冻结保留**,不改。设计文档是各时间点记录(v0.3-spec / v2 论文等),改名会篡改历史证据。

## Accepted With Risk

- description 改动使旧 trigger-eval 20/20 失效。**接受此风险**: 本轮标 pending,下次单独重跑拿 Enloom 版新基线。
- 全局重装已闭合:旧 `~/.agents/skills/agentos-workflow/` 已删,新 `~/.agents/skills/enloom/`(name: enloom)已装,源/装一致。源/装不一致风险消除。

## Rejected Reports

(none)

## Archived Phases

(none yet — Close 阶段写入)

## Ownership Table (this phase)

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/project_state.md` + Registry | 控制 agent 独占 |
| 并行写 | P1-P4 各批次产出 | 控制 agent 逐包串行 |
| 只读 | `design/` 历史、旧 `AgentOS/` 快照 | 谁都不改 |
