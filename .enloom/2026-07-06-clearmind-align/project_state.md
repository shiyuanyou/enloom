# clearmind-align · project_state

> 目标:clear-mind skill 对齐 enloom v0.6 dispatch-default posture。源裁决见 `.clear-mind/2026-07-06-clearmind-align-v06/review.md`(WORTH-IT)。

## Goal

把 clear-mind skill 在叙事/接口/命名三层轻量对齐 enloom v0.6 dispatch-default posture,不动 explore gather 运行时默认(仍内联),保留独立可用性。对齐标准="各自默认有理由 + 交叉引用清晰",非"默认姿态统一"。

## Current Phase

**Phase: 1 — 三层轻量对齐(CLOSED, 待 archive)**。clear-mind 自审(explore→plan→review)闭合裁决 WORTH-IT;执行层 dispatch sub-agent 完成 4 文件 6 处编辑 + control agent 自修 ASCII 图残留 1 处;Verify PASS(6 项 grep 独立复核通过,独立可用性未破,control agent 未误入 SKILL/glossary)。三层对齐落地:叙事(explore 默认重述为"运行时默认内联=独立可用性约束,dispatch 首选")+ 接口(Handoff 反映 enloom v0.6 dispatch-default)+ 命名(trigger-contract 一处显式 clear-mind 角色=裁决者)。

## Anti Goal

- 不翻转 explore gather 运行时默认(破坏独立可用性,PRIMARY CONSTRAINT)。
- 不引入 .enloom/ 暗检测(clear-mind 已自证反模式)。
- 不全 skill 引入 control agent 角色名(clear-mind 非 orchestrator)。
- 不改 plan/review 内联(编排层判断,非 worker 活)。
- 不动 enloom skill 文件(本 phase 只改 clear-mind)。

## Constraints

- **源/副本同步**:Writable 指向 `~/.agents/skills/clear-mind/`(源)。改完后 worker 须 cp 同步到 enloom 仓库内无(注:clear-mind 源在 ~/.agents,不在 enloom 仓库;本 phase 只改 ~/.agents 源,改完提交的是 enloom 仓库的 .enloom/ 工作记录 + .clear-mind/ 裁决记录,clear-mind 源文件改动通过 git 在 ~/.agents 或直接落盘)。实际:clear-mind 源直接在 ~/.agents/skills/clear-mind/ 编辑,无需副本同步(clear-mind 不像 enloom 有源/副本双份)。
- 三层改动同性质(文档对齐),1 个 task packet 全包,serial。

## Accepted Results

- **P1-align (PASS, accepted)**:clear-mind skill 4 文件对齐 enloom v0.6 dispatch-default。叙事层:trigger-contract.md:38(explore 默认重述"运行时默认模式 B=独立可用性约束")+ explore-method.md:87(叙事框定段)+ :109(模式 B 标题"降级但可用"→"独立 skill 的原生模式")+ :45(ASCII 图"内联降级"→"内联,运行时默认内联",control agent 自修)。接口层:SKILL.md:31(gather 行)+ :73(Handoff 补 v0.6 dispatch-default)+ review.md:90(Handoff 同)。命名层:trigger-contract.md:68(clear-mind 角色=裁决者,显式不使用 control agent)。运行时默认未翻转,独立可用性保留。

## Registry

### Active Tasks

| ID | Task | Status |
|----|------|--------|
| P1-align | 三层轻量对齐:叙事(trigger-contract/explore-method/SKILL.md)+ 接口(review-template)+ 命名(trigger-contract 一处)+ grep 自检 + 提交 push | ✅ completed (PASS) |

### Promised Outputs

| declarer | identifier | consumers | verify_at | status |
|----------|-----------|-----------|-----------|--------|
| P1-align | trigger-contract explore 段重述默认 + 拒暗检测理由保留 | Verify | Verify | ✅ fulfilled |
| P1-align | explore-method "降级"软化 + 模式 A/B 平级重框 | Verify | Verify | ✅ fulfilled |
| P1-align | SKILL.md explore 行 + Handoff 段反映 dispatch-default | Verify | Verify | ✅ fulfilled |
| P1-align | review-template Handoff 补 enloom dispatch-default 一句 | Verify | Verify | ✅ fulfilled |

### Pending Dependencies

- (无)

### Broken References

- (无)

### Known Exceptions

- (无)

### Accepted With Risk

- (无)

### Rejected Reports

- (无)

## Archived Phases

- **Phase 1 (P1-align)** — clear-mind 三层轻量对齐 dispatch-default,2026-07-06 closed。结论:叙事/接口/命名三层落地,运行时默认未翻转,独立可用性保留;control agent 自修 ASCII 图残留升 PASS。详见 `archive/phase-1-entry.md`。

> compaction not triggered: ~75 lines / 1 archived result(远低于阈值)。

## Human Decisions Needed

- (无,裁决已由 clear-mind review.md 给出 WORTH-IT,直接执行)

## Next Review Point

- Verify 阶段:grep 验证"降级"在 explore 上下文减少 + 读 trigger-contract + enloom landing-contract §5 不觉矛盾 + 独立可用性未破(clear-mind 仍能无 enloom 跑)。
