# Ashworth Manor Production Recovery

## Summary

Drive Ashworth Manor to a production-quality baseline where the player journey is coherent, traversal feels physical, room staging communicates intent, and the declaration/runtime/docs/test surfaces all agree.

## Scope

- Included:
  - opening route repair
  - critical-path room composition
  - compiled-world traversal improvement
  - threshold mechanism completion
  - dynamic setpiece and puzzle audit
  - validation/self-healing hardening
  - final repo/docs alignment
- Excluded:
  - save compatibility preservation
  - combat or enemy systems
  - non-diegetic HUD redesign

## Constraints

- Forward+ renderer is canonical when it materially improves atmosphere, glass, water, and lighting readability
- Declarations remain the canonical content layer unless a subsystem is intentionally replaced
- Procedural shell > inset model detail > procedural moving mechanism is the architectural stack
- Same-world ordinary doors should not default to fade transitions
- Visual acceptance must come from renderer captures, not code inspection alone

## Assumptions

- Existing tests remain worth preserving and extending
- Source models, textures, and sounds already exist in the repo
- It is acceptable to break compatibility if doing so materially improves the game
- Player-perception quality matters more than maintaining legacy architectural assumptions

## Execution Policy

- Completion standard: no task is complete until its acceptance criteria and verification both pass
- Partial completion is not success
- Stop only for:
  - critical blocker
  - contradictory requirements
  - user redirect
- Update `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md` when the architecture or execution state changes materially

## Task Graph

### T01
- `Title:` Repair front-gate facade massing and opening composition
- `Depends on:` none
- `Why it exists:` the current opening still reads like a flat stage facade instead of a moonlit manor approach
- `Implementation notes:`
  - strengthen the gate-to-manor spatial hierarchy
  - replace flat facade staging with readable front elevation logic
  - keep the diegetic sign/menu and hedge-lined path intact
- `Acceptance criteria:`
  - `00_gate_menu.png`, `02_gate_threshold.png`, and `05_front_door_approach.png` show a believable manor destination
  - the moon, sign, hedges, and facade read as one opening sequence
  - no side-frame void/clipped junk dominates the shot
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### T02
- `Title:` Repair the foyer front-door handoff
- `Depends on:` T01
- `Why it exists:` the current first frame inside the manor is still blocker-heavy and not worthy of the opening handoff
- `Implementation notes:`
  - adjust threshold pose, nearby shell composition, and hall-axis readability
  - the staircase and route hierarchy must win immediately
- `Acceptance criteria:`
  - `06_foyer_handoff.png` shows a readable hall axis and stair pull
  - no dominant wall/ceiling obstruction crowds the frame
- `Verification:`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `Status:` pending

### T03
- `Title:` Polish remaining critical-path first frames
- `Depends on:` T02
- `Why it exists:` `library`, `kitchen`, and `attic_stairs` still do not fully sell their room thesis
- `Implementation notes:`
  - focus on first-frame readability, lights, blockers, and focal anchors
- `Acceptance criteria:`
  - `library` lands on a clue tableau
  - `kitchen` lands on a service-story tableau
  - `attic_stairs` lands on a vertical trespass image
- `Verification:`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` pending

### T04
- `Title:` Remove remaining same-world room-swap feel
- `Depends on:` none
- `Why it exists:` compiled-world traversal is better, but still not fully continuous
- `Implementation notes:`
  - keep improving live compiled-world navigation
  - ordinary same-world doors should rely on the live seam, not room-entry snaps
- `Acceptance criteria:`
  - same-world door traversal no longer reads like hidden repositioning on the main route
  - manor interior traversal is materially more continuous
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` pending

### T05
- `Title:` Finish threshold mechanism assemblies
- `Depends on:` T04
- `Why it exists:` threshold feel is core to the game and still only partially realized
- `Implementation notes:`
  - doors, gates, ladders, trapdoors, and secret passages need complete presentation/state logic
- `Acceptance criteria:`
  - at least one polished working example exists for each threshold family
  - thresholds visibly open/reveal/deploy before traversal where appropriate
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `Status:` pending

### T06
- `Title:` Complete the service secret passage end-to-end
- `Depends on:` T05
- `Why it exists:` the `storage_basement <-> carriage_house` route is the benchmark for hidden mechanism feel
- `Implementation notes:`
  - reveal, open, persist, traverse, and return path must all work convincingly
