# Plan · prompt-workflow-optimization

```yaml
created: 2026-07-17
project: prompt-workflow-optimization
stage: plan
status: confirmed-for-current-phase
input: explore.md
```

> Reading Budget: ~6 min. 前置 `explore.md` 判定材料：部分；未验证收益见其 §4。

## Uncertain Items Summary

- P1/P3 的收益需 dogfood 才能验证 → §6、§8。
- P2 的活源码在 sibling project，不能作为本 phase 的顺带修改 → §7。
- dev-wiki 为历史编译材料，不是 live skill SSOT → §5。

## 0. 诉求摘要

- **问题**：Enloom 的核心控制纪律已足够强，但 researcher 的材料可追溯性和报告级边界可见性仍依赖宽泛措辞；报告中的好经验需要被压缩为少量、可复用的协议点。
- **核心目标**：
  1. 让 `audited researcher` 的材料性结论可由 reviewer 快速追溯。
  2. 让 worker 对实际边界偏离与修改范围可见，但不伪装成运行时隔离。
- **期望结果类型**：实操方案 + 方向验证。
- **MVP 边界**：只改 Enloom 的 researcher asset、task packet helper、worker report；不触碰 lifecycle、五铁律、Evidence Contract 四要素、Clear-Mind 源码或任何 archive。

## 1. 诉求剖析

**表层意图**：吸收 prompt-workflow audit，优化 Enloom，并在本项目留下 Clear-Mind 分析。

**深层目标**：让复杂任务的控制协议在关键研究任务中更可审计，同时避免“协议越来越完整、实际越来越难用”的膨胀。

**张力**：报告提出 P1/P2/P3；但现有 Enloom 已经以 references、templates、prompt-assets 分层。若把三项都提升为普遍硬规则，会破坏 mode-differentiated density 和 optional coupling。

## 2. 第一性原理

- **PRIMARY CONSTRAINT**：reviewer 无法以低成本把材料性研究结论还原到具体一手输入，是在不增加新阶段/新 checklist 的前提下提升可信度的根本阻塞。
- **SECONDARY CONSTRAINTS**：
  1. packet 边界是声明性约束，现有报告不易一眼看出实际偏离。
  2. Clear-Mind 的 handoff 缺少稳定内容形状，但它的活源码属于 sibling project。
  3. 历史 wiki 可能与 live contract 漂移。
- **MINIMAL MVP**：在 `audited` researcher packet 中，要求 `output.md` 用一张简短 Evidence Record 记录材料性 finding 的类型与 locator；在 report 增加 Boundary Check，记录实际输入范围、packet 偏离、source/config/state 修改和 out-of-scope 项。
- **REMOVABLE**：全局 checklist、新 lifecycle 阶段、Clear-Mind 强制前置、verdict 合并、事故级 completion contract 的默认字段、以 wiki 文案替代 live contract。

**定义核查**：

- “材料性 finding”= 会改变 recommendation、acceptance 或风险结论的事实/推断；不是每句说明文字。
- “locator”= 本地 `path + heading/line range` 或 URL + section；hypothesis 必须定位其依赖的 fact，不把推断本身伪装为 source。
- “Boundary Check”= worker 的声明和 reviewer 的检索入口；不是沙盒、权限或独立验证的证明。

## 3. 优化问题

- **B.1 聚焦表层版**：怎样给 researcher 增加 provenance 和 boundary 字段？
- **B.2 直击核心版**：怎样让 reviewer 能在压缩报告外快速核验关键结论，又不把所有 research 变成文档官僚流程？
- **B.3 升维破局版**：把“更多规则”改写为“仅在 packet 宣告高审计需求时，交付可回到源头的最小证据索引”。

### 3.1 方向推演

- **选中的方向**：仅在 `audited` researcher 中启用可追溯 evidence index。
- **最小可验证假设**：若 researcher report 提供材料性 finding 的 locator，control 能在不通读 `output.md` 的情况下判断 evidence 是否足以支持 PASS/ISSUES。
- **当前方案先会站不住的地方**：若所有模式、所有角色都强制逐 finding 表格，轻量 recon 和 emergent work 的认知负担会超过收益。

## 4. 领域拓展

- **审计系统**：审计记录应把强制事实与调用方声明分开；对应 Evidence Record 与 Boundary Check 语义分离。
- **编译器诊断**：错误定位应指向源位置而不是重复整段上下文；对应 `path + heading/line range` 作为追溯索引，而非原文复制。

## 5. 类似经验的适用边界

- dev-wiki 的 Evidence Contract、事实/AI 综合边界、编排工具交接和 self-dogfood 支持方向，但它的页面最晚更新于 2026-07-09，且已观测到 worker-report ownership 漂移。
- 因此迁移的是机制：事实/假设分离、产物边界、dogfood 必要不充分；不迁移旧字段的逐字内容。

## 6. 当前 phase 的最小实施方案

1. 在 `prompt-assets/researcher.md` 的 Output 段增加：仅当 packet 的 `Evidence Required` 声明 locator 或 packet 为 `audited` 时，`output.md` 必须包含 Evidence Record；表中只列材料性 finding，明确 fact / hypothesis / open question 的不同 locator 规则。
2. 在 `templates/task-packet.md` 的 `Evidence Required` helper 中增加：control 可声明 locator 粒度；audited researcher 的默认要求是材料性 finding 的最小 locator，不要求复制内容。
3. 在 `templates/worker-report.md` 增加 Boundary Check：实际读取范围、偏离、修改范围、out-of-scope；明确这是 self-attestation，不是运行时隔离证据。
4. 建一个 only-read `audited researcher` dogfood，检查 P1/P3 在真实 report-first review 中是否减少回读，且不产生 citation theater。
5. 保持 source 与 installed copy 同步；以 `diff -qr` 和现有 structural validation 作为收口检查。

## 7. P2 的处置

P2 值得保留，但本 phase **不改**。理由：Clear-Mind 的活源码在 `../clear-mind/clear-mind-skill/`；它应作为单独 patch，由 Clear-Mind 项目的 SSOT、同步与 dogfood 管理。推荐的未来接口仅包含 Verdict、Primary constraint、MVP/scope、hard conditions/evidence gaps、source artifacts，并声明“不是 Enloom Plan/packet/dispatch 授权”。

## 8. 验收与不确定项

- `audited researcher` 的 Evidence Record 能定位每一条材料性 finding；非材料性叙述不要求表格。
- hypothesis 不被列为 fact；其 dependent facts 可定位。
- Boundary Check 不声称 sandbox 或 independent verification。
- `emergent` / recon 仍可保持轻量，不被新增表格阻塞。
- dogfood 后再判断是否将 P1 从“packet opt-in”扩大为 audited researcher 默认；在此之前，收益不足以判断。

## Summary Confirmation Gate

- **我理解的问题**：不是缺更多治理，而是需要让必要的少量治理在对的 mode/role 上可检验。
- **主要矛盾**：材料性结论的低成本可回溯性。
- **MVP 边界**：P1 + 改良版 P3 + 一次真实只读 dogfood。
- **待确认**：P2 需由 sibling Clear-Mind project 单独决定和实现。

[gate] plan.md exists? → yes
