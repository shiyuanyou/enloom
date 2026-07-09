# Phase Plan: P1 — 元卫生清理 + 方法论缝隙修复

## Phase Goal

用 enloom 治理 enloom 开发仓库自身：清理 references 版本标注 bloat、归档 design/ 死代码、压缩 PROGRESS.md 历史、补两处实战暴露的方法论缝隙。改完后 skill 更精简、更易读，且无功能回归。

## Anti Goal

- 不改五铁律语义、六阶段骨架、Evidence Contract 四要素
- 不改 trigger description（trigger eval 20/20 须保持）
- 不动 AgentOS/ 冻结快照
- 不为了形式改而改——每个改动有明确收益理由
- 不删 glossary 的任何术语条目（只重组结构，去版本分段）

## Constraints

- 全局安装副本 (`~/.agents/skills/enloom/`) 须与源同步
- 改 references 时保留 wikilink 锚点（`#section` 链接），不破坏交叉引用
- 改后须验证：references 文件计数不变（不丢文件）、关键内容标记存活、skill 能正常加载

## Strategy

parallel (3 个写不相交文件集的 task)

## Ownership Table

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| `enloom-skill/references/*.md` (10 文件) | parallel-write zone | T-skill-clean 独占 | Execute |
| `enloom-skill/references/templates/*.md` | read-only (T-skill-clean 可能查但不改) | no one | All |
| `design/*.md` + `design/_archive/` (new) | parallel-write zone | T-design-archive 独占 | Execute |
| `README.md` + `PROGRESS.md` | serial-integration zone | T-progress-compact (control) | Integrate |
| `.enloom/2026-07-09-repo-hygiene/*` | serial-integration zone | control agent | Integrate |
| `~/.agents/skills/enloom/` | serial-integration zone | control agent (post-verify sync) | Integrate |

写集互不相交验证：
- T-skill-clean → `enloom-skill/references/*.md` (+ glossary.md 在 references/ 内)
- T-design-archive → `design/` (完全独立目录)
- T-progress-compact → `README.md` + `PROGRESS.md` (顶层，skill 包外)
三集合 = ∅ 交集 → 真正并行安全。

## Reference Tolerance Decision Table

| Reference type | Tolerates dangling? | Forces serial? |
|----------------|---------------------|----------------|
| markdown `[x](path.md)` cross-refs in references | yes (grep target at verify) | no |

## Promise Registry Draft

无前向声明。

## Tasks

- T-skill-clean: references 去版本标注 bloat + glossary 重组 + 缝隙A/B 修复
- T-design-archive: design/ 3552 行归档到 design/_archive/
- T-progress-compact: PROGRESS.md 历史段 compaction + README 状态更新

## Review Plan

每个 task 按 Evidence Contract review：
- T-skill-clean: 版本标注计数归零或仅留必要、glossary 单段不分版本、缝隙句已加、文件计数不变、内容标记存活、交叉引用锚点不破
- T-design-archive: design/_archive/ 存在、原 design/ 顶层仅保留 index 或清空、live skill 零引用（已确认）
- T-progress-compact: PROGRESS.md 行数下降、当前状态段完整、历史归档可追溯

## Human Decisions Needed

- **recon decision**: 已有把握（audit-followup 已完整诊断，所有改动点已定位）→ no，跳过

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes
- Parallel ownership is defined if needed: yes (3 disjoint write sets)
- Promise Registry drafted if forward declarations exist: not-needed
- recon considered: yes (已判定 no)
- **Landing gate confirmed**: this phase-plan is written to tasks/phase-plan-P1.md: yes