- `Acceptance criteria:`
  - concealed seam, reveal, and post-open traversal all work both directions
  - persistence survives re-entry
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `Status:` pending

### T07
- `Title:` Audit dynamic setpieces and local puzzle state grammar
- `Depends on:` none
- `Why it exists:` the game logic may still be formally consistent while feeling non-actionable to a player
- `Implementation notes:`
  - audit side-diamond logic, local puzzle readability, and cross-room functional roles
  - ensure dynamic setpieces reflect actual state changes visually
  - current live progress:
    - chapel font now has still, disturbed, and searched liquid states
    - kitchen bucket is now a real scene-authored interactable with still and rippled water states
    - parlor tea service is now a real low-table tableau with disturbed liquid states after inspection
    - dining-room wine glass is now a real stateful setpiece with agitated liquid after inspection
    - next likely extensions are greenhouse/garden water beats and other service containers
- `Acceptance criteria:`
  - major story and puzzle interactions have clear functional roles and visible states
  - at least one tea-service style side-diamond is fully coherent in data and runtime
- `Verification:`
  - declaration tests plus targeted runtime interaction checks
- `Status:` in_progress

### T08
- `Title:` Audit outlook grammar and exterior/interior view treatment
- `Depends on:` T03
- `Why it exists:` window-facing and glazed spaces still need better view logic
- `Implementation notes:`
  - greenhouse, wing rooms, and threshold outlooks should read intentionally
- `Acceptance criteria:`
  - greenhouse can face house-return and glass-envelope directions without flattening
  - important windows read as outlooks, not just emissive fillers
- `Verification:`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `Status:` pending

### T09
- `Title:` Harden compiler validation and self-healing
- `Depends on:` T01, T02, T03
- `Why it exists:` too many spatial/framing defects are still discovered late through screenshots
- `Implementation notes:`
  - add spawn-cone, blocker, anchor, clearance, and graph-compatibility checks
- `Acceptance criteria:`
  - declaration validation catches missing critical anchors and obvious spawn/framing failures earlier
  - self-healing recommendations exist for simple scale/anchor corrections
- `Verification:`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
- `Status:` pending

### T10
- `Title:` Full puzzle and ending playability audit
- `Depends on:` T05, T06, T07
- `Why it exists:` the planned puzzle structure has not yet been fully validated as an actual game journey
- `Implementation notes:`
  - verify puzzle solvability, side-diamond usability, and ending triggers from a player perspective
- `Acceptance criteria:`
  - puzzle route is actionable without hidden author-only assumptions
  - all endings remain reachable through intentional play
- `Verification:`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - targeted player-journey checks as needed
- `Status:` pending

### T11
- `Title:` Final docs and asset-map alignment
- `Depends on:` T07, T08, T09
- `Why it exists:` repo docs must describe the shipped game, not the superseded architecture
- `Implementation notes:`
  - ensure scene grammar, compiled worlds, procedural stack, and threshold philosophy are consistently documented
- `Acceptance criteria:`
  - no top-level docs imply the old room-scene runtime as primary
  - room/authoring docs align with actual declaration/runtime grammar
- `Verification:`
  - docs spot-check against runtime files
- `Status:` pending

### T12
- `Title:` Production acceptance freeze
- `Depends on:` T01, T02, T03, T04, T05, T06, T09, T10, T11
- `Why it exists:` the repo should only be called production-ready once all acceptance surfaces converge
- `Implementation notes:`
  - run the full command suite and do a final visual pass
- `Acceptance criteria:`
  - declaration, interaction, room-spec, playthrough, walkthrough, and opening-journey lanes all pass
  - critical-path visuals are accepted
  - no key threshold still feels placeholder
- `Verification:`
  - all major Godot command lanes
- `Status:` pending

## Critical Gates

- Gate A: opening route is visually acceptable before deeper route polish continues
- Gate B: same-world traversal and threshold feel are credible before puzzle playability is signed off
- Gate C: validation catches the major spatial/framing failure classes before final freeze

## Resume Instructions

1. Read this file first.
2. Read `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md`.
3. Resume from the earliest unblocked task not marked `verified_done`.
4. Update task statuses as work progresses.
5. Do not declare success while any required task remains `pending` or `blocked`.
