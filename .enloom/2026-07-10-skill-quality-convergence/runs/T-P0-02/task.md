# Task Packet: T-P0-02 — Canonical contract matrix

Task Packet Version: 0.2
Mode: audited
Role: integrator

## Goal

只消费已经由 control `PASS / accepted` 的 T-P0-01 baseline，把 17 个 finding 裁决成一套可执行、无双重 owner、无循环 gate 的 canonical contract matrix。每条 canonical rule 必须明确唯一 SSOT、引用方、最小迁移边界、落地 phase、可执行验证与禁止继续出现的旧表述；同时逐条裁决 `decisions.md` D006 的 8 个 provisional choices。

产物是 P1–P6 的冻结契约输入，不是 live patch。P0 期间任何 live skill/root/installed 文件仍只读。

## Anti Goal

- 不修改 `enloom-skill/**`、根文档、安装副本或历史归档。
- 不重新做一遍无边界 baseline audit；只有发现 T-P0-01 证据自相矛盾时才提出 `baseline_challenge`。
- 不把同一规则分给两个 owner SSOT；“多个文件都解释一遍”不算 canonicalization。
- 不用抽象口号替代时序、角色、路径和 verdict 的可判定规则。
- 不展开 P1–P6 task packet，不写实现补丁，不改 description。
- 不以当前 host 的偶然能力替代跨 runtime contract。

## Inputs

唯一被接受的事实输入：

- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/output.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/report.md`（Review Result 必须为 `PASS / accepted`）

控制面约束：

- `.enloom/2026-07-10-skill-quality-convergence/tasks/phase-plan-P0.md`
- `.enloom/2026-07-10-skill-quality-convergence/project_state.md`
- `.enloom/2026-07-10-skill-quality-convergence/decisions.md`

用于确认 owner/consumer 边界的当前只读文件：

- `AGENTS.md`
- `README.md`
- `PROGRESS.md`
- `enloom-skill/SKILL.md`
- `enloom-skill/references/**/*.md`
- `enloom-skill/prompt-assets/**/*.md`
- `/Users/bigo/.agents/skills/enloom/**`（只核对 parity，不作为独立 SSOT）

## Existing State

- T-P0-01 已被 control 验收：8 domains、17 findings、3 dogfood reports，count delta 0。
- T-P0-01 的 `confirmed` 表示事实成立，不等于其 repair candidate 已被接受。
- D006 的 8 点均为 provisional，必须 `retain / revise / reject`，不能默认照抄。
- 历史 dogfood 的旧 PASS 标签只作为 regression fixture，不可当当前 contract 已通过的证明。
- P0 accepted 前不得碰 live skill；T-P0-03 会从独立上下文对本矩阵做对抗 review。

## Allowed Tools

- 只读 shell：`rg`、`sed`、`awk`、`wc`、`find`、`diff`、`git status`、`git diff`、`git show`、`git rev-parse`。
- 可读取 Inputs 中列出的文件并做只读 truth-table、路径、集合与时序核对。
- 不使用网络，不执行安装/格式化/生成器，不创建临时 live fixture。

## Writable Files

仅允许写：

- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/output.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/report.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/raw-notes.md`（可选）

## Forbidden Files

显式禁止修改：

- `enloom-skill/**`
- `README.md`
- `PROGRESS.md`
- `CHANGELOG.md`
- `AGENTS.md`
- `/Users/bigo/.agents/skills/enloom/**`
- `design/_archive/**`
- `.enloom/archive/**`
- `.enloom/task_board.md`
- `.enloom/2026-07-10-skill-quality-convergence/project_state.md`
- `.enloom/2026-07-10-skill-quality-convergence/decisions.md`
- `.enloom/2026-07-10-skill-quality-convergence/tasks/**`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/**`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-03/**`
- 本 task packet 自身 `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/task.md`

## Output Files

### `output.md`

使用以下固定结构：

1. `## Input Gate`：记录 T-P0-01 Review Result、HEAD、live/source-installed 边界。
2. `## Canonical Rule Index`：每条 rule 一行，ID 固定为连续 `C01`…`CNN`，含一句话 rule、唯一 owner、phase。
3. `## Canonical Rules`：每条用 `### CNN — <name>`；字段全部必填：
   - canonical rule：用 MUST / MUST NOT / MAY 写成可判定句
   - unique owner SSOT：恰好一个 live 文件 + 当前或拟定 section title
   - consumers：所有必须改为引用/简述的文件集合
   - finding coverage：映射 F-Dx-xx
   - rationale and rejected alternatives
   - minimal migration boundary：按文件列，不给 patch
   - forbidden legacy wording/behavior
   - executable verification：命令或表驱动样例，含 pass/fail signal
   - landing phase：P1–P6 恰好一个
   - residual risk / evidence still needed
4. `## Finding Coverage`：恰好 17 行，逐个列出 T-P0-01 finding ID、status、rule ID 或 `no-live-change` / `deferred-evidence`、理由。集合必须与 T-P0-01 headings 完全相等。
5. `## D006 Adjudication`：恰好 8 行 `D006-1`…`D006-8`，每行 `retain / revise / reject`、映射 rule、理由。
6. `## Required Decision Fixtures`：
   - Evidence truth table：至少 6 个正反例，覆盖 required check omission、empty evidence、structural limitation、unexplained high issue、medium defect、clean pass；每例唯一 verdict + conclusion。
   - Lifecycle walkthrough：从 Stage 0 Triage + 后续 six-stage lifecycle 顺序走到 Close，明确 make-prompt、dispatch gate、fold、health-check 的执行时点；不得循环依赖。
   - Ownership matrix：task packet、worker output/report、review verdict proposal、Review Result、audit output/report、Registry、archive 各自恰好一个 durable writer。
   - Runtime capability matrix：区分 sub-agent availability、concurrent dispatch capability、actual concurrency、model/session diversity；未知能力不得伪装成 universal fact。
   - Namespace resolver examples：至少 active、folded closed、reopen same-name 三例，每例唯一定位结果。
   - Validation decision table：official-capable path 与 flat fallback path 的承诺边界和 failure behavior。
7. `## P1–P6 Dependency Graph`：恰好 6 行，只列 phase goal、prerequisite rules、owner file set、exit verification、blocked-by；不写 future packets。
8. `## Adversarial Review Handoff`：列出 T-P0-03 必须主动挑战的 assumptions、可能循环/双 owner/不可执行命令、证据缺口。

### `report.md`

按 worker-report 结构落盘。Worker 不填写 Review Result 的 verdict/conclusion；留给 control。报告必须给所有可数项 `claimed / recounted / delta`，并把仍需独立 reviewer 裁决的高风险点明确列出。

## Acceptance Criteria

1. T-P0-01 的 17 个 finding 恰好覆盖一次，不漏、不重复；superseded/evidence-gap 不被偷改成 live defect。
2. 每条 canonical rule 只有一个 owner SSOT；consumer 只引用或简述，不再形成平行规范。
3. 每条 rule 有可执行 verification、禁止旧表述、最小迁移文件集和唯一 landing phase。
4. Evidence truth table 至少 6 例且 verdict/conclusion 可由规则唯一算出；Required Checks Not Run 与 structural limitation 分离。
5. Lifecycle walkthrough 无“进入阶段前需先有本阶段生成物”，fold 不在 Triage 结果前产生副作用，health-check 的 periodic home 与 transition executor 区分清楚。
6. reviewer、control、audit worker 对 durable artifacts 的写权无重叠；audit 不允许 context-only 返回替代落盘。
7. runtime 规则只要求协议真正依赖的 capability；并发、隔离、模型多样性按 capability 与 actual execution 分开记录。
8. active/folded/reopen project 都能从 task_board + canonical resolver 唯一定位；不创建同名重复项目。
9. validation 的 owner contract 与 fallback 实现能力一致；description/trigger 优化保持延后。
10. D006 8 点全部有明确裁决；P1–P6 依赖图恰好 6 行且不展开 future packets。
11. live/installed/archive/serial-integration 文件保持不变，产物可由独立 T-P0-03 仅靠文件复核。

## Required Verification

- `C01-input-acceptance`
  - command: `rg -n '^Verdict: PASS$|^Conclusion: accepted$' .../runs/T-P0-01/report.md`
  - pass_condition: 两行都存在且唯一。
  - fail_signal: baseline 未 accepted 或 review 结论歧义。
  - named_list: `input_gate_failures`
- `C02-finding-set`
  - command: 从 T-P0-01 `^### F-D[1-8]-NN` headings 与本产物 Finding Coverage 第一列分别排序，做集合 diff。
  - pass_condition: 两边各 17、集合完全相等、无重复。
  - fail_signal: finding 漏项、重复或新造 ID。
  - named_list: `finding_coverage_errors`
- `C03-rule-owner-completeness`
  - command: 独立重数 `^### C[0-9][0-9] —`，逐条检查 10 个必填字段和 exactly-one owner。
  - pass_condition: 每条完整；owner 路径属于 live source/root docs 且恰好一个。
  - fail_signal: 双 owner、无 owner、缺字段、owner 指向 archive/installed copy。
  - named_list: `rule_contract_errors`
- `C04-d006-set`
  - command: 重数并比对 `D006-1`…`D006-8`。
  - pass_condition: 恰好 8、每项唯一且有 disposition/rule/reason。
  - fail_signal: 漏项、重复、未裁决。
  - named_list: `d006_errors`
- `C05-evidence-fixtures`
  - command: manual: 用 canonical Evidence rule 对至少 6 个 fixture 逐个推导 verdict/conclusion，并做 pairwise ambiguity check。
  - pass_condition: 每例唯一结果；required omission 与 limitation 不共享同一语义字段。
  - fail_signal: 同例可得两个 verdict、诚实 limitation 自动阻断所有 PASS、required omission 被放行。
  - named_list: `evidence_ambiguities`
- `C06-lifecycle-trace`
  - command: manual: 从零 run 目录顺序演练 Triage→Close，记录每个 write/check 的 stage 与前置文件。
  - pass_condition: 无自依赖；pre-dispatch task gate 保留；fold 在合法进入 Enloom 后才可执行。
  - fail_signal: make-prompt 循环、pre-triage write/dispatch、transition gate 无执行者。
  - named_list: `lifecycle_cycles`
- `C07-ownership-trace`
  - command: manual: 对 durable artifact writer 列做唯一性重数。
  - pass_condition: 每个 artifact writer count=1；worker/reviewer 只写各自 run 输出，control 串行写 Review Result/Registry/state/archive。
  - fail_signal: writer count 0 或 >1、context-only audit。
  - named_list: `ownership_conflicts`
- `C08-runtime-namespace-validation`
  - command: manual: 分别执行 runtime capability、namespace 三例和 validation 两路径 decision table 的一致性检查。
  - pass_condition: capability/actual 分离；三个 namespace case 唯一；fallback 不承诺超出实现的 YAML contract。
  - fail_signal: host 偶然事实被普遍化、resolver 多解/无解、validator 过度承诺。
  - named_list: `cross_contract_errors`
- `C09-dependency-graph`
  - command: 重数 P1–P6 六行并检查所有 rule 恰好落一个 phase、依赖不倒置。
  - pass_condition: 6 phases；rule coverage 完整；description 在 P5，dogfood/发布在 P6。
  - fail_signal: phase 漏项、rule 无 phase/多 phase、先改 metadata 后修行为。
  - named_list: `phase_mapping_errors`
- `C10-claim-consistency`
  - command: 独立重数 rules、17 findings、8 D006、fixtures、6 phases 和所有 named lists。
  - pass_condition: report claimed/recounted delta 全为 0。
  - fail_signal: 任一 count mismatch。
  - named_list: `claim_mismatches`
- `C11-file-boundary`
  - command: `git status --short`、live diff、source/installed diff、forbidden/control hash before/after。
  - pass_condition: worker 只新增 T-P0-02 output/report/raw-notes；其他哈希不变。
  - fail_signal: forbidden path mutation。
  - named_list: `boundary_violations`

Countable outputs:

- Canonical rule 数量及每条必填字段/owner 数。
- Finding Coverage：17。
- D006 adjudication：8。
- Evidence fixtures：至少 6，报告实际数量。
- Lifecycle walkthrough stage rows：Stage 0 + six lifecycle stages，共 7。
- Ownership artifact rows：报告实际数量及 writer-count 异常数。
- Namespace examples：3。
- Validation paths：2。
- P1–P6 rows：6。
- 所有 named-list 项目数。

## Evidence Required

- 每项 C01–C11 的实际检查和证据位置。
- 集合 diff 与 writer uniqueness 必须给可复算结果，不接受“已覆盖”。
- verification command 若依赖后续实现，必须标为 future-phase candidate，并同时给 P0 当前可做的静态一致性检查。
- 任何 critical check 未跑时 Result 不能是 done。

## Review Budget

- `output.md` 建议不超过 850 行；优先保留 rule、决策表和可执行 gate。
- `report.md` 不超过 200 行。
- 原始集合/命令输出超预算可放 `raw-notes.md`。

## Pending / Promise Registry Updates

无跨 worker promise。T-P0-03 只消费本任务被 control accepted 后的现存文件。任何待验证项放入矩阵 residual risk 与 report Registry proposal，由 control 在 P0 Integrate 时统一处理。

## Human Decision Gate

若 canonicalization 证明“独立 sub-agent 硬要求”与项目已声明的目标 host 范围不可兼容，且无法通过 compatibility preflight + honest halt 解决，返回 `blocked` 并给出最小二选一；不要自行删除硬要求或扩建 runtime。

## Done Signal

仅在 `output.md`、`report.md` 已落盘，C01–C11 全部执行，17/8/6-phase 集合闭合且 boundary 通过时返回 `done`。聊天只回 Result、counts、风险名和产物路径。

## Rework Addendum — required after T-P0-03 FAIL

T-P0-03 的独立 review 已返回 `FAIL / needs-rework`，P0 gate 为 `not-accepted`。保留原始 matrix 作为历史输入，但在本次同一 run 产物中追加 `## Rework Amendment` 与对应 report evidence；不得修改 live 文件。四个 high blocker 必须逐项闭合：

1. **C01/C02 totality**：增加 packet-level `required_check_status` 与有序 decision table。明确：声明的 required check 若没有 `run` 即 `Not Checked`/FAIL；结构性 limitation 只有在不阻断任何 required check 时才留在 Known Blind Spots；claim mismatch 的默认 ISSUES 与“违反原始 AC 时 FAIL”边界；高问题按 `repairable-within-packet → FAIL/needs-rework`、`unsafe/unusable/non-repairable → FAIL/rejected`。同一输入不得有两个 verdict/conclusion。
2. **C03/C07 Stage 4 termination**：增加命名的 Verify-worker sub-state（进入 Verify 后由 control 创建 reviewer/audit packet，落盘 task，再 dispatch；control 直接完成该 run 的 Review Result），明确该 sub-state 不回 Plan、不需要 reviewer-of-review，也不把 control finalization 隐藏成例外。
3. **C07 physical ownership**：禁止 section-level 双写。把 worker evidence `report.md` 与 control-owned `review-result.md` 拆成两个 durable artifacts，更新 ownership/landing/archive gate：worker 只写 report body，control 只写 review-result；Verify/Close 以两者同时存在为 gate。pure audit packet 必须同样声明两个路径。
4. **C04/C10 resolver/fold**：定义可枚举的 resolver error enum 与 precedence（duplicate row、orphan root、both roots、neither root、partial move），规定 fold/reopen 的 pre-move snapshot、move failure 立即停止、`FOLD_MOVE_PARTIAL` 阻断 Orient 的恢复状态；不得依赖“blocking”泛称或 first-path-wins。

同时吸收对抗 review 的非阻断修订：P2 必须沿用 one-plus-six phrase guard；C08/C12 写出 hard/soft unknown 四维表与 preflight propagation；C11 给 V01 unavailable/rule-gap 命名状态；C13 把 link-target syntax owner 移到真正的 validation/reference owner；C09 明确 host-native prompt evidence 是 future acceptance，C14/F-D7-02/D8-02 保持 evidence-gap/no-live-change。

Rework acceptance：上述四项 high blocker 在 output 中各有 revised rule、counterexample closure、唯一验证和旧表述禁用项；重新独立重数 14/17/8/8/7/7/3/2/6；旧 T-P0-03 FAIL 不能被删除或改写，只能在新 `Rework Amendment` 中被 supersede。

## Rework Addendum 2 — required after independent T-P0-03 recheck

The first amendment closed RA2/RA3 but left two high blockers. Append a second amendment to the same T-P0-02 output/report; preserve all prior prefixes and the first FAIL/recheck evidence.

1. **RA1 status cross-field totality**: make status tuples mechanically valid before the verdict table. `run_state=run` MUST pair with `outcome=pass|fail` and a non-empty evidence reference; `run_state=not-run` MUST pair with `outcome=not-run` and `evidence_ref=none`; every other combination is `STATUS_INVALID` and selects FAIL before all later rows. Re-derive the malformed tuple `run + outcome=not-run + evidence_ref=ref` and its duals. No status combination may fall through without a verdict.
2. **RA4 operation-intent precedence**: add a named `PROJECT_OPERATION_INVALID` predicate/result before the success row. It MUST block `reopen` on an active-only project, `fold` on an archive-only project, `fold` on an active project when `closed && threshold` is false, and any fold/reopen intent with no matching row/root. Valid `lookup`, valid closed/threshold fold, and valid folded reopen may retain the existing success enum plus explicit allowed effect. Error/marker precedence remains above operation intent; no move occurs on invalid intent.

Rework-2 acceptance: preserve the original 349-line matrix prefix and prior amendment; add concrete closure rows, unique verification, and forbidden legacy behavior for these two cases. Compact `14/17/8/8/7/7/3/2/6` and original 17 finding/D006 sets remain unchanged. T-P0-03 must be independently rechecked again using the same packet; do not modify live files.
