# Review · enloom v0.6 P2-recon 升格（详版重跑）

```yaml
created: 2026-07-07
project: enloom-v06-p2-recon-deep
stage: review
status: finalized
input: plan.md (2026-07-07-p2-recon-deep)
```

> **Reading Budget**: ~10 min read（约 4200 字。较上轮 review 更严：本轮材料更实（evals.json + Role 字段 + v0.5 原文已读），plan 暴露的新设计未决点更多（eval 双路径 / Role 红线灰色地带 / v0.5 治理债），需逐条应力测试，超建议区间但收敛于主要矛盾）。

## Uncertain Items Summary

- P2 必要性的承重因果链（P0 漏扫 → recon 必须 sub-agent 化）是**部分归因**，非完全错误也非铁证 → §1 / §3
- "中等结构升格 > 一段指引"无先验运行数据，裁决基于结构推理而非实证 → §1
- recon 产物对齐 Evidence Contract 四要素的映射待 P2 实现时定，本 review 只验"是否可对齐" → §1
- **【本轮新】** Role 枚举加 recon 值是否越 v0.5 红线 —— plan 主张越，本 review 倾向**不越**（枚举值扩展 ≠ 新顶层字段）→ §1 / §4
- **【本轮新】** eval 进 9-case vs trigger-evals —— plan 主张 9-case，本 review **支持**，并补一条触发层的边界条件 → §1 / §4
- ~~auto-research DAG 为假类比（enloom 无预算分层）~~ —— **（上轮用户纠正，已翻为真类比）**：廉价强模型消解分层必要性 → §2

## 0. 被裁决的方案（一句话）

在 v0.6 dispatch-default 下，把 v0.5 down-scope 成"一段调度指引"的 recon 升格为"中等结构"——researcher.md 加 recon How-to-work 行为分支（不动 Role/Mode 枚举）+ phase-plan.md 加可选结构位（Gate Check 加 recon considered 行）+ 9-case 主 suite 加 case 10（测决策层）——并显式重新裁决 v0.5 红线（其"真实并行未常态化"前提已被推翻，"成熟度"悬空理由靠 P0/P1 dogfood 证伪）。

**plan 的关键 claim（review 的验证对象）**：
- plan 说主要矛盾是：recon 从"主窗口可选调度技巧"变成"Plan 对不熟领域的结构化第一步"——防预研缺口返工。
- plan 给的最小 MVP 是：How-to-work 行为分支（**非**新 Role/Mode 枚举值）+ 可选结构位 + 9-case case 10；不加 stage/顶层字段值/Pre-flight。
- plan 的 F 结论/评分是：P2 真正动作 = "显式重裁 v0.5 红线"；问题评分 4/4/5/3，最弱可验证性（3）。新增：三件交付物细化（行为分支非枚举值 / 结构位 + Gate Check 行 / case 10 测决策层）。
- **review 最该应力测试的三条（本轮较上轮多两条）**：
  1. plan §6 E 标的高风险预设——"把 recon 升格成结构化第一步就能防住 P0 式漏扫"（P2 必要性承重墙）。
  2. **【本轮新】** plan 主张"Role 枚举加 recon 值越红线故 MVP 回避"——这个回避是否反而让 MVP 太弱（行为分支够不够撑起"结构化第一步"）？
  3. **【本轮新】** plan 主张"eval 进 9-case 测决策层"——若 recon 升格的价值其实在触发层，是否测错层？

## 1. 可行性（4 维工程扫描）

