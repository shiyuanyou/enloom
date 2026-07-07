# Task Packet: P2

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

按 clear-mind reframe 终版（`.clear-mind/2026-07-07-p2-recon-deep/review.md` §7 的五件 MVP）落地 P2-recon 升格：把 recon 从"一段调度指引"升级为**人机决策门 + recommended 信号**（零结构改动，不碰 v0.5 红线）。五件交付物全部落在 `enloom-skill/` 源仓库，改完同步到 `~/.agents/skills/enloom/` 副本。

## Anti Goal

- **不加** stage / 顶层字段 / Mode 枚举值 / Role 枚举值 / Pre-flight 子阶段（v0.5 红线 + reframe 零结构原则）。
- 不改 `design/` 历史文档（冻结）。
- 不动 art-lab / manual-trial 的 "the agent" 措辞（归 P3）。
- 不写"recon 防漏扫"这类叙事（假性需求，只写"给 Plan 一个结构化的预研位置 + 降低主窗口 prompt 污染"）。
- 不为其他用户习惯优化。
- 不重构无关段落——只加/改本任务指定的内容。

## Inputs

- **设计依据**（只读）：`.clear-mind/2026-07-07-p2-recon-deep/review.md` §7（五件 MVP + 三信号规则）+ plan.md v3。
- **将被改的文件**（源仓库，先 Read 再改）：
  - `enloom-skill/references/templates/phase-plan.md`（74 行，Human Decisions 段在 :64，Gate Check 在 :67-74）
  - `enloom-skill/references/scheduler-rules.md`（66 行，recon 指引段在 :53-59）
  - `enloom-skill/prompt-assets/researcher.md`（47 行，How to work 在 :32-38）
  - `enloom-skill/evals/evals.json`（100 行，9 个 case，结构 {id,prompt,expected_output,expectations[]}）
  - `enloom-skill/references/eval-guide.md`（129 行，"What the evals test" 表在 :5-17，trigger eval 段在 :59-67）
- **参考**（只读，不改）：`enloom-skill/references/trigger-contract.md`（triage 阶段定义）、`enloom-skill/references/workflow-steps.md`（Stage 1 triage）。

## Existing State

- v0.6 已闭合 P0/P0.5/P1。scheduler-rules.md:53-59 现有 recon 指引是 v0.5 down-scope 版（"非新阶段、非新字段、非新术语"）。researcher.md 是通用 read-only worker（无 mode 分支）。phase-plan.md Human Decisions 段是空模板。evals.json 9 case 无 recon。

## Allowed Tools

Read / Edit / Write / Bash（cp / diff / grep）。不改源仓库外的文件。

## Writable Files

> Exclusive list, precise to the path。源仓库 + 副本（同步）。**只这 5 个文件 × 2 处 = 10 处**。

源仓库 `enloom-skill/`：
1. `enloom-skill/references/templates/phase-plan.md`
2. `enloom-skill/references/scheduler-rules.md`
3. `enloom-skill/prompt-assets/researcher.md`
4. `enloom-skill/evals/evals.json`
5. `enloom-skill/references/eval-guide.md`

安装副本 `~/.agents/skills/enloom/`（同步，5 个对应文件）。

## Forbidden Files

> 显式枚举串行集成区 + 不可碰区。

- `.enloom/` 整个目录（串行集成区，控制 agent 独占）
- `.clear-mind/` 整个目录（只读设计依据）
- `design/` 整个目录（冻结历史）
- `enloom-skill/` 下**非本任务 5 文件**的其他所有文件（SKILL.md / 其他 references / 其他 prompt-assets / 其他 templates）
- 根 `README.md` / `PROGRESS.md`

## Output Files

- `enloom-skill/` 5 文件（改完）
- `~/.agents/skills/enloom/` 对应 5 文件（cp 同步）
- `runs/P2/output.md`（逐文件 old→new 改动摘要）
- `runs/P2/report.md`（Evidence Contract 四要素 + Claim Consistency）

## Acceptance Criteria

五件 MVP 严格匹配 review §7：

### ① phase-plan.md（Human Decision recon 行 + Gate Check 行）
- 在 `## Human Decisions Needed` 段（:64）下方加一个 recon 决策模板行/小区块。措辞示例（可润色，保留语义）：
  ```
  - **recon decision (P2 reframe)**: 该 phase 域是否需要先 recon？规模/结构/边界是否已明？
    - [ ] yes — 派 recon task（emergent mode，产物=规模素描，喂回 Plan 修正切分）
    - [ ] no — 已有把握，跳过
    - [ ] recommended（若 Plan 触发三信号之一：见 scheduler-rules §recon）
  ```
- 在 `## Gate Check` 段（:67-74）加一行：`- recon considered (P2): yes | no`（出口自检）。

### ② triage 接 recon 偏好
- 在 `enloom-skill/references/trigger-contract.md` **或** `workflow-steps.md` Stage 1 triage 段加一条：triage 时可接收用户"要/不要 recon"声明（机制 b），未声明时默认走机制 (a)（Human Decision）。**落点你定**——倾向 trigger-contract（声明随触发）。措辞简洁，说明这是可选偏好，不强制。
- 注意：这是"接收偏好"，不是"自动判断"。enloom 不判断熟不熟，只把偏好传给 Plan 阶段的 Human Decision。

