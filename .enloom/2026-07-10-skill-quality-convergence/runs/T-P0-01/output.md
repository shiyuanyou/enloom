# T-P0-01 — Live Baseline Audit

## Baseline

- HEAD: `318944b1ff715049a71ebcb21f3e16fe21afc07f`，与 packet 预期值精确一致。
- Source / installed parity: `diff -qr enloom-skill /Users/bigo/.agents/skills/enloom` 退出 0、无输出；当前源与安装副本一致。
- Live diff: `git diff --name-only -- enloom-skill README.md PROGRESS.md CHANGELOG.md AGENTS.md` 在审计前为空；P0 live 文件没有既有 diff。
- Existing non-live state: 审计开始时 `git status --short` 只有既有的 `M .enloom/task_board.md` 与未跟踪的 `.enloom/2026-07-10-skill-quality-convergence/`；它们是 control 已建立的 P0 控制面，不归本 worker 所有。
- Audit boundary: 完整覆盖 packet 指定的 root docs、live skill/references/templates/prompt-assets、安装副本一致性，以及 repo-hygiene 三个冻结 run 的 task/report/output。没有修改 live skill、root docs、installed copy、archive 或 serial-integration 文件。
- Status vocabulary: 本文的 `confirmed / superseded / downgraded / insufficient-evidence` 只描述当前事实状态，不提前裁决 canonical rule。

## Domain Summary

| ID | Domain | Status | Finding count | Highest severity |
|---|---|---|---:|---|
| D1 | Evidence | confirmed | 2 | high |
| D2 | Lifecycle / landing / fold | confirmed | 4 | high |
| D3 | Review / audit ownership | confirmed | 2 | high |
| D4 | Runtime / parallel | mixed: confirmed + downgraded | 2 | medium |
| D5 | Namespace | confirmed | 1 | high |
| D6 | Validation | confirmed | 1 | high |
| D7 | Description | mixed: confirmed + insufficient-evidence | 2 | medium |
| D8 | Mechanical text | mixed: confirmed + superseded | 3 | medium |

## Findings

### F-D1-01

- severity: high
- status: confirmed
- claim: `PASS iff` 的公式与同文件的 PASS 完整条件不等价；前者只要求 declared checks 已跑且 evidence 非空，后者还要求 blind spots 已声明且无未解释 high-severity issue，因此相同报告可被两套文字判成不同结果。
- current evidence: `enloom-skill/references/evidence-contract.md:30-36` 把“两条件”写成 `if and only if`；`enloom-skill/references/evidence-contract.md:44-48` 又为 PASS 增加 blind spots 与 high-severity 条件；`enloom-skill/references/workflow-steps.md:167-171` 同时复述扩展条件与两条件 `iff`。
- conflicting/agreeing sources: `enloom-skill/references/review-checklist.md:15-21` 同样一边给四条件 PASS，一边把硬约束缩成 declared checks + evidence；三处一致地暴露同一个逻辑缺口，而不是互相消除。
- why it matters: Verify 的机械判定不是唯一函数；reviewer 可以抓住 `iff` 给 PASS，也可以抓住 verdict table 拒绝，Law 4 因此没有真正机械化。
- minimal repair boundary: `enloom-skill/references/evidence-contract.md`、`enloom-skill/references/workflow-steps.md`、`enloom-skill/references/review-checklist.md`，以及复述结论规则的 `references/templates/audit-task-packet.md`。
- counterevidence / known counterexample: 三处都明确禁止无 evidence 的 PASS，说明核心意图稳定；缺陷是必要/充分条件集合不完整，不是完全没有 gate。
- executable verification candidate: `NOT RUN（P0 不改 live）`；用四个表驱动样例分别覆盖“checks/evidence 都有但 blind spots 缺失”“high issue 未解释”“全部满足”“required check 未跑”，要求所有 owner 文件输出同一 verdict。

### F-D1-02

