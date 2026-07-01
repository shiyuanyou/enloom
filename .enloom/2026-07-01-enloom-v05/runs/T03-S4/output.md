# Output: T03-S4

health-check 拆两档。硬闸门语义不变,只降执行成本。

## 改动 1: workflow-steps.md Health Check 段

- 段首加 v0.5 说明:拆两档,硬闸门语义不变只降成本。
- Stage-transition hard gate 项下加「v0.5 light tier at transitions」:只跑该转移的文件存在性,单行 "Gates OK" 确认,不展开九项。
- Periodic drift detection 项下加「v0.5 full tier here」:九项全量只在 Orient 入口 + 定期 Verify 跑。
- 九项检查列表加小标题「full tier」,明示不在每次转移跑。
- 尾段区分两类 finding:轻量档阻断推进;全量档 log 给下次 Orient/Integrate。

## 改动 2: landing-contract.md §4

- 加「v0.5 light tier at transitions」bullet:转移时只跑该闸门文件存在性,单行确认,不展开九项;全量档在 Orient + 定期 Verify。
- 尾段补:轻量档保留双保险同时尊重 attention budget。

## 未动(零回归)

- 九项检查内容逐条未动(只是标注属于完整档)。
- 双保险(control 自检 + health-check)语义未动。
- 硬闸门「finding 阻断推进」未动。
