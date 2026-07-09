# Output: T05-S6

phase-plan 引用容忍度决策表落地。

## 改动 1: templates/phase-plan.md

- Promise Registry Draft 段前插入 §Reference Tolerance Decision Table (v0.5)。
- 含 5 种引用类型示例(wikilinks / markdown links / code import / file-system path / JSON schema $ref),标注容忍度 + 处理 + 是否强制 serial。
- 决策行(原单行)保留并迁到表后。

## 改动 2: registry-and-compaction.md §3

- Degradation Mechanism 末尾加 v0.5 段:Plan 阶段不再每次从零推导,而是填 phase-plan 的决策表(脚手架非新闸门)。

## 未动

- Promise Registry 字段 / 操作周期 / 退化机制语义未动。
