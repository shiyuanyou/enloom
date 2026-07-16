# Enloom

> 一套编排复杂 AI 工作的方法论。

Enloom 是一个轻量级**控制面** workflow skill——给 agent 处理那些太大、状态太多、单次上下文装不下的长任务。只在不该直接硬干时才进入：需要分阶段目标、worker 任务包、基于证据的 review、状态压缩、归档纪律时。

> Enloom **不提供** scheduler / CLI / model resolver / 自动 worker 运行时。它只给 agent 一套文件协议 + 决策纪律。任务能直接做完就直接做。

---

## 它是什么

一套基于 markdown 的方法论，让编排者在长任务中**极薄但永不失明**。核心洞察来自一次真实大规模任务：只记录"已完成什么"的状态会留下系统性盲区。真正能让你恢复项目的是**未闭合风险清单**。Enloom 就是围绕守住这份清单建的。

## 何时不该直接硬干

**使用 Enloom**，当**命中 ≥2 个以下触发器时**：
- 预计超过 3 个阶段
- 需要 2 个以上 worker 或角色
- 需要跨会话状态
- 需要 review、归档或复盘纪律
- 上下文可能膨胀到影响判断
- 产物会成为长期资产

**不要用于**：单文件小改动、明确 bug fix、一次性脚本、明确答案型问答。

> 只有一个触发器命中 → `light-plan`（简短计划，不建文件）。零触发器命中 → `direct`（直接做）。

## Stage 0 Triage + 六阶段生命周期（Stages 1–6）

```
0. Triage    → direct / light-plan / enter lifecycle   判断是否进入
1. Orient    → read project_state + Registry risk sections   恢复状态（必扫风险区段）
2. Plan      → phase goal + Ownership Table + Promise Registry   只规划当前阶段
3. Execute   → make task packet / dispatch / worker plays inside boundary   派 worker
4. Verify    → review report + audit packet + Evidence Contract gate   凭证据验收
5. Integrate → update project_state + Registry + compaction check   压缩进状态
6. Close     → archive + closure check + user report   归档退出
```

**五条铁律**
1. 无触发器不进入。
2. 无任务包不派 worker。（派发闸门要求 `task.md` 已存在）
3. 无所有权表不并行。（三阶模型）
4. 无证据不得 PASS。（Evidence Contract 硬约束）
5. 无状态更新不归档。（归档闸门要求每个 review-result.md 已存在）

## 核心机制

| 机制 | 一句话 |
|---|---|
| **Registry（七区段）** | 让 project_state 成为活的可恢复真相的未闭合风险清单。 |
| **Evidence Contract** | 四要素 + 三态验收；无证据的 PASS 自动降级。 |
| **Ownership Table** | 三阶文件所有权，让并行安全。 |
| **Promise Registry** | 前向声明产出 + 容忍悬空引用 + 末尾验收。 |
| **Compaction Protocol** | 压缩已决过程细节，绝不压缩未闭合风险。 |

---

## 状态

**v0.6**（2026-07-07）。版本历史与变更细节见 [CHANGELOG.md](CHANGELOG.md)。未闭合风险见 [PROGRESS.md § Registry](PROGRESS.md)。

## 安装

Skill 名称：`enloom`。全局安装于 `~/.agents/skills/enloom/`。通过 `description` 触发；在任意加载 skill 的 agent 运行时中调用即可。

支持的安装方式为从源复制到 agent 主目录（与开发中使用的同步方式相同）。在仓库根目录执行：

```bash
# 安装：复制 skill 源到 agent 主目录
cp -r enloom-skill/ ~/.agents/skills/enloom/
```

安装后验证源与副本一致：

```bash
# 验证源与副本一致
diff -qr enloom-skill/ ~/.agents/skills/enloom/
```

干净 `diff`（无输出，exit 0）表示已安装副本与源一致。源有变动后重新执行 `cp` 以保持同步。

可运行 skill 包见 [enloom-skill/](enloom-skill/)。

## 两个目录，两个"看见"主体

| 目录 | 装什么 | 谁看 |
|---|---|---|
| `enloom/`（本仓库） | skill 源码、设计文档、进度——开发仓库。 | 你（开发者） |
| `.enloom/`（用户项目中） | 运行时工作文件；v0.4 起按项目隔离 + 落盘时序契约。默认隐藏。 | 终端用户（默认看不到） |

## 目录

```
enloom/
├── README.md                          本文件
├── AGENTS.md                          agent 工作指引（可改 / 冻结）
├── PROGRESS.md                        进度、下一步
├── .enloom/                           ★ 自举工作区（v0.4 命名空间：task_board + 按项目分目录）
│   ├── task_board.md                    项目级入口表（v0.4）
│   └── archive/                         已闭合自举项目折叠于此（fold 机制目标）
├── enloom-skill/                      ★ 可运行 skill 包
│   ├── SKILL.md                         skill 入口
│   ├── references/                      生命周期 + 合约 + 模板 + 示例
│   │   ├── workflow-steps.md            六阶段生命周期 + 五铁律 + 阶段闸门
│   │   ├── landing-contract.md          ★ v0.4 阶段闸门 + control↔worker 握手
│   │   ├── trigger-contract.md          何时进入 / 绕过 / 模糊情况
│   │   ├── evidence-contract.md         ★ 证据四要素 + 三态验收
│   │   ├── registry-and-compaction.md   ★ Registry/Ownership/Promise/Compaction
│   │   ├── prompt-control.md            编排技巧
│   │   ├── scheduler-rules.md           串行/并行（三阶所有权）
│   │   ├── review-checklist.md · archive-policy.md · validation.md · glossary.md
│   │   ├── templates/                   填空合约
│   │   └── examples/                    决策树 + 手动试验
│   ├── prompt-assets/                   worker 角色资源
└── design/                            设计归档（已闭合，非运行时）
    ├── index.md                         归档索引
    └── _archive/                        设计规格 + AgentOS v0.3 快照 + clear-mind 痕迹
```

> 注：`AgentOS/` v0.3 自举快照与 `.clear-mind/` 历史产物已归档至 `design/_archive/`（正文不动，证据真实性靠 git 历史）。可运行 skill 包在 `enloom-skill/`。

## 子动作

生命周期各阶段内的操作：

| 子动作 | 阶段 |
|---|---|
| `triage` | 0 Triage |
| `plan` | 2 Plan |
| `make-prompt` · `dispatch` | 3 Execute |
| `review` · `audit` | 4 Verify |
| `archive` | 6 Close |
| `health-check` | 1 Orient + 4 Verify（定期） |

详见 [enloom-skill/SKILL.md](enloom-skill/SKILL.md)。

## 进度

进度、下一步和路线图：[PROGRESS.md](PROGRESS.md)。设计推理：[design/](design/)。
