# Archive Entry: P1 — 元卫生清理 + 方法论缝隙修复

**Project**: repo-hygiene | **Phase**: P1 | **Closed**: 2026-07-09

## Completed

用 enloom 生命周期治理 enloom 开发仓库自身的元卫生。3 个并行 task（写集不相交）全部 PASS：

1. **T-skill-clean** — references 版本标注去 bloat (25→5) + glossary 重组（按版本分→按逻辑分）+ 两处方法论缝隙修复
2. **T-design-archive** — design/ 7 文件 (3552 行) 归档到 `design/_archive/`，顶层留 index.md
3. **T-progress-compact** — PROGRESS.md 249→80 行 (68%) + 新增 § Registry 未闭合风险 (6 条) + README §Status 压缩

## Outputs

- 8 references 文件改动（版本标注清理 + glossary 重组 + 缝隙补句）
- `design/_archive/` (7 文件) + `design/index.md`
- PROGRESS.md (80 行) + README.md (170 行) — 含 Registry 风险段
- installed skill `~/.agents/skills/enloom/` 已同步（8 references, 0 mismatch）

## Evidence

- Claim Consistency: 版本标注 25→5（独立 grep 重数 ✓）、glossary 31→31（✓）、文件 12（✓）、design 7→archive（✓）、PROGRESS 249→80（✓）
- 语义不变量: Five Laws 5/5 ✓、六阶段 7 refs ✓、Evidence Contract 4 要素 ✓、三态 verdict ✓
- Forbidden files: SKILL.md git diff empty ✓、templates read-only ✓
- quick_validate: PASS ✓

## Verification

三态 verdict: 3/3 PASS（独立 Claim Consistency 重数全部匹配，gate 条件全部满足）。
Review conclusion: 3/3 accepted。

## Decisions Updated

无新决策（方法论缝隙的补法在 task packet 中已确定，无 Human Decision Gate 需求）。

## Project State Updated

project_state.md 更新：Phase 1 标记完成，Active Tasks 3/3 accepted，compaction not triggered (55 lines)。

## Registry Updates

- **Accepted With Risk**: installed skill 已同步，但 trigger eval 未重新运行（本次改动不动 SKILL.md description，trigger 行为应不变，但未独立验证——属 Known Blind Spot）

## Open Risks Carried Forward

1. trigger eval 未重跑（description 未改，但 references 内容改动可能间接影响 host 加载行为——残留盲区）
2. glossary 术语数有两种口径（literal `^| \**` = 31 vs BRE `^\| \**` = 71）——非缺陷，两种口径 before/after 都守恒
3. `design/index.md` 的 README 目录树引用可能需要后续更新（README 目录树仍列 design/ 文件名——属 T-progress-compact 范围外的 follow-up）

## Raw Material Handling

runs/ 下 task.md / output.md / report.md / raw-notes 全部落盘，保留作过程证据。

## Next Step

- 可选: 跑一次 trigger eval 确认 description-only 行为不回归（消除 Accepted With Risk）
- 可选: README 目录树更新 design/ 新结构
- 本项目可关闭

## Archive conditions checklist

- [x] task packet exists (3/3)
- [x] output and report exist (3/3)
- [x] review result exists (3/3 — verdict + conclusion filled)
- [x] project_state updated
- [x] registry risk sections processed (Accepted With Risk: trigger eval pending)
- [x] raw material in runs/
- [x] compaction trigger checked (not triggered, 55 lines)
