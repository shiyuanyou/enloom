# Review · enloom v0.6 P2-recon 升格

```yaml
created: 2026-07-06
project: enloom-v06-p2-recon
stage: review
status: finalized
input: plan.md
```

> **Reading Budget**: ~7 min read(约 3000 字。需展开因果链应力测试 + 三件交付物一致性验证 + 红线重新裁决的合法性检验，超建议区间但收敛于主要矛盾)。

## Uncertain Items Summary

- P2 必要性的承重因果链(P0 漏扫 → recon 必须 sub-agent 化)是**部分归因**，非完全错误也非铁证 → §1 / §3
- "中等结构升格 > 一段指引"无先验运行数据，裁决基于结构推理而非实证 → §1
- recon 产物对齐 Evidence Contract 四要素的映射待 P2 实现时定，本 review 只验"是否可对齐" → §1
- ~~auto-research DAG 为假类比(enloom 无预算分层)~~ —— **(用户纠正，已翻为真类比)**：廉价强模型消解分层必要性 → §2

## 0. 被裁决的方案(一句话)

在 v0.6 dispatch-default 下，把 v0.5 down-scope 成"一段调度指引"的 recon 升格为"中等结构"——researcher.md 加 recon 行为分支 + phase-plan.md 加可选结构位 + 一个 eval case——并显式重新裁决 v0.5 红线(其"真实并行未常态化"前提已被推翻)。

**plan 的关键 claim(review 的验证对象)**：
- plan 说主要矛盾是：recon 从"主窗口可选调度技巧"变成"Plan 对不熟领域的结构化第一步"——防预研缺口返工。
- plan 给的最小 MVP 是：行为分支(非新 Mode 字段) + 可选结构位 + eval case；不加 stage/字段/Pre-flight。
- plan 的 F 结论/评分是：P2 的真正动作是"显式重新裁决 v0.5 红线"；问题评分 4/4/4/3，最弱是可验证性(3)。
- **review 最该应力测试的一条**：plan §6 E.4 自己标的——"把 recon 升格成结构化第一步就能防住 P0 式漏扫"这条预设，风险高。这是 P2 必要性的承重墙。

## 1. 可行性(4 维工程扫描)

