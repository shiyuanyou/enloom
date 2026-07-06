# P0.5 Report — evidence-contract 残留旧叙事 + 断链修补

## What changed

修补 `evidence-contract.md` §The Honest Blind Spots 中 P0 packet 边界外的三处残留旧叙事:编号第 2/3 项正文(L91/L92)的 "single-agent" 措辞,以及 L92 指向已改名 scheduler-rules 标题的断链引用;另清理 L94 收尾句的 "single-agent mode" 措辞。virtual parallelism 盲区本体保留,仅重述措辞为 sub-agent posture 下的等效表达。

## What file

`/Users/bigo/.agents/skills/enloom/references/evidence-contract.md`(仅此一个文件)

## Diff summary

- L91:第 2 项正文由 "single-agent run / share one context" 翻转为 "separate sub-agents / may share model or session"。
- L92:第 3 项正文由 "In single-agent mode ... execution is actually serial (`scheduler-rules.md` "单 agent 会话的现实")" 翻转为 sub-agent 顺序 spawn 表述,引用串更新为 `"并行调度的真实时序"`(P0 改名后的标题)。
- L94:收尾句由 "unusable in single-agent mode ... assumes isolation ... real parallelism" 翻转为 "weaker ... process isolation ... real concurrency"。

## Why

P0 翻转了该文件 L88(§开头)与 L24(§Fifth Dimension),但 §Honest Blind Spots 编号列表的正文 + 收尾落在 packet 边界外,留下单 agent 措辞与断链(control agent 独立 grep 确认)。P0.5 收口这些遗留,使全节叙事与 P0 已确立的 sub-agent posture 一致。

## Verification

| id | command | pass_condition | actual result | status |
|----|---------|----------------|---------------|--------|
| V1 | `grep -rin "single-agent" ...evidence-contract.md` | 0 hits | 0 hits(exit 1) | PASS |
| V2 | `grep -n "单 agent 会话的现实" ...evidence-contract.md` | 0 hits | 0 hits(exit 1) | PASS |
| V3 | `grep -in "virtual parallelism" ...evidence-contract.md` | ≥1 hit | 1 hit(L92,exit 0) | PASS |
| V4 | `grep -n "并行调度的真实时序" ...evidence-contract.md` | ≥1 hit | 1 hit(L92,exit 0) | PASS |

V1–V4 全部通过。

## Acceptance Criteria

1. ✅ L91/L92/L94 三处翻转。
2. ✅ L92 scheduler-rules 引用串从 `"单 agent 会话的现实"` 更新为 `"并行调度的真实时序"`。
3. ✅ virtual parallelism 盲区本体保留(只重述措辞)。
4. ✅ 其余段落(含 P0 已翻转的 L88/L24)未被误改。

## Countable outputs

- 修改文件数 = 1
- 翻转措辞位置数 = 3

## Review Result

Verdict: PASS
Conclusion: accepted
Reviewer notes:

control agent 独立复核:
- V1-V4 全部独立重跑确认。
- 全 skill 终扫 `grep -rin "single-agent"` 后,evidence-contract.md 零残留。
- L92 断链已修(`"单 agent 会话的现实"` → `"并行调度的真实时序"`),与 scheduler-rules P0 改名后的新标题对齐。
- virtual parallelism 盲区本体保留(L92 仍述"顺序 spawn,parallel 标签 ≠ 真并发")。

Claim Consistency: P0.5 声称 1 文件 3 处,与独立 grep 一致。

P0 + P0.5 合并状态:核心叙事链(glossary / evidence-contract / landing-contract / scheduler-rules / worker-report)零残留旧叙事。剩余 3 处 single-agent 命中均合法(glossary 新措辞本身 / eval-guide + coder 归 P1 范围)。
