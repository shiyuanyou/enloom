# Enloom · Agent 工作指引

本文件讲 **agent 在这个仓库里怎么干活**。项目是什么、目录结构、子动作清单、版本状态见 [README.md](README.md)（SSOT）。本仓库是上层孵化器 `NewIdeas/` 下的一个独立子项目（见 `../AGENTS.md`）。

## SSOT 指引

| 要找什么 | 去哪 |
|----------|------|
| 项目是什么 / 目录 / 状态 | [README.md](README.md) |
| 可运行 skill 入口 | [enloom-skill/SKILL.md](enloom-skill/SKILL.md) |
| 生命周期 + 五铁律 | [enloom-skill/references/workflow-steps.md](enloom-skill/references/workflow-steps.md) |
| 证据契约 / 验收三态 | [enloom-skill/references/evidence-contract.md](enloom-skill/references/evidence-contract.md) |
| 状态治理（Registry/Ownership/Promise/Compaction） | [enloom-skill/references/registry-and-compaction.md](enloom-skill/references/registry-and-compaction.md) |
| 进度 / 下一步 / 未闭合风险 Registry | [PROGRESS.md](PROGRESS.md) |
| 设计文档（已归档） | [design/index.md](design/index.md) → `design/_archive/` |

进入仓库先读 README + PROGRESS § Registry（未闭合风险清单，Orient 必扫），再动手。

## 冻结证据 — 不要动

以下目录是**历史证据**，不是 bloat，改了就 falsify 历史：

- **`AgentOS/`** — v0.3 自举冻结快照（legacy 命名故意保留）。重命名或整理会破坏它作为「v0.3 前真实跑过」的凭据。
- **`.enloom/2026-06-30-*` / `2026-07-01-*` / `2026-07-06-*` 等 dogfood 项目目录** — 每个版本的自举痕迹。它们是各自版本的 dogfood 证据，保留为过程凭据。
- **`.clear-mind/`** — clear-mind skill 的分析过程产物，独立项目的工作痕迹。
- **`enloom-skill/report.md`** — v0.1 验收报告（历史），不改。

可以改的是：`enloom-skill/SKILL.md`、`enloom-skill/references/`、`enloom-skill/prompt-assets/`、`README.md`、`PROGRESS.md`、`AGENTS.md`、新建 `.enloom/<today>-<project>/`。

## 改 skill 的纪律

1. **源 / 副本同步**。`enloom-skill/` 是源，`~/.agents/skills/enloom/` 是已安装副本。改了源必须同步到副本（`cp` 改动文件），否则 host 加载的是旧版。这是 Law 5 之外的工程纪律——archive 不校验它，但不同步 = 改了个寂寞。
2. **改 `description` 字段前先想 trigger 影响**。description 是 skill 的触发门，改措辞可能改变 host 是否调用 enloom。历史上有 trigger-eval 20/20 基线（单模型、description-only），套件已删除（2026-07-09，跟不上 v0.6 后的迭代复杂度）。现在 trigger 行为靠真实任务 dogfood 验证。
3. **改 references 时查交叉引用**。references 间用 `§Section Title`（人读形式）引用，不用 `.md#slug` 锚点。改段标题前 `grep -r '<旧标题>' enloom-skill/` 确认引用方。被引最多的：`evidence-contract.md`（13 文件引）、`landing-contract.md`、`registry-and-compaction.md`。
4. **不改铁律 / 阶段骨架 / Evidence Contract 四要素**。这些是方法论不变量。改前先问：这是修订史 bloat（可去），还是规则本身（不可动）。

## 开发即 dogfood

enloom 用自己的机制治理自己的开发。改 skill 不是直接硬干——当改动命中触发器（≥2 个：多阶段 / 多 worker / 跨会话状态 / review 归档纪律）时，进 enloom 生命周期：

- `.enloom/task_board.md` 是入口表（一项目一行）
- 每个项目一个 `.enloom/<created>-<project>/` 目录，含 `project_state.md` + `tasks/` + `runs/` + `archive/`
- worker 产出落盘（`runs/<TASK>/task.md` + `output.md` + `report.md`），不只活在 context 里
- review 凭证据 PASS，不凭叙述

最近一次 dogfood：`.enloom/2026-07-09-repo-hygiene/`（元卫生清理，3 task 并行 PASS）。

## design/ 是归档区

`design/` 下的文档**全部已闭合**（v0.3/v0.4/v0.5 规格 + 设计演化 + 经验笔记），2026-07-09 归档到 `design/_archive/`，顶层留 `design/index.md` 作索引。活文档去 `enloom-skill/references/` 和 `PROGRESS.md`。归档文档只读不改——它们是「当时设计推理」的凭据。

## 不做

- 不做常驻后台 / CLI / scheduler / model resolver / 自动 worker runtime（skill 只给协议 + 纪律）
- 不维护独立 eval 套件（已删除，行为验证靠真实任务 dogfood）
- 不把一个项目的任务写进另一个项目的 SSOT
- 不为形式改而改——每个改动要有明确收益理由
