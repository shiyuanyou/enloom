# Worker Report: T003-DOGFOOD-READONLY

## Result

done — the fresh packet freezes all three P3 baselines directly in Existing State; V1–V4 completed against that authority.

## Files Changed

- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/output.md`
- `.enloom/2026-07-17-prompt-workflow-optimization/runs/T003-DOGFOOD-READONLY/report.md`

## Boundary Check

> Worker self-attestation for reviewer lookup only; it is not proof of runtime isolation, permission enforcement, independent verification, or a stronger `PASS`.

- Actual inputs investigated: the five source files named in the packet; installed researcher asset as explicitly directed by control; task packet.
- Packet-boundary deviations and reasons: none.
- Source / config / state modifications: none.
- Out-of-scope questions: broader-default adoption remains a control decision after review; this is one dogfood sample only.

## Checks Run

- `V1` pass — Evidence Record has 5 material findings, each with a permitted type and locator/basis.
- `V2` pass — located the audited, researcher, and packet-declared-locator gates and documented their joint effect in F1/F2/F4.
- `V3` pass — located Boundary Check and its explicit non-proof rule; confirmed Evidence Contract field and review-result ownership remain separate.
- `V4` pass — SHA-256 values match all three baselines frozen in the fresh task packet.

## Evidence

- `V1`: `output.md` Evidence Record F1–F5 provides the 5-item count, types, and locators/bases.
- `V2`: `enloom-skill/prompt-assets/researcher.md` §Output, lines 22–26; `enloom-skill/references/templates/task-packet.md` §Evidence Required, lines 66–79.
- `V3`: `enloom-skill/references/templates/worker-report.md` §§Boundary Check and "Review Result lives in a sibling file", lines 12–19 and 63–69; `enloom-skill/references/evidence-contract.md` §The Four Elements, lines 5–21.
- `V4`: `shasum -a 256` returned all three frozen packet baselines exactly:
  - `1f1f470cac6e2e06b54c1c8a9d40ad415d79eb01ac9c742040dfb18a207e1298` — `enloom-skill/prompt-assets/researcher.md`
  - `7c558642047becded9e5597e37315d2a3885fdd7adb30b2c3d280b1e80052329` — `enloom-skill/references/templates/task-packet.md`
  - `ce5929c1cd55166c89e0d4116fe57345f6d95a713b7021f81b63fd752dde418e` — `enloom-skill/references/templates/worker-report.md`

## Not Checked

None.

## Known Blind Spots

| limitation_id | blocks_check_ids | reason | risk |
|---|---:|---|---|
| cross-worker-file-isolation | [] | Packet discipline is not runtime isolation. | This Boundary Check must not be treated as an isolation proof. |
| cross-role-verification | [] | Review may share a model or session. | The dogfood review is not guaranteed to be an independent re-derivation. |

## Risks

- This one sample does not establish whether P1 should expand beyond the current joint trigger.

## Registry Updates

None.

## State Update

None; packet forbids state and registry writes.

## Next

Control should review this sample's Evidence Record and Boundary Check, then decide whether the current audited-researcher trigger remains the default or narrows to explicit packet opt-in.

## Return To Caller (trim rule)

done — P1/P3 contract boundaries pass this read-only sample (V1–V4); source hashes match the fresh packet baselines. Output/report are at the declared paths.
