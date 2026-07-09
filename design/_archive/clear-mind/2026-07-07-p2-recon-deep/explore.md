# Explore · enloom v0.6 P2-recon 升格（详版重跑）

```yaml
created: 2026-07-07
project: enloom-v06-p2-recon-deep
stage: explore
status: finalized
input: "用 clear-mind 完整流程，完整详细地分析一下 v0.6 P2 recon 规划"
supersedes: .clear-mind/2026-07-06-p2-recon/ (上轮已落 explore/plan/review，verdict=CONDITIONAL；本轮补上轮自述缺口：evals.json 实读、task-packet Mode/Role 双字段实读、v0.5 S2 原文实读)
```

> **Reading Budget**: ~8 min read（约 3200 字。比上轮 explore 厚，因本轮实读了上轮标注"未读"的 evals.json schema + task-packet 双字段 + v0.5 S2 原文裁决，材料底座更实。）

## Uncertain Items Summary

> 先看这段判断材料可靠性，再决定是否深入。

- **"升格必然加结构 vs v0.5 红线不加阶段/字段/术语"的核心张力** —— 这是承重判断，全部基于一手实读（scheduler-rules.md:53-59 + v0.5 design S2 原文），非印象。**可靠**。→ §2.1
- **"P0 漏扫 → recon 必须 sub-agent 化"的因果链** —— archive-1-entry 自己这么归因（§Dogfood 验证总结 #3），但属自评，无独立复跑数据。**部分归因，待 review stress**。→ §2.1 / §5
- **evals.json 当前只有 9 个 case、无 recon case、无 trigger-eval 覆盖 recon 触发** —— 一手实读确认（evals.json:1-100 全文）。**可靠**，且补上轮缺口。→ §2.1
- **task-packet 已有 `Mode:` + `Role:` 双顶层字段** —— 一手实读（task-packet.md:3-4）。这改变了"加 recon 字段是否越红线"的判断维度。→ §2.1 / §5

## 0. 原始诉求（用户原话）

> "用 clear-mind 的skill完整详细的分析一下v0.6 P2 recon 规划"

上下文：用户是 enloom 作者，在用 enloom dogfood 修 enloom 自身。v0.6 已闭合 P0（叙事翻转）+ P0.5（补齐）+ P1（角色命名硬化 + trim rule），`project_state.md:32` 把 **P2-recon** 标为 pending，三件交付物已列。用户要在动手实现 P2 前，用 clear-mind **完整、详细**地想清楚 P2 recon 升格到底怎么做、做到什么程度、值不值得做。上轮（2026-07-06）已跑过一次 explore→plan→review，verdict=CONDITIONAL；本轮按"完整详细"要求重跑并补缺口。

## 1. prepare 摘要

- **归一化诉求**：在 enloom v0.6 dispatch-default 翻转完成后（默认 sub-agent、无能力即中断不退化），把 v0.5 故意 down-scope 成"一段调度指引"的 recon（侦察）**升格为 first-class sub-agent task pattern**——具体落到 `researcher.md` 加 recon 行为/模式、`phase-plan.md` 加 recon 结构位、`evals.json` 加 recon case。在动手实现前，用 clear-mind 裁决"升格到什么程度才不重蹈 v0.5 否决的 over-engineering，又能真正解 dispatch-default 下的预研前置缺口"，并给三件交付物咬合的细化设计。
- **信源优先级**：本地一手（enloom skill 源文件 + v0.6 dogfood 项目目录 + v0.5 design 原文 + evals.json 原文）> 现有 wiki（无）> Web（本案无外部可比对象，不适用）> LLM 内置（仅背景常识）。本轮 100% 落在本地一手。
- **搜索策略**（动态生成，本案全被本地一手覆盖，仅记框架）：
  - 领域相关：① "LLM orchestrator pre-research / recon / scout stage pattern" ② "task decomposition scale-mismatch rework" ③ "pre-flight vs first-task-heuristic tradeoff"
  - 通用：① 相关方案的官方文档/规格 ② 失败案例 ③ A vs B 对比
- **wiki 检测结果**：☐ 未检测到项目内 wiki，跳过。

## 2. gather 汇总（4 信源维度）

### 2.1 本地一手（最高优先级，本轮全部实读）

**(A) recon 的现状定义（唯一承重处）** —— `enloom-skill/references/scheduler-rules.md:53-59`「新 domain 的侦察调度（v0.5 指引）」全文实读：