| 维度 | 判定 | 信号/证据 |
|---|---|---|
| 性能与容量 | **可接受** | 三件交付物都是文档/模板/eval 改动，无运行时性能。recon task 本是 emergent task，不增 dispatch 开销。唯一隐忧：recon 多一个 task = 多一轮 dispatch，但这是设计意图（预研前置），非缺陷。 |
| 可靠性与失效模式 | **有风险** | 见下：recon worker 漏边界（与主窗口手扫同病）+ **【本轮新】** recon 行为分支若只是 How-to-work 一句话，Plan 仍可能"看不见"它（结构强度存疑）。 |
| 可维护性与技术债 | **有风险** | scheduler-rules 现行指引（scheduler-rules.md:53-59）与新增结构位若不交叉引用，产生"两处定义 recon"漂移源。P1 刚建源/副本同步纪律，P2 改的文件同样受影响（phase-2-entry Open Risk #3 未闭环）。**【本轮新】** plan 选 How-to-work 行为分支（不动 Role 枚举），会留下"recon 到底是 role 还是 behavior"的术语债——researcher.md 里 recon 是分支，task-packet 里 Role 没有 recon 值，两处语义不对称。 |
| 实施复杂度与风险 | **可接受** | researcher.md 加行为分支 < 加新 Role 枚举值 < 加新 Mode 字段；phase-plan 加可选结构位 < 加必填字段；9-case case 10 = 沿用既有 integration 轨。复杂度在 v0.5 否决的 Pre-flight 之下，属可控。 |

**领域特定维度**：Evidence Contract 兼容性——recon 产物（规模/结构素描）能否塞进四要素（Checks Run / Evidence / Not Checked / Known Blind Spots）？**可对齐**：Checks Run = "读了 packet 列出的 input"；Evidence = "规模/结构素描 + 出处"；Not Checked = "packet 外未扫的"；Known Blind Spots = "素描的不确定处"。不需新要素，**机制不破坏**。✅

**最致命的工程弱点（抓主要矛盾）**：**recon-as-sub-agent 并不自动比主窗口手扫覆盖更全**。P0 漏扫根因若是"packet 边界设计无系统覆盖方法"，那 sub-agent recon 读的也是 packet 列出的 input——**它会忠实地漏掉 packet 没列的东西**。升格改变的是"谁扫、何时扫"，没改变"扫什么"。这是 plan §6 E.4 标的高风险预设，review 确认它确是承重墙且确有裂缝。**【本轮加重】**：这条裂缝比上轮评估更深，因为本轮实读 archive-1 §Dogfood #3 原文，发现它把"主窗口做"和"没系统覆盖"混在一句里——sub-agent 化只解前者，不解后者。

**【本轮新】第二致命弱点（plan 主张的 Role 回避）**：plan 为守 v0.5 红线，选 How-to-work 行为分支而非 Role 枚举值。但这带来一个新风险——**recon 在 task-packet 里没有显式标识位**（Role 仍是 researcher，Mode 仍是 emergent），那 Plan 怎么"标记这个 task 是 recon"？靠 packet 文字描述（Goal/Anti-Goal 里写"这是 recon"）？这种"靠自然语言标记"的结构强度，可能撑不起 plan 自己说的"结构化第一步"。**这是 plan 自洽性的第二个裂缝**：既要"结构化"又要"不动字段"，两者张力没被 plan 完全消化。

**边界应力测试**：
- **满足 80%（recon 任务明确、不熟领域触发清晰）**：phase-plan 结构位 + researcher 分支 + case 10 能设计跑通。
- **满足 50%（recon 产物对齐四要素、源/副本同步、Role 术语对称）**：需 P2 实现时显式处理；P1 的 Sync Step 纪律可复用；Role 对称债建议显式记为 Accepted-with-Risk。
- **完全不满足（recon 真能防漏扫）**：见上致命弱点——**不保证**。降级路径：recon 价值重新框定为"用独立上下文探规模、降低主窗口 prompt 污染"，而非"防漏边界"。这是仍值得做的降级目标，只是不是 plan 宣称的那个。

## 2. 他山之石（3 条件结构相似性闸门）

召回的类比对象：① v0.5 自己的 down-scope 裁决（同项目）② art_lab #16（recon 诞生地）③ auto-research DAG cheap-gather→quality-analyze ④ **【本轮新】** enloom 自己的 eval 双轨制（9-case + trigger-evals）

