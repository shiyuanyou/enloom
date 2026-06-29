# Decisions

影响后续工作的关键决策记录。每条:背景 / 决定 / 理由 / 影响。

## D1 — 版本标签用 v0.2,不用 V1

- **背景**:用户原话说"实现 V1"。但 design-summary.md 的 "V1" 指被废弃的重型架构(Project Control → Prompt Factory → Scheduler → Worker),已被 V2(on-demand skill)取代。项目实际版本线是 v0.1 → v0.2。
- **决定**:本次交付标 **v0.2**。
- **理由**:用 bare "V1" 会和 design-summary 的废弃架构术语冲突;v0.2 正是 PROGRESS.md deferred 项的目标版本。
- **影响**:所有新文档用 v0.2;README/PROGRESS 状态段升级到 v0.2。

## D2 — 不全局安装,留项目本地

- **背景**:PROGRESS.md:40 把"全局安装到 ~/.agents/skills/"列为 v0.2 deferred 项。
- **决定**:**放弃全局安装**,产物留在 `agentos/agentos-workflow-skill/`。
- **理由**:用户明确指示"当前目录即可,不要全局安装"。trigger 边界尚未充分验证(本次才是首个真实任务),不 promote 是保守且正确的。
- **影响**:project_state 标 Known Exception;skill-creator 闭环只跑静态校验 + eval,不做 promote。

## D3 — 范围 = eval 套件 + references 模板 + prompt-assets

- **背景**:用户多选确认本次交付范围。
- **决定**:交付三组:(1) eval 套件(eval.js + eval-guide);(2) 5 个 references 模板;(3) 3 个 prompt-assets 角色。
- **理由**:eval 是 report.md:64 / PROGRESS.md:39 明确的 v0.2 收尾核心;references 和 prompt-assets 来自 skill-reference-notes.md 的设计建议。
- **影响**:T002/T003/T004 是 Phase B 的三个并行声明 task。

## D4 — prompt-assets 只写 researcher/coder/reviewer

- **背景**:design-summary.md:298-308 列了 researcher/architect/coder/reviewer/tester 五个角色。但 PROGRESS.md:41 明确"Worker 角色资产不预先写,等反复使用沉淀出稳定措辞"。
- **决定**:只写 **researcher / coder / reviewer** 三个核心角色,architect/tester 标 deferred。
- **理由**:尊重项目自身纪律"不预先写"。三个角色覆盖 triage-decision-tree 和 review 路径里实际出现的角色,是验证协议必需的最小集。
- **影响**:T003 产 3 文件;architect/tester 在 project_state Pending Registry 记一笔。

## D5 — skill-creator 闭环走手工版

- **背景**:skill-creator 的 `run_eval.py`/`run_loop.py` 依赖外部 `claude -p` subagent 调度,本单 agent 会话跑不了。
- **决定**:闭环 = `quick_validate.py` 静态校验(回归基线)+ 手工版 eval(用 evals.json 的 prompt 逐个验证 triage/review 决策,记录 pass/fail)。
- **理由**:诚实于环境约束。静态校验是 v0.1 已用的同一命令(report.md:34);手工 eval 是 PROGRESS.md:46 "跑真实任务" 的本意。
- **影响**:eval-guide.md 必须写明自动版前置条件,供后续环境具备时复跑。

## v0.3 决策(2026-06-24,自 brainstorming 逐节确认)

### D6 — 重组深度 C-中:SKILL.md 重写为生命周期驱动

- **背景**:v0.3 发力点是 art_lab 经验内化。内容组织有「操作菜单为主架」与「生命周期阶段为主架」两选。
- **决定**:选生命周期重组(C-中深度)。SKILL.md 从「6 操作菜单」重写为「6 阶段生命周期」,操作降级为阶段内子动作。Step 0-7 合并 Make Packet+Dispatch 为 Execute(阶段 3)。
- **理由**:操作菜单是扁平的,生命周期是时序的——长任务的真实结构是时序。降级操作不消失,只是有了归属。
- **影响**:SKILL.md + workflow-steps.md 重写;glossary 加 Lifecycle Stage 等术语。

### D7 — art_lab 作 worked example,不进主干

- **背景**:art_lab 原始样本(死链扫描/quote 编码扫描/引用计数)是 wiki 领域专属。
- **决定**:主干 references 只出现通用结构(check_item schema / 三阶模型 / Promise Registry)。art_lab 的具体命令**只**进 `references/examples/art-lab-worked-example.md`,作「通用结构在真实任务里长什么样」的参照。
- **理由**:skill 主体对编码/研发任务通用,art_lab 经验又不丢失。领域词(dead link/promise page)通用化为 Broken References / Promised Outputs。
- **影响**:新增 art-lab-worked-example.md;主干 reference 不含 wiki 命令。

### D8 — 五块全上 + 状态治理汇一份 reference

- **背景**:五块经验(Registry / Evidence Contract / Ownership+Promise / Compaction / Audit)落地范围。
- **决定**:五块全上。Registry/Ownership/Promise/Compaction 主题内聚(都是「如何治理 project_state」),汇入同一份 `registry-and-compaction.md`,避免文件碎片。Evidence Contract 独立(它是验证层,与状态治理正交)。
- **影响**:新增 evidence-contract.md + registry-and-compaction.md(各 1 节);4 templates 扩展。

### D9 — 守 Non-Goals + 诚实约束单 agent 隔离

- **背景**:v0.3 易越界引入执行器来自动化 audit/compaction。
- **决定**:守线——纯文件协议 + 决策纪律,不引入 scheduler/CLI/runtime。art_lab 的命令证据要求靠 audit packet 契约 + review gate 拒绝无证据 PASS 落地,control agent 手动跑命令、手动登记 registry。单 agent worker 隔离靠字段纪律(Writable/Forbidden)非执行隔离,在 Evidence Contract 要求诚实声明此盲区。
- **理由**:越界会破坏 skill 的轻量定位。诚实于环境约束,不假装解决隔离。
- **影响**:Non-Goals 与 v0.2 一致;verify-report 显式声明 Not Checked: 跨 worker 真实隔离性。