- severity: high
- status: confirmed
- claim: `Not Checked` 同时承载“本应执行但未执行的验证”和“运行时结构性 limitation”；前者应阻止 PASS，后者却被要求在正常 PASS 报告中声明，当前四要素无法区分两类风险。
- current evidence: `enloom-skill/references/evidence-contract.md:9-14` 定义 Not Checked 为 should-have-run-but-did-not，Known Blind Spots 只负责解释这些缺口；`enloom-skill/references/evidence-contract.md:84-90` 又要求把 cross-worker isolation、cross-role verification、virtual parallelism 三个结构性限制列在 Not Checked；`enloom-skill/references/templates/worker-report.md:22-34` 继续把 Known Blind Spots 绑定到 Not Checked，同时提示按适用性列结构性盲区。
- conflicting/agreeing sources: `enloom-skill/references/review-checklist.md:25-28` 要 accepted 报告同时含两个字段；`evidence-contract.md:32` 又规定 declared check `NOT RUN` 不能 PASS。repo-hygiene 的 `T-progress-compact/report.md:81-91` 展示了现实反例：Not Checked 非空但 Review Result 仍为 PASS。
- why it matters: limitation 若放入 Not Checked，literal gate 会拒绝所有诚实报告；若不放，四要素/盲区要求又失败。dogfood 的 PASS 因而不可由当前规则唯一复算。
- minimal repair boundary: `enloom-skill/references/evidence-contract.md`、`references/templates/worker-report.md`、`references/review-checklist.md`、三份 `prompt-assets/*.md` 中对 Not Checked 的指令。
- counterevidence / known counterexample: `worker-report.md:34` 的“Not every report needs all three”已经按适用性降噪，但仍未提供 required-check omission 与 structural limitation 的字段级分流。
- executable verification candidate: `NOT RUN（等待 canonical field semantics）`；构造 required check omission、declared noncritical check omission、structural limitation、无缺口四份报告，验证每份只有一个合法 verdict/conclusion。

### F-D2-01

- severity: high
- status: confirmed
- claim: Stage 3 存在循环入口：`make-prompt` 被定义为 Stage 3 子动作，但 Stage 3 入口又要求它将要生成的 `task.md` 已存在。
- current evidence: `enloom-skill/SKILL.md:39-44` 把 `make-prompt` 与 `dispatch` 都放在 Stage 3；`enloom-skill/references/workflow-steps.md:119-128` 要进入 Stage 3 前已有 `runs/<TASK>/task.md`，缺失则回 Plan；`enloom-skill/references/landing-contract.md:35-42` 的 handshake 先做 Stage 3 entry check，随后才执行 make-prompt 写 task.md。
- conflicting/agreeing sources: `landing-contract.md:64` 和 `workflow-steps.md:128` 都正确要求 pre-dispatch 时 task.md 已存在；冲突只在“Stage 3 entry”与“pre-dispatch gate”被当成同一时点。
- why it matters: 新 task 严格照状态机执行时无法进入生成 packet 的阶段；实际控制面只能绕过 entry gate，或把 make-prompt 偷跑到 Plan/阶段间隙。
- minimal repair boundary: `enloom-skill/SKILL.md`、`references/workflow-steps.md`、`references/landing-contract.md`、`references/glossary.md` 中 Gate 定义。
- counterevidence / known counterexample: 当前 P0 实际先把 `runs/T-P0-01/task.md` 落盘再 dispatch，说明 pre-dispatch Law 2 可以工作；它不能证明当前阶段边界自洽。
- executable verification candidate: `NOT RUN（需先裁决 stage owner）`；从空 run 目录逐条执行 gate table，记录 make-prompt 是否能在不越级的前提下首次创建 task.md。

### F-D2-02

- severity: high
- status: confirmed
- claim: Project Fold 规则允许在 Triage 决策之前 dispatch sub-agent 并移动目录，直接违反“先 triage、再创建文件或 dispatch”的 First Move，也让一个最终应为 `direct` 的请求产生 Enloom 副作用。
- current evidence: `enloom-skill/SKILL.md:12-17` 要求在创建文件或 dispatch worker 前先 triage；`enloom-skill/references/workflow-steps.md:64-65` 却要求“再做 Triage 正事”前先派 sub-agent 做 fold；`enloom-skill/references/archive-policy.md:47-54` 确认 fold 是会执行目录移动的显式操作。
- conflicting/agreeing sources: `enloom-skill/SKILL.md:55` 的 Law 1（No Enloom without trigger）支持 First Move；archive policy 的 fold 触发本身有明确阈值，但没有消除时序冲突。
- why it matters: Stage 0 本应是无副作用的入口判断；当前规则可以在尚未确认进入 Enloom 时改工作区并派 worker。
- minimal repair boundary: `enloom-skill/references/workflow-steps.md`、`references/archive-policy.md`、`enloom-skill/SKILL.md` 的 fold stage mapping。
- counterevidence / known counterexample: fold 只做 mv、task_board 行不动，副作用范围较小；但“副作用小”不能满足 First Move 的顺序约束。
- executable verification candidate: `NOT RUN（会移动冻结目录，超出本 packet）`；用一个零 trigger 的 direct 请求和三个 closed 顶层项目做手工状态机演练，确认 triage 结果产生前文件系统零写入。