- **可量化事实**：recon 现在是 **1 段调度指引**，标题后括号明确标注"v0.5 指引"。踩坑来源是 art_lab #16（原规划 3 agent ~100 条，预研后发现 ~180 条 → 返工）。现行规则：Plan 遇不熟领域时把**第一个 task 设为侦察 task**，用**现有 task-packet**（`mode: emergent`，`Allowed Tools: Read / Grep / Web`），其 output 喂回 Plan 修正切分。自评"吃下约 80% 的『预研前置』价值，且零结构改动（无需 Pre-flight 子阶段、无需 `pre_flight_needed` 字段）"。
- **边界条件**：recon 的 done signal = "**一份可读的规模/结构素描**"，**不是产物本身**。判据明写：Plan 对目标 domain 的规模/结构/边界没把握 → 首 task 为 recon；有把握 → 跳过。
- **内部矛盾（核心张力）**：scheduler-rules 现行版本同时说"零结构改动（无需 Pre-flight 子阶段、无需 `pre_flight_needed` 字段、非新阶段/非新字段/非新术语）"，而 `project_state.md:17` Goal 明写"recon 升格"。**"升格"语义上必然要加某种结构，这与 v0.5 划下的"不加阶段/字段/术语"红线直接冲突。** 这是 P2 的核心矛盾，整个裁决围绕它。

**(B) v0.5 否决 S2 的原始裁决（本轮实读原文，补上轮二手转述）** —— `design/2026-07-01-enloom-v0.5-optimization-design.md:79-95`（S2 全文）：

- **可量化事实**：原 S2 提案 = "Plan 与 Execute 之间加可选子阶段 **Pre-flight（预飞）** + `pre_flight_needed: true/false` 字段 + glossary 加 Pre-flight 术语"。评审**否决**，理由原文："**方案过重**：新增子阶段 + `pre_flight_needed` 字段 + glossary 术语，对当前成熟度的 skill 是 over-engineering。"降级方案原文："Plan 遇到不熟领域时，**第一个 task 就是侦察 task**（用现有 task-packet，mode=emergent，Allowed Tools=Read/Grep/Web）。这不需要新阶段，只需 `scheduler-rules.md` 加一段调度指引……吃下约 80% 的价值且零结构改动。"
- **边界条件（升格触发条件，原文）**："若未来真实并行规模到来再升级为正式子阶段。"**这正是 P2 援引的合法性来源**——但注意 v0.5 只说了"真实并行规模"，**没说"成熟度"**。v0.5 否决理由是**两条**（"方案过重" + "对当前成熟度 over-engineering"），触发升格的条件只列了**一条**（并行规模）。"成熟度"那条没有给升格触发条件，是缺口。
- **内部矛盾**：v0.5 否决的是"Pre-flight **子阶段** + **字段** + **术语**"（重结构）。P2 三件交付物里——researcher.md 加"模式"、phase-plan 加"结构位"——是**中等结构**，介于"零结构"和"子阶段+字段+术语"之间。**v0.5 从未给过这个中间档的裁决**，P2 实际是在开辟一个 v0.5 未评判过的设计空间。这条判断本轮实读原文后更确凿（上轮二手转述一致，但本轮能引原文行号）。

**(C) P2 的实证触发（why now）** —— `.enloom/2026-07-06-enloom-v06/project_state.md:9` + `archive/phase-1-entry.md:67`：

- **可量化事实**：P0 dogfood 时，packet 边界（6 处叙事翻转点）由**主窗口手扫**设定（recon 未 dispatch 给 sub-agent），漏了 `evidence-contract.md:91/92/94` 编号项正文 → 触发 ISSUES → 开 P0.5 补齐。archive-1-entry §Dogfood 验证总结 #3 原文："**暴露 packet 设计缺陷（实证 P2 需求）**：P0 packet 的 6 处边界漏了 evidence-contract 编号项正文，导致 ISSUES。根因是扫描/recon 由主窗口做，没系统化覆盖。"
- **边界条件**：这是 D1/D5 痛点（complex 任务预研没进 sub-agent）的真实复现，被引为"recon 必须是 sub-agent task 而非主窗口顺手做"的直接证据。
- **内部矛盾（plan/review 要警惕）**：archive-1 **自己归因**为"扫描/recon 由主窗口做，没系统化覆盖"。但这句话把两个根因混在了一起：① "由主窗口做" ② "没系统化覆盖"。**即使 dispatch 给 sub-agent，若 packet 边界本身没系统化覆盖，sub-agent 一样会忠实漏掉 packet 没列的东西。** 升格改变"谁扫、何时扫"，不必然改变"扫什么/覆盖是否系统"。这个因果链是 P2 必要性的关键论据，**可能过度归因**，review 必须检验。

