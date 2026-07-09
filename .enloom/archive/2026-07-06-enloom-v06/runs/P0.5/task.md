# Task Packet: P0.5 — evidence-contract 残留旧叙事 + 断链修补

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

修补 P0 翻转后 `evidence-contract.md` §The Honest Blind Spots 编号第 2/3 项正文(L91/L92)的残留旧叙事措辞,以及 L92 里指向**已改名** scheduler-rules 标题的断链引用。这是 P0 的 ISSUES 遗留,经 control agent 独立 grep 确认。

同时清理 L94 收尾句的 "single-agent mode" 措辞。

## Anti Goal

- 不动 §The Honest Blind Spots 的开头段(L88,P0 已翻转)。
- 不动 §The Fifth Dimension 的 boundary statement(L24,P0 已翻转)。
- 不删 virtual parallelism 盲区本体——只重述其措辞,把 "single-agent mode" / "execution is actually serial" 换成 sub-agent posture 下的等效表达。
- 不改 evidence-contract.md 的其他段落。

## Inputs

文件:`/Users/bigo/.agents/skills/enloom/references/evidence-contract.md`

### 位置 1 — L91,编号第 2 项正文

**当前 L91**:
```
2. **Cross-role verification — verdict / review / audit may share one context.** In a single-agent run, the same model context that produced the output often also produces the verdict, the review conclusion, and the audit. Independent reasoning-chain verification (a second model genuinely re-deriving the conclusion) is **not guaranteed**. A PASS from the same context that did the work is weaker evidence than a PASS from a fresh one. *(v0.5 — fills the gap the original statement left.)*
```

**翻转成**:
```
2. **Cross-role verification — verdict / review may share model or session.** Even when worker and reviewer are separate sub-agents, they may run on the same model or be spawned within one session. Independent reasoning-chain verification (a genuinely fresh re-derivation) is **not guaranteed**. A PASS is stronger evidence when reviewer and worker differ in model or session than when they are closely coupled. *(v0.5 — fills the gap the original statement left.)*
```

### 位置 2 — L92,编号第 3 项正文(含断链)

**当前 L92**:
```
3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** In single-agent mode, a phase-plan may declare `parallel` with a full Ownership Table, but execution is actually serial (`scheduler-rules.md` "单 agent 会话的现实"). The Ownership Table still has value — it makes the intended ownership explicit and is what a real multi-sub-agent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened. *(v0.5 — empirical basis: `scheduler-rules.md` already admits this, but the admission was buried in the rules, not surfaced as a named blind spot.)*
```

**翻转成**(注意:更新对 scheduler-rules 标题的引用为新标题):
```
3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** Even with every task dispatched to an independent sub-agent, the control agent spawns them sequentially within one session — so a phase-plan may declare `parallel` with a full Ownership Table without runtime concurrency actually occurring (`scheduler-rules.md` "并行调度的真实时序"). The Ownership Table still has value — it makes the intended ownership explicit and is what a truly concurrent runtime would enforce — but no runtime parallelism is actually being executed. Declaring `parallel` without acknowledging this would overstate what happened. *(v0.5 — empirical basis: `scheduler-rules.md` already admits this, but the admission was buried in the rules, not surfaced as a named blind spot.)*
```

### 位置 3 — L94,收尾句

**当前 L94**:
```
These do not make Enloom unusable in single-agent mode — they make it honest. A control agent that proceeds knowing these limits makes better decisions than one that assumes isolation, independent review, and real parallelism are guaranteed.
```

**翻转成**:
```
These do not make Enloom weaker — they make it honest. A control agent that proceeds knowing these limits makes better decisions than one that assumes process isolation, independent review, and real concurrency are guaranteed.
```

## Existing State

- P0 已翻转该文件 L88(§开头)与 L24(§Fifth Dimension)。
- L91/L92/L94 是 §Honest Blind Spots 编号列表的正文 + 收尾,当时在 packet 边界外。
- scheduler-rules 对应小节已改名为"并行调度的真实时序(virtual parallelism 盲区)"(P0 翻转)。

## Allowed Tools

Read / Edit / Grep / Bash(仅 grep 验证)

## Writable Files

- `/Users/bigo/.agents/skills/enloom/references/evidence-contract.md`(仅此一个文件)

## Forbidden files

- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/**`
- evidence-contract.md 以外的任何 skill 文件

## Output Files

- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/2026-07-06-enloom-v06/runs/P0.5/output.md`
- `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/.enloom/2026-07-06-enloom-v06/runs/P0.5/report.md`(Review Result 留空)

## Acceptance Criteria

1. L91/L92/L94 三处翻转。
2. L92 的 scheduler-rules 引用串从 `"单 agent 会话的现实"` 更新为 `"并行调度的真实时序"`。
3. virtual parallelism 盲区本体保留(只重述措辞)。
4. 该文件其余段落(含 P0 已翻转的 L88/L24)未被误改。

## Required Verification

| id | command | pass_condition | fail_signal |
|----|---------|----------------|-------------|
| V1 | `grep -rin "single-agent" /Users/bigo/.agents/skills/enloom/references/evidence-contract.md` | 0 hits | ≥1 hit |
| V2 | `grep -n "单 agent 会话的现实" /Users/bigo/.agents/skills/enloom/references/evidence-contract.md` | 0 hits(旧标题断链已修) | ≥1 hit |
| V3 | `grep -in "virtual parallelism" /Users/bigo/.agents/skills/enloom/references/evidence-contract.md` | ≥1 hit(盲区保留) | 0 hit |
| V4 | `grep -n "并行调度的真实时序" /Users/bigo/.agents/skills/enloom/references/evidence-contract.md` | ≥1 hit(新标题引用落地) | 0 hit |

## Countable outputs

- 修改文件数 = 1
- 翻转措辞位置数 = 3(L91/L92/L94)

## Evidence Required

四要素 + Review Result 留空。

## Review Budget

只读 report.md + output.md。

## Done Signal

返回 done/blocked/failed + V1-V4 结果 + 路径。
