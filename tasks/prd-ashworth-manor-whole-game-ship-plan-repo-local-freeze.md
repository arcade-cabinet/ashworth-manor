# PRD: Ashworth Manor Whole-Game Ship Plan, Freeze, and Release Validation

## Overview

Ship Ashworth Manor as one coherent, fully playable, polished declaration-first game from the front-gate arrival through the authored `Adult -> Elder -> Child` Elizabeth route order. This PRD covers canonical docs convergence, shared-spine completion, all three route implementations, unified music-box finale logic, `gdUnit4`-backed end-to-end playthrough proof, renderer-backed Godot debug-view acceptance, repo-local freeze, archive/handoff hygiene, post-freeze maintenance posture, and downstream Android release-candidate/export validation.

Repo-local product truth remains the primary convergence gate, but the whole-game ship plan is not complete until packaged Android/export validation has been audited, authored, and evidenced as part of the downstream release tranche.

## Goals

- Ship one canonical version of Ashworth Manor with no conflicting whole-game descriptions.
- Make the shared opening, basement spine, and all three Elizabeth timelines fully playable without debug intervention.
- Preserve declaration-authored content as source of truth.
- Prove playability with automated coverage that actually plays the game from a player perspective through `Adult`, `Elder`, and `Child`.
- Require renderer-backed Godot debug-view review for perception-sensitive beats and critical rooms.
- End in a frozen, documented, maintainable repo state with archived legacy weave-era material clearly separated from canonical truth.
- Carry the plan through release-candidate/export readiness so packaged build, install, and launch proof are part of the same whole-game ship contract.

## Quality Gates

Base gate for every story:
- `godot --headless --path . --quit-after 1`

Add the smallest relevant domain gate for the touched surface:
- Declaration and data-authoring stories: `godot --headless --path . --script test/generated/test_declarations.gd`
- Interaction, state, and progression stories: `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- Room topology and traversal stories: `godot --headless --path . --script test/e2e/test_room_specs.gd`
- Route-order and progression stories: `godot --headless --path . --script test/e2e/test_route_progression.gd`
- Full player-journey and ending stories: `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `gdUnit4` harness stories: `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd`

Perception-sensitive stories also require renderer-backed Godot debug-view review:
- `godot --path . --script test/e2e/test_opening_journey.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`
- Review captured output for the opening, basement landing, attic, crypt, hidden room, and each route finale.

Freeze-only gate:
- `godot --headless --path . --quit-after 1`
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

Release-validation gate:
- `godot --headless --path . --export-release "Android" build/ashworth-manor.apk`
- Run the current packaged smoke and critical-path validation flow described in `docs/MAESTRO_E2E_PLAN.md` or its canonical successor.
- Record install/launch proof on emulator or device, or record a real environment blocker honestly.

Quality rules:
- Full-playthrough proof must reflect actual player progression, not only flag injection.
- Perception-sensitive stories are not done until renderer-backed debug-view captures are reviewed.
- Docs-only completion is invalid if runtime and test surfaces still disagree.

## Parallelization Plan

Use each story's `Depends On` field as the source for Ralph `dependsOn`.

Intended parallel groups:
- Wave 1: `US-002`, `US-003`
- Wave 7: `US-009`, `US-011`, `US-013`
- Wave 10: `US-016`, `US-017`, `US-018`
- Wave 11: `US-019`, `US-020`

The graph is intentionally shaped so Ralph `auto` mode can detect meaningful parallel work once the shared spine is stable.

## User Stories

### US-001: Consolidate the canonical whole-game source of truth
**Depends On:** none  
**Description:** As a contributor, I want one canonical whole-game documentation surface so implementation, testing, and polish converge on the same shipped game.

**Acceptance Criteria:**
- [ ] One canonical doc surface defines premise, route order, shared spine, endings, critical rooms, tools, and acceptance lanes.
- [ ] `docs/GAME_BIBLE.md`, `docs/PLAYER_PREMISE.md`, `docs/ELIZABETH_ROUTE_PROGRAM.md`, `docs/NARRATIVE.md`, and `docs/MASTER_SCRIPT.md` no longer conflict about the shipped game.
- [ ] The canonical docs distinguish repo-local freeze from downstream Android/export validation without treating release validation as out of scope.

### US-002: Repoint the repo source map to the canonical docs and master graph
**Depends On:** US-001  
**Description:** As a contributor, I want the repo entry points to name the canonical sources first so work does not depend on archaeology.

**Acceptance Criteria:**
- [ ] `docs/INDEX.md`, `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md` clearly point to the canonical whole-game docs.
- [ ] `docs/batches/ashworth-master-task-graph.md` is identified as the primary execution contract.
- [ ] Canonical surfaces and historical support surfaces are distinguished explicitly.

