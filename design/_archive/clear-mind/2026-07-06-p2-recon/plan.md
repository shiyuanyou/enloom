# Plan · enloom v0.6 P2-recon 升格

```yaml
created: 2026-07-06
project: enloom-v06-p2-recon
stage: plan
status: draft
```

> **Reading Budget**: ~9 min read(约 4200 字。主要矛盾推导需展开苏格拉底链 + A-F 全模块，超 plan 建议区间，因 P2 同时触及"升格合法性 / 三件交付物一致性 / 因果归因"三股张力，无法压缩)。
>
> 前置 explore.md 判定材料：**部分**。缺口已补(eval case 形态已读 evals.json schema)；剩余缺口为设计决策(本文输出)与待验假设(留 review)。

## Uncertain Items Summary

- "升格"≠"加 stage"——本文的核心论点是把升格严格限定在"中等结构"档，但这个边界本身是 plan 的主张，review 要应力测试 → §2 / §3.1
- P2 必要性的因果链(P0 漏扫 → recon 必须 sub-agent 化)可能被过度归因 → §6 (E.4)
- ~~recon worker 与 execution worker 是否需要"预算分层"以兑现省钱价值~~ —— **(review 阶段用户纠正，已撤销)**：廉价强模型(DeepSeek-V4-Pro thinking=max)消解了分层必要性，省钱维度转为"独立上下文探边界"

## 0. 原始诉求(用户原话)

> "用 clear-mind 完整流程，每个流程都详细一点，我准备设计一下 P2 recon"

上下文：enloom 作者用 enloom 修 enloom。v0.6 已闭合 P0/P0.5/P1。P2-recon 是 `project_state.md` 标 pending 的下一 phase，三件交付物已列(researcher.md recon 模式 / phase-plan 结构位 / eval case)。用户要在动手实现前，用 clear-mind 想清楚 P2 到底怎么做、做到什么程度。

## 1. 诉求剖析(askBQ 模块 A)

**表层意图**：设计 P2 recon 升格的实现——把 recon 从 scheduler-rules 一段指引，升级为 researcher.md 的 recon 模式 + phase-plan 的结构位 + 一个 eval case。

**深层目标**：让 enloom 在 dispatch-default 新 posture 下，"复杂任务的第一步自动是 sub-agent recon"这件事**有结构支撑、可被 eval 验证**，而不是依赖主窗口记得"该派 recon 了"。P0 dogfood 暴露的"主窗口手扫漏边界"不再靠人的自觉来防，而是靠流程位置(recon 是 Plan 的第一个 task packet)来防。

**期望结果类型**：☑ **方向验证** —— 用户要的是"P2 升格到什么程度才对、值不值得做、走哪条"，不是直接给代码(那是 enloom 执行的事)。

> 张力：表层意图看起来是"实现三件交付物"(实操)，但深层目标是"让预研前置从自觉变成机制"(方向)。如果把 P2 当纯实操做，会直奔三件交付物写代码；但真正的问题在"升格的度"——做少了等于没升格(还是靠主窗口自觉)，做多了重蹈 v0.5 否决的 over-engineering。所以是方向验证型。

## 2. 第一性原理(主要矛盾)

苏格拉底链(1-3 锐问收敛)：

- **追真实需求**：用户不是要"recon 这个功能"，是要"P0 那种主窗口手扫漏边界的事不再发生"。recon 只是手段。
- **挑战被当事实的假设**：P0 漏扫 → "recon 必须 sub-agent 化"这条因果链被当成 P2 的合法性基础。但**反问**：P0 漏扫的根因，究竟是"recon 由主窗口做"，还是"packet 边界设计时没系统化覆盖"?如果是后者，把 recon 升格成 sub-agent task 也未必防得住——sub-agent 一样会漏。这条要标"可能"(见 §6 E.4)。
- **区分主次**：去掉"eval case"这件事会不会让 P2 完全没意义?不会(eval 是验证手段，非核心)。去掉"researcher.md recon 模式 + phase-plan 结构位"呢?会——没有这两个，recon 仍只是 scheduler-rules 一段文字，主窗口仍可以"忘了派"，P0 漏扫会原样复现。**所以核心在结构位 + worker 模式，eval 是配套。**

