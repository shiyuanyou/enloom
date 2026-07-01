# Phase Plan: P1-v05

## Phase Goal

落地 v0.5 评审裁决版的 7 条改动 + 文档同步 + 零回归验证。源在 `enloom-skill/`,改完重装对齐 `~/.agents/skills/enloom/`。

## Anti Goal

- 不做 S3 / X1 / Pre-flight 阶段(Non-Goals)。
- 不改 Registry 七段 / Evidence 四要素硬约束 / Ownership 三阶 / 五铁律既有语义。
- 不动 description 触发词。

## Constraints

- **零回归**:S5 是定向加强,S4 拆档不改语义,S1 改框架不删旧机制——既有 v0.4 闸门表 + 落盘契约 + 硬约束必须全部语义不变。
- 改源后必须重装,源/装逐字节一致。
- **dogfood**:本 phase 实现过程自己遵守新闸门(S4 轻量档 + S5 compaction 检查)。

## Strategy

serial(单 agent 串行模式,scheduler-rules.md:53 已承认)。并行仅协议形式。

## Ownership Table

serial 执行,但所有权仍声明(协议形式):

| Resource / path | Tier | Writer | Stage |
|-----------------|------|--------|-------|
| `enloom-skill/references/*.md`(各任务独占的目标文件) | parallel-write zone(协议形式) | 对应 worker | Execute |
| `enloom-skill/references/evidence-contract.md` | serial-integration zone(多任务共写:X2+S1) | control agent 单线程 | Execute |
| `.enloom/2026-07-01-enloom-v05/*`(project_state/decisions/registry) | serial-integration zone | control agent | Integrate |
| 设计文档 + 已归档 v0.4 项目 | read-only zone | no one | All |

**关键串行约束**:`evidence-contract.md` 被 X2 和 S1 两个任务共写 → 这两个任务串行(X2 先,S1 后,或合并),禁止真并行写同一文件。

## Promise Registry Draft

(无前向声明——所有产出是就地改文件,不存在 worker A 引用 worker B 将产出的引用)

## Reference Tolerance Decision Table

> v0.5 新机制(S6)的预填:本 phase 的产物引用层容忍度。

| 引用类型 | 容忍悬空引用? | 处理 |
|----------|--------------|------|
| markdown 内部链接(`[x](ref.md)`) | 是 | 改后可验证(grep 目标存在);容忍中间态 |
| 设计文档 → reference 引用 | 是(已存在) | 读侧,不改设计文档 |
| 重装:源 → 装 路径 | 否(必须逐字节一致) | 强制 serial:改完源,重装一步到位,`diff` 验证 |

结论:本 phase 引用层基本容忍悬空(都是改既有文件),唯一强制 serial 的是「源/装一致性」——那是重装步骤,不是 worker 间引用。

## Tasks

按文件共写冲突 + 优先级分批。同一文件的多个改动合并为一个 worker 任务,避免写冲突:

- **T01(S5 高)**:改 `registry-and-compaction.md`(§4 触发措辞 必执行 + 阈值旁加"启发式非教条")+ `workflow-steps.md`(Stage 5 出口闸门加 compaction check)+ `landing-contract.md`(§1 闸门表 Stage 5 改措辞)。
- **T02(X2 高)**:改 `evidence-contract.md`(§Honest Blind Spot 扩三项)+ `scheduler-rules.md`(`:53` 附近回写虚拟并行盲区标记)+ `templates/worker-report.md`(Known Blind Spots 段对齐三项)。
- **T03(S4 中)**:改 `workflow-steps.md`(Health Check 拆两档)+ `landing-contract.md`(§4 health-check 执行方式改轻量档)。
- **T04(S1 中·改框架)**:改 `evidence-contract.md`(加第 5 维 report-vs-output claim 一致性 + 单 agent 退化边界声明)+ `review-checklist.md`(加计数自洽检查)+ `templates/task-packet.md`(Required Verification 段加 "Countable outputs" 字段)。
- **T05(S6 低)**:改 `templates/phase-plan.md`(加引用容忍度决策表)+ `registry-and-compaction.md` §3(引用此表)。
- **T06(S7 低)**:改 `templates/task-packet.md`(三模式差异化字段表)+ `scheduler-rules.md`(mode 选择指引更新)+ `workflow-steps.md` Stage 3(make-prompt 自检规则)。
- **T07(S2 低)**:改 `scheduler-rules.md`(加「新 domain 首 task 应为 recon」调度指引;无新阶段/字段/术语)。
- **T08(META)**:改 `glossary.md`(v0.5 新术语)+ `SKILL.md`(版本到 v0.5 + references 列表更新)+ `README.md`/`PROGRESS.md`(Status 段)。
- **T09(VAL)**:零回归核查 + 全局重装 + 结构验证(validation.md)。

**串行冲突注意**:
- `evidence-contract.md` 被 T02(X2)+ T04(S1)共写 → T04 在 T02 后执行,或合并。分两 worker 时 T04 读 T02 后的版本。
- `workflow-steps.md` 被 T01(S5)+ T03(S4)+ T06(S7)共写 → 严格按序:T01→T03→T06,或合并。
- `landing-contract.md` 被 T01(S5)+ T03(S4)共写 → T01→T03。
- `scheduler-rules.md` 被 T02(X2)+ T06(S7)+ T07(S2)共写 → T02→T07→T06 或合并。
- `templates/task-packet.md` 被 T04(S1)+ T06(S7)共写 → T04→T06。
- `registry-and-compaction.md` 被 T01(S5)+ T05(S6)共写 → T01→T05。

## Review Plan

每个 worker report 按 Evidence Contract 四要素验收;VAL 任务做全包零回归核查(五铁律/七段/硬约束/闸门表语义不变)。

## Human Decisions Needed

(无——评审已全部裁决;字段名统一用 "Claim Consistency Check" 而非 "Independent Verification",依据 S7 评审注)

## Gate Check

- Phase goal is clear: **yes**
- Acceptance criteria are clear: **yes**(每项对应 design §7 验证标准 1-10)
- Parallel ownership is defined if needed: yes(serial 执行,已声明串行约束)
- Promise Registry drafted if forward declarations exist: not-needed
- **Landing gate confirmed**: this phase-plan is written to `tasks/phase-plan-P1.md` (Stage 2 exit gate — see landing-contract.md §1): **yes**
