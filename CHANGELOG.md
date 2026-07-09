# Changelog · 版本历史

Enloom 的版本演进日志。每版一行结论 + 入口 commit；细节 `git show <hash>` 或查对应 dogfood 痕迹。活文档（当前状态、未闭合风险、非目标）不在本文件，去 [PROGRESS.md](PROGRESS.md)。

| 版本 | 日期 | 一行结论 | 入口 commit |
|------|------|----------|-------------|
| v0.6 | 2026-07-07 | dispatch-default 翻转（Stage 3 默认派 sub-agent，无能力即中断）+ recon 升格为 Plan 首个 task packet | `e71f686` |
| v0.5 | 2026-07-01 | dev-wiki 交叉评审裁决版：compaction 强制闸门 + 三项诚实盲区 + health-check 两档 + Claim Consistency 第 5 维 | `8b63cc6` |
| v0.4 | 2026-06-30 | 双腿：项目级命名空间（`.enloom/` task_board + 每项目目录）+ 落盘时序契约（Stage 闸门 + Law 2/5 机械化） | `17ba308` |
| v0.3.3 | 2026-06-29 | 纯重命名 `AgentOS/agentos-workflow` → Enloom，零功能改动；全局重装 25 文件 | `37d8d49` |
| v0.3.2 | 2026-06-29 | 吸收认识论纪律 + 修复计划纪律（art_lab `.research/`）→ prompt-control.md 加 §4/§5 | `66110a9` |
| v0.3.1 | 2026-06-29 | 吸收路由预填 / 多层派发失真 / 脚本坑（art_lab 06-24 后新经验）→ 新 reference prompt-control.md | `66110a9` |
| v0.3 | 2026-06-24 | 自举重写：操作菜单 → 生命周期 6 阶段，内化 art_lab 五块硬经验；Path B 独立盲测 9/9 PASS | `12b7eea` |
| v0.2 | 2026-06-17 | 补 eval 套件 + 5 references + 3 Worker 角色（researcher/coder/reviewer）+ skill-creator 闭环 | `e473679` |
| v0.1 | 2026-06-15 | 纯文档 skill 初版完成（SKILL.md + 5 模板，零可执行代码）；手工 trial 三类路径 PASS | `8406c80` |

---

## 2026-07-09 归档整理 — 冻结目录清理出顶层

延续 repo-hygiene 的清理，把三个不活跃的冻结目录从顶层归档，仓库根目录更干净。所有移动用 `git mv`，git rename 历史完整保留，证据真实性不受影响。

1. **`AgentOS/` → `design/_archive/AgentOS/`** — v0.3 自举快照整目录归档，内部 45 文件 / legacy 命名 / 200+ 自引用全部不动。运行包 `enloom-skill/` 对它零依赖。
2. **`.clear-mind/` → `design/_archive/clear-mind/`** — clear-mind skill 历史工作痕迹（2026-07-02 ~ 2026-07-07）归档。注意 `workflow-steps.md` 里 `.clear-mind/<project>/review.md` 是 clear-mind 的活输出路径，给未来新产物用——归档的只是历史内容。
3. **`.enloom/` 5 个 closed 项目 → `.enloom/archive/`** — v04/v05/v06/clearmind-align/repo-hygiene 从 `.enloom/` 顶层折叠到 `.enloom/archive/`；`task_board.md`（用名字索引）留原地。
4. **AGENTS.md 规则同步** — 原「冻结证据 — 不要动」段改为「归档证据 — 正文不改」：位置更新、保护逻辑（正文不动，靠 git 历史）保留，消除「不要整理」与「已归档移动」的自相矛盾。
5. **新增 `fold` 机制（项目级折叠）** — 上面第 3 点手工折叠催生的方法论缺口：现有 archive 只有 phase 级（`archive/<phase>-entry.md`），没有 project 级。新增 `fold` sub-action：Stage 0 Triage 时 closed 项目堆积 ≥3 → 派 sub-agent 把目录从 `.enloom/` 顶层 mv 到 `.enloom/archive/`，task_board 行不动。本次 5 项目折叠即其 worked example。落点：archive-policy.md §Project Fold + workflow-steps §Stage 0 + SKILL.md sub-action 表 + glossary/task-board 模板。
6. **v0.3.3 旧单状态遗留物归档** — `.enloom/project_state.md`（冻结 v0.3.3 单状态）+ `.enloom/runs/`（trigger-eval）是 v0.4 命名空间规矩前的遗留，散在 `.enloom/` 根目录不合规矩。移到 `.enloom/archive/2026-06-24-v033-rename/`，`.enloom/` 根目录现在只剩 `task_board.md` + `archive/`。注：该 project_state.md 正文里的 `AgentOS` 是 v0.3.3 重命名项目「当时在做什么」的历史事实，非过时引用，按「归档证据—正文不改」保留。

---

## v0.6（2026-07-07）— dispatch-default 翻转 + recon 升格

来自实跑诊断（worker task 被主窗口直接做，而非 dispatch 给 sub-agent）。dogfood 痕迹：`.enloom/archive/2026-07-06-enloom-v06/`。