```
PRIMARY CONSTRAINT: recon 从"主窗口可选的调度技巧"变成"Plan 阶段对不熟领域
的结构化第一步"——是达成"预研前置不再靠主窗口自觉"的根本阻塞。不解决它，
P0 漏扫类失败会原样复现，dispatch-default 翻转的收益被预研缺口的返工吃掉。

SECONDARY CONSTRAINTS:
  (1) v0.5 划下的红线"不新增阶段/字段/术语"——P2 的升格必须在这个红线内
      找到落点，否则等于推翻 v0.5 评审而无新裁决。
  (2) 三件交付物的一致性——researcher.md recon 模式的输出 ↔ phase-plan
      结构位的输入，必须咬合，否则两个文件各说各话。
  (3) 不破坏现有 Evidence Contract / task-packet / Ownership Table 机制——
      recon task 仍是一个 emergent task，不是新机制。

MINIMAL MVP: 给 researcher.md 加一个 recon 行为分支(不是新 Mode 字段，而是
  How-to-work 里"若 packet 标 recon，则产物是规模/结构素描而非完整 research")
  + 给 phase-plan.md 的 Tasks 段加一个可选的"recon task"提示位 + 一个 eval
  case 验证"Plan 遇不熟领域会派 recon"。三者构成最小闭环。

REMOVABLE:
  - 新增 `Mode: recon` 顶层字段(v0.5 红线，推迟)
  - Pre-flight 独立 stage(v0.5 已否决，不碰)
  - ~~recon 与 execution 的模型预算分层~~ —— **(review 阶段已撤销)**：廉价强模型消解分层必要性，recon worker 可直接用强模型(thinking=max)派，不必降级
  - scheduler-rules 那段指引的大改(保留，与新结构位交叉引用即可)
```

> **轻量定义核查**：
> - "升格"(elevation)：边界封闭吗?——plan 主张严格定义为"加行为分支 + 结构位 + eval，但不加 stage/字段/术语"。可证伪(若有人加字段即越界)。**站得住，保留。**
> - "recon 模式"：是 concept-borrowing 陷阱吗(把简单的东西叫"模式"镀金)?——**有风险**。"模式"这个词暗示一个重结构。plan 倾向降称为"recon 行为分支"或直接"recon task"(它本就是一个 emergent task，只是产物不同)。术语选择影响 P2 是否越 v0.5 红线，§3.1 推演。

## 3. 优化问题(askBQ 模块 B)

- **B.1 聚焦表层版**：在 v0.6 dispatch-default 下，要让"Plan 遇不熟领域自动派 recon"，最小且不越 v0.5 红线的结构改动是什么?
- **B.2 直击核心版**：recon 升格真正要解的是"主窗口自觉不可靠"——那么解法是"加结构强制 Plan 派 recon"，还是"承认主窗口自觉够用、只补 eval 兜底"?前者越红线风险，后者可能根本没解问题。
- **B.3 升维破局版**：如果问题不是"recon 要不要升格"，而是"v0.5 的红线本身是否还成立"?v0.5 划红线的依据是"skill 当前成熟度不足 + 真实并行未常态化"。v0.6 dispatch-default 改变了第二个前提——**红线的前提消失了一半，红线本身是否该被重新裁决，而不是 P2 绕着它走?**

### 3.1 方向推演(从 B.3 推进)

