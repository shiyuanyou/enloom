# Archive Entry: P3 readonly dogfood

## Scope

Run a real, bounded audited researcher task using the new material-finding Evidence Record and Boundary Check.

## Result

`T003-DOGFOOD-READONLY` completed `PASS / accepted`. Its five typed material findings were locator-backed; the Boundary Check preserved its non-proof semantics; source checksums stayed unchanged.

## Evidence

- `runs/T003-DOGFOOD-READONLY/output.md`
- `runs/T003-DOGFOOD-READONLY/report.md`
- `runs/T003-DOGFOOD-READONLY/review-result.md`

## Limits retained

- This validates a single readonly sample, not cross-domain generalization, runtime isolation, or expansion to other modes/roles.

## Closure

P1 remains the current default only for audited researcher packets whose `Evidence Required` explicitly asks for material-finding locators. P3 remains a self-attestation. Installed copy parity was verified before closure.
