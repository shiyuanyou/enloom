# 三、PM / 规格 / 记忆 / 上下文层竞品 · 中文详版

## 总览

这些工具解决"状态放在哪里、如何被下一个 session/agent 读取、如何不让旧信息污染新工作"。它们和 Enloom 的关系是：它们是竞品的外部状态层，而 Enloom 是控制面本身。

| 项目 | 解决的问题 | SSOT 类型 | 核心差异化 |
|---|---|---|---|
| Task Master AI | PRD → task graph → 开发 | tasks.json + .taskmaster/ | 依赖图 + next_task |
| CCPM | PRD → Epic → GitHub Issues → 并行开发 | GitHub Issues + .claude/epics/ | Issue 可视化 + depends_on/parallel/conflicts_with |
| Spec Kit | 模糊需求 → spec → plan → tasks → implement | .specify/ + specs/ | SDD 最成熟，分析/clarify/converge gates |
| BMAD | 上游规划 + 并行编排，不写代码 | story files + handoff-manifest.json | 所有文件冲突已知、依赖已知再派工 |
| Project Butler | 项目记忆跨 session 不丢 | CLAUDE.md + PROJECT.md + session-handoff.md | 轻量记忆栈 |
| agent-memory | 结构化、可审查的项目记忆 | .agent-memory/ Markdown + FTS5 | staged update + human review gate |
| ContextOS/Checkpoint | 跨工具 continuation | .contextos/ | 只投影不替代真值 |
| episodic-memory | 跨工具决策/发现/教训存储 | ~/.episodic-memory/ Markdown | revision chain + 行为模式机械执行 |
| DCP | 上下文明码压缩 | plugin 配置 + dcp.jsonc | 不修改历史，只改发给模型的内容 |

---

## 1. Task Master AI

**GitHub**: `eyaltoledano/claude-task-master`

### 解决的问题
把 PRD 转成 AI 可执行的任务树，提供"下一步做什么"的选择器。36 个 MCP 工具 + CLI。

### SSOT 结构
- 核心：`.taskmaster/tasks/tasks.json`
- 新版支持 tagged task lists（master、feature-branch 各有一份 tasks 数组）
- PRD 在 `.taskmaster/docs/prd.txt`
- 复杂度报告在 `.taskmaster/reports/`

### 任务依赖 / 验收
- 每个 task 有 dependencies（可跨 task 引用）
- subtask 也有 dependencies
- `next_task` 按依赖满足、priority、dependency count、ID 排序
- testStrategy 是验收主字段（文本，非强制 evidence）

### 上下文治理
- `TASK_MASTER_TOOLS=core|standard|all|custom` 控制工具暴露，减少 token
- core 只暴露 7 个工具（约 70% token 减少）
- 研究模型和 fallback 模型分离，任务生成和研究用不同 model

### 局限
- 任务完成靠 status 和 testStrategy，缺强制 evidence gate
- tasks.json 集中 mutable state，团队并行时仍有冲突
- 没有"未闭合风险"结构
- 偏任务管理，不解决跨会话记忆或上下文压缩

### 对 Enloom 启发
- `next_task`、`blocked`、`validate` 这类确定性命令值得做轻 CLI
- Machine-readable task index 可作为 project_state.md 的机器友好索引
- Tagged task lists 隔离策略对 Enloom 分支/阶段隔离有参考价值

---

## 2. CCPM

**GitHub**: `automazeio/ccpm`

### 解决的问题
给 AI agent 一个"PM brain"：idea → PRD → epic → GitHub Issues → 并行开发。核心原则："每行代码必须追溯到规格"。

### SSOT 结构
双层 SSOT：
- 本地：`.claude/prds/` + `.claude/epics/<feature>/`（Markdown 文件）
- 远端：GitHub Issues（epic + sub-issues + comments）

### 文件结构
- PRD 在 `.claude/prds/<name>.md`
- Epic 在 `.claude/epics/<feature>/epic.md`
- 每个 task 一个文件，含 depends_on、parallel、conflicts_with、AC、effort、DoD
- 启动任务前先做 analysis（并行流分析：Scope、Files、Can Start、Dependencies、Conflict Risk）
- GitHub sync 后文件重命名为 issue number

### 确定性脚本
standup、status、next、blocked 等查询由 bash scripts 扫描本地文件完成，不烧 LLM token。

### 局限
- 强依赖 GitHub、gh CLI、git worktree
- 并行安全仍依赖 agent 遵守 assigned files（无运行时隔离）
- Acceptance Criteria 和 DoD 是文本约束，缺 Enloom 式"No PASS without Evidence"
- 同一个 worktree 多 agent 会遇 shared files 冲突

### 对 Enloom 启发
- depends_on / parallel / conflicts_with 三元数据可吸取到 Ownership Table
- `<N>-analysis.md` 做并行流分析很适合 Enloom worker dispatch 前
- 确定性脚本(`next`、`blocked`、`standup`)对 Enloom CLI 层有参考价值
- GitHub Issues 可作为 Enloom 可选 projection 而非核心依赖

