# art_lab .prompts 设计经验与 Prompt 控制笔记

日期：2026-06-15（初稿）｜**2026-06-29 增补**（§「06-24 后的新经验」）

这份笔记基于 `~/cloudDocs/art_lab/.prompts/README.md` 及其索引到的关键文件抽样整理，重点不是复述 art_lab 的 ingest 细节，而是提炼对 AgentOS V2 有复用价值的设计经验和 prompt 控制原则。

> **增补说明（2026-06-29）**：初稿停在 06-15，彼时 v0.3（06-24）据此内化了五块硬经验。但 art_lab 在 06-24~06-28 又沉淀了 P7/P8 与踩坑 #11–#15，这些是 v0.3 没吸收的新经验。本次增补补在文末 §「06-24 后的新经验」，并已落地为 skill v0.3.1 的新 reference `references/prompt-control.md`。后又勘蕾 `.prompts/archive/` + `.research/`，发现认识论纪律（PROBE §5.1）+ 修复计划纪律（踩坑 #8）亦未吸收，落地为 v0.3.2（prompt-control.md §4/§5）。

## 一句话结论

`art_lab/.prompts` 已经是一个真实跑过大规模任务的“文件系统控制层”原型：它用 `state.md` 做断点恢复，用模板约束 sub-agent，用 audit 做质量阀门，用 postmortem 修正流程，再用 parallel workflow 把并行风险收束到文件所有权和单线程集成上。

它给 AgentOS V2 的最大启发是：复杂任务的关键不是让主 agent 更聪明，而是把主 agent 从“长上下文执行者”改造成“状态、边界、验收、归档的控制面”。

## 我看到的方案演化

### 1. 串行 ingest：主 agent 极薄编排

`INGEST_MASTER.md` 的核心设计是主 agent 不读 raw 内容，只读 `state.md`、`batch-schedule.md`、`wiki/index.md` 这类控制信息，然后填充 `SUBAGENT_TEMPLATE.md` 派发 sub-agent。

优点：

- 主窗口上下文被压住。
- batch 可以断点恢复。
- raw 阅读和页面编译被隔离给 worker。
- 每批完成后可用 commit 和 state 记录形成进度锚点。

暴露的问题：

- 主 agent 太薄时，会只验证结构，不验证全局语义。
- sub-agent 的局部自治无法保证全局链接图一致。
- audit 如果只是“看起来检查了”，但没有机械执行命令，PASS 会变成幻觉信号。

### 2. Postmortem：形式 PASS 掩盖语义失败

`POSTMORTEM.md` 记录了最关键的一类坑：31 批完成、6 次审计通过、359 页产出后，仍然出现 16+ 死链、quote 编码不一致、重复概念页、路径推导错误、log.md 伪引用等问题。

根因不是“没有 prompt”，而是 prompt 里的约束没有变成可验证的硬门槛：

- 审计模板写了“检查 wikilink 目标文件是否存在”，但实际执行中没有强制命令证据。
- `state.md` 追踪了 batch 完成，却没有追踪链接图的 undefined symbols。
- sub-agent 返回“待激活链接”是不稳定的，缺少 registry 和后续闭环。
- 主 agent 过度信任 PASS，没有抽样验证或二次扫描。

经验：任何自动审计的 PASS 都应附带“已执行的检查”和“已知盲区”。没有命令证据的 PASS 只能算口头自评。

### 3. 修复计划：先分类，再修复

`REPAIR_PLAN.md` 没有把 16 个问题一锅端，而是先按修复策略分层：

- A 层：log.md 中的路过提及，删 wikilink。
- B 层：被内容页引用且确有价值的概念，补建概念页。
- C 层：艺术家/作品实体，补建实体页并回填双向链接。

经验：review 失败后不要直接“修所有问题”。先把问题类型化，区分删链接、补页面、改命名、建例外、更新模板。分类本身就是降低返工成本的控制动作。

### 4. 图谱收敛 v2：先验证指标，再制定计划

`GRAPH_CONVERGENCE_PLAN.md` 里有一个很重要的纠偏：v1 把 “wiki→raw wikilink 连接数”误当成 raw 集成率，得出了“94% raw 未集成”的错误结论；v2 通过独立扫描发现 raw 实际 100% 已集成，真正问题是 wiki 内部连通性不均。

经验：长任务中的指标必须先定义，再验证，再行动。错误指标会让整套计划偏航。

