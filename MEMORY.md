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
- `docs/GAME_BIBLE.md` is now the single canonical authority for the shipped
  game. The other narrative docs (`PLAYER_PREMISE`, `ELIZABETH_ROUTE_PROGRAM`,
  `NARRATIVE`, `MASTER_SCRIPT`) are focused supplements that defer to it.
- `docs/SUBSTRATE_FOUNDATION.md` is now the substrate authority for the shared
  physical language of the game.
- `docs/batches/hard-substrate-freeze.md` is now the active execution contract
  while the shared substrate is being rebuilt and reapplied.
- `docs/batches/ashworth-master-task-graph.md` remains the whole-game scope
  contract and supersedes the fragmented batch chain as the main ship-scope
  surface.
- `docs/batches/ralph-remaining-stories-batch.md` is the active execution
  contract for the unfinished PRD surface after the recovered Ralph tranche.
- `docs/batches/ralph-final-remaining-stories.md` is now the active execution
  contract for the real open finish tranche (`US-020` through `US-027`).
  It now records `US-020` through `US-025` as complete, with `US-026` and
  `US-027` blocked on downstream Android/device prerequisites.

## Canonical Substrate Decisions

- The current story-complete build is provisional until the substrate sweep is
  complete.
- Primary architecture, walls, ceilings, stairs, ladders, gates, roads,
  hedges, boundary walls, terrain, water, glass, and sky must come from shared
  builders, shaders, and factories.
- Imported models are reserved for discrete props and hero objects.
- PBRs, HDRIs, heightmaps, atlases, and decals are substrate inputs, not
  substitutes for the substrate.
- Declarations remain the source of truth. Substrate adoption is
  declaration-facing, not scene-authoring drift.
- Operationally, use `tree` and curated inventories for substrate audits rather
  than broad repeated searches.
- Stable substrate primitive families are:
  - `surface`
  - `architecture`
  - `foliage`
  - `terrain_path`
  - `liquid_glass_sky`
  - `prop`
- Stable substrate mount families are:
  - `wall`
  - `floor`
  - `ceiling`
  - `threshold`
  - `gate_leaf`
  - `table`
  - `shelf`
  - `sill`
  - `mantel`
  - `path_edge`
  - `hedge_terminator`
  - `water_edge`
  - `facade_anchor`
- The initial region/environment substrate matrix is:
  - `grounds_twilight`
  - `forecourt_lamplit`
  - `ground_floor_warmth`
  - `upper_floor_moonlit`
  - `attic_dust_lantern`
  - `basement_bad_air`
  - `deep_basement_service`
  - `greenhouse_gaslit`
  - `garden_mist`
  - `crypt_candle`
- Shared fixture wrappers should resolve repeated materials through
  `shared_recipe_applicator.gd` and recipe ids, not embedded
  `StandardMaterial3D` stacks.
- The greenhouse shell/lantern/lily fixtures, parlor tea service, and chapel
  font states are now explicit regression examples for that rule and are
  covered by declaration validation.
- Shared builder fallbacks for stairs, ladders, windows, and portal shadow
  fills now resolve through explicit recipe ids (`fallback_wood`,
  `fallback_metal`, `shadow_void`) instead of local `StandardMaterial3D.new()`
  snippets in builder files.
- Envelope and threshold builders now default in recipe-id space too:
  floors, ceilings, walls, stairs, doors, gates, and windows all carry
  explicit shared recipe defaults instead of relying on raw texture-path
  defaults.
- Trapdoors now follow the same rule: the hatch builder defaults to shared oak
  recipe ids and no longer treats legacy `frame_texture` / `door_texture` as
  the primary surface contract.
- The declaration suite now has direct builder-default assertions proving those
  recipe-first defaults and proving recipe ids do not fall through the
  door/window model-selection heuristics.
- Door and window runtime assembly now records legacy model hints separately
  from resolved surface recipes, so recipe ownership and compatibility mesh
  selection are no longer the same implicit channel.
- Builder-level compatibility parsing no longer accepts old texture-shaped
  strings like `wall*_texture` or `door_texture_##.png`.
- Ordinary `DoorBuilder` and `WindowBuilder` runtime paths are now procedural
  substrate primitives; imported frame/panel/window meshes are no longer part
  of the common builder contract.
- `RoomAssembler` no longer hand-builds local materials for procedural moon or
  world-label props; those runtime visuals now route through
  `EstateMaterialKit`.
- `RoomAssembler` now also intercepts declaration-authored
  `window_clean.glb` / `window_ray.glb` props and replaces them with shared
  procedural window / glow-plane visuals at assembly time.
- `RoomAssembler` now also intercepts declaration-authored `stairs0.glb`,
  `stairbanister.glb`, and `banisterbase.glb` props and replaces them with
  procedural stair / rail / newel geometry during assembly.
- Common windows no longer need per-room compatibility hints at all:
  `WindowBuilder` now emits native procedural frame geometry directly, and the
  room-side `legacy_window_model_hint` field has now been removed from the
  schema.
- Authored `type = "door"` connections no longer carry compatibility
  panel/frame hints at all. The shared door builder’s native default panel path
  now owns that case end to end.
- Authored declaration data now mirrors active compatibility selectors into
  explicit hint fields in `world.tres` and windowed room declarations, and the
  declaration suite now enforces that.