---

## 3. Spec Kit

**GitHub**: `github/spec-kit`

### 解决的问题
推广 Spec-Driven Development。不让 AI 直接写代码，而是先生成 spec/plan/tasks，再用 /speckit.implement 执行。

### 核心流程
constitution → specify → clarify → plan → tasks → (analyze) → implement → converge

### artifact 质量门
- Clarify: 覆盖式结构化问询，把模糊项标记为 "NEEDS CLARIFICATION"
- Checklist: 生成需求完整性、清晰度、一致性检查表
- Analyze: spec/plan/tasks 交叉一致性检查
- Converge: 实现后对照 artifact 检查剩余工作，回写 tasks.md

### 任务格式
强制 `- [ ] T001 [P] [US1] Description with file path`，`[P]` 表示可并行（不同文件 + 不依赖未完成任务）。

### 局限
- 是规格驱动工具，不是完整 PM/Issue/worker runtime
- tasks.md 是 checklist 不是强 schema 任务数据库
- 验收依赖 agent 执行 analyze/converge，缺硬 evidence gate
- 长任务里的 worker output/report/archive/risk 没有专门协议

### 对 Enloom 启发
- clarify→checklist→analyze→converge 的 gate 语言可进入 Enloom
- `NEEDS CLARIFICATION` 可成为 Registry 的 Pending Dependencies
- `[P]` 并行标记和 file path 任务格式可升级为 worker packet
- converge 对 Enloom 的 Integrate 阶段非常有价值

---

## 4. BMAD Planning & Orchestrator

**GitHub**: `aj-geddes/claude-code-bmad-skills`

### 定位
只做上游规划 + 并行编排，不写代码。产出 ready-for-dev story files + tool-agnostic handoff-manifest.json。

### 防两类冲突
1. 语义冲突：所有 agent 共享一套 architecture/API style/data model/naming/security
2. 文件冲突：stories scoped to disjoint files，分组为 waves，拓扑排序，同 wave 不碰重叠 scope

### 同步产出
- story file：AC、Dev Notes、Testing、Tasks/Subtasks、Dependency Map、Owned File/Module Scope
- AC、Dev Notes、Testing 被锁定，外部 dev tool 只能写 Dev Agent Record
- handoff-manifest.json：每个 ready story 的 path、scope、wave、dependencies

### 局限
- 明确不写代码、不跑测试、不 review diff
- Owned scope 规划错误会导致后续冲突
- Ready-for-dev 只是 planning gate ≠ 已验证实现
- 对实现后的证据、漂移、风险没有 Registry

### 对 Enloom 启发
- handoff-manifest.json 作为稳定 machine-readable manifest 值得直接采用
- Story locked sections + Dev Agent Record 可对映 Enloom worker report 设计
- Owned File/Module Scope 和 waves 可增强 Ownership Table
- Readiness PASS/CONCERNS/FAIL 与 Enloom PASS/ISSUES/FAIL 相近

---

## 5. Project Butler

**GitHub**: `JamesShi96/project-butler`

### 解决的问题
跨 session 记忆丢失：AI 助手每次忘记架构、命名约定、决策、TODO。

### 记忆栈分层（7 组件）
```
stable rules:     CLAUDE.md（人类审核过的原则）
current state:    PROJECT.md + STRUCTURE.md + UPDATE_LOG.md + DOCS.md + project-profile.json
raw facts:        log/ + TODO.md
handoff:          session-handoff.md
```

### 四个日常命令
- `/project-butler`：初始化/升级项目记忆
- `end session`：保存进度、更新 handoff
- `continue`：下个 session 恢复
- `status`：查当前状态

### 局限
- 自维护 wiki 可能被 AI 写偏
- TODO 的 dependencies 是自由文本，非可计算 DAG
- 无证据硬门槛
- 自然语言触发依赖 agent 正确识别 intent

### 对 Enloom 启发
- raw facts / current state / stable rules 三层分离
- session-handoff.md 的轻量恢复可映射为 Orient 的 continuation summary
- Candidate rules 先入池再人审 → 对映 Enloom 的 decisions 或 project invariants

---

## 6. agent-memory

**GitHub**: `xChuCx/agent-memory`

### 定位
repo-native、local、git-versioned、searchable project memory。核心承诺：Markdown 是 SSOT，SQLite 只是 shadow index，MCP 只是接口。

### 为什么特别
更新采用 staged proposal → human review diff → apply/reject，而不是 agent 安静改记忆。这是其他工具几乎不做的。

