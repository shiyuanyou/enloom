# Phase Plan: v0.3-implementation

## Phase Goal

实现 v0.3 spec 全部文件变动:生命周期主架重写 + 五块经验内化(Registry / Evidence Contract / Ownership+Promise / Compaction / Audit)落成通用文件协议。spec 第 6a 节文件变动清单逐条交付。

## Anti Goal

- 不引入 scheduler / CLI / model resolver / 自动 worker runtime(Non-Goals 守线)。
- 不把 art_lab 的 wiki 领域专属命令放进主干模板——只进 worked example。
- 不推倒目录骨架;内容层大改,结构连续。
- 不假装解决单 agent worker 隔离——诚实记录此盲区。

## Constraints

- 串行执行(单 agent 环境,无真并行)。
- 每个文件改动对照 spec 第 6a 节逐条核对,无遗漏无矛盾。
- 改动只在 `agentos/` 内。

## Strategy

serial(单 agent 会话现实;声明所有权表满足铁律 3 形式)。

## Ownership Table

并行 dispatch 时必填。本 phase 串行执行,表作为纪律声明:

| 资源/路径 | 阶 | 可写者 | 阶段 |
|-----------|-----|--------|------|
| SKILL.md / workflow-steps.md / glossary.md | 串行集成区 | T007(control)独占 | Execute |
| evidence-contract.md / registry-and-compaction.md | 并行写区(各自独占新文件) | T008 独占 | Execute |
| audit-task-packet.md / art-lab-worked-example.md | 并行写区(各自独占新文件) | T009 独占 | Execute |
| templates/project-state/phase-plan/task-packet/worker-report | 串行集成区(4 文件改) | T010 独占 | Execute |
| trigger-contract/scheduler-rules/review-checklist/archive-policy | 并行写区(各自独占) | T011 独占 | Execute |
| evals.json / prompt-assets/* | 串行集成区 | T012 独占 | Execute |
| design/v0.3-lifecycle-spec.md | 只读区 | 无人(只读输入) | 全程 |
| AgentOS/project_state.md / decisions.md | 串行集成区 | control agent 独占 | Integrate |

## Tasks

- T007: SKILL.md + workflow-steps.md + glossary.md(生命周期主架重写)
- T008: evidence-contract.md + registry-and-compaction.md(核心新增 reference)
- T009: audit-task-packet.md + art-lab-worked-example.md(audit 模板 + worked example)
- T010: 4 templates 扩展(project-state / phase-plan / task-packet / worker-report)
- T011: 4 references 更新(trigger-contract / scheduler-rules / review-checklist / archive-policy)
- T012: evals.json 加 3 case + prompt-assets 微调

## Review Plan

Verify 阶段(T007–T012 完成后):
- 跑 validation.md 结构校验(bash 实现:SKILL.md frontmatter)。
- 逐文件 evidence audit:对照 spec 第 6a 节 17 行变动清单,逐条核对「改动是否落地 + 内容是否对齐该节来源」。
- 对照 spec 验收标准 6 条。

## Human Decisions Needed

- (已在 plan 确认,无需进一步决策)

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes(spec 第 6a 节文件变动清单 + 验收标准)
- Parallel ownership is defined if needed: yes(声明式,串行执行)
