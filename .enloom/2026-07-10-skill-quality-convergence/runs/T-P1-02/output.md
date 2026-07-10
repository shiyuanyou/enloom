# T-P1-02 Per-File Change Summary

Task: align 8 Evidence Contract consumer files with the new owner §Verdict Decision Function (C01) and the revised §The Four Elements disjoint semantics (C02). Consumers reference the owner; they do not restate the formula.

## 1. `enloom-skill/references/review-checklist.md`

- **Header (line 3):** rewritten to state verdict/conclusion logic has its SSOT in `evidence-contract.md §Verdict Decision Function`; this file lists gate checks only, no formula restatement.
- **§三态 verdict table (lines 15-21):** the 判定条件 column previously restated the PASS formula ("所有 declared checks 已跑 + evidence 非空...") independently. Replaced with: a 概览 table whose conditions point to the owner, plus an explicit note that the ordered verdict table + mandatory conclusion mapping in the owner is the complete mechanized formula and "此处不再独立复述「PASS iff」条件". Removed the standalone "硬约束: verdict = PASS 当且仅当..." paragraph that restated the old iff formula; replaced with a reference to the owner's ordered verdict table.
- **§accepted 的必要条件 (lines 24-31):** Not Checked line updated to "**packet 声明的 required-check ID 中未执行者**...非空 → 阻断 PASS"; Known Blind Spots line updated to "**结构性 / 运行时 / 越界限制**,每行带 `blocks_check_ids`;`blocks_check_ids=[]` 可与 PASS 共存". Added a new checklist item enforcing C02 disjoint semantics ("Not Checked 与 Known Blind Spots 不混用...结构性限制不得放进 Not Checked;required omission 不得软化成盲区"), referencing owner §The Four Elements.

## 2. `enloom-skill/references/templates/worker-report.md`

- **§Not Checked comment (line 24):** old text "which verifications should have run but did not. Declared blind spots, explicitly, not hidden." → new "**packet-declared required-check IDs that were not executed** (or an explicit `None` when every declared check ran). Not a place for structural limitations. A non-empty entry here blocks `PASS`. C02: this field is reserved for required omissions only."
- **§Known Blind Spots comment (line 29):** old text "for each Not Checked item: why it was not checked" (conflated the two fields) → new "**structural / runtime / out-of-scope limitations**, NOT explanations for Not Checked items. Each row carries a `blocks_check_ids` field: empty array `[]`...may coexist with `PASS`; a non-empty array MUST project to matching `not-run` IDs listed in Not Checked. C02 disjoint semantics: a structural limitation may *explain* an omission (via `blocks_check_ids`) but MUST NOT *replace* the omitted check ID in Not Checked."
- **Three structural blind spots (lines 30-32):** each now explicitly tagged `blocks_check_ids=[]` and framed as Known Blind Spots entries (not Not Checked items), with the leading sentence stating they belong in this field, never in the required-omission field above.

## 3. `enloom-skill/references/templates/audit-task-packet.md`

- **§Conclusion Rules (lines 38-42):** old text restated the PASS formula ("verdict = PASS requires: every declared check run + non-empty evidence + blind spots declared") → new text references "the total **Verdict Decision Function** in `evidence-contract.md §Verdict Decision Function` (ordered verdict table + mandatory conclusion mapping) — that section is the SSOT and is not restated here", followed by a summary that does not restate an iff formula.
- **§Not Checked (line 58):** old text "checks that should have run but did not, with why and the risk size (Evidence Contract element 3 + 4)" (conflated elements 3 and 4) → new "**Packet-declared required-check IDs not executed** (Evidence Contract element 3 — required omissions only; a non-empty entry blocks `PASS`). Structural limitations go in Known Blind Spots, not here (C02 disjoint semantics)."

## 4. `enloom-skill/prompt-assets/reviewer.md`

- **§Output (lines 26-37):** verdict and conclusion definitions now preceded by "Both are derived from the total decision function in `evidence-contract.md §Verdict Decision Function`...that section is the SSOT; the lists below are labels only, the conditions are defined there, not restated here". Review conclusion relabeled "(mandatory mapping from verdict; not a free choice)"; `needs-rework`/`rejected` now reference `repair_class` per the owner's mandatory conclusion mapping. FAIL row gained "/ STATUS_INVALID".
- **§How to review step 2 (line 42):** old "Apply the Evidence Contract hard constraint: PASS requires non-empty evidence..." (restated the hard constraint) → new "Derive verdict and conclusion from `evidence-contract.md §Verdict Decision Function` — the ordered verdict table is the hard constraint... Do not apply an independent formula."

