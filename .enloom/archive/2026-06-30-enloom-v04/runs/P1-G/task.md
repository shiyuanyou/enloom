# Task Packet: P1-G

Task Packet Version: 0.2
Mode: audited
Role: integrator

## Goal

(1) 改 `references/registry-and-compaction.md` §1 开头:注明 Registry 现住项目目录的 project_state、Compaction 范围也是项目内。(2) 改 `references/archive-policy.md`:闭合条件里 project_state/runs/archive 路径加项目前缀意识;闭合条件加「Review Result 段已填」闸门(铁律 5 机械化)。

## Anti Goal

- 不改 Registry 七段语义 / Compaction 四步语义。
- 不改 workflow-steps / SKILL / glossary / templates。

## Inputs

- registry-and-compaction.md §1 / archive-policy.md 现状。
- landing-contract.md(铁律 5 机械化:archive 前 Review Result 填)。

## Writable Files

- `references/registry-and-compaction.md`
- `references/archive-policy.md`

## Forbidden Files

- 其余 enloom-skill/ 文件 / project_state / design / 旧 .enloom

## Acceptance Criteria

- registry-and-compaction §1 注明 Registry 现住项目目录、compaction 范围项目内。
- archive-policy 闭合条件加「Review Result 段已填」项;路径意识项目前缀。

## Done Signal

done + 改动点。
