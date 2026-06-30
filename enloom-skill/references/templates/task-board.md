# Task Board

> 项目级入口表。一行一 Project。Orient 第一步读本表定位目标项目;任务详情进各项目的 `project_state.md`,不在此索引。
> v0.4 命名空间层的唯一全局文件——位于 `.enloom/task_board.md`(项目目录之外)。

| project | created | updated | phase | desc |
|---|---|---|---|---|
| example-project | 2026-06-29 | 2026-06-30 | v0.1 | 一句话简介 |

## 字段语义

- **project**:稳定标识,去重键。slug 形态(如 `enloom-dev`)。同名 Project 第二次进入据此复用已有目录。
- **created**:创建日期,**永不变**。决定项目目录名 `YYYY-MM-DD-<project>`。
- **updated**:最近一次进入该 Project 的日期。每次 Orient/Integrate 后更新。
- **phase**:当前阶段标签(自由文本,如 `v0.3.4` / `ingest` / `closed`)。`closed` 表示项目已闭合,行保留可查。
- **desc**:一句话简介。

## 用法

- **Orient(Stage 1)**:读本表 → 定位目标 project 行(用户指明 / 唯一活跃 / 最近 updated)→ `cd .enloom/<created>-<project>/` → 读该项目 `project_state.md`。
- **新项目**:无匹配行 → 建 `<今天>-<projectName>/` 目录 + 初始化 project_state.md + 在本表加一行(`created`=今天)。
- **复用**:同名 project 已有行 → 复用其目录,只更新 `updated`,不新建目录、不改 `created`。
- **闭合**:phase 列标 `closed`,行不删(历史可查)。

## 不要

- 不在本表索引任务/阶段(那是各项目 project_state 的 Active Tasks)。
- 不删行(用 `closed` 标记)。
