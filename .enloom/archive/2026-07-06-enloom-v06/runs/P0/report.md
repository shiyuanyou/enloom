# report.md — P0 叙事翻转六处 Worker Report

Task: 把 6 处"单 agent 自执行合法化"措辞同批翻转成"默认 dispatch 给独立 sub-agent,无 sub-agent 能力即中断(不退化自执行)"。audited 模式,Evidence Contract 四要素 + Claim Consistency。

## Result

done

## Files Changed

- `references/glossary.md`
- `references/evidence-contract.md`
- `references/landing-contract.md`
- `references/scheduler-rules.md`
- `references/templates/worker-report.md`

文件数 = 5。翻转措辞位置数 = 6(evidence-contract.md 内含 2 处)。详见 output.md。

## Checks Run

> Evidence Contract element 1 — 哪些验证被执行,具名。

| id | command | pass_condition | 结果 |
|----|---------|----------------|------|
| V1 | `grep -rn "same agent entering worker mode\|当前 agent 进入 worker mode\|the agent recounts its own\|single-agent mode.*default\|dispatching to itself" references/ SKILL.md` | 0 hits | **PASS** — exit=1(无匹配),0 hits |
| V2 | `grep -rn "virtual parallelism\|协议形式" evidence-contract.md scheduler-rules.md` | ≥1 hit each(virtual parallelism 盲区保留) | **PASS(scheduler-rules)** / **需说明(见 Evidence)** |
| V3 | `grep -rn "无 sub-agent\|halts\|interrupt\|中断" landing-contract.md` | ≥1 hit(中断语义落地) | **PASS** — 1 hit(L90 "halts") |
| V4 | `grep -rn "六个阶段\|six stages\|Five Laws\|五铁律\|四要素\|Four Elements" evidence-contract.md landing-contract.md` | 原有 hit 数不变(骨架未被误改) | **PASS** — 3 hits,与 baseline 完全一致 |

另执行:6 处 old_string 唯一精确匹配确认(Edit 工具逐处成功,无失败)、改后内容逐处 grep 复核(均命中新措辞)。

## Evidence

> Evidence Contract element 2 — 每项检查的证据:命令输出 / 文件路径 / 引用。

### V1 实际输出(0 hits,PASS)
```
$ grep -rn "same agent entering worker mode\|当前 agent 进入 worker mode\|the agent recounts its own\|single-agent mode.*default\|dispatching to itself" references/ SKILL.md
(no output, exit=1)
```
→ 5 个旧叙事锚短语全部消除。

### V2 实际输出
scheduler-rules.md(PASS):
```
references/scheduler-rules.md:61:## 并行调度的真实时序(virtual parallelism 盲区)
references/scheduler-rules.md:63:> ⚠️ **架构盲区**:即使每个 task 都真 dispatch 给独立 sub-agent...是**协议形式**,不代表运行时真并发执行...Known Blind Spots 第 3 项(virtual parallelism)...
```
→ "virtual parallelism" + "协议形式" 均命中。盲区**保留**并重述为 sub-agent posture。

evidence-contract.md(packet V2 字面命令显示 0 hit):
```
$ grep -rn "virtual parallelism\|协议形式" references/evidence-contract.md
(no output, exit=1)
```
**诊断:case 敏感性伪阴性,非真实缺失。** 该文件的盲区在 §Honest Blind Spots 编号第 3 项使用大写 `Virtual parallelism`(非小写),且措辞为 "protocol form only"(非中文"协议形式")。case-insensitive 复核确认盲区原位保留:
```
$ grep -rin "virtual parallelism\|协议形式" references/evidence-contract.md
references/evidence-contract.md:92:3. **Virtual parallelism — declared `strategy: parallel` is protocol form only.** ...
```
→ 该编号项(L92)在 packet 的 6 处边界之外(packet 只指派 §开头 L88 + §Fifth Dimension L24),且 packet 显式要求保留 virtual parallelism 盲区。盲区本体完整保留。**V2 的 pass_condition(盲区保留)实质满足**,packet 字面命令的 case 敏感性是已知口径问题,见 Known Blind Spots。

### V3 实际输出(PASS)
```
references/landing-contract.md:90:... If the runtime cannot dispatch a sub-agent, Enloom **halts** — ...
```
→ "halts" 命中 1 处。中断语义落地。

