# Project State

## Goal

在不改变 Enloom 五铁律、六阶段、Evidence Contract 四要素或 Clear-Mind 的独立性前提下，验证并实施 prompt workflow audit 中最小、可审计的 Enloom 改动：audited researcher 的材料性 finding provenance 与边界自声明。

## Current Phase

closed — P1 audit、P2 source patch、P3 readonly dogfood 均已 review 并归档。P1 保持为 audited researcher 的当前默认，且仍需要 packet 明确要求 material-finding locators；不扩大到其他 mode/role。

Compatibility preflight: **yes** — 当前运行时暴露独立 sub-agent 调度能力；`list_agents` 显示仅 control 运行，且会话配置允许额外 agent。并发与模型多样性未作为保证。

## Accepted Results

- Clear-Mind 裁决为 `CONDITIONAL`：仅当 P1 保持 mode-aware、P3 明确是 self-attestation，并经真实只读 dogfood 验证时，才值得实施。
- T001-PATCH-AUDIT `PASS / accepted`：7 个材料性 findings、3 个精确 edit locations；P1 是 researcher + audited + packet-declared locator 的联合条件，P3 位于 `Files Changed` 后且不改变 Evidence Contract 语义。
- T002-P1-P3-PATCH `ISSUES / accepted-with-risk`：三处 source patch 落地；P1 是 role/mode/packet locator 联合条件，P3 是单独的 Boundary Check。V2 whole-worktree check 的 inherited noise 已记录，未发现额外 Enloom source 改动。
- T003-DOGFOOD-READONLY `PASS / accepted`：5 条 typed material findings 均可按 locator 回源；Boundary Check 语义清楚；三处 source checksum 与 dispatch 前基线一致，source/install parity 与 whitespace check 均通过。

## Registry

### Active Tasks

None.

### Promised Outputs

None.

### Pending Dependencies

- Clear-Mind → Enloom optional handoff (audit P2) belongs to sibling `../clear-mind/` project and remains a separate, non-blocking decision.

### Broken References

None known.

### Known Exceptions

- dev-wiki 是历史编译知识；允许作为机制证据，但 live Enloom source 是当前契约 SSOT。

### Accepted With Risk

- Boundary Check 是 worker self-attestation，不能被理解为运行时隔离或独立验证。
- T002 V2 whole-worktree path count is noisy because inherited `.enloom/task_board.md` appears in Git diff and untracked run artifacts do not; source-only review found the expected three source files. Future packets should use explicit source-path checks, not whole-worktree output for this assertion.

### Rejected Reports

None.

## Archived Phases

- P1 audit done on 2026-07-17, accepted: three narrow source locations selected; see `archive/P1-entry.md`.
- P2 patch done on 2026-07-17, accepted-with-risk: source patch complete; see `archive/P2-entry.md`.
- P3 dogfood done on 2026-07-17, accepted: one readonly audited-researcher sample validated P1/P3 form and source immutability; see `archive/P3-entry.md`.

## Human Decisions Needed

None for this closed Enloom patch. P2 remains a future decision in the Clear-Mind project.

## Next Review Point

Reopen only if an audited researcher run shows locator overhead/citation theatre, or when the Clear-Mind project elects to implement its optional handoff record.

Compaction not triggered: project_state remains below 200 lines; no unresolved risk was removed.
