# Archive Policy

archive 是闭合。没有闭合,不算完成。闭合标准机械化,逐条核对。

## 闭合条件(全部满足才能 archive)

- [ ] task packet 存在。
- [ ] output 和 report 存在。
- [ ] review result 存在(写入 report 的 Review Result 段:verdict + conclusion)。
- [ ] project_state 已更新(压缩结论,不是 raw 过程)。
- [ ] decisions 已更新(若有关键决策)。
- [ ] **registry 风险区段已处理**(铁律 5 扩展):open risks 已转为 active task、known risk 或 accepted exception;broken references 已解决或登记;rejected reports 已索引。具体四个风险区段(Pending Dependencies / Broken References / Accepted With Risk / Rejected Reports)逐项确认状态。
- [ ] raw 材料已归档或声明丢弃(进 `runs/` 或 `archive/`,不进主窗口)。
- [ ] **compaction 触发检查**:若 project_state 超阈值(>200 行 / Accepted Results >10 / Orient 读不完),archive 前先跑一次 [Compaction Protocol](registry-and-compaction.md),保证退出时 state 干净。

任一缺失,不能 archive(铁律 5)。

## 归档输出

用 [templates/archive-entry.md](templates/archive-entry.md)。条目含:Completed / Outputs / Evidence / Verification / Decisions Updated / Project State Updated / Registry Updates / Open Risks Carried Forward / Raw Material Handling / Next Step。

## 主窗口退场

archive 后,control 只向用户汇报:
- 当前阶段完成了什么。
- 验收结论。
- 还剩什么风险。
- 下一步是什么。

不汇报 raw 过程、不复述日志、不粘贴大段 evidence。

## 状态压缩

project_state 不能只是越来越长的总结。每次 review 只追加或替换对应小节;过期细节移入 archive。

v0.3 把 compaction 从概念升级为完整 [Compaction Protocol](registry-and-compaction.md §4):触发条件(>200 行 / Accepted Results 阈值 / 可读性)→ 四步流程(扫描 → 迁移 → 收口 → 校验)→ 防错规则(**压缩前后 registry 四个风险区段条目数只能持平或减少,仅当 genuinely resolved;否则回滚**)。

核心原则:**压缩的是已闭合的过程细节,绝不压缩未闭合风险。** Registry 七区段是活性真相,compaction 时优先保留。
