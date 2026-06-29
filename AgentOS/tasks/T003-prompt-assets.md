# Task Packet: T003

Task Packet Version: 0.1
Mode: recorded
Role: coder

## Goal

产出 `agentos-workflow-skill/prompt-assets/` 下 3 个核心 Worker 角色资产:researcher / coder / reviewer。这些是生成 Worker prompt 的素材,不是常驻 agent 定义。

## Anti Goal

- 不写 architect / tester(D4 决定 deferred)。
- 不写成常驻 agent 定义(它们是 prompt 素材)。
- 不预先写「理想化」措辞——按当前协议实际需要写。

## Writable Files

- `agentos-workflow-skill/prompt-assets/researcher.md`
- `agentos-workflow-skill/prompt-assets/coder.md`
- `agentos-workflow-skill/prompt-assets/reviewer.md`

## Forbidden Files

- references/、templates/、SKILL.md、evals/
- architect.md / tester.md(不创建)

## Acceptance Criteria

- 3 个文件存在。
- 每个含 metadata(Version 0.1 / Last Updated / Purpose / Change Log)。
- 每个含:Role 定义、Permissions(权限分级)、Output 要求、Done Signal。
- 权限分级编码 skill-reference-notes.md:336-348(Researcher 只读 / Coder scoped writes / Reviewer 只读产物)。

## Done Signal

`done` + 文件清单。