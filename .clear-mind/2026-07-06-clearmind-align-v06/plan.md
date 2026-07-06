# Plan · clear-mind 对齐 v0.6 dispatch-default(自审)

```yaml
created: 2026-07-06
project: clearmind-align-v06
stage: plan
status: draft
```

> **Reading Budget**: ~8 min read(约 3800 字。核心是"翻转 vs 定位差异"的张力推导，需展开苏格拉底链 + 区分三层不一致各自的对齐动作)。
>
> 前置 explore.md 判定材料：**充分**。无关键缺口。

## Uncertain Items Summary

- "翻转 explore 默认会破坏 clear-mind 独立性"是 plan 的核心论点，但"独立性"的代价是否值得，review 要 stress → §2 / §3.1
- "怎么判 enloom 可调用"若不靠暗检测，候选是"用户显式要求 + 一次性能力探测"，后者未验证 → §6 E.5
- 命名层(control agent)是否统一，是风格决策——plan 倾向不强制，但这是主张非定论 → §2

## 0. 原始诉求(用户原话)

> "现在总结一下 enloom 今天的升级迭代思路，我觉得那个 clear-mind 应该也对齐一下"

上下文：enloom 今天完成 v0.6 dispatch-default posture 翻转(P0/P0.5/P1)。用户感觉 clear-mind 作为 phase -1 前置兄弟 skill 该对齐。方向未定，先自审。

## 1. 诉求剖析(askBQ 模块 A)

**表层意图**：把 clear-mind 对齐 enloom v0.6 的 dispatch-default posture——让两个兄弟 skill 的默认姿态一致。

**深层目标**：让 clear-mind 与 enloom 作为"phase -1 前置 + 执行编排"的兄弟组合，在 dispatch 这件事上**叙事一致、接口干净**——不要 enloom 刚消灭了"单 agent 自执行合法"，clear-mind 却默认"当前 agent 内联做 worker 活"，造成兄弟 skill 各说各话。

**期望结果类型**：☑ **方向验证** —— 用户要的是"该对齐什么、对齐到什么程度、哪些不该动"，不是直接改文件(改文件是执行的事)。

> 张力：表层"对齐"听起来是"clear-mind 跟 enloom 走"，但深层问题是"两个 skill 定位不同，盲目对齐会破坏 clear-mind 的独立可用性"。所以这是方向验证——要分清"真冲突"和"定位差异"。

## 2. 第一性原理(主要矛盾)

苏格拉底链(1-3 锐问收敛)：

- **追真实需求**：用户不是要 clear-mind 变成 enloom，是要"兄弟 skill 不自相矛盾"。但 clear-mind 的核心价值是**独立可用**(无 enloom 也能跑 plan→review)。这两者哪个是真需求?
- **拆到不可再分**：clear-mind 哪些阶段做了"worker 活"?explore §2.1 已定位——**只有 explore gather 的模式 B**(Read/Grep/WebSearch 4 信源收集，这在 enloom 里是典型 worker task 形态)。plan/review 的内联是编排层判断(想清楚要不要做)，不是 worker 活。所以"对齐 dispatch-default"的真正落点，**不是全 clear-mind，只是 explore gather 一个阶段**。
- **区分主次**：如果把 clear-mind 的 explore gather 默认翻转成"dispatch enloom"，去掉什么会让整件事没意义?——去掉"clear-mind 无 enloom 也能独立跑"这个 v0.1 兼容承诺，clear-mind 就从"独立 skill"降级成"enloom 的专属前置"，**它的整个独立价值消失**。这是主要约束。

```
PRIMARY CONSTRAINT: 对齐不能破坏 clear-mind 的独立可用性(无 enloom 也能跑
  plan→review)。clear-mind 的核心定位是"optional phase -1，独立于执行编排"
  (SKILL.md:8-10)。任何对齐动作若让 clear-mind 变成"enloom 的专属前置"，
  整件事失去意义——那是降级不是升级。

SECONDARY CONSTRAINTS:
  (1) explore gather 模式 B(内联)与 enloom dispatch-default 表面相反——这是
      唯一的真冲突候选，但它在"独立可用"约束下，应作为"降级路径"保留而非消灭。
  (2) clear-mind 刻意拒绝 .enloom/ 暗检测(trigger-contract:38)——翻转默认
      若要发生，"怎么判 enloom 可调用"必须有新答案(不能回到暗检测)。
  (3) 命名层(零 control agent)与 enloom P1 不一致——但这是风格问题非正确性。

MINIMAL MVP: 三层不一致各给最小对齐动作，而非一刀切翻转:
  ① 叙事层:clear-mind 的 explore 默认从"模式 B 内联"重述为"dispatch-default
     posture 与 enloom 对齐——当 enloom 可调用时默认模式 A，不可调用降级模式 B"。
     不改运行时默认(仍内联)，改叙事框定(承认 dispatch-default 是首选)。
  ② 接口层:Handoff 段 + trigger-contract 的"与执行编排边界"段，反映 enloom
     现在是 dispatch-default posture(几句话)。
  ③ 命名层:不强制引入 control agent(clear-mind 非 orchestrator)，但把"当前
     agent"这类模糊措辞在 explore 模式描述里显式化(可选，低优先)。

REMOVABLE:
  - 翻转 explore gather 运行时默认为模式 A(破坏独立可用性，砍)
  - 引入 .enloom/ 暗检测(clear-mind 已自证其为反模式，砍)
  - 全 skill 引入 control agent 角色名(clear-mind 不需要，砍)
  - 改 plan/review 的内联为 dispatch(plan/review 是编排层判断不是 worker 活，砍)
```