**(D) 三件交付物的落点 + 将被改的文件（本轮全部实读真实结构）**：

- **交付物 ① `researcher.md` 加 recon** —— `enloom-skill/prompt-assets/researcher.md`（全文 47 行，v0.2）实读：
  - 现状：Role = "bounded research worker（lifecycle Stage 3 Execute）"。Permissions 表（Read repo/docs ✅ / Write output.md+report.md ✅ / 改源 ❌ / 架构决策 ❌）。Output = output.md（research findings）+ report.md（Evidence Contract 四要素）。How to work 5 条（只读 packet 列的 input、不读别的 run 的 raw、守 Anti Goal、压缩进 report、分 fact/synthesis）。Done Signal = done/blocked/failed。
  - **关键发现（本轮新）**：researcher.md **没有任何 mode 分支**——它是通用 read-only worker。要"加 recon"，要么加 `Mode:` 顶层字段（越 v0.5 红线），要么在 How-to-work 加一条行为分支（"若 packet 标 recon，产物是规模/结构素描而非完整 research"）。
  - 内部矛盾：researcher 的 Done Signal 是"research complete"，recon 的 done signal（scheduler-rules）是"规模/结构素描"——**产物语义不同**。recon 若直接套 researcher 的 output/report 二分，会产出过重（完整 research findings），而 recon 要的是轻量素描。
- **交付物 ② `phase-plan.md` 加 recon 结构位** —— `enloom-skill/references/templates/phase-plan.md`（74 行）实读：
  - 现有段（顺序）：Phase Goal / Anti Goal / Constraints / Strategy / Ownership Table / Reference Tolerance Decision Table / Promise Registry Draft / **Tasks**（`- T001:` 裸列表）/ Review Plan / Human Decisions / Gate Check。
  - 关键发现：Tasks 段是裸列表，**无显式 recon slot**。若在 Tasks 前加"recon task（可选，遇不熟领域）"提示位，它和现有 emergent-mode task 是**同构**的——结构位只是**提示 Plan 考虑先派 recon**，不引入新字段。这是"升格但不过度"的最小形态。
  - Gate Check 是 exit gate（落盘到 `tasks/phase-plan-<phase>.md`），可直接加一条"recon task considered: yes/no"。
- **交付物 ③ evals.json 加 recon case** —— `enloom-skill/evals/evals.json`（**本轮新读，补上轮缺口**）+ `references/eval-guide.md`（129 行）实读：
  - **现状**：evals.json 有 **9 个 case**，结构 = `{id, prompt, expected_output, expectations[]}`。case 1-9 覆盖 triage（1/2/3）、strategy serial vs parallel（4）、review evidence gate（5/6/7）、Promise Registry（8）、Compaction（9）。**无任何 recon case**。
  - eval-guide.md:5-17 的"What the evals test"表明列 case 1-9，**无 case 10**。eval-guide 自己说"最重要的 case 是 2/3/6/7/9"（over-trigger / over-read / evidence-free PASS / risk-loss）——recon 不在其列。
  - **关键发现（本轮新，且重要）**：eval-guide.md:59-67 有一个**独立的 trigger eval 体系**（`trigger-evals.json`，20 queries，60/40 train/test），专门测"只给 description 字段，模型会不会 INVOKE/BYPASS"。eval-guide.md:110-111 明确："只在 skill body 稳定后才跑 trigger eval。"——**P2 加 recon case 有两条可能路径**：(a) 在 9-case 主 suite 加 case 10（测 triage/plan 会不会派 recon，属"决策"测）；(b) 在 trigger-evals.json 加（测 description 会不会触发 recon，属"触发"测）。**这两条不等价**，P2 要选哪条、还是都加，是个待 plan 决策的设计点（上轮完全没触及这个区分）。
  - 边界条件：9-case suite 是"喂完整 skill body 测决策"；trigger suite 是"只给 description 测触发"。eval-guide.md:62 明确警告"Do not conflate the two."。
  - 内部矛盾：recon 升格若主要靠"Plan 遇不熟领域自觉派"，那它更接近"决策"（9-case case 10）；若主要靠 description 触发，则需进 trigger-evals。**P2 当前三件交付物只说"eval 加 recon case"，没区分是哪种 eval**——这是个隐藏的设计未决点。

