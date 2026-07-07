# Plan · enloom v0.6 P2-recon 升格（reframe + recommended 终版）

```yaml
created: 2026-07-07
project: enloom-v06-p2-recon-deep
stage: plan
status: finalized
revision: v3 (reframe + recommended)
supersedes: v1/v2 同文件（原方案 = "Plan 自动派 recon"；v3 翻为 "人机决策门 + recommended 信号"，见 §1）
```

> **Reading Budget**: ~9 min read（约 4000 字。v3 是终版：v1/v2 的"自动派"方案被 review §6 reframe 推翻，本版落 reframe + recommended 信号规则）。
>
> 前置 explore.md 判定材料：**充分**（v3 无新增一手材料，沿用 v2 实读的 scheduler-rules / v0.5 design S2 / researcher.md / phase-plan.md / evals.json + eval-guide.md / task-packet.md）。

## 版本史（为什么 plan 从 v2 翻成 v3）

- **v1**（2026-07-06 上轮）：原方案 = researcher.md 加 recon 模式 + phase-plan 加结构位 + eval case。review 给 CONDITIONAL。
- **v2**（2026-07-07 本轮详版重跑）：同方案但材料更实，review 给 CONDITIONAL（X+Y+W+Z），核心新发现 = "Role 枚举加 recon 值"是个红线灰色地带 + eval 有 9-case / trigger-evals 双路径。
- **v3（本版，reframe）**：用户提议把"Plan 自动派 recon"换成"**recon 要不要的决策交给用户**"——两条机制：(a) 每个 phase 把 recon 摆成 Human Decision；(b) 用户触发时可直接指定。再叠加"**recommended 信号**"（Plan 在 Registry 无覆盖/新文件类型/边界不明时标 recommended）。**整个换轴**，原方案三件交付物的形态全部改变。

## 0. 原始诉求（含 reframe 后的收敛）

> v1/v2 原始诉求："用 clear-mind 的skill完整详细的分析一下v0.6 P2 recon 规划"
>
> v3 reframe（用户在 review §6 后提出）："要不直接提问用户？每次 enloom 可以让用户决定要不要进入 recon，然后也支持用户触发 enloom 的时候直接指定要 recon 或者不要 recon"
>
> v3 recommended（用户进一步认可）："推荐做确实是巧妙的判断"——把 recommended 从"可选"提为 P2 第一版核心。

上下文：enloom 作者用 enloom dogfood 修 enloom。v0.6 已闭合 P0/P0.5/P1。P2-recon 标 pending。用户拍板的原则："**我是第一个用户，我就会这样用。如果别人不习惯就用其他 skill 或自己改造。**"——这消解了"为假想未来用户设计"带来的 over-engineering，是 v3 的第一性原理基座。

## 1. 诉求剖析（askBQ 模块 A）

**表层意图**：让 enloom 把"要不要 recon"的决策**显式交给用户**，而非靠 Plan 自动判断派不派。两条机制 + 一个 salience 层：
- **(a) 人机决策门**：每个 phase 的 phase-plan 把 recon 摆成一行 Human Decision。
- **(b) 触发时指定**：用户进 enloom 时可直接声明要/不要 recon。
- **(c) recommended 信号**：Plan 在结构化信号出现时把 recon 标 `recommended`（salience 加成，非强制）。

**深层目标**：让"复杂任务该不该先 recon"这件事**有一道过不去的显式门**，而不是靠主窗口记得"该 recon 了"或靠 Plan 自己判断熟不熟（两者都不可靠）。把"承重点"从结构位提醒 agent 换成显式人机门提醒人——人仍可能判错（art_lab #16 的根因就是人没预研），但门保证决策不会被静默跳过。

**期望结果类型**：☑ **方向验证**（reframe 确认了方向，剩"recommended 信号怎么落、eval 怎么改、三件交付物形态怎么变"需 plan 收敛）。

