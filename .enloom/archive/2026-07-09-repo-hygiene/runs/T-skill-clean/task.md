# Task Packet: T-skill-clean

Task Packet Version: 0.2
Mode: recorded
Role: coder

## Goal

清理 `enloom-skill/references/` 下 8 个文件的版本标注 bloat（`(v0.x)` 内联标记），重组 glossary 为不分版本的单一术语段，并补两处实战暴露的方法论缝隙。改完 references 更精简易读，当前规则是什么清晰，不再混入"何时加入"的修订史。

## Anti Goal

- 不删任何术语条目（glossary 只重组，不减内容）
- 不改铁律语义/阶段骨架/Evidence Contract 四要素
- 不改 trigger description（SKILL.md frontmatter 的 description 字段不动）
- 不改 templates/（只查不改）
- 不为删而删——版本标注如果承载当前规则信息（非纯历史），保留或改写为无版本标注的当前语义

## Inputs

- `enloom-skill/references/*.md`（10 文件，其中 8 个有版本标注）
- 实战诊断：
  - 缝隙A（landing-contract §2/§5）：dispatch 握手描述偏理想化——说"worker 从磁盘读 task.md"，但前台 dispatch 实际把内容嵌进 prompt。gate 意图（durable artifact 存活）未破，补一句实现细节说明即可。
  - 缝隙B（registry-and-compaction §3）：Promise Registry 限同一 phase 内 worker 间前向声明；交付物按惯例自带的悬空引用（如 canon forward-declare）归 Accepted With Risk 或 Known Exceptions。补判别句。
- 版本标注分布（recon 实测）：
  - workflow-steps.md: 4 处 `(v0.5)` 标注（§Stage 3/§Stage 5/§Health Check 两档）
  - eval-guide.md: 4 处
  - evidence-contract.md: 3 处（§The Fifth Dimension / §Honest Blind Spots / §脚本执行坑引）
  - scheduler-rules.md: 2 处（§recon 调度 / §virtual parallelism）
  - review-checklist.md: 2 处
  - registry-and-compaction.md: 2 处（§4 Compaction / §3 Promise v0.5 决策表）
  - glossary.md: 2 处 + 4 个按版本分的段标题
  - landing-contract.md: 1 处

## Existing State

glossary.md 当前结构（5 段）：核心术语 / v0.3 新增 / v0.4 新增 / v0.5 新增 / 不要混用 / 版本对象。
目标结构：所有术语合并进一个 "术语表" 段（按逻辑分组，不按版本），保留 "不要混用" 和 "版本对象" 段。

## Allowed Tools

Read / Edit / Bash(grep, sed)

## Writable Files

- `enloom-skill/references/workflow-steps.md`
- `enloom-skill/references/evidence-contract.md`
- `enloom-skill/references/landing-contract.md`
- `enloom-skill/references/scheduler-rules.md`
- `enloom-skill/references/review-checklist.md`
- `enloom-skill/references/registry-and-compaction.md`
- `enloom-skill/references/glossary.md`
- `enloom-skill/references/eval-guide.md`

## Forbidden Files

- `enloom-skill/SKILL.md`（serial-integration，control 管）
- `enloom-skill/references/templates/*.md`（read-only，只查不改）
- `enloom-skill/prompt-assets/*.md`（不在本 task 范围）
- `README.md` / `PROGRESS.md`（T-progress-compact 管）
- `design/*`（T-design-archive 管）
- `.enloom/**`（control 管）
- `~/.agents/skills/enloom/**`（control post-verify 管）

## Output Files

无新建文件。改动全在上述 8 个 Writable Files。

## Acceptance Criteria

1. `grep -roE '\(v0\.[0-9][^)]*\)' enloom-skill/references/` 计数：从当前 22+ 降到 ≤5（仅保留承载当前规则语义、删了会丢失信息的少数标注，改写为无版本前缀的当前语义）
2. glossary.md 不再有 "v0.3 新增" / "v0.4 新增" / "v0.5 新增" 段标题，所有术语合并进单一 "核心术语" 或按逻辑分组（状态治理 / 命名空间 / 验证）的段
3. glossary.md 术语条目数 ≥ 原 30 条（不删内容，只重组）
4. landing-contract.md §2 或 §5 补一句 dispatch 握手的实现细节说明（缝隙A）
5. registry-and-compaction.md §3 补一句 Promise Registry vs 惯例悬空引用的判别（缝隙B）
6. references/ 下 .md 文件数 = 10（不变，不丢文件）
7. 交叉引用锚点（`#section`）不破坏——被 13 文件引用的 evidence-contract.md 的段标题不变或改后同步更新引用

## Required Verification

- `grep -roE '\(v0\.[0-9][^)]*\)' enloom-skill/references/ | wc -l` → 目标 ≤5
- `grep -c '^## ' enloom-skill/references/glossary.md` → 段数 ≤4（核心术语/逻辑子组/不要混用/版本对象）
- `ls enloom-skill/references/*.md | wc -l` → 10
- `grep -c 'Claim Consistency\|三态\|Ownership Table\|Registry\|Compaction\|Promise Registry\|health-check 两档\|virtual parallelism\|recon' enloom-skill/references/glossary.md` → 关键术语存活
- 内容标记：grep 'No PASS without Evidence' evidence-contract.md / grep 'three-tier' scheduler-rules.md / grep 'stage-transition hard gate' landing-contract.md → 均命中

## Countable outputs

- 版本标注计数（before/after）
- glossary 段数（before/after）
- glossary 术语条目数（before/after，确保不减）

## Evidence Required

每条 Acceptance Criteria 的 grep 命令输出。

## Review Budget

report.md 必读。output.md 不需要（无独立产物文件）。改动摘要表在 report 里即可。

## Pending / Promise Registry Updates

无。

## Human Decision Gate

无。方法论缝隙的补法已在上文描述清楚。

## Done Signal

`done` + report.md，含：每文件改了什么（摘要表）、版本标注 before/after 计数、glossary 重组说明、两处缝隙补句原文。
