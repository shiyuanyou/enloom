# Long Task Control Competitors - Review

## Verdict

CONDITIONAL

Enloom is worth continuing if it stays sharply positioned as a thin, file-native, evidence-first control plane. It is not worth trying to beat every runtime/harness on execution features. The defensible niche is: "the smallest protocol that lets any coding agent recover, delegate, verify, and archive long work without pretending chat memory is state."

## Primary Contradiction

The market is splitting in two directions:

- Heavy runtime products make state and recovery mechanical, but cost setup complexity and lock-in.
- Skill/process packs are easy to install, but much of their enforcement is still prompt-dependent.

Enloom can win only if it owns the middle: more rigorous than a skill checklist, lighter and more portable than a runtime daemon.

## What Competitors Teach

### From Superpowers / fable-long-task / longtaskforagent

Clear stage workflows and human gates make agents less chaotic. But if every phase becomes a full methodology, the system becomes too heavy for mixed domains.

### From PCP / Task Master / CCPM / Spec Kit / BMAD

Task graph, spec, issue, and story artifacts are extremely valuable. Enloom should integrate with them rather than duplicate all of them.

### From Smithers / Millrace / Taskplane / Multi-Agent-Orchestrator / Citadel

True runtime ownership matters when tasks must survive crashes, run in parallel, or be supervised for hours. Enloom should define a clean handoff contract to such runtimes.

### From DCP / Project Butler / agent-memory / ContextOS / episodic-memory

Continuity is a projection problem, not a dumping problem. The next agent needs a compact continuation pack with pointers and evidence, not a full transcript.

## Strategic Implications For Enloom

1. Keep the non-goal: no built-in scheduler/runtime/model resolver.
2. Strengthen the file protocol until it can be consumed by other tools.
3. Treat `project_state.md` and Registry as the key product, not just internal logs.
4. Add explicit import/export handoff shapes for GitHub Issues, Task Master, Spec Kit tasks, and runtime orchestrators.
5. Add context-budget discipline: never compress unclosed risk; always compact resolved process details.
6. Add stronger "what evidence is required" schemas; competitors often say evidence but do not normalize it.
7. Avoid feature envy from giant harnesses. Their breadth is not Enloom's lane.

## Best Next Product Direction

Build Enloom as a protocol and reference skill, not a monolith.

Possible external-facing promise:

> Enloom is the long-task control protocol for coding agents: phase state, risk registry, task packets, file ownership, evidence gates, and archive discipline in plain Markdown, with adapters to the runtime you already use.

## Handoff Suggestion

If proceeding to implementation/design, use Enloom itself for a short phase:

- Phase goal: define v0.6 competitor-informed positioning and adapter boundaries.
- Required outputs: positioning doc, competitor matrix, integration boundary table, revised non-goals, one adapter contract sketch.
- Do not implement a runtime in this phase.
