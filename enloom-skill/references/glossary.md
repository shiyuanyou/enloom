# Glossary

固定术语表,防止长期讨论中的概念漂移。所有 reference 和模板必须使用同一组词。

## 核心术语

| 术语 | 含义 |
|------|------|
| **Control Skill** | 按需触发的控制流程,走生命周期 6 阶段编排(triage → orient → plan → execute → verify → integrate → close)。不编码、不深读 raw。 |
| **Lifecycle Stage** | v0.3 的主架。6 阶段:0 Triage / 1 Orient / 2 Plan / 3 Execute / 4 Verify / 5 Integrate / 6 Close。操作降级为阶段内的子动作。 |
| **Task Packet** | 给 Worker 的任务契约。版本化(当前 0.2)。最小字段见 [templates/task-packet.md](templates/task-packet.md)。约束 worker **行为**(该做什么)。 |
| **Worker** | 短生命周期执行单元。可以是 sub-agent、Pi、或当前 agent 进入 worker mode。在 packet 边界内发挥智能。 |
| **Prompt Asset** | 可复用的 Worker prompt 模板(如 researcher.md / coder.md)。素材,不是常驻 agent。 |
| **Report** | Worker 给 verify 的压缩结论。固定结构对齐 Evidence Contract 四要素。 |
| **Raw Notes** | 可追溯但默认不读的过程材料。仅当证据不足 / 失败 / 高风险 / 复盘时读。 |
| **Review Budget** | verify 方允许读取的材料与成本。路由规则,不只是长度限制。 |
| **Project State** | 当前项目压缩状态(`project_state.md`)。目标 3 分钟读完,<200 行触发 compaction。含 Registry 七区段。 |
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

## 不要混用的词

- 不要把「Prompt Asset」叫「常驻 Agent」——它是素材。
- 不要把「Report」叫「输出」——输出是 `output.md`,report 是压缩结论。
- 不要把「Task Packet」叫「Prompt」——packet 是契约,prompt 是 packet 实例化后的执行输入。
- 不要把「Audit Packet」叫「Task Packet」——前者约束验证,后者约束行为。正交但不同。
- 不要把「Verdict」和 review 结论混用——Verdict(PASS/ISSUES/FAIL)是 verify 阶段的机械化判定;review 结论(accepted/needs-rework/...)是 control agent 的整合决策。
- 不要把「Registry」叫「状态」——Registry 是 project_state 的固定七区段结构,是状态里的活性真相部分。

## 版本对象

- **Task Packet Version**:契约格式版本(当前 0.2)。
- **Skill 版本**:skill 整体发布版本(v0.1 / v0.2 / v0.3 / ...)。
- **Design generation**:设计代际(V2 = on-demand skill 论文;不是发布号)。