| 类比对象 | ①本质约束相同? | ②机制可映射? | ③约束可对齐? | 结论 |
|---|---|---|---|---|
| v0.5 down-scope 裁决 | ✓（同一 skill 的成熟度/结构权衡） | ✓（都是"加多少结构"决策） | **△** | 需改造——v0.5 约束"真实并行未常态化"已被 v0.6 推翻；但"成熟度"这条悬空理由需 P0/P1 dogfood 证伪（已部分证伪：3 phase 跑通）。**【本轮新】** 这条的治理债（否决两理由 vs 触发一条件）是 plan 主动暴露的，review 认可 plan 的处理方向（显式重裁）。 |
| art_lab #16 | ✓（规模偏差致返工） | ✓（预研前置） | ✓ | **真类比**——recon 诞生于此，P2 是把它从指引升结构，因果同源 |
| auto-research DAG | ✓（先探规模再做真活） | ✓（cheap-gather→quality-analyze DAG 形态） | ✓ | **真类比（成本维度被廉价强模型消解）**——借鉴"固定 pass"+"独立上下文"两层都成立 |
| **【本轮新】eval 双轨制** | ✓（都是"测什么放进测什么的层"） | ✓（9-case=integration / trigger=unit） | ✓ | **真类比**——recon 属 body 内部 pattern，按测试金字塔进 integration（9-case），支持 plan 的 eval 归类主张 |

- **历史失败归因**：v0.5 否决 S2 的失败类目 = "对当前成熟度 over-engineering"。当前 P2 方案是否真解决这个根因？——**部分解决**：P2 选"中等结构"档（低于 Pre-flight 子阶段+字段+术语），避开 v0.5 否决最重形态；但"成熟度是否够"P2 没正面论证，靠"P0/P1 跑通 3 phase"间接证伪。**这是类比闸门留的缝**，plan 已识别为治理债并主张显式重裁，review 认可这个方向。

## 3. 拓展（主要矛盾 + MEP）

- **want vs need vs 假性需求**：
  - want：三件交付物（researcher 行为分支 / phase-plan 位 / eval case）。
  - need：预研前置不靠主窗口自觉，P0 式漏扫不复现。
  - **假性需求警报**：把 recon 升格成"防漏扫的银弹"是假性需求（§1 已证它防不住 packet 边界外的漏）。真实 need 是"给 Plan 一个结构化的预研位置，降低主窗口 prompt 污染 + 用独立上下文探规模"。降级框定后 P2 仍值得做，但卖点要诚实。**【本轮新】** 第二个假性需求警报：把"recon 升格"等同于"recon 防漏扫 + recon 进 Role 枚举 + recon 进 trigger-eval"——前两个是过度，只有"给预研一个结构位置"是真 need。
- **主要矛盾识别**：plan 的 PRIMARY（自觉→机制）方向对，但**机制改变的是"位置/时机"，不是"覆盖完整性"**。解"位置/时机"已足以让 P2 成立（预研从可能跳过变成有结构位提醒）；但若宣称解了"覆盖完整性"（防漏扫），则过度。**【本轮新】** 还有一个次要矛盾：plan 想要"结构化第一步"的强度，又想守"不动 Role 枚举"的红线——这两者在 researcher.md How-to-work 分支的形态下未必同时成立（§1 第二弱点）。
- **MEP（最小有效实践）**：小/真/有反馈——
  - **小**：只做 researcher.md 行为分支 + phase-plan 可选位（+ Gate Check 行）+ 9-case case 10，不加字段/阶段。
  - **真**：下一个真实复杂 phase（可就是 P3 清理，或下一个 dogfood 任务）真派一次 recon sub-agent，看它的素描是否真喂回 Plan 修正切分。
  - **有反馈**：case 10 是反馈机制；加上 recon 跑完后的"素描是否改变了 Plan 切分"这一观测点（比 case 10 更有说服力）。

## 4. 三态裁决（出口）

> 裁决围绕主要矛盾：recon 从"可选技巧"变"结构化第一步"——这个方向值得做，但 plan 的承重因果链有裂缝，卖点需从"防漏扫"降级为"给预研一个结构位置"，且 Role 字段的处理需明确。

勾选：**☑ CONDITIONAL**（⚠️ **后置修订**：本节裁决被 §6 Reframe 推翻为 WORTH-IT。§1-3 的应力测试仍有效——正是它暴露的 W 裂缝促成了 reframe。读本文件先看 §6。）

