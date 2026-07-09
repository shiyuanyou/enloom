# Enloom · 进度

本文只讲**进度、状态、下一步**。项目是什么、怎么用、目录结构见 [README.md](README.md)（SSOT）。设计推导见 [design/](design/)。

> 一句话定位：Enloom 是轻量级控制面 workflow skill——A methodology for orchestrating complex AI work。给 agent 处理太大、状态太多、单次上下文装不下的长任务。只给文件协议 + 决策纪律，**不给** scheduler / CLI / model resolver / 自动 worker runtime。

> **本文档自身的 dogfood 说明**：本文件曾违反 enloom 自己的 Compaction Protocol（249 行、90% 是已闭合历史）。本次（2026-07-09）首次实战 Compaction Protocol——历史段从「完整变更列表」压缩为「一行结论 + commit hash 指针」。读者要细节可 `git show <hash>`。

## 当前状态

**v0.6 已完成**（2026-07-07）。**dispatch-default 翻转 + recon 升格**——来自实跑诊断（worker task 被主窗口直接做，而非 dispatch 给 sub-agent）：

1. **Dispatch-default 翻转 (P0+P0.5)** — Stage 3 task 默认 dispatch 给 sub-agent；无能力即中断不退化。六处叙事翻转：glossary / evidence-contract ×2 / landing-contract §5 / scheduler-rules / worker-report。
2. **命名硬化 + trim rule (P1)** — 7 处措辞硬化。worker-report trim rule：control agent 只收 Result + Checks summary + verdict-level evidence + named risks。
3. **recon 升格 (P2)** — recon 从主窗口顺手做 → Plan 第一个 sub-agent task packet。phase-plan Human Decision + triage 偏好透传 + scheduler-rules 三信号 + researcher 分支 + eval case 10。
4. **清理 (P3)** — archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 措辞。

dogfood 落在 `.enloom/2026-07-06-enloom-v06/`。**零回归**：六阶段骨架 / 五铁律 / Evidence Contract 四要素 / virtual parallelism 盲区全保留。

- git: `e71f686`(P0+P0.5) → `b675c30`(P1) → `5dc33d8`(P2) → `e43f6d1`(P3)

## Registry — 未闭合风险

> 这是 enloom 自己 Registry 机制的自指应用：把所有「已知但未闭合」的风险集中在这里，**compaction 不得压缩本段**（Compaction Protocol §4 防错规则）。Orient 必扫。

1. **跨模型 trigger 未验证** — 历史 trigger-eval 20/20（套件已于 2026-07-09 删除，见 #4）只在 deepseek-v4-pro 单模型验过（description-only fresh-context 盲跑）。换 Claude / GPT 系是否会过 trigger、判对 near-miss，未经测试。
2. **第二领域泛化未证明** — 所有五块硬经验（Registry / Evidence Contract / Ownership+Promise / Compaction / Audit）+ prompt-control 三块经验，全部来自 art_lab wiki ingest **单一领域**（知识型长任务）。纯工程任务（代码迁移 / 数据处理）的适用性是 deferred 项。
3. **prompt-assets 是否 load-bearing 存疑** — `enloom-skill/prompt-assets/` 下的 researcher / coder / reviewer 角色资产，实战中是否真被 host 加载并影响 worker 行为，未经原生运行时验证。历史 eval 不覆盖此处（套件已删除，见 #4）。
4. **~~eval 套件 ROI 存疑~~（已闭合 2026-07-09）** — 27 个 eval 文件（9-case 决策 suite + 20-query trigger suite）是 description-only unit test，**非 host 原生 trigger 集成测试**。已跟不上 v0.6 后的迭代复杂度与 dogfood 实战密度，套件整体删除（源仓库 + 已安装副本）。后续行为验证靠真实任务 dogfood，不维护独立 eval 套件。
5. **virtual parallelism 盲区（v0.5 新增）** — 单 agent 环境下 `strategy: parallel` 只是协议形式，非真并发。cross-worker isolation 与 cross-role verification（verdict/review/audit 可能同 context）均未独立验证。
6. **compaction 防错规则实战中首验** — Compaction Protocol 此前一直标注「未实战」。**本次执行恰好验证**：风险区段（本段）条目数不减少（6 条），已闭合过程细节（版本历史）被压缩。防错规则首次有了实证样本。

## 版本历史

> 每版一行结论 + commit hash。完整变更列表 `git show <hash>` 或查对应 `.enloom/<date>-enloom-v0X/` dogfood 痕迹。历史事实与顺序保留，只压缩过程细节。

