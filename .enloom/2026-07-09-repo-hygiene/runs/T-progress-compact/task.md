# Task Packet: T-progress-compact

Task Packet Version: 0.2
Mode: recorded
Role: integrator

## Goal

对 `PROGRESS.md` (249 行) 和 `README.md` 状态段做一次 compaction——压缩已闭合的历史过程细节，同时为 dev repo 补一个 Registry 风险段（最强的 dogfood：用 enloom 自己的 Registry 机制治自己的状态 bloat）。

## Anti Goal

- 不删历史事实（v0.1~v0.6 的存在和顺序保留），只压缩其过程细节
- 不改 README 的 skill 定义/功能描述（§What it is / §How it works / §Five Laws 不变）
- 不改 README 的 Install 段
- compaction 不碰未闭合风险——README 的 honest blind spot 段保留且强化
- PROGRESS.md 历史段压缩后仍可追溯到 git log（一行结论 + commit hash）

## Inputs

- `PROGRESS.md` (249 行)：顶部当前状态(v0.6) + 外部review待办 + v0.4/v0.3.3/v0.3.x/v0.3/v0.2/v0.1 全历史
- `README.md` (183 行)：§Status 段含 v0.6~v0.1 版本历史 + honest blind spot
- 诊断：PROGRESS.md 是 enloom 自己 compaction 原则的教科书违规——记"完成了什么"，未闭合风险散落各处

## Existing State

PROGRESS.md 当前形态：249 行，90% 是历史，顶部 10% 是当前。正是 Compaction Protocol §4 的场景（resolved process detail 该压缩）。
README §Status：6 个版本块逐个展开，每个含完整变更列表。honest blind spot 在最末。

## Allowed Tools

Read / Edit / Write

## Writable Files

- `PROGRESS.md`
- `README.md`

## Forbidden Files

- `enloom-skill/**`（不碰 skill 包）
- `design/**`（T-design-archive 管）
- `.enloom/**`（control 管）

## Output Files

无新建文件。

## Acceptance Criteria

1. PROGRESS.md 行数从 249 降到 ≤120（至少 50% 压缩）
2. PROGRESS.md 顶部"当前状态"段完整保留 v0.6 信息
3. PROGRESS.md 历史段压缩为：每个版本一行结论 + commit hash 指针（可 `git show` 追溯）
4. PROGRESS.md 新增 "Registry — 未闭合风险" 段，集中当前所有已知风险（跨模型 trigger 未验 / 第二领域泛化未证 / prompt-assets 是否 load-bearing / eval ROI 存疑 / compaction Protocol 未实战——最后一条本次执行恰好验证）
5. README §Status 段压缩：最近 2 版本(v0.6/v0.5)保留要点，更早版本(v0.4~v0.1)合并为 1-2 行指针到 PROGRESS/git log
6. README honest blind spot 段保留，并新增指向 PROGRESS.md Registry 段的引用
7. README 的 skill 功能描述段（What it is / How it works / Five Laws / Core mechanisms）不变

## Required Verification

- `wc -l PROGRESS.md` → ≤120
- `grep -c '当前状态\|Registry.*未闭合\|跨模型\|第二领域\|prompt-assets\|eval ROI' PROGRESS.md` → 风险段关键标记存在
- `grep -c 'v0.6\|dispatch-default\|recon' PROGRESS.md` → 当前状态存活
- README `grep 'What it is\|How it works\|Five Laws\|Core mechanisms'` → 功能段不变
- README `grep 'honest blind spot\|Registry' ` → 盲区段 + Registry 指针存活

## Countable outputs

- PROGRESS.md 行数（before 249 / after）
- README 行数（before 183 / after）
- Registry 风险条目数（after，目标 4-6 条）

## Evidence Required

wc -l before/after + grep 关键标记。

## Review Budget

report.md 必读。

## Done Signal

`done` + report.md，含：PROGRESS before/after 行数、Registry 风险清单、README §Status 压缩说明、honest blind spot 保留确认。