### US-003: Capture the runtime baseline and define the shared-spine state map
**Depends On:** US-001  
**Description:** As an implementer, I want a verified starting baseline and canonical state map so shared-spine and route work target concrete runtime semantics.

**Acceptance Criteria:**
- [ ] The current runtime baseline, active test lanes, and known gaps are recorded in checkpoint docs.
- [ ] Canonical state keys are defined for basement relight, bad air, gas restored, basement lights awake, stable house light, walking-stick phase, and route-order progression.
- [ ] The baseline notes how the current test surface must evolve from legacy weave semantics to `Adult`, `Elder`, and `Child`.

### US-004: Finalize the arrival sequence from packet to dark foyer handoff
**Depends On:** US-003  
**Description:** As a player, I want the arrival sequence to establish legal duty, distance, and cold entry so the game opens as a coherent embodied journey.

**Acceptance Criteria:**
- [ ] Packet, valise, threshold acknowledgment, gate, drive, forecourt, and dark-house entry all follow the canonical heir-return sequence.
- [ ] The front-gate approach reads as materially grounded and socially legible without flattening the reveal.
- [ ] The foyer handoff preserves darkness, hostility, and route-program intent.

### US-005: Finalize first warmth, firebrand acquisition, and the forced kitchen descent
**Depends On:** US-004  
**Description:** As a player, I want the first house answer and Elizabeth's first seizure beat to feel authored so the early game turns decisively into the service-world descent.

**Acceptance Criteria:**
- [ ] Early foyer, parlor, kitchen, and dining flow produce one coherent first-warmth rule set.
- [ ] The player reliably acquires the firebrand through the parlor hearth.
- [ ] Elizabeth's laugh, firebrand loss, and kitchen-side forced descent trigger cleanly and intentionally.

### US-006: Implement the storage-basement landing, improvised relight, and bad-air pressure
**Depends On:** US-003, US-005  
**Description:** As a player, I want the basement arrival to be consequential and hostile so recovery of light and survival pressure become embodied play rather than abstract state changes.

**Acceptance Criteria:**
- [ ] The storage-basement fall lands as an authored event with immediate bodily consequence.
- [ ] The player must reclaim light through concise improvised relight logic.
- [ ] Bad air creates meaningful pressure and failure consequence without HUD-style timers.

### US-007: Re-author the boiler and restore estate lighting coherently
**Depends On:** US-006  
**Description:** As a player, I want gas restoration to feel like reclaiming infrastructure so the house visibly changes when service machinery is brought back.

**Acceptance Criteria:**
- [ ] The boiler room reads as concise service machinery rather than stale occult residue.
- [ ] Gas restoration is a short, meaningful sequence that immediately wakes basement sconces.
- [ ] Stable restored-light state propagates across the shared accessible mansion on subsequent loads.

### US-008: Build the service-world return and walking-stick transition
**Depends On:** US-007  
**Description:** As a player, I want re-emergence from the basement and the next tool phase to feel socially and mechanically coherent so midgame identity changes are legible.

**Acceptance Criteria:**
- [ ] The player exits the service world through utilitarian circulation rather than a magical snap-back.
- [ ] The walking stick cleanly replaces the early carried-light phase.
- [ ] The walking stick gets an immediate first meaningful use.

### US-009: Author the Adult-route clue topology and shared-room bias
**Depends On:** US-008  
**Description:** As a player entering the Adult timeline, I want the house to bias me toward denied adulthood and private life so the attic resolution feels earned.

**Acceptance Criteria:**
- [ ] An Adult-route clue topology is recorded in canonical working surfaces.
- [ ] Shared and upper-house content biases toward letters, portraits, private effects, and denied adulthood.
- [ ] The Adult route is legible before the attic becomes the final chamber.

### US-010: Deliver the Adult attic resolution, ending, docs, and capture proof
**Depends On:** US-009  
**Description:** As a player on the Adult timeline, I want the attic to resolve the route through the music box so the first canonical completion feels definitive.

**Acceptance Criteria:**
- [ ] Adult late-game access clearly aims at attic truth and the attic functions as the true final room.
- [ ] Adult late transition includes the route-specific late darkness / lantern-on-hook progression that opens attic truth rather than bypassing it.
- [ ] The Adult music-box solve completes cleanly and records route completion without breaking fixed route order.
- [ ] Adult docs and renderer-backed debug-view captures agree on the implemented route.

