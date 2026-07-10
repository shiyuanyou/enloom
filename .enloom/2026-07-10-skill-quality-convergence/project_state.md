# project_state: skill-quality-convergence

## Goal

把 2026-07-10 质量 review 发现的问题按依赖顺序逐步收敛：先消除核心契约矛盾，再修执行边界和运行时适配，最后处理 description、文案与发布体验；每一阶段都独立 review、验证、提交和同步，不做大爆炸式重写。

## Current Phase

**P2 — Lifecycle/Dispatch/Fold 去环化：accepted 2026-07-10；P3 未开始。**

- T-P2-01（PASS/accepted）：重写 landing-contract.md + archive-policy.md owner——C03 Stage 3 entry = phase plan（task.md 变为 pre-dispatch gate，消除循环入口）；C06 health-check 两轴（periodic homes vs transition executor）；RA2 V0→V3 Verify-worker 非递归四态；C04 Triage 无副作用 + fold 移到 enloom 决定后 + control-owned；RA4/RA4.2 resolver 7 级 precedence + fold-move-state.md 快照 + PROJECT_OPERATION_INVALID。
- T-P2-02（PASS/accepted）：4 个 consumer 对齐——workflow-steps / SKILL / glossary / AGENTS 全部更新 fold 时序、Stage 3 entry gate、RA2 引用、C05 phrase guard。
- Source/installed parity 验证通过（`diff -qr` exit 0）。
- Exit Gate：circular entry residue = 0；old fold timing residue = 0；RA2 states = 4；RA4 enums = 6 error + 3 success；C05 phrase guard = 2/2/2 per file。
- Compaction check：未触发（state ~120 lines，Accepted Results 7，低于阈值）。

### Progressive Convergence Ladder

| Phase | 收敛对象 | 退出条件 |
|---|---|---|
| **P0** | 当前事实重验 + 关键语义裁决 | 每个 finding 有 canonical rule、owner 文件、验证方式；独立 reviewer 接受 |
| **P1** | Evidence Contract 与 verdict/review conclusion | `PASS/ISSUES/FAIL` 可唯一判定；必检未跑与结构性盲区分离；模板一致 |
| **P2** | Lifecycle、landing gates、Stage 3、fold 时序 | 状态机无循环入口；无 trigger 前无副作用；gate 类型和执行者明确 |
| **P3** | Worker/reviewer/audit ownership、runtime capability、prompt-assets | control/worker 写权唯一；并发按能力声明；role→asset 路由可执行 |
| **P4** | Namespace、fold 后定位、validation 与机械链接 | archived project 可定位；validator 承诺与实现一致；结构检查全绿 |
| **P5** | `description`、阶段命名、README/PROGRESS/Install 文本 | 入口元数据与稳定后的契约一致；近失配 trigger 集通过 |
| **P6** | 真实任务 dogfood、旧版基线对比、同步与关闭 | 行为样例通过；无高风险 Registry 项；源/副本一致；归档闭合 |

### Convergence Gates

1. 一次只修一个语义簇；后续 phase 不提前夹带修改。
2. 每 phase：task packet → worker 落盘 → report-first review → 独立验证 → project_state/Registry 更新。
3. `FAIL` 留在原 phase rework；`ISSUES` 只有风险明确登记且不影响下一 phase 前置条件时才能继续。
4. 每个实现 phase 通过后形成一个可回滚 commit；未 PASS 不提交。
5. 修改源 skill 后，同一 phase Integrate 必须同步安装副本并核对 `diff -qr`；行为测试使用已同步版本。
6. description 和 trigger 优化放到核心行为稳定以后，避免用元数据掩盖契约问题。
7. skill-creator 的行为/trigger eval 作为临时执行证据放在本项目 `runs/` 或临时工作区，不恢复永久 eval 套件。

## Accepted Results

- T-P0-01（PASS/accepted）：当前 HEAD baseline audit，8 domains、17 findings、3 份 dogfood gate audit，证据与边界 hash 完整；见 `runs/T-P0-01/`。
- T-P0-02（PASS/accepted）：14 canonical rules、17 finding coverage、D006 8 项、Evidence/lifecycle/ownership/namespace/validation fixtures 与 P1–P6 graph；两轮 amendment 及独立 recheck 均保留；见 `runs/T-P0-02/`。
- T-P0-03（PASS/accepted）：独立 adversarial review 初次发现 4 个 high blocker，rework 后再次发现 2 个 high blocker，最终 recheck 全部关闭；所有 FAIL 前缀保留为历史证据；见 `runs/T-P0-03/`。
- T-P1-01（PASS/accepted）：evidence-contract.md owner 重写，C01/C02/RA1/RA1.2 全部落地；见 `runs/T-P1-01/`。
- T-P1-02（PASS/accepted）：8 个 consumer 文件对齐 owner §Verdict Decision Function 和 C02 disjoint 语义；见 `runs/T-P1-02/`。
- T-P2-01（PASS/accepted）：landing-contract + archive-policy owner 重写，C03/C04/C06/RA2/RA4/RA4.2 全落地；见 `runs/T-P2-01/`。
- T-P2-02（PASS/accepted）：4 consumer 对齐 fold 时序、Stage 3 entry gate、RA2 引用、C05 phrase guard；见 `runs/T-P2-02/`。

