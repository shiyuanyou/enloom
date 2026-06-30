# Enloom · 进度

本文只讲**进度、状态、下一步**。项目是什么、怎么用、目录结构见 [README.md](README.md)（SSOT）。设计推导见 [design/](design/)。

> 一句话定位：Enloom 是轻量级控制面 workflow skill——A methodology for orchestrating complex AI work。给 agent 处理太大、状态太多、单次上下文装不下的长任务。只给文件协议 + 决策纪律，**不给** scheduler / CLI / model resolver / 自动 worker runtime。

## 当前状态

**v0.4 进行中**（2026-06-30）。**双腿功能改动**,均来自实跑诊断:

1. **项目级命名空间** —— `.enloom/` 从单一全局状态改为 `task_board.md` 入口表 + 每项目一目录(`<created>-<project>/`)。同名项目第二次进入复用目录(时间戳=创建日,固定)。解决"第二次进来路径不一致、跨任务状态全挤一个文件"。
2. **落盘时序契约** —— 每个生命周期 Stage 加入口/出口**闸门**(文件存在性检查)+ 主流程↔worker 握手时序图,逼 worker 产出落盘成文件而非只留上下文。**铁律 2/5 机械化**(dispatch 前 task.md 必存 / archive 前 Review Result 必填),对齐铁律 4 标准。根因:art_lab 实跑 `.enloom/tasks runs` 全空,90 分钟工作的 task packet/worker report 从未落盘。

落地范围:新增 `landing-contract.md` + `task-board` 模板;改 SKILL.md(File Protocol 新树 + Landing Discipline 段)/ workflow-steps(7 Stage 全闸门 + Orient task_board 定位 + health-check 硬闸门升级)/ glossary(4 术语)/ phase-plan(落盘 gate)/ registry+archive(项目目录 + Review Result 闸门)/ eval-guide(项目前缀)。**用 Enloom 自己的生命周期跑这次开发**(dogfood),落在新结构 `.enloom/2026-06-30-enloom-v04/`——且 **P1 的 6 任务 task.md/output.md/report.md 全真实落盘**,成为落盘契约的首个活样本(正是 art_lab 缺口的反面)。P1 契约层 + P2 引用层完成,待 P3 产物层(README/PROGRESS/冻结确认/全局重装)。

- 设计输入：[`design/v0.4-project-namespace-spec.md`](design/v0.4-project-namespace-spec.md)（brainstorming 9 决策逐项确认）
- 旧 `.enloom/project_state.md`(v0.3.3 单状态 dogfood)→ **冻结保留**,不迁移,作历史证据

**v0.3.3 已归档**（2026-06-29）。**纯重命名 + 产品化,零功能改动**：把产品从 `AgentOS / agentos-workflow` 重命名为 **Enloom**。三层命名统一——开发仓库 `agentos/` → `enloom/`、skill 内部 `name` `agentos-workflow` → `enloom`、skill 产出目录 `AgentOS/` → `.enloom/`（隐藏,用户项目里默认看不到）、skill 源包目录 `agentos-workflow-skill/` → `enloom-skill/`。**用 Enloom 自己的生命周期 6 阶段跑这次重命名**（dogfood）,过程留痕在 `.enloom/`。Verify: 12 skill 源包文件 name/desc/路径全替换、`AgentOS`→`Enloom` / 分类结果码 `agentos`→`enloom` / 路径 `AgentOS/`→`.enloom/`,README 重写为中英双语产品页。全局重装已完成:`~/.agents/skills/` 删旧 `agentos-workflow/`、装新 `enloom/`(25 文件,evals/ 按设计剥离,quick_validate PASS,源/装逐字节一致)。**trigger-eval re-run 完成**(`.enloom/runs/trigger-eval/run-002.md`):新 description 20/20(train 12/12 + test 8/8,description 零修改即通过,near-miss 7/7 全对),Enloom 版新基线确立;与 run-001 旧基线一致,验证 rename 在 trigger 层面确为零功能改动。

- 旧 `AgentOS/` 自举快照（含大量旧名引用）→ **冻结保留**,不改,作 v0.3 历史快照

