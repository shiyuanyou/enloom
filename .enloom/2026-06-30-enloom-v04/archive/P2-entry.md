# Archive Entry: P2 (引用层)

Date: 2026-06-30
Review Result: accepted

## Completed

引用层路径修复:eval-guide.md 行 115/128 两处裸 `.enloom/runs/` 加 `<project>/` 前缀。全包裸 `.enloom/runs` 归零。

## Outputs

- `references/eval-guide.md`(2 处路径)。

## Evidence

- 全包 grep `\.enloom/runs`(排除 `<project>`)无输出。
- B 组其余文件(scheduler-rules/task-packet/worker-report/review-checklist/prompt-assets)用相对路径形态(`runs/TASK_ID/`、`project_state`),项目目录语境正确,不需改。

## Verification

- checks_run: P2-1(行 115/128 前缀)/ P2-2(全包归零)/ P2-3(B 组相对路径确认)
- passed: 全部
- failed: (无)
- not_run: (无)

## Decisions Updated

(无)

## Project State Updated

✓ Pending Dependencies 清除 P2,加 P3 待办。

## Registry Updates

(无 broken/rejected)

## Open Risks Carried Forward

(无)

## Raw Material Handling

P2-A 的 task.md/report.md 落盘于 runs/P2-A/。

## Next Step

P3 产物层:README/PROGRESS + 旧 dogfood 冻结确认 + 全局重装。
