# project_state: repo-hygiene

> 用 enloom 治理 enloom 开发仓库自身的元卫生。这是最强 dogfood——用自己的机制治自己的 bloat。

## Current Phase

**Phase 1: 元卫生清理 + 方法论缝隙修复 — ✅ 完成 (closed 2026-07-09)**

3 个并行 task 全部 PASS，installed skill 已同步（8 references, 0 mismatch）。Archive entry 写入 `archive/P1-entry.md`。

### 交付物
- T-skill-clean: 版本标注 25→5 (剩 5 全在只读 templates/)，glossary 从按版本分 4 段→按逻辑分 4 组（术语不减），缝隙A（landing-contract dispatch 实现细节）+ 缝隙B（registry Promise scope 判别）补句充实。Five Laws/六阶段/Evidence Contract 语义不变，quick_validate PASS。
- T-design-archive: design/ 7 文件 (3552 行) → `design/_archive/`，顶层留 index.md。内容零修改。
- T-progress-compact: PROGRESS.md 249→80 行 (68% 压缩)，新增 § Registry 未闭合风险 (6 条)。README §Status 压缩，功能段不变，blind spot 强化。

### Compaction check
compaction not triggered: 55 lines / 0 archived results (project_state 远低于 ~200 阈值)

## Active Tasks

| Task | Status | Owner |
|------|--------|-------|
| T-skill-clean | ✅ accepted (PASS) | worker → control verified |
| T-design-archive | ✅ accepted (PASS) | worker → control verified |
| T-progress-compact | ✅ accepted (PASS) | worker → control verified |

## Promised Outputs

| declarer | identifier | consumers | verify_at | status |
|----------|-----------|-----------|-----------|--------|
| — | 无前向声明 | — | — | — |

## Pending Dependencies

无。三个 task 写不相交文件集。

## Broken References

无。

## Known Exceptions

- `AgentOS/` 冻结快照保留作历史证据——明确不动。
- `.enloom/` 旧 dogfood 项目目录保留——它们是各自版本的 dogfood 证据，非 bloat。

## Accepted With Risk

- ~~本次改动涉及全局安装的 skill。改后须重新同步到 `~/.agents/skills/enloom/` 并做 trigger eval 不回归确认。~~ **已闭合 (2026-07-09)**：installed skill 已同步；eval 套件整体删除（源仓库 + 已安装副本），trigger eval 不再适用。原 risk 项（trigger eval 未重跑）随套件删除直接关闭——要删的套件不回归。

## Rejected Reports

无。

---

## Archived Phases

- **P1 (2026-07-09)**: 元卫生清理 + 方法论缝隙修复。3/3 PASS, installed skill 同步。详见 `archive/P1-entry.md`。
