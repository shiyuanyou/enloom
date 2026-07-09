# Task Packet: T002

Task Packet Version: 0.1
Mode: recorded
Role: coder

## Goal

补充 `agentos-workflow-skill/references/` 下 5 个被 design 文档建议但尚未存在的 reference 文件,让 SKILL.md 的细节外指更完整。

## Anti Goal

- 不改现有 5 个模板和 workflow-steps.md。
- 不重复 workflow-steps.md 已有内容(只做外指与补充)。
- 不写 design 已否决的内容(Non-Goals:CLI/scheduler/auto runtime)。
- 不长篇大论(每文件 <120 行)。

## Writable Files

- `agentos-workflow-skill/references/trigger-contract.md`
- `agentos-workflow-skill/references/glossary.md`
- `agentos-workflow-skill/references/scheduler-rules.md`
- `agentos-workflow-skill/references/review-checklist.md`
- `agentos-workflow-skill/references/archive-policy.md`
- `agentos-workflow-skill/SKILL.md`(仅加指针,不改现有操作定义)

## Forbidden Files

- 现有 5 个 templates、workflow-steps.md、examples/
- prompt-assets/、evals/(T003/T004 范围)
- README.md、PROGRESS.md、design/

## Acceptance Criteria

- 5 个新文件存在,每个 <120 行。
- SKILL.md 增加指向新 reference 的指针。
- 无与 workflow-steps.md 重复的概念定义(用 `rg` 验证)。

## Done Signal

`done` + 文件清单。