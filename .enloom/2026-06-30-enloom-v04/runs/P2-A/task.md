# Task Packet: P2-A

Task Packet Version: 0.2
Mode: audited
Role: integrator

## Goal

改 `references/eval-guide.md` 行 115/128 两处裸路径:`.enloom/runs/trigger-eval/` → `.enloom/<project>/runs/trigger-eval/`,`.enloom/runs/<TASK>/` → `.enloom/<project>/runs/<TASK>/`。这是全包唯一残留的裸 `.enloom/` 路径(P1 后全包扫描确认)。

## Anti Goal

- 不改 eval-guide 其他内容。
- 不改其他 B 组文件(scheduler-rules/task-packet/worker-report/review-checklist/prompt-assets 用相对路径,项目目录语境下正确,不需改)。

## Inputs

- eval-guide.md 行 115/128。
- SKILL.md File Protocol v0.4 命名空间结构。

## Existing State

全包扫描后仅此 2 处裸路径。

## Writable Files

- `references/eval-guide.md`

## Forbidden Files

- 其余 enloom-skill/ 文件 / project_state / design / 旧 .enloom

## Acceptance Criteria

- 行 115/128 路径加 `<project>/` 前缀。
- 全包 grep 裸 `.enloom/runs` 归零。

## Required Verification

- check_item:改后全包无裸 `.enloom/runs`(应有 `<project>`)。

## Done Signal

done + grep 证据。