AgentOS 的任务包里应要求 worker 写清：

- 本任务使用什么指标。
- 指标如何计算。
- 计算命令或证据是什么。
- 哪些指标不代表什么。

### 5. 并行 workflow：并行的本质是所有权隔离

`PARALLEL_BATCH_WORKFLOW.md` 是最接近 AgentOS V2 的实战样本。它把大批量 ingest 分成：

1. Phase 0 定向：主 agent 读规则、索引、log、模板、锚点页。
2. Phase 1 并行研究：librarian/explorer lanes，不写 wiki 文件。
3. Phase 2 并行写页：fixer lanes 只创建各自独占的新文件。
4. Phase 3 单线程集成：一个 fixer 独占 index/log/backfill。
5. Phase 4 验证：主 agent + graph-scan。

关键不是“用了并行”，而是并行前把可写文件切开了：

- 多个 fixer 不碰 `wiki/index.md`。
- 多个 fixer 不碰 `wiki/log.md`。
- 多个 fixer 不改已有页面。
- 所有共享面统一交给 Phase 3 单线程集成。

经验：并行不是策略本身，而是所有权明确后的例外优化。只要有共享写入面，就必须串行。

### 6. raw-seeded：有长期价值的研究不能只留在会话里

`PARALLEL_BATCH_WORKFLOW.md` 明确反思了探索圈 Phase 1 的问题：用了 `emergent` 模式，研究包散在各 lane session 中，session 过期后不可复现。v2 起大型批次默认 `raw-seeded`，先把研究沉淀到 `.research/`，再编译成 wiki。

经验：

- 快速探索可以 emergent。
- 长期资产、外部多源、人类需审阅的任务应 raw-seeded。
- 不确定时默认 raw-seeded。

这对 AgentOS 很关键：worker 的中间结果是否需要保存，不应临时决定，而应在 task packet 里声明。

### 7. 自动化设计：自动发生的是检测，不是决策

`AUTOMATION_DESIGN.md` 的边界很清楚：fswatch、git hook、cron、pi CLI 可以自动提示 raw 新文件、自动 lint wiki commit、定期 graph-scan，但不自动 ingest、不自动修复、不替代人类策展。

经验：自动化层适合做传感器和警报器，不适合做价值判断。

AgentOS V2 也应该保持这个边界：自动 health-check 可以发现 drift，但是否扩展任务、是否建页、是否接受风险，应由 control skill review 后交给人类或明确规则决定。

## 设计经验

### 1. 文件系统可以成为控制面

`README.md` 是地图，`state.md` 是唯一真相源，模板文件是协议，`log.md` 是操作历史，archive/commit 是阶段快照。

这套方式的好处是新会话不用读完整聊天历史，只要读少数控制文件就能恢复状态。

AgentOS V2 应继续坚持“长期状态留在文件系统，不留在聊天上下文”。

### 2. state 不只记录进度，还要记录未闭合风险

art_lab 的 `state.md` 已记录 current batch、待激活链接、审计记录、修复阶段。但 postmortem 说明还缺一个 dead-link registry。

AgentOS 的 project state 不应只写“完成了什么”，还要写：

- pending outputs
- pending links / promised pages
- known exceptions
- rejected reports
- accepted-with-risk items
- next review point

真正能恢复项目的不是进度百分比，而是未闭合风险清单。

### 3. 主 agent 可以薄，但不能盲

“主 agent 不读 raw”是对的，但“主 agent 不验证语义后果”会留下系统性漏洞。

更稳的边界是：

- 主 agent 不深读执行材料。
- 主 agent 必须检查跨 worker 的全局不变量。
- 主 agent 必须抽样验证高风险结果。
- 主 agent 必须拒绝没有证据的 PASS。

薄编排器不是橡皮图章。它的价值就在于守住不变量。

### 4. 全局一致性不能外包给局部 worker

sub-agent 只能看到自己的 batch，就会自然产生命名漂移、重复概念、指向未来页面、路径猜测等问题。

因此所有跨 batch 的东西都需要 registry：

- existing pages
- promised pages
- pending links
- known exceptions
- naming aliases
- dead links

worker 可以提出建议，但不能凭局部上下文擅自定义全局命名。

### 5. 审计必须有命令证据和失败条件

“检查死链”不是一个足够强的 prompt。更好的写法是：