**v0.3 已归档**（2026-06-24）。本次是**自举开发**——用 v0.3 自己的生命周期 6 阶段（Triage→Orient→Plan→Execute→Verify→Integrate→Close）组织 v0.3 实现，过程留痕在 `AgentOS/`。把 SKILL.md 从操作菜单重写为生命周期阶段驱动，并把 art_lab 五块硬经验（Registry / Evidence Contract / Ownership+Promise / Compaction / Audit）内化为通用文件协议。Verify：validation.md 结构校验 PASS + 17 文件 content-marker audit PASS。**后续**：eval-guide 去工具绑定（适配 opencode/pi 环境，`0c27c19`）+ **Path B 独立盲测 9/9 case 全 PASS**（干净 opencode 会话，fresh context per case，非 self-graded）。

- 设计输入：[`design/v0.3-lifecycle-spec.md`](design/v0.3-lifecycle-spec.md)（brainstorming 逐节确认）
- 自举工作区：[`AgentOS/`](AgentOS/)（project_state + decisions D1–D9 + runs/v03/verify-report）
- v0.3 诚实盲区：self-graded audit（content-marker 确认内容存在不保证质量）+ 单 agent 隔离靠字段纪律（review/verify 维度 + serial 默认已由 Path B 9/9 case 独立盲跑验证通过）

**v0.3.1 已归档**（2026-06-29）。skill body 增量补丁——吸收 art_lab 在 v0.3(06-24)之后沉淀的三块 prompt-control 新经验（P7 路由预填 / P8 多层派发传话失真 / 脚本坑 #11·13·14，均为 06-24~06-28，v0.3 未吸收）。落地为**新 reference** [`prompt-control.md`](agentos-workflow-skill/references/prompt-control.md)（三节，real-failure→mechanism→when-to-apply 体）+ 4 处交叉链接（scheduler-rules / evidence-contract / SKILL.md / task-packet）。Verify：quick_validate PASS + content-marker audit PASS（3 节齐全 / 4 链接到位 / 术语防撞 multi-layer≠three-tier）。重新打包安装到全局（25 文件，+1 prompt-control.md）。**不动 description**（trigger eval 20/20 仍有效，trigger 行为不变）。

- 设计输入：[`design/art-lab-prompt-control-lessons.md`](design/art-lab-prompt-control-lessons.md) §「06-24 后的新经验」（设计文档从 06-15 增补到 06-29）
- v0.3.1 诚实盲区：三块经验都来自 art_lab 单一领域（wiki ingest），泛化判断未经第二领域验证——真实环境测试重点看非 wiki 任务（代码迁移/数据处理）是否适用

**v0.3.2 已归档**（2026-06-29）。继 v0.3.1 后勘蕾 `.prompts/archive/` + `.research/`，确认 archive（冻结蓝图）经验已被 v0.3 吸收、S5_6 手册验证了 v0.3.1 提取对了，**唯一新经验来自 PROBE §5.1 + 踩坑 #8**：认识论纪律（fact vs AI-synthesis 强制分离 + 信号词判别）+ 修复计划纪律（计划须验证自身问题声明）。落地为 `prompt-control.md` 加 §4/§5（现 5 节）+ researcher.md 加交叉链接到 §4。Verify：quick_validate PASS + content-marker PASS（5 节齐全 / epistemic 6 / repair-plan 7 / researcher 1 链接）+ 重新打包安装（25 文件，diff 仅 evals/）。**不动 description**（trigger eval 仍有效）。

- 设计输入：[`design/art-lab-prompt-control-lessons.md`](design/art-lab-prompt-control-lessons.md) §「来自 .research/ 的认识论纪律」
- v0.3.2 诚实盲区：两块都来自 art_lab 知识型任务（wiki/研究），纯工程任务（代码/迁移）里事实/推论界限清晰、这两块偏弱——真实环境测试重点看知识型/调研型长任务是否命中

**v0.2 已归档**（2026-06-17）。用 v0.1 自己的协议(triage→plan→make-prompt→review→archive→health-check)组织 v0.2 开发。补齐 eval 套件、5 个 references、3 个 Worker 角色资产，并用 skill-creator 跑闭环（`quick_validate.py` pass + 手工 eval 6/6 case）。仍项目本地，未全局安装。

- v0.2 协议复盘：见下方「已完成（v0.2）」末尾 Protocol Retrospective

**v0.1 已归档**（2026-06-15）。纯文档 skill 初版完成，**零可执行代码**——"代码"是 `SKILL.md` + 5 个模板。静态校验通过，手工 trial 覆盖 direct / agentos / needs-rework 三类路径。

- 验收报告：[agentos-workflow-skill/report.md](agentos-workflow-skill/report.md)（result: `accepted`）

## 已完成（v0.3）

