# P2-recon 升格 · output（逐文件 old→new 改动摘要）

> 交付物 ①-⑤ 落地 review §7 reframe + recommended 终版。零结构改动（不新增 stage / 顶层字段 / Role 枚举值 / Pre-flight 子阶段）。源 5 文件 + ② 落点文件 = 6 文件改完，cp 同步到 `~/.agents/skills/enloom/`，`diff -r` 全树一致。

## ① phase-plan.md（references/templates/）

**old** — `## Human Decisions Needed`（:64）下方为空；`## Gate Check`（:67-74）5 行出口自检，无 recon。

**new** —
- Human Decisions 段加 `recon decision (v0.6 P2 reframe)` 决策块：一句问题（"该 phase 域是否需要先 recon？规模/结构/边界是否已明？"）+ 三态选项 `[ ] yes / no / recommended`，注明机制 a（Plan 摆决策不自动派）+ 交叉引用 scheduler-rules §recon 的信号规则。
- Gate Check 加第 6 行 `- recon considered (v0.6 P2): yes | no`（出口自检）。

净增 1 个 Human Decision 块 + 1 个 Gate Check 行 = 2 处（对齐 Countable outputs）。

## ② trigger-contract.md（references/）— 机制 b 落点

**old** — 无 recon 相关内容（"用户显式要求"段后直接接 triage 映射）。

**new** — 在"用户显式要求"段后加 `## recon 偏好(可选,机制 b)` 段：用户触发时可声明"要/不要 recon"，triage 透传给 Plan 影响 phase-plan recon Human Decision。显式声明"可选偏好不是强制"，未声明时默认走机制 (a)。关键约束句："enloom 只接收并透传偏好，不自己判断领域熟不熟"（机制 c 的 recommended 只靠三信号，不靠"熟不熟"判断）。

落点选 trigger-contract.md（task.md §② 倾向"声明随触发"，且偏好随 triage 入口自然落位）。1 处（对齐 Countable outputs）。

## ③ scheduler-rules.md（references/）

**old** — `## 新 domain 的侦察调度(v0.5 指引)`（:53-59）：art_lab #16 踩坑 + v0.5 down-scope 指引（"Plan 把第一个 task 设为侦察 task"，隐含 Plan 自觉派）。

**new** — 标题升格为 `## recon 调度(v0.6 P2 reframe:人机决策门 + recommended 信号)`，整段重写（保留踩坑背景）：
- **升格**：recon 决策现在是 phase-plan Human Decision 的一行（不再"Plan 自觉派"），显式写"Plan 不自动派，只把决策摆出来等人定"。删除 v0.5 "把第一个 task 设为侦察 task" 这句（CHECK7 应清理的 v0.5 残留）。
- **recommended 三信号规则（机制 c，P2 第一版核心）**：① Registry 无该域风险段（新 domain）② 新文件类型 ③ 规模/边界不明。注明 salience（agent 廉价可错）与决策（人）分离 + 新项目 Registry 空时 false positive 裂缝。
- **保留**：recon task 仍是普通 emergent task（mode: emergent, Allowed Tools: Read/Grep/Web）+ done signal = 规模/结构素描。交叉引用 researcher.md How-to-work 第 6 条。
- **双向交叉引用**：本段 P2-C ↔ phase-plan Human Decision P2-A（Promise Registry 本 packet 内闭合）。
- **诚实边界**：recon 防"决策被静默跳过"，**不防**"决策做错"，**不防**"覆盖不完整"（packet 外照样漏）。卖点 = "给预研一个结构化位置 + 降低主窗口 prompt 污染"，不是"防漏扫"（reframe §6.2 + §7 X 降级）。

1 段升格（含 3 条 recommended 信号）（对齐 Countable outputs）。

## ④ researcher.md（prompt-assets/）

**old** — `## How to work`（:32-38）1-5 条，无 recon 分支。Role/Mode 枚举未涉及。

**new** — 加第 6 条（编号续，task.md §④ 原文照引）：`If the task packet marks this as a recon task` → 产物是轻量规模/结构素描（file counts / entry counts / structure map / boundary notes），非完整 research；喂回 Plan 修正切分；对齐 Evidence Contract 四要素（Checks Run=inputs read / Evidence=sketch+sources / Not Checked=outside packet / Known Blind Spots=uncertainties）；勿过度研究。末尾交叉引用 scheduler-rules §recon。**不动 Role/Mode 枚举**（recon task 仍是普通 emergent task，Role 仍 researcher）。

1 条分支（第 6 条）（对齐 Countable outputs）。

## ⑤ evals.json + eval-guide.md（evals/ + references/）

**evals.json** — case 10（id: 10）加在 case 9 后，结构对齐（{id, prompt, expected_output, expectations[]}）：
- prompt：构造不熟领域 + 多阶段 + 显式规模未明（"codebase I've never seen before… don't want to commit to a decomposition before I understand the scale"）——足够触发 Plan 考虑 recon + 触发 recommended 信号。
- expected_output：triage returns enloom；phase-plan Human Decisions 含 recon decision 行（yes/no/recommended 三态之一）；信号触发故标 recommended。
- expectations[]：5 条（triage=enloom / Human Decisions 含 recon 行 / 三态之一非静默跳过 / 信号出现标 recommended / 无自动派——reframe 决策显式非静默）。测的是 reframe 行为（不是自动派）。
- JSON 校验：`python3 -c json.load` 通过，10 cases，id 10 在位。

**eval-guide.md** —
- :3 `nine cases` → `ten cases`。
- 表格加第 10 行：`| 10 | Unfamiliar-domain complex task | enloom + recon Human Decision present | Does Plan surface recon as an explicit decision (not silently skip)? (v0.6 P2 reframe) |`。
- "most important cases" 句补一句：case 10 测 v0.6 P2 reframe（recon 须显式 Human Decision + 信号触发标 recommended，非自动派非静默跳过）。
- **判定项**：另外 4 处 "nine-case/9-case" 引用（:62 :64 :112 :125）指的是"上述 decision suite"，因 case 10 加入后 suite 从 9 变 10，若保留"nine-case"会与 10 行表格自相矛盾。故一并更新为"ten-case/10-case"保持内部一致。此为 ⑤ 范围内的连带一致性维护（task.md §⑤ :19 允许"补一句 case 10"），非无关重构。

eval-guide.md 共 6 处更新（1 句"ten cases" + 1 表格行 + 1 "most important" 补句 + 4 处 nine→ten；其中"≥2 处"硬要求满足）。

## 同步 + diff

6 文件 cp 到 `~/.agents/skills/enloom/`（5 列表文件 + ② trigger-contract.md）。`diff -r enloom-skill/ ~/.agents/skills/enloom/` 全树无差异。

## 判定项 / 已知判断

1. **② 落点**：选 trigger-contract.md（task.md §② 明示倾向，"声明随触发"）。
2. **sync 6 非 5**：task.md :41 写"5 文件×2=10 处"，但 §② 把 trigger-contract.md 也纳入 writable（OR-分支解为 trigger-contract）。故同步 6 文件。副本 trigger-contract.md 原本就在（非新建），仅覆盖。
3. **eval-guide.md 的 9→10 连带**：见上 ⑤。判断为 ⑤ 范围内一致性维护，非越界。
