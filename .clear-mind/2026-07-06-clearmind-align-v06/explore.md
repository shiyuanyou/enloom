# Explore · clear-mind 对齐 v0.6 dispatch-default(自审)

```yaml
created: 2026-07-06
project: clearmind-align-v06
stage: explore
status: finalized
input: "clear-mind 应该也对齐一下 enloom 今天的 dispatch-default 升级"
```

> **Reading Budget**: ~6 min read(约 2500 字)。本案核心是判断"clear-mind 的 explore gather 默认内联"与"enloom 的 dispatch-default"是否真冲突，还是定位不同的合理设计。材料底座已读 SKILL.md / trigger-contract / explore-method / honest-limitations 全文。

## Uncertain Items Summary

- **最尖锐的表面冲突**：clear-mind explore gather 默认"模式 B 内联"，enloom v0.6 默认"dispatch sub-agent"——表面相反。但这可能是定位差异(编排层 vs worker 层)而非真冲突 → §2.1 / §3
- clear-mind 全 skill **零使用 "control agent" 角色名**，与 enloom P1 命名铁律不一致 → §2.1(命名层)
- honest-limitations §X.1 自陈"单 agent 串行，plan/review 同上下文"——这是 v0.5 留的声明，enloom v0.6 是否让它过时 → §2.2

## 0. 原始诉求(用户原话)

> "现在总结一下 enloom 今天的升级迭代思路，我觉得那个 clear-mind 应该也对齐一下"

上下文：enloom 今天(2026-07-06)完成 v0.6 三个 commit——P0/P0.5(叙事翻转：单 agent 自执行合法 → 默认 dispatch sub-agent，无能力即中断不退化)+ P1(角色命名硬化：control agent/worker 二分，禁"the agent")+ clear-mind 自跑 P2 裁决。用户感觉 clear-mind 作为 enloom 的 phase -1 前置兄弟 skill，应当对齐这套新 posture。方向未定，故选"先跑 clear-mind 自审"。

## 1. prepare 摘要

- **归一化诉求**：审查 clear-mind 全 skill(18 文件 / 2309 行)对 enloom v0.6 dispatch-default posture 的对齐度——哪些地方与新 posture 真冲突(需改)、哪些是 clear-mind 自身定位决定的合理设计(不该动)、哪些只是命名/措辞层面的轻量不一致。
- **信源优先级**：本地一手(clear-mind skill 源文件) > enloom v0.6 dogfood 产物(project_state / archive entries) > LLM 内置。无 wiki / Web 适用。
- **搜索策略**：已用 grep 全 skill 扫 10 类术语(内联/模式 A·B/单 agent/降级/自执行/worker/sub-agent/control agent/主窗口/handoff/执行编排)，命中点已在 §2 归类。
- **wiki 检测结果**：☐ 未检测到 wiki，跳过。

## 2. gather 汇总(4 信源维度)

### 2.1 本地一手(最高优先级：clear-mind skill 源 + enloom v0.6 产物)

**最尖锐的表面冲突点 —— explore gather 的默认模式**：
- **可量化事实**：clear-mind 的 explore gather 有双模式(模式 A 借 enloom dispatch 并行 / 模式 B 内联降级)，**默认模式 B**，仅当用户显式要求 enloom dispatch 才切模式 A。声明在 `trigger-contract.md:38` + `explore-method.md:87-90`。模式 B 定义(`explore-method.md:109-112`)："当前 agent 顺序内联执行 4 信源收集(不派 worker)"。
- **边界条件**：clear-mind **刻意拒绝** `.enloom/` 存在性检测作为模式切换判据(`trigger-contract.md:38` + `explore-method.md:92`)，理由是"那是隐性依赖 + 误判风险——别的项目残留的 `.enloom/` 不等于当前可调用 enloom"。模式选择是**公开声明(用户显式要求)**，不是**暗地检测**。
- **内部矛盾(本案核心张力)**：enloom v0.6 的 dispatch-default posture 是"Stage 3 worker task 必须 dispatch 给 sub-agent，无能力即中断不退化"。clear-mind 的 gather 默认"当前 agent 内联做(不派 worker)"。**表面看，两个兄弟 skill 的默认姿态相反。** 但这是真冲突还是定位差异，是 plan 要裁决的核心。

**定位差异的关键线索(可能化解冲突)**：
- **可量化事实**：clear-mind 的 SKILL.md:8-10 自我定位为"optional phase -1，sits before execution-orchestration skills like Enloom"，"does not provide a scheduler, CLI, or resident agent"。它的 plan/review 本来就是"当前 agent 内联做判断"——这是**编排层工作(想清楚要不要做)**，不是 worker task(执行)。
- **边界条件**：enloom 的 dispatch-default 针对的是 **Stage 3 Execute 的 worker task**(读代码/写产物/跑校验)。clear-mind 的 plan/review 不生产 worker 产物，它产出的是**裁决文件(plan.md/review.md)**。两者处在生命周期的不同层。
- **内部矛盾**：但 clear-mind 的 explore gather 做的"4 信源收集"(Read/Grep 代码库、WebSearch、读 wiki)——**这在 enloom 里恰好是典型的 worker task 形态**(只读研究、独立产物文件)。explore-method §3 自己也说模式 A 是"enloom 按 Ownership Table 派并行 worker"。**所以 explore gather 是 clear-mind 里唯一一个"跨越编排层/worker 层边界"的阶段**——它的内联默认，才是真冲突点；plan/review 的内联，是合理设计。

