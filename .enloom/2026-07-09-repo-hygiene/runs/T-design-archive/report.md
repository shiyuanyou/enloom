# Report: T-design-archive

Evidence Contract — 四要素：What changed / Where / How verified / Open issues。

## 1. What changed（做了什么）

将 `design/` 目录 7 个已闭合设计文档（3,552 行）归档到 `design/_archive/`，并在 `design/` 顶层新建 `index.md` 解释归档状态与活文档去向。

- 新建 `design/_archive/` 目录
- 移动 7 个文件（内容零修改）
- 新建 `design/index.md`（唯一内容写入）

## 2. Where（落到哪里）

仓库根：`/Users/bigo/CloudDocs/NewIdeas/enloom/`

| 路径 | 操作 |
|---|---|
| `design/_archive/` | 新建目录 |
| `design/index.md` | 新建（2,183 bytes，唯一新建文件） |
| `design/_archive/<7 文件>` | 从顶层 `mv` 进来，内容未改 |
| `enloom-skill/**` / `README.md` / `PROGRESS.md` / `.enloom/**` | **未触碰** |

## 3. How verified（怎么验证的）

### 3a. `ls design/_archive/` → 7 个归档文件

```
2026-07-01-enloom-v0.5-optimization-design.md
art-lab-prompt-control-lessons.md
design-summary.md
skill-reference-notes.md
skill-workflow-draft.md
v0.3-lifecycle-spec.md
v0.4-project-namespace-spec.md
```

### 3b. `ls design/*.md` → 顶层仅 index.md

```
index.md
```

（顶层 `.md` 数：before 7 → after 1。无 open-question 文档保留。）

### 3c. 归档前后内容零修改（SHA256 对比）

移动前（在 `design/` 顶层）与移动后（在 `design/_archive/`）的 SHA256 完全一致：

| 文件 | SHA256（前后一致） |
|---|---|
| `design-summary.md` | `1c92bf71faa185cac2eecac0ff5aaef07dd3be16cb744c79fb2577bb013b05fd` |
| `art-lab-prompt-control-lessons.md` | `7347107ac47a65f3dd254fb84330cb9beccdd048a4b3727db56a70e43d2869e1` |
| `skill-reference-notes.md` | `3aebd601fc35e2c62b20770bfcbe91fd0d23052400359af73aeb0c86ab82b5b8` |
| `skill-workflow-draft.md` | `73639a7d7cdd69c3aa65769c801b05b9353324b28d5d63a71dc0e4a47f4d03f6` |
| `v0.3-lifecycle-spec.md` | `1ef567c6e038b381ab044b76ad734fad6eaf08b38fe39b0499ac3affe8eef50c` |
| `2026-07-01-enloom-v0.5-optimization-design.md` | `dc62ea3d94a18ecf3773c0de33f2f24f1ddbf7c0eb1db8f81f473fc59833373d` |
| `v0.4-project-namespace-spec.md` | `97d3b69d48c56068f95339e2c0499ee20475862f7c6b382730eb4e83c1daf20a` |

（注：本仓库非 git repo，无 `git diff`；改用 SHA256 逐文件对比 + `mv` 保留原始 mtime/size 作为佐证——`ls -la` 显示 7 文件 mtime 均为 `Jul 3 11:20`、size 与原值一致，未被重写。）

### 3d. `grep -rl 'design/' enloom-skill/` → 0（live skill 不引用）

```
$ grep -rl 'design/' enloom-skill/
exit:1   # (1 = no matches)
```

归档前后均为 0，符合任务前提。

## 4. Open issues / 保留项

**无。**

逐个检查 7 份文档判定 open question：

| 文件 | 判定 | 依据 |
|---|---|---|
| `design-summary.md` | 闭合 | V1→V2 演化，文末为定位结论；洞察已进 SKILL.md/README.md。 |
| `art-lab-prompt-control-lessons.md` | 闭合 | 教训已提取进 `references/prompt-control.md`（5 节）；文末「诚实盲区」是记录非待决项。 |
| `skill-reference-notes.md` | 闭合 | 外部 skill 调研；文末「第一轮只验证三件事」是已完成范围。 |
| `skill-workflow-draft.md` | 闭合 | v0.1 草案；已被 v0.3+ 全面超越。 |
| `v0.3-lifecycle-spec.md` | 闭合 | 状态「设计已逐节确认」；已实现，被 v0.4/v0.5 超越。`[ ]` 验收框是 spec 层标准非未决风险。 |
| `2026-07-01-enloom-v0.5-optimization-design.md` | 闭合 | 状态「评审完成」，逐条 ✅🟡⏸️❌ 裁决；已实现。 |
| `v0.4-project-namespace-spec.md` | 闭合 | v0.4 规格；已实现，v0.5 文档引用其为既定事实。 |

全仓 `grep -niE 'open question|未决|待定|TBD|TODO|pending decision|unresolved'` 仅命中 `v0.3-lifecycle-spec.md:120`——该行描述 `Broken References` 检查范围（「悬空 TODO 指向」），不是本 spec 的未决问题。

→ **全部 7 份归档，顶层无保留项。** 遵循「绝不压缩未闭合风险」：本次未发现任何未闭合风险需保留。

## 验收标准对照

| # | 标准 | 结果 |
|---|---|---|
| 1 | `design/_archive/` 存在 | ✅ |
| 2 | 已闭合设计文档移入 `_archive/` | ✅ 7/7 |
| 3 | 顶层有 index 解释归档 + 指向 references | ✅ `design/index.md` |
| 4 | 被归档文件内容零修改 | ✅ SHA256 一致 |
| 5 | 含未决问题的文档保留顶层并标注 | ✅ N/A——无未决文档 |

## 可计数产出

- `design/` 顶层 .md：before 7 → after 1（index.md）
- `design/_archive/` 文件数：before 0 → after 7
- 归档总行数：3,552
- live skill 对 `design/` 引用：0（不变）
- 新建文件：1（`design/index.md`）
- 删除文件：0

## Done Signal

**done。** 7 文件归档至 `design/_archive/`，顶层仅 `index.md`（路径：`/Users/bigo/CloudDocs/NewIdeas/enloom/design/index.md`），无未决项保留。

## Review Result

**Verdict: PASS** | **Conclusion: accepted**

Control-agent independent recount confirms:
- design/_archive/ = 7 files ✓
- design/ top-level = index.md only ✓
- Live skill design/ references = 0 ✓
- design/index.md exists ✓
- Content zero-modification (SHA256 verified by worker) ✓
- Forbidden files untouched ✓

Clean execution. All 7 docs correctly judged closed (version specs all implemented, lessons extracted into references).