### F-D2-03

- severity: medium
- status: confirmed
- claim: live 文本把编号 0–6 的七个状态称为“six stages”，没有明确区分 Stage 0 entry decision 与后续 six-stage lifecycle。
- current evidence: `enloom-skill/SKILL.md:21-32` 声称 six stages 后列出 0–6 七行；`enloom-skill/references/workflow-steps.md:1-12` 重复相同表述；`enloom-skill/references/glossary.md:9-10` 明说“6 阶段”并同时枚举 Triage/Orient/Plan/Execute/Verify/Integrate/Close 七个名称。
- conflicting/agreeing sources: `enloom-skill/references/trigger-contract.md:44-47` 已隐含 Triage 是 lifecycle 入口决策、`enloom` 后从 Stage 1 开始，提供了可区分的反证；但核心 owner 未采用该区分。
- why it matters: phase/task 文档在“六阶段”与“Stage 0–6”之间无法做机械计数，T-P0-03 也无法判断“six stages 7 refs”究竟是通过还是自相矛盾。
- minimal repair boundary: `enloom-skill/SKILL.md`、`references/workflow-steps.md`、`references/glossary.md`、README 的 lifecycle 标题与摘要。
- counterevidence / known counterexample: 把 Triage 视为 stage 0、后六项视为执行 lifecycle 可解释现有编号；这只是合理解释，当前 owner 文本没有明说。
- executable verification candidate: 已运行 `rg -n '^0\. Triage|...|^6\. Close' enloom-skill/SKILL.md`，重数为 7；修订后应再用固定术语 grep 验证 owner 与引用方一致。

### F-D2-04

- severity: medium
- status: confirmed
- claim: `health-check` 的 stage mapping 只写 Orient + Verify，但 landing/workflow 又要求它执行每个 stage transition；入口索引与详细契约给出的调用点不一致。
- current evidence: `enloom-skill/SKILL.md:48-49` 把 health-check 归到 `1 Orient + 4 Verify`；`README.md:122-129` 也只列 Orient + Verify (periodic)；`enloom-skill/references/workflow-steps.md:246-257` 则要求每个 1→2→3→4→5→6 边界运行 light tier；`enloom-skill/references/landing-contract.md:77-86` 再次把它定义为 every-stage transition executor。
- conflicting/agreeing sources: `SKILL.md:115` 已在 Landing Discipline prose 中提到每次 transition hard-verify，说明详细语义存在，但 sub-action table 与 README 仍会误导只按 stage membership 调用的 agent。
- why it matters: agent 若只按入口表加载，可能漏跑 transition gate；若按详细 reference，又会得到不同的 stage ownership。
- minimal repair boundary: `enloom-skill/SKILL.md` 的 sub-action table、`README.md` Controls 表，以及 owner `references/workflow-steps.md`/`landing-contract.md` 的术语对齐。
- counterevidence / known counterexample: 详细 reference 对 light/full tier 划分很清楚；问题是入口索引不忠实，不是 detailed rule 缺失。
- executable verification candidate: 已用 `rg -n 'health-check'` 对 SKILL/README/workflow/landing 交叉核对；修订后应要求所有 stage mapping 列出 transition executor 与 periodic homes 两种语义。

### F-D3-01

- severity: high
- status: confirmed
- claim: reviewer 与 control 对 Review Result/Registry 的写权没有唯一 owner：landing 把 report 写入与 Registry 更新交给 control，reviewer asset 又命令 reviewer “log” Registry，同时声明 reviewer 不得修改任何文件。
- current evidence: `enloom-skill/references/landing-contract.md:53-56` 明确由 control 写 `report.md` 的 Review Result 和 project_state/Registry；`enloom-skill/prompt-assets/reviewer.md:11-20` 禁止 reviewer 修改任何文件或 project_state；同文件 `reviewer.md:39-46` 又要求 reviewer “Log discovered problems into the Registry”；`enloom-skill/references/workflow-steps.md:171-175` 将 Registry 写入义务明确给 control agent。
- conflicting/agreeing sources: `reviewer.md:22-37` 的输出可以解释为 verdict/conclusion + Registry proposal，但第 45 行使用的是实际写入动词 `Log`，不是 propose；`landing-contract` 没有 reviewer 独立落盘路径。
- why it matters: 遵守 permissions 的 reviewer 无法完成 How to review；照 How to review 写 Registry 又侵犯 serial-integration ownership。
- minimal repair boundary: `enloom-skill/prompt-assets/reviewer.md`、`references/landing-contract.md`、`references/workflow-steps.md`、`references/templates/worker-report.md`。
- counterevidence / known counterexample: 当前 P0 packet 已采用“worker 留空 Review Result、control 串行填写”的可执行做法；这是一份局部 packet 约束，尚未修复 live 通用契约。
- executable verification candidate: `NOT RUN（等待 ownership 裁决）`；以 reviewer packet 分别尝试 verdict、Review Result、Registry proposal 三种产物，确保只有一个角色对每个 durable file 有写权。

