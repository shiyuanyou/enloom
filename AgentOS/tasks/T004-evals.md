# Task Packet: T004

Task Packet Version: 0.1
Mode: recorded
Role: coder

## Goal

产出 `agentos-workflow-skill/evals/evals.json`(6 case,按 skill-creator schema)+ `references/eval-guide.md`(说明手工/自动两种 eval 路径)。这是 v0.2 闭环核心,也是 report.md:64 / PROGRESS.md:39 明确的 deferred 项。

## Anti Goal

- 不写自动 eval runner(依赖外部 claude -p,环境不支持)。
- 不把 eval prompt 写成会触发 Non-Goals 的任务(如调度器、CLI)。
- 不在 evals.json 里夹带非 schema 字段。

## Writable Files

- `agentos-workflow-skill/evals/evals.json`
- `agentos-workflow-skill/references/eval-guide.md`

## Forbidden Files

- SKILL.md(已在 T002 加指针指向 eval-guide.md)
- 其他 references / templates / prompt-assets

## Acceptance Criteria

- evals.json 是合法 JSON,符合 skill-creator schema(skill_name + evals[] with id/prompt/expected_output/expectations)。
- 6 case 覆盖 ref-notes:428-436:复杂→agentos / 简单 bug→direct / 一次性脚本→direct / 多 worker 强依赖→serial / report 缺 evidence→needs-rework / output 太长→要求压缩。
- eval-guide.md 说明手工版(本次 T005 用)和自动版(需 claude -p)两条路径。
- skill_name = agentos-workflow(对齐 frontmatter)。

## Done Signal

`done` + JSON 校验输出。