方案本质有价值（recon 升格方向正确、art_lab #16 真类比、Evidence Contract 兼容、eval 双轨制支持 case 10 归类、三件交付物可咬合），但存在**可消除的阻断条件**：

- **硬条件 X（必须满足才做）**：P2 的卖点/叙事**从"防 P0 式漏扫"降级为"给 Plan 一个结构化的预研位置 + 降低主窗口 prompt 污染"**。
  - 理由：§1 已证 recon-as-sub-agent 不保证覆盖更全（packet 外仍会漏）。"防漏扫"是假性需求，写在 P2 叙事里会成为下次 dogfood 反噬点（跑了 recon 还是漏 → 怀疑整个 P2）。
  - 满足后：P2 进入 WORTH-IT，叙事诚实。
- **硬条件 Y（必须满足才做）**：**显式重新裁决 v0.5 红线**，而非绕着走。
  - 理由：plan §3.1 已指出——绕红线的最小升格连自己的 eval 都过不了。P2 必须在一处 design note（或 phase-plan 注释、或 scheduler-rules 升格那段）写明"v0.5 S2 的'真实并行未常态化'前提已被 v0.6 dispatch-default 推翻，'成熟度'悬空理由已被 P0/P1 dogfood 证伪，故红线在此条件下失效"，给出新裁决。否则 P2 是"无裁决地推翻 v0.5"，留治理债。
  - 满足后：P2 的结构升格有合法来源。
- **【本轮新】硬条件 W（必须满足才做）**：**recon 在 task-packet 里的标识机制必须显式**——要么 Role 枚举加 `recon` 值（review 倾向**这不算越 v0.5 红线**：枚举值扩展是既有字段的合法填值，不是新增顶层字段），要么在 task-packet 的 Goal/Anti-Goal 段强制写一行 `> recon task: yes` 标记位。**不能只靠 researcher.md How-to-work 一句话**——那样 Plan 派 task 时没有结构化标识可读，"结构化第一步"落空。
  - 理由：plan 为守红线回避 Role 枚举，但回避过头会让 MVP 太弱（§1 第二弱点）。review 认为 Role 枚举加值 ≠ 新字段（v0.5 红线原文是"不新增阶段/字段/术语"，`recon` 词 scheduler-rules 已用非新术语，Role 是既有字段非新字段）。故 plan 的"越红线"判断**偏保守**，可放宽。
  - 满足后：recon task 有显式标识，Plan 能结构化地"看见"它，case 10 才测得出"Plan 会派 recon"。
- **软条件 Z（不满足则降级方案）**：recon 产物对齐 Evidence Contract 四要素的具体映射，**在 P2 实现时定**，但 phase-plan 结构位描述须预留映射位。
  - 不满足（结构位描述太泛、无法承载四要素对齐）→ 降级：只做 researcher.md 行为分支 + case 10，phase-plan 结构位推迟到有运行数据后。
  - 满足后：三件交付物完整咬合。

**满足 X+Y+W 后的路径**：WORTH-IT，进入 enloom 执行（P2 三件交付物作为 task packets 派 sub-agent，沿用 P1 源/副本同步纪律）。

> **【本轮 vs 上轮的差异】** 上轮 verdict=CONDITIONAL 只有 X+Y+Z 三条件；本轮**新增硬条件 W**（recon 标识机制显式化），因本轮实读 task-packet 发现 Role 枚举已有，plan 的"回避 Role"过保守会让 MVP 太弱。这是本轮详版的核心增量——不只更详细，而是**修正了 plan 一个隐藏的自洽性裂缝**。

## 6. Reframe（用户提议，推翻 §4 裁决）

> **状态：本 reframe 在 §4 裁决落盘后由用户提出，经两轮对话后用户拍板（"我是第一个用户，我会这样用，别人不习惯就用其他 skill 或自己改造"）。§4 的 CONDITIONAL 被推翻，本节给出新裁决。**

### 6.1 Reframe 的轴

