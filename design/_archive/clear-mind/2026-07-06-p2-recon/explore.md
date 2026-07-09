# Explore · enloom v0.6 P2-recon 升格

```yaml
created: 2026-07-06
project: enloom-v06-p2-recon
stage: explore
status: finalized
input: "用 clear-mind 完整流程，每个流程都详细一点，我准备设计一下 P2 recon"
```

> **Reading Budget**: ~6 min read(约 2400 字)。本文是 plan/review 的材料底座，聚焦"recon 现状是什么 / v0.5 为什么 down-scope / P2 要升格什么"三件事，不展开方案裁决(那是 plan/review 的事)。

## Uncertain Items Summary

> 先看这段判断材料可靠性，再决定是否深入。

- **未实测的"高杠杆"假设**:recon 升格成 task packet 后真能复现"80% 预研前置价值"，但此判断来自 v0.5 设计文档自评，无独立运行数据佐证 → §2.1 / §3
- **eval case 的具体形态待定**:三件交付物中 eval case 最为模糊，现有 `eval-guide.md` 未读真实内容，是否已有"侦察 case"的范式不可知 → §4 标"不足"
- **"recon 模式"与 researcher.md 现有结构的关系**:是新增一个并列 mode、还是加一段 How-to-work 分支，design 文档未明说 → §3

## 0. 原始诉求(用户原话)

> "用 clear-mind 完整流程，每个流程都详细一点，我准备设计一下 P2 recon"

上下文：用户是 enloom 的作者，正在用 enloom dogfood 修 enloom 自身。git log 显示 v0.6 已完成 P0(叙事翻转)+ P0.5(补齐)+ P1(角色命名硬化)。`project_state.md` Active Tasks 标 P2-recon 为 pending，并列出三件交付物。用户要用 clear-mind 在动手前先想清楚"P2 recon 升格到底怎么做、值不值得做、做到什么程度"。

## 1. prepare 摘要

- **归一化诉求**：在 enloom v0.6 dispatch-default 翻转完成后，把 v0.5 故意 down-scope 成"一段调度指引"的 recon(侦察)升格成 first-class sub-agent task pattern —— 具体落到 researcher.md 加 recon 模式 / phase-plan.md 加 recon 结构位 / eval 加 recon case。在动手实现前，用 clear-mind 裁决"升格到什么程度才不重蹈 v0.5 否决的 over-engineering，又能真正解 dispatch-default 下的预研前置缺口"。
- **信源优先级**：本地一手 > 现有 wiki > Web > LLM 内置。本文以本地一手(enloom skill 源文件 + v0.6 dogfood 项目目录 + v0.5 design 文档)为主，Web/wiki 不适用(无外部可比对象)。
- **搜索策略**(动态生成，本案多被本地一手覆盖，仅列框架)：
  - 领域相关：①"LLM orchestrator pre-research/recon stage pattern"②"task decomposition scale-mismatch rework"③"pre-flight vs first-task-heuristic tradeoff"
  - 通用：①相关方案的官方文档/规格 ②失败案例 ③A vs B 对比
- **wiki 检测结果**：☐ 未检测到项目内 wiki，跳过。

## 2. gather 汇总(4 信源维度)

### 2.1 本地一手(最高优先级：enloom skill 源 + v0.6 dogfood 目录 + v0.5 design)

**recon 的现状定义(唯一承重处)** —— `enloom-skill/references/scheduler-rules.md:53-59`「新 domain 的侦察调度(v0.5 指引)」：
- **可量化事实**：recon 现在是 **1 段调度指引**，明确标注"非新阶段、非新字段、非新术语"。踩坑来源是 art_lab #16(原规划 3 agent ~100 条，预研后发现 ~180 条 → 返工)。当前规则：Plan 遇不熟领域时把**第一个 task 设为侦察 task**，用**现有 task-packet**(`mode: emergent`, `Allowed Tools: Read / Grep / Web`)，output 喂回 Plan 修正切分。自评"吃下约 80% 预研前置价值，零结构改动"。
- **边界条件**：recon 的 done signal = "一份可读的规模/结构素描"，**不是产物本身**。判据：Plan 对目标 domain 的规模/结构/边界没把握 → 首 task 为 recon；有把握 → 跳过。
- **内部矛盾**(关键张力点)：scheduler-rules 现行版本同时说"零结构改动(无需 Pre-flight 子阶段、无需 `pre_flight_needed` 字段)"，而 `project_state.md` Goal 明写"recon 升格"。**"升格"语义上必然要加某种结构(recon 模式/结构位/eval case)，这与 v0.5 划下的"不加阶段/字段/术语"红线直接冲突。** 这是 P2 的核心矛盾。

