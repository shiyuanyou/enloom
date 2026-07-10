# Glossary

固定术语表,防止长期讨论中的概念漂移。所有 reference 和模板必须使用同一组词。术语按逻辑分组(生命周期 / 状态治理 / 命名空间 / 验证),不按加入版本;下面"版本对象"段单独说明契约与发布号。

## 核心术语(生命周期 + 任务包 + 角色)

| 术语 | 含义 |
|------|------|
| **Control Skill** | 按需触发的控制流程,走 Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6)编排(triage → orient → plan → execute → verify → integrate → close)。不编码、不深读 raw。 |
| **Lifecycle Stage** | 生命周期主架。模型是 Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6):0 Triage / 1 Orient / 2 Plan / 3 Execute / 4 Verify / 5 Integrate / 6 Close。Triage 是入口决策,不计入六阶段。操作降级为阶段内的子动作。 |
| **Task Packet** | 给 Worker 的任务契约。版本化(当前 0.2)。最小字段见 [templates/task-packet.md](templates/task-packet.md)。约束 worker **行为**(该做什么)。 |
| **Worker** | 短生命周期执行单元,是**独立的 sub-agent 执行单元**(sub-agent / Pi / 其他支持 sub-agent dispatch 的运行时)。主窗口(control agent)不进入 worker mode——Stage 3 task 必须 dispatch 给独立 sub-agent;运行时无 sub-agent 能力 → 中断,提示换支持工具(opencode / pi / codex 等),不退化自执行。在 packet 边界内发挥智能。 |
| **Prompt Asset** | 可复用的 Worker prompt 模板(如 researcher.md / coder.md)。素材,不是常驻 agent。 |
| **Report** | Worker 给 verify 的压缩结论(`report.md`)。固定结构对齐 Evidence Contract 四要素。RA3:entirely worker-owned —— 不含 Review Result(verdict/conclusion 在独立的 `review-result.md`,control 写)。 |
| **Raw Notes** | 可追溯但默认不读的过程材料。仅当证据不足 / 失败 / 高风险 / 复盘时读。 |
| **Review Budget** | verify 方允许读取的材料与成本。路由规则,不只是长度限制。 |
| **Project State** | 当前项目压缩状态(`project_state.md`)。目标 3 分钟读完,<200 行触发 compaction。含 Registry 七区段。`project_state.md` 住在**项目目录内**(`.enloom/<project>/`),非全局唯一。 |
| **Decisions** | 影响后续工作的关键决策记录(`decisions.md`)。 |
| **Archive** | 已闭合任务的过程材料 + 归档条目;已闭合项目(fold 后)的折叠目录。 |
| **Done Signal** | Worker 完成后的明确标记:`done` / `blocked` / `failed`。 |

## 状态治理术语(Registry / Ownership / Promise / Compaction / Evidence Contract)

