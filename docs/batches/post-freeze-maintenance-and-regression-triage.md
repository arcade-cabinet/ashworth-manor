# Post-Freeze Maintenance and Regression Triage

## Summary
Maintain Ashworth Manor after completion by triaging regressions, keeping canonical docs and acceptance evidence aligned with the shipped runtime, and applying bounded polish or bug-fix work without reopening core design. This batch exists so post-freeze work has one disciplined execution surface instead of drifting back into unstructured redesign.

## Scope
- Included work
  - reproduce and classify post-freeze bugs or regressions
  - apply bounded runtime, declaration, doc, or test fixes that preserve shipped canon
  - re-run targeted and full acceptance lanes after fixes
  - keep canonical docs, checkpoints, and acceptance evidence honest as maintenance work lands
  - record maintenance findings and residual risks for future contributors
- Explicitly excluded work
  - new routes, new endings, or canonical story redesign
  - major system rewrites not justified by concrete shipped regressions
  - speculative polish work without a discovered player-facing defect or measurable acceptance gap
  - release/distribution infrastructure outside repo-local maintenance documentation

## Constraints
- Declarations remain canonical.
- This batch assumes the final integration and archive/handoff batches are complete enough that the game is in maintenance posture, not active production redesign.
- Preserve the shipped `Adult -> Elder -> Child` route program.
- Do not revive the old weave or reopen foundational narrative decisions unless a concrete bug proves the current implementation impossible to maintain.
- Fixes should be small, testable, and tied to discovered defects or mismatches.
- Renderer-backed review remains part of maintenance whenever visual/player-perception surfaces are touched.

## Assumptions
- The canonical source map already exists and points to:
  - `docs/PLAYER_PREMISE.md`
  - `docs/ELIZABETH_ROUTE_PROGRAM.md`
  - `docs/NARRATIVE.md`
  - `docs/MASTER_SCRIPT.md`
  - `docs/script/MASTER_SCRIPT.md`
  - `PLAN.md`
  - `MEMORY.md`
  - `STRUCTURE.md`
- Acceptance evidence already includes:
  - declaration tests
  - interaction tests
  - route/full-playthrough lanes
  - renderer-backed opening and walkthrough captures
- Post-freeze issues may still surface in:
  - room docs drifting from runtime
  - route order / ending regressions
  - visual composition or sourced-light regressions
  - stale archive/canonical labels after follow-on edits

## Execution Policy
- Completion standard
  - The batch is complete only when discovered regressions are triaged, bounded fixes land at verified checkpoints, and the checkpoint/docs surface still tells the truth about the shipped game.
- Stop conditions
  - Stop if a discovered issue would require reopening core route design rather than maintenance.
  - Stop if a proposed fix would trigger broad non-regression work better handled as a new explicit production batch.
  - Stop if the bug cannot be reproduced or classified well enough to drive bounded implementation.
- Verification cadence
  - Reproduce first, then patch.
  - Re-run the smallest meaningful automated surface after each fix.
  - Re-run renderer-backed lanes for any visual or walkthrough-affecting change.
- Partial completion
  - Acceptable only at verified checkpoint boundaries inside this batch.
  - Do not leave the repo with unverified “probably fixed” maintenance edits.

## Task Graph

### M01
- `ID:` M01
- `Title:` Establish the current maintenance baseline and issue register
- `Depends on:` none
- `Why it exists:` maintenance work must start from a known-good baseline and a concrete list of discovered issues rather than ad hoc edits.
- `Implementation notes:`
  - run the baseline acceptance surface
  - collect any failing tests, renderer discrepancies, or canonical-surface mismatches
  - record the maintenance issue register in `MEMORY.md`
- `Acceptance criteria:`
  - there is a current maintenance baseline and issue list
  - each known issue is classified as logic, content, visual, docs, or archive/handoff drift
  - future maintenance slices can point at specific defects rather than “general polish”
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - update `MEMORY.md` with the maintenance register
- `Status:` pending