| 版本 | 日期 | 一行结论 | 入口 commit |
|------|------|----------|-------------|
| v0.6 | 2026-07-07 | dispatch-default 翻转（Stage 3 默认派 sub-agent，无能力即中断）+ recon 升格为 Plan 首个 task packet | `e71f686` |
| v0.5 | 2026-07-01 | dev-wiki 交叉评审裁决版：compaction 强制闸门 + 三项诚实盲区 + health-check 两档 + Claim Consistency 第 5 维 | `8b63cc6` |
| v0.4 | 2026-06-30 | 双腿：项目级命名空间（`.enloom/` task_board + 每项目目录）+ 落盘时序契约（Stage 闸门 + Law 2/5 机械化） | `17ba308` |
| v0.3.3 | 2026-06-29 | 纯重命名 `AgentOS/agentos-workflow` → Enloom，零功能改动；全局重装 25 文件，trigger-eval 重跑 20/20 | `37d8d49` |
| v0.3.2 | 2026-06-29 | 吸收认识论纪律 + 修复计划纪律（art_lab `.research/`）→ prompt-control.md 加 §4/§5 | `66110a9` |
| v0.3.1 | 2026-06-29 | 吸收 P7 路由预填 / P8 多层派发失真 / 脚本坑（art_lab 06-24 后新经验）→ 新 reference prompt-control.md | `66110a9` |
| v0.3 | 2026-06-24 | 自举重写：操作菜单 → 生命周期 6 阶段，内化 art_lab 五块硬经验；Path B 独立盲测 9/9 PASS | `12b7eea` |
| v0.2 | 2026-06-17 | 补 eval 套件 + 5 references + 3 Worker 角色（researcher/coder/reviewer）+ skill-creator 闭环 | `e473679` |
| v0.1 | 2026-06-15 | 纯文档 skill 初版完成（SKILL.md + 5 模板，零可执行代码）；手工 trial 三类路径 PASS | `8406c80` |

设计输入与 dogfood 痕迹：v0.6 `.enloom/2026-07-06-enloom-v06/`、v0.5 `design/_archive/2026-07-01-enloom-v0.5-optimization-design.md` + `.enloom/2026-07-01-enloom-v05/`、v0.4 `design/_archive/v0.4-project-namespace-spec.md` + `.enloom/2026-06-30-enloom-v04/`、v0.3 `design/_archive/v0.3-lifecycle-spec.md` + `AgentOS/`（冻结快照）、v0.2/v0.1 见 `AgentOS/runs/`。

## 外部 review 闭合记录（2026-07-01）

来自对 enloom × clear-mind 组合的外部 review，三条均已闭合（v0.5 落地，`2378de1`）：trigger-contract 加 Clear-Mind 建议句 / Orient 承认可选读 `.clear-mind/<project>/review.md` / landing-contract 盲区对齐成三项（指向 evidence-contract 为 SSOT）。**原则（不实现）**：保持 enloom × clear-mind 正交，不做正式双向失败降级协议。

## 不做的事

引用 `design/design-summary.md` 与 `design/skill-workflow-draft.md` 的 Non-Goals：

- 不做常驻后台——需要时介入，完成后退场
- 不做自动模型选择
- 不做复杂 DAG 引擎
- 不做无限 sub-agent 嵌套
- 不做全自动修复（health-check 只报告 + 提最小下一步，不自动改）
- 不强制所有任务都进入 Enloom（能直接做就直接做）
- 不做 CLI / scheduler / model resolver / 自动 worker runtime（skill 只给协议 + 纪律）

## 相关文档

| 文档 | 是什么 |
|------|--------|
| [README.md](README.md) | 项目 SSOT——是什么、目录、子动作清单、状态 |
| [enloom-skill/SKILL.md](enloom-skill/SKILL.md) | 可运行 skill 入口，生命周期 6 阶段 + 文件协议 |
| [enloom-skill/references/workflow-steps.md](enloom-skill/references/workflow-steps.md) | 生命周期 6 阶段完整工作流 + 五条铁律 |
| [enloom-skill/references/evidence-contract.md](enloom-skill/references/evidence-contract.md) | 证据契约四要素 + 三态 verdict |
| [enloom-skill/references/registry-and-compaction.md](enloom-skill/references/registry-and-compaction.md) | Registry/Ownership/Promise/Compaction 状态治理 |
| [design/index.md](design/index.md) | design/ 归档区入口——7 份已闭合设计文档的索引（v0.3/v0.4/v0.5 规格 + 设计演化 + 经验笔记），全部在 `design/_archive/` |