```markdown
必须执行以下命令，并在报告中粘贴统计结果。若命令未执行，结论必须为 FAIL。

检查项：dead link scan
命令：...
通过条件：dead_links = 0，或全部登记为 known_exception
失败条件：任何 high severity dead link 未修复且未登记
```

这能把审计从“模型说它检查了”变成“它必须留下检查痕迹”。

### 6. PASS 要携带盲区声明

自动检查永远有盲区。art_lab 的教训是结构检查无法证明语义正确。

AgentOS review report 应固定包含：

- Passed checks
- Failed checks
- Not checked
- Known blind spots
- Evidence
- Decision

没有 blind spots 的 PASS 反而可疑。

### 7. 并行之前先画文件所有权表

并行 workflow 成功的核心是所有权表，而不是 lane 数量。

AgentOS 在 plan 阶段若选择并行，必须先输出：

```markdown
| 文件/资源 | 可写者 | 阶段 | 备注 |
| --- | --- | --- | --- |
| 新文件 A-C | Lane A | Phase 2 | 独占 |
| index/log | Integrator | Phase 3 | 单线程 |
| raw/ | 无人 | 全程 | 只读 |
```

没有所有权表，不应并行 dispatch。

### 8. 承诺页面必须被验证

Promise Pages 是一个好设计：并行写页时允许 lane A 链向 lane B 将创建的页面。但它必须有收口机制。

AgentOS 可借鉴为 `Promised Outputs Registry`：

- 谁承诺创建什么。
- 哪些 worker 依赖它。
- 集成阶段是否兑现。
- 未兑现时如何降级为纯文本、待建标记或补任务。

### 9. commit 是工作流节点，不只是版本历史

探索圈 Phase 1 的反模式是 47 文件一个大 commit，后续回滚和理解阶段都变困难。v2 改成 Phase 1.5 / Phase 2 / Phase 3 / Phase 4 分段 commit。

AgentOS 不一定自动 commit，但应在 archive/report 里建议阶段快照点：

- 研究沉淀完成
- 产物创建完成
- 集成回填完成
- 验证修复完成

### 10. “插入，而非投放”是知识型任务的好原则

`EXPLORATION_CIRCLE.md` 的“插入，而非投放”很适合所有知识图谱类任务：新页面出生时就要焊接到已有锚点，不要先堆内容再事后补链。

AgentOS 对知识型 worker 可以要求：

- 先列现有锚点。
- 再列新产物如何接入锚点。
- 产物完成后验证双向关系。

## Prompt 控制原则

### 1. Prompt 是契约，不是请求

好的 worker prompt 至少包含：

```markdown
Task ID:
Mode:
Role:
Goal:
Anti Goal:
Inputs:
Existing State:
Allowed Tools:
Writable Files:
Forbidden Files:
Output Files:
Acceptance Criteria:
Validation Commands:
Review Budget:
Done Signal:
```

如果缺少 `Anti Goal`、`Writable Files`、`Forbidden Files` 或 `Validation Commands`，worker 就会自然越界。

### 2. 把“必须”和“禁止”放在 worker 最容易看到的位置

`SUBAGENT_TEMPLATE.md` 的硬约束形式是好的：先前置操作，再任务，再已有状态，再必须做/禁止做。

但脆弱规则要重复，尤其是这些：

- raw 永远只读。
- 不凭模型记忆补内容。
- 创建新页面前查 index。
- 路过提及不 wikilink。
- 共享文件不能改。
- 返回前必须验证链接。

### 3. existing_pages 要完整，anchors 可以另列

postmortem 提到一个坑：主 agent 有时只注入相关门类页面，导致 sub-agent 不知道全局已有页面，重复造概念或链接到近义空页。

更好的结构：

```markdown
Existing Pages Snapshot:
- 完整页面名列表或可检索索引

Recommended Anchors:
- 本批优先连接的 10-20 个锚点
```

完整列表用于防重复，锚点列表用于降认知负担。两者不要混成一个被主 agent 过度过滤的列表。

### 4. 审计 prompt 必须禁止“未执行也 PASS”

审计 prompt 应明确：

- 如果命令不可用，必须报告 `NOT RUN`。
- 任何关键检查 `NOT RUN`，结论不能是 PASS。
- 任何 high severity issue，结论不能是 PASS。
- Issue 数量、样本数量、命令输出必须写入报告。

这条对 AgentOS review 阶段尤其重要。

### 5. 报告格式要服务 review，而不是服务展示