- **选中的方向**：B.3 —— P2 的真正动作不是"在 v0.5 红线内塞结构"，而是**显式重新裁决红线是否还成立**。
- **如果这个方向是对的，最小可验证假设**：v0.5 否决 S2 的两个理由("成熟度不足" + "真实并行未常态化")中，第二个已被 v0.6 dispatch-default 推翻；若第一个("成熟度不足")也被 P0/P1 的 dogfood 证伪(enloom 已成功跑了 3 个 phase 的 sub-agent dispatch)，则 v0.5 红线整体失效，P2 可以光明正大加中等结构，而非偷偷塞。
- **当前方案在这个假设下，哪一步先站不住**：若 P2 仍按"绕红线"的姿态做(只加最小分支、不敢动术语、不敢写"recon 是 Plan 的正式第一步")，那它的结构强度不足以让 eval case 10 真正测出"Plan 会派 recon"——eval 会发现 Plan 仍把它当可选技巧而跳过。**即：绕红线的最小升格，连自己的 eval 都过不了。** 这是 P2 设计的自洽性测试。

## 4. 领域拓展(askBQ 模块 C)

- **相邻领域 1：编译器的 type-check vs inference** —— 编译器不会说"类型推断是可选的调度技巧"，它把 type-check 作为 pipeline 的固定 pass，但 pass 本身可配置(严格/宽松)。recon 升格类比：recon 应是 Plan 的固定 pass(对不熟领域必跑)，但 pass 的"重量"可配(轻素描 vs 完整 research)。**可迁移视角**：固定位置 + 可配重量，比"可选调度技巧"更不易被跳过。
- **相邻领域 2：auto-research DAG 的 cheap-gather → quality-analyze** —— recon 对应 gather 阶段(探规模)，execution 对应 analyze 阶段(做真活)。**可迁移视角**：DAG 的价值在"用独立上下文探边界、降低主窗口 prompt 污染"。(review 阶段用户纠正：原以为需要"贵/便宜模型分层"才能兑现，但廉价强模型如 DeepSeek-V4-Pro thinking=max 消解了这个前提——recon 与 execution 都可敞开跑强模型，成本不构成阻碍。)
- **可借鉴**：固定 pass 思想(领域 1) + 独立上下文探边界(领域 2)。两条都能直接落 P2，不再有"预算分层"保留项阻挡。

## 5. 领域类似与可能结论(askBQ 模块 D)

- **已知做法 1：v0.5 自己的 down-scope 裁决** —— 结论："对当前成熟度而言 over-engineering，降为调度指引"。这是 P2 最直接的"他山之石"，且是同一项目的自己。**共识**：预研前置有价值(80%)；**分歧**：是否值得加结构。P2 必须正面回应这个分歧，而非无视。
- **已知做法 2：art_lab #16 踩坑** —— 结论：按 Plan 切分直接派执行 worker，因规模偏差返工(规划 ~100，实际 ~180)。**这是 recon 概念的诞生地**，证明"Plan 的切分基于已有 Registry 风险段，不是对新任务的领域预研"是真实痛点。
- **共识与分歧**：领域内共识"预研前置有价值"；分歧在"结构化程度"。当前无运行数据证明"中等结构升格"比"一段调度指引"显著更好——这是 P2 最大的证据缺口，review 要 stress。

## 6. 缺失信息与隐含假设(askBQ 模块 E)

- **隐含前提**：
  - P2 必要性的因果链"P0 漏扫 → recon 必须 sub-agent 化"成立。
  - "升格"能在不破坏 Evidence Contract / task-packet 现有机制的前提下完成。
  - recon task 仍走 emergent mode，不需要新 mode 字段。
- **前提成立条件**：
  - 因果链成立需：P0 漏扫的根因确实是"主窗口手扫无系统覆盖"，而非"packet 设计偶然疏忽"。**这个条件部分成立**(archive-1 自己这么归因)，但**未独立验证**——可能两种根因都有。
  - 机制不破坏需：recon 的产物(规模/结构素描)能塞进 Evidence Contract 四要素框架(Checks Run / Evidence / Not Checked / Known Blind Spots)。素描算"Evidence"还是新类别?**待 design**。