整套 P2 讨论的前提（plan + §1-4）是：recon 升格 = **让 Plan 自动派 recon**（结构强制）。用户提议把这个前提掀了——recon 的"要不要"决策**交给用户**，enloom 只负责把问题显式摆出来。两条机制：

- **(a) 每个 phase 的 phase-plan 把 recon 摆成一行 Human Decision**（"这域熟不熟？要不要先 recon？"），用户在 Plan 出口决策。
- **(b) 用户触发 enloom 时可直接指定**（要/不要 recon），enloom 据此跳过/摆出 Human Decision。

### 6.2 为什么这是 reframe 不是微调

它同时换了**承重点**（结构位提醒 agent → 显式人机门提醒人）和**红线关系**（新增结构 → 零结构，复用既有 Human Decision 机制）。三个原 §4 条件直接消失：

- **Y（重裁 v0.5 红线）消失**：不新增 stage/字段/术语，只是 triage 接偏好 + Plan 摆既有 Human Decision。零结构改动，不碰红线。
- **W（Role 枚举 vs 行为分支）消失**：recon 不再需要 task-packet 显式标识类型——它就是普通 emergent task，Goal 写明"这是 recon、产物是规模素描"。§1 的第二致命弱点（标识强度）随之消解。
- **eval 路径变干净**：case 10 从"测 Plan 自动派 recon"（难触发难判）变成"测 Plan 把 recon 摆成 Human Decision"（行为明确好判）。

只剩：
- **X（叙事降级）依然守**——sub-agent recon 一样会忠实漏 packet 外的东西，"防漏扫"仍是假性需求。这条在 reframe 后**不变**，是跨方案的恒定约束。

### 6.3 Reframe 自己的裂缝（诚实标注，未消失）

1. **art_lab #16 的本质是人没预研**——作者撞规模偏差才回头研究。"要不要 recon?"的提示只在用户被提示时**能正确自校"我其实不熟"**才有用。人对"自己不知道什么"的预判天生不可靠。**但这条裂缝 plan 方案也有**（agent 自觉同样不可靠），reframe 没更糟，也没根治。
2. **"每次问"的 alarm fatigue**——每 phase 都问，用户很快学会无脑点"不要"，退回 P0。**缓解**：不是每次问，而是 Plan 在 Registry 无覆盖 / 新文件类型等**信号**出现时把 recon 标 `recommended`，平时只是 standing option。这把一点"判熟不熟"的活还给 agent，但比"agent 自己决定派不派"轻得多——agent 只判"要不要标 recommended"，不判"做不做"。
3. **机制 (a) 仍需 agent 轻判断**——除非走激进版（Plan 永远把 recon 摆成一行 Human Decision，agent 完全不判断熟不熟）。最干净，代价是每 phase 多一行决策。机制 (b) 正好兜底熟手用户。

### 6.4 用户拍板的原则（消解 over-engineering）

> "我是第一个用户，我就会这样用。如果别人不习惯就用其他 skill 或自己改造。"

这条原则**不是妥协，是干净的第一性原理动作**。"为假想未来用户设计"是 v0.5 红线"对当前成熟度 over-engineering"的隐形来源。当用户 = 作者本人、不接受者 fork 时，那一整类担忧（alarm fatigue 对别人、通用触发设计、其他用户习惯）**失去适用对象**——它们全是在为不存在的人优化。剩下的是"作者这样用顺不顺"，可回答、可自校。

裂缝 1（人判熟不熟不可靠）在所有方案里都存在，reframe 不假装能解，只是诚实不假装——这反而比 plan 方案（靠 agent 自觉防漏扫）叙事更诚实。

### 6.5 新裁决（推翻 §4）

勾选：**☑ WORTH-IT**

理由（围绕主要矛盾）：recon 从"可选技巧"变"结构化第一步"——用户提议的 reframe 用**人机决策门**（而非结构位强制）实现了同样的"结构化"，且：
- 不碰 v0.5 红线（零结构改动）→ 消解 §4 的 Y。
- 不破现有机制（复用 phase-plan Human Decision + triage 接偏好）→ 消解 §4 的 W。
- eval 变简单（测显式行为而非自动判断）→ 消解 §4 的 eval 难点。
- 与 enloom 现有哲学咬合（phase-plan 本就有 Human Decisions 段，recon 决策天然落位，非新机制）。