> **张力（已由 reframe 解决）**：v1/v2 的张力是"升格的度"——做少了没升格，做多了越红线。v3 消解了这个张力：**零结构改动**（复用 phase-plan 既有 Human Decision + triage 接偏好），所以根本不碰 v0.5 红线，"度"的问题不存在了。新的张力转移到"recommended 信号怎么设计才不 alarm fatigue"。

## 2. 第一性原理（主要矛盾）

苏格拉底链（1-3 锐问收敛）：

- **追真实需求**：用户不是要"recon 自动化"，是要"P0 那种主窗口手扫漏边界的事，背后有一个该 recon 没 recon 的决策被静默跳过了"。recon 是手段，**显式决策门**才是 need。
- **挑战被当事实的假设**：v1/v2 假设"recon 该由 Plan 自动判断派不派"。**反问**：Plan 判断"熟不熟"和主窗口判断"熟不熟"是同一个不可靠判断，只是换个执行者。把决策交给用户至少诚实——人判熟不熟不可靠是 art_lab #16 的根因，但门保证决策不被跳过。**自动派** vs **人机门**，后者承重更诚实。
- **区分主次**：去掉 recommended（c）会不会让 v3 完全没意义？不会——(a)+(b) 已构成"决策不被静默跳过"的闭环。但去掉 recommended，(a) 退化成 standing option，alarm fatigue 会让用户无脑跳过。**recommended 是让 (a) 不塌成噪音的 salience 层**——不是承重墙（承重在 a 的门），但是让门真正被认真看的放大镜。

```
PRIMARY CONSTRAINT: 把"要不要 recon"从主窗口/Plan 的静默自觉，变成一道
显式人机决策门（a + b）——是达成"recon 决策不被静默跳过"的根本阻塞。
不解决它，P0 漏扫类失败（背后是该 recon 没 recon）会原样复现。

SECONDARY CONSTRAINTS:
  (1) recommended 信号（c）防 standing option 退化成 alarm fatigue——
      Plan 在结构化信号出现时标 recommended，给决策加 salience。
  (2) 不新增 stage/字段/术语——复用 phase-plan 既有 Human Decision 段 +
      triage 接偏好。v0.5 红线因此不适用（零结构改动）。
  (3) recon task 仍是普通 emergent task，产物=规模素描，不扩展 Role 枚举。

MINIMAL MVP:
  (a) phase-plan 模板：Human Decisions 段加一行 recon 决策模板
      ("该 phase 域是否需要先 recon？规模/边界是否已明？")
  (b) triage 接收 recon 偏好（要/不要/默认走 a）
  (c) Plan 标 recommended 的信号规则（三条：Registry 无覆盖 / 新文件类型 /
      规模边界不明）——写进 phase-plan 注释或 scheduler-rules
  (d) researcher.md 约定 recon task 产物=规模素描（How-to-work 一条分支，
      不动 Role/Mode 枚举）
  (e) 9-case case 10 改写：测"Plan 是否把 recon 摆成 Human Decision"

REMOVABLE:
  - 新增 Mode/Role 枚举值（零结构改动原则下直接砍掉，v2 的红线灰色地带
    在 v3 不存在）
  - Pre-flight 独立 stage（v0.5 已否决）
  - recon 与 execution 模型预算分层（上轮用户纠正，已消解）
  - scheduler-rules 那段 v0.5 指引的大改（与新机制交叉引用即可）
  - trigger-evals 加 recon（recon 是 body 内部 pattern，9-case 足够；
    见 §3.1 eval 路径推演）
  - "为其他用户习惯优化"——用户拍板不做，留给 fork
```

> **轻量定义核查**：
> - **"recommended 信号"**：封闭吗？——三条信号（Registry 无覆盖 / 新文件类型 / 规模边界不明）都是 Plan 阶段**本来就在做的判断的副产物**，机械、可判、可错但廉价。可证伪（若无信号却标 recommended = 误报）。**站得住。**
> - **"人机决策门"**：是 concept-borrowing 吗？——不是。phase-plan.md 本就有 Human Decisions 段（行 64-66），recon 决策天然落位，非新机制。**站得住。**
> - **"第一个用户"原则**：是放弃通用性吗？——**是，但这是诚实的第一性原理动作**。"为假想未来用户设计"是 v0.5 红线 over-engineering 的隐形来源；收到"用户=作者"后，alarm fatigue / 通用触发 / 他人习惯这类担忧失去适用对象。**站得住，是 v3 的基座。**