| 术语 | 含义 |
|------|------|
| **Registry** | project_state.md 的固定结构,七区段活性真相。详见 [registry-and-compaction.md](registry-and-compaction.md)。 |
| **Ownership Table** | 文件所有权表。三阶所有权模型(并行写区 / 串行集成区 / 只读区)。并行 dispatch 的硬前置(铁律 3:No Parallel without Ownership Table)。 |
| **Promise Registry** | 承诺产出注册表。占 Registry 的 `## Promised Outputs` 区段。限同一 phase 内 worker 间前向声明(worker A 声明将产出 X,worker B 已引用 X);交付物按惯例自带的悬空引用(如 canon forward-declare `[[Djembe]]`)不属此,归 Accepted With Risk 或 Known Exceptions。前向声明产出 + 悬空引用容忍 + 末端校验。 |
| **Evidence Contract** | 证据契约。任何宣称完成的 worker 必须产出四要素(两两 disjoint):Checks Run / Evidence / **Not Checked**(packet 声明的 required-check ID 中未执行者,阻断 PASS)/ **Known Blind Spots**(结构性/运行时/越界限制,带 `blocks_check_ids`)。verdict 与 conclusion 的判定由 §Verdict Decision Function 作为 total function 唯一给出。详见 [evidence-contract.md](evidence-contract.md)。 |
| **Audit Packet** | 审计任务包。Task Packet 的特化,约束 worker **验证**(该验证什么、怎么算通过)。5 元组 check_item schema。详见 [templates/audit-task-packet.md](templates/audit-task-packet.md)。 |
| **Audit Mode** | 审计模式。`batch`(抽样,周期性)/ `final`(全量,发布前)。挂 Verify 阶段。 |
| **Verdict** | 三态验收结论:`PASS` / `ISSUES` / `FAIL`。判定由 [evidence-contract.md §Verdict Decision Function](evidence-contract.md) 作为 total function 唯一给出(ordered verdict table + mandatory conclusion mapping),消费者不复述公式。中间态 ISSUES 支撑「带已知缺陷继续推进」。 |
| **Review Result / review-result.md** | Verify 阶段的验收结果文件(`runs/<RUN>/review-result.md`)。含 verdict(PASS/ISSUES/FAIL)+ review 结论(accepted/accepted-with-risk/needs-rework/rejected)。**RA3:control-owned 独立文件,sole writer = control** —— 不在 worker 的 `report.md` 内。reviewer/audit worker 只在自己的 `output.md`/`report.md` 写 proposal;只有 control 整合,写 target 与每个 Verify-worker run 的 `review-result.md`。canonical run join = `task.md + output.md + report.md + review-result.md`。 |
| **File-level ownership(RA3)** | 每个 durable artifact 恰好一个 sole writer,无物理文件双写。`report.md` 全归 worker;`review-result.md` 是独立 control-owned artifact。取代旧的 section-level 模型(一个 `report.md` 由 worker 写 evidence body + control 填 Review Result 子段)。七行 owner 表见 [landing-contract.md §6](landing-contract.md)。 |
| **Compaction** | 压缩协议。压缩已闭合的过程细节,绝不压缩未闭合风险。四步:扫描 → 迁移 → 收口 → 校验。 |
| **check_item** | Audit Packet 的标准检查项,5 元组:id / command / pass_condition / fail_signal / named_list。 |

## 命名空间术语(Project / task_board / Gate / Landing)

| 术语 | 含义 |
|------|------|
| **Project** | 顶层命名空间单元。`.enloom/` 下一个 `<创建时间>-<项目名>` 目录 = 一个 Project,内含自己的 project_state / Registry / tasks / runs / archive。跨 Project 状态不混。同名 Project 第二次进入复用已有目录(时间戳=创建日,固定)。**定位走 C10 两根 resolver**(同时检查 active 根 `.enloom/<created>-<project>/` 与 archive 根 `.enloom/archive/<created>-<project>/`,fold 后的 closed 项目从 archive 根解析,不可无条件假设在 active 根)。 |
| **task_board** | 唯一入口表(`.enloom/task_board.md`)。一行一 Project,字段 project/created/updated/phase/desc。Orient 第一步读它定位目标 Project,再跑 C10 两根 resolver 解析到唯一目录。只索引项目,不索引任务。 |
| **Gate / 闸门** | Stage 转移的机械检查 = 文件存在性。每个 Stage 有入口/出口闸门。**Stage 3 入口 = 接受的 phase plan 存在**(C03:非 packet;packet 由 `make-prompt` 在 Stage 3 内创建,之后 **Law 2 预派发闸门**检查 packet 存在才允许 dispatch)。control 自检 + health-check 硬闸门双保险。完整表见 [landing-contract.md](landing-contract.md)。 |
| **Landing / 落盘** | worker 产出必须落盘成文件(output.md/report.md),不能只留对话上下文。dispatch 交的是 task.md 路径,非口头描述。是闸门表成立的物理前提,也是铁律 2/5 机械化的基础。 |
| **Fold / 折叠** | 项目级目录折叠。closed 项目目录从 `.enloom/` 顶层移到 `.enloom/archive/`。**触发时机(C04):Stage 0 Triage 决定 `enloom` 之后**(非 Triage 前);`direct`/`light-plan` 不触发。**control 直接执行的串行 namespace 操作,不派 sub-agent**。条件:phase=closed + 目录在顶层 + closed 顶层项目 ≥3。区别于 archive(phase 级归档)。task_board 行不动。**fold 后项目从 archive 根解析**(C10 两根 resolver:active 与 archive 两候选,fold 让路径变化对查找透明)。详见 [archive-policy.md](archive-policy.md) §Project Fold;resolver 规范见 [templates/task-board.md §Resolver](templates/task-board.md)。 |

