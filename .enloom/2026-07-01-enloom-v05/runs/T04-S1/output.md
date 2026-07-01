# Output: T04-S1

Evidence Contract 第 5 维 = Claim Consistency(report-vs-output 一致性校验)。三文件改动。

## 改动 1: evidence-contract.md

- 在四要素段后、Hard Constraint 前插入 §The Fifth Dimension — Report-vs-Output Claim Consistency (v0.5)。
- 定义第 5 维:对 report 任何可数 claim(条目数/通过率/文件数/覆盖率),Verify 阶段用 grep -c/awk/git diff --stat 独立重数;偏差>0 → ISSUES,结构性缺陷进 Broken References。
- 单 agent 退化边界声明:多 sub-agent 是真跨运行时;单 agent 退化为"agent 复核自己 output",防 claim 笔误/漂移,不防系统性谎报(后者归 cross-role 盲区)。
- 反命名:明示叫 "Claim Consistency",never "sub-agent count verification"。
- 挂载点:task-packet Required Verification 的 Countable outputs 字段;audited 必填。

## 改动 2: review-checklist.md

- accepted 必要条件后新增 §计数自洽检查(v0.5·第 5 维 Claim Consistency)。
- 偏差=0 通过;偏差>0 ISSUES(非 PASS)+ 方向登记;结构性缺陷进 Broken References。
- 单 agent 退化说明(防笔误漂移,不防谎报)+ 适用判据(audited 必填,recorded/emergent 可选)。

## 改动 3: templates/task-packet.md

- Required Verification 段加 Countable outputs 字段 + 说明 + audited 必填标记。

## 未动(零回归)

- 四要素本身未动(第 5 维是新增,不改 1-4)。
- Hard Constraint(PASS iff checks ran + evidence 非空)未动 —— 第 5 维是额外维度,不削弱硬约束。
- 三态 verdict 未动。