**(E) task-packet 的 Mode/Role 双字段（本轮新读，与红线判断强相关）** —— `enloom-skill/references/templates/task-packet.md:1-19` 实读：

- **可量化事实**：task-packet 头部已有两个顶层字段：`Mode: emergent | recorded | audited`（行 3）+ `Role: researcher | coder | reviewer | integrator | tester`（行 4）。v0.5 mode-differentiated 字段表（行 9-17）已按 mode 差异化字段要求。
- **关键发现（本轮新，影响红线判断）**：**`Role:` 字段已经是一个"枚举角色"的顶层字段**。researcher.md 加"recon 模式"，**最干净的做法不是加 `Mode:` 值，而是在 `Role:` 枚举里加一个 `recon` 值**（`Role: researcher | coder | reviewer | integrator | tester | recon`），或者把 recon 作为 researcher 的一个子角色。但——v0.5 红线是"不加**新术语**"。`recon` 这个词 scheduler-rules 已经用了（不算新术语），但把它升成 `Role:` 枚举值，算不算"加字段/术语"？**这是 v0.5 红线的边界灰色地带**，plan/review 要裁决。上轮 explore/plan 都没注意 task-packet 已有 Role 字段，本轮补上。

### 2.2 现有 wiki / 知识库

- 无，跳过（§1 已检测无 wiki）。

### 2.3 外部网络（Web）

- 未收集。本案是 enloom 内部设计决策，recon 作为 orchestrator 内部 task pattern 不属公开技术范畴。LLM orchestrator 领域的"pre-research stage"做法多见于各家私有 pipeline（如 pi-sdk auto-research DAG），但属"他山之石"范畴，留给 plan 模块 C/D，不在 explore 裁决。

### 2.4 LLM 内置领域知识（仅补充，不作判断依据）

- **可量化事实**：多 agent orchestrator 普遍有"先 scout/recon 再 decompose"模式（如 auto-research 的 cheap-gather→quality-analyze DAG）；价值在用便宜预算探规模，把贵预算留给真正分析。
- **边界条件**：这类模式有效的前提是 gather 与 analyze 能用**不同模型预算**且 gather 足够便宜。
- **内部矛盾（上轮已纠正，本轮沿用）**：enloom 的 recon worker 和 execution worker 当前都派给同一种 sub-agent（general-purpose），**无"便宜探、贵的做"的预算分层**。但用户在上轮 review 阶段纠正：若 recon 与 execution 都跑 DeepSeek-V4-Pro（thinking=max）这类**廉价强模型**，"贵/便宜分层"不再是必要条件——强模型两边都敞开跑，DAG 价值从"省钱"转成"用独立上下文探边界、降低主窗口 prompt 污染"。**本轮采纳此纠正**：成本维度被消解，"独立上下文 vs 主窗口污染"维度仍成立。

## 3. 语义线索（关键发现位置索引）

- **核心声称所在位置**：
  - recon 现状定义 → `enloom-skill/references/scheduler-rules.md:53-59`（整段是承重墙，"零结构改动"句在 :57）
  - v0.5 否决 S2 原文裁决 → `design/2026-07-01-enloom-v0.5-optimization-design.md:79-95`（:91 "方案过重" + :93 "更轻的替代" + :95 "若未来真实并行规模到来再升级"）+ Non-Goals（:262 区附近，"待真实多 sub-agent 并行常态化后再评估"）+ 改动清单 S2 行"降级"
  - P2 实证触发 → `.enloom/2026-07-06-enloom-v06/project_state.md:9`（dogfood 回看）+ `archive/phase-1-entry.md:67`（P0 漏扫，§Dogfood 验证总结 #3）
  - 三件交付物清单 → `project_state.md:32` + `archive/phase-2-entry.md:48`
  - **evals.json 9 case 结构（本轮新）** → `enloom-skill/evals/evals.json:1-100`（结构在 :3-14 的 case 1）
  - **trigger-evals 独立体系（本轮新）** → `enloom-skill/references/eval-guide.md:59-67`（trigger eval）+ `:110-115`（body 稳定后才跑）
  - **task-packet Mode/Role 双字段（本轮新）** → `enloom-skill/references/templates/task-packet.md:3-4`
