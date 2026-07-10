# Task Packet: T-P0-01 — Live baseline audit

Task Packet Version: 0.2
Mode: audited
Role: researcher

## Goal

基于当前 `HEAD` 对 Enloom live contract 做一次可复核的 baseline audit。逐项重验 P0 phase plan 列出的八个语义域，区分“仍成立 / 已被当前实现消除 / 需要降级 / 证据不足”，并给出精确到文件与行号的证据、最小修复边界和反例。额外审计最新一次 dogfood 的三个 worker report 是否真实满足 Evidence Contract 四要素与 Review Result gate。

本任务只建立事实基线，不裁决 canonical rule，不修改任何 live 文件。

## Anti Goal

- 不修复、不重写、不格式化 `enloom-skill/**` 或根文档。
- 不把 P0 plan、D006 或上一轮对话结论当作已证实事实；它们只是待核验假设。
- 不给 P1–P6 写详细设计或 task packet。
- 不修改冻结历史；dogfood 产物只读。
- 不用“全局不一致”“看起来有问题”替代可定位证据。

## Inputs

控制面输入：

- `.enloom/2026-07-10-skill-quality-convergence/tasks/phase-plan-P0.md`
- `.enloom/2026-07-10-skill-quality-convergence/project_state.md`
- `.enloom/2026-07-10-skill-quality-convergence/decisions.md`

当前 live 输入：

- `AGENTS.md`
- `README.md`
- `PROGRESS.md`
- `CHANGELOG.md`
- `enloom-skill/SKILL.md`
- `enloom-skill/references/**/*.md`
- `enloom-skill/prompt-assets/**/*.md`

安装副本（只用于一致性核对）：

- `/Users/bigo/.agents/skills/enloom/**`

最新 dogfood 证据（只读，完整检查三份 report；需要时只读其 task/output）：

- `.enloom/archive/2026-07-09-repo-hygiene/runs/T-design-archive/**`
- `.enloom/archive/2026-07-09-repo-hygiene/runs/T-progress-compact/**`
- `.enloom/archive/2026-07-09-repo-hygiene/runs/T-skill-clean/**`

## Existing State

- 预期基线 commit：`318944b1ff715049a71ebcb21f3e16fe21afc07f`；必须实测确认。
- P0 phase plan 预列八域：Evidence；Lifecycle/landing/fold；review/audit ownership；runtime/parallel；namespace；validation；description；机械文本。
- `decisions.md` D006 是 provisional choices，不是 accepted truth。
- 当前已知工作树改动应仅位于本项目 `.enloom/` 控制面；若发现 live diff，立即 `blocked` 并报告。

## Allowed Tools

- 只读 shell：`rg`、`sed`、`awk`、`wc`、`find`、`diff`、`git status`、`git diff`、`git show`、`git log`、`git rev-parse`。
- 可读取上述 Inputs 及必要的 git 历史。
- 不使用网络，不执行安装，不运行会修改工作树的 formatter/generator。

## Writable Files

仅允许写：

- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/output.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/report.md`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/raw-notes.md`（可选；只放超出 report budget 的命令摘录）

