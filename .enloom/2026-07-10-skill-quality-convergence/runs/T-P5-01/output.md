# T-P5-01 — Output (C05 naming cleanup, C12 compatibility preflight, C14 install)

## Summary

Implemented three canonical rules across the three owner files. C05 broad lifecycle-naming cleanup in workflow-steps.md; C12 compatibility preflight (frontmatter + prose section) in SKILL.md; C14 executable install procedure + parity check, plus C05 README heading and P3 Five-Laws consistency, in README.md. The SKILL.md `description` frontmatter field is unchanged (F-D7-02 guard preserved).

## Per-file changes

### 1. `enloom-skill/references/workflow-steps.md` — C05 broad naming cleanup

**Pre-existing state (post-P2):** Line 3 already carried the qualified phrase "Stage 0 Triage entry decision + six-stage lifecycle (Stages 1–6)" (P2 phrase guard applied to a modified sentence). However, the 7-row code-block walkthrough (rows `0. Triage … 6. Close`) sat directly under that header with no qualifier, so a reader scanning the block saw seven numbered rows under six-stage wording. Line 255 (Health Check) already qualified "the six-stage lifecycle (Stages 1–6)".

**Change:** Added one qualifier paragraph immediately after the 7-row code block (now lines 15–16) stating explicitly that the walkthrough spans **one entry stage (Stage 0 Triage) plus six lifecycle stages (Stages 1–6)** — seven rows total — that Triage is the side-effect-free entry decision, not one of the six lifecycle stages, and that "Stages 0–6" is only accurate when it carries this one-plus-six qualifier. This is the C05 broad cleanup that P2's phrase guard deferred: P2 guarded *new/changed* sentences, P5 cleans up the *pre-existing* unqualified walkthrough framing.

**No stage logic changed** — naming/count only, per the C05 minimal migration boundary.

### 2. `enloom-skill/SKILL.md` — C12 compatibility preflight

**Pre-existing state (post-P3):** Frontmatter had `name` + `description` only; no compatibility metadata. Body had no statement of the independent-sub-agent requirement or its preflight timing.

**Changes:**
- **Frontmatter:** Added a `compatibility` field (line 4) summarizing the requirement — full Enloom requires dispatch to an independent sub-agent, no control-self-execution fallback, control MUST preflight after `enloom` and before any `.enloom` write/fold/dispatch. `description` is byte-for-byte unchanged (V06 confirms exactly one `description:` field).
- **Body:** Added a new `## Compatibility Preflight (C12)` section (lines 62–71), placed before `## References`. The section states, in prose:
  - Full Enloom requires dispatch to an **independent sub-agent**; there is no control-self-execution fallback (control is the serial namespace owner/orchestrator, not a worker substitute). Some hosts ignore `compatibility` frontmatter, so the prose is the mandatory statement.
  - **Preflight timing:** after Stage 0 Triage returns `enloom` but **before** creating/updating `.enloom/`, folding, or dispatching, control MUST preflight availability.
  - `yes` → proceed, copy evidence into every phase plan / task packet.
  - `no` or `unknown` → **hard halt**, emit a minimal runtime-switch message, stop. `no` and `unknown` behave identically (unknown is never assumed `yes`).
  - Concurrent dispatch / actual concurrency / model-session diversity are optional C08 soft facts, not compatibility gates; independent sub-agent is the sole hard halt.

This satisfies both the frontmatter machine-facing summary and the mandatory prose preflight, and encodes the C12 amendment (independent sub-agent `no|unknown` is the sole hard halt; the other three C08 unknowns are soft).

### 3. `README.md` — C14 install + C05 + P3 consistency

**Pre-existing state:** §Install had a comment-only code block (`# from this repo, package + install (uses skill-creator tooling)`) with no executable command, no stated destination, no parity check. §How it works heading read "六阶段生命周期" (unqualified). Five Laws line 52 read "archive gate requires every report's Review Result filled" (pre-RA3/P3 wording).

**Changes:**
- **C14 (§Install):** Replaced the comment-only block with an executable procedure and a parity check. The supported mechanism is a source copy to the agent home — `cp -r enloom-skill/ ~/.agents/skills/enloom/` — stating the destination (`~/.agents/skills/enloom/`), followed by `diff -qr enloom-skill/ ~/.agents/skills/enloom/` as the parity check, with guidance that clean `diff` (no output, exit 0) means parity and that `cp` should be re-run after source changes. This matches the actual sync method used in practice and is independently checkable.
- **C05 (§How it works):** Heading "六阶段生命周期" → "Stage 0 Triage + 六阶段生命周期（Stages 1–6）" — the one-plus-six qualifier applied to README's bilingual heading.
- **P3 consistency (Five Laws, line 52):** "archive gate requires every report's Review Result filled" → "archive gate requires every review-result.md to exist" — aligns README with the RA3 file-level split (`review-result.md` is now a separate control-owned file, not a report subsection).

## Verification results (V01–V07)

All seven required checks pass:

| ID | Named list | Command result | Required | Pass |
|---|---|---|---|---|
| V01 | c05_workflow | 3 hits (`six-stage lifecycle\|Stage 0 Triage.*six\|六阶段`) | >= 2 | yes |
| V02 | c12_skill | 6 hits (`compatibility\|Compatibility Preflight\|preflight`) | >= 2 | yes |
| V03 | c12_no_fallback | 3 hits (`no.*fallback\|self-execution fallback\|halt.*runtime`) | >= 1 | yes |
| V04 | c14_install | 2 hits (`cp -r enloom-skill\|diff -qr enloom`) | >= 2 | yes |
| V05 | c14_comment_block | 0 hits (`# from this repo\|skill-creator tooling`) | 0 | yes |
| V06 | f_d7_02_guard | 1 hit (`description:`) | exactly 1 | yes |
| V07 | p3_readme_consistency | 0 hits (`Review Result filled`) | 0 | yes |

## Countable outputs

- C05 qualified phrases in workflow-steps.md: 3 (up from 2 post-P2; added the walkthrough qualifier).
- C12 compatibility statements in SKILL.md: 6 (frontmatter `compatibility` field + 5 body statements in the new section).
- C14 executable commands in README.md: 2 (`cp -r` install + `diff -qr` parity).
- `description` field count in SKILL.md: 1 (unchanged).

## Scope discipline

- Wrote only to the 3 Writable Files. No Forbidden Files touched.
- `description` frontmatter unchanged (F-D7-02 evidence-gap guard honored).
- No consumer files (glossary, trigger-contract, PROGRESS, review-checklist) edited — those are T-P5-02.
- No Evidence/lifecycle/ownership/namespace semantics changed.
