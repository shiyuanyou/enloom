# Phase Plan: Phase 4 — P3 清理(archive-entry Raw Material Handling 锁注释 + art-lab/manual-trial 措辞)

## Phase Goal

收尾 v0.6 遗留的两处清理:① archive-entry 模板的 Raw Material Handling 段加"锁注释"(说明该段为何存在 + 填写纪律,防 worker 误填 raw 进主窗口);② art-lab / manual-trial 的 "the agent" 措辞——按 P1 建立的角色命名基准(control agent / worker)处理,但**art-lab 的"the agent"指向原始外部任务(art_lab wiki build)而非 enloom 角色,需判断保留还是重写**。

## Anti Goal

- 不动 art-lab 的领域特定内容(dead-link scan / quote-encoding scan 等 wiki-domain only 命令——它们是 worked example,非 enloom 机制)。
- 不重写 art-lab 的叙事结构(只处理"the agent"措辞 + 必要注释)。
- 不碰 design/ 历史、不动核心 references(P0-P2 已闭合的文件)。
- 不引入新机制——P3 是纯清理,零结构改动。

## Constraints

- **源仓库优先**:Writable 指向 `enloom-skill/`(源),改完同步副本,Done Signal 含 cp + diff(P1/P2 纪律)。
- **art-lab 判断原则**:line 9 的"the agent could not recover"描述的是**原始 art_lab 任务**的执行者(一个历史外部项目),不是 enloom 的 control agent/worker。强行改成 enloom 角色名会**篡改历史描述**。处理选项:(a) 保留原样 + 加注释说明"此处 the agent 指 art_lab 原任务的执行者,非 enloom 角色"；(b) 改写成"the operator/worker(art_lab 原任务)"保留语义中性。**worker 判断哪个更诚实,倾向 (a) 保留 + 注释**(改写有篡改历史风险)。

## Strategy

serial。两文件 + 一个判断点,1 个 task packet。

## Ownership Table

| 区 | 文件 | 写者 |
|---|---|---|
| 串行集成 | `.enloom/2026-07-06-enloom-v06/project_state.md` + task_board.md | 控制 agent 独占 |
| 并行写 | `enloom-skill/` 下 P3 文件(archive-entry.md / art-lab-worked-example.md / manual-trial.md) | P3-worker 独占 |
| 只读 | `design/`、前序项目目录、`.clear-mind/`、其他 skill 文件 | 谁都不改 |

## Reference Tolerance Decision Table (v0.5)

| Reference type | Tolerates dangling? | Handling | Forces serial? |
|---|---|---|---|
| markdown internal links | yes | grep at verify | no |

**Decision**: yes(纯措辞清理,无新引用)。

## Promise Registry Draft

无(无 forward declaration)。

## Tasks

| ID | Task | Mode |
|----|------|------|
| P3 | ① archive-entry Raw Material Handling 锁注释 ② art-lab "the agent" 处理(判断保留+注释 or 重写) ③ manual-trial "The agent" → control agent(3 处,enloom 角色语境,直接改) | audited |

## Review Plan

- `grep -n "Raw Material Handling" enloom-skill/references/templates/archive-entry.md` → 锁注释命中
- `grep -n "the agent\|The agent" enloom-skill/references/examples/art-lab-worked-example.md` → 处理后或保留+注释,或重写(worker 判断)
- `grep -n "the agent\|The agent" enloom-skill/references/examples/manual-trial.md` → 应为 0(改 control agent)或仅留必要历史描述
- `grep -rn "single-agent" enloom-skill/` → 0(P0 已清,P3 不应引入)
- Claim Consistency:声称 N 文件改动,git diff --stat 复核
- 源/副本:`diff -r enloom-skill/ ~/.agents/skills/enloom/` 改动文件无差异

## Human Decisions Needed

- **recon considered: yes-skip** —— P3 是熟域(措辞清理,材料在 P1/P2 多次提及,art-lab/manual-trial 已实读)。跳过 recon sub-agent。

## Gate Check

- Phase goal is clear: yes
- Acceptance criteria are clear: yes
- Parallel ownership is defined if needed: not-needed(serial)
- Promise Registry drafted if forward declarations exist: not-needed
- **Landing gate confirmed**: written to `tasks/phase-plan-4.md`: yes