- Interior envelope surfaces no longer depend on room texture fields at all,
  and the old room-level `wall_texture`, `floor_texture`, and
  `ceiling_texture` fields have now been removed from the declaration schema.
  Ordinary windows now rely directly on the shared builder default mesh path
  instead of carrying room-side compatibility metadata.
- Threshold compatibility no longer depends on connection texture fields at
  all, and the old connection-level `door_texture` / `frame_texture` fields
  have now been removed from the declaration schema. Compatibility threshold
  mesh selection now lives only in explicit builder-call inputs where targeted
  compatibility testing still needs it.
- `DoorBuilder` now matches that rule exactly: only explicit legacy hint fields
  can drive threshold mesh compatibility.
- The old procedural door scripts are no longer a substrate exception:
  `door_single.gd` and `door_double.gd` now default to shared recipe refs, with
  raw `Texture2D` inputs retained only as compatibility fallback, and that
  compatibility path now resolves through `EstateMaterialKit` instead of local
  `StandardMaterial3D.new()` snippets. Those compatibility inputs are now
  explicitly named `legacy_door_texture` / `legacy_frame_texture`.
- The remaining shared grounds-side glow/void scripts are no longer substrate
  exceptions either: front door, entry portico, mansion facade, outward road,
  and starfield now resolve shadow/glow/star materials through
  `EstateMaterialKit` helpers instead of local `StandardMaterial3D.new()`
  blocks.
- Declaration validation now guards both recipe-wrapper scenes and those
  grounds scripts, plus the procedural door scripts, against regressing back to
  local `StandardMaterial3D` construction.
- That guard is now generalized: outside `estate_material_kit.gd` and
  `pbr_texture_kit.gd`, local `StandardMaterial3D.new()` calls in
  `builders/`, `scenes/shared/`, and `scripts/procedural/` are treated as
  substrate regressions.

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
- The target look is Myst-like Victorian: brassy, woody, lamplit, mist-forward,
  materially grounded
- Existing `psx_*` systems are compatibility/compositor shims, not the target
  look

## Current Known Misalignments

- Many room docs and declarations still reference the old weave
- Opening packet/valise flow now exists in runtime, declarations, and focused
  tests
- The forecourt now physically reveals locked service-side and garden-side gates
- Renderer-backed opening-journey captures exist for the current gate/drive/
  forecourt sequence
- The gate threshold has improved materially:
  - the sign and valise now read as one social/arrival composition
  - the valise is visibly present beneath the sign in the opening overview
  - the opening sign no longer reads like unrelated slab props
  - the focused front-gate probe lane now includes dedicated outward-road, sky,
    and valise evidence frames
  - the valise is now visibly present in the sign-side close composition after
    being scaled up and pulled slightly off the wall
- The remaining opening visual weakness is the drive hedge language:
  - the hedge corridors are now structurally continuous, but the material
    language still reads too synthetic and under-detailed
  - the hedge walls now read as enclosing walls rather than short repeated
    hedge stubs, but still do not yet read as finished clipped topiary
  - the opening capture contract is now good enough to show that honestly
- The upper-drive / front-steps mansion pull is materially improved:
  - the end of the drive now reads as a procedural entry portico rather than a
    blank placeholder wall
  - the front-steps commit frame now communicates a real threshold silhouette
    instead of the earlier wallpaper-front failure
  - the hedge face treatment has been simplified away from the worst dotted
    relief pass, though it still needs richer material craft
- The opening entrance now has a readable closed front door again:
  - the old edge-on imported door prop has been replaced with a shared
    procedural front-door scene
  - both `drive_upper` and `front_steps` now read as leading to an actual shut
    entrance rather than a lit blank plane
- The forecourt side-wall logic is closer to the intended estate layout:
  - procedural brick boundary-wall sections now sit between the side gates and
    the house
  - the forecourt is still sparse, but it is less like an empty platform
- The outward-road world is materially stronger than before:
  - village houses and terraces are now pulled much closer to the carriage road
  - the gate-side probes now read as a real roadside settlement rather than an
    abstract strip of dark props
  - but the village still remains too schematic and blocky to pass final art
    review
- The hedge corridors are structurally correct but still not finished:
  - they now behave as continuous clipped walls and the worst banding is
    reduced
  - but they still read too smooth and synthetic to count as convincing
    Victorian topiary
- The sign/valise threshold artifact is materially reduced in the main opening
  views, and the opening probe lane now includes left/right village-side
  captures instead of relying on one outward-road frame
- The outward-road capture is no longer a void/portal failure:
  - there is now visible roadside architecture in the village-side probes
  - but the exterior still reads too schematic and too stage-like to pass final
    visual acceptance
- Grounds sky is no longer blocked on star readability:
  - stars now read in the opening overview and dedicated sky probe
  - the remaining sky work is nuance and broader visual richness, not absence
- Dark-house entry is now real in runtime: the front door is keyed, the foyer
  no longer auto-lights, and the first route reaches the parlor before warmth is
  reclaimed
- The first warmth beat now lives in the parlor hearth and starts
  `current_light_tool = firebrand`
- The first Elizabeth seizure now lives at the kitchen service hatch: once the
  player carries the firebrand, the hatch tap triggers Elizabeth's laugh,
  consumes the brand, and forces the drop into the dark storage basement
### Canonical Execution Contracts

