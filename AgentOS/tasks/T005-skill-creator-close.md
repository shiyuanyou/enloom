# Task Packet: T005

Task Packet Version: 0.1
Mode: audited
Role: reviewer

## Goal

加载 `skill-creator` skill,走它的 create-skill 收尾流程,对 AgentOS Workflow v0.2 做验证闭环:
1. 跑 `quick_validate.py` 静态基线(回归 v0.1 已过的校验)。
2. 用 evals.json 的 6 个 prompt 做手工版 eval,记录 triage/review 决策是否符合 expected_output。
3. 产出 protocol-retrospective(协议可调点复盘)。

## Anti Goal

- 不跑 run_eval.py / run_loop.py(依赖外部 claude -p,环境不支持——已记 D5)。
- 不假装自动化 eval 跑过。
- 不做全局安装(D2)。
- 不改 evals.json 的 expected_output 去迎合结果(那是作弊)。

## Allowed Tools

- skill-creator skill(加载)
- `uv run --with PyYAML python .../quick_validate.py`(静态校验)
- 只读 Bash / Read / Edit(runs/T005 记录)

## Writable Files

- `AgentOS/runs/T005/report.md`
- `AgentOS/runs/T005/eval-results.md`(手工 eval 逐 case 结果)

## Forbidden Files

- skill 包内任何文件(T002-T004 已定稿,本 task 只验证不改)
- README/PROGRESS(T006 范围)

## Acceptance Criteria

- quick_validate.py 对 agentos-workflow-skill 返回 pass(exit 0)。
- eval-results.md 覆盖 6 case,每 case 有 pass/fail 逐条 expectation + 决策记录。
- report.md 含 protocol-retrospective(本次自举暴露的协议可调点)。

## Done Signal

`done` + 验证输出 + 复盘段。