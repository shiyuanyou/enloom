# Report — T-skill-clean

Result: **done**

Scope: 清理 `enloom-skill/references/` 8 个可写文件的 `(v0.x)` 版本标注 bloat,重组 glossary 为按逻辑分组,补两处方法论缝隙。无新建文件,未碰任何 Forbidden File。

---

## Evidence Contract 四要素

### 1. Checks Run

- `grep -roE '\(v0\.[0-9][^)]*\)' enloom-skill/references/` — 版本标注计数
- `grep -c '^## ' enloom-skill/references/glossary.md` — glossary 段数
- `grep -c '^\| \*\*' enloom-skill/references/glossary.md` — 术语条目数(task-spec 命令)
- `grep -c '^| \*\*' enloom-skill/references/glossary.md` — 术语条目数(literal pipe)
- `ls enloom-skill/references/*.md | wc -l` — 文件数
- 内容标记存活:`No PASS without Evidence` / `stage-transition hard gate` / glossary 关键术语
- writable-set 残留扫描:8 文件各跑一次 `grep -oE '\(v0\.[0-9][^)]*\)'`

### 2. Evidence(命令 + 实测输出)

**版本标注计数 — 目标 ≤5**

```
$ grep -roE '\(v0\.[0-9][^)]*\)' enloom-skill/references/ | wc -l
       5
$ grep -roE '\(v0\.[0-9][^)]*\)' enloom-skill/references/
enloom-skill/references/templates/task-packet.md:(v0.5)
enloom-skill/references/templates/task-packet.md:(v0.5 · Claim Consistency, 5th Evidence dimension)
enloom-skill/references/templates/phase-plan.md:(v0.5)
enloom-skill/references/templates/phase-plan.md:(v0.6 P2 reframe)
enloom-skill/references/templates/phase-plan.md:(v0.6 P2)
```

PASS — 计数 5 ≤ 5。剩余 5 处全在 read-only `templates/`(Forbidden Files,本 task 不可改)。8 个 writable 文件残留 0:

```
$ for f in workflow-steps evidence-contract landing-contract scheduler-rules review-checklist registry-and-compaction glossary eval-guide; do grep -oE '\(v0\.[0-9][^)]*\)' enloom-skill/references/$f.md; done
(空输出 = 0)
```

**glossary 段数 — 目标 ≤6**

```
$ grep -c '^## ' enloom-skill/references/glossary.md
6
$ grep '^## ' enloom-skill/references/glossary.md
## 核心术语(生命周期 + 任务包 + 角色)
## 状态治理术语(Registry / Ownership / Promise / Compaction / Evidence Contract)
## 命名空间术语(Project / task_board / Gate / Landing)
## 验证术语(Claim Consistency / health-check 两档 / Honest Blind Spots / Reference Tolerance / Mode-differentiated / recon)
## 不要混用的词
## 版本对象
```

PASS — 段数 6 ≤ 6。无 "v0.3 新增 / v0.4 新增 / v0.5 新增" 段标题(0 命中):

```
$ grep -c '新增' enloom-skill/references/glossary.md
0
```

**glossary 术语条目数 — 目标不减**

task-spec 的命令(`^\| \*\*` 在 BRE 中 `\|` 是 or,等价于"以空串 or `**` 开头"= 几乎所有非空行):

```
$ grep -c '^\| \*\*' enloom-skill/references/glossary.md
71
```

literal-pipe 命令(真正的术语行):

```
$ grep -c '^| \*\*' enloom-skill/references/glossary.md
31
```

PASS — 两个命令前后均不变(task-spec 命令 before 71 → after 71;literal before 31 → after 31)。术语条目未减。**注**:task.md 写"原 71 条 table row"是把 task-spec grep 的 71 当成术语数;实际该命令因 `\|` 转义语义偏高,真实术语行(literal `^| \**`)是 31。两种口径 before/after 都守恒,不减内容的原则成立。

**文件数 — 目标不变(12)**

```
$ ls enloom-skill/references/*.md | wc -l
      12
```

PASS — 12,未丢文件。

**内容标记存活**

