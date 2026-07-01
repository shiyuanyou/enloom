# Output: T01-S5

三处改动落地,S5 Compaction 从「可选检查」升级为 Stage 5 Integrate 出口必执行闸门。

## 改动 1: registry-and-compaction.md §4

- Trigger Conditions 段首加「heuristic, not dogma」注释(阈值旁明示非教条)。
- 新增 §"Mandatory vs Skipped (v0.5)" 子段:超标→必执行(不准 defer);未超标→跳过并记一行。
- Lifecycle Hooks Integrate 段:"If met, run" → "mandatory — runs before exit gate; deferring not permitted"。

## 改动 2: workflow-steps.md Stage 5

- Exit gate:"compaction trigger check run" → "compaction enforced — if threshold met, must run before gate passes; if not met, one-liner records skip"。
- Compaction check 段标题加 "(v0.5: mandatory gate)";超标→mandatory;加 skip 记录一行;加阈值"启发式非教条"指针。

## 改动 3: landing-contract.md §1 Gate Table

- Stage 5 Exit:"compaction trigger check run" → "compaction run or threshold not met"(含 v0.5 说明:超标 forces compaction)。

## 未动(零语义破坏)

- 四步流程表(Scan/Migrate/Closeout/Verify)逐字未动。
- Anti-Error Rule(step 4,风险段计数不得因压缩下降)未动。
- Registry 七段未动。
