# Glossary

固定术语表,防止长期讨论中的概念漂移。所有 reference 和模板必须使用同一组词。

## 核心术语

| 术语 | 含义 |
|------|------|
| **Control Skill** | 按需触发的控制流程,走生命周期 6 阶段编排(triage → orient → plan → execute → verify → integrate → close)。不编码、不深读 raw。 |
| **Lifecycle Stage** | v0.3 的主架。6 阶段:0 Triage / 1 Orient / 2 Plan / 3 Execute / 4 Verify / 5 Integrate / 6 Close。操作降级为阶段内的子动作。 |
| **Task Packet** | 给 Worker 的任务契约。版本化(当前 0.2)。最小字段见 [templates/task-packet.md](templates/task-packet.md)。约束 worker **行为**(该做什么)。 |
| **Worker** | 短生命周期执行单元,是**独立的 sub-agent 执行单元**(sub-agent / Pi / 其他支持 sub-agent dispatch 的运行时)。主窗口(control agent)不进入 worker mode——Stage 3 task 必须 dispatch 给独立 sub-agent;运行时无 sub-agent 能力 → 中断,提示换支持工具(opencode / pi / codex 等),不退化自执行。在 packet 边界内发挥智能。 |
| **Prompt Asset** | 可复用的 Worker prompt 模板(如 researcher.md / coder.md)。素材,不是常驻 agent。 |
| **Report** | Worker 给 verify 的压缩结论。固定结构对齐 Evidence Contract 四要素。 |
| **Raw Notes** | 可追溯但默认不读的过程材料。仅当证据不足 / 失败 / 高风险 / 复盘时读。 |
| **Review Budget** | verify 方允许读取的材料与成本。路由规则,不只是长度限制。 |
| **Project State** | 当前项目压缩状态(`project_state.md`)。目标 3 分钟读完,<200 行触发 compaction。含 Registry 七区段。v0.4 起 `project_state.md` 住在**项目目录内**(`.enloom/<project>/`),不再全局唯一。 |
| **Decisions** | 影响后续工作的关键决策记录(`decisions.md`)。 |
| **Archive** | 已闭合任务的过程材料 + 归档条目。 |
| **Done Signal** | Worker 完成后的明确标记:`done` / `blocked` / `failed`。 |

## v0.3 新增术语(状态治理 + 验证)

| 术语 | 含义 |
|------|------|
| **Registry** | project_state.md 的固定结构,七区段活性真相。详见 [registry-and-compaction.md](registry-and-compaction.md)。 |
| **Ownership Table** | 文件所有权表。三阶所有权模型(并行写区 / 串行集成区 / 只读区)。并行 dispatch 的硬前置(铁律 3 升级)。 |
| **Promise Registry** | 承诺产出注册表。占 Registry 的 `## Promised Outputs` 区段。前向声明产出 + 悬空引用容忍 + 末端校验。 |
| **Evidence Contract** | 证据契约。任何宣称完成的 worker 必须产出四要素:Checks Run / Evidence / Not Checked / Known Blind Spots。详见 [evidence-contract.md](evidence-contract.md)。 |
| **Audit Packet** | 审计任务包。Task Packet 的特化,约束 worker **验证**(该验证什么、怎么算通过)。5 元组 check_item schema。详见 [templates/audit-task-packet.md](templates/audit-task-packet.md)。 |
| **Audit Mode** | 审计模式。`batch`(抽样,周期性)/ `final`(全量,发布前)。挂 Verify 阶段。 |
| **Verdict** | 三态验收结论:`PASS` / `ISSUES` / `FAIL`。中间态 ISSUES 支撑「带已知缺陷继续推进」。 |
| **Compaction** | 压缩协议。压缩已闭合的过程细节,绝不压缩未闭合风险。四步:扫描 → 迁移 → 收口 → 校验。 |
| **check_item** | Audit Packet 的标准检查项,5 元组:id / command / pass_condition / fail_signal / named_list。 |

## v0.4 新增术语(命名空间 + 落盘)