**v0.5 否决 S2 的原始理由** —— `design/2026-07-01-enloom-v0.5-optimization-design.md:79-96`(S2)+ `:262`(Non-Goals)+ `:276`(改动清单)：
- **可量化事实**：原 S2 提案是"Plan 与 Execute 之间的 Pre-flight 子阶段 + `pre_flight_needed` 字段"。评审**否决**为 over-engineering("对 skill 当前成熟度而言过度工程")，降级为 scheduler-rules 一段。
- **边界条件**：评审留了一句话作为升格触发条件——"若未来真实并行规模到来再升级为正式子阶段"。**这正是 P2 现在援引的合法性来源**：v0.6 dispatch-default 让 sub-agent 真实可派，"真实并行规模"前提满足了。
- **内部矛盾**：v0.5 否决的是"Pre-flight **子阶段** + **字段**"(重结构)。P2 三件交付物里，researcher.md 加"模式"、phase-plan 加"结构位"——这是中等结构，介于"零结构"和"子阶段+字段"之间。**v0.5 没有给过这个中间档的裁决**，P2 实际是在开辟一个 v0.5 未评判过的设计空间。

**P2 的实证触发(why now)** —— `.enloom/2026-07-06-enloom-v06/project_state.md:9` + `archive/phase-1-entry.md:67`：
- **可量化事实**：P0 dogfood 时，packet 边界(6 处叙事翻转点)由**主窗口手扫**设定(recon 未 dispatch)，漏了 `evidence-contract.md:91/92/94` 编号项正文 → 触发 ISSUES → 开 P0.5 补齐。
- **边界条件**：这是 D1/D5 痛点的真实复现——复杂任务的预研究没进 sub-agent。被引为"recon 必须是 sub-agent task 而非主窗口顺手做"的直接证据。
- **内部矛盾**(待 plan 警惕)：P0 的漏扫**也可能**只是 packet 设计本身的疏漏，未必全归因于"主窗口做 recon"。这个因果链是 P2 必要性的关键论据，plan/review 要检验它是否被过度归因。

**三件交付物的落点** —— `project_state.md:32` + `archive/phase-2-entry.md:48`：
- **可量化事实**：①`researcher.md` 加 recon 模式(现 researcher.md 是 v0.2，**无任何 mode 分支**，是通用 read-only worker)②`phase-plan.md` 加 recon 结构位(现模板有 Tasks 段，**无显式 recon slot**)③eval 加 recon case。
- **边界条件**：`project_state.md` 把 P2 的核心目标一句话定义为"复杂任务插预研究任务包"。
- **内部矛盾**：三件交付物之间的**一致性机制未定义**——researcher.md 的"recon 模式"输出格式，与 phase-plan.md 的"recon 结构位"要求的输入，是否对齐?没有设计文档说明两者如何咬合。

**researcher.md 现状(将被改的文件)** —— `enloom-skill/prompt-assets/researcher.md`(全文 47 行)：
- **可量化事实**：v0.2。Role = bounded research worker(Stage 3 Execute)。Permissions：可读 repo/docs、可写 output.md+report.md、不可改源/配置、不做架构决策。Done Signal = done/blocked/failed。How to work 5 条(只读 packet 列出的 input、不读别的 run 的 raw notes、守 Anti Goal、压缩进 report、区分 fact/synthesis)。
- **边界条件**：researcher 现在的 report.md 对齐 Evidence Contract 四要素(Checks Run / Evidence / Not Checked / Known Blind Spots)。
- **内部矛盾**：researcher 的 Done Signal 是"research complete"，但 recon 的 done signal(按 scheduler-rules)是"规模/结构素描"——**两者产物语义不同**。recon 模式若直接套 researcher 的 output/report 二分，可能产出过重(完整 research findings)，而 recon 要的是轻量素描。

**phase-plan.md 现状(将被改的模板)** —— `enloom-skill/references/templates/phase-plan.md`(74 行)：
- **可量化事实**：现有段：Phase Goal / Anti Goal / Constraints / Strategy / Ownership Table / Reference Tolerance Decision Table / Promise Registry Draft / Tasks / Review Plan / Human Decisions / Gate Check。Tasks 段是 `- T001:` 裸列表。
- **边界条件**：Gate Check 是 exit gate(落盘到 `tasks/phase-plan-<phase>.md`)。
- **内部矛盾**：若在 Tasks 前加"recon task(可选)"结构位，它和现有 emergent-mode task 是同构的——结构位只是**提示 Plan 考虑先派 recon**，不引入新字段。这是"升格但不过度"的最小形态。

### 2.2 现有 wiki / 知识库

- 无，跳过(§1 已检测无 wiki)。

### 2.3 外部网络(Web)

- 未收集。本案是 enloom 内部设计决策，无可比外部产品(recon 作为 orchestrator 内部 task pattern，不属公开技术范畴)。LLM orchestrator 领域的"pre-research stage"做法多见于各家私有 pipeline(如 pi-sdk auto-research DAG)，但属"他山之石"范畴，留给 plan 模块 C/D 处理，不在 explore 裁决。

### 2.4 LLM 内置领域知识(仅补充，不作判断依据)

