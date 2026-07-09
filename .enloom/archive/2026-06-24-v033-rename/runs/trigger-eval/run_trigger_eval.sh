#!/usr/bin/env bash
# description-only trigger eval runner (enloom rename re-run, run-002).
#
# Copy of AgentOS/runs/trigger-eval/run_trigger_eval.sh with paths updated for
# the agentos→enloom rename. The frozen AgentOS/ original is preserved untouched
# as historical evidence. This runner lives in .enloom/ (the live dogfood workspace).
#
# Feeds ONLY the skill name + description to a fresh-context opencode session
# (--pure = no external plugins, so the skill body cannot be auto-loaded and
#  contaminate the description-only isolation). Scores each query's INVOKE/BYPASS
# against expected_invoke from trigger-evals.json.
#
# Usage:
#   ./run_trigger_eval.sh train   # ids 1-12
#   ./run_trigger_eval.sh test    # ids 13-20
#   ./run_trigger_eval.sh all     # 1-20
#   IDS="1,3,5" ./run_trigger_eval.sh ids
#
# Reads description from SKILL.md frontmatter. Output: TSV to stdout + full raw
# log to .enloom/runs/trigger-eval/raw/<split>/<id>.log
set -euo pipefail

# resolve project root: enloom/ (script lives in enloom/.enloom/runs/trigger-eval/)
PROJ_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$PROJ_ROOT"

SKILL_MD="enloom-skill/SKILL.md"
EVALS_JSON="enloom-skill/evals/trigger-evals.json"
RAW_DIR=".enloom/runs/trigger-eval/raw"

# --- extract description (frontmatter `description:` single line, YAML) ---
SKILL_NAME="enloom"
DESCRIPTION=$(python3 - "$SKILL_MD" <<'PY'
import sys, re, yaml
txt = open(sys.argv[1]).read()
m = re.match(r'^---\n(.*?)\n---\n', txt, re.S)
fm = yaml.safe_load(m.group(1))
print(fm['description'])
PY
)

# --- pick ids ---
SPLIT="${1:-all}"
case "$SPLIT" in
  train) IDS=$(seq 1 12) ;;
  test)  IDS=$(seq 13 20) ;;
  all)   IDS=$(seq 1 20) ;;
  ids)   IDS=$(echo "${IDS:-}" | tr ',' ' ') ;;
  *) echo "unknown split: $SPLIT" >&2; exit 2 ;;
esac

mkdir -p "$RAW_DIR"

WRAP=$(cat <<EOF
You have a skill named "${SKILL_NAME}". Its description is:

"${DESCRIPTION}"

For the following user request, decide whether you would INVOKE this skill or BYPASS (not invoke) it.
Consider ONLY the description above — you have no other information about the skill.
Output EXACTLY one line in this format and nothing else:
VERDICT: INVOKE
or
VERDICT: BYPASS
Then on a second line give ONE sentence of reasoning.
EOF
)

printf "id\tcategory\tsplit\texpected_invoke\tactual_invoke\tverdict\trationale\n"

for id in $IDS; do
  row=$(jq -r --argjson id "$id" '.evals[] | select(.id==$id) | [.id,.category,.split,(.expected_invoke|tostring),.prompt] | @tsv' "$EVALS_JSON")
  [ -z "$row" ] && continue
  # jq @tsv emits: id \t category \t split \t expected \t prompt  (5 fields)
  IFS=$'\t' read -r _id _cat _split _exp _prompt <<< "$row"

  logdir="$RAW_DIR/$_split"; mkdir -p "$logdir"
  logfile="$logdir/${id}.log"

  # fresh context per query, --pure blocks auto skill load.
  # opencode occasionally returns an empty body (transient); retry up to 3x.
  raw=""
  for attempt in 1 2 3; do
    raw=$(opencode run --pure "$WRAP

USER REQUEST: $_prompt" 2>&1) || raw=""
    if printf '%s' "$raw" | grep -qiE 'VERDICT:'; then break; fi
  done
  printf '%s' "$raw" > "$logfile"

  # parse the model's own VERDICT: line (last occurrence wins). `|| true`
  # because grep exits 1 on no-match, which under `set -e` would abort.
  actual=$(printf '%s' "$raw" | grep -iE 'VERDICT:' | tail -1 | sed -E 's/.*VERDICT:[[:space:]]*//I' | tr '[:upper:]' '[:lower:]' || true)
  actual_invoke=""
  case "$actual" in
    invoke*|*invoke*)  actual_invoke="true" ;;
    bypass*|*bypass*)  actual_invoke="false" ;;
    *) actual_invoke="unclear" ;;
  esac

  if [ "$actual_invoke" = "$_exp" ]; then verdict="PASS"; else verdict="FAIL"; fi
  rationale=$(printf '%s' "$raw" | sed -E 's/\x1b\[[0-9;]*m//g' | grep -v -iE 'VERDICT:|^>|^[[:space:]]*$' | tail -1)

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$_cat" "$_split" "$_exp" "$actual_invoke" "$verdict" "$rationale"
done