剩余约束（不阻断，需实现时处理）：
- **X（叙事降级）**：recon 升格的卖点仍是"给 Plan 一个结构化的预研位置 + 降低主窗口 prompt 污染"，**不是**"防 P0 式漏扫"。这条跨 reframe 不变，实现时写进 researcher/phase-plan 描述。
- **Z（软）**：recon 产物对齐 Evidence Contract 四要素的映射，P2 实现时定。

## 7. Handoff（reframe + recommended 终版）

> **v3 修订**：本节原把 recommended 列为"裂缝 2 缓解，可选，非 P2 必做"。用户进一步认可"推荐做确实是巧妙的判断"后，recommended **提级为 P2 第一版核心**（不是可选）。理由：recommended 是让机制 (a) 不塌成 alarm fatigue 噪音的 salience 层——没有它，standing option 会被用户快速学会无脑跳过，门形同虚设。它的巧妙在"拆开判断"：salience（agent 廉价可错）与决策（人）分离。

据 WORTH-IT：

- **直接进入 enloom 生命周期执行 P2**，task packets 按 reframe + recommended 定义（五件 MVP）：
  1. **phase-plan Human Decision 模板行**（机制 a）：Human Decisions 段（phase-plan.md:64）加一行 recon 决策模板——"该 phase 域是否需要先 recon？规模/边界是否已明？"。Gate Check（:67）加 "recon considered: yes/no" 行作出口自检。
  2. **triage 接 recon 偏好**（机制 b）：triage/contract 阶段接收用户"要/不要 recon"声明，未声明时默认走机制 (a)。接口落 trigger-contract 或 workflow Stage 1（P2 实现时定）。
  3. **recommended 三信号规则**（机制 c，**P2 第一版核心**）：Plan 在以下任一信号出现时，把 recon Human Decision 标 `recommended`，否则作为 standing option：
     - **Registry 无该域风险段**（新 domain）—— 读 project_state.md Registry 段（Pending Dependencies / Broken References / Accepted With Risk），无相关项即触发。这是 Orient 本来就在做的事（project-state.md:53 "control agent scans this on Orient"）的副产物。
     - **出现新文件类型**（扩展名/结构未见过）—— Plan 读 input 时的自然观察。
     - **Plan 读 input 时规模/边界不明**—— Plan 本来就要做的判断。
     规则落 scheduler-rules 升格那段（与既有 recon 指引同处，交叉引用 phase-plan Human Decision）。**已知裂缝**：新项目 Registry 空时 false positive 多，第一个用户（作者）可接受，记录为 Known Limitation。
  4. **researcher.md recon 产物约定**：recon task 是普通 emergent task，Goal/Anti-Goal 写明产物=规模/结构素描（不是完整 research），output 喂回 Plan 修正切分。How-to-work 加一条分支（"若 packet 标 recon，产物是规模素描"），**不动 Role/Mode 枚举**。recon 产物对齐 Evidence Contract 四要素的映射 P2 实现时定（Checks Run=读了 input / Evidence=素描+出处 / Not Checked=packet 外 / Known Blind Spots=不确定处）。
  5. **9-case case 10 改写**：测"Plan 是否把 recon 摆成 Human Decision + 是否在信号出现时标 recommended"（显式行为），不测"Plan 是否自动派 recon"（自动判断）。**不进 trigger-evals**（recon 是 body 内部 pattern，与 description 入口无关）。
- **实现时的观测点（给 P2 自己的 feedback）**：
  1. 下一个真实复杂 phase，看作者自己用 reframe 版时，recon Human Decision 是否被认真决策（而非无脑跳过）。比 case 10 更有说服力——直接来自第一个用户。
  2. **recommended 信号是否真的影响了 recon 决策**（而非被无视）——这是 recommended 提级为核心后的关键验证。若被无视，说明信号精度不够，按第一个用户反馈调。