> **轻量定义核查**：
> - "对齐"(alignment)：封闭吗?——plan 主张分三层(叙事/接口/命名)，每层有不同动作。可证伪(若某层动作破坏独立可用性即越界)。**站得住。**
> - "独立可用"(independent usability)：循环吗?——"clear-mind 无 enloom 能跑"是可验证的(删 enloom，clear-mind 是否仍能 plan→review)。**不循环，保留。**
> - 警惕"概念借用"陷阱：把 clear-mind 的 explore gather 模式 B 说成"单 agent 自执行兜底"(enloom 已消灭的叙事)——这是**借 enloom 的框定给 clear-mind 镀问题**。模式 B 不是"兜底"，是 clear-mind 的**原生默认**(它比 enloom dispatch 更根本)。降级称"原生内联模式"而非"降级模式"，措辞上更诚实。

## 3. 优化问题(askBQ 模块 B)

- **B.1 聚焦表层版**：clear-mind 的 explore gather 默认要怎么改，才能既对齐 enloom dispatch-default，又不破坏独立可用性?
- **B.2 直击核心版**：用户要的"对齐"本质是什么——是 clear-mind 运行时行为改变(真 dispatch)，还是 clear-mind 叙事与 enloom 不自相矛盾(姿态一致)?如果是后者，那不动运行时默认、只改叙事框定就够了。
- **B.3 升维破局版**：如果"对齐"的标准不是"两个 skill 默认姿态一样"，而是"两个 skill 各自的默认姿态都有充分理由、且彼此知道对方的默认"呢?enloom 的 dispatch-default 有理由(worker task 不该自执行)；clear-mind 的内联默认也有理由(独立 skill 不该硬依赖兄弟)。**真正要对齐的不是"默认一样"，是"各自默认的理由都站得住，且交叉引用清晰"。**

### 3.1 方向推演(从 B.3 推进)

- **选中的方向**：B.3 —— 对齐 = 各自默认有理由 + 交叉引用清晰，不是默认姿态统一。
- **如果这个方向是对的，最小可验证假设**：clear-mind 只需在叙事层把 explore gather 的双模式重新框定——"dispatch-default 时代，模式 A(enloom dispatch)是首选，模式 B(内联)是独立降级路径"——而不改运行时默认(仍内联，因为独立可用性优先)。验证标准：一个读者读完修改后的 clear-mind + enloom v0.6，不会觉得"两兄弟自相矛盾"，而是觉得"各自有理"。
- **当前方案在这个假设下，哪一步先站不住**：如果只改叙事不改运行时，**用户实际跑 clear-mind 时仍是内联**——叙事说"dispatch 是首选"，行为是"内联"，这是言行不一。**这是 B.3 方向的自洽性裂缝**。修补：叙事必须诚实说明"首选 dispatch，但独立可用性约束使运行时默认仍内联；用户显式要求即切 dispatch"。即承认这是受约束的首选，不是无条件首选。

## 4. 领域拓展(askBQ 模块 C)

- **相邻领域 1：编译器的前端/后端解耦** —— 前端(解析)和后端(代码生成)各自有默认行为，通过 IR(中间表示)解耦。clear-mind(explore gather)与 enloom(dispatch)类比：各自默认不同，通过 `.clear-mind/` ↔ `.enloom/` 文件接口解耦。**可迁移视角**：对齐不是让前端用后端的默认，是让 IR 接口干净。
- **相邻领域 2：Unix 哲学的"do one thing well"** —— 每个工具独立可用，通过管道组合。clear-mind 独立可用(无 enloom 能跑)是 Unix 式正道。**可迁移视角**：破坏独立可用性去"对齐"，是反 Unix 哲学的耦合。
- **可借鉴**：解耦靠接口(领域 1)+ 独立优先(领域 2)。两条都指向"不改运行时默认，改叙事 + 接口描述"。

## 5. 领域类似与可能结论(askBQ 模块 D)