**设计（Phase A）**：
- [x] `design/v0.3-lifecycle-spec.md`——生命周期重组 + art_lab 经验深度内化的完整设计规格，brainstorming 逐节确认（5 决策 + 内容组织 + 重组深度）

**Skill 包变动（Phase B，17 文件，对照 spec 6a 清单）**：
- [x] **重写** `SKILL.md` + `references/workflow-steps.md`——操作菜单 → 生命周期 6 阶段（合并 Make Packet+Dispatch 为 Execute），操作降级为子动作，五铁律保留并升级 3/4/5
- [x] **新增** `references/evidence-contract.md`——四要素（Checks Run/Evidence/Not Checked/Known Blind Spots）+ "无证据不得 PASS"硬约束 + 三态 verdict（PASS/ISSUES/FAIL）
- [x] **新增** `references/registry-and-compaction.md`——Registry 七区段 + Ownership 三阶模型 + Promise Registry + Compaction 四步（状态治理汇一份 reference）
- [x] **新增** `references/templates/audit-task-packet.md`——5 元组 check_item schema（id/command/pass/fail/named_list）
- [x] **新增** `references/examples/art-lab-worked-example.md`——art_lab 领域命令作 worked example（check_item 填空示范），不进主干
- [x] **扩展** 4 templates：project-state（7 区段骨架 + Archived Phases）/ phase-plan（Ownership Table + Promise draft）/ task-packet（Required Verification 对齐 check_item + Forbidden 显式枚举）/ worker-report（对齐 Evidence Contract 四要素）
- [x] **更新** `glossary.md`（加 Lifecycle Stage/Ownership Table/Promise Registry/Evidence Contract/Audit Packet/Compaction/check_item/Verdict）
- [x] **更新** 4 references：trigger-contract（生命周期入口）/ scheduler-rules（三阶所有权模型）/ review-checklist（三态 verdict + Registry 更新义务）/ archive-policy（registry 风险区段已处理 + compaction 触发检查）
- [x] **更新** `evals/evals.json`——+3 case（7 audit 缺证据→FAIL / 8 promise 未兑现→登记 broken / 9 compaction 误删→回滚），共 9 case
- [x] **微调** 3 prompt-assets（researcher/coder/reviewer 对齐生命周期阶段 + Evidence Contract）

**验证**：
- [x] validation.md 结构校验（bash impl）——SKILL.md frontmatter PASS（name=agentos-workflow, desc 599 字符）
- [x] spec 6a content-marker audit——17/17 文件 PASS
- [x] evals.json JSON 合法 + 9 case

### Protocol Retrospective（v0.3 自举反馈）

v0.3 是首次用生命周期 6 阶段（而非 v0.2 的 6 操作）跑真实开发：

| 观察 | 反馈 |
|------|------|
| 生命周期 vs 操作菜单 | 生命周期时序结构更贴合长任务真实流程；Orient 必扫 Registry 风险区段的纪律有用（本次 Pending Dependencies 指导了执行顺序：glossary 先于 workflow-steps，references 先于 templates）|
| Evidence Contract 自指 | 写 verify-report 时四要素（Checks Run/Evidence/Not Checked/Known Blind Spots）自然套用，Not Checked 段诚实记录了"单 agent 隔离未独立验证"——纪律可用 |
| Ownership Table 声明式 | 单 agent 环境下表是纪律声明非执行约束，但填表过程本身澄清了"谁改哪个文件"，避免误碰 |
| Compaction 未触发 | 本次 project_state 未超 200 行，Compaction Protocol 未实战。需更大任务验证防错规则 |
| content-marker audit 局限 | marker 确认内容存在不保证质量；独立 subagent eval 仍是 deferred 项 |

详见 `AgentOS/runs/v03/verify-report.md`。

## 已完成（v0.2）

**自举工作区**（`AgentOS/`，v0.2 新增）：
- [x] `project_state.md` + `decisions.md`（D1–D5）+ 6 个 task packet（T001–T006）+ 6 个 run（含 report + 证据）
- [x] health-check 抓到并修复一个 drift（T001 report 漏 Review Result 段）