- `docs/SUBSTRATE_FOUNDATION.md` is the **substrate authority**
- `docs/batches/hard-substrate-freeze.md` is the **active execution contract**
- `docs/batches/ashworth-master-task-graph.md` is the **whole-game scope
  contract**

### Historical Batch Detail (support only — superseded by master task graph)

The individual batch files below are retained as implementation-level detail.
They were written before the master task graph unified execution into one
surface. Refer to them for phase-level context, but do not treat them as
independent execution drivers:

- `docs/batches/service-basement-midgame-spine.md` — shared spine: basement
  survival → gas restoration → walking-stick phase
- `docs/batches/adult-route-attic-resolution.md` — first route: midgame →
  attic music-box resolution
- `docs/batches/elder-route-crypt-resolution.md` — second route: attic
  rupture → wine-cellar/crypt music-box resolution
- `docs/batches/child-route-hidden-room-resolution.md` — third route: attic
  clue escalation → hidden-room music-box resolution
- `docs/batches/final-integration-and-acceptance.md` — post-route: winding-key
  unification, weave migration, acceptance rebuild
- `docs/batches/archive-and-handoff-hygiene.md` — post-freeze: archive
  labeling, source-map tightening, handoff hygiene
- `docs/batches/post-freeze-maintenance-and-regression-triage.md` —
  standing: regression triage and checkpoint truth-keeping
- `docs/batches/release-candidate-and-device-validation.md` — downstream:
  Android export, Maestro validation, release-candidate evidence
- Foyer chandelier auto-response exists only for the temporary sovereign/elder
  compatibility path; standard first route keeps the hall dark
- Critical-path route behavior is now implemented through `Adult`, `Elder`, and
  `Child`, but some declaration keys and tests still express those routes via
  legacy compatibility thread names

## Acceptance Notes

- High-level docs now define the canonical route program
- `docs/SUBSTRATE_FOUNDATION.md` now defines the canonical substrate rules
- `docs/batches/hard-substrate-freeze.md` is the active implementation batch
  until the substrate sweep is complete
- Runtime route progression now enforces `Adult -> Elder -> Child`
- `macro_thread` remains only as temporary compatibility state derived from
  `elizabeth_route`
- `docs/GAME_BIBLE.md` is the single canonical authority; the other narrative
  docs are focused supplements that defer to it on overlap
- Room docs and declaration text should be treated as partially stale until
  migrated
