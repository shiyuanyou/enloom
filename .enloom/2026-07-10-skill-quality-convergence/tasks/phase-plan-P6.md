# Phase Plan: P6 — Dogfood / 对比 / 同步 / 关闭

## Phase Goal

验证冻结后的全契约自洽（dogfood = 本项目 P1–P5 本身用新 Evidence Contract / lifecycle gates / ownership / namespace 跑通）、重评 P0 三份 frozen report、最终 source/installed parity、Registry 高风险清零、archive closure。

## Tasks

### T-P6-01 — Full contract self-consistency check
验证 C01–C14 全部在 live skill 中落地且自洽。

### T-P6-02 — P0 frozen report regrade
用新 Verdict Decision Function 重评 T-P0-01/02/03 三份 report，不回写原文。

### T-P6-03 — Final source/installed parity
`diff -qr enloom-skill/ ~/.agents/skills/enloom/` = empty。

### T-P6-04 — Registry high-risk clearance + archive closure
Registry 四风险区段清零或标注 carried risk；archive entry 落盘。

## Exit Gate (Phase)

- C01–C14 全部在 live skill 中验证通过
- P0 三份 report 重评一致（同 verdict/conclusion）
- `diff -qr` empty
- 无 open high risk
- archive closure pass
