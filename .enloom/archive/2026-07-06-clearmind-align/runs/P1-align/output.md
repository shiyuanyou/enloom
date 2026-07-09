# P1-align · 改动摘要(output.md)

逐处 old→new。4 文件 6 处编辑,均用 Edit 工具精确替换。

## 文件 1: trigger-contract.md

### 改动 1a — §explore 触发条件(约第 38 行)
模式默认重述(dispatch-default 时代叙事)。

- old:`...模式 A 借 enloom dispatch 并行收集 / 模式 B 内联降级),**默认模式 B**;仅当**用户显式要求 enloom dispatch** 时切到模式 A——不靠检测 `.enloom/` 存在性来判定`
- new:`...模式 A 借 enloom dispatch 并行收集 / 模式 B 内联),**运行时默认模式 B**(clear-mind 作为独立 skill 不硬依赖兄弟 skill 的 dispatch 能力——这是独立可用性约束,不是 dispatch 不可取);**当用户显式要求 enloom dispatch 时切到模式 A**。不靠检测 `.enloom/` 存在性来判定`
- 关键词变化:删除"模式 B 内联**降级**"的"降级";"默认模式 B"→"运行时默认模式 B"+ 独立可用性约束说明。

### 改动 1b — §与执行编排(enloom 等)的边界 段末尾(约第 66 行 → 现 68 行)
补一句 enloom v0.6 posture + clear-mind 角色(裁决者)。

- old:`- 任一 skill 可独立运行。文件即接口(`.clear-mind/` ↔ `.enloom/`),互不侵入内部。`
- new:old 句保留 + 追加:
  `注:enloom v0.6 起 dispatch-default posture(默认 dispatch sub-agent,无能力即中断不退化);clear-mind 自身不是 orchestrator,其角色是**裁决者**(phase -1 前置),不承担 control agent 的编排职责——故本 skill 不使用 "control agent" 角色名。`
- 注:此句是 clear-mind 全 skill 唯一显式提到 "control agent" 的地方,且为否定式("不使用"),符合 Anti-Goal。

## 文件 2: explore-method.md

### 改动 2a — §3 模式选择规则前补框定段(约第 87 行)
补一段 dispatch-default 时代叙事框定。

- old:`### 模式选择规则（先看这个）\n\ngather 走哪个模式，由**用户显式要求**决定，不靠环境检测：`
- new:在 `### 模式选择规则（先看这个）` 与原 gather 行之间插入:
  `**叙事框定(dispatch-default 时代)**:模式 A(enloom dispatch)是首选姿态——它把 4 信源收集 dispatch 给独立 sub-agent,与 enloom v0.6 dispatch-default posture 一致。模式 B(内联)是 clear-mind **独立可用性约束下的原生降级路径**:clear-mind 作为独立 skill 须能无 enloom 运行,故运行时默认仍为 B。这不是'dispatch 不可取',是'独立约束使然'。`
- 注:此段含 "原生降级路径" 一处 "降级"——packet 明确允许("若'原生降级路径'保留一处'降级'字样可接受")。

### 改动 2b — §模式 B 标题与定义(约第 109-113 行)
标题软化 + 定义补一句。

- old title:`### 模式 B：内联模式（降级但可用）`
- new title:`### 模式 B：内联模式（独立 skill 的原生模式）`
- old 定义末:`- 保持 explore 可独立运行，不硬依赖 enloom。`
- new 定义末:old 行保留 + 追加 `- 此模式是 clear-mind 独立可用性的保证——不硬依赖 enloom 的 dispatch 能力。`
- 关键词变化:标题去 "降级"。

## 文件 3: SKILL.md

### 改动 3a — explore 内部三阶段图 gather 行(约第 31 行)
- old:`  gather      →  借 enloom dispatch 并行收集 4 信源(或内联降级)              →  gather-summary.md`
- new:`  gather      →  借 enloom dispatch 并行收集 4 信源(运行时默认内联,独立可用性约束)  →  gather-summary.md`
- 关键词变化:"或内联降级"→"运行时默认内联,独立可用性约束"。去 "降级"。

### 改动 3b — Handoff 段 WORTH-IT/CONDITIONAL 行(约第 73 行)
- old:`- **WORTH-IT / CONDITIONAL** → suggest entering an execution-orchestration skill (e.g., Enloom's lifecycle).`
- new:`- **WORTH-IT / CONDITIONAL** → suggest entering an execution-orchestration skill (e.g., Enloom's lifecycle — which since v0.6 defaults to dispatching sub-agents, halting if none available).`
- 关键词变化:补 v0.6 dispatch-default posture。

## 文件 4: templates/review.md

### 改动 4 — Handoff 段 WORTH-IT 行(约第 90 行)
- old:`- **WORTH-IT** → 建议进入执行编排(如 enloom 生命周期)。`
- new:`- **WORTH-IT** → 建议进入执行编排(如 enloom 生命周期——v0.6 起 dispatch-default,默认派 sub-agent,无能力即中断)。`
- 关键词变化:补 v0.6 dispatch-default。

---

## 偏差记录

1. **Check 1 "降级" 命中数 = 2(非 ≤1)**:改动后 explore-method.md 仍命中 2 处 "降级":
   - 第 87 行:`原生降级路径` —— packet 改动 2a **强制写入**的新文本,packet 明确允许此一处。
   - 第 45 行:`双模式收集 4 信源维度(enloom 并行 / 内联降级)` —— §1 拓扑定位 ASCII 图,**超出改动清单范围**(改动 2a/2b 仅覆盖 §3 模式选择与 §模式 B 标题/定义)。未改,避免越界。
   - packet 验收语义("标题与模式选择的'降级'应已改")已满足:旧标题 "降级但可用" 已去 "降级"。

2. **Check 6 git diff 不可用**:clear-mind 源不在 git 仓库(`Not a git repository`)。改用 `ls -la` mtime 核对:4 文件 mtime 均为今日编辑时间,确认 4 文件已改。

3. packet 引用的 old 文本与文件实际文本在标点/空格上略有出入,均按实际内容精确匹配(中文标点全角、ASCII 图对齐空格保留)。