- **诚实边界（跨方案恒定，reframe 不解）**：v3 防"决策被静默跳过"，**不防**"决策做错"（用户可能说不要 recon 然后撞规模偏差）。art_lab #16 根因（人没预研）在所有方案里都存在，v3 不假装能解。
- **遗留（非 P2 范围，记录）**：① "别人不习惯"的通用化——按用户拍板"我是第一个用户"，**主动不做**，留给 fork ② recommended false positive 在新项目的根治——留作后续优化，按第一个用户反馈 ③ 源/副本同步缝隙（phase-2-entry Open Risk #3，P2 沿用 P1 Sync Step 纪律）。

> 三份产物（explore.md / plan.md / review.md）已落 `.clear-mind/2026-07-07-p2-recon-deep/`，全部对齐 reframe + recommended 终版（v3）。本 review 经 §6 reframe + §7 recommended 提级后裁决为 WORTH-IT，建议进 enloom 执行。原 §1-4（原方案应力测试）+ §5（原 CONDITIONAL Handoff）保留作推理链——它们正是 reframe 的合法性来源（§4 的 W 裂缝 + §3 假性需求警报，共同逼出了人机决策门 + recommended 这个更干净的承重点）。

`[gate] review.md exists? → yes` · `[gate] verdict = WORTH-IT (reframed, see §6; supersedes §4 CONDITIONAL)? → yes` · `[gate] KILL reframing non-empty? → N/A (not KILL)`

---

## 5. Handoff（后续去向建议）— ⚠️ §4 原 CONDITIONAL 版，已被 §7（reframe 后 WORTH-IT 版）取代，保留作推理链

据 CONDITIONAL 裁决（**已被 §6/§7 推翻，以下仅作历史记录**）：

- **先满足 X（叙事降级）+ Y（显式重裁红线）+ W（recon 标识显式化）**——这三件是 clear-mind 阶段就能定的，建议用户读本 review 后拍板：
  1. 是否接受"防漏扫"降级为"给预研一个结构位置"。
  2. 是否同意显式重裁 v0.5 红线（含正面处理"成熟度"悬空理由）。
  3. **【本轮新】** recon 标识走哪条——Role 枚举加 `recon` 值（review 推荐，非越线）/ task-packet Goal 段标记位 / 维持 plan 的 How-to-work 分支（最弱，review 不推荐）。
- **满足后建议进入 enloom 生命周期执行 P2**：把三件交付物（researcher.md 行为分支 + 可选 Role 枚举扩展 / phase-plan 可选结构位 + Gate Check 行 / 9-case case 10）作为 P2 的 task packets，按 v0.6 dispatch-default 派 sub-agent。
- **执行时的观测点（给 P2 自己的 feedback）**：
  1. 下一个真实复杂 phase 跑 recon 时，观测"recon 素描是否真改变了 Plan 切分"——recon 升格价值的真实检验，比 case 10 更有说服力。
  2. **【本轮新】** case 10 跑完看 Plan 是否真派了 recon——若没派，说明结构位 + 行为分支的强度不够，需回到 W 条件升级标识机制（很可能就是上 Role 枚举）。
- **遗留（非 P2 范围，记录）**：① recon 与 execution 模型预算分层（enloom 无机制，未来项；上轮已由廉价强模型消解必要性）② 源/副本同步缝隙（phase-2-entry Open Risk #3，建议后续进 prompt-control/landing-contract，P2 沿用 P1 纪律）③ **【本轮新】** 若 P2 选 Role 枚举加 recon 值，需同步更新 researcher.md（或新建 recon worker prompt）以对应新 Role——这是个小的连带改动，P2 实现时注意。

> clear-mind 只产出文件 + 建议。三份产物（explore.md / plan.md / review.md）已落 `.clear-mind/2026-07-07-p2-recon-deep/`，enloom 的 Orient 可选读作上下文。是否进执行由用户决定。

`[gate] review.md exists? → yes` · `[gate] verdict = CONDITIONAL (one of three states)? → yes` · `[gate] KILL reframing non-empty? → N/A (not KILL)`