sub-agent 返回摘要的结构很好：创建页面、交叉引用、待激活链接、矛盾/不确定、自评、已知弱点。

AgentOS worker report 可以进一步压缩为：

```markdown
## Result
## Files Changed
## Evidence
## Pending / Registry Updates
## Risks
## Self Check
## State Update
## Next
```

Review 方默认只读 report。只有 evidence 不足、风险高、或验收失败时，才读 output/raw notes。

### 6. 模式选择本身要写进 prompt

`emergent / raw-seeded / hybrid` 是非常好的模式分层。

AgentOS 可以泛化为：

- `emergent`：快试错，不保证中间过程可复现。
- `recorded`：关键中间材料落盘，可复查。
- `audited`：每步都有验证命令和 review gate。

大型任务默认不要 emergent。除非用户明确接受过程丢失，否则长期项目应该 recorded 或 audited。

### 7. 不要让主 agent 替 worker 想完

`INGEST_MASTER.md` 有一句很重要：主 agent 不替 sub-agent 决定建哪些页面。主 agent 给边界、输入、已有状态和验收标准，worker 在边界内发挥智能。

这正好对应 AgentOS V2 的核心：主窗口不应该把方案和实现全写完再派 worker。任务包应给“问题空间边界”，不是给逐行操作清单。

### 8. 失败重试要修改任务包，而不是只说“再试一次”

原 ingest master 有 retry_count 机制，但 postmortem 说明失败可能来自任务包边界不完整。

AgentOS 的 retry prompt 应包含：

- 上次失败的验收项。
- 失败证据。
- 本次任务包做了什么改变。
- 本次仍不允许做什么。

如果两次失败都来自同一类问题，应回到 plan/review，而不是继续 dispatch。

### 9. 自动化 prompt 默认只读

自动触发场景下 prompt 应写死：

- 只读。
- 输出问题清单。
- 不修改文件。
- 不自动修复。
- 不替代人类决策。

这能避免“提醒系统”不小心变成“无人值守写入系统”。

### 10. 质量标准要反具体、反空泛

`MASTER_PLAN.md` 的全局质量标准很值得复用：具体性、可验证性、因果解释、反事实思维，禁止模糊时间、禁止归属错误、禁止只写感受。

AgentOS prompt asset 可以内置这种“反空泛”规则：

- 不只说 A 影响 B，要解释机制。
- 不只给结论，要给证据。
- 不确定就标注不确定。
- 不把复杂问题写成单线胜利叙事。

## AgentOS V2 可以直接吸收的设计

### 1. 增加状态注册表

在 `project_state.md` 或独立 state 文件中增加：

```markdown
## Active Tasks
## Promised Outputs
## Pending Links / Dependencies
## Dead Links / Broken References
## Known Exceptions
## Accepted With Risk
## Rejected Reports
## Next Review Point
```

### 2. 增加任务模式字段

每个 task packet 加：

```markdown
Mode: emergent | recorded | audited
Intermediate Artifacts: discard | save-to-runs | save-to-raw
Human Review Required: yes | no
```

### 3. 增加并行前检查

并行 dispatch 前必须满足：

- 有文件所有权表。
- 有 promised outputs registry。
- 有单线程集成阶段。
- 有最终验证命令。
- review budget 足够读完所有报告。

### 4. 增加审计模板

审计 task packet 必须包括：

```markdown
Checks:
  - name:
    command:
    pass_condition:
    fail_condition:
    known_exceptions:

Conclusion Rules:
  - Any NOT RUN critical check => FAIL
  - Any high issue => FAIL
  - PASS must include command evidence and blind spots
```

### 5. 增加 archive 闭合标准

任务归档前检查：

- task packet 存在。
- output 存在。
- report 存在。
- validation evidence 存在。
- state update 已合并。
- registry 已更新。
- raw notes 已归档或声明丢弃。
- open risks 已转成下一步任务或 known risk。

## 反模式清单

- 一个大 prompt 让 worker 自己理解所有历史。
- 主窗口把方案想完，worker 只机械照做。
- 主窗口完全不设边界，worker 重新理解整个项目。
- 审计报告没有命令证据却写 PASS。
- 多个 worker 同时改共享文件。
- 研究成果只留在 sub-agent session。
- `state.md` 只记录完成，不记录风险。
- 自动化流程默认有写权限。
- 指标未定义就制定长期计划。
- 一次大 commit 收口多阶段工作。
- pending link 没有 registry。
- known exception 和真实 bug 混在同一类 issue 里。

