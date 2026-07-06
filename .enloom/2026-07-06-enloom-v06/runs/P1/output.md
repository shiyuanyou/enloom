# P1 Output — 角色命名硬化 + trim rule + 源/副本同步

Task Packet Version: 0.2 · Mode: audited · Role: coder

Source repo root: `/Users/bigo/Library/Mobile Documents/com~apple~CloudDocs/NewIdeas/enloom/enloom-skill/`
Installed copy: `~/.agents/skills/enloom/`

All 7 edit locations applied to the source repo. Each entry below records the file, the exact old_string that matched, and the new_string written.

---

## #1 — `references/eval-guide.md` L31 (P0 遗留: single-agent 残留)

**old_string** (matched uniquely, full line L31):
```
This path needs no external tooling. It is the honest default when no headless subagent dispatch is available. **Known bias**: in a single-agent session the same agent that wrote the skill also grades it — this is a self-graded upper bound, not a validated number. Flag it in the results; do not pretend it is independent.
```

**new_string**:
```
This path needs no external tooling. It is the honest default when no headless subagent dispatch is available. **Known bias**: when the control agent itself runs the eval (not a fresh sub-agent), the same context that wrote the skill also grades it — this is a self-graded upper bound, not a validated number. Flag it in the results; do not pretend it is independent. Path B (fresh sub-agent per query) is the way to remove this bias.
```

Flips "in a single-agent session the same agent…" → "when the control agent itself runs the eval (not a fresh sub-agent)…". Adds the remediation pointer to Path B.

---

## #2 — `references/eval-guide.md` L25 (D2: "hand the model")

**old_string** (matched uniquely, full line L25):
```
1. In a fresh agent turn, hand the model the `prompt`.
```

**new_string**:
```
1. In a fresh agent turn, hand the worker the `prompt`.
```

`the model` → `the worker` (explicit role).

---

## #3 — `prompt-assets/coder.md` L37 (P0 遗留: single-agent 残留)

**old_string** (matched uniquely, full line L37):
```
4. Explicitly declare what you did NOT check (Not Checked) and why (Known Blind Spots) — including, in a single-agent environment, "cross-worker real isolation not independently verifiable."
```

**new_string**:
```
4. Explicitly declare what you did NOT check (Not Checked) and why (Known Blind Spots) — including "cross-worker file isolation: enforced by packet fields, not by process boundary; a worker touching a forbidden file is caught by later audit, not blocked at runtime."
```

Replaces the single-agent framing with the structural blind-spot statement (mirrors worker-report.md Known Blind Spots #1).

---

## #4 — `references/templates/worker-report.md` (D3 缺口: trim rule 段插入)

**Anchor / context above `## Review Result`:**
The section directly above was `## Next` (a short header with one blank line), then two blank lines, then `## Review Result` with its blockquote. To guarantee a unique match, the Edit anchored on the `## Review Result` heading **plus** its immediately-following blockquote line (`> Verdict (PASS / ISSUES / FAIL)…`), and inserted the new section before it.

**old_string** (matched uniquely):
```
## Review Result

> Verdict (PASS / ISSUES / FAIL) + review conclusion (accepted | accepted-with-risk | needs-rework | rejected). See [review-checklist.md](../review-checklist.md).
```

**new_string** (new section inserted before `## Review Result`):
```
## Return To Caller (trim rule)

The control agent receives only: **Result + Checks Run summary + verdict-level Evidence + named risks**. Do not paste full raw output, full command logs, or worker process narrative back into the main window — detail sinks into `output.md` / `raw-notes.md` on disk, where the control agent reads only on evidence-shortfall or failure. This mirrors [audit-task-packet.md §Return To Caller](audit-task-packet.md).

## Review Result

> Verdict (PASS / ISSUES / FAIL) + review conclusion (accepted | accepted-with-risk | needs-rework | rejected). See [review-checklist.md](../review-checklist.md).
```

The new `## Return To Caller (trim rule)` section now sits at L51–L53, directly above `## Review Result` (now L55). Mirrors `audit-task-packet.md:63-65`.

---

## #5 — `references/templates/project-state.md` L38, L43, L53, L58 (D2: "Orient scans this")

All four lines contain the identical token `← Orient scans this.`. Applied a single Edit with `replace_all=true`, which changed all four occurrences identically.

**old_string** (replace_all=true; 4 occurrences at L38, L43, L53, L58):
```
← Orient scans this.
```

**new_string**:
```
← control agent scans this on Orient.
```

Resulting lines (confirmed by grep):
- L38: `> Unmet cross-task / cross-phase dependencies. ← control agent scans this on Orient.`
- L43: `> Discovered broken references: … ← control agent scans this on Orient.`
- L53: `> Accepted items that carry risk and need re-checking. ← control agent scans this on Orient.`
- L58: `> Index of rejected reports — … ← control agent scans this on Orient.`

---

## #6 — `references/templates/task-board.md` L3, L14, L20 (D2: Orient 用法)

Three distinct edits (different lines, applied separately):

**L3**
- old: `> 项目级入口表。一行一 Project。Orient 第一步读本表定位目标项目;…`
- new: `> 项目级入口表。一行一 Project。control agent 在 Orient 第一步读本表定位目标项目;…`
- (`Orient 第一步` → `control agent 在 Orient 第一步`)

**L14**
- old: `- **updated**:最近一次进入该 Project 的日期。每次 Orient/Integrate 后更新。`
- new: `- **updated**:最近一次进入该 Project 的日期。control agent 每次 Orient/Integrate 后更新。`
- (`每次 Orient/Integrate 后` → `control agent 每次 Orient/Integrate 后`)

**L20**
- old: `- **Orient(Stage 1)**:读本表 → 定位目标 project 行…`
- new: `- **Orient(Stage 1)** — control agent reads this:读本表 → 定位目标 project 行…`
- (`**Orient(Stage 1)**:` → `**Orient(Stage 1)** — control agent reads this:`)

---

## #7 — `references/templates/task-packet.md` L7, L19 (D2: make-prompt 被动语态)

Two distinct edits:

**L7**
- old: `…fill accordingly. The \`make-prompt\` self-check (workflow-steps Stage 3) enforces the **required** cells;…`
- new: `…fill accordingly. The control agent's \`make-prompt\` self-check (workflow-steps Stage 3) enforces the **required** cells;…`
- (`The \`make-prompt\` self-check` → `The control agent's \`make-prompt\` self-check`)

**L19**
- old: `> **Self-check rule**: an \`audited\` packet missing Required Verification or Countable outputs fails \`make-prompt\` and cannot dispatch (Stage 3 gate). …`
- new: `> **Self-check rule**: the control agent's \`make-prompt\` step rejects an \`audited\` packet missing Required Verification or Countable outputs — it cannot dispatch (Stage 3 gate). …`

---

## Sync step (Done Signal 前)

After all 7 source edits, ran the packet's sync loop to copy the 6 writable files from `enloom-skill/` to `$HOME/.agents/skills/enloom/`:

```
for f in references/eval-guide.md references/templates/worker-report.md \
         references/templates/project-state.md references/templates/task-board.md \
         references/templates/task-packet.md prompt-assets/coder.md; do
  cp "enloom-skill/$f" "$HOME/.agents/skills/enloom/$f"
done
```

**Sync confirmation** — all 6 copied successfully:
- synced: references/eval-guide.md
- synced: references/templates/worker-report.md
- synced: references/templates/project-state.md
- synced: references/templates/task-board.md
- synced: references/templates/task-packet.md
- synced: prompt-assets/coder.md

Post-sync `diff -q` source-vs-installed: all 6 files MATCH (see report.md → Checks Run → V4).
