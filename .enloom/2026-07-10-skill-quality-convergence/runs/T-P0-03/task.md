# Task Packet: T-P0-03 — Independent adversarial review

Task Packet Version: 0.2
Mode: audited
Role: reviewer

## Goal

在全新 worker 上下文中，对已被 control 接受的 T-P0-01 baseline 与 T-P0-02 canonical matrix 做独立对抗 review。不要复述矩阵；主动构造反例，检查它是否真的消除了高严重度歧义、循环 gate、双重 durable writer、不可执行 verification 和遗漏 near-miss。给出 `PASS / ISSUES / FAIL` 与 `accepted / accepted-with-risk / needs-rework / rejected`，并明确 P0 是否可以在不改 live skill 的前提下进入 Integrate/Close。

## Anti Goal

- 不修改任何 live skill、根文档、安装副本、历史归档或 control state。
- 不把 T-P0-02 的“C01–C11 PASS”当作独立证据；必须自己重算并引用当前文件/矩阵行。
- 不通过重复引用矩阵原文来冒充 adversarial challenge。
- 不提出 P1–P6 的新 roadmap；只指出矩阵需要 rework 的最小边界。
- 不因低风险文案问题掩盖 report ownership、Stage 4 handshake 或 capability preflight 的高风险问题。

## Inputs

已通过 control gate 的事实输入：

- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/output.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/report.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/output.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/report.md`

约束与当前只读实现：

- `.enloom/2026-07-10-skill-quality-convergence/tasks/phase-plan-P0.md`
- `.enloom/2026-07-10-skill-quality-convergence/decisions.md`
- `AGENTS.md`
- `README.md`
- `PROGRESS.md`
- `enloom-skill/SKILL.md`
- `enloom-skill/references/**/*.md`
- `enloom-skill/prompt-assets/**/*.md`
- `/Users/bigo/.agents/skills/enloom/**`（只做 parity 观察）

## Existing State

- T-P0-01 report Review Result：`PASS / accepted`。
- T-P0-02 report Review Result：`PASS / accepted`，matrix 自报 14 rules、17 findings、8 D006、8 fixtures、7 lifecycle、7 ownership、4 runtime dimensions、3 namespace、2 validation、6 phases。
- T-P0-02 已明确高风险：物理 `report.md` section ownership、Stage 4 verifier dispatch、C12 preflight timing、validation tooling、trigger evidence、runtime observation、install command。
- P0 phase plan 要求：若 T-P0-03 发现高严重度歧义，P0 不得 accepted，必须退回 T-P0-02 rework。

## Allowed Tools

- 只读 shell：`rg`、`sed`、`awk`、`wc`、`find`、`diff`、`git status`、`git diff`、`git show`、`git rev-parse`。
- 允许构造内存中的 truth-table / state-machine / writer-set 反例；不写临时 fixture 到 live 或 archive。
- 不使用网络、不运行安装、不调用 formatter/generator、不得修改任何输入。

## Writable Files

仅允许写：

- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-03/output.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-03/report.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-03/raw-notes.md`（可选）

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
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/**`
- 本 packet 自身 `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-03/task.md`

## Output Files

### `output.md`

固定结构：

1. `## Independence and Input Gate`：确认新 context、两份 prior report 的 accepted pair、HEAD/live/parity 边界。
2. `## Challenge Summary`：恰好 14 行 `C01`–`C14`，每行给 `survives / issue / fail / evidence-gap`、severity、关键反例 ID、结论。
3. `## Adversarial Challenges`：至少包含以下挑战并给当前 live/matrix `path:line` 或 `output.md:line` 证据：
   - EVID-1：C01/C02 的 total decision function；构造 required-check omission、structural limitation blocking a required check、medium defect、high unusable output、claim mismatch 五类边界。
   - LIFE-1：C03 Stage 3 make-prompt→task gate 顺序；从空 run 目录演练，检查是否仍有任何“进入阶段前需有本阶段生成物”的循环。
   - LIFE-2：C07 Stage 4 reviewer/audit 的 local handshake；检查是否需要 reviewer-of-review 无限递归，是否有 context-only 返回路径。
   - OWNER-1：C07 的 `report.md` body 与 Review Result section 是否能由 file-level Writable/Forbidden 真正隔离；若不能，给最小 artifact split。
   - FOLD-1：C04/C10 的 triage→compatibility→fold→Orient 顺序、两 root resolver 及 move failure/duplicate/orphan 的唯一阻断结果。
   - RUNTIME-1：C08/C12 是否把 independent sub-agent、concurrency、actual execution、model/session diversity 分开；`unknown` 是否在每个 `.enloom` 写入前阻断。
   - ASSET-1：C09 五个 Role（researcher/coder/reviewer/integrator/tester）是否都有确定 route；packet-only 是否是明确策略而非缺 asset。
   - VALID-1：C11 的 V01 full validator 与 V02 flat fallback 是否区分 `UNSUPPORTED`/`INVALID`，是否存在无工具却宣称 full pass。
   - NS-1：C10 active/folded/reopen/both-root/neither-root/orphan 六类 resolver 输入各自唯一结果。
   - TEXT-1：C13 owner 是否放错文件；C14 install command 是否在 P0 被错误“确定”；D006/D7-02/D8-02 是否被偷偷升级为 live change。
4. `## Counterexample Table`：至少 8 个反例；字段为 input state、matrix rule、expected outcome、observed ambiguity、severity、minimal rework。
5. `## Verdict and P0 Gate`：给唯一 `verdict` 与 `review conclusion`，并给 P0 `accepted | not-accepted`。`not-accepted` 必须列出阻断 finding 和退回 T-P0-02 的最小修改。
6. `## Counts and Coverage`：独立重算 14/17/8/8/7/7/3/2/6 及 named lists；任何 delta 都必须进入报告。
7. `## Known Blind Spots`：列出无法在当前 runtime 证明的事项，不能把“同一 session / 共享 workspace”写成独立隔离。

### `report.md`

按 worker-report 结构。必须包含 Checks Run、Evidence、Not Checked、Known Blind Spots、Risks、Registry Updates。Worker 不填写 Review Result 的 verdict/conclusion，留给 control；报告必须区分“matrix worker 的 Evidence Contract PASS”和“P0 phase 是否 accepted”。

## Acceptance Criteria

1. 14 个 canonical rule 全部被挑战；至少 8 个不是简单重述的 concrete counterexample。
2. C01/C02、C03/C07 是 blocking-focus：任何 verdict 多解、Stage 4 local handshake 循环、section writer 无法在 packet 文件级规则中表达，都必须判为 high，P0 `not-accepted`。
3. C04/C10/C08/C12/C11/C09/C13/C14 的边界和 evidence-gap 有独立证据；unknown 不得被写成 pass。
4. T-P0-01 17 finding、T-P0-02 14 rule、D006 8 项 coverage 完整且 count delta=0，除非发现真实 mismatch；真实 mismatch 直接记录。
5. 任何 P0 `accepted` 都必须满足：无 high challenge、所有 critical checks 已跑、证据非空、blind spots 已声明、live immutability 通过。
6. 明确哪些问题必须退回 T-P0-02，哪些只是 P1–P6 residual risk；不把 residual risk 静默丢弃。
7. Worker 只写 T-P0-03 自己的 output/report/raw-notes；live skill 与所有 serial-integration 文件保持不变。

## Required Verification

- `A01-input-gate`
  - command: `rg -n '^Verdict: PASS$|^Conclusion: accepted$'` 两个 prior report；`git rev-parse HEAD`。
  - pass_condition: 两个 input report 各有唯一 accepted pair，HEAD 与 T-P0-01 一致。
  - fail_signal: prior output 未 accepted 或基线漂移。
  - named_list: `input_gate_failures`
- `A02-coverage`
  - command: 从 T-P0-01 headings、T-P0-02 Finding Coverage、T-P0-02 C01–C14 index 做集合 diff。
  - pass_condition: 17/17 findings、14/14 rules、无重复/漏项。
  - fail_signal: 集合不相等、rule 无 finding coverage。
  - named_list: `coverage_errors`
- `A03-challenge-depth`
  - command: manual: 每个 C01–C14 至少一条当前证据；Challenge Summary 14 行；Counterexample Table ≥8 行且含至少 3 个 high-focus 反例。
  - pass_condition: 不只转述规则，反例能改变或确认结论。
  - fail_signal: 复述、无独立 anchor、只给意见不构造输入。
  - named_list: `shallow_challenges`
- `A04-evidence-uniqueness`
  - command: manual: 对 EVID-1 五类边界与 T-P0-02 E01–E08 重新推导 verdict/conclusion。
  - pass_condition: 每例唯一；required omission / limitation / medium defect / high issue 不混淆。
  - fail_signal: 多解、结构 limitation 阻断 required check 却仍 PASS、repairability 无判据。
  - named_list: `verdict_ambiguities`
- `A05-lifecycle-recursion`
  - command: manual: 空 run 目录 + Stage 0–6 walkthrough，分别走 execution worker 与 reviewer/audit worker。
  - pass_condition: 所有 packet 先落盘再 dispatch；无 Stage 3/Stage 4 循环或 reviewer-of-review 无限递归。
  - fail_signal: 本阶段生成物作为入口前置、context-only review、需要无限 reviewer。
  - named_list: `lifecycle_blockers`
- `A06-writer-ownership`
  - command: manual: 将 Writable/Forbidden 映射到物理路径，逐个检查 task/output/report/Review Result/Registry/archive。
  - pass_condition: 文件级 owner 可执行；section ownership 若不可表达，必须提出独立 control artifact 并判当前矩阵 high issue。
  - fail_signal: 同一 physical file 需要两个 worker 写权限、reviewer 写 target report/Registry、audit 无落盘路径。
  - named_list: `writer_conflicts`
- `A07-runtime-namespace-validation`
  - command: manual: 复演 C08/C12 四维 capability、C10 六类 resolver、C11 V01/V02。
  - pass_condition: unknown/ambiguous/unsupported 都有唯一 blocking signal；不把静态文本当 runtime evidence。
  - fail_signal: unknown 继续写 `.enloom`、first-path wins、fallback 冒充 full YAML。
  - named_list: `boundary_ambiguities`
- `A08-phase-order`
  - command: 重数 P1–P6 与 rule phase，检查 C05/D7-02/D8-02 延后关系。
  - pass_condition: 6 phases、14 rules each one phase、description/trigger evidence 后置。
  - fail_signal: 依赖倒置、P0 偷带 live change、evidence-gap 被实现化。
  - named_list: `phase_order_errors`
- `A09-boundary`
  - command: `git status --short`、live diff、`diff -qr`、forbidden/control hash before/after。
  - pass_condition: 仅 T-P0-03 output/report/raw-notes 新增。
  - fail_signal: 任一 forbidden/live mutation。
  - named_list: `boundary_violations`
- `A10-claim-consistency`
  - command: 独立重数 14/17/8/8/7/7/3/2/6、challenge rows、counterexamples、named lists。
  - pass_condition: report claimed/recounted delta 全为 0。
  - fail_signal: 任一 mismatch。
  - named_list: `claim_mismatches`

Countable outputs:

- challenged canonical rules：14。
- Finding coverage：17；D006：8。
- Evidence fixtures rederived：8；lifecycle：7；ownership：7；namespace：3；validation：2；phases：6。
- Counterexamples：至少 8，报告实际数；Challenge Summary：14。
- named-list 项目数及 high blocker 数。

## Evidence Required

- 每个 A01–A10 的实际检查、证据路径/行号和结果。
- 每个 high-focus challenge 必须至少一个 current live 或 matrix/output anchor；不能只引用 reviewer intuition。
- 若命令未跑，放入 Not Checked 并将 verdict 降级；共享 workspace、同模型/session、无 runtime timing 必须作为 blind spot 声明。

## Review Budget

- `output.md` 建议 ≤650 行；report ≤200 行。
- raw 命令输出超预算落 `raw-notes.md`。

## Pending / Promise Registry Updates

无跨 worker promise。发现的 high/medium blocker 只写本 run 的 Registry Updates 提案，由 control 在 P0 Integrate/rework 决定是否入 Registry。

## Human Decision Gate

若无法在当前证据下判定“section ownership 是否可执行”或“Stage 4 reviewer/audit handshake 是否无递归”，返回 `FAIL / needs-rework`，不要自行选择永久 artifact 结构。

## Done Signal

仅在 `output.md`、`report.md` 均落盘，A01–A10 有证据，14 rule 全挑战且 counts 可复算时返回 `done`。聊天只回 verdict、P0 gate、阻断风险和产物路径。
