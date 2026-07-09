# Output — T-skill-clean

改 `enloom-skill/references/` 下 8 个文件:去版本标注 bloat、重组 glossary、补两处方法论缝隙。无新建文件。

## 改动摘要表

| 文件 | 版本标注 (before→after) | 改了什么 |
|------|:---:|------|
| workflow-steps.md | 4 → 0 | 删 4 处 `(v0.5)`(make-prompt 自检标题 / Stage 5 exit gate / Compaction check 标题 / Two Tiers 标题);Health Check 段把 "v0.4 promotes / v0.5 splits / v0.4 new / v0.5 light tier / v0.3 retained" 等修订史叙述改写为当前状态陈述;Five Laws 段 "All five carry into v0.3" → "carry through the lifecycle"。 |
| eval-guide.md | 4 → 0 | 删 case 表 4 处标注(case 7/8/9 的 `(v0.3)`、case 10 的 `(v0.6 P2 reframe)`);正文 "Case 10 tests the v0.6 P2 reframe" → "tests the recon Human Decision";"v0.1 acceptance checks" → "an earlier, narrower acceptance check"。 |
| evidence-contract.md | 3 → 0 | 删 §The Fifth Dimension 标题 `(v0.5)`;Honest Blind Spots 三项尾部注释 `*(v0.5 — fills the gap...)*` / `*(v0.5 — empirical basis...)*` / `*(Recorded since v0.3.)*` 改写为无版本号的当前语义句;引言 "v0.5 从一项扩展为三项" → "盲区共三项"。 |
| scheduler-rules.md | 2 → 0 | 删 Mode 块 `(v0.5)`、recon 标题 `(v0.6 P2 reframe:人机决策门 + recommended 信号)`;recon 引言 "v0.5 的...在 v0.6 升格为" → "recon 调度走人机决策门 + recommended 信号";Ownership Table 段 "v0.3 把...升级为" → "「ownership 概念」在此升级为"。 |
| review-checklist.md | 2 → 0 | 删 `计数自洽检查(v0.5·第 5 维...)` 标题中的 `v0.5·`、rejected 段尾 `(v0.3 新增)`;首行 "v0.3 对齐" → "对齐"。 |
| registry-and-compaction.md | 2 → 0 | 删 §4 `### Mandatory vs Skipped (v0.5)` 标题、Lifecycle Hooks 段 `(v0.5 upgrade from optional to enforced)`;同时清理 §1/§2/§4 中 "v0.4:" / "new to v0.3" / "v0.3 conservatively" / "v0.2 had a compaction concept" 4 处非括号修订史叙述,改写为当前状态。**补缝隙B**(§3 新增 `### Scope — Promise Registry vs. dangling references by convention`)。 |
| glossary.md | 2 → 0 | 重组:4 个按版本分的段(核心 / v0.3新增 / v0.4新增 / v0.5新增)合并为 4 个按逻辑分的段(核心术语 / 状态治理 / 命名空间 / 验证);删所有术语行内 `v0.x` 前缀;"不要混用"段尾两处 `v0.4 新增` / `v0.5 新增` 后缀删去;版本对象段 "v0.1 / v0.2 / v0.3 / ..." 举例删去。术语条目 31 条不变(按 task-spec 的 `grep -c '^\| \*\*'` 计 71,不变)。 |
| landing-contract.md | 1 → 0 | 删 gate 表 Stage 5 `(v0.5: upgraded from "trigger check run"...)`;§3 表头 `v0.3 (statement)` / `v0.4 (mechanized)` → `Statement (intent)` / `Mechanized (gate)`;§4 "v0.3 role / v0.4 promotes / v0.5 light tier" 修订史改写为当前状态。**补缝隙A**(§2 新增 "Dispatch content vs. path — an implementation detail, not a gate question" 段)。 |

## 计数 (before → after)

- 版本标注(全 references/):**25 → 5**(剩 5 全在 read-only `templates/`,不可改;writable 8 文件 20 → 0)
- glossary 段数:**6 → 6**(前 4 段从"核心/v0.3新增/v0.4新增/v0.5新增"变为"核心/状态治理/命名空间/验证";"不要混用"+"版本对象"保留)
- glossary 术语条目:**31 → 31**(literal `grep -c '^| \*\*'`;task-spec 的 `grep -c '^\| \*\*'` 因 `\|` 为 BRE or 返回 71,前后均 71,不减)
- references/ 文件数:**12 → 12**(不变)

## 两处缝隙补句

### 缝隙A(landing-contract.md §2,Handshake Sequence 末)

> **Dispatch content vs. path — an implementation detail, not a gate question.** Handing the worker the `task.md` *path* is the Law 2 gate requirement: the durable artifact must exist on disk before dispatch (the entry gate checks `runs/<TASK>/task.md`), so the contract survives a session crash and a later Verify can re-read it. *How the worker obtains the packet's content* is below the gate: a sub-agent runtime that re-reads the file from the path satisfies Law 2, and so does a front-stage dispatch that embeds the packet content into the worker's prompt — provided the on-disk `task.md` already exists in both cases. The gate cares about the durable artifact surviving; the delivery channel (path-read vs. prompt-embedded) is free to vary. Either way the packet is the contract, and `output.md` / `report.md` must still land on disk to satisfy the exit gate.

### 缝隙B(registry-and-compaction.md §3,新增 `### Scope` 子段)

> The Promise Registry is scoped to **forward declarations made within one phase by one worker that another worker already references** (worker A declares it will produce X; worker B has already written a reference to X). It is the cross-worker, in-phase contract surface.
>
> A dangling reference that a deliverable carries **by convention** is a different animal: a canon page that forward-declares `[[Djembe]]` because the wiki tolerates dangling links is not promising anything to a sibling worker — it is just exercising the storage format's tolerance. Such convention-borne dangling references do **not** enter the Promise Registry. They are tracked as risk: logged in `## Known Exceptions` if intentionally retained, or in `## Accepted With Risk` if they carry a re-check obligation. The dividing question is "did a *worker* promise this to another *worker* in this phase?" — if not, it is convention, not a Promise Registry entry.

## 关键约束遵守

- 未碰 Forbidden Files(SKILL.md / templates/*.md / prompt-assets/*.md / README / PROGRESS / design / .enloom)
- 未删任何 glossary 术语条目(31 → 31)
- 未改铁律语义 / 阶段骨架 / Evidence Contract 四要素(四要素段、Hard Constraint、Three-State Verdict 全保留)
- 交叉引用锚点不破坏:所有跨文件引用用 `§Section Title` 人读形式,被引段标题前缀保留;无 `.md#slug` 锚点链接