### US-011: Author the Elder-route clue topology and blackout grammar
**Depends On:** US-008  
**Description:** As a player entering the Elder timeline, I want the route to bias toward burial, caretaking, and altered memory so the later descent reads as distinct from Adult.

**Acceptance Criteria:**
- [ ] An Elder-route clue topology is recorded in canonical working surfaces.
- [ ] Shared and upper-house content biases toward burial records, caretaker residue, and altered memory.
- [ ] The Elder rupture, blackout, and lantern-on-hook grammar are distinct from the Adult route.

### US-012: Deliver the Elder cellar-to-crypt resolution, ending, docs, and capture proof
**Depends On:** US-011  
**Description:** As a player on the Elder timeline, I want the late route to descend into personal burial truth so the second canonical completion hands off cleanly to Child.

**Acceptance Criteria:**
- [ ] Elder late-game includes attic rupture, blackout descent, lantern-on-hook transition, wine-cellar bypass, and crypt-gate resolution as one coherent sequence.
- [ ] Wine cellar traversal and crypt chamber feel route-specific, intimate, and accusatory.
- [ ] The Elder music-box solve resolves the route and advances progression toward `Child`.
- [ ] Elder docs and renderer-backed debug-view captures agree on blackout, cellar, crypt, and finale behavior.

### US-013: Author the Child-route clue topology and blocked-architecture chain
**Depends On:** US-008  
**Description:** As a player entering the Child timeline, I want the route to bias toward hidden childhood and blocked architecture so the final reveal feels physical rather than symbolic.

**Acceptance Criteria:**
- [ ] A Child-route clue topology is recorded in canonical working surfaces.
- [ ] Shared and upper-house content biases toward nursery traces, concealment, blocked architecture, and memory intrusion.
- [ ] The attic becomes a clue engine that redirects the player away from attic truth and toward hidden-room truth.

### US-014: Deliver the Child hidden-room resolution, ending, docs, and capture proof
**Depends On:** US-013  
**Description:** As a player on the Child timeline, I want the hidden room to reveal erased domestic truth through the music box so the deepest route lands as the final canonical revelation.

**Acceptance Criteria:**
- [ ] Hidden-room discovery is architectural and authored, not arbitrary.
- [ ] Child late-game initially resembles attic truth, then redirects through attic clues into the sealed-room reveal.
- [ ] The hidden chamber reads as erased domestic truth rather than occult residue.
- [ ] The Child music-box solve, route completion, docs, and renderer-backed debug-view captures all agree.

### US-015: Unify the winding-key/music-box system and harden route-order progression
**Depends On:** US-010, US-012, US-014  
**Description:** As a player, I want one coherent final-object arc and one stable route order so all three timelines feel like one shipped game rather than separate prototypes.

**Acceptance Criteria:**
- [ ] The winding key and music box form one coherent mechanical and symbolic system across all routes.
- [ ] Runtime progression is fixed to `Adult -> Elder -> Child` with explicit post-third-run behavior.
- [ ] Any legacy `macro_thread` compatibility is hidden implementation detail only, not canonical design truth.

### US-016: Migrate critical-path room docs off the old weave
**Depends On:** US-001, US-015  
**Description:** As a contributor, I want critical-path room docs to describe the shipped route program so the room corpus no longer misleads implementation or review.

**Acceptance Criteria:**
- [ ] Critical-path room docs no longer frame current gameplay through `Captive`, `Mourning`, `Sovereign`, or the old weave.
- [ ] Opening, basement, attic, crypt, and hidden-room docs all match the shipped route program.
- [ ] Any remaining weave-era references in room docs are clearly archived or historical.

### US-017: Migrate declaration-authored route text off the old weave
**Depends On:** US-015  
**Description:** As a player, I want declaration-authored text to speak the shipped game so interactions, endings, and room language do not leak superseded route logic.

**Acceptance Criteria:**
- [ ] Route-facing declarations align with `Adult`, `Elder`, and `Child`.
- [ ] Critical-path declaration text no longer presents weave-era route framing as canonical.
- [ ] Search-based audits over `declarations/` only leave intentional compatibility shims or archived references.

### US-018: Expand `gdUnit4`-backed automated coverage for the full three-route program
**Depends On:** US-008, US-010, US-012, US-014, US-015  
**Description:** As a maintainer, I want automated coverage that actually plays the shipped game through all three Elizabeth timelines so regressions are caught as player-visible failures.

**Acceptance Criteria:**
- [ ] The full-playthrough surface drives real route progression from a clean start through `Adult -> Elder -> Child`.
- [ ] Route-order, shared-spine, and ending coverage distinguish the three authored timelines rather than only legacy compatibility outcomes.
- [ ] The suite runs through the repo's documented `gdUnit4` CLI and emits usable reports under the existing reporting flow.

