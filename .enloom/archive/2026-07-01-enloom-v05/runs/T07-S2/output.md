# Output: T07-S2

scheduler-rules 加 recon 调度指引(S2 降级版)。

## 改动: scheduler-rules.md

- 路由预填段后、单 agent 现实段前,新增 §「新 domain 的侦察调度(v0.5 指引)」。
- 记踩坑 #16(规模偏差返工)。
- 指引:不熟领域时,首 task 设为侦察 task(现有 task-packet,mode=emergent,Allowed Tools=Read/Grep/Web),output 喂回 Plan 修正切分。
- 明示:非新阶段、非新字段、非新术语(吃 80% 价值,零结构改动)。

## 未动(零回归)

- 无 Pre-flight 阶段(grep workflow-steps = 0)。
- 无 pre_flight_needed 字段。
- 无 glossary 新术语(grep glossary = 0)。
- scheduler-rules 既有段(默认 serial / 三阶所有权 / 路由预填 / 单 agent 现实)语义未动。
