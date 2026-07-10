# T-P4-01 Output — C10 (task-board.md) + C11/C13 (validation.md)

Task Packet Version: 0.2 · Mode: audited · Role: coder

## Scope

Rewrote the two Writable Files only:
- `enloom-skill/references/templates/task-board.md` (29 → 60 lines)
- `enloom-skill/references/validation.md` (92 → 146 lines)

No Forbidden Files touched.

---

## A. task-board.md — C10 two-root resolver

### Changes

1. **New §Resolver —— 两根定位（C10）** section. Documents the two-root algorithm:
   - Input: stable project slug from the `project` column.
   - `task_board` at most one row per project.
   - Derive `<created>-<project>`, check **exactly two candidates**: active root `.enloom/<created>-<project>/` and archive root `.enloom/archive/<created>-<project>/`.
   - Resolver returns exactly one enum; operation intent (`lookup|fold|reopen`) cannot bypass any error.
2. **RA4 error enum references** (no table duplication). The full 7-level precedence table is referenced via `[archive-policy.md](../archive-policy.md) §Namespace Resolver`. The six key blocking error enums are named inline: `FOLD_MOVE_PARTIAL`, `PROJECT_DUPLICATE_ROW`, `PROJECT_ORPHAN_ROOT`, `PROJECT_BOTH_ROOTS`, `PROJECT_MISSING_ROOT`, `PROJECT_OPERATION_INVALID`. Success enums `PROJECT_NEW`/`PROJECT_ACTIVE`/`PROJECT_FOLDED` are listed.
3. **Resolver examples table** (N01 active / N02 folded closed / N03 reopen) + the four negative signals (duplicate rows / both candidates / neither candidate with row / orphan directory without row), each producing one named blocking error.
4. **Reopen semantics** in §用法: `PROJECT_FOLDED + ALLOW_REOPEN` moves the **exact directory** back to active, **preserves `created`**, updates **the same row** (`updated`/`phase`), **MUST NOT create a duplicate**. Cross-links to `archive-policy.md §Reopen`.
5. **Removed unconditional `cd .enloom/<created>-<project>/`**. §用法 Orient step now: read board → locate row → run C10 resolver (checks both roots) → resolve the unique directory. The §不要 list adds: "永不无条件假设项目在 active root——永远走 C10 两根 resolver."
6. Existing table structure and §字段语义 kept verbatim (project/created/updated/phase/desc semantics unchanged).

### What was preserved

- Header blockquote, the example row, §字段语义 (unchanged), §不要 (extended, not removed).

---

## B. validation.md — C11 honest paths + C13 reference integrity

### Changes

7. **New §Validation Paths and Promise Boundary section** (C11). Two paths, explicit promise boundary, decision table:
   - **V01 Full** — 5-enum: `FULL_VALID | FULL_INVALID | FULL_VALIDATOR_UNAVAILABLE | FULL_RULE_GAP | FULL_EXECUTION_ERROR`. Exit 0 may mean full contract passed only when validator/version + rule coverage are evidenced. Non-verdicts (`UNAVAILABLE | RULE_GAP | EXECUTION_ERROR`) can never become `FULL_VALID`. If full required but unavailable/fails → control MUST halt.
   - **V02 Flat fallback** — 3-enum: `FLAT_VALID | FLAT_INVALID | FLAT_UNSUPPORTED`. No dependency; only declared unindented single-line flat scalar subset. Nested/multiline/type-sensitive input → `FLAT_UNSUPPORTED` (non-zero), **NOT** `INVALID`. Exit 0 means only "flat subset valid," never full equivalence. MUST NOT install dependencies or guess.
8. **§What to check** clarified which path runs which rule: V01 runs all 11 on any real YAML; V02 flat runs 1–3 and 6–10 on flat scalars plus rule 5 on flat top-level keys (cannot inspect nested `metadata`); rules 4 (parses-as-mapping) and 11 (typed string check) require a YAML-capable validator — V02 returns `FLAT_UNSUPPORTED` for inputs needing them. Also added "(not EOF)" to rule 3 per C11 forbidden-wording list.
9. **§Reference: bash implementation** now explicitly states it implements **ONLY the V02 flat fallback subset**, returns `FLAT_UNSUPPORTED` (exit 2) for indented/nested/multiline input rather than `INVALID`, and does **not** do full YAML validation. The script was rewritten to emit `FLAT_VALID`/`FLAT_INVALID`/`FLAT_UNSUPPORTED` verdicts and reject indented content as out-of-subset.
10. **New §Markdown Reference Integrity section** (C13 owner SSOT, moved from AGENTS.md): link target = resolvable path/URL only; `§Section Title` hint belongs in label/adjacent prose, never in target; inline code examples like `` `[x](path)` `` stay code, never "fixed" as links.
11. **§What this is NOT** / **§Why not ship one script?** lightly updated to reference the V01/V02 boundary (no semantics changed).