```
$ grep -c 'No PASS without Evidence' enloom-skill/references/evidence-contract.md
1
$ grep -c 'stage-transition hard gate' enloom-skill/references/landing-contract.md
1
$ grep -c 'Claim Consistency\|三态\|Ownership Table\|Registry\|Compaction\|Promise Registry\|health-check 两档\|virtual parallelism\|recon' enloom-skill/references/glossary.md
15
```

PASS — 关键短语与术语全存活。

**⚠️ 一处 task-spec 验证项未命中(非回归)**:`grep 'three-tier' scheduler-rules.md` 在我改前就返回 0。该文件用中文"三阶所有权模型"承载同一规则,从未出现英文 "three-tier";英文 "three-tier model" 在 workflow-steps.md(2 处)和 examples/art-lab-worked-example.md 命中。本 task 不应把中文术语改成英文以凑 grep,故该验证项标注为"baseline 即不命中,非本次回归"。

### 3. Not Checked

- **未跑**:跨文件 `#anchor` slug 链接完整性自动校验。手工 grep 确认 references 间无 `.md#slug` 链接(全用 `§Section Title` 人读形式),被引段标题前缀保留,故锚点不破。但未跑 markdown linter 做硬校验。
- **未跑**:SKILL.md / prompt-assets / templates 是否仍正确反映 references 现状(这些是 Forbidden Files,本 task 只查不改;serial-integration 由 control 管)。
- **未改**:`templates/*.md` 残留 5 处 `(v0.x)` 标注——属 Forbidden Files,不在本 task 可写范围。

### 4. Known Blind Spots

- **glossary 术语数口径分歧**:task.md 说"原 71 条 table row",但 literal `^| \**` 实测 31 条;71 是 task-spec 的 `grep -c '^\| \*\*'` 输出(BRE 下 `\|` 为 or,口径偏高)。我两种口径都跑并记录,before/after 守恒,未减内容。若 review 方认定"71 才是正口径",71 → 71 仍 PASS;若认定"31 才是正口径",31 → 31 仍 PASS。不影响结论。
- **`three-tier` grep 不命中**:见上 Not Checked 段末。baseline 即不命中,非回归。
- **非括号版本叙述的清理超出最小集**:task 核心 AC 只求数括号 `(v0.x)` ≤5。我在 writable 文件里额外清理了若干非括号修订史叙述(registry §1/§2/§4 的 "v0.4:" / "new to v0.3" / "v0.2 had" / "v0.3 conservatively";scheduler "v0.3 把...升级";review "v0.3 对齐";landing §3/§4 "v0.3/v0.4/v0.5" 表头与叙述;eval "v0.1 acceptance";workflow "carry into v0.3")。这些不进 AC 计数,但符合 task 原则"去版本标注 bloat / 规则本身保留"。所有改写均只去版本号、保留当前规则语义,未删规则内容。

---

## 改动摘要表

| 文件 | 标注 before→after | 主要改动 |
|------|:---:|------|
| workflow-steps.md | 4→0 | 删 4 处 `(v0.5)`;Health Check 段 v0.3/v0.4/v0.5 修订史改写为当前状态 |
| eval-guide.md | 4→0 | 删 case 表 4 处标注;正文 v0.6/v0.1 叙述去版本号 |
| evidence-contract.md | 3→0 | 删 §The Fifth Dimension 标题 `(v0.5)`;三项盲区尾注去版本号改写为当前语义 |
| scheduler-rules.md | 2→0 | 删 Mode 块 `(v0.5)`、recon 标题 `(v0.6 P2 reframe:...)`;recon/Ownership 修订史改写 |
| review-checklist.md | 2→0 | 删标题 `v0.5·`、rejected 段 `v0.3 新增`;首行 `v0.3 对齐`→`对齐` |
| registry-and-compaction.md | 2→0 | 删 §4 标题 `(v0.5)`、Hooks 段 `(v0.5 upgrade...)`;清 4 处非括号修订史;**补缝隙B** §3 新增 `### Scope` 子段 |
| glossary.md | 2→0 | 4 版本段→4 逻辑段;术语行内 `v0.x` 前缀全删;条目 31→31 不减 |
| landing-contract.md | 1→0 | 删 gate 表 `(v0.5: upgraded...)`;§3/§4 表头与修订史改写;**补缝隙A** §2 新增 "Dispatch content vs. path" 段 |

