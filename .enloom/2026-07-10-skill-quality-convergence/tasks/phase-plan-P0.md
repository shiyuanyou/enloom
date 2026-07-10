# Phase Plan: P0 — Rebaseline + Contract Freeze

## Phase Goal

对上一轮 review 的所有高优先级 finding 按当前 `HEAD` 重新取证，裁决一套无歧义的 canonical contract，并把每条修复映射到 owner 文件、依赖 phase 和可执行验证；P0 结束前不修改任何 live skill 文件。

## Anti Goal

- 不直接修 `enloom-skill/**`、README、PROGRESS、CHANGELOG 或 AGENTS。
- 不改 `description`，不运行 description optimizer。
- 不写安装副本 `~/.agents/skills/enloom/`。
- 不修改 `design/_archive/**` 或 `.enloom/archive/**` 的历史正文。
- 不一次性详细规划 P1–P6 的 worker packet；本文件只详细规划当前 P0。

## Constraints

- 事实源优先级：当前 live 文件与 git 状态 > 当前安装副本 > 冻结 dogfood 报告 > 对话摘要。
- Five Laws 的目标、生命周期骨架意图、Evidence Contract 四字段名保留；允许澄清互相冲突的语义。
- 每个 finding 必须有精确文件/行证据，不接受“看起来不一致”。
- 任何建议命令必须在当前环境实跑或标 `NOT RUN`，不能凭经验假设可用。
- P0 输出只落在本项目 `runs/T-P0-*/`，control 独占 `project_state.md` 与 `decisions.md`。

## Strategy

`serial`。T-P0-02 依赖 T-P0-01 的事实矩阵，T-P0-03 再独立挑战前两项；这里并行只会制造两套未经统一的规则。

## Ownership Table

虽然本 phase 串行，仍明确边界：

| Resource / path | Tier | Writer | Stage |
|---|---|---|---|
| `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/**` | worker-exclusive output | T-P0-01 | Execute |
| `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/**` | worker-exclusive output | T-P0-02 | Execute |
| `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-03/**` | worker-exclusive output | T-P0-03 | Verify |
| `project_state.md` / `decisions.md` / `task_board.md` | serial-integration zone | control agent | Integrate |
| `enloom-skill/**` / root docs / installed copy | read-only zone | no one | P0 all stages |
| `design/_archive/**` / `.enloom/archive/**` | read-only evidence | no one | P0 all stages |

## Reference Tolerance Decision Table

P0 不创建跨 worker 引用，Promise Registry 不适用。报告只引用已经存在的文件路径；所有链接在 Verify 时检查目标存在。

## Promise Registry Draft

无。三个任务串行，后一个只消费前一个已落盘、已 review 的输出。

## Tasks

### T-P0-01 — Live baseline audit

- 重验上一轮八组 finding：Evidence、Lifecycle/landing/fold、review/audit ownership、runtime/parallel、namespace、validation、description、机械文本。
- 对每项给出：severity、current evidence、是否仍成立、冲突文件、最小修复边界、已知反例。
- 额外核对最新 dogfood 是否真正满足当前四要素和 Review Result gate。

### T-P0-02 — Canonical contract matrix

- 只消费 T-P0-01 的 accepted 输出。
- 对每个冲突写唯一 canonical rule：定义、owner SSOT、引用方、迁移方式、验证命令、禁止的旧表述。
- 检查 provisional decisions D006；保留、修订或拒绝都必须说明理由。
- 产出 P1–P6 的依赖图，只列 phase 目标和 owner 文件，不展开未来 task packet。

### T-P0-03 — Independent adversarial review

- 独立 reviewer 不复述前两份报告，主动寻找循环 gate、双重 owner、无法执行的验证和遗漏 near-miss。
- 对 canonical matrix 给 `PASS / ISSUES / FAIL` 与 review conclusion。
- 若有高严重度歧义，P0 不得 accepted，退回 T-P0-02 rework。

### Control integration

- 只在 T-P0-03 accepted 后更新 `decisions.md`、project_state Registry 和下一 phase 标签。
- P0 不产生 source commit；若用户希望追踪规划状态，可单独提交 `.enloom` 计划，但不得和 P1 source change 混在一起。

## Review Plan

P0 accepted 必须同时满足：

1. 上一轮所有 P0/P1 finding 均在矩阵中有状态，不能漏项或凭旧结论跳过。
2. 每个 canonical rule 只有一个 owner SSOT，其他文件只引用或简述。
3. Evidence 的 required-check / limitation / verdict / conclusion 四者可用至少 4 个正反样例唯一判定。
4. Lifecycle 从 Triage 到 Close 可顺序走通，不存在“进入阶段前先有本阶段产物”的循环。
5. reviewer、control、audit worker 的写权限无重叠。
6. runtime 能力边界不把某个 host 的限制写成通用事实。
7. 后续每 phase 的文件集合与验证方式明确，description 明确延后。
8. T-P0-03 报告含完整证据与 Review Result；无证据 PASS 一律退回。

## Human Decisions Needed

- **recon decision**：`no`。上一轮 review、live 文件和 dogfood 证据已覆盖当前规模与边界；P0 本身就是事实重验，不再额外派 recon。
- 当前无阻塞决策。若 T-P0-03 发现“保留独立 sub-agent 硬要求”与目标运行时范围不可兼容，再把该项升级给用户裁决。

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes
- Parallel ownership is defined if needed: not-needed（serial；仍声明文件边界）
- Promise Registry drafted if forward declarations exist: not-needed
- recon considered: yes（no）
- **Landing gate confirmed**: 本文件已写入 `tasks/phase-plan-P0.md`: yes