## Registry

### Active Tasks

| Task | Status | Note |
|---|---|---|
| P0 phase plan | completed | P0 accepted；archive entry 已落盘 |
| T-P0-01 | accepted | PASS；8/17/3 counts delta 0，live boundary clean |
| T-P0-02 | accepted | PASS；14 rules；两轮 rework 后 high blockers=0 |
| T-P0-03 | accepted | 独立 final recheck PASS；历史 FAIL/rework 前缀保留 |
| P1 phase plan | completed | P1 accepted；archive entry 已落盘 |
| T-P1-01 | accepted | PASS；owner 重写，C01/C02/RA1/RA1.2 全落地 |
| T-P1-02 | accepted | PASS；8 consumer 对齐，legacy residue 0 |
| P2 phase plan | completed | P2 accepted；archive entry 已落盘 |
| T-P2-01 | accepted | PASS；landing+archive owner 重写，C03/C04/C06/RA2/RA4 全落地 |
| T-P2-02 | accepted | PASS；4 consumer 对齐，fold timing + Stage 3 entry + RA2 + C05 guard |

### Promised Outputs

无。P0 串行，不做跨 worker 前向声明。

### Pending Dependencies

- P3 必须冻结 durable ownership（C07/RA3 file-level split）、runtime capability 记录（C08）、role-to-asset 路由（C09）；C03/C04/C06 已落地为 P2 的前置条件。
- P4/P5/P6 按 T-P0-02 graph 串行推进；任何实现 phase 未 PASS 不得提交或进入下一 phase。
- P3/P5 的 host-native prompt、runtime capability、跨模型 trigger 证据取决于可用 runtime；不可用时必须标成未验证。
- P4/P5 的 validator、install command、renderer 与目录 move recovery 仍需执行证据；不能用静态矩阵冒充运行通过。

### Broken References

- **open / P4 owner C13**：`enloom-skill/references/templates/task-packet.md` 与 `worker-report.md` 各一处 `§` 被写入 Markdown target；P0 已定 owner 为 `references/validation.md`，尚未修 live。
- **open / P4 owner C10**：fold 后 task_board 顶层 resolver 无法唯一定位 archive project；需按 RA4 error enum/两 root 规则实现。
- **open / P4 owner C11**：validation reference 宣称的 full YAML contract 与 flat fallback 实现边界尚未落地。
- **superseded**：phase-plan 的 ``[x](path)`` 位于 code span，不是 live link；不进入修复队列，历史假设保留在 T-P0-01 output。

### Known Exceptions

- `design/_archive/**`、`.enloom/archive/**` 是冻结历史证据，修复 live contract 时不回写历史正文。
- 不维护永久独立 eval 套件；本轮使用临时行为证据和真实 dogfood。
- T-P0-02 `report.md` 为 233 行，超过 packet 建议的 200 行 soft budget；为保留两轮 amendment/FAIL 历史而有意不删，详细过程仍隔离在 `runs/`，不进入主窗口。

### Accepted With Risk

- P0 只证明静态 contract totality/ownership/state-machine 可判定；Stage 4 runtime dispatch、filesystem move、validator、install、renderer、host prompt 与 trigger 行为尚未执行。
- C08/C09/C11/C14 与 F-D7-02 的 runtime/host evidence gap 按 P3–P6 graph 携带；C05 phrase guard 在 P2 作为不变量，广泛命名清理仍后置 P5。
- shared workspace 与 model/session ancestry 不提供 process/model isolation；hash/status 只能检测边界漂移，不能证明无 interleaving race。
- T-P0-03 两次 FAIL/rework 是已闭合过程证据，不视为 accepted defect；原始 report/output 不回写。

### Rejected Reports

无永久 rejected report；T-P0-03 首次与二次 `FAIL / needs-rework` 已按 failure protocol rework 并保留在 `runs/`，最终独立 recheck PASS。

## Archived Phases

- P0 done 2026-07-10, `accepted`; canonical matrix + independent adversarial closure 见 `archive/P0-entry.md`。
- P1 done 2026-07-10, `accepted`; Evidence Contract totality + consumer alignment 见 `archive/P1-entry.md`。
- P2 done 2026-07-10, `accepted`; lifecycle/dispatch/fold 去环化 + consumer alignment 见 `archive/P2-entry.md`。

## Human Decisions Needed

- P0 无阻塞决策；D006 八项已由 T-P0-02 adjudication 形成 accepted P0 contract input。
- P5 进入 trigger 优化前，用户需要 review 一次 should-trigger / should-not-trigger 样例集。

## Next Review Point

P3 phase plan/packet review；ownership/runtime/role-asset 冻结是下一个收敛簇（C07/RA3 + C08 + C09）。任何 source change 仍需同 phase source/installed sync、diff parity、独立 review 与 commit gate。
