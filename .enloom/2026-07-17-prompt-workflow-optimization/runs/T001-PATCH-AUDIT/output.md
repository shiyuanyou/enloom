# T001-PATCH-AUDIT · Independent Research Output

## Countable Outputs

- Material findings: **7** (F1–F7 below).
- Proposed Enloom edit locations: **3** (L1–L3 below).

## Material Findings

### F1 — P1 fills a locator gap; it must not restate epistemic categories

**Type:** fact

The researcher asset already requires citations and separates sourced facts, unverified hypotheses, and open questions. The prompt-control reference gives the same three-way distinction and requires per-source provenance, but neither defines the minimum locator for a material finding in local code, document, or log research. P1 should therefore add only the materiality-plus-locator rule; duplicating the category definitions would overlap existing guidance.

**Evidence:** `enloom-skill/prompt-assets/researcher.md` §Output and §How to work, lines 22–34; `enloom-skill/references/prompt-control.md` §4 "Epistemic Discipline", lines 96–133; audit `final-report.md` §5 "P1", lines 136–155.

### F2 — P1 has a mode-aware packet hook already

**Type:** fact

The ordinary packet already carries `Mode`, `Role`, and an `Evidence Required` field. Its audited mode requires verification and countable outputs, while lifecycle guidance says density must not be applied uniformly to emergent work. The new locator requirement can therefore be made specific to a researcher packet that is both `audited` and explicitly asks for material-finding locators; recon and emergent packets remain unaffected.

**Evidence:** `enloom-skill/references/templates/task-packet.md` §Mode-differentiated field requirements, lines 3–19, and §Evidence Required, lines 66–77; `enloom-skill/references/workflow-steps.md` §Stage 3, lines 134–151; `.clear-mind/2026-07-17-prompt-workflow-optimization/review.md` §1 and §4, lines 34–40 and 60–67.

### F3 — Exact P1 trigger is a joint mode/role/packet condition

**Type:** hypothesis

The smallest trigger is: apply an Evidence Record only when the worker role is `researcher`, the packet mode is `audited`, and that packet's `Evidence Required` declares a material-finding locator. The record lists only material findings; facts cite a source locator, hypotheses cite their dependent facts and reasoning, and open questions identify missing evidence or the next check. This preserves the current fact/hypothesis/open-question discipline while making the demanded provenance reviewable.

**Dependent facts and reasoning:** F1 establishes that categories already exist but locator granularity does not; F2 establishes the available mode/role/packet controls. The Clear-Mind plan and review require packet-declared, mode-aware use rather than all-mode enforcement: `.clear-mind/2026-07-17-prompt-workflow-optimization/plan.md` §2 and §6, lines 38–50 and 74–92; `review.md` §4, lines 60–67.

### F4 — Existing report fields do not expose actual input scope or deviations

**Type:** fact

`Files Changed` reports changes, while `Known Blind Spots` is reserved for structural/runtime/out-of-scope limitations and must not absorb required-check omissions. Neither gives the reviewer a compact declaration of what inputs were actually investigated, whether the worker departed from the packet, or whether source/config/state was modified. `review-result.md` is control-owned and cannot host a worker self-declaration.

**Evidence:** `enloom-skill/references/templates/worker-report.md` §§Files Changed, Not Checked, Known Blind Spots, and "Review Result lives in a sibling file", lines 9–35 and 57–59; `enloom-skill/references/evidence-contract.md` §The Four Elements, lines 5–21; `enloom-skill/references/templates/task-packet.md` §Forbidden Files, lines 41–51.

### F5 — P3 must stay a declaration, not a proof

**Type:** fact

Current Enloom explicitly says writable/forbidden lists enforce worker isolation by packet discipline rather than an independent runtime, and calls cross-role verification a non-guarantee. A Boundary Check may improve review navigation, but it cannot certify runtime isolation, permissions, independent verification, or a stronger PASS.

