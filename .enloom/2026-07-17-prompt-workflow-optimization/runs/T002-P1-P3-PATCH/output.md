# T002-P1-P3-PATCH · Patch Notes

## Changed Source Files (3)

1. `enloom-skill/prompt-assets/researcher.md`
   - Added the P1 Evidence Record trigger: role `researcher` + mode `audited` + packet-explicit material-finding locator requirement.
   - Delegates category semantics to existing Epistemic Discipline guidance.
2. `enloom-skill/references/templates/task-packet.md`
   - Added the control helper that declares Evidence Record use and locator granularity for audited researcher packets.
   - Specifies locator treatment for fact, hypothesis, and open question without redefining the taxonomy.
3. `enloom-skill/references/templates/worker-report.md`
   - Added Boundary Check after Files Changed, with actual inputs, deviations/reasons, source/config/state modifications, and out-of-scope questions.
   - States that it is self-attestation, not proof of runtime isolation, independent verification, or a stronger PASS.

## New Named Source Requirements (3)

1. Audited-researcher Evidence Record trigger.
2. Packet-owned material-finding locator declaration.
3. Boundary Check self-attestation.

## Scope Preserved

- No Evidence Contract or workflow/lifecycle source changed.
- No change to the sibling `review-result.md` control ownership.
- No installed-copy synchronization was attempted.
