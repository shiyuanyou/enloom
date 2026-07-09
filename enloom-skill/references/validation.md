# Validation

How to validate that an Enloom skill package is well-formed, **without hard-coding a single language**. The checks below are language-neutral. The agent picks an implementation based on what the current environment actually has, trying the most portable first.

This exists because not every environment ships Python, and even when it does, `PyYAML` is an extra dependency. The skill package itself stays zero-code — the validation logic is described here, and the agent writes a throwaway checker in whatever runtime is available.

## What to check (the contract)

Given a skill directory `<skill>/SKILL.md`, verify ALL of:

1. **File exists.** `<skill>/SKILL.md` is present.
2. **Frontmatter present.** Content starts with a line that is exactly `---`.
3. **Frontmatter closed.** A second `---` closes the YAML block.
4. **Frontmatter is a dict.** The block between the fences parses as a YAML mapping (not a scalar, not a list).
5. **No unexpected keys.** Only these top-level keys are allowed: `name`, `description`, `license`, `allowed-tools`, `metadata`, `compatibility`. (Nested keys under `metadata` are fine.)
6. **name present** and is a string.
7. **name is kebab-case:** matches `^[a-z0-9-]+$`, does not start/end with `-`, contains no `--`, length ≤ 64.
8. **description present** and is a string.
9. **description has no angle brackets** (`<` or `>`) — they break some frontmatter parsers.
10. **description length ≤ 1024.**
11. **If `compatibility` present:** string, length ≤ 500.

Any failure → print the failing rule and exit non-zero. All pass → print `Skill is valid!` and exit 0.

## Choosing an implementation (priority order)

Try in this order. Use the first runtime the environment actually has. Do NOT require the user to install anything.

### 1. bash (preferred — ships on macOS/Linux, near-universal)

`grep`/`sed`/`awk` can do every check above. The frontmatter this skill uses is flat `key: value` lines, so you don't need a real YAML parser — simple text extraction is enough. Windows needs Git Bash or WSL.

### 2. node / JavaScript (second — wide on dev machines)

Node's standard library has no YAML parser, but again the frontmatter here is flat. Read the file, split on `---`, parse `key: value` lines manually. `JSON` is available for any structured checks if you ever extend this.

### 3. python3 (last — avoid if possible to dodge PyYAML)

If you must use Python, **do not `import yaml`** — that drags in PyYAML. Parse the flat `key: value` frontmatter yourself with the standard library. Only fall back to PyYAML if the frontmatter is genuinely nested (it isn't, for this skill).

## Reference: bash implementation

This is a reference, not a shipped script. The agent should adapt it to the target environment rather than copy blindly — e.g. adjust the path, or rewrite in node/python if bash is absent.

```bash
#!/usr/bin/env bash
# Validate a skill's SKILL.md frontmatter. Pure bash, no Python.
# Usage: validate.sh <skill-dir>
# Exits 0 + prints "Skill is valid!" on success, 1 + reason on failure.
set -u
skill_dir="${1:?Usage: validate.sh <skill-dir>}"
f="$skill_dir/SKILL.md"
[ -f "$f" ] || { echo "SKILL.md not found"; exit 1; }

# Extract frontmatter block (text between the first two --- lines)
fm=$(awk 'NR==1 && $0=="---"{f=1;next} f && $0=="---"{exit} f' "$f")
[ -n "$fm" ] || { echo "Invalid frontmatter format"; exit 1; }

# name
name=$(awk -F': ' '/^name:/{print $2}' <<<"$fm")
[ -n "$name" ] || { echo "Missing 'name' in frontmatter"; exit 1; }
echo "$name" | grep -Eq '^[a-z0-9-]+$' || { echo "Name '$name' should be kebab-case"; exit 1; }
case "$name" in -*|*-) echo "Name cannot start/end with hyphen"; exit 1;; esac
echo "$name" | grep -q -- '--' && { echo "Name cannot contain consecutive hyphens"; exit 1; }
[ "${#name}" -le 64 ] || { echo "Name too long (max 64)"; exit 1; }

# description
desc=$(awk -F': ' '/^description:/{sub(/^description: /,""); print}' <<<"$fm")
[ -n "$desc" ] || { echo "Missing 'description' in frontmatter"; exit 1; }
case "$desc" in *'<'*|*'>'*) echo "Description cannot contain angle brackets"; exit 1;; esac
[ "${#desc}" -le 1024 ] || { echo "Description too long (max 1024)"; exit 1; }

# unexpected keys
allowed='name description license allowed-tools metadata compatibility'
while IFS= read -r line; do
  key=$(echo "$line" | awk -F': *' '{print $1}')
  [ -z "$key" ] && continue
  echo "$allowed" | grep -qw "$key" || { echo "Unexpected key: $key"; exit 1; }
done <<<"$fm"

echo "Skill is valid!"
```

## What this is NOT

- Not a behavior eval. Passing this means the skill is *well-formed*, not that it triggers or decides correctly. Behavior is judged on real tasks, not a structural check.
- Not tied to skill-creator's `quick_validate.py`. That script (needs Python + PyYAML) implements the *same* checks and is fine when available — but it is **one implementation**, not the canonical one. This guide is the environment-neutral contract; `quick_validate.py` is a convenient instance of it for Python environments. Use whichever your environment has.

## Why not ship one script?

Enloom is a zero-code, pure-document skill by design (see PROGRESS.md Non-Goals: no CLI, no runtime). Hard-coding a `validate.sh` or `validate.py` in `scripts/` would make the package depend on one runtime and contradict that stance. Describing the checks + letting the agent implement them in-situ keeps the package portable and the validation honest — the agent can only validate what its environment can actually run.