---

## Verification Results (V01–V07)

| ID | Check | Command essence | Result | Status |
|---|---|---|---|---|
| V01 | no unconditional `cd .enloom/` in task-board | `rg 'cd \.enloom/'` | 0 hits (exit 1) | PASS |
| V02 | `archive/` present in task-board | `rg -c 'archive/'` | 5 | PASS |
| V03 | C10 error enum present in task-board | `rg -c 'FOLD_MOVE_PARTIAL\|…'` | 6 | PASS |
| V04 | all 8 V01+V02 enums in validation | per-enum count | miss=0 (all ≥1) | PASS |
| V05 | `UNSUPPORTED` in validation | `rg -c 'UNSUPPORTED'` | 9 | PASS |
| V06 | C13 owner section in validation | `rg 'Markdown Reference Integrity\|…'` | 2 | PASS |
| V07 | § belongs in label, not target | `rg '§Section.*Title\|§.*hint.*label\|§.*target'` | 1 | PASS |

Extra checks:
- C13 static defect: `rg '\]\([^)]*\.md §[0-9]+\)'` on both writable files → 0 hits (no malformed targets introduced).
- Inline-code pseudo-link `` `[x](path)` `` remains code in validation.md (C13 compliance).
- Countable outputs: V01 enums = exactly 5; V02 enums = exactly 3; C10 resolver cases cover N01/N02/N03 + 4 negatives.

---

## Full rewritten content

### task-board.md