### F-D3-02

- severity: high
- status: confirmed
- claim: pure audit worker 可以只收到 audit packet，但该模板没有 Writable/Forbidden、output/report 落盘路径或 Review Result 写入责任，无法同时满足 Law 2、Stage 4 landing 和 serial Registry ownership。
- current evidence: `enloom-skill/references/templates/audit-task-packet.md:9-13` 明说 pure audit worker 可只收到该 packet；`audit-task-packet.md:50-65` 只定义 named lists 与返回 caller 的 verdict/counts，没有 durable output/report/ownership 字段；普通 packet 的 audited mode 在 `references/templates/task-packet.md:7-19` 要求完整 Writable/Forbidden/verification/countable fields；`enloom-skill/references/landing-contract.md:16-18` 则要求 Execute/Verify 依赖 task/output/report/Review Result 文件。
- conflicting/agreeing sources: `enloom-skill/references/workflow-steps.md:173-175` 说 audit returns verdict + named lists “for registry intake”，可解释为 control 后续写入；但 template 没说明这个 handshake，也没有 reviewer report 文件。
- why it matters: audit worker 可能只在 chat 返回，或直接写 Registry；两种都破坏当前 landing/ownership contract，且 archive 无法检查其 Review Result。
- minimal repair boundary: `enloom-skill/references/templates/audit-task-packet.md`、`references/workflow-steps.md`、`references/landing-contract.md`、`prompt-assets/reviewer.md`。
- counterevidence / known counterexample: audit packet 与普通 packet组合使用时，普通 packet 可补齐边界；缺陷来自模板明确允许“pure audit only this packet”。
- executable verification candidate: `NOT RUN（需先决定 audit 是否是独立 run）`；生成一份 pure final audit packet，逐项检查 task/output/report/Review Result 与 Registry proposal 的 owner/path 是否能从 packet 唯一推出。

### F-D4-01

- severity: medium
- status: downgraded
- claim: “virtual parallelism = control 必然顺序 spawn、无 runtime concurrency”应降级为 runtime-conditional limitation；live 文本把某类 host 行为写成了所有 Enloom runtime 的架构事实。
- current evidence: `enloom-skill/references/scheduler-rules.md:73-77` 断言即使有独立 sub-agent，control 也在单会话中顺序发起；`enloom-skill/references/evidence-contract.md:86-90` 把同一断言列为恒定 Honest Blind Spot；`README.md:10-11` 同时声明 Enloom 不提供 worker runtime，实际并发能力应由 host 决定。
- conflicting/agreeing sources: `enloom-skill/references/landing-contract.md:88-92` 已承认 runtime capability 有/无 sub-agent 的差异，却没有为并发 capability 做同样条件化。当前 Codex team runtime 可创建并行 agent，但本 P0 phase 按 packet 明确串行，未做时间重叠实验。
- why it matters: protocol 把“声明 parallel”一律解释成未并发，会错误描述具备 concurrent dispatch 的 host，也无法诚实记录一次实际发生的并行。
- minimal repair boundary: `enloom-skill/references/scheduler-rules.md`、`references/evidence-contract.md`、`references/glossary.md`、worker-report blind-spot提示。
- counterevidence / known counterexample: 在只能顺序调用 sub-agent 的 runtime 上，这个 limitation 完全真实；降级为 conditional 不等于删除。
- executable verification candidate: `NOT RUN（P0 strategy=serial）`；在支持的 host 上派两个只写隔离文件、各记录 start/end 的 task，比较时间窗并把 capability/actual execution 分开报告。

### F-D4-02

