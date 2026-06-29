# Project State

## Goal

用 AgentOS 自举开发 **v0.3**:把 SKILL.md 从「6 操作菜单」重写为「生命周期阶段驱动」,并把 art_lab 验证过的五块硬经验(Registry / Evidence Contract / Ownership+Promise / Compaction / Audit)内化为通用文件协议。

## Current Phase

**v0.3 已闭合**(2026-06-24)。Phase B 实现全部完成,6 task accepted,Verify PASS。主窗口退场。

## Accepted Results

- 2026-06-24 triage 判定 `agentos`(用户显式要求 + 多阶段 + 多文件 + 长期资产)。
- 2026-06-24 Phase A:spec 写定,逐节确认,5 决策 + 内容组织 + 重组深度全落定。
- 2026-06-24 Phase B 实现:T007–T012 全部 accepted。17 个文件变动(spec 6a 清单)逐条交付。
- 2026-06-24 Verify:validation.md 结构校验 PASS(SKILL.md frontmatter valid)+ 17/17 spec 6a content-marker audit PASS + evals.json 9 case 合法。verdict=PASS,review=accepted。
- 2026-06-25 eval-guide/validation 去工具绑定(适配 opencode/pi 环境):把 Path B 的 `claude -p` 写死改为环境无关(opencode `run`/pi `--mode json`/Claude Code 三实例任选),quick_validate.py 从"official tool"降级为"one implementation"。commit `0c27c19`。
- 2026-06-25 **Path B 独立盲测 3/9 case PASS**:干净 opencode 会话(经 eval-guide Path B,非 self-graded),测 triage 维度——case 1(`agentos`)/case 2(`direct`)/case 3(`direct`)全判对。Case 3 验证了 references 交叉引用链是活的(SKILL→trigger-contract→decision-tree 三层印证)。
- 2026-06-25 **Path B 独立盲测 6/6 case PASS (case 4-9)**:干净 opencode `run` 会话(fresh context per case,非 self-graded),测 serial 默认(case 4)+ review/verify 维度(case 5-9,evidence/promise/compaction 三条新硬约束)全判对。详见 `runs/path-b-eval/eval-results-cases-4-9.md`。**9/9 case Path B 全 PASS**。
- 2026-06-25 **description-optimization eval set 就绪**:新增 `evals/trigger-evals.json`(20-query trigger set,7 AGENTOS / 6 DIRECT / 7 near-miss,60/40 train/test split)+ eval-guide 补 "Trigger Eval" 段(description-only 协议 + 调优循环)+ `runs/trigger-eval/results-template.md`。set 与跑法就绪,**待实跑迭代**(train→调 description→test 一次性验证)。trigger eval 测的是 description 字段触发准确性,与 9-case Path B(测加载后决策)是不同问题。

## Registry

### Active Tasks

(空 — v0.3 实现闭合)

### Promised Outputs

(空 — 本阶段无跨 worker 前向声明)

### Pending Dependencies



### Broken References

(空)

### Known Exceptions

- **单 agent 环境,worker 隔离靠字段纪律非执行隔离**(沿用 v0.2 D5):已按 Evidence Contract 要求诚实声明此盲区(见 verify-report Not Checked)。
- **不全局安装**(沿用 v0.2 D2):产物留 `agentos-workflow-skill/`,项目本地。

### Accepted With Risk

- **v0.3 实现是 self-graded 上界**:content-marker audit 由实现 agent 自跑,确认 spec 强制内容 *存在*,不保证 *写得好/细节正确*。marker 具体(如硬约束查 "if and only if"),但人工 review 会更可信。风险 medium。
- ~~triage 行为已部分独立验过~~ **已解除**:2026-06-25 Path B 全 9/9 case 独立盲跑 PASS(非 self-graded)。triage 维度(1-3)+ serial 默认(4)+ review/verify 维度(5-9,evidence/promise/compaction 三条新硬约束)全判对。

### Rejected Reports

(空)

## Archived Phases

- **v0.3 实现**(2026-06-24 归档):生命周期主架重写 + 五块经验内化。6 task accepted,17 文件变动,Verify PASS。详见 `archive/task-history.md`。
- **v0.2 自举**(2026-06-17 归档):6 task accepted,补齐 eval 套件 + 5 references + 3 prompt-assets + skill-creator 闭环。详见 `archive/task-history.md`。
- **v0.1**(2026-06-15 归档):纯文档 skill 初版,静态校验 + 手工 trial 三路径通过。

## Human Decisions Needed

(空 — 全程自举执行,无待决策项)

## Next Review Point

Path B 9/9 case 全 PASS ✅。**description-optimization**:eval set 已就绪(`evals/trigger-evals.json`,20-query / 60/40 split + eval-guide Trigger Eval 段 + results-template),**待实跑迭代**——train(12)→调 description→test(8)一次性验证。本轮不调 description 字段,留实跑数据驱动。