| 维度 | 判定 | 信号/证据 |
|---|---|---|
| 性能与容量 | **可接受** | 三件交付物都是文档/模板/eval 改动，无运行时性能。recon task 本是 emergent task，不增加 dispatch 开销。唯一隐忧：recon 多一个 task = 多一轮 dispatch，但这是设计意图(预研前置)，非缺陷。 |
| 可靠性与失效模式 | **有风险** | 见下：recon worker 漏边界(与主窗口手扫同病)。 |
| 可维护性与技术债 | **有风险** | scheduler-rules 现行指引(scheduler-rules.md:53-59)与新增结构位若不交叉引用，会产生"两处定义 recon"的漂移源。P1 刚建立源/副本同步纪律，P2 改的文件同样受此影响(phase-2-entry Open Risk #3 未闭环)。 |
| 实施复杂度与风险 | **可接受** | researcher.md 加行为分支 < 加新 Mode 字段；phase-plan 加可选结构位 < 加必填字段。复杂度在 v0.5 否决的 Pre-flight 之下，属可控。 |

**领域特定维度**：Evidence Contract 兼容性——recon 产物(规模/结构素描)能否塞进四要素(Checks Run / Evidence / Not Checked / Known Blind Spots)?**可对齐**：Checks Run = "读了 packet 列出的 input"; Evidence = "规模/结构素描 + 出处"; Not Checked = "packet 外未扫的"; Known Blind Spots = "素描的不确定处"。不需新要素，**机制不破坏**。✅

**最致命的工程弱点(抓主要矛盾)**：**recon-as-sub-agent 并不自动比主窗口手扫覆盖更全**。P0 漏扫的根因若是"packet 边界设计无系统覆盖方法"，那么 sub-agent recon 读的也是 packet 列出的 input —— **它会忠实地漏掉 packet 没列的东西**。升格改变的是"谁扫、何时扫"，没改变"扫什么"。这是 plan §6 E.4 标的高风险预设，review 确认它确实是承重墙且确有裂缝。

**边界应力测试**：
- **满足 80%(recon 任务明确、不熟领域触发清晰)**：phase-plan 结构位 + researcher 分支能跑通，eval case 10 可设计。
- **满足 50%(recon 产物对齐四要素、源/副本同步)**：需 P2 实现时显式处理，P1 的 Sync Step 纪律可复用。
- **完全不满足(recon 真能防漏扫)**：见上致命弱点——**不保证**。降级路径：recon 的价值重新框定为"用独立上下文探规模、降低主窗口 prompt 污染"，而非"防漏边界"。这是个仍值得做的降级目标，只是不是 plan 宣称的那个。

## 2. 他山之石(3 条件结构相似性闸门)

召回的类比对象：① v0.5 自己的 down-scope 裁决(同项目)② art_lab #16(recon 诞生地)③ auto-research DAG cheap-gather→quality-analyze

| 类比对象 | ①本质约束相同? | ②机制可映射? | ③约束可对齐? | 结论 |
|---|---|---|---|---|
| v0.5 down-scope 裁决 | ✓(同一 skill 的成熟度/结构权衡) | ✓(都是"加多少结构"决策) | **△** | 需改造——v0.5 的约束("真实并行未常态化")已被 v0.6 推翻，但不能默认"成熟度不足"也自动推翻，那需 P0/P1 dogfood 证伪(已部分证伪：3 phase 跑通) |
| art_lab #16 | ✓(规模偏差致返工) | ✓(预研前置) | ✓ | **真类比**——recon 诞生于此，P2 是把它从指引升结构，因果同源 |
| auto-research DAG | ✓(都是"先探规模再做真活") | ✓(cheap-gather→quality-analyze 的 DAG 形态) | ✓ | **真类比(成本维度被廉价强模型消解)**——原 review 曾判此为假类比，依据是"enloom 无模型预算分层，cheap-gather 省钱兑现不了"。**用户纠正**：若 recon 与 execution 都跑 DeepSeek-V4-Pro(thinking=max)这类**廉价强模型**，则"贵/便宜分层"本身不再是必要条件——强模型两边都敞开跑，DAG 的价值从"省钱"转成"用独立上下文探边界、降低主窗口 prompt 污染"，条件③对齐。借鉴"固定 pass"+"独立上下文"两层都成立 |

- **历史失败归因**：v0.5 否决 S2 的失败类目 = "对当前成熟度 over-engineering"。当前 P2 方案是否真解决这个根因?——**部分解决**：P2 选了"中等结构"档(低于 Pre-flight 子阶段+字段)，避开了 v0.5 否决的最重形态；但"成熟度是否够"这个根因，P2 没有正面论证，是靠"P0/P1 跑通了 3 phase"间接证伪。**这是类比闸门留的缝**。

## 3. 拓展(主要矛盾 + MEP)

- **want vs need vs 假性需求**：
  - want：三件交付物(researcher 模式 / phase-plan 位 / eval case)。
  - need：预研前置不靠主窗口自觉，P0 式漏扫不复现。
  - **假性需求警报**：把 recon 升格成"防漏扫的银弹"是假性需求(§1 已证它防不住 packet 边界外的漏)。真实 need 是"给 Plan 一个结构化的预研位置，降低主窗口 prompt 污染 + 用独立上下文探规模"。降级框定后，P2 仍值得做，但卖点要诚实。
- **主要矛盾识别**：plan 的 PRIMARY(自觉→机制)方向对，但**机制改变的是"位置/时机"，不是"覆盖完整性"**。解"位置/时机"已足以让 P2 成立(预研从可能跳过变成有结构位提醒)；但若宣称解了"覆盖完整性"(防漏扫)，则过度。
- **MEP(最小有效实践)**：小/真/有反馈——
  - **小**：只做 researcher.md 行为分支 + phase-plan 可选位 + eval case 10，不加字段/阶段。
  - **真**：下一个真实复杂 phase(可就是 P3 清理，或下一个 dogfood 任务)真派一次 recon sub-agent，看它的素描是否真喂回 Plan 修正了切分。
  - **有反馈**：eval case 10 是反馈机制；加上 recon 跑完后的"素描是否改变了 Plan 切分"这一观测点。

## 4. 三态裁决(出口)

> 裁决围绕主要矛盾：recon 从"可选技巧"变"结构化第一步"——这个方向值得做，但 plan 的承重因果链有裂缝，且卖点需从"防漏扫"降级为"给预研一个结构位置"。

勾选：**☑ CONDITIONAL**

方案本质有价值(recon 升格方向正确、art_lab #16 真类比、Evidence Contract 兼容、三件交付物可咬合)，但存在**可消除的阻断条件**：

- **硬条件 X(必须满足才做)**：P2 的卖点/叙事**从"防 P0 式漏扫"降级为"给 Plan 一个结构化的预研位置 + 降低主窗口 prompt 污染"**。
  - 理由：§1 已证 recon-as-sub-agent 不保证覆盖更全(packet 外仍会漏)。"防漏扫"是假性需求，写在 P2 叙事里会成为下次 dogfood 的反噬点(跑了 recon 还是漏 → 怀疑整个 P2)。
  - 满足后：P2 进入 WORTH-IT，叙事诚实。
- **硬条件 Y(必须满足才做)**：**显式重新裁决 v0.5 红线**，而非绕着走。
  - 理由：plan §3.1 已指出——绕红线的最小升格连自己的 eval 都过不了。P2 必须在 phase-plan 或一处 design note 里写明"v0.5 S2 的'真实并行未常态化'前提已被 v0.6 dispatch-default 推翻，故红线在此条件下失效"，给出新裁决。否则 P2 是"无裁决地推翻 v0.5"，留下治理债。
  - 满足后：P2 的结构升格有合法来源。
- **软条件 Z(不满足则降级方案)**：recon 产物对齐 Evidence Contract 四要素的具体映射，**在 P2 实现时定**，但 phase-plan 结构位的描述必须预留这个映射位。
  - 不满足(结构位描述太泛、无法承载四要素对齐)→ 降级：只做 researcher.md 行为分支 + eval case，phase-plan 结构位推迟到有运行数据后。
  - 满足后：三件交付物完整咬合。

**满足 X+Y 后的路径**：WORTH-IT，进入 enloom 执行(P2 三件交付物作为 task packets 派 sub-agent，沿用 P1 源/副本同步纪律)。

## 5. Handoff(后续去向建议)

据 CONDITIONAL 裁决：

- **先满足 X(叙事降级) + Y(显式重裁红线)**——这两件是 clear-mind 阶段就能确定的，建议用户在读本 review 后拍板：是否接受"防漏扫"降级为"给预研一个结构位置"，以及是否同意显式重裁 v0.5 红线。
- **满足后建议进入 enloom 生命周期执行 P2**：把三件交付物(researcher.md 行为分支 / phase-plan 可选结构位 / eval case 10)作为 P2 的 task packets，按 v0.6 dispatch-default 派 sub-agent。
- **执行时的观测点(给 P2 自己的 feedback)**：下一个真实复杂 phase 跑 recon 时，观测"recon 素描是否真改变了 Plan 切分"——这是 recon 升格价值的真实检验，比 eval case 10 更有说服力。
- **遗留(非 P2 范围，记录)**：① recon 与 execution 的模型预算分层(enloom 无机制，未来项)② 源/副本同步缝隙(phase-2-entry Open Risk #3，建议后续进 prompt-control/landing-contract，P2 沿用 P1 纪律即可)。

> clear-mind 只产出文件 + 建议。三份产物(explore.md / plan.md / review.md)已落 `.clear-mind/2026-07-06-p2-recon/`，enloom 的 Orient 可选读作上下文。是否进执行由用户决定。

`[gate] review.md exists? → yes` · `[gate] verdict = CONDITIONAL (one of three states)? → yes` · `[gate] KILL reframing non-empty? → N/A (not KILL)`
