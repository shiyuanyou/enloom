# Archive Entry: Phase 3 — P2-recon 升格(reframe + recommended)

## Completed

把 v0.5 down-scope 成"一段调度指引"的 recon,按 clear-mind reframe 终版(`.clear-mind/2026-07-07-p2-recon-deep/`)升级为**人机决策门 + recommended 信号**——零结构改动(不新增 stage/顶层字段/Role 枚举值/Pre-flight),复用既有 phase-plan Human Decision + triage 偏好机制。reframe 规则在自身 phase-plan-3 首次跑通(recon considered: yes-skip,熟域)。

## Outputs

源仓库 `enloom-skill/` 6 文件(同步至安装副本):
- `references/templates/phase-plan.md` — Human Decisions 段加 recon decision 块(yes/no/recommended 三态,:66-69)+ Gate Check 加 "recon considered (v0.6 P2)" 行(:77)
- `references/trigger-contract.md` — 新增 `## recon 偏好(可选,机制 b)` 段(:34-38,triage 透传偏好不判断)
- `references/scheduler-rules.md` — v0.5 recon 指引段升格为"人机决策门 + recommended 三信号"(:53-71,含机制 abc + 三信号 + 诚实边界 + Known Limitation + P2-C↔P2-A 双向交叉引用)
- `prompt-assets/researcher.md` — How-to-work 第 6 条 recon 产物分支(:39,产物=规模素描,不动 Role/Mode 枚举)
- `evals/evals.json` — case 10(测 reframe 行为:Plan 摆 Human Decision + recommended 标记,非自动派)
- `references/eval-guide.md` — "nine cases"→"ten cases" + 表格第 10 行 + "most important" 补 case 10 说明(:3/:18/:20 + 4 处 nine→ten cascade)

## Evidence

- V1(recon considered 行):phase-plan.md:77 命中 ✅
- V2(recommended 三信号):scheduler-rules.md:61 三信号规则命中,grep "recommended" 4 行 ✅
- V3(researcher 分支):researcher.md:39 第 6 条命中 ✅
- V4(evals case 10):evals.json:100 id 10,python3 json.load valid 10 cases ✅
- V5(eval-guide):表格第 10 行 + ten-case cascade 全覆盖(grep "nine-case" 返回 clean)✅
- V6(trigger-contract 机制 b):trigger-contract.md:34 命中 ✅
- V7(reframe 对齐):grep "自动派" 2 hits 均否定句("不自动派"),精确残留 grep(旧 v0.5 句式)clean ✅
- V8(源/副本一致):`diff -r enloom-skill/ ~/.agents/skills/enloom/` exit 0 ✅
- 额外:卖点降级核查——scheduler-rules.md:71 显式"卖点是给预研结构化位置...不是防漏扫" ✅

## Verification

- P2: PASS(accepted)
- Claim Consistency:声称 6 文件改动,git diff --stat + diff -r 独立复核一致

## Decisions Updated

- **D-recon 升格形态**:recon 从"主窗口/Plan 自觉派"(v1/v2)+ "调度指引"(v0.5)→ **人机决策门 + recommended 信号**(v0.6 P2 reframe)。零结构改动,不碰 v0.5 红线。
- **recommended 三信号**(P2 第一版核心):Registry 无覆盖 / 新文件类型 / 规模边界不明——Plan 本来就在做的判断的副产物,agent 只标 salience 不定决策。
- **recon 标识靠文字**:task-packet 标 recon 靠 Goal/Anti-Goal 文字(非结构化字段),这是零结构改动的代价。
- **triage recon 偏好落点**:trigger-contract.md(声明随触发),非 workflow-steps(OR-分支解析)。
- **eval case 10 路径**:9-case 主 suite(测决策),非 trigger-evals(recon 是 body 内部 pattern)。

## Project State Updated

✅ project_state.md Current Phase / Active Tasks / Accepted With Risk / Archived Phases 均已更新。task_board.md enloom-v06 行更新(phase3 closed)。

## Registry Updates

- Accepted With Risk:新增 4 项 P2 诚实边界(防静默跳过不防做错 / recommended false positive / case 10 设计态 / recon 标识靠文字)
- 其余风险段:无变动

## Open Risks Carried Forward

1. **P3 清理**:archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 的 "the agent" 措辞
2. **recommended 信号精度调优**:第一版三信号在新项目(Registry 空)false positive 多,按后续 dogfood 反馈调
3. **case 10 passage 验证**:待 headless sub-agent dispatch 环境就绪(Path B),现属设计态
4. **"源/副本"缝隙**:enloom 无机制处理 skill 修自己时的源/副本一致性——P1/P2 均用 packet 纪律(Sync Step + diff)预防,但未写进 reference。建议后续进 prompt-control 或 landing-contract

## Raw Material Handling

- worker 完整改动记录在 runs/P2/output.md(逐文件 old→new)
- 未进主窗口;control agent 只读 report.md
- 改动过程的 raw Edit 调用历史在 sub-agent 上下文里,不复制进 archive

## Next Step

Phase 4 — P3 清理(archive-entry Raw Material Handling + art-lab/manual-trial 措辞)。或按用户决定收尾 v0.6。

## Dogfood 验证总结(本次跑 enloom 修 enloom 的关键观察)

1. **reframe 规则首次在自身跑通**:phase-plan-3 的 Human Decisions 段(recon considered: yes-skip)是 P2 刚设计机制的首次实例化——控制 agent 判本 phase 熟域(材料已通过 clear-mind explore 实读),标 yes-skip 跳过 recon sub-agent。机制 (a) 自洽可用。
2. **clear-mind ↔ enloom 文件即接口跑通**:clear-mind 的 review.md §7 五件 MVP 直接成为 enloom phase-plan-3 的 Goal/Acceptance Criteria,无人工转译损耗。两 skill 通过 `.clear-mind/` ↔ `.enloom/` 文件交接,互不侵入内部。
3. **worker 诚实 flag 的价值**:worker 在 report.md 主动 flag 了 5 个 blind spot(最重要的是 CHECK7 lexical 假阳——"自动派"匹配到"不自动派"否定句)。control agent 据此在 Verify 阶段读上下文而非机械数 grep 行数,避免误判。Evidence Contract 四要素 + Known Blind Spots 机制再次起作用。
4. **源/副本同步纪律二次跑通**:P1 建立的 Sync Step(cp + diff -r)在 P2 复用,6 文件 ×2 处全树一致。纪律可复现。
5. **recommended 三信号的第一版落定**:从 clear-mind review §7 的设计,到 scheduler-rules.md 的实现文本,再到 researcher.md How-to-work 第 6 条的 worker 行为——三处咬合。真实有效性待后续复杂 phase dogfood 验证(观测点:recommended 是否真影响 recon 决策)。
