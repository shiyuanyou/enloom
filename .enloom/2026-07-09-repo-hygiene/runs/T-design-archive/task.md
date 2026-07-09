# Task Packet: T-design-archive

Task Packet Version: 0.2
Mode: recorded
Role: coder

## Goal

将 `design/` 目录 3,552 行设计文档归档。这些文档的教训已被提取进 `enloom-skill/references/`，live skill 对 design/ 的引用数为 0（已 grep 确认）。它们是 enloom 自己定义的"已闭合过程细节"，该 compaction 进 archive。

## Anti Goal

- 不删任何文件（归档不是删除，是移到 archive 子目录）
- 不改任何文件内容（只移动位置）
- 如果某 design 文档含**未决的设计问题**（open question），保留在 design/ 顶层不归档——遵循"绝不压缩未闭合风险"

## Inputs

- `design/` 7 个文件：
  - design-summary.md (899 行) — V1→V2 演化 + 四种退化分析。核心洞察已进 SKILL.md/README。
  - art-lab-prompt-control-lessons.md (576 行) — 教训已提取进 prompt-control.md reference。
  - skill-reference-notes.md (572 行) — 外部 skill 调研笔记。
  - skill-workflow-draft.md (499 行) — v0.1 草案。
  - v0.3-lifecycle-spec.md (458 行) — v0.3 设计规格，已实现。
  - 2026-07-01-enloom-v0.5-optimization-design.md (301 行) — v0.5 评审裁决版，已实现。
  - v0.4-project-namespace-spec.md (247 行) — v0.4 设计规格，已实现。

## Existing State

design/ 当前在仓库顶层，7 文件。live skill (enloom-skill/) 对 design/ 引用 = 0。
README.md 有 3 处链接指向 design/（§Status 段历史链接 + §Directory 树）。

## Allowed Tools

Read / Bash(mv, mkdir, ls, grep)

## Writable Files

- `design/` 目录下（创建 `design/_archive/`，移动文件）

## Forbidden Files

- `enloom-skill/**`（不碰 skill 包）
- `README.md` / `PROGRESS.md`（T-progress-compact 管）
- `.enloom/**`（control 管）

## Output Files

- `design/_archive/` 新目录，含被归档的文件
- `design/README.md` 或 `design/index.md`（新建，1 个文件）——解释 design/ 现在是 archive，列出归档文件，指向 enloom-skill/references/ 作为活文档

## Acceptance Criteria

1. `design/_archive/` 存在
2. 已闭合的设计文档移入 `design/_archive/`
3. `design/` 顶层有一个 index 文件解释归档状态 + 指向 enloom-skill/references/
4. 被归档的文件**内容零修改**（`diff` 确认）
5. 如果发现含未决问题的文档，保留在 design/ 顶层并在 index 中标注

## Required Verification

- `ls design/_archive/` → 归档文件列表
- `ls design/*.md` → 顶层仅 index（+ 任何保留的未决问题文档）
- 归档前后文件内容对比：`diff design/_archive/X.md <原X.md>` → 无差异（用 git 或移动前后对比）
- `grep -rl 'design/' enloom-skill/` → 仍为 0（live skill 不引用）

## Countable outputs

- design/ 顶层文件数（before: 7 / after: 1 index + 可能的未决项）
- design/_archive/ 文件数（after）

## Evidence Required

ls 输出 + diff 确认零修改。

## Review Budget

report.md 必读。

## Done Signal

`done` + report.md，含：归档了哪些文件、保留顶层的是什么及理由、index 文件路径。