## 给 AgentOS 的压缩原则

1. 主窗口只读控制文件，不吞过程材料。
2. Worker prompt 给边界和验收，不替 worker 完成思考。
3. Review 只读 report，必要时抽样证据。
4. 所有跨 worker 不变量都进 registry。
5. PASS 必须可验证，FAIL 必须可分类。
6. 并行必须先有所有权隔离。
7. 长期有价值的中间材料必须落盘。
8. 自动化负责提醒和检测，不替代决策。
9. 每个阶段都有可回滚的状态快照。
10. 复杂任务结束后，过程退场，状态留下。

---

## 06-24 后的新经验（2026-06-29 增补）

> 初稿（上文）停在 06-15。v0.3（06-24）据此内化了五块硬经验（Registry / Evidence Contract / Ownership+Promise / Compaction / Audit）。但 art_lab 在 **06-24~06-28** 又跑出三块新实战经验（README §调度原则 P7/P8 + 踩坑 #11–#15），全部晚于 v0.3，故当时未被吸收。本节是这三块的提炼，已落地为 skill **v0.3.1** 的新 reference [`agentos-workflow-skill/references/prompt-control.md`](../agentos-workflow-skill/references/prompt-control.md)。三块都属于 **prompt 构造技术**（怎么造一个能扛住交接的任务包），是五块硬经验之上的新一层。

### P7 · 路由预填：主窗口决策，worker 纯执行

**art_lab 出处**：`SUBAGENT_TEMPLATE.md` §路由预填模式；`README.md` §调度原则 P7（S5.6 B 组 BATCH_PLANS 预填模式，2026-06-28）。

**实战失败**：split/migrate 批操作派发给 worker 时只说"拆这些行、其余重定向"。worker 各自从本地 bundle 推导路由（哪行进哪个文件、重定向到哪），结果各 worker 路由相互矛盾；一个 worker 应用的全局 redirect 还吃掉了另一个 worker 结构化编辑要匹配的精确字符串，结构化编辑全 miss。

**通用机制**：批处理里有两类决策必须分开——**路由决策**（重定向目标/文件去向/拆分点）需要全局图景，**归主窗口**，预填进脚本数据结构（redirects 表 / splits 清单 / 文件去向映射）；**执行**（写 content、跑脚本、验证计数）只需 bundle，**归 worker**。预填后 worker **零路由决策**。

**适用判据**：目标是机械化可判定的（规则可预先计算，非判断题）才用。判断题（"这个概念够不够重要要拆出来"）仍归 worker bundle。

**与 Ownership Table 的关系**：互补不重叠。Ownership Table 管「**谁**能写哪个文件」（防写冲突）；路由预填管「**什么内容/去向**由谁决定」（防路由矛盾）。并行 split/migrate/merge 批处理两者都要。

### P8 · 多层派发的传话游戏失真：闭集硬约束原样内联

**art_lab 出处**：`README.md` §调度原则 P8（S5.6 B 组三层编排实测，2026-06-28）+ 踩坑 #15。

**实战失败**：编排为"主控→预读 agent→执行 agent"三层。预读 agent 返回"规则总结"，成为执行 agent 的**唯一**规则源。一个闭集硬约束（29 项白名单 + 非白名单链接的理由句格式）被总结而非复制，总结里漏了部分白名单、放松了格式。每个执行 agent 都产出缺理由句的非白名单链接，gate 全挂。

**通用机制**：约束分两类，传播方式不同——

| 约束类型 | 例子 | 如何到达最终 worker |
|---------|------|------------------|
| **闭集（可枚举）** | 白名单、允许字段名、gate 理由句格式、标签词表 | 主窗口从原文**原样复制**进执行 prompt，**绝不**再总结 |
| **开放解读** | "这页范本好在哪"、"这个 bundle 要点是什么"、incoming refs 语境归并 | 预读 agent 产**丰摘要**，总结在这里是价值不是损失 |

判别：**这条约束能否被穷举枚举？** 能 → 闭集，原样内联；不能（关于质量/关系的判断）→ 开放解读，可摘要。主窗口在多层派发里的活是**裁定+复制，非再总结**（针对闭集约束）。