### V4 实际输出(PASS,与 baseline 一致)
```
1  references/evidence-contract.md:7:## The Four Elements
2  references/landing-contract.md:5:... all six stages ...
3  references/landing-contract.md:75:The Five Laws become uniformly mechanical ...
```
→ 3 hits。baseline 同为 3 hits(改前实测)。骨架(The Four Elements / six stages / Five Laws)未被触动。六阶段骨架 / 五铁律 / Evidence Contract 四要素本身未改。

### 逐文件改动 diff 摘要

| # | 文件 | 改动 | 旧叙事锚点删除 |
|---|------|------|----------------|
| 1 | glossary.md L12 | Worker 定义:删"或当前 agent 进入 worker mode" → "独立的 sub-agent 执行单元…无 sub-agent 能力即中断,不退化自执行" | ✓ |
| 2 | evidence-contract.md L88 | §Honest Blind Spots 开头:删"single-agent environment…worker is the same agent" → "要求 dispatch 给独立 sub-agent…无能力即中断" | ✓ |
| 3 | evidence-contract.md L24 | Fifth Dimension blockquote:删"single-agent mode (the current default)…degrades to agent recounts own output" → 多 sub-agent 跨运行时校验,系统性谎报归于 Known Blind Spots | ✓ |
| 4 | landing-contract.md L88-92 | §5 整段重写:标题 "Single-agent reality" → "Sub-agent requirement";删"dispatching to itself""same agent" → "halts, no self-execution fallback" | ✓ |
| 5 | scheduler-rules.md L61-65 | §整段:标题 → "并行调度的真实时序(virtual parallelism 盲区)";删"执行实际串行…协议真实表现,不是绕过";virtual parallelism 盲区**保留**并重述 | ✓(盲区留) |
| 6 | worker-report.md L29-32 | Known Blind Spots 模板:开头删 "In a single-agent environment";三项盲区全部保留但重述为 sub-agent posture | ✓ |

详细 old→new 见 output.md。

## Not Checked

> Evidence Contract element 3 — 应跑但未跑的验证。

1. **packet 字面 V2 命令的 case 校准未重跑改写版。** 我用 case-insensitive 复核证实盲区保留,但未向 packet 提议改 V2 命令(超出 worker 边界)。如果 control agent 严格按 packet 字面 V2 判 evidence-contract.md,会看到 0 hit。
2. **互引自洽的全文跑读未做。** 我用定向 grep 复核了关键引用关系(glossary ↔ landing §5 ↔ scheduler §注脚 ↔ worker-report → evidence-contract),未对 5 文件做完整跑读对照。
3. **除 6 处锚点外的"single-agent"残留词未系统性扫描。** V1 只覆盖 packet 指定的 5 个锚短语;文件内其它 "single-agent mode"/"single-agent run" 措辞(如 evidence-contract.md L92 编号第 3 项正文)未在 packet 边界内,未被翻转——见 Known Blind Spots。

## Known Blind Spots

> Evidence Contract element 4 — 每个 Not Checked 项:为何未查 + 风险多大。

