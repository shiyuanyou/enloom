# Phase Plan: Phase 1 — clear-mind 三层轻量对齐 dispatch-default

## Phase Goal

按 clear-mind 自审裁决(`.clear-mind/2026-07-06-clearmind-align-v06/review.md`,WORTH-IT),把 clear-mind skill 在三层轻量对齐 enloom v0.6 dispatch-default posture:(1)叙事层——explore gather 默认重述为"dispatch 首选/内联原生",软化"降级";(2)接口层——Handoff + trigger-contract 反映 enloom 现是 dispatch-default;(3)命名层——trigger-contract 一处显式 clear-mind 角色。不动运行时默认,保留独立可用性。完成后 git 提交 + push。

## Anti Goal

- 不翻转 explore 运行时默认为模式 A(破独立可用性)。
- 不引入 .enloom/ 暗检测。
- 不全 skill 引 control agent。
- 不改 plan/review 内联。
- 不改 enloom skill 文件。
- 不动 honest-limitations §X.1 的"单 agent"框定(那是裁决独立性维度,非执行 dispatch;超出本 phase 范围,留为可选后续)。

## Constraints

- 源文件直接在 `~/.agents/skills/clear-mind/` 编辑(clear-mind 无源/副本双份,不像 enloom)。
- enloom 仓库提交内容:`.enloom/2026-07-06-clearmind-align/`(工作记录)+ `.clear-mind/2026-07-06-clearmind-align-v06/`(裁决记录,已存在)。
- clear-mind 源改动(~/.agents)不在 enloom 仓库内,本 phase 只在 enloom 仓库记录工作过程;源文件改动直接落盘 ~/.agents。

## Strategy

serial。三层改动同性质(文档对齐),1 个 task packet 全包。

## Ownership Table

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/2026-07-06-clearmind-align/project_state.md` | control agent 独占 |
| 并行写 | `~/.agents/skills/clear-mind/` 下被改文件 | P1-worker 独占 |
| 只读 | enloom skill 文件、design/ 历史、其他 clear-mind 未列文件 | 谁都不改 |

## Tasks

| ID | Task | Mode |
|----|------|------|
| P1-align | 三层轻量对齐 clear-mind skill 文件 + grep 自检 | audited |

## Review Plan

- grep "降级" 在 explore 上下文 → 应从 ~3 处降为 0-1 处(或转为中性表述)
- grep "模式 B" 附近不再单方面暗示"劣/ fallback"
- trigger-contract §explore + §与执行编排边界 含 dispatch-default 时代重述
- SKILL.md explore 行 + Handoff 段反映新 posture
- review-template Handoff 含 enloom dispatch-default 一句
- 独立可用性未破:clear-mind 仍能无 enloom 跑(叙事未引入硬依赖)
- Claim Consistency:声称 N 文件改动,git diff --stat 独立复核

## Human Decisions

- (无)