- **疑似概念混淆处**：
  - `scheduler-rules.md:57` "recon 用现有 task-packet" vs `researcher.md` 要"加 recon"——前者说"不需要新东西"，后者要"加新东西"。措辞需对齐（可能"加"只是 How-to-work 一个分支，不是新 packet 类型）。
  - "升格"（elevation）的语义边界不清：是"加结构位/分支但仍是 emergent task"，还是"升成独立 stage"？`project_state.md:17` 说"首 task 为 sub-agent recon"，倾向前者（仍是一个 task），但术语未硬化。
  - **"eval 加 recon case"——是 9-case 主 suite 的 case 10（测决策），还是 trigger-evals（测触发）？三件交付物未区分（本轮新发现）。**
  - **task-packet 已有 `Role:` 枚举字段——recon 是加进 Role 枚举、还是加进 Mode、还是只是 researcher 的子行为？三选未定（本轮新发现）。**
- **关键论证起点**：plan 若论证"P2 必要"，从 `archive/phase-1-entry.md:67` 的 P0 漏扫因果链起读；若论证"P2 不该过度升格"，从 `design/...v0.5-optimization-design.md:91-95` 的否决+触发条件起读。

## 4. 信息充分度判断

> ⚠️ 材料充分度，不是方案裁决。

勾选：**☑ 充分**（本轮较上轮升级：上轮标"部分"，缺口 1 是 eval case 形态未知；本轮已读 evals.json + eval-guide.md，缺口 1 已消除）

- **主干全覆盖**：recon 现状、v0.5 否决原文、P2 实证触发、三件交付物落点、两个将被改的文件真实结构、**evals.json 9 case 结构 + trigger-evals 独立体系、task-packet Mode/Role 双字段** —— 全部一手实读，无关键缺口。
- **剩余项不是材料缺口，是设计决策（plan 的活）**：
  1. ~~eval case 形态未知~~ —— **本轮已消除**：9-case suite `{id,prompt,expected_output,expectations[]}` + trigger-evals.json 独立体系，P2 选哪条待 plan 决策。
  2. researcher.md 的"recon"实现路径（Role 枚举值 / Mode 值 / How-to-work 分支）—— 待 plan 决策，非材料缺口。**本轮新增维度：task-packet 已有 Role 枚举，影响这个决策。**
  3. 三件交付物一致性契约（recon worker 输出 ↔ phase-plan 结构位输入如何咬合）—— 待 plan 设计。
  4. 预算分层问题 —— 上轮已由用户纠正消解，不再是缺口。

## 5. 给 plan/review 的交接

- explore.md 已存在 → plan 先读它（已满足 plan-method §0 入口闸门）。
- **下游最该带着的五条材料（本轮较上轮多两条）**：
  1. **P2 核心矛盾** = "升格必然加结构" vs "v0.5 红线 = 不加阶段/字段/术语"。v0.5 升格触发条件原文只列了"真实并行规模"（已被 v0.6 dispatch-default 满足），但否决理由有两条（"方案过重" + "成熟度 over-engineering"），第二条没给触发条件——**这是裁决 P2 合法性时 plan 要正面处理的治理债**。
  2. **三件交付物里**，researcher.md recon + phase-plan 结构位是"中等结构升格"，eval case 是配套验证。P2 的设计空间在"中等结构"这个 v0.5 未评判过的档位。
  3. **P2 必要性因果链（P0 漏扫 → recon 必须 sub-agent 化）需被检验是否过度归因**（archive-1 把"主窗口做"和"没系统覆盖"混在一起，sub-agent 化只解前者）。
  4. **【本轮新】eval case 有两条路径**：9-case 主 suite（测决策"会不会派 recon"）vs trigger-evals（测触发"description 会不会让模型想到 recon"）。P2 三件交付物只说"加 recon case"未区分，plan 要裁决加哪条/是否都加。
  5. **【本轮新】task-packet 已有 `Role:` 枚举字段**（researcher|coder|reviewer|integrator|tester）。researcher.md 加 recon，最干净可能是 Role 加 `recon` 值或 researcher 子角色，但这触及 v0.5 "不加新术语/字段"红线的灰色地带，plan 要裁决。