### ③ scheduler-rules.md（recon 升格 + recommended 三信号）
- 把现有 :53-59 的"新 domain 的侦察调度（v0.5 指引）"段**升格**——保留踩坑背景（art_lab #16），但更新指引反映 reframe：
  - recon 决策现在是 **phase-plan Human Decision 的一行**（不再是"Plan 自觉派"）。
  - 加 **recommended 三信号规则**：Plan 在以下任一信号出现时把 recon Human Decision 标 `recommended`，否则作为 standing option：
    1. Registry 无该域风险段（新 domain）—— Orient 读 project_state Registry 段的副产物
    2. 出现新文件类型（扩展名/结构未见过）—— Plan 读 input 时的观察
    3. Plan 读 input 时规模/边界不明
  - 保留 v0.5 的"用现有 task-packet（mode: emergent，Allowed Tools: Read/Grep/Web）"+ "recon done signal = 规模/结构素描"。
  - 加一句诚实边界：recon 防的是"决策被静默跳过"，**不防**"决策做错"（art_lab #16 式根因跨方案恒存）。
  - 与 phase-plan Human Decision 段交叉引用（Promise Registry P2-C→P2-A）。

### ④ researcher.md（How-to-work recon 产物分支）
- 在 `## How to work`（:32-38）加一条分支（编号续，现 1-5，加 6）：
  ```
  6. **If the task packet marks this as a recon task** (Goal/Anti-Goal says "recon", product = scale/structure sketch, not full research): your output is a lightweight scale/structure sketch — file counts, entry counts, structure map, boundary notes — NOT a complete research finding. Feed it back so Plan can correct its decomposition. Align to Evidence Contract four elements (Checks Run = inputs read / Evidence = sketch + sources / Not Checked = outside packet / Known Blind Spots = uncertainties). Do not over-research.
  ```
- **不动 Role/Mode 枚举**（reframe 零结构原则）。recon task 仍是普通 emergent task，Role 仍 researcher，只是 Goal 写明产物=素描。

### ⑤ evals.json case 10 + eval-guide.md
- `evals.json` 加 case 10（id: 10），结构对齐现有 9 case（{id, prompt, expected_output, expectations[]}）。测的是 **reframe 行为**（不是自动派）：
  - prompt：构造一个"不熟领域的复杂多文件任务"（如"我要给一个我没见过的代码库加多阶段迁移"），足够触发 Plan 考虑 recon。
  - expected_output：triage returns enloom；phase-plan 的 Human Decisions 段**包含 recon decision 行**（yes/no/recommended 三态之一）；若信号触发则标 recommended。
  - expectations[]：
    1. "triage conclusion is enloom"
    2. "phase-plan Human Decisions section contains a recon decision line"
    3. "recon decision is one of: yes / no / recommended (not silently skipped)"
    4. "if a recommended signal is present (new domain / new file type / unclear scale), the recon decision is marked recommended"
    5. "no automatic recon dispatch without the Human Decision being present (reframe: decision is explicit, not silent)"
- `eval-guide.md` 更新：
  - :3 "covers nine cases" → "covers ten cases"
  - :5-17 表格加第 10 行：`| 10 | Unfamiliar-domain complex task | enloom + recon Human Decision present | Does Plan surface recon as an explicit decision (not silently skip)? (v0.6 P2 reframe) |`
  - :19 "most important cases" 句可不动，或补一句 case 10 测 reframe。

## Required Verification

> audited mode 必填。

Countable outputs:
- phase-plan.md: 1 个 Human Decision recon 行 + 1 个 Gate Check recon considered 行 = 2 处
- trigger-contract 或 workflow-steps: 1 处 triage recon 偏好
- scheduler-rules.md: 1 段升格（含 3 条 recommended 信号）
- researcher.md: 1 条 How-to-work 分支（第 6 条）
- evals.json: 1 个新 case（id 10）
- eval-guide.md: ≥2 处更新（"ten cases" + 表格第 10 行）

check_item 列表（Verify 阶段独立复核）：
- `grep -rn "recon considered" enloom-skill/references/templates/phase-plan.md` → 命中
- `grep -rn "recommended" enloom-skill/references/scheduler-rules.md` → 三信号规则命中
- `grep -n "If the task packet marks this as a recon" enloom-skill/prompt-assets/researcher.md` → 命中
- `grep -n '"id": 10' enloom-skill/evals/evals.json` → 命中
- `grep -n "recon Human Decision\|recon decision" enloom-skill/references/eval-guide.md` → 命中
- `grep -rn "recon" enloom-skill/references/trigger-contract.md enloom-skill/references/workflow-steps.md` → 命中（二选一落点）
- **reframe 对齐**：`grep -rn "自动派\|first task 自动" enloom-skill/` → 应为 0（无 v1/v2 残留）
- 源/副本：`diff -r enloom-skill/ ~/.agents/skills/enloom/` → 改动文件无差异

## Evidence Required

每个 check_item 用 Evidence Contract 四要素回答（Checks Run / Evidence / Not Checked / Known Blind Spots）。report.md 里给。

## Review Budget

~1500 字。逐文件 old→new 摘要进 output.md，结论进 report.md。

## Pending / Promise Registry Updates

- P2-C（scheduler-rules）引用 P2-A（phase-plan Human Decision）—— 双向交叉引用，本 packet 内闭合。

## Human Decision Gate

无（Phase 3 的 Human Decision recon 已在 phase-plan-3.md 标 yes-skip，本 task 是熟域执行）。

## Done Signal

Return `done` / `blocked` / `failed` + 路径。`done` 须含：源 5 文件改完 + 副本同步 + diff 校验通过 + output.md + report.md。