**适用判据**：派发超过两层（control→…→worker）时适用，尤其是"先研究/摘要再执行"管线。预读 agent 若返回"这是规则"本身就是 smell——闭集规则不该经摘要传播。两层扁平派发（control→worker）主窗口直接写 packet，自动满足。

**与 Evidence Contract 的关系**：gate 抓下游症状（闭集约束违规），P8 防上游根因。若同一闭集违规在多个 worker 反复出现，怀疑多层失真而非 worker 粗心。

**术语防撞**：skill 里 `三阶/three-tier` 已被文件所有权占用（registry-and-compaction §2 / scheduler-rules），故此处用"**多层派发（multi-layer dispatch）**"措辞，不与所有权 tiers 冲突。

### 踩坑 #11/13/14 · 脚本执行的子串伪阳性 + 结构化改写先于全局替换

**art_lab 出处**：`README.md` 踩坑 #11（Stage 2 质量回顾，2026-06-25）/ #13（S5.6 A 组，2026-06-27）/ #14（canon_splits 顺序 bug 根因提炼，2026-06-28）。

**踩坑 #11（子串匹配伪阳性）**：生成 influence 网络的脚本用 `if token in title`（子串包含）。单字/短 token 命中几乎所有标题（`假名` 命中所有日文标题、`家` 命中几乎所有标题、长文件名多子串命中），入度从 ~22 虚高到 89，派生视图看着合理差点上线。
**机制**：脚本构建关系/链接/符号图时，**用精确解析，不用子串包含**。用精确正则（如 `\[\[([^\]]+)\]\]` 提 wikilink）或语言的符号解析器，匹配解析出的标识符。生成后**人工抽检 top-N 高度节点**，对比真实 `grep -c` 计数——degree 远超真实计数就是子串伪阳性签名。

**踩坑 #13/#14（结构化改写必须先于全局文本替换）**：批量脚本对同一批文件有两种编辑：(a) 按精确字符串的结构化改写（拆特定 canon 行、改特定 frontmatter 字段）和 (b) 全局 wikilink 文本替换（所有 `[[old]]`→`[[new]]`）。脚本先跑 (b) 再跑 (a)，全局替换吃掉了 (a) 要匹配的精确字符串，(a) 全 miss 且 fallback 到"已处理"，脚本报成功却啥也没干。
**机制**：脚本混合**结构化精确匹配**与**全局文本替换**时，**结构化改写先跑**。全局替换按定义会改变后续结构化匹配要找的字符串。替代方案：全局替换**显式跳过** derived/staging 文件（`_` 前缀，下游脚本会重生成，不丢数据）。
**通用化**：这是 #13 的根因提炼，上升为通用规则——任何"结构化精确匹配"与"全局文本替换"并存的脚本都适用。

**诊断信号**：dry-run 结构化命中数 < 预期，或 live 报"already processed/not found"且无错误 → 全局替换先吃了匹配串（#13/#14）；派生图节点 degree 远超真实引用计数 → 子串匹配短 token（#11）；多个 worker 独立产出同一闭集违规 → 多层派发失真（P8）。

**适用判据**：workflow **生成派生分析**（影响图/依赖图/交叉引用索引 → #11）或**混合编辑类型批改文件**（重构/迁移/重命名 → #13/#14）时咬人。两者在 Integrate 阶段（Stage 5）和审计脚本里常见。

### 落地与盲区

- **落地**：上述三块已写成 [`agentos-workflow-skill/references/prompt-control.md`](../agentos-workflow-skill/references/prompt-control.md)（§1-3：Route Pre-fill / Multi-Layer Dispatch Distortion / Script-Execution Pitfalls），并在 scheduler-rules / evidence-contract / SKILL.md / task-packet 加交叉链接。属 skill v0.3.1。
- **诚实盲区**：这三块都来自 art_lab 单一领域（wiki ingest）。泛化判断是推断，未经第二领域验证。真实环境测试时重点看：这些机制在非 wiki 类任务（代码迁移/数据处理）是否真适用，还是需再调措辞。

---

### 来自 `.research/` 的认识论纪律（v0.3.2，2026-06-29 增补）

勘蕾 `.prompts/archive/`（冻结蓝图）+ `.research/`（探问工作区）后判定：archive 的经验（断点恢复/极薄编排/partial-completion 拒绝）已在 06-15 被 v0.3 吸收成 Registry/Compaction/Evidence Contract；`S5_6_EXECUTION_MANUAL` 字面就是 v0.3.1 的 P7/P8/脚本坑（验证了 v0.3.1 提取对了）。**唯一新经验来自 PROBE_FRAMEWORK §5.1**——认识论纪律，v0.3/v0.3.1 都未覆盖。