## 3. 优化问题（askBQ 模块 B）

- **B.1 聚焦表层版**：在 v0.6 dispatch-default 下，让"recon 决策不被静默跳过"，最小且零结构改动的机制是什么？——答：phase-plan Human Decision 一行 + triage 接偏好。
- **B.2 直击核心版**：recon 升格真正要解的是"该 recon 没 recon 的决策被跳过"。解法是"加结构强制 Plan 派"（v1/v2，越红线 + agent 自觉不可靠），还是"加门让用户决策"（v3，零结构 + 人判不可靠但门保证不被跳过）？后者承重更诚实。
- **B.3 升维破局版**：如果问题不是"recon 要不要升格"，而是"**'判断熟不熟'这件事，到底该 agent 做、人做、还是拆开做**"？v3 的巧妙在于**拆开**——"该不该重视这个决策"（salience）给 agent（廉价可错的信号判断），"到底做不做"（决策）给人（人机门）。自动派把两个都给 agent（越界），standing option 把两个都给人（alarm fatigue），recommended + 门是中间档。

### 3.1 方向推演（从 B.3 + eval 路径推进）

- **选中的方向**：B.3 的"拆开判断"——recommended（agent 做 salience）+ Human Decision（人做决策）。
- **如果这个方向对，最小可验证假设**：recommended 的三条信号是 Plan 本来就在做的判断的副产物，故"判熟不熟"被降级成"判有没有信号"——后者机械、廉价、可错但安全（recommended 非强制，误报成本低）。
- **当前方案在这个假设下，哪一步先站不住**：若 Registry 在新项目还没积累风险段时，"Registry 无覆盖"会过度触发 recommended（false positive 多）。但这第一个用户（作者）看得懂为什么标 recommended，无视成本低——按"第一个用户"原则可接受。**这是 v3 的已知裂缝，但不阻断。**

**eval 路径推演（沿用 v2，reframe 下更清晰）**：
- recon 是 body 内部 pattern（phase-plan Human Decision），description（skill 入口）不直接描述它。故 case 10 进 **9-case 主 suite**（测"Plan 是否把 recon 摆成 Human Decision"，显式行为好判），**不进 trigger-evals**（测 description 入口，与内部 pattern 无关）。
- v3 下 case 10 更好判：不测"Plan 自动派不派"（难），测"Plan 摆没摆 Human Decision"（显式）。

## 4. 领域拓展（askBQ 模块 C）

- **相邻领域 1：编译器 warning vs error** —— error 强制阻塞（= v1/v2 的结构强制），warning 提示但不阻（= recommended 信号）。编译器不会把所有判断都升级成 error（那会 alarm fatigue），而是用 warning 给 salience，让开发者决策。**可迁移**：recommended 是 recon 的 warning 级，Human Decision 是 error 级（决策必须过，但答案可 no）。
- **相邻领域 2：auto-research DAG cheap-gather → quality-analyze** —— recon 对应 gather（探规模），价值在"用独立上下文探边界、降低主窗口 prompt 污染"。（上轮用户纠正：廉价强模型消解预算分层必要性，DAG 价值从省钱转独立上下文。v3 沿用。）
- **相邻领域 3：测试金字塔（unit vs integration）** —— eval-guide.md 自己分 9-case（integration，喂完整 body）vs trigger-evals（unit，只给 description）。recon 属 body 内部 pattern，按金字塔进 integration（9-case）。**可迁移**：P2 的 eval 归类服从"测什么放进测什么的层"。
- **【v3 新】相邻领域 4：IDE 的 quick-fix lightbulb** —— IDE 不自动改代码（那是越界），而是在有信号时弹 lightbulb（salience），开发者决定改不改（决策）。**可迁移**：recommended = lightbulb，Human Decision = 开发者拍板。完美映射 v3 的"拆开判断"。
- **可借鉴**：warning/error 分级（领域 1）+ 独立上下文（领域 2）+ 测什么放哪层（领域 3）+ lightbulb 模式（领域 4）。

