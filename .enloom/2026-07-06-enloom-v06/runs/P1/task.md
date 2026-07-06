# Task Packet: P1 — 角色命名硬化 + trim rule + 源/副本同步

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

7 处措辞硬化 + 1 处结构性补强(trim rule),全部在**源仓库** `enloom-skill/` 下完成,完成后同步到安装副本。收尾 P0 遗留 + 补 D3 缺口。

## Anti Goal

- 不动 art-lab-worked-example.md / manual-trial.md(P3)。
- 不动 researcher.md(P2)。
- 不动 archive-entry.md 的 Raw Material Handling(P3)。
- 不重写整段——只改指定句/补指定段。

## Inputs

**源仓库根目录**:`/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/`

### 1. `references/eval-guide.md` L31 — single-agent 残留(P0 遗留)

**当前 L31**:
```
This path needs no external tooling. It is the honest default when no headless subagent dispatch is available. **Known bias**: in a single-agent session the same agent that wrote the skill also grades it — this is a self-graded upper bound, not a validated number. Flag it in the results; do not pretend it is independent.
```

**翻转成**:
```
This path needs no external tooling. It is the honest default when no headless subagent dispatch is available. **Known bias**: when the control agent itself runs the eval (not a fresh sub-agent), the same context that wrote the skill also grades it — this is a self-graded upper bound, not a validated number. Flag it in the results; do not pretend it is independent. Path B (fresh sub-agent per query) is the way to remove this bias.
```

### 2. `references/eval-guide.md` L25 — "hand the model" (D2)

**当前 L25**:
```
1. In a fresh agent turn, hand the model the `prompt`.
```

**翻转成**:
```
1. In a fresh agent turn, hand the worker the `prompt`.
```

### 3. `prompt-assets/coder.md` L37 — single-agent 残留(P0 遗留)

**当前 L37**:
```
4. Explicitly declare what you did NOT check (Not Checked) and why (Known Blind Spots) — including, in a single-agent environment, "cross-worker real isolation not independently verifiable."
```

**翻转成**:
```
4. Explicitly declare what you did NOT check (Not Checked) and why (Known Blind Spots) — including "cross-worker file isolation: enforced by packet fields, not by process boundary; a worker touching a forbidden file is caught by later audit, not blocked at runtime."
```

### 4. `references/templates/worker-report.md` — 补 Return-To-Caller trim rule 段(D3 缺口)

**当前**:worker-report.md 没有任何 trim rule / Return-To-Caller 段。这是 worker→control 回流的最大缺口——audit-task-packet.md:63-65 有,worker-report 没有。

**补**:在 `## Review Result` 段**之前**(即文件末尾的 Review Result 之前),插入新的一段。用 Edit 在 `## Review Result` 这一行前插入:

old_string(匹配 `## Review Result` 行,含其上方的空行上下文——先 Read 文件确认精确上下文):
找到 `## Review Result` 标题行,在它**前面**插入:
```
## Return To Caller (trim rule)

The control agent receives only: **Result + Checks Run summary + verdict-level Evidence + named risks**. Do not paste full raw output, full command logs, or worker process narrative back into the main window — detail sinks into `output.md` / `raw-notes.md` on disk, where the control agent reads only on evidence-shortfall or failure. This mirrors [audit-task-packet.md §Return To Caller](audit-task-packet.md).

```

(注意:worker 要先 Read worker-report.md 看清 `## Review Result` 上方的精确内容,确保 Edit 的 old_string 唯一匹配。可能需要包含上一段的最后一行作为锚点。)

### 5. `references/templates/project-state.md` L38,43,53,58 — "Orient scans this" (D2)

四处 `← Orient scans this.` 全部改成 `← control agent scans this on Orient.`

用 replace_all 不行(四处文字完全相同,但 Edit replace_all 会全换——其实可以,因为目标文字也相同)。但为精确,逐处改或用 replace_all 均可。目标:四处 `← Orient scans this.` → `← control agent scans this on Orient.`

### 6. `references/templates/task-board.md` L3,L14,L20 — Orient 用法(D2)

**L3** 当前:
```
> 项目级入口表。一行一 Project。Orient 第一步读本表定位目标项目;任务详情进各项目的 `project_state.md`,不在此索引。
```
翻转:`Orient 第一步` → `control agent 在 Orient 第一步`

**L14** 当前:
```
- **updated**:最近一次进入该 Project 的日期。每次 Orient/Integrate 后更新。
```
翻转:`每次 Orient/Integrate 后` → `control agent 每次 Orient/Integrate 后`