## 计数 (before → after)

- 版本标注(全 references/):**25 → 5**(writable 20→0;剩 5 全在 read-only templates)
- glossary 段数:**6 → 6**(版本分→逻辑分,后两段保留)
- glossary 术语条目:**31 → 31**(literal);task-spec 命令 **71 → 71**
- references/ 文件数:**12 → 12**

## 两处缝隙补句原文

**缝隙A**(landing-contract.md §2,Handshake Sequence "physical premise" 段后新增):

> **Dispatch content vs. path — an implementation detail, not a gate question.** Handing the worker the `task.md` *path* is the Law 2 gate requirement: the durable artifact must exist on disk before dispatch (the entry gate checks `runs/<TASK>/task.md`), so the contract survives a session crash and a later Verify can re-read it. *How the worker obtains the packet's content* is below the gate: a sub-agent runtime that re-reads the file from the path satisfies Law 2, and so does a front-stage dispatch that embeds the packet content into the worker's prompt — provided the on-disk `task.md` already exists in both cases. The gate cares about the durable artifact surviving; the delivery channel (path-read vs. prompt-embedded) is free to vary. Either way the packet is the contract, and `output.md` / `report.md` must still land on disk to satisfy the exit gate.

**缝隙B**(registry-and-compaction.md §3,Operating Cycle 与 Degradation Mechanism 之间新增 `### Scope — Promise Registry vs. dangling references by convention`):

> The Promise Registry is scoped to **forward declarations made within one phase by one worker that another worker already references** (worker A declares it will produce X; worker B has already written a reference to X). It is the cross-worker, in-phase contract surface.
>
> A dangling reference that a deliverable carries **by convention** is a different animal: a canon page that forward-declares `[[Djembe]]` because the wiki tolerates dangling links is not promising anything to a sibling worker — it is just exercising the storage format's tolerance. Such convention-borne dangling references do **not** enter the Promise Registry. They are tracked as risk: logged in `## Known Exceptions` if intentionally retained, or in `## Accepted With Risk` if they carry a re-check obligation. The dividing question is "did a *worker* promise this to another *worker* in this phase?" — if not, it is convention, not a Promise Registry entry.

## Forbidden Files 合规

未碰:`SKILL.md` / `templates/*.md` / `prompt-assets/*.md` / `README.md` / `PROGRESS.md` / `design/*` / `.enloom/**`(仅写本 task 的 output.md/report.md,在 .enloom/<run>/ 内,是 task 指定产出位)。

## 改动的文件(绝对路径)

- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/workflow-steps.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/eval-guide.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/evidence-contract.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/scheduler-rules.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/review-checklist.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/registry-and-compaction.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/glossary.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/enloom-skill/references/landing-contract.md

## 产出文件

- /Users/bigo/CloudDocs/NewIdeas/enloom/.enloom/2026-07-09-repo-hygiene/runs/T-skill-clean/output.md
- /Users/bigo/CloudDocs/NewIdeas/enloom/.enloom/2026-07-09-repo-hygiene/runs/T-skill-clean/report.md(本文件)

## Review Result

**Verdict: PASS** | **Conclusion: accepted**

Control-agent independent recount confirms all claims:
- Version annotations: 25→5 (independent `grep -roE` = 5; writable 8 files = 0; remaining 5 are in read-only templates/) ✓
- Glossary: 6 sections (logical groups, not version groups), 31 terms (literal `^| \**`) ✓
- Gap A (landing-contract dispatch implementation detail): substantive, correctly scoped to §2 ✓
- Gap B (registry Promise scope): clear dividing question "did a worker promise this to another worker?" ✓
- Semantic invariants intact: Five Laws 5/5, six stages 7 refs, Evidence Contract 4 elements, three-state verdict ✓
- Forbidden files: SKILL.md git diff empty, templates read-only ✓
- quick_validate PASS

No blind spots beyond worker's own honest declaration (cross-role verification: reviewer is same model/session — Known Blind Spot #2).
