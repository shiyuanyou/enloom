# Task Packet: P1-align

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

对 clear-mind skill(~/.agents/skills/clear-mind/)做三层轻量对齐 enloom v0.6 dispatch-default posture,具体改 4 个文件 + grep 自检。每处改动用 Edit 工具精确替换,不重写整段。

## Anti Goal

- 不翻转 explore gather 运行时默认(仍内联,只改叙事)。
- 不引入 .enloom/ 暗检测。
- 不全 skill 引入 "control agent" 角色名(只 trigger-contract 一处显式 clear-mind 自己角色)。
- 不改 plan/review 的内联表述。
- 不改 honest-limitations.md(超出本 phase)。
- 不改 enloom skill 任何文件。
- 不动 clear-mind 未列出的文件。

## Inputs

- 裁决来源:`/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.clear-mind/2026-07-06-clearmind-align-v06/review.md`(WORTH-IT,三层对齐方案)
- 被改文件(均需先 Read 再 Edit):
  1. `/Users/bigo/.agents/skills/clear-mind/references/trigger-contract.md`
  2. `/Users/bigo/.agents/skills/clear-mind/references/explore-method.md`
  3. `/Users/bigo/.agents/skills/clear-mind/SKILL.md`
  4. `/Users/bigo/.agents/skills/clear-mind/references/templates/review.md`

## Existing State

- enloom v0.6 已确立 dispatch-default posture(默认 dispatch sub-agent,无能力即中断不退化)。
- clear-mind 的 explore gather 默认"模式 B 内联",措辞含"降级",与 enloom 新 posture 叙事上不一致(定位差异非真冲突,但叙事需跟进)。
- clear-mind 全 skill 零使用 "control agent"。

## Allowed Tools

Read, Edit, Bash(grep/wc 自检), Write(仅 output.md/report.md)

## Writable Files

> Exclusive,精确到路径。

- `/Users/bigo/.agents/skills/clear-mind/references/trigger-contract.md`(源)
- `/Users/bigo/.agents/skills/clear-mind/references/explore-method.md`(源)
- `/Users/bigo/.agents/skills/clear-mind/SKILL.md`(源)
- `/Users/bigo/.agents/skills/clear-mind/references/templates/review.md`(源)
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/2026-07-06-clearmind-align/runs/P1-align/output.md`(产物)
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/2026-07-06-clearmind-align/runs/P1-align/report.md`(产物)

## Forbidden Files

> 显式枚举串行集成区 + 其他 clear-mind 文件 + enloom 全部。

- `.enloom/2026-07-06-clearmind-align/project_state.md`(串行集成,control agent 独占)
- `.enloom/task_board.md`(串行集成)
- `/Users/bigo/.agents/skills/enloom/` 下所有文件(本 phase 不动 enloom)
- `/Users/bigo/.agents/skills/clear-mind/` 下未在 Writable 列出的所有文件(尤其:honest-limitations.md / plan-method.md / review-method.md / askbq-framework.md / glossary.md / source-priority.md / 其他 templates / examples)

## Output Files

- `output.md` — 逐处 old→new 改动摘要(每处:文件 + 行号 + 改前 + 改后)
- `report.md` — Evidence Contract 四要素对齐

## Acceptance Criteria

- 4 个源文件各完成指定改动(见下方"改动清单")。
- grep 自检通过(见 Required Verification)。
- 无 Forbidden 文件被改。
- 未引入 "control agent" 到 SKILL.md/glossary(只 trigger-contract 一处允许显式 clear-mind 角色)。

## 改动清单(逐处精确)

### 文件 1: trigger-contract.md

**改动 1a**(§explore 触发条件,第 38 行附近 —— 模式默认重述):
当前文本含:"explore 的 gather 有两种模式(模式 A 借 enloom dispatch 并行收集 / 模式 B 内联降级),**默认模式 B**;仅当**用户显式要求 enloom dispatch** 时切到模式 A——不靠检测 `.enloom/` 存在性来判定"

改为(保留拒绝暗检测的理由,但把"默认 B"重述为 dispatch-default 时代的叙事):
"explore 的 gather 有两种模式(模式 A 借 enloom dispatch 并行收集 / 模式 B 内联),**运行时默认模式 B**(clear-mind 作为独立 skill 不硬依赖兄弟 skill 的 dispatch 能力——这是独立可用性约束,不是 dispatch 不可取);**当用户显式要求 enloom dispatch 时切到模式 A**。不靠检测 `.enloom/` 存在性来判定"