**Skill 包新增**（`agentos-workflow-skill/`）：
- [x] `references/trigger-contract.md`——Use / Do NOT use / Ambiguous，独立成设计对象
- [x] `references/glossary.md`——固定术语表，防概念漂移
- [x] `references/scheduler-rules.md`——串/并行判断表 + 单 agent 环境现实
- [x] `references/review-checklist.md`——review gate 清单
- [x] `references/archive-policy.md`——闭合标准机械化
- [x] `references/eval-guide.md`——手工（Path A）/ 自动（Path B）两条 eval 路径
- [x] `prompt-assets/researcher.md` · `coder.md` · `reviewer.md`——3 个 Worker 角色素材（带 metadata + 权限分级）
- [x] `evals/evals.json`——6 case eval 套件（覆盖 ref-notes:428-436 全部场景）
- [x] `SKILL.md`——加 References 段，集中指向所有 reference

**skill-creator 闭环**（用户指定的最终落地）：
- [x] `quick_validate.py` 对 `agentos-workflow-skill` 返回 `Skill is valid!`（exit 0）
- [x] 手工 eval 6/6 case pass（self-graded，已诚实标注局限），证据在 `AgentOS/runs/T005/eval-results.md`

### Protocol Retrospective（v0.1 协议首个真实使用反馈）

对照 PROGRESS 旧「下一步可调点」，本次自举观察：

| 可调点 | 观察 | 建议 |
|--------|------|------|
| Trigger 过度触发? | 不过度（本次正确进入）。但 near-miss 未独立验证 | trigger 准确性列为 v0.3 最高优先 eval |
| Task Packet 太重? | 偏重，简单 task 我自行裁剪了字段 | make-prompt 加一句「按复杂度裁剪，Goal/Anti Goal/Output/Acceptance/Done Signal 不可省」 |
| Review Budget 省上下文? | 成立，全程只读 report | — |
| Worker 边界内发挥智能? | 单 agent 环境靠 packet 字段纪律，非执行隔离 | protocol-notes 记录此限制 |
| health-check 有效? | 有效，抓到真实 drift | — |

详见 `AgentOS/runs/T005/report.md` 的 Protocol Retrospective 段。

## 已完成（v0.1）

**Skill 包**（`agentos-workflow-skill/`）：
- [x] `SKILL.md`——入口，`name: agentos-workflow`，定义 6 个操作 + 推荐文件协议 + review 姿态
- [x] `references/workflow-steps.md`——完整 Step 0–7 工作流 + 五条铁律 + 失败协议 + health-check v0
- [x] `references/examples/triage-decision-tree.md`——triage 决策树 + 8 个 worked examples（≥2 trigger 规则）
- [x] `references/examples/manual-trial.md`——3 项手工 trial + 结果记录表
- [x] `references/templates/`——5 个填空契约模板：`phase-plan` · `task-packet` · `worker-report` · `project-state` · `archive-entry`

**6 个控制操作**：`triage` · `plan` · `make-prompt` · `review` · `archive` · `health-check`，每个带 gate。

**验证**：

| 项 | 结果 | 证据 |
|------|------|------|
| `quick_validate.py` 静态校验 | pass | frontmatter 合法，SKILL.md 短、细节外指 references/ |
| 自动化关键词边界检查 | pass | `scheduler/CLI/script/auto/自动/调度/模型选择` 等命中仅为边界声明，非功能承诺 |
| 手工 trial：Direct Bypass | pass（2026-06-15） | 单个小改动，triage 返回 `direct`，不创建 AgentOS 文件 |
| 手工 trial：AgentOS Entry | pass（2026-06-15） | 长期资产 + task packets + review + state + archive，triage 返回 `agentos` |
| 手工 trial：Evidence Gate | pass（2026-06-15） | verification 未跑、evidence 不足，review 返回 `needs-rework` |

## 明确推迟 / 未做

