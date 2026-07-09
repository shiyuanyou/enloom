# P2-recon 升格 · worker report（Evidence Contract 四要素）

```yaml
phase: P2
role: coder
verdict: done
files_changed: 6 源 + 6 副本 = 12 处
```

## Checks Run

1. `grep -rn "recon considered" enloom-skill/references/templates/phase-plan.md` → 命中（:77）
2. `grep -n "recommended" enloom-skill/references/scheduler-rules.md` → 命中 4 行（标题 + 升格句 + 三信号规则段 + salience 缝隙句），三信号规则命中 ✓
3. `grep -n "If the task packet marks this as a recon" enloom-skill/prompt-assets/researcher.md` → 命中（:39，第 6 条）
4. `grep -n '"id": 10' enloom-skill/evals/evals.json` → 命中（:100）
5. `grep -n "recon Human Decision\|recon decision" enloom-skill/references/eval-guide.md` → 命中（:18 表格第 10 行 + :19 "most important" 补句）
6. `grep -rn "recon" enloom-skill/references/trigger-contract.md enloom-skill/references/workflow-steps.md` → 命中（trigger-contract.md :34/:36，② 落点）。注：workflow-steps.md 仅 1 处 substring 假阳（"precondition"含"recon"），非 recon 内容；② 实际落 trigger-contract.md。
7. reframe 对齐 `grep -rn "自动派\|first task 自动" enloom-skill/` → **见 Known Blind Spots 第 1 条**（lexical 2 hits，semantic 0 residue）
8. `diff -r enloom-skill/ ~/.agents/skills/enloom/` → 无差异（全树一致）
9. 附加：`python3 -c json.load` evals.json → valid，10 cases，id 10 在位

## Evidence（逐 check_item 四要素）

### check_item 1 — recon considered 行（phase-plan.md）
- **Evidence**：`phase-plan.md:77  - recon considered (v0.6 P2): yes | no`。Gate Check 段第 6 行，紧跟既有 5 行出口自检后。Human Decisions 段另有 `recon decision (v0.6 P2 reframe)` 决策块（:66-69，yes/no/recommended 三态）。
- **Not Checked**：未验证该行在真实 phase-plan-3 填写场景的语义清晰度（模板行，待 Plan 阶段实例化）。
- **Known Blind Spots**：措辞含 "v0.6 P2" 版本标签，未来版本演进需回顾清理（与既有 Gate Check 行风格一致，可控）。

### check_item 2 — recommended 三信号规则（scheduler-rules.md）
- **Evidence**：`scheduler-rules.md:61` 三信号规则段，编号列出 ① Registry 无该域风险段（新 domain）② 新文件类型 ③ 规模/边界不明。grep "recommended" 命中 4 行（:53/:55/:61/:67）。
- **Not Checked**：信号 1（Registry 读取）依赖 Orient 阶段 project_state.md Registry 段格式——本任务未改 project-state 模板，假设其 Registry 段结构与 review §7 描述一致（Pending Dependencies / Broken References / Accepted With Risk）。
- **Known Blind Spots**：recommended false positive 在新项目（Registry 空）会多发——review §7 已标为 Known Limitation，文本已写入 scheduler-rules.md :67。未做运行验证（无新项目实例）。

### check_item 3 — recon How-to-work 分支（researcher.md）
- **Evidence**：`researcher.md:39` 第 6 条 `If the task packet marks this as a recon task…`，含产物定义（规模/结构素描）+ Evidence Contract 四要素映射 + 交叉引用 scheduler-rules §recon。
- **Not Checked**：Role/Mode 枚举确实未动（grep 确认 researcher.md 无 Role/Mode 字段改动；recon task 仍是 emergent + researcher）。未验证 recon worker 实际拿到这种 task 时的产出质量（需真实 recon dispatch）。
- **Known Blind Spots**：task-packet 标识 recon 仍靠 Goal/Anti-Goal 文字（非结构化字段）——这是 reframe 的有意取舍（§6.2 消解了 §4 的 W 条件），非缺陷，但 Plan 派 task 时需在 Goal 明写"recon"researcher 才会走第 6 条。

### check_item 4 — evals.json case 10
- **Evidence**：`evals.json:100  "id": 10`，完整结构 {id, prompt, expected_output, expectations[]}。JSON 合法（python3 校验，10 cases）。prompt 构造不熟领域+规模未明，expectations 5 条测 reframe 行为（显式决策 / recommended 标记 / 非自动派）。
- **Not Checked**：未实际跑 case 10（无 headless sub-agent dispatch 环境；eval-guide.md Path A/B 均为人工或需外部工具）。
- **Known Blind Spots**：case 10 是设计态 eval，passage 未验证；其 expected_output 的"信号触发故标 recommended"判断依赖 reviewer 对 prompt 的解读，存在主观空间。

### check_item 5 — eval-guide.md recon 行
- **Evidence**：`eval-guide.md:18` 表格第 10 行（含"recon Human Decision present"）+ :3 "ten cases" + :19 "most important" 补句。grep "recon Human Decision\|recon decision" 命中。
- **Not Checked**：另 4 处 "nine-case→ten-case" 连带更新（:62/:64/:112/:125）的必要性——判断为内部一致性（suite 从 9 变 10 后旧称谓自相矛盾），属 ⑤ 范围。
- **Known Blind Spots**：见下方"Known Blind Spots 第 3 条"（判定项披露）。

