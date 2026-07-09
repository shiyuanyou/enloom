# Decisions · enloom-v05

> 影响后续工作的关键决策记录。评审已裁决大部分,本文件记录实现期的裁决。

## D1 · 字段名统一 = Claim Consistency

**决策**:S7 audited 模式的独立校验字段名 + S1 第 5 维,统一用 **Claim Consistency**(report-vs-output claim 一致性校验)。

**否决**:"Independent Verification"(原 S1 初稿命名)和 "sub-agent count verification"(评审明示反命名)。

**依据**:design §7 标准 6「audited 模式的独立校验字段名随 S1 定性(Claim Consistency Check 或 Independent Verification,二选一,全包一致)」。评审 §S1 裁决:单 agent 串行下 "sub-agent 计数验证" 名不副实,重定性为 claim 一致性。glossary + task-packet + evidence-contract + review-checklist 全包统一该名。

**影响**:全包术语一致;未来真实多 sub-agent 运行时若提级,字段名不必改(claim 一致性在多 runtime 下含义更强)。

## D2 · scheduler-rules 写回虚拟并行盲区

**决策**:X2 第 3 项盲区(virtual parallelism)不仅写进 evidence-contract,还在 scheduler-rules.md「单 agent 会话的现实」段首加 ⚠️ 回写标记,双向链接。

**依据**:评审 §X2 裁决「第 3 项应同时回写到 scheduler-rules.md 该行附近,使其从'埋在规则里的一句话'升级为'明示的架构盲区'」。

## D3 · Compaction 阈值保留启发式

**决策**:S5 把 compaction 从可选升级为必执行闸门,但触发阈值(200 行 / 10 条 / 3 分钟)保留为**启发式、非教条**(registry §4 明示)。

**依据**:评审 §S5 唯一提醒「阈值写死可以,但留一句'阈值是启发式、非教条',避免变成不可讨论的硬数字」。

## D4 · S2 不建阶段,降为指引

**决策**:S2(预研)不建 Pre-flight 子阶段、不加 pre_flight_needed 字段、不加 glossary 术语。仅 scheduler-rules 加一段调度指引。

**依据**:评审 §S2 裁决「方案过重,对当前成熟度 over-engineering;降为 scheduler-rules 一段指引吃下约 80% 价值且零结构改动」。design §7 标准 7「无新阶段、无新字段、无新术语」grep 验证通过。

## D5 · dogfood 用 v0.5 新机制自举

**决策**:本 phase 实现过程严格遵守新闸门——S4 轻量档(每 Stage 转移单行确认)+ S5 compaction 检查(Integrate 出口记录 skip)。

**依据**:design §7 标准 10「dogfood 自举:v0.5 实现过程自己严格遵守新的闸门表」。project_state 有 Compaction Log 段记录。