**改动 1b**(§与执行编排(enloom 等)的边界 段末尾,第 66 行附近 —— 补一句 enloom 新 posture + clear-mind 角色显式):
在该段末尾"文件即接口(`.clear-mind/` ↔ `.enloom/`),互不侵入内部。"之后,补一句:
"注:enloom v0.6 起 dispatch-default posture(默认 dispatch sub-agent,无能力即中断不退化);clear-mind 自身不是 orchestrator,其角色是**裁决者**(phase -1 前置),不承担 control agent 的编排职责——故本 skill 不使用 'control agent' 角色名。"

### 文件 2: explore-method.md

**改动 2a**(§3 模式选择规则,第 87-90 行附近):
当前:"gather 走哪个模式,由**用户显式要求**决定,不靠环境检测:" 后跟两条(用户显式→A;其他→B 默认)。
在两条规则前补一段框定(dispatch-default 时代):
"**叙事框定(dispatch-default 时代)**:模式 A(enloom dispatch)是首选姿态——它把 4 信源收集 dispatch 给独立 sub-agent,与 enloom v0.6 dispatch-default posture 一致。模式 B(内联)是 clear-mind **独立可用性约束下的原生降级路径**:clear-mind 作为独立 skill 须能无 enloom 运行,故运行时默认仍为 B。这不是'dispatch 不可取',是'独立约束使然'。"

**改动 2b**(§模式 B 标题与定义,第 109-112 行附近):
标题"### 模式 B:内联模式(降级但可用)"改为"### 模式 B:内联模式(独立 skill 的原生模式)"。
定义里"当前 agent 顺序内联执行 4 信源收集(不派 worker)"保留,但补一句:"此模式是 clear-mind 独立可用性的保证——不硬依赖 enloom 的 dispatch 能力。"

### 文件 3: SKILL.md

**改动 3a**(explore 内部三阶段图,gather 行,第 31 行附近):
当前:"gather → 借 enloom dispatch 并行收集 4 信源(或内联降级) → gather-summary.md"
改为:"gather → 借 enloom dispatch 并行收集 4 信源(运行时默认内联,独立可用性约束) → gather-summary.md"

**改动 3b**(Handoff 段,第 72-73 行附近):
当前:"WORTH-IT / CONDITIONAL → suggest entering an execution-orchestration skill (e.g., Enloom's lifecycle)."
改为:"WORTH-IT / CONDITIONAL → suggest entering an execution-orchestration skill (e.g., Enloom's lifecycle — which since v0.6 defaults to dispatching sub-agents, halting if none available)."

### 文件 4: templates/review.md

**改动 4**(Handoff 段,第 90 行附近):
当前:"- **WORTH-IT** → 建议进入执行编排(如 enloom 生命周期)。"
改为:"- **WORTH-IT** → 建议进入执行编排(如 enloom 生命周期——v0.6 起 dispatch-default,默认派 sub-agent,无能力即中断)。"

## Required Verification

> 每项对齐一个 check_item。

1. `grep -rn "降级" /Users/bigo/.agents/skills/clear-mind/references/explore-method.md` → "降级"在 explore 上下文应从 ~3 处降为 ≤1 处(改动 2a/2b 软化后;若"原生降级路径"保留一处"降级"字样可接受,但标题与模式选择的"降级"应已改)
2. `grep -rn "默认模式 B\|默认.*内联" /Users/bigo/.agents/skills/clear-mind/references/trigger-contract.md` → 含"运行时默认模式 B"且附"独立可用性约束"说明
3. `grep -n "dispatch-default\|v0.6" /Users/bigo/.agents/skills/clear-mind/SKILL.md` → Handoff 段至少 1 命中
4. `grep -n "裁决者" /Users/bigo/.agents/skills/clear-mind/references/trigger-contract.md` → ≥1 命中(改动 1b)
5. `grep -rn "control agent" /Users/bigo/.agents/skills/clear-mind/SKILL.md /Users/bigo/.agents/skills/clear-mind/references/glossary.md` → 0 命中(未误引入)
6. 改动文件数 = 4(`git -C /Users/bigo/.agents/skills/clear-mind diff --stat` 或 wc 核对;注意 clear-mind 源可能不在 git,改用 ls -la 核对 mtime)

Countable outputs:
- 改动文件数:4
- "降级"在 explore-method.md 命中数:改动后 ≤1
- "control agent" 在 SKILL.md/glossary.md 命中数:0

## Evidence Required

- 每个 grep check 的实际输出(命令 + 结果)
- 4 文件每处的 old→new diff 摘要(写进 output.md)
- Forbidden 文件未改的确认(grep control agent 在 SKILL/glossary = 0)

## Review Budget

report.md 控制在 80 行内;output.md 改动摘要 ≤150 行。

## Done Signal

Return `done` / `blocked` / `failed` + report.md/output.md 路径。done 须附:4 文件改动确认 + 6 项 grep 结果 + Claim Consistency(声称 4 文件,核对一致)。