- **已知做法 1：clear-mind 自己的 explore 模式设计** —— 它已经设计了双模式 + 拒绝暗检测。结论：clear-mind 团队**已经想过 dispatch 问题**，并选了"内联默认 + 显式切 dispatch"。P2 的任务不是推翻这个设计，是看它在 v0.6 新 posture 下**叙事是否需要更新**。
- **已知做法 2：enloom 的 landing-contract §5 翻转** —— enloom 自己翻转时，对"无 sub-agent"的处理是"中断，不退化"。clear-mind 不能照搬这个(它会破坏独立可用性)，但可以借鉴其**诚实姿态**——明确说"clear-mind 的内联是受独立约束的原生默认，不是 enloom 那种被消灭的自执行兜底"。
- **共识与分歧**：两个 skill 共识"dispatch sub-agent 比 agent 自做更隔离"；分歧在"独立 skill 是否该硬依赖兄弟 skill 的 dispatch 能力"。clear-mind 选不该，enloom 选必须(因为它就是 orchestrator)。**这个分歧是定位决定的，不是谁对谁错。**

## 6. 缺失信息与隐含假设(askBQ 模块 E)

- **隐含前提**：
  - "对齐"意味着某种统一(叙事或行为)。
  - clear-mind 的独立可用性值得保留(v0.1 兼容承诺)。
  - enloom dispatch-default 是"更优"姿态，clear-mind 该向它靠。
- **前提成立条件**：
  - "对齐=统一"成立需：两个 skill 定位相同。**但它们定位不同(phase -1 vs orchestrator)**，所以"统一"不是正确框定，"各自有理+接口干净"才是。
  - 独立可用性值得保留：成立——clear-mind SKILL.md:8-10 明确定位为独立 skill，且回退兼容是 v0.1 承诺。
  - enloom posture 更优：在 orchestrator 语境成立；在独立 skill 语境**不成立**(独立 skill 不该硬依赖)。
- **可验证性**：独立可用性可验——删 enloom，clear-mind 是否仍 plan→review。✅ 已验(本案就是 clear-mind 自跑，无 enloom dispatch)。
- **可能错误的预设**：
  - "clear-mind 的模式 B 是降级" —— **风险：中**。explore-method 措辞"模式 B 内联降级"暗示 A 优 B 劣。但在独立 skill 语境，B 是原生默认，A 是增强。措辞预设了"A 为正、B 为降"的等级，这在 dispatch-default 时代更强化。**plan 建议叙事重构时把这个等级软化**。
  - "不改运行时只改叙事 = 言行不一" —— **风险：高**。§3.1 已识别此裂缝。修补方案(承认受约束的首选)是否够诚实，review 要 stress。
- **缺失信息**：
  - 若要翻转运行时默认，"怎么判 enloom 可调用"的新答案 —— 候选是"用户显式要求 + 一次性能力探测(尝试 dispatch，失败则降级)"，但后者未验证。**标"可能"**，且本案 plan 倾向不翻转运行时，故此缺口非阻塞。

## 7. 简单结论 + 问题评分(askBQ 模块 F)

- **有限结论**：clear-mind 对齐 v0.6 的正确动作是**三层轻量对齐(叙事 + 接口 + 可选命名)，不动运行时默认**。对齐的标准是"各自默认有理由 + 交叉引用清晰"(B.3)，不是"默认姿态统一"。explore gather 的内联是受独立可用性约束的原生默认，不是 enloom 那种被消灭的自执行兜底——叙事上要把这个区别说清。
- **问题评分**(1-5)：
  - 诉求清晰度：**4** —— 深层(叙事一致)可推出，唯一模糊是"对齐"的边界。
  - 主要矛盾识别度：**5** —— PRIMARY(独立可用性)清晰且经"去掉它全盘失去意义"测试。
  - 假设暴露度：**4** —— E 模块标了"言行不一"裂缝 + "模式 B 是降级"措辞预设。
  - 可验证性：**4** —— 独立可用性可验；叙事对齐效果可验(读者是否觉得自相矛盾)。
- **给 review 的验证焦点**：**最该 stress 的是 §3.1 的自洽性裂缝——"叙事说 dispatch 首选，运行时仍内联"是否真构成言行不一**，以及修补方案("受独立约束的首选")是否足够诚实，还是变相合理化不变。

## 8. Summary Confirmation Gate(确认门)

- **我理解的问题**：让 clear-mind 与 enloom v0.6 dispatch-default 在叙事/接口上不再自相矛盾，同时保留 clear-mind 的独立可用性。
- **主要矛盾**：对齐不能破坏独立可用性——clear-mind 的核心定位是无 enloom 也能跑。
- **MINIMAL MVP 边界**：三层轻量对齐——①explore 叙事重构(dispatch 首选/内联原生降级，不改运行时)②Handoff+trigger-contract 反映 enloom 新 posture③可选命名显式化。不动运行时默认、不引入暗检测、不改 plan/review 内联。
- **待确认 / 待补充**：
  1. 用户要的是"叙事一致"(plan 主张)还是"运行时真 dispatch"(被独立约束否决)?
  2. "受独立约束的首选 dispatch"这个叙事修补是否够诚实(review stress)?

`[gate] plan.md exists? → yes` · `[gate] explore.md read before plan? → yes`
