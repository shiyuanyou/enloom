# design/ — 归档目录

本目录是 **enloom 设计文档的归档区**，不是活文档。这里的设计规格、演化总结、外部 skill 调研笔记均已实现或被提取，保留只为可追溯历史。

## 状态

`design/` 下的全部文档已闭合（closed）：

- 版本规格（v0.3 / v0.4 / v0.5 评审裁决版）均已实现，被后续版本超越。
- 教训/洞察已提取进 [`enloom-skill/references/`](../enloom-skill/references/)（`prompt-control.md`、`evidence-contract.md`、`landing-contract.md` 等）。
- V1→V2 演化与核心定位已进 `enloom-skill/SKILL.md` 与仓库 `README.md`。

live skill 对 `design/` 的引用数为 0（已 `grep -rl 'design/' enloom-skill/` 确认）。归档不删除、不改动任何文件，仅把闭合文档移入 `_archive/`。本次归档未发现任何含未决设计问题（open question）的文档——全部 7 份均为闭合文档，已移入 `_archive/`。

## 活文档去这里

- 设计纪律的活版本：[`enloom-skill/references/`](../enloom-skill/references/)
- 项目演进时间线：[`../PROGRESS.md`](../PROGRESS.md)
- 文件级历史：`git log -- design/_archive/<file>`

## 归档文件（design/_archive/）

| 文件 | 行数 | 闭合说明 |
|---|---|---|
| `design-summary.md` | 899 | V1→V2 演化 + 四种退化分析；核心洞察已进 SKILL.md / README.md。 |
| `art-lab-prompt-control-lessons.md` | 576 | art_lab .prompts 设计经验；教训已提取进 `references/prompt-control.md`（5 节）。 |
| `skill-reference-notes.md` | 572 | 外部 skill 生态调研笔记（skill-creator / llm-wiki / brainstorming 等）。 |
| `skill-workflow-draft.md` | 499 | v0.1 轻量 workflow 草案；后续 v0.3+ 已全面超越。 |
| `v0.3-lifecycle-spec.md` | 458 | v0.3 生命周期重组规格；已实现，被 v0.4/v0.5 超越。 |
| `2026-07-01-enloom-v0.5-optimization-design.md` | 301 | v0.5 评审裁决版（✅🟡⏸️❌ 逐条标记）；已实现。 |
| `v0.4-project-namespace-spec.md` | 247 | v0.4 项目级命名空间 + 落盘时序契约；已实现，被 v0.5 引用为既定事实。 |

共 7 文件，3,552 行。归档日期：2026-07-09。