- plan 据此走诉求剖析 → 第一性原理 → askBQ A-F；review 对 plan 结论做边界应力测试，最后三态裁决。**本轮 review 应较上轮更严，因材料更实、暴露的设计未决点更多（eval 路径 + Role 字段）。**

`[gate] explore.md exists? → yes`

---

## 6. Reframe 补遗（v2 落盘后用户换轴，补一手材料）

> **状态**：本节在 §1-5（原方案材料）落盘后补。原方案（Plan 自动派 recon）被 review §6 推翻为"人机决策门 + recommended 信号"。本节补 reframe 所需的、§1-5 未覆盖的一手事实。**§1-5 不删——它们是"为什么走到 reframe"的推理链**（正是 §3 的因果链裂缝 + v0.5 红线张力，逼出了 reframe）。信息充分度结论（§4 充分）**不变**——reframe 没引入新的未知一手材料，只是把已有材料重新组合。

### 6.1 reframe 依赖的既有机制（一手实读确认）

reframe 的核心论点是"零结构改动，复用既有 Human Decision 机制"。三条一手事实支撑：

- **phase-plan.md 已有 "Human Decisions Needed" 段**（`enloom-skill/references/templates/phase-plan.md:64`）—— reframe 机制 (a) 往这里加一行 recon 决策模板，**非新机制**。Gate Check 段（:67）可加 "recon considered: yes/no" 行作为出口自检。
- **project-state.md 的 Registry 是结构化的**（`enloom-skill/references/templates/project-state.md:16-53`）—— 含 Pending Dependencies / Promised Outputs / Broken References / Accepted With Risk / Rejected Reports。recommended 信号的"Registry 无覆盖"判断**有实读对象**：Plan 读 project_state.md 的 Registry 段，看有没有该 domain 的风险段。这不是新判断，是 Orient 阶段（`project-state.md:53` 注"control agent scans this on Orient"）本来就在做的事的副产物。
- **task-packet 的 Role/Mode 双字段仍在**（task-packet.md:3-4）—— 但 reframe 下**不需要动它们**：recon task 就是普通 emergent task，Role 仍填 researcher，只是 Goal/Anti-Goal 写明"产物=规模素描"。v2 纠结的"Role 枚举加 recon 值是否越红线"问题，在 reframe 下**直接消失**（不动枚举）。

### 6.2 reframe 改变的信息充分度判断

§4 原判"充分"。reframe 后**仍充分**，且部分原本是"设计决策"的项变成了"既有机制复用"：

- ~~researcher.md 的 recon 实现路径（Role 值 / Mode 值 / 分支）~~ —— reframe 下：researcher.md 加一条 How-to-work 分支（"若 packet 标 recon，产物是规模素描"），不动枚举。**已定**。
- ~~三件交付物一致性契约~~ —— reframe 下：recon task 是普通 emergent task，输出喂回 Plan 修正切分（scheduler-rules 既有机制）。**已定**。
- **新增待定（reframe 引入）**：recommended 三信号规则落 scheduler-rules 还是 phase-plan 注释；triage 接偏好的接口（trigger-contract 还是 workflow Stage 1）。这两项是 P2 实现决策，非材料缺口。

### 6.3 给 v3 plan/review 的交接（取代 §5 的五条）

reframe 后，下游最该带的三条材料（取代 §5 原五条——原五条服务于已被推翻的"自动派"方案）：

1. **reframe 的合法性** = phase-plan.md:64 已有 Human Decisions 段 + project-state.md Registry 结构化 + task-packet Role/Mode 不需动。三事实合一 → 零结构改动，不碰 v0.5 红线。
2. **recommended 信号的工程性** = 三信号（Registry 无覆盖 / 新文件类型 / 规模边界不明）都是 Orient/Plan 阶段本来就在做的判断的副产物，非新工作量。"判熟不熟"被降级成"判有没有信号"——机械、廉价、可错但安全（recommended 非强制）。
3. **reframe 不解的裂缝** = art_lab #16 根因（人没预研）。门防"决策被静默跳过"，不防"决策做错"。这条跨所有方案恒存，reframe 不假装能解——但比 v1/v2（靠 agent 自觉防漏扫）叙事更诚实。

`[gate] explore.md exists? → yes (v2 + reframe 补遗 §6)`
