# Review · clear-mind 对齐 v0.6 dispatch-default(自审)

```yaml
created: 2026-07-06
project: clearmind-align-v06
stage: review
status: finalized
input: plan.md
```

> **Reading Budget**: ~6 min read(约 2600 字)。核心是 §3.1"言行不一"裂缝的应力测试 + 三层对齐的可行性扫描，收敛于主要矛盾。

## Uncertain Items Summary

- "叙事首选 dispatch / 运行时仍内联"是否言行不一——review 确认有张力但可诚实修补 → §1 / §3
- "模式 B 是降级"的措辞预设被 plan 标出，review 同意需软化，但软化后是否仍暗示等级 → §1
- 三层对齐的命名层(零 control agent)是否真该不动，review 认为该不动(clear-mind 非 orchestrator) → §1

## 0. 被裁决的方案(一句话)

clear-mind 对齐 enloom v0.6 dispatch-default，用三层轻量动作(叙事重构 + 接口描述更新 + 可选命名显式化)，不动 explore gather 的运行时默认(仍内联)，保留独立可用性；对齐标准是"各自默认有理由 + 交叉引用清晰"，不是"默认姿态统一"。

**plan 的关键 claim(review 的验证对象)**：
- plan 说主要矛盾是：对齐不能破坏 clear-mind 独立可用性(无 enloom 也能跑)。
- plan 给的最小 MVP 是：三层轻量对齐，不改运行时默认。
- plan 的 F 结论/评分是：对齐=各自有理+接口干净，非默认统一；评分 4/5/4/4。
- **review 最该应力测试的一条**：plan §3.1 自己标的——"叙事说 dispatch 首选，运行时仍内联"是否真言行不一，修补方案("受独立约束的首选")是否够诚实。

## 1. 可行性(4 维工程扫描)

| 维度 | 判定 | 信号/证据 |
|---|---|---|
| 性能与容量 | **可接受** | 三层都是文档改动(叙事/接口/命名)，无运行时性能影响。改动量小(估计 ≤5 文件，主要 trigger-contract / explore-method / SKILL.md / review-template)。 |
| 可靠性与失效模式 | **有风险** | 见下：言行不一裂缝。 |
| 可维护性与技术债 | **可接受** | 叙事重构后，clear-mind 与 enloom 的交叉引用更清晰，降低"两兄弟各说各话"的漂移。命名层不强制统一，避免引入 clear-mind 不需要的角色名。 |
| 实施复杂度与风险 | **可接受** | 不动运行时 = 零行为风险。纯文档对齐的回归风险极低。 |

**领域特定维度**：独立可用性保持——三层对齐**不引入任何对 enloom 的硬依赖**。叙事说"dispatch 首选"但运行时仍内联，clear-mind 删掉 enloom 仍能 plan→review。✅ PRIMARY CONSTRAINT 不破。

**最致命的工程弱点(抓主要矛盾)**：**plan §3.1 的言行不一裂缝是真的**。叙事若写"模式 A(dispatch)是首选"，但运行时默认是模式 B(内联)，读者会困惑"你既然首选 A 为什么默认 B"。这是 plan 自己识别的，review 确认它是最致命弱点。

**边界应力测试** —— 针对言行不一裂缝：
- plan 的修补方案("受独立可用性约束的首选 dispatch")是否够诚实?
- **review 判定：够诚实，但措辞要精确。** 关键区分：这不是"宣称 X 却做 Y"的虚伪，是"承认 X 更优但 Y 是 X 的成本约束下的默认"——类似"健康饮食首选，但预算约束下默认快餐"。只要叙事**显式声明这个约束关系**(而非隐瞒)，就不算言行不一。**条件：叙事必须明写"运行时默认内联是独立可用性约束的结果，不是 dispatch 不可取"**。满足此条件 → 裂缝修补成立。

## 2. 他山之石(3 条件结构相似性闸门)

召回的类比对象：①编译器前端/后端解耦(plan §4)②Unix do-one-thing(plan §4)③clear-mind 自己的双模式设计

| 类比对象 | ①本质约束相同? | ②机制可映射? | ③约束可对齐? | 结论 |
|---|---|---|---|---|
| 编译器前端/后端 | ✓(各自默认不同，靠 IR 解耦) | ✓(.clear-mind/↔.enloom/ 文件接口 = IR) | ✓ | **真类比**——对齐靠接口干净，不靠默认统一 |
| Unix do-one-thing | ✓(独立可用是正道) | ✓(每个工具独立 + 管道组合) | ✓ | **真类比**——破坏独立性去对齐 = 反 Unix 耦合 |
| clear-mind 自己的双模式 | ✓(已想过 dispatch 问题) | ✓(内联默认 + 显式切 dispatch) | ✓ | **真类比(自身先例)**——团队已选"内联默认"，review 只验叙事是否需更新 |

