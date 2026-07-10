# Enloom · 进度

本文只讲**当前状态、未闭合风险、下一步**。项目是什么、怎么用、目录结构见 [README.md](README.md)（SSOT）。版本历史见 [CHANGELOG.md](CHANGELOG.md)。设计推导见 [design/](design/)。

> 一句话定位：Enloom 是轻量级控制面 workflow skill——A methodology for orchestrating complex AI work。给 agent 处理太大、状态太多、单次上下文装不下的长任务。只给文件协议 + 决策纪律，**不给** scheduler / CLI / model resolver / 自动 worker runtime。

## 当前状态

**v0.6 已完成**（2026-07-07）。版本历史与变更细节见 [CHANGELOG.md](CHANGELOG.md)。

## Registry — 未闭合风险

> 这是 enloom 自己 Registry 机制的自指应用：把所有「已知但未闭合」的风险集中在这里，**compaction 不得压缩本段**（Compaction Protocol §4 防错规则）。Orient 必扫。

1. **跨模型 trigger 未验证** — 历史 trigger-eval 20/20（套件已于 2026-07-09 删除，见 #4）只在 deepseek-v4-pro 单模型验过（description-only fresh-context 盲跑）。换 Claude / GPT 系是否会过 trigger、判对 near-miss，未经测试。
2. **第二领域泛化未证明** — 所有五块硬经验（Registry / Evidence Contract / Ownership+Promise / Compaction / Audit）+ prompt-control 三块经验，全部来自 art_lab wiki ingest **单一领域**（知识型长任务）。纯工程任务（代码迁移 / 数据处理）的适用性是 deferred 项。
3. **prompt-assets 是否 load-bearing 存疑** — `enloom-skill/prompt-assets/` 下的 researcher / coder / reviewer 角色资产，实战中是否真被 host 加载并影响 worker 行为，未经原生运行时验证。历史 eval 不覆盖此处（套件已删除，见 #4）。
4. **~~eval 套件 ROI 存疑~~（已闭合 2026-07-09）** — 27 个 eval 文件（9-case 决策 suite + 20-query trigger suite）是 description-only unit test，**非 host 原生 trigger 集成测试**。已跟不上 v0.6 后的迭代复杂度与 dogfood 实战密度，套件整体删除（源仓库 + 已安装副本）。后续行为验证靠真实任务 dogfood，不维护独立 eval 套件。
5. **virtual parallelism 盲区** — 单 agent 环境下 `strategy: parallel` 只是协议形式，非真并发。cross-worker isolation 与 cross-role verification（verdict/review/audit 可能同 context）均未独立验证。
6. **compaction 防错规则实战中首验** — Compaction Protocol 此前一直标注「未实战」。**本次执行恰好验证**：风险区段（本段）条目数不减少（6 条），已闭合过程细节（版本历史）被压缩。防错规则首次有了实证样本。

## 不做的事

引用 `design/_archive/design-summary.md` 与 `design/_archive/skill-workflow-draft.md` 的 Non-Goals：

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
| [CHANGELOG.md](CHANGELOG.md) | 版本历史——每版一行结论 + 入口 commit + 变更细节 |
| [enloom-skill/SKILL.md](enloom-skill/SKILL.md) | 可运行 skill 入口，Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6) + 文件协议 |
| [enloom-skill/references/workflow-steps.md](enloom-skill/references/workflow-steps.md) | Stage 0 Triage 入口决策 + 六阶段生命周期(Stages 1–6)完整工作流 + 五条铁律 |
| [enloom-skill/references/evidence-contract.md](enloom-skill/references/evidence-contract.md) | 证据契约四要素 + 三态 verdict |
| [enloom-skill/references/registry-and-compaction.md](enloom-skill/references/registry-and-compaction.md) | Registry/Ownership/Promise/Compaction 状态治理 |
| [design/index.md](design/index.md) | design/ 归档区入口——已闭合设计文档的索引，全部在 `design/_archive/` |