- severity: medium
- status: confirmed
- claim: task packet 的 `Role` 没有通用的 role→prompt-asset 加载路由；prompt-assets 被列为目录素材，但 coder/reviewer/researcher 是否进入实际 dispatch prompt 取决于 agent 自行发现。
- current evidence: `enloom-skill/references/templates/task-packet.md:3-5` 定义 Role 枚举；`enloom-skill/SKILL.md:61-77` 的 on-demand references 路由没有任何 prompt asset；`enloom-skill/SKILL.md:99-102` 只在推荐项目目录树列出三个文件；`PROGRESS.md:15-18` 明确登记 prompt-assets 是否 load-bearing 未经原生 runtime 验证。
- conflicting/agreeing sources: `enloom-skill/references/scheduler-rules.md:69` 为 recon researcher 单点链接 researcher asset，`prompt-control.md:127-133` 也引用 researcher；它们是特例，不构成所有 Role 的 dispatch 路由。
- why it matters: packet 标了 `Role: reviewer` 不保证 reviewer contract 被加载；ownership、report shape 和 epistemic discipline 可能只存在于无人读取的素材中。
- minimal repair boundary: `enloom-skill/SKILL.md` 或 `references/workflow-steps.md` 的 make-prompt/dispatch route，以及必要时 `references/templates/task-packet.md` 的 Role 说明；无需默认复制资产到项目目录。
- counterevidence / known counterexample: agent 若主动读取对应 asset，现有文件内容可用；缺的是确定性路由，不是素材缺失。
- executable verification candidate: `NOT RUN（P0 禁止 runtime/eval 扩展）`；分别 dispatch Role=researcher/coder/reviewer 的最小 packet，检查最终 prompt 是否包含对应 asset 的唯一标记与权限边界。

### F-D5-01

- severity: high
- status: confirmed
- claim: fold 后 task_board 无法按 live resolver 唯一定位项目：索引字段只能推导顶层 `.enloom/<created>-<project>/`，fold 却把目录移到 `.enloom/archive/<created>-<project>/` 且不更新行。
- current evidence: `enloom-skill/references/templates/task-board.md:10-23` 定义字段并要求 Orient `cd .enloom/<created>-<project>/`，closed/fold 行仍保留且不改；`enloom-skill/references/archive-policy.md:47-56` 把目录移到 `.enloom/archive/...` 并再次强调 task_board 行不动；`enloom-skill/SKILL.md:105-107` 要 Orient 依靠 task_board 定位并复用同名项目，却没有 active/archive location 或 search fallback。
- conflicting/agreeing sources: archive policy 声称“project 列用名字索引，路径变化不影响查找”，但 task-board schema 没有位置字段，resolver 也只给顶层路径；项目名可去重但不能决定目录在 active 还是 archive。
- why it matters: Orient/reopen closed 项目时会得到不存在的顶层路径；同名项目重入可能被误判为新建，破坏 namespace 去重和历史连续性。
- minimal repair boundary: `enloom-skill/references/templates/task-board.md`、`references/workflow-steps.md` Orient、`references/archive-policy.md` Fold/reopen、`enloom-skill/SKILL.md` File Protocol。
- counterevidence / known counterexample: agent 可以先查顶层、再查 archive，人工恢复路径；当前 contract 没写这条 resolver，所以不能依赖猜测。
- executable verification candidate: `NOT RUN（不移动冻结项目）`；对一条 active row 和一条 folded closed row执行同一 resolver，要求恰好定位一个 project_state；随后模拟 reopen，确认不创建同名新目录。

### F-D6-01

- severity: high
- status: confirmed
- claim: Validation 的“verify ALL”契约超出 reference bash 实现能力；实现不是 YAML parser，也没有验证 closing fence、nested metadata、compatibility 类型/长度，却宣称与完整 contract/quick_validate 等价。
- current evidence: `enloom-skill/references/validation.md:7-23` 要求 YAML mapping、nested metadata、compatibility 类型/长度等 11 条全验；`validation.md:29-39` 宣称 flat text parser 可做每一条；`validation.md:55-79` 的 bash 实现只抽取到 closing fence或 EOF、检查 name/description/每行 key，未检查 closing fence 是否真实存在、compatibility，也会把 nested metadata 的子键当 unexpected top-level key；`validation.md:84-87` 又称 quick_validate 实现“same checks”。
- conflicting/agreeing sources: 当前 `enloom-skill/SKILL.md:1-4` 只有 flat name/description，reference script 足以验证当前这个简单实例；这不证明它实现了文档承诺的允许键/嵌套输入空间。
- why it matters: malformed or contract-legal nested frontmatter可能被误放行/误拒；validator 的 PASS 不能证明它自称的 11 条规则。
- minimal repair boundary: owner `enloom-skill/references/validation.md`；是否采用官方 validator 或收窄 fallback 承诺由后续 canonical matrix 裁决，不需要新增永久脚本。
- counterevidence / known counterexample: 对当前 flat two-key frontmatter，source/installed parity 与文本检查均正常；这是实现子集的正例。
- executable verification candidate: `NOT RUN（packet 只允许三个 run 输出文件）`；在临时目录建立缺 closing fence、nested metadata、非字符串 compatibility、合法 flat 四个 fixture，分别跑官方 validator 与 fallback，比较逐规则结果。