1. **(对应 Not Checked #1 — V2 口径)** V2 pass_condition 的实质语义是"virtual parallelism 盲区保留",已满足(scheduler-rules 命中 + evidence-contract 大写 `Virtual parallelism` 原位保留)。但 packet 字面命令大小写敏感,对 evidence-contract.md 报 0 hit。**风险:低**——这是 packet 验证口径与文件既有命名大小写不一致(packet 搜小写 `virtual parallelism`,文件用大写 `Virtual parallelism`),非真实盲区丢失。control agent 复核时建议用 `-i`。

2. **(对应 Not Checked #3 — 残留旧叙事)** `references/evidence-contract.md` L92(§The Honest Blind Spots 编号第 3 项正文)仍含旧叙事措辞:"In single-agent mode, a phase-plan may declare `parallel`… execution is actually serial (`scheduler-rules.md` "单 agent 会话的现实")"。该处(a)用 "single-agent mode" 措辞,(b)引用旧 scheduler-rules 标题串 `"单 agent 会话的现实"`(已改名为"并行调度的真实时序(virtual parallelism 盲区)")。
   - **为何未改**:packet 的 6 处边界精确指派 evidence-contract.md 的 §开头(L88)与 §Fifth Dimension(L24),**未**把编号第 3 项(L92)列入;Countable outputs=6;且 packet 反复强调"不删 virtual parallelism 盲区"。我判定该编号项属"保留"而非"翻转"范围,故未动。
   - **风险:中**——它造成叙事不完全自洽:V1 不覆盖 "single-agent mode"(V1 只匹配 `single-agent mode.*default`,该行无 "default" 后缀所以不命中),所以 V1 通过;但人工通读会看到残留旧措辞 + 一条指向已改名小节的旧标题引用。建议作为 follow-up task(第 7 处)单独翻转该编号项措辞并对齐新 scheduler-rules 标题。

3. **(对应 Not Checked #3 — 残留旧叙事)** `references/evidence-contract.md` L91(§Honest Blind Spots 编号第 2 项)仍含 "In a single-agent run, the same model context…"。同理未在 6 处边界内。**风险:低-中**——与第 2 项同类,建议 follow-up。

4. **virtual parallelism 盲区本体**:已按要求**保留**(scheduler-rules 改后 blockquote + evidence-contract L92 + worker-report 模板 #3 三处一致)。声明 `strategy: parallel` ≠ 真并发——这是 control 层发起时序问题,与 sub-agent 能力正交,保留无误。

## Risks

- 上述 Known Blind Spots #2/#3 的残留措辞,若 control agent 要求"零残留旧叙事",需一个补丁 task(翻转 evidence-contract.md L91/L92 编号项)。本 task 严守 6 处边界,未越界。

## Registry Updates

(无 — 无 broken references / accepted-with-risk / promised outputs)

## State Update

5 个 reference 文件的叙事链已从"单 agent 自执行合法"翻转为"默认 dispatch 给独立 sub-agent,无能力即 halt"。互引主要路径(glossary ↔ landing §5 ↔ scheduler §注脚 ↔ worker-report → evidence-contract)改后自洽;evidence-contract L91/L92 编号项是已知遗留(见 Known Blind Spots)。

## Next

建议(非强制):开 follow-up task 翻转 evidence-contract.md §Honest Blind Spots 编号第 2/3 项(L91/L92)的 "single-agent mode/run" 措辞,并把 L92 对 scheduler-rules 的引用从旧标题串 `"单 agent 会话的现实"` 更新为新标题,以达到零残留旧叙事。

## Review Result

> Verdict (PASS / ISSUES / FAIL) + review conclusion。**留空,由 control agent 填写。**

Verdict: ISSUES
Conclusion: accepted-with-risk
Reviewer notes:

control agent 独立复核(不轻信 worker 自报):

- V1 PASS（exit=1,0 锚短语）— 独立确认。
- V2 实质 PASS — virtual parallelism 盲区在 scheduler-rules:61,63 + evidence-contract:92 保留(case-insensitive 确认)。packet 字面命令的小写 `virtual parallelism` 对 evidence-contract 大写 `Virtual parallelism` 是 case 假阴性,worker 诊断正确。
- V3 PASS — landing-contract:90 "halts" 落地。
- V4 PASS — 骨架 3 hits 与 baseline 一致。

ISSUES 而非 PASS 的原因:worker 诚实声明的遗留盲区经独立 `grep -rin single-agent` 确认属实,且比 packet 边界预估的更严重:

1. **evidence-contract.md:92** 编号第 3 项正文 `(scheduler-rules.md "单 agent 会话的现实")` 引用的是**已改名的旧标题串** — 这不是纯措辞遗留,是**断链**(指向已不存在的标题)。control agent 的 packet 边界错误(只列 L88/L24,漏了编号项正文),非 worker 越界。worker 严守边界正确。
2. **evidence-contract.md:91** 编号第 2 项 "In a single-agent run, the same model context..." — 措辞遗留。
3. **evidence-contract.md:94** "unusable in single-agent mode" — 措辞遗留。
4. **eval-guide.md:31**(packet 完全未覆盖此文件) — "single-agent session the same agent...grades it"。此文件不在 P0 的 5 个 writable 范围内,归 P1 处理。

风险定级:中。#1 是断链(读者点过去找不到标题),#2/#3 是叙事不彻底,#4 跨文件。均不阻塞 P0 的核心收益(六处主链已翻转),但需 P0.5 follow-up 补齐以达到"零残留旧叙事"目标。

**dogfood 验证点**:
- (a) Stage 3 真 dispatch 了 sub-agent — 不是主窗口自执行。dispatch-default posture 在 v06 自身首次跑通。
- (b) worker 诚实声明边界外遗留 — Evidence Contract 的 Not Checked + Known Blind Spots 机制起作用,没有被 worker 隐瞒。
- (c) Claim Consistency: worker 声称 5 文件 / 6 处, `git diff --stat` 独立复核见 Integrate 阶段。
- (d) 暴露了 packet 设计的真实缺陷 — recon/扫描没覆盖到编号项正文的残留,这是 P2 recon 升格的实证需求。
