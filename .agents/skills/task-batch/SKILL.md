---
name: task-batch
description: |
  Use when the user wants Codex to execute a durable batch spec, continue a long autonomous implementation run, or work through a repo-local task graph until completion or a real blocker. Triggers include "run the batch", "execute this batch", "keep going until done", "resume autonomous work", or "continue the task graph".
---

# Task Batch

Execute a durable batch spec continuously using Codex-native checkpoint files.

## Purpose

This skill is the execution half of long autonomous work. It is built for repos that keep durable execution state in files instead of external task objects.

Primary state surfaces:

- `docs/batches/<slug>.md`
- `PLAN.md`
- `STRUCTURE.md`
- `MEMORY.md`

## Core Contract

Do not treat a batch as a loose suggestion. Treat it as an execution contract.

The executor should continue until one of these is true:

- all tasks are complete and verified
- a critical blocker prevents further safe progress
- the user redirects the work

Do not stop just because one task was completed if the batch still has runnable work.

## Startup

1. Read the target batch file.
2. Read `PLAN.md`, `STRUCTURE.md`, and `MEMORY.md` when they are relevant or present.
3. Build a working task order from dependency information.
4. Update the live plan/tool plan so the current execution slice is explicit.
5. Start with the earliest unblocked task.

## Execution Rules

For each task:

1. restate the task goal to yourself in implementation terms
2. inspect only the code and content needed for that task
3. implement the change
4. run the task’s verification steps
5. update durable state before moving on

Durable state means:

- mark task status in the batch file
- update `PLAN.md` when the execution plan materially changes
- record discoveries, dead ends, and workarounds in `MEMORY.md`
- update `STRUCTURE.md` when architecture actually changes

## Status Vocabulary

Use these task statuses inside the batch file:

- `pending`
- `in_progress`
- `blocked`
- `verified_done`
- `skipped`

`verified_done` means the task’s acceptance criteria and verification both passed.

## Stop Conditions

Allowed reasons to stop early:

- missing required artifact or environment that cannot be inferred or created safely
- contradictory batch requirements that require user arbitration
- external dependency failure that blocks execution
- repeated verification failure after a reasonable repair attempt

If you stop early:

1. mark the blocked task as `blocked`
2. record the blocker in `MEMORY.md`
3. state exactly what remains incomplete

Do not present partial completion as success.

## Validation Discipline

Never mark a task done based on code inspection alone when the batch asks for runtime or visual behavior.

Prefer:

- exact test commands
- screenshot or render capture lanes
- focused interaction checks
- concrete file/path validation

For Ashworth Manor specifically, use the declared test and render lanes whenever the task touches runtime, room composition, traversal, or perception.

## Long-Run Behavior

Optimize for continuity across many turns:

- keep notes terse and durable
- avoid re-reading the whole repo every time
- use the batch file as the source of pending work
- keep `MEMORY.md` factual and execution-focused

## Delegation

Only use sub-agents when the user has explicitly authorized delegation or parallel agent work.

When delegation is allowed:

- keep each delegated task narrow
- assign disjoint ownership
- keep the main thread on critical-path integration

If the user has not authorized delegation, execute locally.

## Batch File Maintenance

While executing:

- keep completed tasks marked `verified_done`
- move the active task to `in_progress`
- keep blocked tasks explicit
- do not silently rewrite acceptance criteria after the fact just to make a task pass

If new work is discovered:

- add it as a new task only if it is required for correctness
- link it to its dependency
- keep the batch graph honest

## Completion

A batch is complete only when:

- all required tasks are `verified_done` or intentionally `skipped`
- no unresolved `blocked` tasks remain
- final verification gates were run
- checkpoint files reflect the completed state

On completion:

1. summarize what shipped
2. list final verification performed
3. name any residual risks that were intentionally accepted