- **历史失败归因**：若强翻转 clear-mind 运行时默认为 dispatch，失败类目 = "独立 skill 硬依赖兄弟 skill" = 反 Unix 耦合。当前方案(不动运行时)避开了这个失败。✅

> 三个类比全过闸门，无假类比。这反过来强化 plan 的结论：对齐靠接口/叙事，不靠运行时统一。

## 3. 拓展(主要矛盾 + MEP)

- **want vs need vs 假性需求**：
  - want：clear-mind 对齐 enloom。
  - need：两兄弟不自相矛盾。
  - **假性需求警报**：把"对齐"等同于"运行时默认统一"是假性需求——它破坏 PRIMARY(独立可用性)。真 need 是"叙事 + 接口层面一致"。
- **主要矛盾识别**：plan 的 PRIMARY(独立可用性)经 review 验证站得住——去掉它，clear-mind 从独立 skill 降级为 enloom 专属前置，核心价值消失。三层轻量对齐恰好在 PRIMARY 约束内操作(不改运行时)，主要矛盾被正确触及。
- **MEP(最小有效实践)**：小/真/有反馈——
  - **小**：只改叙事 + 接口描述，≤5 文件。
  - **真**：改完后，一个新读者读 clear-mind explore 段 + enloom v0.6 landing-contract §5，是否还觉得矛盾。
  - **有反馈**：下次 clear-mind 实跑时(如本案)，观察 explore 是否仍能在无 enloom 时内联工作(独立可用性未破)。

## 4. 三态裁决(出口)

> 裁决围绕主要矛盾：三层轻量对齐在独立可用性约束内操作，正确触及"不自相矛盾"这个真 need。

勾选：**☑ WORTH-IT**

值得做，核心理由：**主要矛盾可解且解法不破独立可用性**。plan 的三层对齐(叙事/接口/命名)恰好在 PRIMARY CONSTRAINT(独立可用性)划下的边界内操作——不动运行时默认 = 零行为风险 + 零独立性破坏。言行不一裂缝(plan 自己识别的最致命弱点)经 stress 测试可诚实修补，条件是叙事显式声明"运行时内联是独立约束的结果"。

**值得做的核心理由(一句话)**：enloom 今天消灭了"单 agent 自执行合法"叙事，clear-mind 若不在叙事层跟进，两兄弟会在 dispatch 这件事上各说各话——这个漂移用 ≤5 文件的叙事重构就能修，成本极低而一致性收益明确，且不碰独立可用性这条红线。

**附带条件(软)**：
- 叙事重构时，把 explore-method 里"模式 B 内联**降级**"的"降级"二字软化——它在 dispatch-default 时代强化"A 优 B 劣"的等级暗示。建议改述为"模式 B 内联(独立模式)"或"模式 B 内联(无 enloom 时的原生模式)"，与"模式 A(dispatch，需 enloom)"平级表述。
- 命名层不强制引入 control agent(clear-mind 非 orchestrator，不需要)，但可在 trigger-contract §"与执行编排边界"里**一处**显式点明 clear-mind 自己的角色是"裁决者"而非"control agent"，消除术语模糊。

## 5. Handoff(后续去向建议)

据 WORTH-IT：

- **建议进入执行**：把三层对齐作为一组 task packets 执行。改动文件清单(预估)：
  1. `references/trigger-contract.md` §explore 触发条件 + §与执行编排边界 —— 重述默认模式 + 一处角色显式化
  2. `references/explore-method.md` §3 模式选择 + 模式 A/B 定义 —— 软化"降级"、重框"首选/原生"
  3. `SKILL.md` explore 段 + Handoff 段 —— 反映 dispatch-default 时代叙事
  4. `references/templates/review.md` Handoff 模板 —— "进入执行编排(如 enloom 生命周期)" 可补一句 enloom 现是 dispatch-default
  5. (可选)`references/honest-limitations.md` §X.1 —— "单 agent 串行"框定可加一行澄清"此指裁决独立性维度，非执行 dispatch 维度"
- **执行纪律**：这是改 skill 源文件，若 enloom dogfood 项目要纳入，走 enloom 生命周期(派 sub-agent)；若是 clear-mind 独立维护，可直接轻量改。建议前者(与 enloom v0.6 dogfood 一致)。
- **验证**：改完后 grep "降级" 在 explore 上下文应大幅减少；读 trigger-contract + enloom landing-contract §5 不觉矛盾。

> clear-mind 只产出文件 + 建议。三份产物已落 `.clear-mind/2026-07-06-clearmind-align-v06/`。是否进执行由用户决定。

`[gate] review.md exists? → yes` · `[gate] verdict = WORTH-IT (one of three states)? → yes`