## 验证术语(Claim Consistency / health-check 两档 / Honest Blind Spots / Reference Tolerance / Mode-differentiated / recon)

| 术语 | 含义 |
|------|------|
| **Claim Consistency(报告自洽)** | Evidence Contract 第 5 维。对 report 任何可数 claim(条目数/通过率/文件数/覆盖率),Verify 阶段用独立脚本(grep -c/awk/git diff --stat)对 output 实际重数;偏差>0 → ISSUES。**不叫 sub-agent 计数验证**(单 agent 下名不副实)。audited 模式必填,recorded/emergent 可选。详见 [evidence-contract.md §The Fifth Dimension](evidence-contract.md)。 |
| **health-check 两档** | health-check 操作在**两个轴(C06)**:**周期主场所轴**(完整档——Orient 入口 + 定期 Verify,九项全量扫描)+ **转移执行轴**(轻量档——control 在六阶段生命周期的五个边界 `1→2/2→3/3→4/4→5/5→6` 各跑一次,只验前一阶段出口闸门文件,单行 "Gates OK" 确认)。两轴不可混同:周期主场所不是转移执行点的全集。硬闸门语义不变,只降执行成本。详见 [landing-contract.md](landing-contract.md) §4。 |
| **Honest Blind Spots(三项)** | 单 agent 环境的诚实盲区共三项:(1) cross-worker real isolation(无独立 runtime 验证未碰 forbidden),(2) cross-role verification(verdict/review/audit 可能同 context),(3) virtual parallelism(单 agent 下 strategy:parallel 只是协议形式,执行实际串行)。详见 [evidence-contract.md §The Honest Blind Spots](evidence-contract.md)。 |
| **Reference Tolerance Decision Table** | phase-plan 的引用容忍度决策表。填 3-5 种引用类型(wikilinks/markdown links/code import/file path/schema $ref)的悬空容忍度,据此决定 promise+parallel 是否可用。脚手架非新闸门。详见 [templates/phase-plan.md](templates/phase-plan.md)。 |
| **Mode-differentiated density(模式约束密度)** | task-packet 三模式差异化字段表。约束密度匹配 mode:emergent 的 Forbidden 可选(audited 级约束对探索任务过度);audited 的 Required Verification + Countable outputs 必填(缺则 make-prompt 自检失败,不准 dispatch)。详见 [templates/task-packet.md](templates/task-packet.md)。 |
| **recon task(侦察任务)** | scheduler-rules 的侦察调度。新 domain/不熟代码库时,首 task 设为侦察 task(现有 task-packet,mode=emergent,Allowed Tools=Read/Grep/Web),output 喂回 Plan 修正切分。**非新阶段、非新字段、非新术语**(吃 80% 预研价值,零结构改动)。详见 [scheduler-rules.md](scheduler-rules.md)。 |

## 不要混用的词

- 不要把「Prompt Asset」叫「常驻 Agent」——它是素材。
- 不要把「Report」叫「输出」——输出是 `output.md`,report 是压缩结论。
- 不要把「Task Packet」叫「Prompt」——packet 是契约,prompt 是 packet 实例化后的执行输入。
- 不要把「Audit Packet」叫「Task Packet」——前者约束验证,后者约束行为。正交但不同。
- 不要把「Verdict」和 review 结论混用——Verdict(PASS/ISSUES/FAIL)是 verify 阶段的机械化判定;review 结论(accepted/needs-rework/...)是 control agent 的整合决策。
- 不要把「Registry」叫「状态」——Registry 是 project_state 的固定七区段结构,是状态里的活性真相部分。
- 不要把「task_board」叫「任务列表」——task_board 是**项目级**索引表(一行一项目),不索引任务;任务留在各项目的 project_state。
- 不要把「Claim Consistency」叫「sub-agent 计数验证」——单 agent 串行下没有可信的 sub-agent 实例可数,后者名不副实。

## 版本对象

- **Task Packet Version**:契约格式版本(当前 0.2)。
- **Skill 版本**:skill 整体发布版本。
- **Design generation**:设计代际(V2 = on-demand skill 论文;不是发布号)。