| 术语 | 含义 |
|------|------|
| **Project** | 顶层命名空间单元。`.enloom/` 下一个 `<创建时间>-<项目名>` 目录 = 一个 Project,内含自己的 project_state / Registry / tasks / runs / archive。跨 Project 状态不混。同名 Project 第二次进入复用已有目录(时间戳=创建日,固定)。 |
| **task_board** | 唯一入口表(`.enloom/task_board.md`)。一行一 Project,字段 project/created/updated/phase/desc。Orient 第一步读它定位目标 Project。只索引项目,不索引任务。 |
| **Gate / 闸门** | Stage 转移的机械检查 = 文件存在性。每个 Stage 有入口/出口闸门(如 Stage 3 入口:`runs/<TASK>/task.md` 必存在)。control 自检 + health-check 硬闸门双保险。完整表见 [landing-contract.md](landing-contract.md)。 |
| **Landing / 落盘** | worker 产出必须落盘成文件(output.md/report.md),不能只留对话上下文。dispatch 交的是 task.md 路径,非口头描述。是闸门表成立的物理前提,也是铁律 2/5 机械化的基础。 |

## v0.5 新增术语(闸门强化 + 盲区诚实化 + 证据补维)

| 术语 | 含义 |
|------|------|
| **Claim Consistency(报告自洽)** | Evidence Contract 第 5 维(v0.5)。对 report 任何可数 claim(条目数/通过率/文件数/覆盖率),Verify 阶段用独立脚本(grep -c/awk/git diff --stat)对 output 实际重数;偏差>0 → ISSUES。**不叫 sub-agent 计数验证**(单 agent 下名不副实)。audited 模式必填,recorded/emergent 可选。详见 [evidence-contract.md §The Fifth Dimension](evidence-contract.md)。 |
| **health-check 两档** | v0.5 拆 health-check 执行:**轻量档**(Stage 转移时只跑该闸门文件存在性,单行 "Gates OK" 确认)+ **完整档**(Orient 入口 + 定期 Verify,九项全量)。硬闸门语义不变,只降执行成本。详见 [workflow-steps.md §Health Check](workflow-steps.md)。 |
| **Honest Blind Spots(三项)** | v0.5 把单 agent 环境的诚实盲区从 1 项扩为 3 项:(1) cross-worker real isolation(无独立 runtime 验证未碰 forbidden),(2) cross-role verification(verdict/review/audit 可能同 context),(3) virtual parallelism(单 agent 下 strategy:parallel 只是协议形式,执行实际串行)。详见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。 |
| **Reference Tolerance Decision Table** | v0.5 phase-plan 新增的引用容忍度决策表。填 3-5 种引用类型(wikilinks/markdown links/code import/file path/schema $ref)的悬空容忍度,据此决定 promise+parallel 是否可用。脚手架非新闸门。详见 [templates/phase-plan.md](templates/phase-plan.md)。 |
| **Mode-differentiated density(模式约束密度)** | v0.5 task-packet 三模式差异化字段表。约束密度匹配 mode:emergent 的 Forbidden 可选(audited 级约束对探索任务过度);audited 的 Required Verification + Countable outputs 必填(缺则 make-prompt 自检失败,不准 dispatch)。详见 [templates/task-packet.md](templates/task-packet.md)。 |
| **recon task(侦察任务)** | v0.5 scheduler-rules 调度指引。新 domain/不熟代码库时,首 task 设为侦察 task(现有 task-packet,mode=emergent,Allowed Tools=Read/Grep/Web),output 喂回 Plan 修正切分。**非新阶段、非新字段、非新术语**(吃 80% 预研价值,零结构改动)。详见 [scheduler-rules.md](scheduler-rules.md)。 |

## 不要混用的词

- 不要把「Prompt Asset」叫「常驻 Agent」——它是素材。
- 不要把「Report」叫「输出」——输出是 `output.md`,report 是压缩结论。
- 不要把「Task Packet」叫「Prompt」——packet 是契约,prompt 是 packet 实例化后的执行输入。
- 不要把「Audit Packet」叫「Task Packet」——前者约束验证,后者约束行为。正交但不同。
- 不要把「Verdict」和 review 结论混用——Verdict(PASS/ISSUES/FAIL)是 verify 阶段的机械化判定;review 结论(accepted/needs-rework/...)是 control agent 的整合决策。
- 不要把「Registry」叫「状态」——Registry 是 project_state 的固定七区段结构,是状态里的活性真相部分。
- 不要把「task_board」叫「任务列表」——task_board 是**项目级**索引表(一行一项目),不索引任务;任务留在各项目的 project_state。v0.4 新增。
- 不要把「Claim Consistency」叫「sub-agent 计数验证」——单 agent 串行下没有可信的 sub-agent 实例可数,后者名不副实。v0.5 新增。

## 版本对象

- **Task Packet Version**:契约格式版本(当前 0.2)。
- **Skill 版本**:skill 整体发布版本(v0.1 / v0.2 / v0.3 / ...)。
- **Design generation**:设计代际(V2 = on-demand skill 论文;不是发布号)。