- **可验证性**：因果链可验——下次 dogfood 一个复杂 phase，看 recon-as-sub-agent 是否真比主窗口手扫漏得少。但这是事后验证，P2 设计时只能基于现有证据推断。
- **可能错误的预设**：
  - "把 recon 升格成结构化第一步就能防住 P0 式漏扫" —— **风险：高**。sub-agent recon 一样可能漏边界(它读的也是 packet 列出的 input)。升格改变的是"谁来做、何时做"，不必然改变"覆盖是否系统"。这条预设是 P2 必要性的承重墙，若错，P2 的价值要打折。
  - "eval case 能测出 Plan 是否派 recon" —— **风险：中**。eval 测的是行为，但 Plan 是否派 recon 受 description/SKILL.md 触发影响，eval case 的 prompt 要足够"不熟领域"才能触发，设计有难度。
- **缺失信息**：
  - recon 产物如何对齐 Evidence Contract 四要素 —— **待 design**(P2 实现时定)
  - 是否有运行数据证明"中等结构 > 一段指引" —— **不足以判断**(无此类数据，P2 是首次)
  - "源/副本同步"缝隙(phase-2-entry Open Risk #3)是否影响 P2 三件交付物 —— **可能**(P2 改的文件同样有源/副本问题，需沿用 P1 的 Sync Step 纪律)

## 7. 简单结论 + 问题评分(askBQ 模块 F)

- **有限结论**：P2 的真正动作是**显式重新裁决 v0.5 红线**(其"真实并行未常态化"前提已被 v0.6 推翻)，然后在"中等结构升格"档(researcher.md 行为分支 + phase-plan 可选结构位 + eval case)落地——不是偷偷在红线内塞最小改动，因为最小改动连自己的 eval 都过不了。
- **问题评分**(1-5)：
  - 诉求清晰度：**4** —— 三件交付物明确，深层目标可推出，唯一模糊是"升格的度"。
  - 主要矛盾识别度：**4** —— PRIMARY(自觉→机制)清晰；扣分在 SECONDARY(1)红线与 PRIMARY 的关系还需 review 验。
  - 假设暴露度：**4** —— E 模块列了关键隐含前提，尤其"P0 漏扫→recon sub-agent 化"的因果链风险已标。
  - 可验证性：**3** —— 因果链只能事后验、eval case 触发设计有难度、无"中等结构>指引"的先验数据。这是最弱一环。
- **给 review 的验证焦点**：**最该 stress 的是"P0 漏扫 → recon 必须 sub-agent 化"这条因果链**——若它是过度归因(P0 漏扫根因其实在 packet 设计)，则 P2 的必要性承重墙松动，裁决可能从 WORTH-IT 滑向 CONDITIONAL(需补 packet 设计纪律而非 recon 升格)。

## 8. Summary Confirmation Gate(确认门)

- **我理解的问题**：让 enloom 在 dispatch-default 下，"复杂任务先 sub-agent recon"从主窗口自觉变成有结构支撑、可 eval 验证的机制，以防 P0 式漏扫复现。
- **主要矛盾**：recon 从"可选调度技巧"变成"Plan 对不熟领域的结构化第一步"——这是防预研缺口返工的根本阻塞。
- **MINIMAL MVP 边界**：researcher.md 行为分支(非新 Mode 字段) + phase-plan 可选结构位 + 一个 eval case；三者咬合。不加 stage/顶层字段/Pre-flight。
- **待确认 / 待补充**：
  1. v0.5 红线是否被 P2 显式重新裁决(plan 主张是，但这是 plan 的立场，需用户拍板)
  2. recon 产物对齐 Evidence Contract 四要素的具体映射(P2 实现时定)
  3. "P0 漏扫→recon sub-agent 化"因果链是否过度归因(review stress)

> plan 采用一次性输出节奏，此门非阻塞。用户可确认后进 review，或先纠正/补充。

`[gate] plan.md exists? → yes` · `[gate] explore.md read before plan? → yes`
