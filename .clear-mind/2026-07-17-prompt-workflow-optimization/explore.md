# Explore · prompt-workflow-optimization

```yaml
created: 2026-07-17
project: prompt-workflow-optimization
stage: explore
status: finalized
input: "吸收 Pi prompt workflow quality audit，按第一性原理规划 Enloom 优化方向，并在本项目留下 Clear-Mind 产物。"
```

> Reading Budget: ~5 min. 本文只整理材料与充分度，不作方向裁决。

## Uncertain Items Summary

- P1/P3 的字段是否提高 reviewer 判断质量，尚无真实任务基准 → §4。
- Clear-Mind 的活源码不在本仓库，P2 不能在本项目内完成 → §2、§4。
- dev-wiki 是编译后的历史知识；其中 worker report 的 ownership 描述已与 live skill 不一致 → §3。

## 0. 原始诉求

> 你可以优化一下，然后用 clear-mind 分析一下当前的 enloom 如何规划优化方向。吸收这个 report。可以把 report 内涵的一些经典元素整理剃干净，以第一性原理等方式简化保留关键元素整理过去。clear-mind 的目录也在 enloom 下更新。

## 1. prepare 摘要

- **归一化诉求**：在不改变 Enloom 五铁律、六阶段和 Evidence Contract 四要素的前提下，判断 prompt-workflow audit 的建议哪些应转化为最小可验证的 Enloom 改动，哪些只应保留为运行条件或历史经验。
- **信源优先级**：当前 Enloom 源文件与项目状态 > audit 产物 > dev-wiki 编译页 > agent 记忆。
- **本轮检索**：检查 `README.md`、`AGENTS.md`、`PROGRESS.md`、当前 `enloom-skill/`、已安装副本一致性、audit `final-report.md`，以及 dev-wiki 的相关概念页。
- **wiki 检测结果**：已通过 `llm-wiki` MCP 读取 `dev-wiki`；其 index 最后更新为 2026-07-09。

## 2. 本地一手材料

| 发现 | 来源定位 | 类型 |
|---|---|---|
| Enloom v0.6 已有完整 lifecycle、五铁律、packet ownership、Evidence Contract 与 prompt-assets；本轮不能重造同类框架。 | `README.md`；`enloom-skill/SKILL.md`；`AGENTS.md`「改 skill 的纪律」 | fact |
| 当前源 `enloom-skill/` 与 `~/.agents/skills/enloom/` 的递归 diff 无输出，改动后需要继续保持同步。 | `diff -qr enloom-skill/ ~/.agents/skills/enloom/` | fact |
| researcher 只要求 output 有 citations，未定义本地材料性发现最低 locator 粒度。 | `enloom-skill/prompt-assets/researcher.md` §Output | fact |
| task packet 已有 `Evidence Required`，适合由 packet 声明任务需要的定位强度。 | `enloom-skill/references/templates/task-packet.md` §Evidence Required | fact |
| worker report 已有 Files Changed、Known Blind Spots 和 Return To Caller，但没有简明的实际调查边界/偏离自声明。 | `enloom-skill/references/templates/worker-report.md` | fact |
| Clear-Mind 的**活源码**位于同级 `../clear-mind/clear-mind-skill/`，不是本仓库；本项目内的 `.clear-mind/` 是 Clear-Mind 运行产物目录。 | `test -e` 路径检查；`AGENTS.md`「归档证据」 | fact |

## 3. 已有知识与 audit 输入

- `final-report.md` 的 P1（finding-level provenance）与当前 researcher 的“citation”要求互补；其应当绑定 `audited` 的研究任务，而非成为全模式格式税。
- P2（可选 Clear-Mind → Enloom handoff）符合 dev-wiki 的 `[[编排工具交接模式]]`：交接应发生在清晰产物边界，接收方只取得决策输入，不重做设计或自动获得 dispatch 授权。
- P3（boundary self-attestation）只能降低 review 的检索成本，不能证明运行时文件隔离；这与 dev-wiki `[[自举验证]]` 的“必要但不充分”限制一致。
- dev-wiki 的 `[[Worker报告模板合规]]` 将 `Review Result` 描述在 worker report 内；live Enloom 已将其放进 control-owned sibling `review-result.md`。因此 wiki 只能支持原则，不能替代当前契约。

## 4. 信息充分度判断

- [x] **部分**：当前文件足以决定一个狭窄 patch（P1 + P3）和一个独立的 Clear-Mind handoff 设计决策（P2）。
- **关键缺口**：没有使用新字段的真实 researcher 样本，因此不能声称 P1/P3 已改善质量；也没有两次真实 Clear-Mind → Enloom 交接样本，不能把 P2 扩张成新流程闸门。

## 5. 给 plan/review 的交接

- 首先检验的不是“还能加什么”，而是“哪些信息缺口会让 review 无法机械定位或快速判断”。
- 任何 patch 必须保持：Clear-Mind 决定方向，Enloom 验收执行证据；两种 verdict 不互相映射。
- 首轮目标应是一份 `audited researcher` dogfood，而不是重构 lifecycle、增加顶层 checklist 或使 Clear-Mind 成为硬前置。

[gate] explore.md exists? → yes
