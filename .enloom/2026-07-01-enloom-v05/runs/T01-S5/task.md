# Task Packet: T01-S5

Task Packet Version: 0.2
Mode: audited
Role: coder

## Goal

把 Compaction 从「可选检查」升级为 Stage 5 Integrate 出口闸门条件之一(超标→必执行)。三处改动,零语义破坏(S5 是定向加强)。

## Anti Goal

不改 Compaction Protocol 四步语义。不动 Registry 七段。不改四步防错规则(风险段计数不得因压缩下降)。

## Inputs

- design §3 S5 评审裁决(必执行 + 阈值旁"启发式、非教条")
- design §7 验证标准 1
- 当前源:`enloom-skill/references/registry-and-compaction.md` §4 / `workflow-steps.md` Stage 5 / `landing-contract.md` §1

## Existing State

- `registry-and-compaction.md:114-118` Trigger Conditions 是 "any one"(可选措辞);Lifecycle Hooks `:137` "If met, run compaction"(可选)。
- `workflow-steps.md:180` Stage 5 Exit gate 只要求 "compaction trigger check run"(只检查不执行)。
- `landing-contract.md:20` Gate Table Stage 5 Exit "compaction trigger check run"。

## Allowed Tools

Edit / Read / Bash(grep 验证)

## Writable Files

- `enloom-skill/references/registry-and-compaction.md`
- `enloom-skill/references/workflow-steps.md`
- `enloom-skill/references/landing-contract.md`

## Forbidden Files

- `.enloom/**`(serial-integration,control agent only)
- 任何其他 reference / template / SKILL.md / glossary

## Output Files

(就地改源文件;无新建)

## Acceptance Criteria

1. registry §4 Trigger Conditions:措辞从「建议」改「必执行」;阈值旁有"启发式、非教条"注释。
2. registry §4 Lifecycle Hooks Integrate 段:"If met, run" → 超标必执行闸门。
3. workflow-steps Stage 5 Exit gate:加 compaction check(超标→必执行,未执行不准出口)。
4. landing-contract §1 Gate Table Stage 5 Exit:"compaction trigger check run" → "compaction run or threshold not met"。
5. 零语义破坏:四步流程 + 防错规则不变。

## Required Verification

- grep 验证旧措辞消失、新措辞出现。
- 四步流程表(Scan/Migrate/Closeout/Verify)未被改动。

## Evidence Required

三处改动的 before/after 引用 + grep 证据。

## Review Budget

report-first。

## Done Signal

done + 路径。