- Required verification lanes still include:
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_route_progression.gd`
  - `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`
- `US-020` through `US-025` are now landed:
  - `US-020` late critical-path lighting/material polish and readable renderer
    evidence
  - `US-021` full repo-local freeze rerun
  - `US-022` archived weave-era design docs and tightened source-map guidance
  - `US-023` maintenance baseline and regression register
  - `US-024` Android/export prerequisite audit
  - `US-025` debug-gated `MaestroHelper` wiring
- Downstream Android state is now explicit:
  - debug export succeeds when `ANDROID_HOME`, `ANDROID_SDK_ROOT`, and Android
    build-tools are on `PATH`
  - debug APK installs non-incrementally on `ashworth_test` and launches via
    direct `am start`
  - `maestro test test/maestro/smoke_test.yaml` passes on `ashworth_test`
  - helper-backed `test/maestro/full_playthrough.yaml` is authored but still
    blocked by semantic label pickup on the current AVD
  - helper labels and the full-playthrough flow have now been tightened toward
    short numbered OCR-friendly text (`01 DISMISS`, `02 OPEN VALISE`, etc.),
    but the critical-path Maestro lane is not yet re-proven on device
  - release export is blocked by missing release keystore credentials
- On `codex/ralph-integration-harvest`, the shared Ralph tranche plus the repaired
  full-playthrough lane now pass headless:
  - `test/generated/test_declarations.gd`
  - `test/e2e/test_room_specs.gd`
  - `test/e2e/test_declared_interactions.gd`
  - `test/e2e/test_route_progression.gd`
  - `test/e2e/test_full_playthrough.gd`
- The current local debug opening/polish pass is also green on the active
  branch:
  - `test/generated/test_declarations.gd`
  - `test/e2e/test_room_walkthrough.gd`
  - `test/e2e/test_full_playthrough.gd`
  - `test/e2e/test_drive_visual.gd`
  - `test/e2e/test_opening_journey.gd`
- Remaining integrated PRD scope after the landed `Elder` and `Child` routes
  begins at `US-015`: winding-key/music-box unification, legacy weave
  migration, full acceptance rebuild, archive/handoff, maintenance, and
  Android/release validation.
- `US-011` is now landed at a first verified checkpoint:
  - canonical elder clue map recorded in
    `docs/checkpoints/elder-route-clue-topology.md`
  - elder-biased declaration text landed in `foyer`, `upper_hallway`,
    `wine_cellar`, and `family_crypt`
  - `test/e2e/test_declared_interactions.gd` now asserts elder route bias in
    shared, upper-house, cellar, and crypt surfaces
  - renderer-backed `test/e2e/test_room_walkthrough.gd` reran successfully with
    fresh captures for the touched rooms
- Follow-on visual note for later acceptance/polish:
  - some close-up walkthrough captures in dark burial-side spaces
    (`wine_cellar_wine_footprints`, `family_crypt_crypt_graves`) are readable
    enough for a checkpoint but remain poor showcase frames and should be
    revisited during `US-019` / `US-020`
- `US-012` is now landed at a verified runtime checkpoint:
  - elder route late-game now resolves through attic redirect -> wine cellar
    bypass -> family crypt gate latch -> crypt music box
  - `new_game()` now resets room-event runtime state so repeated in-process
    route tests can re-fire one-shot rupture logic honestly
  - `test/e2e/test_declared_interactions.gd` now covers attic redirect, cellar
    bypass, crypt latch, and crypt music-box resolution
  - `test/e2e/test_full_playthrough.gd` now drives a full Elder completion and
    ending trigger
  - checkpoint recorded in `docs/checkpoints/US-012-elder-crypt-resolution.md`
- Follow-on visual note for later acceptance/polish:
  - the generic burial-side entry captures (`wine_cellar_entry.png`,
    `family_crypt_entry.png`) are still poor showcase images despite the
    walkthrough lane passing and should be revisited during `US-019` / `US-020`
- Local debug audit update:
  - `family_crypt` no longer fails first-person framing in
    `test/e2e/test_room_walkthrough.gd`
- `US-013` and `US-014` are now landed at a verified Child-route checkpoint:
  - canonical Child clue map recorded in
    `docs/checkpoints/child-route-clue-topology.md`
  - attic false-answer chain, sealed seam reveal, and sealed-room finale are
    implemented in declarations/runtime
  - `hidden_chamber.tres` now reads as erased domestic truth rather than occult
    residue
  - `test/e2e/test_declared_interactions.gd` now asserts Child route bias,
    attic redirect, seam reveal, and sealed-room music-box resolution
  - `test/e2e/test_full_playthrough.gd` now drives a full Child completion and
    ending trigger
  - renderer-backed `test/e2e/test_opening_journey.gd` and
    `test/e2e/test_room_walkthrough.gd` reran successfully with updated late
    route manifests
- `US-015` is now landed at a verified route-unification checkpoint:
  - `GameManager` now exposes `set_route_context()` and explicit route mode via
    `get_route_mode()`
  - main route-order and full-playthrough tests now drive `adult / elder /
    child` directly instead of passing legacy thread ids through their primary
    harness
  - the invariant brass winding key / music-box arc remains the solve object
    system across all three route completions
- `US-016` is now the active story:
  - critical-path room docs have been migrated off weave-era labels and stale
    occult hidden-room framing
  - basement, cellar, crypt, attic, and sealed-room docs now describe the
    shipped shared spine and late-route behavior
- `US-017` is now landed at a verified declaration-migration checkpoint:
  - critical-path declarations now carry route-key aliases (`child`, `adult`,
    `elder`) alongside compatibility thread keys
  - late-route attic, cellar, crypt, and foyer declarations now speak route
    identity directly in the canonical source-of-truth layer
  - remaining weave-era declaration surfaces are compatibility-only shims in
    `declarations/threads/*.tres`, `macro_thread` state, and the legacy
    alternate endings
- `US-018` is now landed at a verified automated-coverage checkpoint:
  - `test_full_playthrough.gd` drives the shipped `Adult -> Elder -> Child`
    program directly and distinguishes all three route finales
  - `test_route_progression.gd` proves canonical progression plus explicit
    post-third-run replay mode
  - gdUnit4 is now a real repo-local lane through
    `test/unit/route_program_test.gd`
  - the working gdUnit CLI contract is
    `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode`
  - reports are emitted under `reports/report_*/`
- `US-019` is now the active story: rebuild renderer-backed acceptance and
  capture evidence around the shipped opening, basement, attic, crypt, and
  hidden-room flows
- `US-019` is now landed at a verified renderer-acceptance checkpoint:
  - `test_opening_journey.gd` and `test_room_walkthrough.gd` both pass in
    renderer mode
  - walkthrough milestone manifests now explicitly cover basement, boiler room,
    wine cellar, family crypt, attic storage, and hidden-room finale surfaces
  - route-finale interactables are now promoted into the milestone set:
    `attic_storage_attic_music_box`, `family_crypt_crypt_music_box`, and
    `hidden_chamber_child_music_box`
  - the evidence surface is now organized, but several late critical captures
    still read as materially underlit or placeholder-heavy; this is now the
    real `US-020` polish front
- `US-020` is now the active story: polish the late critical-path materials,
  silhouettes, and sourced lighting so the rebuilt evidence reads as finished
- Local priority has been explicitly redirected back to repo-local debug
  verification before any further Android/export push:
  - comprehensive local suites and renderer-backed debug journeys were rerun on
    2026-04-07
  - current checkpoint:
    `docs/checkpoints/local-debug-audit-2026-04-07.md`
  - local debug is executable and broadly green in logic, but not visually
    complete
  - confirmed remaining blockers are local-experience defects, especially:
    opening hedge craft, foyer readability, storage-basement / boiler-room
    readability, and crypt legibility
- Opening debug polish continued on 2026-04-08:
  - `estate_hedgerow.gd` was simplified back toward continuous clipped mass
    after an over-articulated side-relief pass produced obvious panel artifacts
  - `estate_front_door.gd` and `estate_entry_portico.gd` were strengthened with
    a lighter architectural surround so the commitment frame reads more like a
    real threshold
  - `PBRTextureKit` now supports explicit opacity-map composition for
    alpha-scissor materials, and `EstateMaterialKit` now wires the hedge atlas
    opacity path directly
  - current honest state:
    the hedge corridor is structurally right again and the entrance is clearer,
    but both still need more surface richness before they count as final art
- Opening debug polish continued further on 2026-04-08:
  - `estate_mansion_facade.gd` now carries stronger plinth/projection/panel
    articulation so the drive pull reads more like a real house front
  - `estate_forecourt_steps.gd` and `estate_carriage_road.gd` gained more
    relief and wear detail, including removal of a failed bright gravel-dot
    experiment from the drive surface
  - current honest state:
    the facade is materially better and the road is less broken, but the
    opening still needs richer hedge craft and more final-surface credibility
- Opening debug polish continued again on 2026-04-08:
  - shared procedural gate surfaces were expanded:
    `estate_gate_post.gd`, `estate_fence_run.gd`, and a strengthened
    `estate_iron_gate.gd` now back the front gate and forecourt side gates
  - the same gate-post system was also applied to the crypt/garden gate-column
    surfaces so the gate vocabulary is starting to converge repo-wide
  - `estate_hedgerow.gd` regained controlled face detail through shared frond
    planes, and `estate_boundary_wall.gd` now has more coping/pier relief
  - verification stayed green across both opening and broader debug lanes:
    declarations, front-gate probes, opening journey, room walkthrough, and
    full playthrough all passed
  - current honest state:
    the opening is more coherent and more procedurally authored than before,
    but the remaining blockers are still hedge surface credibility, road
    richness, outward-road village craft, and final facade detail
- Opening debug polish continued further on 2026-04-08:
  - exterior source materials were moved onto selected repo-local PBR sets via
    `EstateMaterialKit`:
    hedge mass, carriage road, verge earth, and boundary brick now come from
    copied photoreal material sources under `assets/shared/pbr/`
  - the grounds environment was redirected away from the HDRI blend path:
    `grounds.tres` now uses the authored generated sky directly, removing the
    repeated HDR header warnings from the opening visual lanes
  - exterior ambient/moon wash was cut substantially across `front_gate`,
    `drive_lower`, `drive_upper`, and `front_steps`, which made the gas lamps,
    windows, and doorway pull read more like real light anchors
  - `estate_hedgerow.gd` now has much stronger clipped face-bay/pilaster
    articulation; the drive corridor finally reads as a deliberate topiary wall
    system in renderer probes instead of a pure green slab
  - `front_gate.tres` now includes explicit village-lamp spill lights aligned
    to the outward-road lamp props so the outward road has actual warm spatial
    anchors
  - current honest state:
    the opening is materially darker, more coherent, and more authored than
    before, but still not final; remaining blockers are the hedge rhythm being
    too mechanical, the road remaining too plain, the outward-road village
    still too schematic, and the authored dusk band still too subtle in the
    outward-looking captures
- Opening debug polish continued again on 2026-04-08:
  - `drive_lower.tres` and `drive_upper.tres` now use one continuous hedge-row
    instance per side instead of several overlapping oversized hedge props;
    this removed the worst declaration-level seam rhythm from the drive
  - `estate_hedgerow.gd` replaced the hard stamped pilaster language with
    softer clipped face relief so the hedge-side probe no longer shows the
    earlier vertical panel artifacts
  - `estate_outward_road.gd` now gives the nearest village houses pitched roofs
    instead of flat lids, which makes the outward-road world read more like a
    settlement and less like pure placeholder blocks
  - `front_gate_menu_sign.gd` now presents the front-gate controls as one
    estate directory board with inset brass plates rather than three hanging
    placards
  - `grounds.tres` plus `psx_bridge.gd` were retuned so the moon is smaller and
    the twilight band is carried more by the generated horizon rather than by
    raw ambient wash
  - verification stayed green:
    declarations, front-gate visual probes, and drive visual probes all passed
  - current honest state:
    the opening is materially more truthful than before, but it is still not
    final; remaining blockers are hedge-surface credibility, the village still
    reading too schematic, the twilight still not quite subtle/right, and the
    drive road still reading too plain in the forward frame
- Opening debug polish continued further on 2026-04-08:
  - `front_gate.tres` had two live outward-road `floor3.glb` slab leftovers
    removed from the active prop list; these were the source of the large pale
    rectangles in the outward-road visual probes
  - `estate_outward_road.gd` now uses darker, warmer village masonry and less
    glaring window energy, and the roadside poplars now use taller two-part
    crowns instead of the earlier three-ball stacked silhouette
  - `drive_lower.tres`, `drive_upper.tres`, and `front_steps.tres` now use
    earth for the base room floor again so the carriage-road prop is not
    fighting an all-gravel room floor
  - `estate_carriage_road.gd` was reauthored toward a narrower twin-track lane
    and the drive probe still passes, but the road remains only partially
    solved visually
  - important negative result:
    two additional hedge experiments in `estate_hedgerow.gd` were tried and
    explicitly backed out after renderer review because they made the drive
    read more artificial, not less; current hedge state is intentionally the
    smoother baseline, not the failed spotted/body-chain variants
  - verification stayed green:
    declarations, front-gate visual probes, drive visual probes, and the full
    opening journey all passed
  - current honest state:
    the outward-road artifact is fixed and the village-side read is stronger,
    but the hedge is still the weakest opening surface and the threshold still
    needs more final craft before it counts as production-finished
- Opening debug polish continued further on 2026-04-08:
  - `drive_lower.tres` and `drive_upper.tres` now use multiple smaller hedge
    runs per side instead of a single stretched hedge slab; `estate_hedgerow.gd`
    was also loosened so shorter authored runs are actually possible
  - two hedge-surface experiments were tried and explicitly rejected after
    probe review: a clipped face-panel pass that read like paneled walling, and
    a face-card veneer that read like pasted dark rectangles near the crown
  - `grounds.tres` and `psx_bridge.gd` were retuned around the existing
    `grounds_kloppenheim_07.png` HDRI so the grounds sky is cooler, stars are
    legible, and the moon now reads clearly in the gate-sky probe instead of
    being swallowed by the old muddy red sky treatment
  - verification stayed green:
    declarations, front-gate visual probes, drive visual probes, and the full
    opening journey all passed
  - current honest state:
    the drive hedge layout is less wrong and the sky is materially better, but
    the hedge surface is still too smooth/synthetic, the outward-road village
    is still too schematic, the twilight band remains too faint, and the drive
    road still needs richer final craft
- Opening debug polish continued further on 2026-04-08:
  - `estate_carriage_road.gd` now has a clearer lane/track material split plus
    additional gravel patch breakup, which makes the drive probes read more
    like worn carriage lanes and less like one flat dark floor strip
  - `estate_outward_road.gd` now pushes the village road deeper with an extra
    horizon road segment, more lane lamps, added far terraces, and layered fog
    banks so the outward-road probe has more actual depth than the previous
    flatter version
  - verification stayed green:
    declarations, drive visual probes, front-gate visual probes, and the full
    opening journey all passed
  - current honest state:
    the drive road and outward-road depth are both better than before, but the
    hedge surface is still the weakest opening material, the final foggy dusk
    terminus is still too faint, and the village still remains somewhat
    schematic at distance
- Opening debug polish continued further on 2026-04-08:
  - `estate_material_kit.gd` and `estate_hedgerow.gd` were reworked again so
    the drive hedges use dense foliage mass and broader clipped shaping instead
    of the earlier leaf-sheet wall look; the hedge now reads much more like a
    dark clipped wall and much less like assembled green masonry
  - the brightest hedge shoulder/crown emphasis was pulled back after renderer
    review because it was creating a false plaster-cornice read at the top of
    the hedge corridor
  - `test_front_gate_visual.gd` now captures dedicated sign and valise detail
    probes, which makes the repo’s gate review surface materially more useful
    than the older context-only probe set
  - an attempted sign-cluster layout shift in `front_gate.tres` was tried,
    proved worse in renderer review, and was explicitly reverted the same turn
    rather than left behind as silent regression
  - `grounds.tres` and `psx_bridge.gd` were both retuned again to widen the
    dusk band and soften the moon, but the gain in the gate sky probes was only
    marginal; the sky is still a live blocker
  - verification stayed green:
    declarations, drive visual probes, front-gate visual probes, and the full
    opening journey all passed
  - current honest state:
    the hedge corridor is materially better than before and the gate evidence
    surface is stronger, but the front-gate sky still reads too hard
    black-purple, the outward-road village is still too schematic, and the
    contextual sign/valise composition still is not yet final
- Opening debug polish continued further on 2026-04-08:
  - `drive_lower.tres` and `drive_upper.tres` were simplified back toward
    continuous hedge runs per side after the segmented hedge cadence started to
    read more like modular walling than topiary; the drive corridor now reads
    as longer clipped hedge walls again
  - `estate_hedgerow.gd` was restored away from the failed embossed/paneled
    hedge experiments; the current hedge builder is back on the cleaner
    clipped-mass profile with darker foliage tones
  - `grounds.tres` and `psx_bridge.gd` were pushed again to isolate the sky
    issue, including temporarily removing the HDRI from the grounds
    environment and forcing a cooler authored twilight gradient
  - verification stayed green:
    declarations, drive visual probes, and front-gate visual probes all passed
  - current honest state:
    the drive corridor is structurally closer because it no longer reads like
    segmented green paneling, but the hedge face is still too smooth in close
    probes, the front-gate sky still reads as a hard maroon-black dome rather
    than convincing twilight, the outward-road village is still too schematic,
    and the opening composition is still not final
- Opening debug polish continued further on 2026-04-08:
  - photoreal PBR sources from `/Volumes/home/assets/2DPhotorealistic` were
    brought into the repo for the shared opening pass:
    `hedge_mass_grass005_*` now backs the hedge wall mass and
    `carriage_gravel042_*` now backs the carriage drive
  - `estate_material_kit.gd`, `estate_carriage_road.gd`, and
    `estate_hedgerow.gd` were retuned around those maps so the opening uses
    stronger normals, clearer wheel-lane logic, and denser clipped-wall
    foliage instead of depending on the flatter previous material set
  - `grounds.tres`, `estate_starfield.gd`, `room_assembler.gd`, and
    `front_gate.tres` were retuned together so the gate sky now has a smaller
    moon, clearer stars, and a less blunt pasted-disc read than the previous
    sky pass
  - `estate_outward_road.gd` was also pushed further: village frontage was
    pulled closer to the road, window glow and lamp spill were strengthened,
    and the outward road now reads more like a nearby lamplit village edge
    than a sparse dark silhouette
  - verification stayed green:
    declarations, front-gate visual probes, drive visual probes, and the full
    opening journey all passed
  - current honest state:
    the sky and outward-road read are both materially better, but the close
    hedge face is still too smooth/synthetic, the drive surface still needs
    richer authored craft, and the opening does not yet count as final polish
- Opening debug polish continued further on 2026-04-08:
  - the next hedge pass found and corrected a real implementation issue in
    `estate_hedgerow.gd`: much of the earlier face relief had been sitting
    inside the hedge volume, which is why the close drive probe was still
    reading mostly as a flat wall
  - `estate_material_kit.gd` and `estate_hedgerow.gd` were retuned again so
    the hedge wall uses stronger normal response, larger visible foliage scale,
    and outward-facing sculpting instead of internal invisible relief
  - the first outward-relief version overcorrected into obvious bead/button
    artifacts; a follow-up pass softened the hedge cross-section and reduced
    those artifacts so the wall now reads less like moulded masonry trim
  - focused verification stayed green:
    front-gate visual probes and drive visual probes both rerendered cleanly
  - current honest state:
    the hedge close-up is better than both the earlier flat slab and the later
    buttoned version, but it still is not fully convincing clipped Victorian
    topiary; the drive floor still needs richer craft, and the opening remains
    on the polish path rather than at final acceptance
- Substrate freeze continued on 2026-04-08:
  - environment-owned surface grammar was extended beyond floor/wall/ceiling
    into `threshold`, `door`, `gate_leaf`, and `window` roles via
    `EnvironmentDeclaration.surface_recipe_overrides`
  - `RoomAssembler` now resolves and records those roles on the assembled room
    root before builder fallback, so threshold surfaces are visible in the same
    runtime metadata surface as floor/wall/ceiling
  - `ConnectionAssembly`, `DoorBuilder`, and `WindowBuilder` now consume the
    resolved threshold grammar directly; legacy connection and wall texture
    strings are retained only as compatibility/model-selection fallbacks
  - `TrapdoorBuilder` now consumes the same `threshold` / `door` substrate
    grammar instead of staying on a separate raw-texture code path
  - `StairsBuilder` and `LadderBuilder` now consume environment-owned surface
    roles too; circulation thresholds are no longer the remaining hardcoded
    material holdouts in the shared builder stack
  - the environment matrix now declares threshold/door/window/gate policy for
    grounds, forecourt, all main interior floors, garden, greenhouse, and crypt
  - the environment matrix now also declares circulation roles where needed:
    `stair_tread`, `stair_structure`, `stair_rail`, `ladder_rail`, and
    `ladder_rung`
  - substrate preset `approved_builders` now explicitly includes the
    circulation builders where those roles are declared, and the declaration
    suite enforces that coupling so the preset matrix cannot silently drift
  - runtime proof:
    `front_gate` now reports `threshold=recipe:surface/brick_masonry`,
    `door=recipe:surface/oak_dark`, `gate_leaf=recipe:surface/wrought_iron`,
    and `window=recipe:surface/wrought_iron`
  - runtime proof:
    `foyer` now reports `threshold=recipe:surface/oak_header`,
    `door=recipe:surface/oak_dark`, and `window=recipe:surface/oak_dark`
  - authored `type = "door"` connections no longer carry compatibility mesh
    hints at all; ordinary thresholds now rely on the shared door builder’s
    native default geometry path unless a new exception is added deliberately
  - authored hidden-door declarations no longer serialize the default
    `secret_panel` presentation, `slide` mechanism, or default concealment
    mesh; `ConnectionAssembly` now owns those defaults cleanly at runtime
  - the declaration suite enforces that hidden-door cleanup by failing if
    authored hidden-door data carries those default values without a real
    override
  - the kitchen service hatch now omits the default trapdoor `lift`
    mechanism in authored data; `TrapdoorBuilder` owns that default and now
    records resolved presentation/mechanism metadata instead of raw strings
  - `DoorBuilder` now records resolved presentation/mechanism metadata too, so
    ordinary door/gate defaults live in the builder rather than in raw
    declaration strings
  - the front entrance still keeps its real `facade_door` presentation
    override, but no longer serializes the default `swing` mechanism in
    authored data
  - `DoorBuilder`, `TrapdoorBuilder`, `StairsBuilder`, and `LadderBuilder` now
    record resolved `mechanism_state` / `reveal_state` metadata instead of
    mirroring raw declaration defaults
  - that fixes the old mismatch where hidden-door area metadata could still
    report `idle` / `visible` even though the runtime treated the threshold as
    concealed
  - `Connection.mechanism_state` and `Connection.reveal_state` now default to
    empty strings in the schema instead of `idle` / `visible`
  - builder/runtime default policy now owns those states directly without the
    old “ignore the schema default” workaround logic
- the dead `Connection.visible_model` field is gone
- the old hidden-door `concealment_model` path is now gone from the schema too
- `ConnectionAssembly` now records a resolved concealment kind directly and
  owns the default hidden-door wall mask as native procedural geometry in the
  shared builder layer
- `RoomDeclaration.legacy_window_model_hint`,
  `Connection.legacy_frame_model_hint`, and
  `Connection.legacy_panel_model_hint` are now gone from the schema too
- ordinary windows and ordinary door/gate thresholds now rely on shared
  builder defaults directly; targeted mesh compatibility survives only as
  explicit builder-call input where tests still need it
- `StairsBuilder` no longer depends on `banisterbase.glb` in the default path;
  stair newels are now native procedural geometry too
  - runtime proof:
    `upper_hallway` now reports `stair_tread=recipe:surface/oak_dark`,
    `stair_structure=recipe:surface/oak_header`, and
    `stair_rail=recipe:surface/oak_dark`
  - runtime proof:
    `storage_basement` now reports `stair_tread=recipe:surface/oak_dark`,
    `stair_structure=recipe:surface/oak_dark`, `stair_rail=recipe:surface/wrought_iron`,
    `ladder_rail=recipe:surface/wrought_iron`, and
    `ladder_rung=recipe:surface/chain_iron`
  - verification stayed green:
    boot, declarations, environment probe, room specs, and full playthrough all
    passed after the threshold-builder adoption
  - the substrate contract is now room-aware rather than only environment-aware:
    declaration validation derives required builders from each room's actual
    runtime shape and outgoing connections, then verifies that the resolved
    substrate preset explicitly approves those builders
  - that room-aware gate immediately caught real preset drift:
    `ground_floor_warmth` was missing `trapdoor_builder`, and `garden_mist`
    was covering the interior chapel without approving `wall_builder` /
    `ceiling_builder`; both were corrected in the substrate preset layer
  - the material/shader substrate is now guarded too:
    `PBRTextureKit` exposes standardized slot introspection, recipe validation
    checks now walk the entire `EstateMaterialKit` library, and every declared
    slot asset is verified against the filesystem instead of being trusted by
    convention
  - the shared foliage shader path was strengthened rather than replaced:
    `estate_foliage_forward_plus.gdshader` now carries richer gust-driven sway
    controls and the foliage recipe path exposes those controls through
    `EstateMaterialKit`, so foliage remains a shader-driven substrate primitive
    instead of collapsing back into flat wall texturing
  - verification stayed green after the recipe/shader contract pass too:
    declarations, environment probe, and full playthrough all reran cleanly
  - mount-family governance is now explicit across region, environment, and
    substrate layers:
    `RoomAssembler` resolves and records `region_id` plus the intersected
    `allowed_mount_families` instead of trusting the environment layer alone
  - mounted payloads now fail closed at runtime:
    payloads targeting missing slots or slot families outside the resolved
    mount-family intersection are skipped with warnings rather than silently
    attaching into invalid host surfaces
  - declaration validation now enforces mount-family alignment:
    room environment mount families must be approved by both the resolved
    substrate preset and the room's region, mount slot ids must be unique, and
    mount payloads must target declared slots with a real scene/model source
  - that gate exposed and corrected more real matrix drift:
    `entrance_exterior`, `rear_estate`, and `carriage_house_isolate` region
    mount-family lists were broadened to match the actual room-specific
    environment presets layered on top of them
  - runtime proof now includes mount governance:
    the environment probe prints both `region` and the final resolved
    `mounts=` intersection for each sampled room
  - verification stayed green after the mount-family pass:
    declarations, environment probe, room specs, and full playthrough all
    reran cleanly
  - declared mount slots/payloads are now live in representative rooms instead
    of only being schema:
    `foyer`, `front_gate`, and `storage_basement` now mount actual payloads
    into declared host slots at runtime
  - mount payload route gating is now real rather than aspirational:
    `RoomAssembler` matches payload `route_modes` against active route ids
    (`adult`, `elder`, `child`) in addition to broader route-mode/thread state
  - `test/e2e/test_mount_payloads.gd` now proves:
    foyer table lamps and wall picture mount correctly, the front gate sign and
    gate lamp mount through facade anchors, basement sconces mount through wall
    slots, and the foyer portrait payload swaps between standard and elder
    variants by route
  - the shared material library now covers more than standard/PBR-style
    surfaces:
    `EstateMaterialKit` now supports `shader_material` recipes and explicitly
    owns shared `glass` and `liquid` families
  - shared glass/liquid recipes now include:
    `glass/window_glass`, `glass/facade_dark`, `glass/door_lamplit`,
    `glass/crystal_glass`, `glass/greenhouse_glass`, and
    `liquid/estate_pond_water` plus dedicated `liquid/*` variants for dining
    wine, chapel font water, kitchen bucket water, and parlor tea
  - shared builders are now consuming those recipes directly:
    `WindowBuilder`, `estate_front_door.gd`, `estate_entry_portico.gd`, and
    `estate_mansion_facade.gd` no longer rely on local ad hoc glass material
    snippets
  - a new generic shared-scene applicator now carries those recipes into the
    non-builder shared scene layer:
    `scenes/shared/shared_recipe_applicator.gd` maps recipe ids onto named
    mesh targets inside authored shared scenes
  - that applicator is now live across:
    greenhouse glazing, greenhouse hanging lantern glass, dining wine glasses,
    chapel baptismal font water states, kitchen bucket water states, parlor tea
    states, and the estate pond water wrappers
  - the old `resources/water/*` and `resources/glass/*` materials are now
    compatibility wrappers rather than the primary substrate path for those
    shared scenes
  - verification stayed green after the shared glass/liquid pass too:
    declarations, room specs, and full playthrough all reran cleanly after the
    generic shared-scene applicator pass too
