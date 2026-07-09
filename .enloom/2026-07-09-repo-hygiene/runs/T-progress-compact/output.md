# Output: T-progress-compact

## 改动摘要

对 dev repo 的 `PROGRESS.md` 和 `README.md` 做了一次 compaction，并补上 Registry 风险段。**这是 enloom 自己 Compaction Protocol 的首次实战**——本任务本身就是防错规则的实证样本（风险段条目不减少，过程细节被压缩）。

### PROGRESS.md（249 → 80 行，压缩 68%）

**结构重组**（旧结构 90% 是已闭合历史 → 新结构以当前状态 + 未闭合风险为主）：

1. **顶部 dogfood 说明**（新增）— 声明本文件曾违反自家 Compaction Protocol，本次首次实战修复。
2. **当前状态**（保留）— v0.6 四项改动（dispatch-default 翻转 / 命名硬化 / recon 升格 / 清理）+ git 指针，完整保留，仅删除冗余措辞。
3. **Registry — 未闭合风险**（新增）— 集中 6 条已知风险，是本任务最强的 dogfood：
   - 跨模型 trigger 未验证（只 deepseek-v4-pro）
   - 第二领域泛化未证明（全来自 art_lab wiki ingest 单一领域）
   - prompt-assets 是否 load-bearing（实战中可能从未被加载）
   - eval 套件 ROI（27 文件，description-only unit test，非原生集成测试）
   - virtual parallelism 盲区（v0.5 新增）
   - compaction 防错规则实战中首验（本任务恰好验证）
4. **版本历史**（压缩）— 9 个版本从「每个完整变更列表」压缩为「表格：版本 | 日期 | 一行结论 | commit hash」。读者要细节 `git show <hash>`。
5. **外部 review 闭合记录**（压缩）— 三条已闭合 review 从逐条展开压缩为一段总结 + commit 指针。
6. **不做的事**（保留）— Non-Goals 完整保留，合并 CLI/scheduler 一行。
7. **相关文档**（保留）— 更新为现行路径（design/ 未归档，路径不变）。

### README.md §Status（183 → 170 行，压缩 7%）

- **v0.6 / v0.5 保留要点**（最近两版，读者最需要）— v0.6 四项改动 + v0.5 七项改动原样保留。
- **v0.4 压缩为一段**（双腿：命名空间 + 落盘时序契约，保留 design 链接）。
- **v0.3.3~v0.1 合并为两行指针** → PROGRESS.md 版本历史表 / `git log`。
- **honest blind spot 段强化**（保留并扩展）— 新增单模型说明（deepseek-v4-pro）+ description-only 局限 + 指向 PROGRESS.md § Registry 的完整风险清单引用（列举 6 条风险标题）。
- **skill 功能描述段不变** — What it is / How it works / Five Laws / Core mechanisms / When to use / Install 全部未动。

## 关键约束遵守

- 只改 `PROGRESS.md` 和 `README.md`（未碰 `enloom-skill/` / `design/` / `.enloom/`，本任务产出文件除外）。
- 未删历史事实（v0.1~v0.6 九个版本的存在与顺序全保留在版本历史表）。
- 未闭合风险未被压缩（Registry 段 6 条 + README blind spot 强化）。
- README 功能描述段零改动（4 个 header grep 全命中）。

## 数值

- PROGRESS.md：249 → **80** 行（目标 ≤120，达成；压缩 68%）
- README.md：183 → **170** 行（压缩 7%）
- Registry 风险条目数：**6**（目标 4-6，达成）
