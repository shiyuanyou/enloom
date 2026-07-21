# Review · prompt-workflow-optimization

```yaml
created: 2026-07-17
project: prompt-workflow-optimization
stage: review
status: finalized
input: plan.md
```

> Reading Budget: ~5 min. 本文是对 plan 的应力测试，不重复其结论。

## Uncertain Items Summary

- 首个 dogfood 尚未运行，P1/P3 的净收益仍待验证 → §1、§4。
- P2 的实现权不在 Enloom repo → §2、§5。
- worker 自声明无法证明运行时边界 → §1、§4。

## 0. 被裁决的方案

在不动 Enloom 核心 lifecycle 与 Evidence Contract 的前提下，对 `audited researcher` 增加材料性 finding locator，并让 worker report 明示实际边界与偏离；随后用一次只读 dogfood 验证。

**plan 的关键 claim**：主要矛盾是 reviewer 对材料性结论的低成本可回溯性；最小 MVP 是 P1 + 改良 P3；最该验证的是新字段是否降低而非提高 review 成本。

## 1. 可行性应力测试

| 维度 | 判定 | 信号/证据 |
|---|---|---|
| 复杂度与维护 | 可接受 | 改动局限于 3 个现有职责明确的文件，不新增 stage/顶层 checklist。 |
| 可靠性与失效模式 | 有风险 | locator 可能变成不准确或无意义的“引用表演”；Boundary Check 可能被误读为隔离证明。 |
| 可维护性 | 可接受 | task packet 控制定位粒度，role asset 说明语义，template 提供稳定报告入口。 |
| 实施风险 | 可接受 | 必须避开 archive；源与 installed copy 当前一致，可在同一 patch 后同步验证。 |

**最致命的工程弱点**：如果“材料性”与 locator 的最低粒度没有被 packet 明确限定，worker 会追求表格完整而不是证据质量，review 反而变慢。

**边界应力测试**：

- 在 audited code/doc investigation：字段有明确收益，适用。
- 在 recon 或 emergent exploration：强制逐 finding 表格是过度约束，应允许 packet 不启用或使用简短 scale/structure evidence。
- 在 host 没有实际文件权限隔离时：Boundary Check 只能报告，不能把 PASS 升级为“已隔离”。

## 2. 他山之石与假类比筛查

- dev-wiki 的 Evidence Contract 与本案同样处理“压缩结论必须可回到证据”；机制和约束均对齐，可迁移。
- dev-wiki 的编排交接模式支持 P2 的产物边界，但 Clear-Mind source 是 sibling repo，不能把“接口存在”误推成“本 repo 可顺带修改”。
- 事故调查的 pause/recovery contract 适用于 production-impact 或 destructive work；将其默认注入 researcher packet 是假类比，拒绝。

## 3. 拓展：主要矛盾与 MEP

**主要矛盾**：现有协议强调“有证据”，但对本地研究的“证据如何被快速定位”没有足够具体的、mode-aware 最小载体。

**MEP**：

- **实践**：使用新 P1/P3 文案跑一次 readonly `audited researcher`，主题为一个可在 3–6 个本地文件完成的调查。
- **真实输入**：真实仓库文件和真实 task packet，不使用演示素材。
- **成功标准**：reviewer 仅凭 report 的 Evidence Record 能抽查所有材料性 finding；没有未标记的 fact/hypothesis 混写；Boundary Check 能说明偏离；结构验证与 source/install diff 通过。
- **失败标准**：表格包含大量非材料性条目、locator 无法打开、review 仍需从头通读 output，或 self-attestation 被当作隔离证据。
- **反馈节点**：dogfood review 后立即决定 P1 是否成为 audited researcher 默认，或回退为每包 opt-in。

## 4. 三态裁决

- [ ] WORTH-IT
- [x] **CONDITIONAL**
  - **硬条件 A**：P1 仅对 packet 声明的高审计需求生效，且要定义“材料性 finding”和 fact/hypothesis/open question 的不同 locator 规则。满足后可进入小 patch。
  - **硬条件 B**：P3 明确为 self-attestation，记录实际范围和偏离，不得表示 sandbox/权限/独立验证。满足后可进入小 patch。
  - **软条件 C**：一次 dogfood 证明收益；不满足则维持 P1 为 opt-in，不扩大到全部 researcher。
  - **软条件 D**：P2 由 Clear-Mind project 单独治理；不满足不阻塞 Enloom P1/P3。
- [ ] KILL-OR-REFRAME

## 5. Execution Handoff Input (optional)

> 这是下一阶段 Enloom Plan 的决策输入，不是 phase plan、task packet 或 dispatch 授权。

- **Verdict**: CONDITIONAL
- **Primary constraint**: reviewer 对材料性研究结论缺少低成本、可回源的定位。
- **Minimal MVP / scope boundary**: P1 + 改良 P3 + 一次 readonly audited researcher dogfood；不改 lifecycle、Evidence Contract 四要素、Clear-Mind source 或 archive。
- **Hard conditions / evidence gaps**: mode-aware locator 规则、self-attestation 语义、dogfood 尚未验证。
- **Source artifacts**: `explore.md` / `plan.md` / `review.md`；audit `final-report.md`；live Enloom source files。

[gate] review.md exists? → yes
