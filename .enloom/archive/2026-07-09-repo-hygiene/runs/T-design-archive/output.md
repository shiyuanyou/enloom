# Output: T-design-archive

改动摘要：将 `design/` 目录下 7 个已闭合设计文档（3,552 行）归档到 `design/_archive/`，并在 `design/` 顶层新建 `index.md` 解释归档状态。

## 改动清单

### 新建
- `design/_archive/` — 新目录
- `design/index.md` — 归档说明（唯一新建的文件，2,183 bytes）

### 移动（内容零修改，仅位置变更）
7 个文件从 `design/` 顶层移入 `design/_archive/`：
- `design-summary.md` (899 行)
- `art-lab-prompt-control-lessons.md` (576 行)
- `skill-reference-notes.md` (572 行)
- `skill-workflow-draft.md` (499 行)
- `v0.3-lifecycle-spec.md` (458 行)
- `2026-07-01-enloom-v0.5-optimization-design.md` (301 行)
- `v0.4-project-namespace-spec.md` (247 行)

### 未改动
- 文件内容：全部归档文件 SHA256 移动前后一致（见 report.md）。
- 禁碰区：`enloom-skill/**` / `README.md` / `PROGRESS.md` / `.enloom/**` 均未触碰。
- 未决问题文档：**无**。逐个检查 7 份文档，全部为闭合文档（版本规格已实现 / 教训已提取进 references），无 open question 保留在顶层。

## open-question 判定依据

逐文件检查每份文档的头/尾/未决标记：
- 三份版本规格（v0.3 / v0.4 / v0.5）状态均为「已逐节确认 / 评审完成」，且被后续版本引用为既定事实或已实现。
- `design-summary.md` / `skill-workflow-draft.md` 是 V1→V2 演化与 v0.1 草案，结论已固化进 SKILL.md / README.md，文末为定位结论非待决项。
- `art-lab-prompt-control-lessons.md` 教训已落地为 `references/prompt-control.md` 5 节，文末「诚实盲区」是记录不是待决问题。
- `skill-reference-notes.md` 外部调研，文末「第一轮只验证三件事」是已完成的 v0.1 验证范围。

全仓 `grep -niE 'open question|未决|待定|TBD|TODO|pending decision|unresolved'` 仅命中一处（`v0.3-lifecycle-spec.md:120` 描述 `Broken References` 检查范围，非待决问题）。

## 结果

| 指标 | before | after |
|---|---|---|
| `design/` 顶层 .md 数 | 7 | 1（index.md） |
| `design/_archive/` 文件数 | 0 | 7 |
| enloom-skill 对 design/ 引用 | 0 | 0（不变） |