| 项 | 状态 | 说明 |
|------|------|------|
| 自动 eval（独立 subagent 盲跑） | ✅ **完成** | eval-guide Path B 已去工具绑定（`0c27c19`）；9/9 case Path B 独立盲跑全 PASS（opencode `run` fresh context per case, 非 self-graded）。case 1-3 triage 维度 + case 4 serial 默认 + case 5-9 review/verify 维度（evidence/promise/compaction 三条新硬约束）全判对。结果见 `AgentOS/runs/path-b-eval/eval-results-cases-4-9.md` |
| 全局安装到 `~/.agents/skills/` | ✅ **已安装**（2026-06-29） | v0.2 显式放弃的理由是"trigger 边界 near-miss 未独立验证前不 promote"——该前提已被 20-query trigger eval（near-miss 全判对）解除。用 skill-creator `package_skill.py` 打包成 `.skill`(自动剥离根级 evals/),解压安装到 `~/.agents/skills/agentos-workflow/`(24 文件,SKILL.md 为根,frontmatter name=agentos-workflow)。安装副本 `quick_validate` PASS,与源 diff 仅 evals/ 之差。**待真实环境测试**(原生 trigger 集成验证是 description-only unit test 未覆盖的盲区)。打包产物:`AgentOS/dist/agentos-workflow-skill.skill` |
| Worker 角色资产 `architect.md` / `tester.md` | 仍推迟 | v0.2 写了 researcher/coder/reviewer 三核心；architect/tester 待措辞沉淀。指向 v0.3+ |
| description-optimization（20-query trigger eval） | ✅ **完成** | 20-query trigger set 实跑全 PASS（`AgentOS/runs/trigger-eval/run-001.md`）：train 12/12 + test 8/8，description 零修改即通过（near-miss discriminator 全判对）。description-only fresh-context 盲跑（opencode `run --pure`，deepseek-v4-pro）。详见下文「下一步」与 run-001 |
| CLI / scheduler / model resolver / 自动 worker runtime | **明确不做** | skill 只给协议 + 纪律。Non-Goals |

## 下一步（v0.4 方向）

**主路径**：9/9 case Path B 独立盲跑全 PASS ✅ **+ 20-query trigger eval 全 PASS ✅**。两条独立维度均已验证：Path B 测加载后决策对不对，trigger eval 测只看 description 会不会正确调用。description-optimization 实跑结果（`AgentOS/runs/trigger-eval/run-001.md`）：train 12/12 + test 8/8，**description 零修改即通过**——当前 description 的 discriminator 已足够,near-miss（architect/orchestrate/coordinate/deep-dive/plan refactor/verify）全判对,无需调优,也因此无过拟合风险。

**来自 v0.3 自举的协议可调点**（详见上方 Protocol Retrospective）：
- Compaction Protocol 未实战（本次 project_state 未超阈值）——需更大任务验证防错规则（风险区段条目数不减少）
- content-marker audit 是 self-graded 上界——已部分解除：review/verify 维度的独立盲跑（case 5-9）在 Path B 9/9 PASS 中完成
- v0.2 遗留可调点（make-prompt 字段裁剪说明、单 agent 隔离 protocol-notes）在 v0.3 已通过 Evidence Contract 的 Not Checked 要求部分落地

## 已知风险

- ~~Trigger/决策准确性~~ **已解除**——9/9 case Path B 独立盲跑全 PASS（非 self-graded,测加载后决策）。triage 维度（1-3）+ serial 默认（4）+ review/verify 维度（5-9）全判对
- ~~Description trigger 准确性~~ **已解除**——20-query trigger eval 全 PASS（train 12/12 + test 8/8,description-only fresh-context 盲跑,测 description 触发）。near-miss discriminator 全判对,description 零修改通过。**残留盲区**:单模型（deepseek-v4-pro）验证,未跨模型;description-only 是 description 字符串的 unit test,非 host 原生 trigger 集成测试
- **Compaction Protocol 未实战**——防错规则（风险区段条目数不减少）只在文档层定义，未经真实压缩验证
- ~~项目本地、未全局安装~~ **已翻转**——已全局安装到 `~/.agents/skills/agentos-workflow/`(2026-06-29)。**残留盲区**:原生 trigger 集成(host 如何发现并加载 skill)未经测试,description-only eval 是 description 字符串的 unit test,非 host 集成测试;单模型(deepseek-v4-pro)未跨模型
- **architect / tester 角色资产缺失**——三核心角色已就位（v0.3 对齐生命周期），待沉淀

## 时间线

