---
name: create-task-batch
description: |
  Use when the user wants a long-running autonomous execution plan, a durable batch spec, a PRD-to-task breakdown, or a structured task list that Codex can resume over many turns. Triggers include requests like "create a batch", "make a task batch", "prepare a long execution plan", "turn this into autonomous work", or "write a batch spec".
---

# Create Task Batch

Create a durable batch file for Codex-native execution. This is the planning side of long autonomous work.

## Purpose

Codex does not have Claude-style task objects. The durable substitute is a repo-local batch spec plus the existing checkpoint files:

- `PLAN.md`
- `STRUCTURE.md`
- `MEMORY.md`

When this skill is used, create or update a batch spec in:

- `docs/batches/<slug>.md`

Use `kebab-case` for `<slug>`.

## Workflow

1. Inspect the repo and any existing batch/spec files that overlap the request.
2. Reuse existing intent from `PLAN.md`, `STRUCTURE.md`, and `MEMORY.md` when relevant.
3. Infer missing details when safe. Ask the user directly only if a missing detail would materially change execution.
4. Produce one durable batch spec that is specific enough for autonomous execution.
5. If the request supersedes an older batch, update that file instead of creating duplicates.

## Required Output Structure

Every batch file must contain these sections:

```md
# <Batch Title>

## Summary
Short statement of the product goal and why this batch exists.

## Scope
- Included work
- Explicitly excluded work

## Constraints
- Architectural constraints
- Product/UX constraints
- Tool/runtime constraints

## Assumptions
- Defaults the executor may rely on

## Execution Policy
- Completion standard
- Stop conditions
- Verification cadence
- Whether partial completion is acceptable

## Task Graph
For each task:
- `ID`
- `Title`
- `Depends on`
- `Why it exists`
- `Implementation notes`
- `Acceptance criteria`
- `Verification`
- `Status` (`pending` initially unless resuming)

## Critical Gates
Milestones that must be reached before later work can continue.

## Resume Instructions
How the executor should resume after compaction or interruption.
```

## Task Quality Rules

Every task must:

- be independently understandable
- have a real completion condition
- name the affected runtime or content surface
- include at least one verification step
- avoid vague verbs like "improve" without saying how success is judged

Every acceptance section should prefer concrete checks such as:

- tests and exact commands
- screenshot/video capture lanes
- file/path existence
- specific runtime behaviors
- visual/readability outcomes for player-facing work

## Dependency Rules

- Keep dependencies explicit.
- Default to shallow DAGs instead of deep chains.
- Split blocking architecture work from downstream content polish.
- If a task is exploratory, mark it clearly and define the decision it must produce.

## Batch Style

Optimize for execution, not presentation.

- Prefer short subsections over narrative prose.
- Use flat bullets.
- Keep each task atomic enough to finish in one sustained working slice.
- For very large epics, group tasks into phases, but still give each task its own acceptance criteria.

## Project-Specific Guidance

For this repo, assume:

- declarations remain the canonical content layer unless the batch explicitly replaces a subsystem
- `PLAN.md`, `STRUCTURE.md`, and `MEMORY.md` are the runtime checkpoint surface
- visual work is not done until renderer captures are reviewed
- player-perception and room-entry composition beat abstract architecture purity

When the batch concerns Ashworth Manor, include verification where relevant from:

- `godot --headless --path . --quit-after 1`
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

## Output Behavior

After writing the batch:

1. summarize the execution shape briefly
2. name the batch file path
3. call out the first critical task

Do not claim the batch is ready if tasks are missing acceptance criteria.
