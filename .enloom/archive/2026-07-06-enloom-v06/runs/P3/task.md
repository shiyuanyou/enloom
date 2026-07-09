# Task Packet: P3

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

收尾 v0.6 两处清理:① archive-entry 模板 Raw Material Handling 段加锁注释;② art-lab / manual-trial 的 "the agent" 措辞按 P1 角色基准处理(含 art-lab 的历史描述判断)。三处全落 `enloom-skill/` 源 + 同步副本。

## Anti Goal

- 不动 art-lab 的领域特定内容(dead-link scan / quote-encoding scan / reference count 等 wiki-domain only 命令)。
- 不重写 art-lab 叙事结构,只处理 "the agent" + 必要注释。
- 不碰 design/、不碰核心 references(P0-P2 闭合文件)、不碰 SKILL.md。
- 不引入新机制——纯清理,零结构改动。
- 不篡改 art-lab 的历史描述(它是真实外部任务的记录)。

## Inputs

- **将被改的文件**(先 Read 再改):
  - `enloom-skill/references/templates/archive-entry.md`(38 行,Raw Material Handling 段在 :34-36,现为空模板段)
  - `enloom-skill/references/examples/art-lab-worked-example.md`(`the agent` 在 :9,"In the original task... the agent could not recover"——**指 art_lab 原任务的执行者,非 enloom 角色**)
  - `enloom-skill/references/examples/manual-trial.md`(`The agent` 在 :16/:28/:29/:30——这些是 **enloom triage 后的行为描述**,应改 control agent)
- **参考**(只读):P1 建立的角色基准——control agent(编排)/ worker(执行),禁用暧昧的 "the agent"。见 archive/phase-2-entry.md Decisions Updated。

## Existing State

- P1 已把核心 skill 的 "the agent" 硬化成 control agent / worker。art-lab / manual-trial 是 examples/,P1 显式推迟到 P3。
- archive-entry 模板的 Raw Material Handling 段是空的,无说明为什么存在、该填什么。phase-1/2/3 的 archive-entry 都填了(raw 在 sub-agent 上下文不进主窗口),但模板本身没锁注释,新用户/worker 可能误填 raw 进主窗口。

## Allowed Tools

Read / Edit / Write / Bash(cp / diff / grep)。

## Writable Files

源仓库 `enloom-skill/`:
1. `enloom-skill/references/templates/archive-entry.md`
2. `enloom-skill/references/examples/art-lab-worked-example.md`
3. `enloom-skill/references/examples/manual-trial.md`

安装副本 `~/.agents/skills/enloom/`(同步,3 个对应文件)。

## Forbidden Files

- `.enloom/`、`.clear-mind/`、`design/`(只读)
- `enloom-skill/` 下非本任务 3 文件的所有其他文件
- 根 README.md / PROGRESS.md

## Output Files

- 源 3 文件(改完)+ 副本 3 文件(同步)
- `runs/P3/output.md`(逐文件 old→new)
- `runs/P3/report.md`(Evidence Contract 四要素)

## Acceptance Criteria

### ① archive-entry Raw Material Handling 锁注释
- 在 `## Raw Material Handling` 段(:34)下方加锁注释(blockquote 或 > 风格,对齐既有模板的注释风格如 phase-plan.md 的 `>` 段)。内容:
  - **该段记录"raw material 如何被隔离",不是"粘贴 raw material 进来"**——raw Edit 调用历史 / 完整 diff / sub-agent 上下文里的过程**不复制进本段或主窗口**;control agent 只读 worker 的 report.md。
  - 填写示例参考:已 archive 的 phase-1/2/3-entry.md(如"worker 完整改动记录在 runs/<TASK>/output.md;未进主窗口;control agent 只读 report.md;raw Edit 历史在 sub-agent 上下文不复制")。
  - 一句纪律:Review Posture(report-first,compress accepted conclusions,不 paste raw 进 long-term state)的体现。

### ② art-lab "the agent"(判断:保留 + 注释,或重写)
- art-lab-worked-example.md :9 的 "the agent could not recover" 描述的是 **art_lab 原任务**(一个真实的外部 wiki/civilization-map build)的执行者,**不是 enloom 的 control agent/worker**。
- **你的判断**(二选一,在 report.md 说明选了哪个 + 为什么):
  - **(a) 保留 "the agent" + 加行内注释**(推荐):在 :9 附近加一句说明"此处 the agent 指 art_lab 原任务的执行者,非 enloom 角色"。理由:art-lab 是历史外部任务的真实记录,改写成 enloom 角色名会篡改历史描述,失真。
  - **(b) 改写**(若你认为读者会混淆):改成 "the operator (of the original art_lab task)" 或类似中性表述,保留语义但不暗示 enloom 角色。
- **倾向 (a)**:历史描述诚实优先。但若你判断 (b) 更清晰不失真,可选 (b),说明理由。

### ③ manual-trial "The agent" → control agent(直接改)
- manual-trial.md :16/:28/:29/:30 的 "The agent" 描述的是 **enloom triage 后的行为**(completes the edit / reads minimal state / produces phase plan / produces Task Packet)——这是 enloom 的 control agent 角色,直接改成 "The control agent"(或 "control agent")。
- 注意 :16 的 "The agent completes the tiny edit normally" 若语境是 `direct` triage(不进 enloom),则 the agent 指"执行 triage 的 control agent 或当前 agent"——按 P1 基准,triage 由 control agent 做,改 control agent 合适。

## Required Verification

Countable outputs:
- archive-entry.md: 1 个 Raw Material Handling 锁注释段
- art-lab: 1 处处理(:9,保留+注释 或 重写)
- manual-trial: 4 处 "The agent" → control agent(:16/:28/:29/:30)

check_item:
- `grep -n "Raw Material Handling" enloom-skill/references/templates/archive-entry.md` → 锁注释命中(段下有 > 注释)
- `grep -n "the agent\|The agent" enloom-skill/references/examples/manual-trial.md` → 0(全改 control agent)或仅留必要历史
- `grep -n "art_lab\|original task\|注释" enloom-skill/references/examples/art-lab-worked-example.md` → 处理痕迹命中
- `grep -rn "single-agent" enloom-skill/` → 0(P3 不引入)
- `diff -r enloom-skill/ ~/.agents/skills/enloom/` → clean

## Evidence Required

每个 check_item 用 Evidence Contract 四要素回答。

## Review Budget

~800 字。逐文件 old→new 进 output.md,结论进 report.md。

## Done Signal

Return done/blocked/failed + 路径。done 须含:源 3 文件改完 + 副本同步 + diff 校验 + output.md + report.md。report.md 须说明 art-lab 选了 (a) 还是 (b) + 理由。
