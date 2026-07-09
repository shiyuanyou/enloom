# Output: P1-C

> 产出文件:`enloom-skill/references/landing-contract.md`(新建)。

## 产出概要

landing-contract.md 收录五节:
1. **Gate Table**(§1)—— 7 Stage(0-6)入口/出口闸门,全部文件存在性检查。
2. **Handshake Sequence**(§2)—— control↔worker 完整握手时序图,每步箭头为落盘。dispatch 交的是 task.md 路径,非口头描述。
3. **Law 2/5 mechanization**(§3)—— 表格对齐 Law 4 风格:dispatch 前 task.md 必存在 / archive 前 Review Result 段必填。
4. **health-check 硬闸门**(§4)—— 从 v0.3 周期性 drift detector 升级为 stage-transition gate executor。
5. **Single-agent reality**(§5)—— 单 agent 会话闸门不放松;诚实盲区声明 worker-report 模板已含。

## 关键设计决策落地

- 闸门=文件存在性,机械化、无判断。
- 双保险:control 自检 + health-check 硬闸门,两处都跑。
- 铁律 2/5 对齐铁律 4 表述(PASS iff... ↔ task.md exists iff...),五铁律统一机械化。
- 「dispatch 交路径非口头」写成铁则,作为闸门表物理前提。