### M02
- `ID:` M02
- `Title:` Triage and fix bounded runtime/declaration regressions
- `Depends on:` M01
- `Why it exists:` the highest-value post-freeze work is fixing concrete regressions without destabilizing the shipped structure.
- `Implementation notes:`
  - choose the highest-severity reproducible issues first
  - prefer small declaration/runtime fixes over broad rewrites
  - keep route order, ending semantics, and shared-spine grammar intact
  - update or add targeted tests when fixing logic regressions
- `Acceptance criteria:`
  - selected runtime/declaration regressions are fixed and reproducible before/after behavior is clear
  - fixes do not reopen canonical design
  - targeted automated coverage exists for the patched regressions where practical
- `Verification:`
  - relevant targeted test commands per issue
  - at minimum `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `Status:` pending

### M03
- `ID:` M03
- `Title:` Triage and fix visual, walkthrough, and sourced-light regressions
- `Depends on:` M01
- `Why it exists:` many post-freeze problems will be player-perception issues that only show up in captures or walkthrough review.
- `Implementation notes:`
  - review renderer-backed opening and room-walkthrough evidence
  - fix only concrete visual defects:
    - lost physical light sources
    - broken composition
    - route-finale staging regressions
    - prop/material drift that undermines the period look
  - keep fixes narrow and reviewer-visible
- `Acceptance criteria:`
  - selected visual regressions are corrected and visible in updated captures
  - sourced-light discipline is preserved in touched spaces
  - walkthrough lanes remain representative of the shipped route grammar
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - screenshot output exists under Godot `user://`
- `Status:` pending

### M04
- `ID:` M04
- `Title:` Repair docs, checkpoint, and archive-surface drift caused by maintenance fixes
- `Depends on:` M02, M03
- `Why it exists:` even small maintenance fixes can desynchronize canonical docs or archive labels if the repo does not explicitly close the loop.
- `Implementation notes:`
  - update only the docs and checkpoint files touched by actual maintenance changes
  - preserve the canonical/archive boundary established by the handoff batch
  - note residual risks or intentionally deferred issues in `MEMORY.md`
- `Acceptance criteria:`
  - touched docs and checkpoint surfaces match the current runtime
  - archive labeling remains intact after maintenance edits
  - `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md` remain trustworthy entry points
- `Verification:`
  - targeted review of touched docs/checkpoint files
  - `rg -n "Captive|Mourning|Sovereign|weave" docs`
- `Status:` pending

### M05
- `ID:` M05
- `Title:` Re-run maintenance acceptance and record the next maintenance frontier
- `Depends on:` M02, M03, M04
- `Why it exists:` maintenance work should end with a fresh verified baseline and a clear note about what, if anything, remains.
- `Implementation notes:`
  - run the appropriate acceptance surface for the issues fixed in this maintenance pass
  - summarize remaining issues as:
    - fixed
    - deferred
    - unreproduced
  - leave a concise next-frontier note in `MEMORY.md`
- `Acceptance criteria:`
  - the maintenance pass ends at a verified checkpoint
  - the repo has a current maintenance summary rather than only historical conversation context
  - any remaining work is clearly classified and bounded
- `Verification:`
  - `godot --headless --path . --quit-after 1`
  - rerun the relevant logic and renderer lanes for the touched surfaces
- `Status:` pending

## Critical Gates
- Gate 1: M01 must produce a concrete maintenance register before any fixes begin.
- Gate 2: M02 and M03 must stay bounded to discovered regressions; if work starts mutating canon, it belongs in a new explicit batch.
- Gate 3: M05 must leave a fresh verified baseline and next-frontier note; otherwise maintenance context is lost again.

## Resume Instructions
- Start from this file and the final completed closeout batches:
  - `docs/batches/final-integration-and-acceptance.md`
  - `docs/batches/archive-and-handoff-hygiene.md`
- Before editing, verify the current baseline:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
- Resume at M01 unless a current maintenance register already exists in `MEMORY.md`.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, stop at a verified checkpoint or record the exact maintenance blocker in `MEMORY.md`.
