# Validation

How to validate that an Enloom skill package is well-formed, **without hard-coding a single language**. The checks below are language-neutral. The agent picks an implementation based on what the current environment actually has, trying the most portable first.

This exists because not every environment ships Python, and even when it does, `PyYAML` is an extra dependency. The skill package itself stays zero-code — the validation logic is described here, and the agent writes a throwaway checker in whatever runtime is available.

## Validation Paths and Promise Boundary

Validation runs on **exactly one** of two paths. The contract is the same 11 rules below; the difference is which inputs a path can honestly decide. Control selects the path explicitly and **names both selection and result** — no silent relabeling.

### V01 — Full official-capable path

A currently available **YAML-capable** validator is shown to execute **all** documented frontmatter rules on the actual frontmatter. Enum:

| Verdict | Meaning |
|---|---|
| `FULL_VALID` | All 11 rules passed against the real (possibly nested/multiline) YAML. |
| `FULL_INVALID` | At least one rule failed; the failing rule is named. |
| `FULL_VALIDATOR_UNAVAILABLE` | No YAML-capable validator is present in this environment. |
| `FULL_RULE_GAP` | A validator is present but cannot execute a documented rule (version/feature gap). |
| `FULL_EXECUTION_ERROR` | A validator is present but errored (parse crash, timeout) before reaching a verdict. |

Exit 0 from V01 may mean the full contract passed **only when** evidence lists the validator/version and rule coverage. `FULL_VALIDATOR_UNAVAILABLE | FULL_RULE_GAP | FULL_EXECUTION_ERROR` are non-verdicts: they can **never** become `FULL_VALID`. If full validation is required but unavailable/fails, control **MUST halt** validation rather than proceed.

### V02 — Flat fallback path

**No dependency.** Supports **only** its declared subset: unindented, single-line, flat scalar frontmatter. It executes **only** the scalar/name/description/key rules it actually implements (see §What to check below for which). Enum:

| Verdict | Meaning |
|---|---|
| `FLAT_VALID` | The flat subset passed the implemented rules. |
| `FLAT_INVALID` | A subset rule failed on a supported input; the failing rule is named. |
| `FLAT_UNSUPPORTED` | Input is nested / multiline / type-sensitive / otherwise out of subset. |

Exit 0 from V02 means **only "flat subset valid,"** **NEVER** full YAML-contract equivalence. Nested/multiline/type-sensitive input → `FLAT_UNSUPPORTED` (non-zero), **NOT** `INVALID` — the fallback does not claim a failure it cannot characterize. V02 **MUST NOT** install dependencies or guess.

Only control selects V02, and only for a declared flat-subset input when full validation is not required. A fallback success **MUST NOT** be relabeled as full success. The decision table:

| Path | Capability / promise | Allowed success | Failure behavior |
|---|---|---|---|
| V01 full | YAML-capable validator executes all documented rules. | Exit 0 may mean full contract passed; evidence lists validator/version + rule coverage. | Tool absent / execution error / rule gap → no full verdict; halt or explicitly choose V02 for a supported flat input. Invalid input → non-zero with failing rule. |
| V02 flat | No dependency; only declared unindented single-line flat scalar subset + its implemented rules. | Exit 0 means only "flat subset valid," never full equivalence. | Nested/multiline/type-sensitive/out-of-subset → non-zero `FLAT_UNSUPPORTED`; detected subset violation → non-zero `FLAT_INVALID`; MUST NOT install dependencies or guess. |

## What to check (the contract)

Given a skill directory `<skill>/SKILL.md`, verify ALL of:

1. **File exists.** `<skill>/SKILL.md` is present.
2. **Frontmatter present.** Content starts with a line that is exactly `---`.
3. **Frontmatter closed.** A second `---` closes the YAML block (not EOF).
4. **Frontmatter is a dict.** The block between the fences parses as a YAML mapping (not a scalar, not a list).
5. **No unexpected keys.** Only these top-level keys are allowed: `name`, `description`, `license`, `allowed-tools`, `metadata`, `compatibility`. (Nested keys under `metadata` are fine.)
6. **name present** and is a string.
7. **name is kebab-case:** matches `^[a-z0-9-]+$`, does not start/end with `-`, contains no `--`, length ≤ 64.
8. **description present** and is a string.
9. **description has no angle brackets** (`<` or `>`) — they break some frontmatter parsers.
10. **description length ≤ 1024.**
11. **If `compatibility` present:** string, length ≤ 500.

Any failure → print the failing rule and exit non-zero. All pass → print `Skill is valid!` and exit 0.

**Which path can run which rule.** V01 can run all 11 on any real YAML. V02 flat fallback can run **rules 1–3 and 6–10** on a declared flat scalar frontmatter, plus rule 5 **on flat top-level keys only** (it cannot inspect nested `metadata`). Rule 4 (parses as a mapping) and rule 11 (a typed string check on a key that, when nested, defeats flat parsing) require a YAML-capable validator — V02 reports `FLAT_UNSUPPORTED` for inputs needing them, not a verdict. The 11 rules remain the full contract; V02's coverage is an honest subset, not a redefinition.

## Choosing an implementation (priority order)

Try in this order. Use the first runtime the environment actually has. Do NOT require the user to install anything.

### 1. bash (preferred — ships on macOS/Linux, near-universal)

`grep`/`sed`/`awk` can do the **flat subset** checks. The frontmatter this skill uses is flat `key: value` lines, so the flat path does not need a real YAML parser — simple text extraction is enough. For nested/multiline/type-sensitive input, bash returns `FLAT_UNSUPPORTED`, not a verdict. Windows needs Git Bash or WSL.

