# Decisions: skill-quality-convergence

## D001 — Contract first, metadata last

- **Status**: accepted for planning
- **Decision**: 先修 Evidence/Lifecycle/Ownership 等行为契约，最后再改 `description`。
- **Why**: description 只决定是否加载 skill，不能修复加载后的自相矛盾；过早优化会让 trigger 分数掩盖行为缺陷。

## D002 — One semantic cluster per phase

- **Status**: accepted for planning
- **Decision**: 每个 phase 只处理一个依赖闭合的语义簇，并在 phase 边界 review、提交、同步。
- **Why**: 让回归范围、责任文件和 rollback 点保持可判断，避免一次性重写 20 多个 Markdown 文件。

## D003 — Preserve invariants, clarify semantics

- **Status**: accepted for planning
- **Decision**: 保留 Five Laws、生命周期骨架意图和 Evidence Contract 四个字段名；允许修正其互相矛盾的定义、执行者和 gate 语义。
- **Why**: AGENTS.md 禁止随意改方法论不变量，但当前缺陷主要是同一不变量在多处被写成不同规则，不需要推倒重来。

## D004 — Historical evidence remains immutable

- **Status**: accepted
- **Decision**: `design/_archive/**` 与 `.enloom/archive/**` 只读。历史报告即使暴露旧流程缺陷，也只作为新版本测试输入，不回写修饰。

## D005 — Evaluations are execution evidence, not a permanent suite

- **Status**: accepted for planning
- **Decision**: P6 使用少量真实行为样例、旧版快照对比和 P5 trigger near-miss 集；产物落本项目 `runs/` 或临时工作区，不重新引入长期维护的 repo eval 目录。

## D006 — Provisional canonical choices for P0 adjudication

以下是默认方向，不在 P0 review 通过前写入 live skill：

1. **Lifecycle naming**：Triage 是 Stage 0 入口决策，后面是六个执行阶段；统一写成“Stage 0 Triage + six-stage lifecycle”。
2. **Evidence**：`Required Checks Not Run` 会阻止 PASS；`Known Limitations` 可在风险已声明且不违反必检时与 PASS 共存。
3. **Review ownership**：reviewer worker 只返回 verdict/conclusion/registry proposals；control 串行写 Review Result 和 Registry。
4. **Dispatch gate**：`make-prompt` 在 dispatch 之前产出 `task.md`；Stage 3 不再用尚未生成的文件作为自身循环入口。
5. **Runtime**：Enloom full mode 仍要求独立 sub-agent，但要在 metadata/compatibility 明示；是否真并发由 runtime capability 决定并按实际记录。
6. **Fold**：不在 Triage 判定前自动产生 mv 副作用；task_board 必须能解析 active/archive 位置。
7. **Validation**：官方 validator 可用时优先使用；shell fallback 只承诺它实际验证的 flat-frontmatter 子集。
8. **Prompt assets**：SKILL.md 提供 role→asset 加载路由；不默认复制一份到每个项目目录。

## D007 — P0 canonical contract freeze accepted

- **Status**: accepted 2026-07-10
- **Decision**: 采纳 T-P0-02 两轮 amendment 后的 14 条 canonical rules，作为 P1–P6 的唯一契约输入；T-P0-03 最终独立 recheck 为 `PASS / accepted`。D006 八项按 matrix adjudication 生效，但仍不等于 live 文件已修改。
- **Evidence**: T-P0-01 `report.md` final `PASS/accepted`；T-P0-02 `report.md` 的 rework-2 Review Result `PASS/accepted`；T-P0-03 `report.md` 的 Final Recheck Review Result `PASS/accepted`。原始 FAIL/rework 前缀保留在各 run 作为历史证据。
- **Resolved high blockers**: RA1.2 status tuple totality；RA2 Verify-worker V0→V3 termination；RA3 `report.md`/`review-result.md` file-level ownership split；RA4.2 resolver operation-intent precedence and no-move invalid effects。
- **Carried risk**: runtime dispatch/move/validator/install/renderer/trigger evidence remains assigned to P1–P6; no live skill or installed copy changed in P0.