### US-019: Rebuild renderer-backed debug-view acceptance lanes for product-truth review
**Depends On:** US-007, US-010, US-012, US-014, US-018  
**Description:** As a reviewer, I want renderer-backed Godot debug-view acceptance lanes so visual and traversal regressions can be judged against stable evidence.

**Acceptance Criteria:**
- [ ] `test/e2e/test_opening_journey.gd` and `test/e2e/test_room_walkthrough.gd` reflect the shipped opening, shared spine, and route finales.
- [ ] Capture manifests cover the opening, basement, attic, crypt, hidden room, and each route finale.
- [ ] Review evidence is organized so failures are actionable without ad hoc manual capture work.

### US-020: Polish critical-path assets, materials, silhouette, and sourced lighting
**Depends On:** US-007, US-010, US-012, US-014, US-018  
**Description:** As a player, I want the critical path to feel visually intentional and fully sourced so the final product reads as polished rather than merely complete.

**Acceptance Criteria:**
- [ ] Opening, basement, attic, crypt, and hidden room each have distinct visual identity and disciplined materials.
- [ ] All dramatic lighting remains visibly sourced by candles, sconces, windows, lanterns, or machinery.
- [ ] Polish changes preserve declaration-first runtime behavior and do not regress automated route coverage.

### US-021: Run the repo-local integration freeze and convergence proof
**Depends On:** US-015, US-016, US-017, US-018, US-019, US-020  
**Description:** As the project owner, I want one freeze gate where runtime, docs, tests, and visual evidence all converge so repo-local completion is defensible.

**Acceptance Criteria:**
- [ ] The full freeze-only command set passes.
- [ ] A clean-save player journey can complete the shared spine and all three Elizabeth timelines in the shipped order.
- [ ] Canonical docs, declarations, test reports, and renderer-backed captures all describe the same finished game.

### US-022: Archive historical weave-era material and tighten contributor handoff
**Depends On:** US-021  
**Description:** As a future contributor, I want archived historical material clearly separated from canonical truth so resuming work after freeze is low-friction and low-risk.

**Acceptance Criteria:**
- [ ] Retained weave-era docs are marked archived or superseded and no longer read as current truth.
- [ ] `docs/INDEX.md`, `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md` clearly distinguish canonical, archived, and maintenance surfaces.
- [ ] Contributor-facing handoff instructions name the canonical source map, regression lanes, and route-order invariants.

### US-023: Establish the post-freeze maintenance baseline and regression register
**Depends On:** US-021, US-022  
**Description:** As a maintainer, I want a known-good maintenance baseline so future fixes start from an honest verified state rather than from assumptions.

**Acceptance Criteria:**
- [ ] A post-freeze baseline rerun is recorded from the frozen repo state.
- [ ] The maintenance register names flaky lanes, high-risk rooms/systems, and likely future regression fronts.
- [ ] The repo is left in a clear maintenance posture rather than implicit ongoing feature development.

### US-024: Audit Android export and packaged-validation prerequisites
**Depends On:** US-021  
**Description:** As a releaser, I want a concrete packaged-validation prerequisite map so release work starts from honest Android/export assumptions rather than wishful thinking.

**Acceptance Criteria:**
- [ ] `export_presets.cfg`, build paths, and packaged-validation docs are audited together.
- [ ] SDK, signing, emulator/device, and automation prerequisites are recorded explicitly.
- [ ] Any missing local prerequisites are marked as real blockers, not silently ignored.

### US-025: Finish debug-gated packaged test-helper support
**Depends On:** US-024  
**Description:** As a maintainer, I want packaged debug/test helper support to be stable and safely gated so device automation can target the critical path without leaking test affordances into normal play.

**Acceptance Criteria:**
- [ ] Packaged debug/test builds expose stable automation hooks where needed.
- [ ] Test-helper affordances are clearly gated away from normal player-facing runtime.
- [ ] Helper support is documented well enough for packaged smoke validation to consume it.

### US-026: Author packaged smoke and critical-path validation flows
**Depends On:** US-025  
**Description:** As a reviewer, I want packaged smoke and critical-path validation flows so release readiness is backed by repeatable launch-to-critical-path evidence.

**Acceptance Criteria:**
- [ ] A packaged validation flow covers launch, valise, dark-house entry, first warmth, and one deeper continuation.
- [ ] Emulator/device validation steps are documented in an executable order.
- [ ] Packaged validation evidence can be gathered without ad hoc rediscovery.