**角色命名不一致(enloom P1 标准)**：
- **可量化事实**：clear-mind 全 skill **零使用 "control agent"**(grep 0 命中)。它用泛化的"执行编排"/"enloom"/"主窗口"(后者仅 1 处，在 v0.5 前瞻设计里，askbq-framework.md:192)。也**零使用 "自执行"/"自己执行"** 字面——最接近的是 explore-method.md:112 的"当前 agent 顺序内联执行"。
- **边界条件**：enloom P1 建立的命名铁律是 control agent(编排)/ worker(执行)二分。clear-mind 不用这套命名，因为它**不自视为执行编排**——它是 phase -1 前置。
- **内部矛盾**：但 clear-mind 在 explore 模式 A 里**确实借 enloom 派 worker**(explore-method.md:99-104：worker-local/worker-wiki/worker-web/worker-llm)。它谈论 worker 时用的是 enloom 的术语，谈论自己时却没有对等的"编排者"角色名。**这是术语层面的不对称，但影响有限**(clear-mind 不需要 control agent 这个角色，因为它不是 orchestrator)。

### 2.2 honest-limitations §X.1 的"单 agent"自陈

- **可量化事实**：`honest-limitations.md:3,21,24,28` 多处自陈"clear-mind 在单 agent 串行环境下""plan/review 在同一 session 先后运行""v0.5 sub-agent 隔离是为了将来缓解，但当前仍是单上下文"。
- **边界条件**：这是 v0.5 留下的诚实声明，针对的是 **plan→review 两阶段裁决的独立性**(同一模型上下文扮两角)，不是 explore gather 的 dispatch。
- **内部矛盾**：enloom v0.6 翻转后，"单 agent 自执行"在 enloom 里是被消灭的叙事。但 clear-mind 的 §X.1 谈的是**裁决独立性**，不是**执行 dispatch**——这是两个不同维度。enloom 消灭的是"worker task 自执行"，clear-mind §X.1 声明的是"review 验证靠纪律不靠隔离"。**后者不被 v0.6 推翻**，但措辞上"单 agent 串行环境"这个框定，在新 posture 下读起来有点像 clear-mind 还停在旧基线。

### 2.3 现有 wiki / 知识库

- 无，跳过。

### 2.4 外部网络 / LLM 内置

- 未收集(本案是 skill 内部设计一致性审查，无外部可比对象)。

## 3. 语义线索(关键发现位置索引)

- **核心声称所在位置**：
  - clear-mind 默认内联 → `trigger-contract.md:38`(规范声明) + `explore-method.md:87-90`(选择规则) + `explore-method.md:109-112`(模式 B 定义)
  - clear-mind 拒绝 .enloom 检测 → `trigger-contract.md:38` + `explore-method.md:92`(反检测理由)
  - clear-mind 自我定位(phase -1 前置，非 orchestrator)→ `SKILL.md:8-10`
  - enloom dispatch-default 新 posture → `.enloom/2026-07-06-enloom-v06/project_state.md:12-17`(Goal)
- **疑似概念混淆处**：
  - "内联"在 clear-mind 有**两种不同含义**：①explore gather 的模式 B(当前 agent 做 worker 活，不派 worker)②plan 的"内联做最小调查"(plan 自己读材料，本就是编排层职责)。grep "内联" 会把两者混在一起，但只有 ① 与 dispatch-default 有张力。
  - "单 agent"在 clear-mind §X.1 指"plan/review 同上下文"(裁决独立性维度)；在 enloom v0.6 指"worker task 自执行"(执行 dispatch 维度)。**同词异义**，不能因为都用"单 agent"就判定 clear-mind 落后。
- **关键论证起点**：plan 若要论证"clear-mind 该翻转 explore 默认"，从 explore-method.md:112(模式 B 做 worker 活)起读；若要论证"不该翻转"，从 SKILL.md:8-10(phase -1 定位) + trigger-contract.md:38(拒绝暗检测的纪律)起读。

## 4. 信息充分度判断

勾选：**☑ 充分**

- 一手材料覆盖全部关键概念：clear-mind 18 文件已扫 10 类术语，命中点全部定位；enloom v0.6 posture 三处规范声明已读；honest-limitations 全文已读。
- 事实可量化：默认模式 B(grep 定位)、零 control agent(0 命中)、零"自执行"(0 命中)、explore gather 是唯一跨层阶段(结构定位)。
- **无关键缺口**。唯一的"不确定"是裁决本身(冲突 vs 定位差异)——那是 plan/review 的活，不是材料缺口。

> 注：本案信息充分度高，是因为问题域窄(clear-mind 一个 skill 对一个 posture)。若裁决发现需要横向对比"其他 phase -1 skill 如何定位"，则需补外部材料——但当前无此需求。

## 5. 给 plan/review 的交接

- **下游最该带着的三条材料**：
  1. **冲突的真正落点是 explore gather(不是 plan/review)**。plan/review 的内联是编排层合理设计(想清楚 vs 执行)，不该按 enloom worker 标准"翻转"。explore gather 的模式 B 才是"做了 worker 活却不 dispatch"——这是唯一真冲突候选。
  2. **clear-mind 有两条自设纪律让"翻转默认"变得复杂**：①拒绝 `.enloom/` 暗检测(理由是误判风险)②定位为 phase -1 前置(非 orchestrator)。翻转默认若要发生，得先回答"怎么判 enloom 可调用"(不能靠暗检测，那靠什么)。
  3. **命名层有轻量不一致**(零 control agent)，但这可能不是问题——clear-mind 不是 orchestrator，不需要这个角色名。是否要统一，是风格决策非正确性决策。
- plan 据此走诉求剖析 → 第一性原理 → askBQ A-F；review 对"是否翻转 explore 默认"做应力测试，最后三态裁决。

`[gate] explore.md exists? → yes`