## 5. 领域类似与可能结论（askBQ 模块 D）

- **已知做法 1：v0.5 自己的 down-scope 裁决** —— v0.5 否决 S2（Pre-flight 子阶段 + 字段 + 术语）为 over-engineering。**v3 直接绕开**：零结构改动，不碰红线，无需重裁。v0.5 的升格触发条件（"真实并行规模到来"）在 v3 下**不再相关**——v3 根本不升格结构，只是接既有 Human Decision 机制。**这是 v3 较 v1/v2 的最大简化。**
- **已知做法 2：art_lab #16 踩坑** —— 规模偏差致返工（规划 ~100，实际 ~180）。**这是 recon 概念的诞生地**。v3 下：art_lab #16 的根因（人没预研）在所有方案里都存在，v3 不假装能解，但 Human Decision 门保证"该不该预研"这个决策不被静默跳过——至少把 art_lab 那种"压根没想过预研"的情况显式化了。
- **【v3 新】已知做法 3：phase-plan.md 既有的 Human Decisions 段** —— phase-plan.md:64-66 本就有 "Human Decisions Needed" 段。v3 的机制 (a) 不是新机制，是往既有段加一行 recon 决策模板。类比闸门：复用既有机制 = 零新机制风险。
- **共识与分歧**：领域内共识"预研前置有价值"；v3 的分歧收窄为"recommended 信号的三条规则够不够"。这是个可实证的问题（第一个用户用起来看），不是结构性分歧。

## 6. 缺失信息与隐含假设（askBQ 模块 E）

- **隐含前提**：
  - "要不要 recon"的决策交给用户比交给 Plan 更可靠——**部分成立**：人判熟不熟不可靠（art_lab #16），但门保证决策不被静默跳过；Plan 判熟不熟同样不可靠且 v1/v2 方案下连门都没有。
  - recommended 的三条信号（Registry 无覆盖 / 新文件类型 / 规模边界不明）是 Plan 本来就在做的判断的副产物——**成立**：这些都是 Plan 读 input 时的自然观察，非新工作量。
  - 第一个用户（作者）能正确理解 recommended 的含义，不会被 false positive 困扰——**成立**（用户拍板原则）。
- **前提成立条件**：
  - 门生效需：phase-plan Human Decision 段被 Plan 真的填写且被用户认真看。**机制上保证**（Gate Check 可加"recon considered"行）。
  - recommended 不 alarm fatigue 需：信号规则足够精确，不为每个 phase 都触发。**部分成立**——新项目 Registry 空时会过度触发，但第一个用户可接受。
- **可验证性**：
  - 门是否生效可验：9-case case 10 测"Plan 摆没摆 Human Decision"（显式行为）。
  - recommended 是否有用可验：第一个用户用 reframe 版时，观察 recommended 是否真的影响了 recon 决策（而非被无视）。这是比 case 10 更强的 feedback。
  - **art_lab #16 式漏扫能否防住**：**不可保证**（sub-agent recon 一样漏 packet 外的）。v3 不宣称能防，只宣称"决策不被静默跳过"。
- **可能错误的预设**：
  - "Human Decision 门能防 P0 式漏扫" —— **风险：高，且 v3 不再宣称这个**。门防的是"决策被静默跳过"，不防"决策做错了"（用户可能判错说不要 recon）。这是 v3 的诚实边界。
  - "recommended 三条信号够用" —— **风险：低**。第一版可简，后续按第一个用户反馈加。
  - "第一个用户原则能消解通用性担忧" —— **风险：低**（用户已拍板），但记录为 Known Limitation：v3 不为其他用户优化。
