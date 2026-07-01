# Task Packet: T09-VAL

Mode: audited | Role: reviewer

## Goal

零回归核查 + 全局重装 + 结构验证。确认 v0.5 七条改动全落地,五铁律/七段/硬约束/闸门表语义不变,源/装逐字节一致。

## Acceptance Criteria

1. design §7 标准 1-10 全过。
2. 五铁律全在(5);七段全在(7);Evidence 硬约束在;闸门表 7 Stage 在;Compaction 防错规则在。
3. 源/装 diff 仅 evals/(剥离规则)。
4. validation.md bash 实现 PASS。

## Countable outputs (Claim Consistency)
- 10 个 design §7 验证标准(全过 = 10)。
- 5 铁律 / 7 段 / 1 硬约束 / 7 Stage / 1 防错规则。
- 27 源文件 / 27 装文件(evals 剥离)。

## Required Verification
- grep 各 invariant 关键词。
- diff -rq 源 vs 装。
- bash validation。

## Done Signal
done + 证据。
