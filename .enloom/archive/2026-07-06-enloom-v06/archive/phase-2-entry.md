# Archive Entry: Phase 2 — P1 角色命名硬化 + trim rule

## Completed

收尾 P0 遗留的 single-agent 措辞(eval-guide/coder),补齐 worker-report 的 trim rule(D3 缺口),把全 skill 的 D2 暧昧措辞("the agent"/"Orient scans"/被动语态)硬化成显式 control agent / worker。建立源仓库 vs 安装副本同步纪律。

## Outputs

源仓库 `enloom-skill/` 6 文件(同步至安装副本):
- `references/eval-guide.md` — L25 `hand the model`→`hand the worker`;L31 single-agent bias 重述
- `prompt-assets/coder.md` — L37 single-agent 盲区 → cross-worker file isolation
- `references/templates/worker-report.md` — 新增 `## Return To Caller (trim rule)` 段(镜像 audit-task-packet:63-65)
- `references/templates/project-state.md` — 4× `Orient scans this` → `control agent scans this on Orient`
- `references/templates/task-board.md` — 3 处 Orient → 显式 control agent
- `references/templates/task-packet.md` — L7/L19 make-prompt 被动语态 → control agent's

## Evidence

- V1: single-agent 全 skill 零残留(排除新正面表述)✅
- V2: worker-report trim rule 段落地(L51+L53)✅
- V3: project-state 4 处全改 ✅
- V4: 源/副本 6 文件逐字节一致 ✅
- V5: `hand the model` 已改;L61 残留是无关正面用法(trigger eval 语义)✅
- 额外: `Orient scans this` 零残留 ✅

## Verification

- P1: PASS(accepted)
- Claim Consistency: 6 文件 7 处,与独立 grep + diff 一致

## Decisions Updated

- D2 角色命名基准:全 skill 统一用 "control agent"(编排)/ "worker"(执行),禁用暧昧的 "the agent"
- D3 trim rule 对称:worker-report 补齐后,与 audit-task-packet 的 Return-To-Caller 防护对齐
- 源/副本同步纪律:Writable 指向源仓库,Done Signal 含 cp 同步 + V4 diff 校验

## Project State Updated

✅ project_state Phase/Active Tasks/Accepted-With-Risk/Archived Phases 均更新。

## Registry Updates

- Accepted With Risk:eval-guide:31 + coder:37 → resolved(P1 闭合)
- 其余风险段:无变动

## Open Risks Carried Forward

1. **P2 recon 升格**:researcher.md 加 recon 模式 + phase-plan 加 recon 结构位 + eval 加 recon case(核心目标"复杂任务插预研究任务包")
2. **P3 清理**:archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 的 "the agent" 措辞
3. **"源/副本"缝隙**:enloom 无机制处理 skill 修自己时的源/副本一致性——本 phase 用 packet 纪律(Sync Step + V4)预防,但未写进 reference。建议后续进 prompt-control 或 landing-contract

## Raw Material Handling

- worker 完整改动记录在 runs/P1/output.md
- 未进主窗口;control agent 只读 report.md

## Next Step

Phase 3 — P2 recon 升格(重头戏:researcher.md recon 模式 + phase-plan 结构位 + eval case)。