### 2. node / JavaScript (second — wide on dev machines)

Node's standard library has no YAML parser, but again the flat frontmatter here is flat. Read the file, split on `---`, parse `key: value` lines manually — this implements the same flat subset (V02). `JSON` is available for any structured checks if you ever extend this. For real nested YAML you need a YAML library, which moves you to V01.

### 3. python3 (last — avoid if possible to dodge PyYAML)

If you must use Python, **do not `import yaml`** — that drags in PyYAML. Parse the flat `key: value` frontmatter yourself with the standard library (V02 subset). Only reach for PyYAML (moving to V01) if the frontmatter is genuinely nested; if so, say so explicitly and record the validator/version.

## Reference: bash implementation

This is a reference, not a shipped script. The agent should adapt it to the target environment rather than copy blindly — e.g. adjust the path, or rewrite in node/python if bash is absent.

**This implements ONLY the V02 flat fallback subset.** It returns `FLAT_UNSUPPORTED` for nested/multiline input, not `INVALID`. It does **not** do full YAML validation — exit 0 means only "flat subset valid," never full contract equivalence.

```bash
#!/usr/bin/env bash
# Validate a skill's SKILL.md frontmatter — V02 flat subset only.
# Usage: validate.sh <skill-dir>
# V02 verdicts: FLAT_VALID (exit 0) | FLAT_INVALID (exit 1) | FLAT_UNSUPPORTED (exit 2)
set -u
skill_dir="${1:?Usage: validate.sh <skill-dir>}"
f="$skill_dir/SKILL.md"
[ -f "$f" ] || { echo "FLAT_INVALID: SKILL.md not found"; exit 1; }

# Extract frontmatter block (text between the first two --- lines; EOF is NOT a fence)
fm=$(awk 'NR==1 && $0=="---"{f=1;next} f && $0=="---"{exit} f' "$f")
[ -n "$fm" ] || { echo "FLAT_INVALID: missing/unterminated frontmatter"; exit 1; }

# V02 promise boundary: reject any input outside the flat single-line scalar subset.
# Indented (nested) or multi-line block-scalar content => FLAT_UNSUPPORTED, not a verdict.
if printf '%s\n' "$fm" | grep -Eq '^[[:space:]]'; then
  echo "FLAT_UNSUPPORTED: indented/nested content — needs a YAML-capable validator (V01)"; exit 2
fi

# name
name=$(awk -F': ' '/^name:/{print $2}' <<<"$fm")
[ -n "$name" ] || { echo "FLAT_INVALID: missing 'name'"; exit 1; }
echo "$name" | grep -Eq '^[a-z0-9-]+$' || { echo "FLAT_INVALID: name '$name' not kebab-case"; exit 1; }
case "$name" in -*|*-) echo "FLAT_INVALID: name cannot start/end with hyphen"; exit 1;; esac
echo "$name" | grep -q -- '--' && { echo "FLAT_INVALID: name cannot contain consecutive hyphens"; exit 1; }
[ "${#name}" -le 64 ] || { echo "FLAT_INVALID: name too long (max 64)"; exit 1; }

# description
desc=$(awk -F': ' '/^description:/{sub(/^description: /,""); print}' <<<"$fm")
[ -n "$desc" ] || { echo "FLAT_INVALID: missing 'description'"; exit 1; }
case "$desc" in *'<'*|*'>'*) echo "FLAT_INVALID: description cannot contain angle brackets"; exit 1;; esac
[ "${#desc}" -le 1024 ] || { echo "FLAT_INVALID: description too long (max 1024)"; exit 1; }

# unexpected keys (flat top-level keys only; nested metadata not inspected by V02)
allowed='name description license allowed-tools metadata compatibility'
while IFS= read -r line; do
  key=$(echo "$line" | awk -F': *' '{print $1}')
  [ -z "$key" ] && continue
  echo "$allowed" | grep -qw "$key" || { echo "FLAT_INVALID: unexpected key: $key"; exit 1; }
done <<<"$fm"

echo "FLAT_VALID: flat subset valid"
```

## Markdown Reference Integrity

This section is the unique owner SSOT for reference-link integrity in this package.

- A Markdown link target **MUST** contain only a resolvable relative path/URL.
- A human-readable `§Section Title` hint **MUST** appear in the link **label** or adjacent prose, **NEVER** inside the target. A target that embeds a `§N` after the path is malformed; put the section number in the label or in prose instead, e.g. `label (§2)` as the link text or note the section in a sentence beside the link.
- Inline code examples such as `` `[x](path)` `` **MUST** remain code and **MUST NOT** be "fixed" as links — they are illustrative pseudo-links, not navigation.

## What this is NOT

- Not a behavior eval. Passing this means the skill is *well-formed*, not that it triggers or decides correctly. Behavior is judged on real tasks, not a structural check.
- Not tied to skill-creator's `quick_validate.py`. That script (needs Python + PyYAML) implements the *same* checks and is fine when available — but it is **one implementation** (a V01 instance when PyYAML is present), not the canonical one. This guide is the environment-neutral contract; `quick_validate.py` is a convenient instance of it for Python environments. Use whichever your environment has, and name the path.

## Why not ship one script?

Enloom is a zero-code, pure-document skill by design (see PROGRESS.md "不做的事": no CLI, no runtime). Hard-coding a `validate.sh` or `validate.py` in `scripts/` would make the package depend on one runtime and contradict that stance. Describing the checks + letting the agent implement them in-situ keeps the package portable and the validation honest — the agent can only validate what its environment can actually run, and the V01/V02 boundary forces it to say so.