- **缺失信息**：
  - recommended 信号规则的具体措辞（写进 phase-plan 注释还是 scheduler-rules）—— **待 P2 实现时定**（plan 倾向 scheduler-rules 升格那段加，与既有指引同处）。
  - recon 产物对齐 Evidence Contract 四要素的映射 —— **待 P2 实现时定**。
  - triage 接偏好的具体接口（怎么声明要/不要 recon）—— **待 P2 实现时定**（倾向 trigger-contract 或 workflow Stage 1 triage 加一个可选字段）。

## 7. 简单结论 + 问题评分（askBQ 模块 F）

- **有限结论**：
  1. v3 的核心动作是**换轴**：recon 决策从"Plan 自动派"（v1/v2，越红线 + agent 自觉不可靠）换成"人机决策门 + recommended 信号"（零结构 + 人判不可靠但门保证不被跳过）。
  2. recommended 的巧妙在**拆开判断**："该不该重视决策"（salience，agent 廉价可错）与"做不做"（决策，人）分离——避开自动派（越界）和 standing option（alarm fatigue）两个极端。
  3. MVP 五件：phase-plan Human Decision 模板行 + triage 接偏好 + recommended 三信号规则 + researcher.md recon 产物约定 + 9-case case 10 改写。
  4. **诚实边界**：v3 防的是"决策被静默跳过"，**不防**"决策做错"（用户可能说不要 recon 然后撞规模偏差）。art_lab #16 式根因（人没预研）在所有方案里都存在，v3 不假装能解。
- **问题评分**（1-5，v3 较 v2 全面提升）：
  - 诉求清晰度：**5**（reframe + recommended 把"升格的度"这个模糊点彻底消解，v2 是 4）
  - 主要矛盾识别度：**5**（PRIMARY 从"自觉→机制"精确为"静默跳过→显式门"，recommended 是 salience 层，v2 是 4）
  - 假设暴露度：**5**（E 模块标了 art_lab 裂缝 + 第一个用户原则边界 + recommended false positive，v2 是 5）
  - 可验证性：**4**（case 10 改写后更好判，v2 是 3；扣分在 recommended 有效性只能靠第一个用户实证）
- **给 review 的验证焦点**（v3 三条）：
  1. recommended 三信号规则在工程上是否真"廉价"（Plan 本来就在做）——若是，v3 的成本极低。
  2. "第一个用户"原则是否真的消解通用性担忧，还是把债留给未来——review 应判这是"主动不做"还是"隐藏债"。
  3. v3 是否真的不碰 v0.5 红线（零结构改动）——若是，Y/W 条件消失，裁决应翻 WORTH-IT。

## 8. Summary Confirmation Gate（确认门）

- **我理解的问题（v3）**：让"要不要 recon"从主窗口/Plan 的静默自觉，变成一道显式人机决策门（+ recommended salience），保证决策不被静默跳过。
- **主要矛盾**：recon 决策从"静默可跳过"变"显式门"——防 P0 式漏扫背后的"该 recon 没 recon"被静默跳过。
- **MINIMAL MVP 边界（五件）**：phase-plan Human Decision 模板行 + triage 接偏好 + recommended 三信号规则 + researcher.md recon 产物约定 + 9-case case 10 改写。不加 stage/字段/枚举值/Pre-flight。
- **诚实边界**：防"决策被静默跳过"，**不防**"决策做错"。art_lab #16 式根因跨方案恒存。
- **待确认 / 待补充**：
  1. recommended 信号规则落 scheduler-rules 还是 phase-plan 注释（plan 倾向前者）
  2. triage 接偏好的接口（trigger-contract 还是 workflow Stage 1）
  3. recon 产物对齐 Evidence Contract 四要素的映射（P2 实现时定）

> plan 采用一次性输出节奏，此门非阻塞。v3 已与 review §6/§7 对齐（reframe + recommended）。

`[gate] plan.md exists? → yes` · `[gate] explore.md read before plan? → yes`
