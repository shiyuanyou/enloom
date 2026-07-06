# Phase Plan: Phase 2 — P1 角色命名硬化 + trim rule

## Phase Goal

收尾 P0 遗留的 single-agent 措辞(eval-guide/coder),补齐 worker-report 的 trim rule(D3 缺口),把全 skill 的"the agent"/"Orient scans"暧昧措辞硬化成显式角色名。同时建立"源仓库 vs 安装副本"同步纪律(P0 dogfood 失误的预防)。

## Anti Goal

- 不动 art-lab / manual-trial 的 "the agent"(归 P3)。
- 不动 researcher.md(归 P2 recon 升格)。
- 不改 archive-entry 的 Raw Material Handling(P3)。
- 不重写整段——只改角色命名 + 补 trim rule 段 + 重述 single-agent 残留句。

## Constraints

- **源仓库优先**:Writable Files 指向 `enloom-skill/`(源),改完后 worker 同步到 `~/.agents/skills/enloom/`(副本)。packet 的 Done Signal 要求两处一致。
- **trim rule 镜像** audit-task-packet.md:63-65 的 "Return To Caller" 段。

## Strategy

serial。7 处改动同性质(措辞硬化),1 个 task packet 全包。

## Ownership Table

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/2026-07-06-enloom-v06/project_state.md` | 控制 agent 独占 |
| 并行写 | `enloom-skill/` 下 P1 文件 | P1-worker 独占 |
| 只读 | `design/`、前序项目目录、其他 skill 文件 | 谁都不改 |

## Tasks

| ID | Task | Mode |
|----|------|------|
| P1 | 7 处措辞硬化 + trim rule + 源/副本同步 | audited |

## Review Plan

- `grep -rin single-agent` 全 skill → 应只命中新措辞正面表述
- `grep -rn "the agent"` 在改动文件 → 大幅下降
- worker-report.md 含 "Return To Caller" 或等效 trim rule 段
- Claim Consistency:声称 7 文件(或 N),git diff --stat 独立复核
- 源/副本一致:`diff -r enloom-skill/ ~/.agents/skills/enloom/` 改动文件无差异

## Human Decisions

- 无
