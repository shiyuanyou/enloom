# Output: T06-S7

task-packet 三模式差异化落地。audited 独立校验字段 = Claim Consistency(随 S1 同步)。

## 改动 1: templates/task-packet.md

- 头部加 mode-differentiated field 表(v0.5):7 字段 × 3 mode 的必填/可选矩阵。
- audited 行:Required Verification + Countable outputs(Claim Consistency)必填。
- emergent 行:Forbidden Files 可选。
- 加 self-check rule:auidted 缺 RV/Countable → make-prompt 失败,不准 dispatch;emergent Forbidden 空仍合法。

## 改动 2: workflow-steps.md Stage 3

- Mode selection 段后加 make-prompt self-check(v0.5·mode-differentiated density)。
- 约束密度匹配 mode;aaudited 缺 RV/Countable → 自检失败不准 dispatch(Stage 3 gate);emergent Forbidden 空仍合法。
- 指向 task-packet 表。

## 改动 3: scheduler-rules.md

- 头部加 mode 约束密度指引(v0.5):三种 mode 不只是标签,决定约束密度;指向 task-packet 表。
- emergent 降 make-prompt 负担;audited RV+Countable 必填缺则不准 dispatch。

## 字段名同步

audited 独立校验字段 = **Countable outputs (Claim Consistency)**,与 S1 第 5 维定性一致(非 Independent Verification)。全包统一。

## 未动(零回归)

- 三 mode 语义定义(emergent/recorded/audited)未改,只是把约束密度推到逻辑终点。
- Law 2(dispatch 需 task.md)未动。