### F-D7-01

- severity: medium
- status: confirmed
- claim: skill 的入口 metadata 没有暴露 full Enloom 的独立 sub-agent 硬要求；description 会触发 skill，但不支持 sub-agent 的 host 只有加载后才在 Stage 3 被告知必须 halt。
- current evidence: `enloom-skill/SKILL.md:1-4` frontmatter 只有 name/description，description 未提 runtime requirement；`README.md:70-78` 明说 host 通过 description 触发；`enloom-skill/references/landing-contract.md:88-92` 将 independent sub-agent 设为不可降级硬要求；`enloom-skill/references/validation.md:21` 明确允许 `compatibility` metadata。
- conflicting/agreeing sources: `SKILL.md:10` 诚实声明 skill 不提供 automatic worker runtime，能降低误解；但“不提供 runtime”不等于“host 必须具备 independent sub-agent，否则 halt”。
- why it matters: host capability near-miss 会先触发/建控制面，直到 dispatch 才失败；兼容性边界不能在加载前被发现。
- minimal repair boundary: `enloom-skill/SKILL.md` frontmatter/entry prose，必要时 README Install/compatibility 说明；不要求现在改 description 文案。
- counterevidence / known counterexample: 用户显式调用 Enloom 时，即使 host 不兼容，加载后给出诚实 halt 仍比静默自执行安全；问题是发现太晚。
- executable verification candidate: `NOT RUN（P0 冻结 metadata）`；在有/无 sub-agent capability 的两个 host profile 上跑同一 explicit invocation，检查兼容性是否在建 `.enloom/` 或 dispatch 前可见。

### F-D7-02

- severity: medium
- status: insufficient-evidence
- claim: 当前 description 的真实 trigger precision/recall 无法在 HEAD 上判定；仓库只保留单模型历史结论，并明确删除了非 host-native 的旧套件。
- current evidence: `enloom-skill/SKILL.md:3` 是当前唯一 description；`PROGRESS.md:15` 明说历史 20/20 只在 deepseek-v4-pro 验过，Claude/GPT 与 near-miss 未验证；`PROGRESS.md:18` 说明旧套件是 description-only unit test、非 host 原生 trigger 集成测试且已删除。
- conflicting/agreeing sources: description 同时包含正向场景与 single-file/bugfix/direct-Q&A 负向边界，文本上具备基本区分；历史 20/20 是有限反证，但不能外推当前多 host 行为。
- why it matters: 不能凭文案直觉把 over-trigger/under-trigger 写成 confirmed defect，也不能声称当前 trigger 已通过。
- minimal repair boundary: 先只产出 P5/P6 临时 host-native should-trigger / should-not-trigger 证据；只有证据指出失败时才触及 `enloom-skill/SKILL.md:3`。
- counterevidence / known counterexample: deepseek-v4-pro 的历史 20/20 表明至少一个模型/旧快照可用；其时效与当前 host 集成均不足。
- executable verification candidate: `NOT RUN（无 packet 授权的跨模型 runtime，且 P0 明确不跑 description optimizer）`；用冻结的正例/near-miss在每个可用 host fresh context 测原生触发，并分别报告 precision/recall。

### F-D8-01

- severity: medium
- status: confirmed
- claim: 两个 template 把 `§` 和章节号写进 Markdown link target，生成不存在的文件路径，而不是把章节提示留在 link label 外。
- current evidence: `enloom-skill/references/templates/task-packet.md:38` 的 target 是 `../registry-and-compaction.md §2`；`enloom-skill/references/templates/worker-report.md:42` 的 target 是 `../registry-and-compaction.md §1`。已运行 `rg -n '\]\([^)]*\.md §[0-9]+\)' enloom-skill/references/templates`，精确命中 2 处。
- conflicting/agreeing sources: `enloom-skill/references/templates/phase-plan.md:35` 使用 `[registry-and-compaction.md §3](../registry-and-compaction.md)`，展示了同仓库中可工作的格式。
- why it matters: 新 packet/report 模板中的核心 Ownership/Registry 说明点击后失败，且 Broken References 自身模板带 broken reference。
- minimal repair boundary: 仅 `references/templates/task-packet.md` 与 `references/templates/worker-report.md`。
- counterevidence / known counterexample: 文字仍可让人猜到 owner 文件，故不是方法论数据丢失；这是可机械修的链接缺陷。
- executable verification candidate: 已运行上述 rg，current count=2；修复后同一命令应为 0，并验证相对 target 文件存在。

