# Output: P1-D

> 改动文件:`enloom-skill/references/workflow-steps.md`。

## 改动点

1. **生命周期总览**(行 13 后):加「Landing gates」段,引用 landing-contract §1/§2,说明双保险(control 自检 + health-check 硬闸门)。
2. **Stage 0 Triage**:加 Entry/Exit gate(— / triage 结果);Inputs 路径 `.enloom/project_state.md` → `.enloom/<project>/project_state.md`(located via task_board)。
3. **Stage 1 Orient**:加 Entry gate(task_board.md exists)/ Exit gate(状态摘要);读取顺序首步改为「读 task_board.md 定位项目」,第 2 步起读 `.enloom/<project>/` 内文件;新增「不读其他项目目录」纪律。
4. **Stage 2 Plan**:加 Entry(project 目录存在)/ Exit(phase-plan-<phase>.md 存在 + goal 清晰)。
5. **Stage 3 Execute**:加 per-task Entry gate(Law 2:task.md 存在)/ Exit gate(output.md+report.md 存在+Result 段);Output 段补「packet 写进 task.md 后再 dispatch,交路径非口头」。
6. **Stage 4 Verify**:加 Entry(report.md 存在+四要素)/ Exit(Review Result 段已填);读取路径加 `<project>/` 前缀注释。
7. **Stage 5 Integrate**:加 Entry(所有 task Review Result 已填)/ Exit(project_state+Registry 更新+compaction 检查);Update 列表加项目相对路径注释。
8. **Stage 6 Close**:加 Entry(Integrate exit gate 全过)/ Exit(Law 5 机械化:archive-entry.md 存在+Review Result 已填+health-check 硬验)。
9. **Health Check 段**:从「periodic」升级为「stage-transition hard gate + periodic drift」双角色;gate files present 列为首要 v0.4 检查;Stage 转移 finding 阻塞推进。

## 验证结果(grep)

- `\.enloom/project_state` 残留:无 ✓
- task_board 定位:5 处 ✓
- Entry/Exit gate:7 Stage 全覆盖(0-6)✓
- landing-contract 引用:6 处 ✓