- **可量化事实**：多 agent orchestrator 普遍存在"先 scout/recon 再 decompose"模式(如 auto-research 的 cheap-gather→quality-analyze DAG)；其价值在于用便宜预算探规模，把贵预算留给真正分析。
- **边界条件**：这类模式有效的前提是 gather 与 analyze 能用**不同模型预算**且 gather 足够便宜。
- **内部矛盾**：enloom 的 recon worker 和 execution worker 当前都派给同一种 sub-agent(general-purpose)，**没有"便宜探、贵的做"的预算分层**。recon 升格若不解决预算分层，"先 recon 再 decompose"可能只是把成本前置，而非真正省钱。此条标注"可能"，留 plan/review 检验。
- **用户后续纠正(review 阶段)**：若 recon 与 execution 都跑 DeepSeek-V4-Pro(thinking=max)这类**廉价强模型**，"贵/便宜分层"不再是必要条件——强模型两边都敞开跑，DAG 的价值从"省钱"转成"用独立上下文探边界、降低主窗口 prompt 污染"。原"可能"标注的成本维度被消解，但"独立上下文 vs 主窗口污染"维度仍成立。

## 3. 语义线索(关键发现位置索引)

- **核心声称所在位置**：
  - recon 现状定义 → `enloom-skill/references/scheduler-rules.md:53-59`(整段是承重墙)
  - v0.5 否决理由 + 升格触发条件 → `design/2026-07-01-enloom-v0.5-optimization-design.md:79-96`(S2 正文) + `:262`(Non-Goals 第 3 条"待真实多 sub-agent 并行常态化后再评估") + `:276`(改动清单 S2 行"降级")
  - P2 实证触发 → `.enloom/2026-07-06-enloom-v06/project_state.md:9`(dogfood 回看) + `archive/phase-1-entry.md:67`(P0 漏扫)
  - 三件交付物清单 → `project_state.md:32` + `archive/phase-2-entry.md:48`
- **疑似概念混淆处**：
  - `scheduler-rules.md:57` "recon 用现有 task-packet" vs `researcher.md` 要"加 recon 模式"——前者说"不需要新东西"，后者要"加新东西"，措辞需对齐(可能"模式"只是 How-to-work 的一个分支，不是新 packet 类型)
  - "升格"(elevation)的语义边界不清：是"加结构位/模式但仍是 emergent task"，还是"升成独立 stage"?`project_state.md:17` 说"首 task 为 sub-agent recon"，倾向前者(仍是一个 task)，但术语未硬化
- **关键论证起点**：plan 若要论证"P2 必要"，从 `archive/phase-1-entry.md:67` 的 P0 漏扫因果链起读；若要论证"P2 不该过度升格"，从 `design/...v0.5-optimization-design.md:262` 的 Non-Goals 起读。

## 4. 信息充分度判断

> ⚠️ 材料充分度，不是方案裁决。

勾选：**☐ 充分 / ☑ 部分 / ☐ 不足**

- **主干已覆盖**：recon 现状、v0.5 否决理由、P2 实证触发、三件交付物落点、两个将被改的文件的真实结构 —— 全部一手实读，无关键缺口。
- **关键缺口**：
  1. **eval case 形态未知** —— `enloom-skill/evals/` 或 `eval-guide.md` 的真实内容未读，不知道现有 eval 是什么范式、recon case 该怎么加(不足)
  2. **researcher.md 的"模式"实现路径未定** —— 是新增 `Mode: research | recon` 字段?还是 How-to-work 加分支?design 文档无明示(待 plan 决策，非材料缺口)
  3. **三件交付物的一致性契约缺失** —— 无文档说明 recon worker 输出 ↔ phase-plan 结构位输入如何咬合(待 plan 设计，非材料缺口)
  4. **预算分层问题** —— recon vs execution 是否需要不同 sub-agent 预算，enloom 现无机制(§2.4 标"可能"，留 plan 检验)

> 缺口 1 是真正的信息缺口(可补读 `eval-guide.md` 消除)；2/3 是设计决策(plan 的活)；4 是待验证假设(plan 的 E 模块 / review 的应力测试)。

## 5. 给 plan/review 的交接

- explore.md 已存在 → plan 先读它(已满足 plan-method §0 入口闸门)。
- **下游最该带着的三条材料**：
  1. P2 的核心矛盾 = "升格必然加结构" vs "v0.5 红线 = 不加阶段/字段/术语"。v0.5 的升格触发条件("真实并行规模到来")是否已被 v0.6 dispatch-default 满足 —— 这是裁决 P2 合法性的钥匙。
  2. 三件交付物里，**researcher.md recon 模式 + phase-plan 结构位**是"中等结构升格"，eval case 是配套验证。P2 的设计空间在"中等结构"这个 v0.5 未评判过的档位。
  3. P2 必要性的因果链(P0 漏扫 → recon 必须 sub-agent 化)需被检验是否过度归因。
- plan 据此走诉求剖析 → 第一性原理 → askBQ A-F；review 对 plan 结论做边界应力测试，最后三态裁决。

`[gate] explore.md exists? → yes`