完成后用 `git status --short` 和 live-path diff 命令核对边界。

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
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-02/**`
- `.enloom/2026-07-10-skill-quality-convergence/runs/T-P0-03/**`

## Output Files

### `output.md`

按以下固定结构：

1. `## Baseline`：HEAD、source/installed parity、live diff 状态、审计边界。
2. `## Domain Summary`：恰好 8 行，ID 固定为 `D1`–`D8`，每行给 domain、status、finding count、最高 severity。
3. `## Findings`：每个 finding 用三级标题 `### F-<D1..D8>-NN`，字段必须包含：
   - severity：blocking / high / medium / low
   - status：confirmed / superseded / downgraded / insufficient-evidence
   - claim
   - current evidence：至少一个 `path:line`；若声称跨文件冲突，至少两个独立 anchor
   - conflicting/agreeing sources
   - why it matters
   - minimal repair boundary（文件集合，不写补丁）
   - counterevidence / known counterexample
   - executable verification candidate
4. `## Latest Dogfood Gate Audit`：恰好 3 行报告矩阵；逐份核对 Checks Run、Evidence、Not Checked、Known Blind Spots、Review Result、任务声明与 output 的 claim consistency。
5. `## Coverage and Unknowns`：列出未检查范围和风险大小，禁止把未检查写成通过。
6. `## Inputs for T-P0-02`：只列已证实事实与待裁决分歧，不给最终 canonical rule。

### `report.md`

使用 worker-report 结构，包含 Result、Files Changed、Checks Run、Evidence、Not Checked、Known Blind Spots、Risks、Registry Updates、State Update、Next、Review Result。Worker 不填写 Review Result 的 verdict/conclusion，只保留空位给 control。

## Acceptance Criteria

1. 八个 domain 全部在当前 HEAD 上重验，Domain Summary 恰好 8 行且与 Findings 数量自洽。
2. 所有 confirmed/downgraded finding 有精确行证据；跨文件冲突不能只有单侧引用。
3. 明确区分规范矛盾、实现缺口、运行时盲区、文案/链接机械缺陷；不把不同层问题揉成一个 finding。
4. 每个 finding 都有最小修复边界、反证/反例与可执行验证候选。
5. 三份最新 dogfood report 全部核对四要素、Review Result 和可数 claim；缺项必须如实判定。
6. 报告声明所有未检查范围及风险；至少声明 cross-role verification 与 shared-filesystem isolation 的真实边界。
7. worker 只写本 packet 的 output/report/raw-notes；live skill 和 serial-integration files 保持不变。
8. `output.md` 可由 T-P0-02 直接消费，不依赖聊天上下文。

## Required Verification

- `B01-baseline`
  - command: `git rev-parse HEAD`
  - pass_condition: 精确等于预期基线；否则阻断并报告。
  - fail_signal: HEAD 漂移。
  - named_list: `baseline_drift`
- `B02-live-boundary`
  - command: `git diff --name-only -- enloom-skill README.md PROGRESS.md CHANGELOG.md AGENTS.md`
  - pass_condition: 输出为空（任务前后都检查）。
  - fail_signal: 任一 live path 出现 diff。
  - named_list: `live_mutations`
- `B03-installed-parity`
  - command: `diff -qr enloom-skill /Users/bigo/.agents/skills/enloom`
  - pass_condition: 输出为空。
  - fail_signal: 源/副本不一致。
  - named_list: `installed_drift`
- `B04-eight-domain-coverage`
  - command: `manual: 逐域从 live 文件重新取证，并检查 D1-D8 summary 与 finding IDs 覆盖一致`
  - pass_condition: 八域无遗漏，每域有明确 status；未发现问题也要给 negative evidence。
  - fail_signal: 漏域、只复述计划、证据来自旧对话而非当前文件。
  - named_list: `coverage_gaps`
- `B05-evidence-anchor-quality`
  - command: `manual: 逐条核对 finding 的 path:line anchor、冲突双侧证据、反例与最小边界`
  - pass_condition: confirmed/downgraded finding 可由第三方按 anchor 复核。
  - fail_signal: 模糊引用、单侧冲突、无反证搜索。
  - named_list: `weak_findings`
- `B06-dogfood-gates`
  - command: `manual: 完整检查 repo-hygiene 三份 report，并在有可数 claim 时独立重数 output`
  - pass_condition: 恰好 3 份均有逐字段 verdict；任何缺项不被误报为通过。
  - fail_signal: 少检查报告、跳过四要素或 Review Result、未重数可数 claim。
  - named_list: `dogfood_gate_failures`
- `B07-output-structure`
  - command: `rg -c '^### F-D[1-8]-[0-9][0-9]' .enloom/2026-07-10-skill-quality-convergence/runs/T-P0-01/output.md`，并独立核对 Domain Summary 八行与 dogfood 三行。
  - pass_condition: finding recount 与 report 自报一致；domain=8；dogfood report=3。
  - fail_signal: 任一 count mismatch。
  - named_list: `claim_mismatches`
- `B08-worker-file-boundary`
  - command: `git status --short` + `git diff --name-only`，与任务开始时状态对比。
  - pass_condition: worker 新写仅限 T-P0-01 output/report/raw-notes；既有 control files 可存在但未被 worker 修改。
  - fail_signal: forbidden path 被修改。
  - named_list: `boundary_violations`

Countable outputs:

- Domain Summary 行数：8。
- 最新 dogfood report 审计行数：3。
- Finding 总数及 D1–D8 分域数量。
- named-list 项目数：`baseline_drift`、`live_mutations`、`installed_drift`、`coverage_gaps`、`weak_findings`、`dogfood_gate_failures`、`claim_mismatches`、`boundary_violations`。

## Evidence Required

- 每个 verification item 的实际命令/手工检查、结果摘要和证据位置。
- 行号必须来自当前工作树，可由 `nl -ba` / `rg -n` 重现。
- 可数 claim 必须在 report 中给“claimed / recounted / delta”。
- 若命令未跑，必须放入 Not Checked；critical item 未跑时 Result 不能是 done。

## Review Budget

- `output.md` 建议不超过 900 行；优先保留证据和冲突边界，删掉过程叙述。
- `report.md` 不超过 180 行。
- raw 命令输出超预算时落 `raw-notes.md`，report 只引用路径与关键摘录。

## Pending / Promise Registry Updates

无跨 worker promise。发现的问题只在 report 的 `Registry Updates` 提案中列出，由 control 在 Verify/Integrate 串行写入 Registry。

## Human Decision Gate

若发现“是否强制独立 sub-agent”与目标 runtime 范围存在无法通过现有项目目标裁决的 blocking 冲突，返回 `blocked`，给出两种最小选项与证据；不要自行扩大产品范围。

## Done Signal

仅在 `output.md` 和 `report.md` 均已落盘、B01–B08 全部执行且 critical check 无缺口时返回 `done`。聊天回复只给短理由和两个/三个产物路径；详细内容留在文件中。