**L20** 当前:
```
- **Orient(Stage 1)**:读本表 → 定位目标 project 行(用户指明 / 唯一活跃 / 最近 updated)→ `cd .enloom/<created>-<project>/` → 读该项目 `project_state.md`。
```
翻转:`**Orient(Stage 1)**:` → `**Orient(Stage 1)** — control agent reads this:` (其余不变)

### 7. `references/templates/task-packet.md` L7,L19 — make-prompt 被动语态(D2)

**L7** 当前片段:
```
The `make-prompt` self-check (workflow-steps Stage 3) enforces the **required** cells; optional cells may be left blank without blocking dispatch.
```
翻转成:
```
The control agent's `make-prompt` self-check (workflow-steps Stage 3) enforces the **required** cells; optional cells may be left blank without blocking dispatch.
```

**L19** 当前片段:
```
> **Self-check rule**: an `audited` packet missing Required Verification or Countable outputs fails `make-prompt` and cannot dispatch (Stage 3 gate). An `emergent` packet with Forbidden blank is still legal.
```
翻转成:
```
> **Self-check rule**: the control agent's `make-prompt` step rejects an `audited` packet missing Required Verification or Countable outputs — it cannot dispatch (Stage 3 gate). An `emergent` packet with Forbidden blank is still legal.
```

## Existing State

- P0+P0.5 已翻转核心叙事链(5 文件)。
- 本 task 的 7 处都是 P0 扫描里的 D2/P0 遗留,不在 P0 writable 范围。
- `audit-task-packet.md:63-65` 是 trim rule 的镜像基准。

## Allowed Tools

Read / Edit / Grep / Bash(grep 验证 + cp 同步)

## Writable Files

> 全部在源仓库下。改完后用 cp 同步到安装副本(见 Done Signal)。

源仓库 `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/`:
- `references/eval-guide.md`
- `references/templates/worker-report.md`
- `references/templates/project-state.md`
- `references/templates/task-board.md`
- `references/templates/task-packet.md`
- `prompt-assets/coder.md`

## Forbidden files

- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/**`
- 源仓库里不在 Writable 列表的文件(SKILL.md / 其他 references / researcher.md / reviewer.md / examples / archive-entry.md / audit-task-packet.md / phase-plan.md 等)
- 安装副本 `~/.agents/skills/enloom/`(只在 Done Signal 的 cp 同步步骤触碰,且只 cp writable 列表的 6 文件)

## Output Files

- `…/runs/P1/output.md` — 逐处改动记录
- `…/runs/P1/report.md` — Evidence Contract 四要素 + Review Result 留空

## Acceptance Criteria

1. 7 处全部翻转/补齐。
2. worker-report.md 含 "Return To Caller" trim rule 段。
3. 全 skill `grep -rin single-agent` 只命中新措辞正面表述(无旧叙事残留)。
4. 源仓库与安装副本的 6 个 writable 文件逐字节一致。

## Required Verification

| id | command | pass_condition | fail_signal |
|----|---------|----------------|-------------|
| V1 | `grep -rin "single-agent" /Users/bigo/.agents/skills/enloom/` (同步后跑) | 只命中新正面表述(glossary 的"不进入 worker mode"等),无旧叙事 | 旧叙事残留 |
| V2 | `grep -n "Return To Caller" enloom-skill/references/templates/worker-report.md` | ≥1 hit | 0 hit |
| V3 | `grep -rn "control agent scans this on Orient" enloom-skill/references/templates/project-state.md` | 4 hits | ≠4 |
| V4 | `diff -rq enloom-skill/references/ ~/.agents/skills/enloom/references/` + `diff -rq enloom-skill/prompt-assets/ ~/.agents/skills/enloom/prompt-assets/` (只看 writable 6 文件) | 6 文件无差异 | 有差异 |
| V5 | `grep -rn "the model\|hand the model" enloom-skill/references/eval-guide.md` | 0 hits(L25 已改) | ≥1 hit |

## Countable outputs

- 修改文件数 = 6(源仓库)
- 改动位置数 = 7(见 Inputs 编号;注意 #5 是 4 处同质,算 1 个位置类型)

## Sync Step (Done Signal 前)

改完源仓库 6 文件后,在 Done Signal 前执行同步:
```
for f in references/eval-guide.md references/templates/worker-report.md references/templates/project-state.md references/templates/task-board.md references/templates/task-packet.md prompt-assets/coder.md; do
  cp "enloom-skill/$f" "$HOME/.agents/skills/enloom/$f"
done
```
然后跑 V4 确认一致。

## Review Budget

只读 report.md + output.md。

## Done Signal

返回 done/blocked/failed + V1-V5 结果 + 源/副本一致性确认 + 路径。
