# Memory

## Canonical Narrative Decisions

- The old `Captive / Mourning / Sovereign` weave is no longer the shipped macro
  narrative model.
- The canonical route order for first completion is:
  - `Adult`
  - `Elder`
  - `Child`
- Elizabeth's music box is the invariant final solve object across all routes.
- Outside paperwork and estate signage remain neutral.
- Elizabeth's laugh only marks significant events.
- `docs/GAME_BIBLE.md` is now the whole-game canonical reference.
- `docs/batches/ashworth-master-task-graph.md` is now the primary execution
  contract and supersedes the fragmented batch chain as the main task surface.

## Player Premise

- Playable present is shortly after the Victorian collapse, not a modern ruin.
- Player is an Ashworth descendant and already knows that fact.
- Player visited as a child, then was abruptly kept away.
- Return is triggered by a solicitor's packet after the final caretaker's death.
- First embodied arrival is the front gate as the hired cab departs.
- Valise beneath the sign establishes inventory diegetically.

## Shared Spine

- packet
- front gate and valise
- ceremonial drive
- dark front-door entry
- first warmth/light problem
- early ground-floor cluster
- kitchen-side service descent
- service basement gas restoration
- walking-stick midgame possession

## Tool and Light Grammar

- Early held state: `firebrand`
- Midgame held state: `walking stick`
- Late held state: `lantern hook`
- Major transitions should consume or discard the previous held tool
- Midgame house light should become stable after gas restoration
- Late game must be able to remove that stability entirely

## Estate Layering Decisions

- Basement is a real service-maintenance layer with normal estate lighting
  infrastructure
- Chapel is not a sub-basement room
- Deep late-game below-ground spaces are `wine_cellar` and `family_crypt`
- Adult route ends in attic
- Elder route ends in crypt
- Child route ends in a sealed hidden room discovered through attic clues

## Creative Direction

- Ashworth Manor is procedural-first and model-assisted
- Architecture should not be ceded to imported room meshes
- Textures and material families should do more of the visual work
- Lighting must always feel sourced

## Current Known Misalignments

- Many room docs and declarations still reference the old weave
- Late-game route divergence is not yet implemented around the new
  `Adult / Elder / Child` structure
- Opening packet/valise flow now exists in runtime, declarations, and focused
  tests
- The forecourt now physically reveals locked service-side and garden-side gates
- Renderer-backed opening-journey captures exist for the current gate/drive/
  forecourt sequence
- Dark-house entry is now real in runtime: the front door is keyed, the foyer
  no longer auto-lights, and the first route reaches the parlor before warmth is
  reclaimed
- The first warmth beat now lives in the parlor hearth and starts
  `current_light_tool = firebrand`
- The first Elizabeth seizure now lives at the kitchen service hatch: once the
  player carries the firebrand, the hatch tap triggers Elizabeth's laugh,
  consumes the brand, and forces the drop into the dark storage basement
- The next focused autonomous batch is `docs/batches/service-basement-midgame-spine.md`
  and covers the whole turn from basement survival to gas restoration and the
  walking-stick phase
- The next downstream bespoke-route batch is
  `docs/batches/adult-route-attic-resolution.md` and covers the first canonical
  full storyline from midgame handoff through attic music-box resolution
- The next downstream route batch after `Adult` is
  `docs/batches/elder-route-crypt-resolution.md` and covers the second
  canonical full storyline from attic rupture through wine-cellar/crypt
  descent and elder music-box resolution
- The next downstream route batch after `Elder` is
  `docs/batches/child-route-hidden-room-resolution.md` and covers the third
  canonical full storyline from attic clue escalation through hidden-room
  discovery and child music-box resolution
- The post-route integration batch is
  `docs/batches/final-integration-and-acceptance.md` and covers winding-key /
  music-box unification, critical-path legacy-weave migration, automated and
  renderer-backed acceptance rebuild, and final production freeze
- The final post-freeze closeout batch is
  `docs/batches/archive-and-handoff-hygiene.md` and covers archive labeling for
  retained weave-era docs, canonical source-map tightening, and contributor
  handoff hygiene after acceptance
- The standing post-completion maintenance batch is
  `docs/batches/post-freeze-maintenance-and-regression-triage.md` and covers
  bounded regressions, visual/playthrough drift, and checkpoint truth-keeping
  after the repo is otherwise considered complete
- The downstream external-validation batch is
  `docs/batches/release-candidate-and-device-validation.md` and covers Android
  export readiness, packaged smoke/critical-path validation, and release-candidate
  evidence gathering using the existing Maestro/export surfaces
- The new authoritative batch is
  `docs/batches/ashworth-master-task-graph.md`, which contains the whole task
  graph in one place and should be used as the primary execution contract going
  forward
- Foyer chandelier auto-response exists only for the temporary sovereign/elder
  compatibility path; standard first route keeps the hall dark
- Tool progression and light grammar are not yet fully encoded beyond the first
  firebrand turn and the forced service descent into the basement

## Acceptance Notes

- High-level docs now define the canonical route program
- Runtime route progression now enforces `Adult -> Elder -> Child`
- `macro_thread` remains only as temporary compatibility state derived from
  `elizabeth_route`
- Canonical top-level docs now begin with `docs/GAME_BIBLE.md`, then
  `PLAYER_PREMISE`, `ELIZABETH_ROUTE_PROGRAM`, `NARRATIVE`, and `MASTER_SCRIPT`
- Room docs and declaration text should be treated as partially stale until
  migrated
- Required verification lanes still include:
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