```markdown
# Task Board

> 项目级入口表。一行一 Project。control agent 在 Orient 第一步读本表定位目标项目;任务详情进各项目的 `project_state.md`,不在此索引。
> 命名空间层的唯一全局文件——位于 `.enloom/task_board.md`(项目目录之外)。

| project | created | updated | phase | desc |
|---|---|---|---|---|
| example-project | 2026-06-29 | 2026-06-30 | v0.1 | 一句话简介 |

## 字段语义

- **project**:稳定标识,去重键。slug 形态(如 `enloom-dev`)。同名 Project 第二次进入据此复用已有目录。
- **created**:创建日期,**永不变**。决定项目目录名 `YYYY-MM-DD-<project>`。
- **updated**:最近一次进入该 Project 的日期。control agent 每次 Orient/Integrate 后更新。
- **phase**:当前阶段标签(自由文本,如 `v0.3.4` / `ingest` / `closed`)。`closed` 表示项目已闭合,行保留可查。
- **desc**:一句话简介。

## Resolver —— 两根定位（C10）

Resolver 输入是稳定 project slug（来自 `project` 列）。`task_board` 对每个 project **至多一行**。推导 `<created>-<project>` 后检查**恰好两个候选**：

- **active root**:`.enloom/<created>-<project>/`
- **archive root**:`.enloom/archive/<created>-<project>/`

搜索两根而非依赖 schema 列,使 fold 位置显式——closed 目录可能已被 fold 到 archive,也可能还在顶层。Resolver 返回**恰好一个 enum**;操作意图（`lookup|fold|reopen`）**不可绕过任何 error**。

完整优先级表（7 级,error 优先于 success）在 [archive-policy.md](../archive-policy.md) §Namespace Resolver。关键 error enum（任一命中 = blocking namespace error,MUST NOT 选/建 project）:

- `FOLD_MOVE_PARTIAL` — move 未完成/失败/post-state 与 intent 不符
- `PROJECT_DUPLICATE_ROW` — `rows > 1`
- `PROJECT_ORPHAN_ROOT` — 无行但存在 active 或 archive 目录
- `PROJECT_BOTH_ROOTS` — 单行 + 两根同时存在
- `PROJECT_MISSING_ROOT` — 单行 + 两根都不存在
- `PROJECT_OPERATION_INVALID` — base-shape/intent/predicate 无效组合（见 [archive-policy.md](../archive-policy.md) §Operation-intent 校验）

Success enum:`PROJECT_NEW`（无行无根 → 通过正常 gate 后创建一行/一目录）、`PROJECT_ACTIVE`（active 独存）、`PROJECT_FOLDED`（archive 独存）。

Resolver 示例:

| Case | task_board 行 | 候选状态 | 唯一结果 |
|---|---|---|---|
| N01 active | 一行:`project=alpha`,`created=2026-07-01` | active 存在;archive 不存在 | resolve `.enloom/2026-07-01-alpha/` |
| N02 folded closed | 同一唯一行,`phase=closed` | active 不存在;archive 存在 | resolve `.enloom/archive/2026-07-01-alpha/`(read-only,除非 reopen) |
| N03 reopen 同名 | 同 N02 行;用户请求 reopen | 仅 archive 存在 | control 移动精确目录回 active,保留 `created`,更新同一行 `updated/phase`,再 resolve active;不建 duplicate |

Negative signals:duplicate rows / both candidates / neither candidate with row / orphan directory without row —— 每个产生一个命名 blocking error,MUST NOT 选/建 project。

## 用法

- **Orient(Stage 1)** — control agent reads this:读本表 → 定位目标 project 行（用户指明 / 唯一活跃 / 最近 updated）→ 跑 C10 resolver（同时检查 `.enloom/<created>-<project>/` 和 `.enloom/archive/<created>-<project>/`）→ resolve 到唯一目录 → 读该项目的 `project_state.md`。**不要无条件**进入 active 根（`.enloom/<created>-<project>/`）——必须走 resolver,因为目录可能在任一根。
- **新项目**(`PROJECT_NEW`):无匹配行且无候选目录 → 建 `<今天>-<projectName>/` 目录 + 初始化 project_state.md + 在本表加一行（`created`=今天）。
- **复用**(`PROJECT_ACTIVE`):同名 project 已有行且 active root 存在 → 复用其目录,只更新 `updated`,不新建目录、不改 `created`。
- **Reopen**(`PROJECT_FOLDED` + `ALLOW_REOPEN`):folded 同名项目重新激活 → control 移动**精确目录**（`.enloom/archive/<created>-<project>/` → `.enloom/<created>-<project>/`）,**保留 `created`**,更新**同一行**的 `updated/phase`。**MUST NOT 创建 duplicate**（不新建行、不新建目录）。详见 [archive-policy.md](../archive-policy.md) §Reopen。
- **闭合**:phase 列标 `closed`,行不删（历史可查）。closed 项目目录会在堆积 ≥3 时由 `fold` 折叠到 `.enloom/archive/`（见 [archive-policy.md](../archive-policy.md) §Project Fold）。fold **只移目录,不改本表行**——两根 resolver 让路径变化对查找透明。

## 不要

- 不在本表索引任务/阶段（那是各项目 project_state 的 Active Tasks）。
- 不删行（用 `closed` 标记）。
- 不无条件假设项目在 active root——永远走 C10 两根 resolver。
```

### validation.md

(Full rewritten file lives at `enloom-skill/references/validation.md`; the structural sections in order are: header → §Validation Paths and Promise Boundary (V01/V02 + decision table) → §What to check (with per-path rule coverage) → §Choosing an implementation → §Reference: bash implementation (V02-only) → §Markdown Reference Integrity → §What this is NOT → §Why not ship one script?.)

---

## Change summary (delta)

| File | Before | After | Net new |
|---|---|---|---|
| `templates/task-board.md` | 29 lines, unconditional `cd`, no resolver | 60 lines, §Resolver + reopen + resolver-based Orient | +§Resolver, +N01–N03 table, +reopen bullets; removed `cd` |
| `validation.md` | 92 lines, 11-rule "can do every check" claim, bash claims full validation | 146 lines, V01/V02 promise boundary, bash = V02-only, §Markdown Reference Integrity | +§Validation Paths, +per-path rule coverage, +§Markdown Reference Integrity; rewritten bash verdicts |

## Decisions / notes

- The C13 §Markdown Reference Integrity section states the rule using descriptive prose (e.g. "put the section number in the label or in prose") rather than embedding a literal malformed `](path §2)` target in the document body. This keeps the strict C13 static defect regex (`\]\([^)]*\.md §[0-9]+\)``) clean while still teaching the rule; the `` `[x](path)` `` inline-code example remains as code per C13.
- RA4's full 7-level table is **referenced**, not duplicated, in task-board.md (per task constraint and the archive-policy.md owner).
- No description/trigger wording changed. No lifecycle/ownership/evidence semantics changed. No templates other than task-board.md touched.