## 5. `enloom-skill/prompt-assets/coder.md`

- **§Output bullet 2 (line 25):** four-element reference now carries the disjoint semantics inline: "**Not Checked = packet-declared required-check IDs not executed (blocks PASS)** / **Known Blind Spots = structural/runtime/out-of-scope limitations (each with `blocks_check_ids`; `[]` may coexist with PASS)**. Do not mix the two fields."
- **§How to work steps 3-4 (lines 31-33):** step 3 now points to `§Verdict Decision Function` for the full verdict logic instead of restating only the auto-downgrade rule. Step 4 rewritten to spell out the two omission fields with C02 disjoint semantics (Not Checked = required-check IDs not executed; Known Blind Spots = structural limitations with `blocks_check_ids`; a structural limitation may explain an omission via `blocks_check_ids` but must not replace the ID in Not Checked), and to include the three structural blind spots each with `blocks_check_ids=[]`.

## 6. `enloom-skill/prompt-assets/researcher.md`

- **§Output bullet 2 (line 25):** four-element reference now carries the disjoint semantics inline (same wording as coder.md): "**Not Checked = packet-declared required-check IDs not executed (blocks PASS)** / **Known Blind Spots = structural/runtime/out-of-scope limitations (each with `blocks_check_ids`; `[]` may coexist with PASS)**. Do not mix the two fields."
- **§How to work step 6 (recon task, line 34):** the inline four-element sketch updated to disjoint semantics: "**Not Checked = packet-declared required-check IDs not executed** / **Known Blind Spots = structural uncertainties, each with `blocks_check_ids`**".

## 7. `enloom-skill/references/glossary.md`

- **Evidence Contract entry (line 29):** now states the four elements are "两两 disjoint" and spells out Not Checked ("packet 声明的 required-check ID 中未执行者,阻断 PASS") and Known Blind Spots ("结构性/运行时/越界限制,带 `blocks_check_ids`"); added "verdict 与 conclusion 的判定由 §Verdict Decision Function 作为 total function 唯一给出".
- **Verdict entry (line 32):** now references "`evidence-contract.md §Verdict Decision Function` 作为 total function 唯一给出(ordered verdict table + mandatory conclusion mapping),消费者不复述公式".
- Lines 63-64 ("不要把 Verdict 和 review 结论混用") kept; consistent with the mandatory mapping.

## 8. `enloom-skill/references/workflow-steps.md`

- ONLY Evidence/Verify-related references touched; lifecycle stage structure untouched (P2 scope).
- **Law 4 (line 31):** "Mechanized in evidence-contract.md" → "The verdict and conclusion are mechanized by the total decision function in `evidence-contract.md §Verdict Decision Function`".
- **Stage 4 Verify (lines 165-171):** the three-state verdict list now preceded by "its selection conditions and the mandatory verdict→conclusion mapping are defined exhaustively by the total decision function in `evidence-contract.md §Verdict Decision Function` — that section is the SSOT and is not restated here"; the report-satisfaction line updated to call out the disjoint four-element semantics. The "Hard constraint" paragraph (old "verdict = PASS if and only if...") restating the iff formula → replaced with "the ordered verdict table in §Verdict Decision Function is the complete PASS/FAIL predicate... Apply that function, not an independent formula."

## Countable outputs

- Consumer files changed: **8** (exactly the writable set).
- Files with old formula residue (V01): **0**.
- Primary consumers referencing §Verdict Decision Function (V02): 3/3 (review-checklist.md=3, audit-task-packet.md=1, reviewer.md=2).
- C02 conflation residue (V03): **0** after rewording one false-positive phrase in worker-report.md.
- Forbidden file (evidence-contract.md) touched by this task: **no** (its working-tree change is the pre-existing T-P1-01 rewrite; mtime 11:50:25 precedes all 8 of my edits, which begin at 11:57:57).