### F-D8-02

- severity: low
- status: superseded
- claim: phase-plan 示例中的 `[x](path)` 不是当前 broken link；它被反引号包围，是 code span 示例，不会生成可点击 Markdown target。
- current evidence: `enloom-skill/references/templates/phase-plan.md:40` 的完整单元格写作 ``_e.g. markdown links `[x](path)`_``；`[x](path)` 位于 inline code 内。
- conflicting/agreeing sources: `.enloom/2026-07-10-skill-quality-convergence/project_state.md:68-71` 把它登记为待重验伪链接；当前 live 行提供反证，因此该旧假设不应进入修复矩阵。
- why it matters: 若按旧结论修它，会把示例代码误当真实导航链接，制造无收益改动。
- minimal repair boundary: 无 live repair；只需 control 在 Registry/canonical matrix 把该项标为 superseded。
- counterevidence / known counterexample: 若某 Markdown renderer错误解析 code span 内链接才可能复现；标准 Markdown 语义不这样做，本轮未发现该 renderer 证据。
- executable verification candidate: `NOT RUN（未引入 renderer）`；用项目实际 Markdown renderer 渲染该单元格，断言 DOM 中没有 href=`path`。

### F-D8-03

- severity: medium
- status: confirmed
- claim: README Install 段展示了一个“package + install”代码块，但代码块只有注释、没有任何可执行安装命令。
- current evidence: `README.md:70-78` 声明安装位置与“from this repo, package + install”，第 74–76 行代码块没有命令。
- conflicting/agreeing sources: `AGENTS.md:31-35` 只规定开发时源/安装副本同步纪律，不是面向用户的首次安装命令；当前机器已有安装副本也不能替代 README 的可复现说明。
- why it matters: 新用户无法按 SSOT 完成安装，也无法验证 source/installed parity；空代码块给出“已有步骤”的假象。
- minimal repair boundary: `README.md` Install 段；若安装由外部 skill-creator 提供，只需写清真实命令或明确指向，不扩展 CLI。
- counterevidence / known counterexample: 已安装环境可直接使用 `~/.agents/skills/enloom/`，所以现有开发者不受阻；缺陷影响首次/迁移安装。
- executable verification candidate: `NOT RUN（当前没有被文档声明的命令可执行，且 P0 禁止安装）`；补文档后在临时 CODEX_HOME/AGENTS_HOME 中按原样执行并做 `diff -qr`。

## Latest Dogfood Gate Audit

| Report | Checks Run | Evidence | Not Checked | Known Blind Spots | Review Result | Claim consistency (claimed / recounted / delta) | Current-contract result |
|---|---|---|---|---|---|---|---|
| `T-design-archive/report.md` | semantic checks under “How verified”, but no canonical field (`report.md:24-69`) | concrete ls/SHA/grep evidence present | absent; “Open issues: 无” is not a Not Checked inventory (`report.md:71-89`) | absent | present: PASS / accepted (`report.md:114-126`) | archived files `7/7/0`; top-level `1/1/0`; lines `3552/3552/0`; refs `0/0/0`, independently recounted from frozen `output.md:12-19,38-42` | **FAIL / needs-rework under current contract**: two of four required elements are absent even though count claims agree. |
| `T-progress-compact/report.md` | present, 8 checks (`report.md:6-20`) | present with command output (`report.md:21-79`) | present and non-empty (`report.md:81-85`) | present (`report.md:87-91`) | present: PASS / accepted (`report.md:97-109`) | PROGRESS after `80/80/0`; README after `170/170/0`; risk items `6/6/0`, recounted against frozen `output.md:7-20,25-30,40-44` | **FAIL / needs-rework under current contract**: acceptance claim that commit hashes are traceable was not run (`task.md:51-56`; `report.md:84`), and “functional prose zero change” was supported only by header presence while exact diff was declared unchecked (`report.md:83,95`). |
| `T-skill-clean/report.md` | present (`report.md:11-20`) | present (`report.md:21-104`) | present and non-empty (`report.md:106-110`) | present (`report.md:112-116`) | present: PASS / accepted (`report.md:172-185`) | annotations `5/5/0`; glossary sections `6/6/0`; terms `31/31/0`; files `12/12/0`, report vs frozen `output.md:18-23` | **FAIL / needs-rework**: packet required glossary sections ≤4, reference files=10, and `three-tier` marker to hit (`task.md:79-85`); actual/report are 6, 12, and 0, while report silently changes the first two expected values and waives the third (`report.md:43-104`). |

