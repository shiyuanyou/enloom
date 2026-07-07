# Phase Plan: Phase 3 — P2-recon 升格（reframe + recommended）

## Phase Goal

把 v0.5 down-scope 成"一段调度指引"的 recon，按 clear-mind reframe 终版（`.clear-mind/2026-07-07-p2-recon-deep/review.md` §6/§7）落成**人机决策门 + recommended 信号**——零结构改动（复用 phase-plan 既有 Human Decision + triage 接偏好），不碰 v0.5 红线。让"要不要 recon"从主窗口/Plan 的静默自觉，变成一道显式门（防决策被静默跳过，**不防**决策做错——诚实边界）。

## Anti Goal

- 不加 stage / 顶层字段 / Mode 枚举值 / Role 枚举值 / Pre-flight（v0.5 红线 + reframe 零结构原则）。
- 不为"其他用户习惯"优化（第一个用户原则：用户=作者，不接受者 fork）。
- 不改 design/ 历史文档（延续冻结决策）。
- 不动 art-lab / manual-trial 的 "the agent" 措辞（归 P3 清理，本 phase 是 P2-recon）。
- 不宣称 recon 能"防漏扫"（假性需求，跨方案恒定裂缝）。

## Constraints

- **源仓库优先**：Writable 指向 `enloom-skill/`（源），改完 worker 同步到 `~/.agents/skills/enloom/`（副本）。Done Signal 含 cp 同步 + diff 校验（沿用 P1 Sync Step 纪律）。
- **reframe 对齐**：五件 MVP 必须严格按 review §7 落，不得回退到 v1/v2 的"自动派"形态。
- **recommended 三信号**：Registry 无覆盖 / 新文件类型 / 规模边界不明——是 Plan 本来就在做的判断的副产物，非新工作量。

## Strategy

serial。五件交付物同性质（skill 源文件 + 模板 + eval 改动），但部分文件有交叉引用（scheduler-rules ↔ phase-plan Human Decision），1 个 task packet 全包更利于一致性。worker 按文件 batch 切分内部串行。

## Ownership Table

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/2026-07-06-enloom-v06/project_state.md` + task_board.md | 控制 agent 独占 |
| 并行写 | `enloom-skill/` 下 P2 文件（researcher.md / scheduler-rules.md / templates/phase-plan.md / evals/evals.json / references/eval-guide.md） | P2-worker 独占 |
| 只读 | `design/`、前序项目目录、`.clear-mind/`、其他 skill 文件 | 谁都不改 |

## Reference Tolerance Decision Table (v0.5)

| Reference type in this project | Tolerates dangling? | Handling | Forces serial? |
|--------------------------------|---------------------|----------|----------------|
| markdown links `[x](path)` | yes | grep target exists at verify | no |
| cross-ref `scheduler-rules.md:53` 风格 | yes | 行号会漂，verify 时 grep 内容锚点 | no |

**Decision**: yes（本 phase 全是 markdown 内部交叉引用，容忍悬空，verify 时 grep 内容锚点）。

## Promise Registry Draft

| declarer | identifier | consumers | verify_at | status |
|----------|-----------|-----------|-----------|--------|
| P2-C | scheduler-rules recon 升格段引用 phase-plan Human Decision | P2-A | Verify | promised |
| P2-A | phase-plan Human Decision recon 行引用 scheduler-rules recon 指引 | P2-C | Verify | promised |

> 双向交叉引用——P2-A 和 P2-C 互相 reference。两者都在同一 task packet 内，worker 一次性处理，无悬空风险。

## Tasks

| ID | Task | Mode |
|----|------|------|
| P2 | 五件 MVP：①phase-plan.md Human Decision recon 行 + Gate Check recon considered 行 ②triage 接 recon 偏好 ③scheduler-rules.md recon 升格 + recommended 三信号 ④researcher.md How-to-work recon 产物分支 ⑤evals.json case 10 + eval-guide.md 表格 | audited |

## Review Plan

- `grep -rn "recon considered" enloom-skill/` → phase-plan 模板命中
- `grep -rn "recommended" enloom-skill/references/scheduler-rules.md` → 三信号规则命中
- `grep -rn "recon" enloom-skill/prompt-assets/researcher.md` → How-to-work 分支命中
- `grep -n '"id": 10' enloom-skill/evals/evals.json` → case 10 存在
- `grep -n "recon" enloom-skill/references/eval-guide.md` → 表格更新
- Claim Consistency：声称 5 文件改动，git diff --stat 独立复核
- 源/副本一致：`diff -r enloom-skill/ ~/.agents/skills/enloom/` 改动文件无差异
- **reframe 对齐核查**：五件 MVP 严格匹配 review §7，无 v1/v2"自动派"残留（grep "自动派"/"first task 自动"应为 0）

## Human Decisions Needed

- **recon considered（本 phase 自身）: yes** —— 本 phase 改的文件结构已通过 clear-mind explore 实读（researcher.md / phase-plan.md / scheduler-rules.md / evals.json / eval-guide.md / task-packet.md），Registry 有 v0.6 dogfood 覆盖（P0/P0.5/P1 已记录），属熟域。**跳过 recon sub-agent，主窗口（本控制 agent）已持材料。** 这正是 reframe 规则的示范：有把握 → 跳过；只是把决策显式记下来。

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes（Review Plan 7 条 grep + diff）
- Parallel ownership is defined if needed: not-needed（serial）
- Promise Registry drafted if forward declarations exist: yes（P2-A ↔ P2-C 双向）
- **Landing gate confirmed**: this phase-plan is written to `tasks/phase-plan-3.md` (Stage 2 exit gate): yes