### check_item 6 — triage recon 偏好落点（trigger-contract.md）
- **Evidence**：`trigger-contract.md:34` `## recon 偏好(可选,机制 b)` 段（:34-:38）。grep "recon" 命中。落 trigger-contract.md（task.md §② 倾向）。
- **Not Checked**：workflow-steps.md 未加（OR-分支二选一，已满足）。未验证 trigger-contract 与 workflow-steps 间是否有"两处定义 triage"漂移——读 trigger-contract :36 "与 triage 子动作的关系"段确认 triage 定义单点在 trigger-contract，无漂移。
- **Known Blind Spots**：偏好透传的具体数据路径（triage 输出 → Plan 输入）未在模板层定义——reframe 是零结构改动，故靠既有 triage→Plan 信息流承载，不新增字段。

### check_item 7 — reframe 对齐（自动派 / first task 自动 应为 0）
- **Evidence**：grep 命中 2 行（scheduler-rules.md:59、phase-plan.md:66），**两处均为否定句**"Plan 不自动派 / 把决策摆出来，不自动派"——即 reframe 原则本身的表述，非 v1/v2 残留。v0.5 原"把第一个 task 设为侦察 task"（隐含自觉派）已在我的 ③ 升格中删除：精确残留 grep `首 task 应为 recon|把.*第一个 task 设为` 返回 0（exit=1 clean）。
- **Not Checked**：无（已对正向断言 + 旧 v0.5 句式双重核查）。
- **Known Blind Spots**：**task.md 的 CHECK7 grep 是 substring 匹配**，"自动派"会匹配到"不自动派"。语义 0 残留，但 lexical 2 hits——若 Verify 阶段机械执行该 grep 会看到 2 行输出，需读上下文（两行都含"不"否定）才判定 clean。**此为本任务最重要的 blind spot，显式 flag**。

### check_item 8 — 源/副本 diff
- **Evidence**：`diff -r enloom-skill/ ~/.agents/skills/enloom/` 全树无差异输出（6 改动文件 cp 同步后完全一致）。
- **Not Checked**：副本中其他未改文件 assumed 未被触碰（cp 只覆盖 6 个目标文件）。
- **Known Blind Spots**：无（diff -r 是全树比对，覆盖所有文件）。

## Claim Consistency（自洽性核查）

- **reframe 零结构**：未加 stage/顶层字段/Role 枚举值/Pre-flight。researcher.md Role/Mode 枚举未动（grep 确认）。evals.json 未加新顶层键。phase-plan.md 未加新模板段（只在既有 Human Decisions/Gate Check 段内加行）。✓
- **P2-A ↔ P2-C 双向交叉引用**：phase-plan.md Human Decision 块引用 scheduler-rules §recon；scheduler-rules 升格段引用 phase-plan Human Decision（P2-A）。Promise Registry 本 packet 内闭合。✓
- **卖点降级**（reframe §6.2 + §7 X）：scheduler-rules.md 诚实边界段显式写"卖点是给预研一个结构化位置 + 降低主窗口 prompt 污染，不是防漏扫"；researcher.md / phase-plan.md 措辞均避开"防漏扫"。✓
- **机制 abc 齐全**：a（phase-plan Human Decision）+ b（triage 偏好，trigger-contract）+ c（recommended 三信号，scheduler-rules）。三处互相交叉引用。✓

## Not Checked（汇总）

- 未实际跑任何 eval（含 case 10）——无 headless dispatch 环境。
- 未在真实复杂 phase 验证 recon Human Decision 是否被认真决策（review §7 观测点 1，留 P3/后续 dogfood）。
- 未验证 recommended 信号对真实 recon 决策的影响（review §7 观测点 2）。
- project_state.md Registry 段格式假设（信号 1 依赖）未实地核对——本任务禁碰 project-state 模板。

## Known Blind Spots（显式 flag）

1. **CHECK7 lexical 假阳（最重要）**：`grep "自动派"` 命中 2 行，但都是"**不**自动派"否定句（reframe 原则表述）。正向 v0.5 残留（"第一个 task 设为侦察"）已删净（精确 grep 0 命中）。Verify 阶段若机械数 grep 行数会误判，须读上下文。
2. **判定项：eval-guide.md 9→10 连带 4 处**：suite 因 case 10 从 9 变 10，:62/:64/:112/:125 的"nine-case/9-case"若不改会与 10 行表格自相矛盾。判断属 ⑤ 一致性维护（非越界），但严格读 task.md "只加/改本任务指定内容"有边界灰区——披露待 reviewer 裁。
3. **判定项：sync 6 非 5 文件**：task.md :41 写"5 文件×2"，但 §② 把 trigger-contract.md 纳入 writable。按 §② 优先级同步 6 文件。
4. **case 10 设计态**：未跑，passage 未知；"信号触发故 recommended"判断有 reviewer 主观空间。
5. **recon 标识靠文字**（reframe 有意取舍，非缺陷）：task-packet 标 recon 靠 Goal/Anti-Goal 文字，非结构化位——Plan 派 task 时须在 Goal 明写"recon"，否则 researcher 不走第 6 条。