| 日期 | commit | 含义 |
|------|--------|------|
| ~2026-06 初 | `32894c3` | 设计诞生：AgentOS V2 设计思路 + 四种退化现象分析 |
| 2026-06-15 | `ab45e1c` | 补外部 skill 调研（skill-reference-notes）+ 本次测试 |
| 2026-06-15 | `8406c80` | v0.1 完成归档（P6 T6.2 accepted） |
| 2026-06-17 | `4608a63` | NewIdeas 转为多项目孵化器，内容搬到顶层 `agentos/` |
| 2026-06-17 | `eee7763` | 补根级 AGENTS.md |
| 2026-06-17 | `e473679` | v0.2 自举开发：eval 套件 + references + prompt-assets + skill-creator 闭环 |
| 2026-06-17 | `d9b9818` | 新增 validation.md：语言无关的 skill 校验规范（bash/node/python，agent 按环境动态选） |
| 2026-06-24 | `b2b9f6e` | v0.3 设计规格：生命周期重组 + art_lab 经验深度内化（spec，待实现） |
| 2026-06-24 | `12b7eea` | v0.3 实现：生命周期主架重写 + 五块经验内化，17 文件变动，自举 Verify PASS |
| 2026-06-25 | `0c27c19` | eval-guide/validation 去工具绑定：`claude -p` 写死 → opencode/pi/Claude Code 任选，适配实际开发环境 |
| 2026-06-25 | （本次，未提交） | Path B 独立盲测 triage 维度 3/9 case PASS（干净 opencode 会话，非 self-graded） |
| 2026-06-25 | `680a1c5` | Path B 独立盲测 case 4-9 全部 PASS（6/6），9/9 case 全 PASS + PROGRESS 漂移修复 |
| 2026-06-25 | `12315d9` | description-optimization：20-query trigger eval set 就绪（trigger-evals.json + eval-guide Trigger Eval 段 + results-template），待实跑迭代 |
| 2026-06-29 | （本次，待提交） | description-optimization 实跑全 PASS：train 12/12 + test 8/8，description 零修改通过（description-only fresh-context 盲跑，opencode --pure，deepseek-v4-pro） |
| 2026-06-29 | （本次，待提交） | 全局安装：package_skill.py 打包 → 解压到 ~/.agents/skills/agentos-workflow/（24 文件，evals/ 已剥离），安装副本 quick_validate PASS。待真实环境测试 |
| 2026-06-29 | （本次，待提交） | v0.3.1：吸收 art_lab 06-24 后 prompt-control 新经验（P7/P8/脚本坑）→ 新 reference prompt-control.md + 4 交叉链接，重新打包安装（25 文件）。不动 description |
| 2026-06-29 | （本次，待提交） | v0.3.2：勘蕾 archive/.research，吸收认识论纪律（PROBE §5.1）+ 修复计划纪律（踩坑 #8）→ prompt-control.md 加 §4/§5 + researcher.md 链接，重新打包安装。不动 description |

自 2026-06-29 trigger eval PASS + 全局安装 + v0.3.1/v0.3.2 起，skill 进入真实环境测试阶段。

## 不做的事

引用 `design/design-summary.md` 与 `design/skill-workflow-draft.md` 的 Non-Goals：

- 不做常驻后台——需要时介入，完成后退场
- 不做自动模型选择
- 不做复杂 DAG 引擎
- 不做无限 sub-agent 嵌套
- 不做全自动修复（health-check 只报告 + 提最小下一步，不自动改）
- 不强制所有任务都进入 AgentOS（能直接做就直接做）

## 相关文档

| 文档 | 是什么 |
|------|--------|
| [README.md](README.md) | 项目 SSOT——是什么、目录、子动作清单、v0.3/v0.1 验收历史 |
| [enloom-skill/SKILL.md](enloom-skill/SKILL.md) | 可运行 skill 入口，生命周期 6 阶段 + 文件协议 |
| [enloom-skill/references/workflow-steps.md](enloom-skill/references/workflow-steps.md) | 生命周期 6 阶段完整工作流 + 五条铁律（v0.3 重写） |
| [enloom-skill/references/evidence-contract.md](enloom-skill/references/evidence-contract.md) | 证据契约四要素 + 三态 verdict（v0.3 新增） |
| [enloom-skill/references/registry-and-compaction.md](enloom-skill/references/registry-and-compaction.md) | Registry/Ownership/Promise/Compaction 状态治理（v0.3 新增） |
| [enloom-skill/report.md](enloom-skill/report.md) | T6.2 验收报告（v0.1 历史，accepted） |
| [design/v0.3-lifecycle-spec.md](design/v0.3-lifecycle-spec.md) | v0.3 设计规格：生命周期重组 + art_lab 经验深度内化 |
| [design/design-summary.md](design/design-summary.md) | V1→V2 设计演化、四种退化现象、四层架构（设计主干，899 行） |
| [design/skill-workflow-draft.md](design/skill-workflow-draft.md) | Skill Workflow v0.1 草案、五铁律、先不做的事、可调点 |
| [design/art-lab-prompt-control-lessons.md](design/art-lab-prompt-control-lessons.md) | 从 `art_lab/.prompts` 提炼的 prompt 控制经验 |
| [design/skill-reference-notes.md](design/skill-reference-notes.md) | 外部 skill 生态调研（skill-creator / llm-wiki 等） |