**Evidence:** `enloom-skill/references/evidence-contract.md` §The Honest Blind Spots, lines 169–177; `enloom-skill/references/templates/worker-report.md` §Known Blind Spots, lines 27–36; `.clear-mind/2026-07-17-prompt-workflow-optimization/review.md` §1 and §4, lines 36–40 and 60–67.

### F6 — P3 needs its own report section rather than reusing contract fields

**Type:** hypothesis

Place a `Boundary Check` immediately after `Files Changed` and before `Checks Run`. It should declare: actual inputs investigated (including necessary linked inputs), packet-boundary deviations and reasons, source/config/state modifications (`none` or list), and out-of-scope questions. Its introductory rule must say it is a worker self-attestation and reviewer lookup aid, not evidence for isolation or verification. This avoids overloading Files Changed, Evidence Contract elements, Known Blind Spots, Risks, or the control-owned review result.

**Dependent facts and reasoning:** F4 identifies the semantic gaps and ownership boundary; F5 identifies the non-proof constraint. The requested P3 shape is compatible with the audit source but should include deviations, not merely "packet-listed inputs: yes/no": `/Users/bigo/bigo-projects/mediascripts/.enloom/2026-07-17-prompt-workflow-quality-audit/final-report.md` §5 "P3", lines 180–196; `.clear-mind/2026-07-17-prompt-workflow-optimization/plan.md` §2, lines 43–50.

### F7 — Value remains unproven until one read-only dogfood run

**Type:** open question

No real task in this phase has yet shown that P1/P3 reduce review time or citation theatre. The next decision should be based on one 3–6-file, read-only audited researcher task; retain packet opt-in if its report cannot support a fast sample review.

**Evidence:** `.clear-mind/2026-07-17-prompt-workflow-optimization/explore.md` §4, lines 48–51; `plan.md` §8, lines 86–92; `review.md` §3, lines 52–58.

## Proposed Enloom Edit Locations

### L1 — Researcher asset: P1 behavioral rule

**Location:** `enloom-skill/prompt-assets/researcher.md`, `## Output`, directly after the `output.md` bullet (current line 24) and before the `report.md` bullet (current line 25).

**Semantic constraint:** define the joint P1 trigger from F3 and point to the packet's `Evidence Required` as the owner of locator granularity. Require a compact Evidence Record only for material findings and refer to existing epistemic-discipline guidance for category meanings; do not replicate that guidance or turn the condition into a rule for recon/emergent work.

### L2 — Task-packet template: P1 control helper

**Location:** `enloom-skill/references/templates/task-packet.md`, `## Evidence Required`, immediately after the current helper paragraph (current lines 66–70) and before `Countable outputs` (current line 72).

**Semantic constraint:** tell control to state whether an audited researcher requires material-finding locators and, if so, the acceptable source-locator form. The helper must preserve packet authority over scope/granularity and must not make every audited role, or every citation, a row in an Evidence Record.

### L3 — Worker-report template: P3 review entry point

**Location:** `enloom-skill/references/templates/worker-report.md`, directly after `## Files Changed` (current lines 9–11) and before `## Checks Run` (current line 12).

**Semantic constraint:** use the F6 four declarations and label them worker self-attestation. Keep `Checks Run`/`Evidence`/`Not Checked`/`Known Blind Spots` unchanged; do not move or duplicate the control-owned sibling review result.

## Explicit Non-Locations

- Do not edit `evidence-contract.md`: P1/P3 do not alter its four-element semantics or verdict function.
- Do not edit `workflow-steps.md`: P1/P3 do not add a lifecycle stage or dispatch gate.
- Do not edit Clear-Mind source in this phase: P2 remains sibling-project work.

**Evidence:** `.clear-mind/2026-07-17-prompt-workflow-optimization/plan.md` §2, §6, and §7, lines 38–50 and 74–84; `review.md` §4, lines 60–67; `enloom-skill/references/evidence-contract.md` §The Four Elements, lines 5–21.