### US-027: Build the release candidate, validate install and launch, and close release-readiness docs
**Depends On:** US-024, US-025, US-026  
**Description:** As the project owner, I want one final packaged-validation proof point so the whole-game ship plan ends with actual build/install/launch evidence rather than repo-local confidence alone.

**Acceptance Criteria:**
- [ ] The Android release build completes successfully.
- [ ] Install and launch are proven on emulator or device, with honest evidence captured.
- [ ] Release-readiness docs record actual packaged-validation scope, evidence, and remaining caveats.

## Functional Requirements

1. FR-1: Declarations and declaration-driven runtime content remain the source of truth for shipped content.
2. FR-2: The opening must begin with the packet/valise sequence at `front_gate` and progress through gate, drive, forecourt, and dark foyer coherently.
3. FR-3: First warmth, firebrand acquisition, and the kitchen-side forced descent must form one authored early-game transition.
4. FR-4: Basement play must use embodied relight and bad-air pressure, not HUD timers or abstract overlays.
5. FR-5: Gas restoration must immediately and visibly change basement and shared-house lighting.
6. FR-6: The walking stick must replace the early carried-light phase and matter immediately.
7. FR-7: Each Elizabeth timeline must have a distinct clue grammar and distinct final truth architecture: attic for Adult, crypt for Elder, hidden room for Child.
8. FR-8: The music box and winding key must remain the invariant final solve system across all three timelines.
9. FR-9: Runtime route order must be fixed to `Adult -> Elder -> Child`, with explicit post-third-run behavior.
10. FR-10: Canonical docs and declaration text must remove weave-era framing from current product truth.
11. FR-11: Automated playthrough coverage must actually play the game from a player perspective across all three authored timelines.
12. FR-12: The automated route surface must be runnable through the repo's `gdUnit4` command path and produce reports.
13. FR-13: Perception-sensitive acceptance must include renderer-backed Godot debug-view capture review.
14. FR-14: Repo-local freeze, archive/handoff, and maintenance posture are in scope as the canonical convergence gate.
15. FR-15: Android/export readiness, packaged smoke validation, and device launch proof are downstream whole-game ship requirements, not optional future work.

## Non-Goals

- New routes beyond `Adult`, `Elder`, and `Child`
- Combat, enemies, or HUD-first redesign
- Revival of the old `Captive / Mourning / Sovereign` weave as active game design
- Modernized setting, futuristic aesthetics, or non-diegetic control/UI overhauls
- New audio systems beyond the current loop-based support

## Technical Considerations

- Primary implementation surfaces are expected to include `declarations/*.tres`, `declarations/rooms/`, `engine/`, `scripts/game_manager.gd`, `scripts/room_manager.gd`, `scripts/world_runtime_manager.gd`, `scripts/interaction_manager.gd`, `scripts/room_base.gd`, `scripts/ui_overlay.gd`, `test/e2e/`, and canonical docs under `docs/`.
- The current repo already contains a `gdUnit4` install and a documented CLI at `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd`; the PRD expects the three-route proof to be available through that harness.
- `test/e2e/test_full_playthrough.gd` currently reflects legacy compatibility semantics; part of this PRD is upgrading that surface to authored route truth.
- Downstream release work is expected to touch `export_presets.cfg`, `build/`, and packaged-validation docs such as `docs/MAESTRO_E2E_PLAN.md`.
- To preserve Ralph `auto` parallelism, route clue-map artifacts should live in route-specific or partitioned surfaces rather than forcing unrelated stories to fight over the same checkpoint file.
- Shared checkpoint files such as `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md` should be updated by the stories that own source-map, freeze, archive, or maintenance outcomes to reduce parallel merge conflicts.

## Success Metrics

- A clean-save player journey can complete `Adult -> Elder -> Child` without manual flag edits or console intervention.
- The repo's `gdUnit4`-backed automated lane and the final freeze gate both pass.
- Renderer-backed Godot debug-view review signs off the opening, basement, attic, crypt, hidden room, and each route finale.
- Canonical doc surfaces and declaration text no longer present weave-era truth as current design.
- Post-freeze contributors can identify canonical sources, archived history, and regression lanes without archaeology.
- The Android release candidate builds, installs, launches, and has critical-path validation evidence recorded honestly.

## Open Questions

- Should route clue-topology artifacts live in route-specific docs, or in partitioned sections of `MEMORY.md`?
- Should legacy `macro_thread` values remain as internal compatibility shims after the new route-order surface is complete, or be removed entirely?
- Should renderer-backed debug-view captures remain generated artifacts outside version control, or should a curated subset be committed as stable review evidence?
- If Android/export prerequisites are incomplete on the current machine, what is the canonical blocked-state evidence format for release stories?