The matrix has exactly three report rows. Countable report-vs-output claims have delta 0 in all three rows; the failures are Evidence/Acceptance gate failures, not numeric report-vs-output drift.

## Coverage and Unknowns

- Required B01–B08 coverage is complete. Eight domains and all three dogfood reports were checked on the current HEAD; no packet-required check was skipped.
- Cross-model/host-native description triggering was not run. Risk: medium; current repo explicitly says only deepseek-v4-pro history exists, so D7 trigger quality remains `insufficient-evidence` rather than pass/fail.
- A malformed-YAML fixture matrix was not executed because packet write scope only permits this run's output/report/raw-notes. Risk: medium; D6 is confirmed from direct code/contract inspection, but exact false-positive/false-negative counts remain unknown.
- A Markdown renderer/DOM link test was not run. Risk: low; two `§` targets are path-level defects by inspection, while the code-span pseudo-link is classified superseded subject to renderer confirmation.
- No concurrent timing experiment was run because P0 strategy is serial. Risk: medium; D4 only downgrades the universal virtual-parallelism claim and does not assert that this P0 worker ran concurrently.
- Historical pre-move SHA256 values in `T-design-archive` cannot be independently regenerated from the frozen output alone. Risk: medium; file/list/line claims were recounted, but the “before” hashes remain report-provided evidence.
- Archived dogfood outputs describe their 2026-07-09 snapshots; current README/PROGRESS/design index have evolved. Recounts therefore compare each report to its frozen `output.md`, not to today's live file lengths.
- Shared-filesystem isolation is not enforced by process sandbox: collaborating agents share the workspace. This worker used exact Writable/Forbidden discipline plus before/after git/hash checks; those detect mutations but cannot prove another actor did not race between checks. Risk: medium.
- Cross-role verification is limited: this audit is a separate worker context, but control/reviewer may use the same model family and parent session. Independent reasoning-chain diversity is not guaranteed. Risk: medium.
- No network, external docs, archived design-body rewrite, source change, formatter, generator, install, or description optimizer was used.

## Inputs for T-P0-02

Only established facts and unresolved adjudication points follow; these are not canonical rules.

1. Established: Evidence owner text contains two independent ambiguities—an incomplete `iff` formula (F-D1-01) and required-check omissions mixed with structural limitations (F-D1-02). Pending adjudication: field semantics and the exact necessary/sufficient PASS set.
2. Established: pre-dispatch `task.md` is a valid Law 2 gate, but assigning packet creation to Stage 3 while making task.md a Stage 3 entry condition is circular (F-D2-01). Pending adjudication: which stage/boundary owns make-prompt.
3. Established: pre-triage fold dispatch/mv conflicts with First Move/Law 1 (F-D2-02). Pending adjudication: fold's trigger point after a request has legitimately entered Enloom.
4. Established: current lifecycle naming enumerates seven numbered states while saying six, and health-check stage mapping omits its transition-executor role (F-D2-03/04). Pending adjudication: canonical naming and mapping vocabulary.
5. Established: control/reviewer/audit write responsibilities are not unique; pure audit packet has no complete landing/ownership contract (F-D3-01/02). Pending adjudication: durable file owner for Review Result, audit report, and Registry proposals/intake.
6. Established: real concurrency and isolation are runtime capabilities, while current docs universalize a sequential-host limitation; prompt assets lack a generic Role route (F-D4-01/02). Pending adjudication: capability declaration versus actual execution record, and asset-loading handshake.
7. Established: task_board's fields/resolver only derive the active top-level path while fold moves closed projects under archive without row change (F-D5-01). Pending adjudication: deterministic active/archive resolver and reopen behavior.
8. Established: the documented flat parser does not implement the full validation contract (F-D6-01). Pending adjudication: authoritative validator versus an explicitly limited fallback.
9. Established: mandatory independent-sub-agent compatibility is absent from entry metadata (F-D7-01); actual cross-host description quality remains unproven (F-D7-02). Pending adjudication: where compatibility is declared; trigger wording must wait for evidence.
10. Established: exactly two live template targets contain `§` in the path; the `[x](path)` code-span hypothesis is superseded; README install block is empty (F-D8-01/02/03). Pending adjudication: mechanical repair set only.
11. Established: all three latest dogfood reports have zero numeric report-vs-output delta, but none satisfies the current gate end-to-end: one lacks two four-element fields, one leaves acceptance-support checks unrun, and one changes/waives packet expectations. Pending adjudication: use them as regression fixtures, not accepted proof of the current Evidence Contract.