1. **Dispatch-default 翻转 (P0+P0.5)** — Stage 3 task 默认 dispatch 给 sub-agent；无能力即中断（提示换 opencode/pi/codex），不退化、不自执行、不污染 prompt。主窗口职责限定为 triage/orient/plan/review/integrate/archive + 串行集成区写入。六处叙事同批改（glossary / evidence-contract / landing-contract / scheduler-rules / worker-report）。
2. **命名硬化 + trim rule (P1)** — 7 处措辞硬化（references / coder / worker-report / project-state / task-board / task-packet）。worker-report trim rule：control agent 收 worker 回报只收 Result + Checks summary + verdict-level evidence + named risks，raw output 落 output.md。
3. **recon 升格 (P2)** — recon 从「主窗口顺手做」升格为 Plan 阶段的第一个 sub-agent task packet；phase-plan 加 Human Decision、triage 偏好透传、scheduler-rules 三信号、researcher 分支、eval case 10。
4. **清理 (P3)** — archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 措辞对齐。

**Non-Goals**：virtual parallelism 盲区保留（声明 parallel ≠ 真并发）；六阶段骨架/五铁律/Evidence Contract 四要素不变。

git: `e71f686`(P0+P0.5) → `b675c30`(P1) → `5dc33d8`(P2) → `e43f6d1`(P3)

---

## v0.5（2026-07-01）— dev-wiki 交叉评审裁决版

来自对 enloom v0.4 的 dev-wiki knowledge-base 交叉评审，三轴裁决（机制对 / 框架对 / 时机对）。dogfood 痕迹：`.enloom/archive/2026-07-01-enloom-v05/`，设计输入 `design/_archive/2026-07-01-enloom-v0.5-optimization-design.md`。

1. **Compaction mandatory gate (S5, HIGH)** — compaction 从可选「check the trigger」升级为 Integrate 出口强制闸门：阈值命中 → 必须跑，不许 defer。堵住「可选检查让 Registry 无限膨胀」的漏洞。阈值标注「heuristic, not dogma」。
2. **Three honest blind spots (X2, HIGH)** — 单一「无独立运行时」盲区扩为三项：cross-worker isolation、cross-role verification（verdict/review/audit 可能同 context）、**virtual parallelism**（单 agent `strategy: parallel` 只是协议形式）。最后一项是评审新发现的盲区，经验基础在 `scheduler-rules.md`。
3. **health-check two-tier (S4, MID)** — 拆成 light tier（stage 转移：只查文件存在性，单行确认）和 full tier（Orient + 周期 Verify：九项扫描）。硬闸门语义不变，执行成本降低。
4. **Claim Consistency, 5th Evidence dimension (S1, MID)** — report-vs-output 数量一致性检查（NOT「sub-agent count verification」——那误名了单 agent 现实）。`audited` mode 必填。
5. **Reference tolerance decision table (S6, LOW)** — phase-plan 脚手架（≥3 reference-type 例子）让 dangling-reference tolerance 判断不用每个项目重新推导。
6. **Mode-differentiated field density (S7, LOW)** — task-packet 字段按 mode 分密度：`emergent` 可空 Forbidden；`audited` 必填 Verification + Countable outputs，否则 make-prompt 自检不过。
7. **Recon scheduling guidance (S2, LOW)** — scheduler-rules 指引：不熟域 → 首个 task 是 recon task。不新增 stage / 字段 / 术语。

**Non-Goals (review-added)**：异构任务分组（S3）；正式 enloom↔clear-mind 失败降级协议（X1）；Pre-flight 子阶段（S2 降为指引）。

---

## v0.4（2026-06-30）— 项目级命名空间 + 落盘时序契约

来自实跑诊断的两条腿。dogfood 痕迹：`.enloom/2026-06-30-enloom-v04/`，设计输入 `design/_archive/v0.4-project-namespace-spec.md`。

1. **项目级命名空间** — `.enloom/` 重组为 `task_board.md`（入口表）+ 每项目目录（`<created>-<project>/`），项目隔离。
2. **落盘时序契约（landing-contract）** — 每个 stage 加 entry/exit 闸门；机械化 Law 2 & 5，让 worker 产出真实落盘。

---

## 外部 review 闭合记录（2026-07-01）

来自对 enloom × clear-mind 组合的外部 review，三条均已闭合（v0.5 落地，`2378de1`）：

- trigger-contract 加 Clear-Mind 建议句
- Orient 承认可选读 `.clear-mind/<project>/review.md`
- landing-contract 盲区对齐成三项（指向 evidence-contract 为 SSOT）

**原则（不实现）**：保持 enloom × clear-mind 正交，不做正式双向失败降级协议。

---

## 深层历史索引

- **设计文档**（v0.3/v0.4/v0.5 规格 + 设计演化 + 经验笔记）：[design/index.md](design/index.md) → `design/_archive/`
- **v0.3 自举冻结快照**（legacy 命名 `AgentOS/`，故意保留）：`AgentOS/`
- **各版本 dogfood 痕迹**：`.enloom/<date>-<project>/`（如 `2026-07-06-enloom-v06/`、`2026-07-01-enloom-v05/`、`2026-06-30-enloom-v04/`）
- **v0.1 验收报告**（历史归档）：`design/_archive/2026-06-15-v01-acceptance-report.md`
- **文件级历史**：`git log --oneline` 或 `git show <commit>`