### SSOT 结构
.agent-memory/ 包含：
- index.md、conventions.md、decisions.md、pitfalls.md、modules/*.md
- local/current.<branch>.md（分支感知）
- staging/<id>/（待审核提案）
- meta/（schema + manifest + FTS5 index）

### Section 身份
用 `<!-- @id: ... -->` 做稳定锚点，heading 可改名但 ID 不变。这是长期引用和追踪的基础。

### 治理
- 高风险类别默认 staged（需人工审批）
- 低风险类别（local current、sessions）可自动 apply
- Apply 时重新检测 drift
- Secret/PII scan 写入前执行
- Section-aware git merge driver

### 局限
- 采用 BM25/FTS，不解决语义相似查询
- Review gate 引入人工成本
- 项目较新，生态小于竞品
- 不是任务调度器

### 对 Enloom 启发
- staged memory update：Registry 高风险修改先生成 proposal/diff
- Section IDs 解决 Registry 条目引用和长期追踪
- local/current.<branch>.md 分支感知对 multi-branch Enloom 部署有价值
- category-aware approval 可用于 Enloom 写入行为

---

## 7. ContextOS / Checkpoint

**GitHub**: `bkalyankumar/contextos`

### 核心洞察
"让下一个 agent 在第一分钟就有用"。不是 coding agent，是 continuity layer beneath coding agents。

### continuation pack 抽象
- 本地 `.contextos/` Markdown store 是 truth
- `checkpoint continue --for claude-code` 生成目标 agent continuation pack
- continuation pack 是投影（projection），不是替换 truth

### pack 包含
Target Agent、Current Task、Latest Handoff、Continue From Here、Files to inspect、Next action，通常 300-800 token。

### 局限
- PyPI Alpha，范围小
- 无 dependency DAG
- 无语义检索
- 需用户/agent 主动维护

### 对 Enloom 启发
- Enloom Orient 应生成 ContextOS 式 continuation pack
- `project_state.md` 是 truth，continuation pack 是 agent-shaped projection
- Secret redaction 可加入 archive/report 输出
- 用户级与项目级上下文分离

---

## 8. episodic-memory

**GitHub**: `lantisprime/episodic-memory`

### 解决的问题
多个 AI 工具（Claude Code、Cursor、Codex、OpenCode、Pi Agent、Windsurf）共享决策/发现/教训。关键是"一个工具昨天做的决定，另一个工具今天看到"。

### revision chain
决策错了不直接编辑改掉，而是标记原 episode superseded，创建 active revision。未来搜索只返回最新 active 版本。

### 两阶记忆
- Global（~/.episodic-memory/）：跨所有项目
- Local（.episodic-memory/）：项目私有

### 行为模式系统
- 11 个行为模式（bp-001 到 bp-012）
- Violation episodes 记录违规 → 重复违规可升级为机械 hook
- Plan gate、checkpoint gate、stop gate 等 hooks 可 opt-in

### 局限
- 早期项目，成熟度有限
- Hook enforcement 强依赖 Claude Code 生态
- 没有完整 PM task dependency/work packet

### 对 Enloom 启发
- Rejected Reports 可借鉴 violation episodes
- Registry 条目可采用 revision chain
- "marker 不是 truth，episode ID + validator 才是 truth"的教训
- Global/local memory 对跨项目 lesson 和项目私有 state 有参考

---

## 9. DCP Dynamic Context Pruning

**GitHub**: `Opencode-DCP/opencode-dynamic-context-pruning`

### 核心洞察
"不修改历史，只改变发给模型的投影"。Emory DyCP 论文同时提出按当前 query 动态选择相关历史 span。

### 压缩机制
- range mode：压缩连续消息 span 成摘要块
- 新压缩与旧压缩重叠时，旧摘要嵌入新摘要（避免多层稀释信息）
- Deduplication：保留重复工具调用的最新输出
- Purge Errors：默认 4 turns 后 clean 错误输入
- Protected tools/files：确保关键信息不丢失

### 上下文管理命令
/dcp context（token 使用统计）、/dcp sweep、/dcp compress [focus]、/dcp manual on|off、/dcp stats。

### 局限
- 摘要可能丢细节（代码 diff、错误栈）
- 影响 prompt cache 命中率
- 与 OpenCode 插件绑定
- 不提供持久记忆

### 对 Enloom 启发
- 区分"chat transcript pruning"和"project_state compaction"
- Compaction 借鉴 protected 列表：Registry 风险区、task packet、worker report、evidence 必须保护
- "历史不改，只改变送给模型的投影"是 Enloom archive 的核心原则
- Range compression nested summary 可用于 archive phase-history

---

## 横向对照：对 Enloom 的记忆治理启发

| 记忆层需求 | 当前 Enloom | 最强借鉴来源 | 可行性 |
|---|---|---|---|
| 跨 session 恢复 | Orient 读 project_state + Registry | ContextOS continuation pack | 高——补充 projection 层 |
| 决策追踪 | Registry 条目 | episodic-memory revision chain | 中——需要加 superseded 状态 |
| 记忆写入安全 | agent 直接改文件 | agent-memory staged update | 高——对 Registry 高风险修改做 diff 审批 |
| 上下文膨胀 | Compaction Protocol | DCP protected lists | 高——细化"绝不压缩"边界 |
| 项目记忆分层 | 所有状态在一个文件 | Project Butler 三层 + agent-memory stable IDs | 中——重构 project_state 结构 |
| 跨项目知识 | 无 | episodic-memory global + local 两层 | 低——短期非核心 |