**§4 · Epistemic Discipline — 事实与 AI 综合的强制分离**

**art_lab 出处**：`PROBE_FRAMEWORK.md` §5.1（2026-06-16 教训）+ `.research/README.md` seed/evidence 生命周期。

**实战失败**：一轮 probe 把 8 个研究种子全写成**封闭结论**，大量 AI 综合/哲学跳跃/自造术语伪装成来源事实（标 `confidence: high`），提前关闭了本该开放的问题。

**通用机制**：研究/探索 worker 产出的是**被诠释的发现**（非可机械验证的产物），模型倾向把三类认识论上不同的东西混进同一个"结论"——
- **事实**（来源直接陈述，可原样引用）→ 进证据记录，零综合
- **诠释/外推**（比较/因果/哲学跳跃/自造术语）→ 显式降级为"假设（未验证）"，不可当事实引用下游
- **开放问题**（材料暴露的张力/缺口）→ 探索性产出的**重心**，保持开放不被过早答案封闭

**信号词判别**（最快抓"综合伪装成事实"的方式）：出现"本质上是/殊途同归/精确对位/收敛于/源于…而非"→ 判综合，降级；来源未出现的词（AI 自造术语）→ 降级；拿不准 → 偏保守降级。重点警惕：哲学跳跃（经验命题跳到本体论）、共现推成因果、范畴滑移。

**适用判据**：worker 产出是**被诠释的研究/探索**时适用（researcher 角色是典型）。不适用于 coder（产物编译过 gate，事实/诠释不紧张）。

**与 Evidence Contract 的关系**：Evidence Contract 管"验证声明带不带命令证据"，是下游 gate；认识论纪律是上游——管研究素材**本身**被记录前的认识论诚实。一份过 evidence gate 的研究报告仍可能认识论 sloppy（"事实"里偷塞 AI 综合）。

**§5 · Repair-Plan Discipline — 修复计划须验证自身的问题声明**

**art_lab 出处**：`README.md` 踩坑 #8（EXPLORATION_CIRCLE_REPAIR review，2026-06-24）。

**实战失败**：一份修复计划列了一串"缺陷"。执行时发现好几个缺陷**根本不存在**——一条声称某概念被错分类，实际它一直在正确区段（行号凭记忆写错）；计划的验证命令用了宿主 BSD grep 不支持的 `grep -P`，本就会报错。计划自信满满（编号项 + 严重度 + 修复步骤），但**问题声明和验证命令都没对现实重跑**。

**通用机制**：修复/补救/审计修复计划**本身是一种断言**，受和它批评的工作同样的证据规则约束——
- 每个**问题声明**（行号/区段/路径/"X 被错分为 Y"）在动手前必须**对当前文件重验**。记忆和推断不是可接受的缺陷目标来源。
- 计划提出的每个**验证命令**必须在目标环境**实跑**，不能假设它能工作。
- 问题声明复现不了 → 从计划**划掉**，别修一个不存在的缺陷（修幻影问题浪费工还可能引入真缺陷）。

**适用判据**：control agent 或 worker 产出**修复计划/补救清单/审计修复提案**时适用。不适用于全新构建（还没声称缺陷）或 agent 边干边验的简单有界修复。

**与 Evidence Contract / §4 的关系**：这是 Evidence Contract 应用到**计划本身**（计划是断言，断言要证据）。与 §4 配对：§4 说研究产出要分事实/综合；§5 说修复计划要验证它的问题声明是事实（非凭记忆的幻影）才动手。

### v0.3.2 落地

- §4/§5 写进 [`prompt-control.md`](../agentos-workflow-skill/references/prompt-control.md)（现 5 节），researcher.md `## How to work` 加交叉链接到 §4。
- 验证：quick_validate PASS + content-marker（5 节齐全 / epistemic 6 marker / repair-plan 7 marker / researcher 1 链接）+ 重新打包安装（25 文件，diff 仅 evals/）。
- **诚实盲区（v0.3.2）**：认识论纪律和修复计划纪律都来自 art_lab 知识型任务（wiki/研究），在纯工程任务（代码/迁移）里事实/推论界限清晰，这两块偏弱。真实环境测试重点看知识型/调研型长任务是否命中。
