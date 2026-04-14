# Ralph Progress Log

This file tracks progress across iterations. Agents update this file
after each iteration and it's included in prompts for context.

## Active Hard Substrate Freeze

- The active execution contract is now
  `docs/batches/hard-substrate-freeze.md`.
- The substrate authority is now
  `docs/SUBSTRATE_FOUNDATION.md`.
- The whole-game ship-scope contract remains
  `docs/batches/ashworth-master-task-graph.md`.
- Current tranche status:
  - `SF-001` canonical substrate inventory and freeze contract — done
  - `SF-002` shared shader and material recipe library — in_progress
  - `SF-003` shared builder and factory library promotion — in_progress
  - `SF-004` declaration-facing mount and slot system — in_progress
  - `SF-005` environment and region preset library — done
  - `SF-006` grounds topology and exterior estate coverage — pending
  - `SF-007` whole-house interior substrate coverage — pending
  - `SF-008` route-state integration on top of the substrate — pending
  - `SF-009` visual QA and evidence rebuild — pending
  - `SF-010` whole-game sweep and rebaseline — pending

## 2026-04-13 - Grounds emissive and void materials moved onto shared kit helpers

## 2026-04-13 - Repeated interactable visuals moved onto explicit visual kinds

- Added declaration-facing visual substrate fields in
  `engine/declarations/interactable_decl.gd`:
  - `visual_kind`
  - `inactive_visual_kind`
  - `state_visual_kind_map`
- Added the shared repeated-fixture visual registry in
  `engine/interactable_visuals.gd`, covering:
  - kitchen bucket still/rippled
  - front-gate valise closed/open
  - greenhouse pot intact/disturbed
  - parlor tea set/disturbed
  - chapel font still/disturbed/searched
  - dining wine still/agitated
- Migrated the authored declaration side in:
  - `declarations/rooms/kitchen.tres`
  - `declarations/rooms/front_gate.tres`
  - `declarations/rooms/greenhouse.tres`
  - `declarations/rooms/parlor.tres`
  - `declarations/rooms/chapel.tres`
  - `declarations/rooms/dining_room.tres`
- Those repeated interactables now author `visual_kind` and
  `state_visual_kind_map` instead of direct shared `.tscn` scene paths in
  `scene_path` / `state_model_map`.
- Extended `test/generated/test_declarations.gd` with a new interactable visual
  contract that proves:
  - the repeated cases are present in authored room data
  - they use the expected visual kinds
  - they clear direct `scene_path`, `model`, and `state_model_map`
  - their resolved runtime paths still point at the expected shared scenes
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Repeated grounds scene kit moved onto substrate kinds

- Added repeated grounds scene substrate kinds to `engine/room_assembler.gd`:
  - `gate_post`
  - `gate_post_stone`
  - `boundary_wall`
  - `iron_gate_closed`
  - `fence_run`
- Those kinds currently instantiate the existing shared grounds scenes through
  the substrate layer, so authored room data no longer needs to point at the
  raw shared scene paths directly for the repeated exterior kit.
- Migrated the repeated declaration side in:
  - `declarations/rooms/front_steps.tres`
  - `declarations/rooms/front_gate.tres`
  - `declarations/rooms/garden.tres`
  - `declarations/rooms/family_crypt.tres`
- Added a declaration-suite `grounds scene prop contract` in
  `test/generated/test_declarations.gd` that proves those repeated props now
  use `substrate_prop_kind` and clear direct `scene_path`.
- Extended builder-default coverage so the new grounds substrate kinds must
  build successfully through `RoomAssembler`.
- Verified there are no remaining direct authored uses of these repeated shared
  grounds scene paths in the migrated room set.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Estate approach wrappers moved onto substrate kinds

- Extended `engine/room_assembler.gd` with the repeated estate-approach
  substrate kinds:
  - `hedgerow`
  - `carriage_road`
  - `outward_road`
  - `mansion_facade`
  - `entry_portico`
  - `front_door_assembly`
  - `forecourt_steps`
  - `starfield`
- Migrated the repeated declaration side in:
  - `declarations/rooms/front_steps.tres`
  - `declarations/rooms/drive_lower.tres`
  - `declarations/rooms/drive_upper.tres`
  - `declarations/rooms/front_gate.tres`
- There are now no remaining direct authored uses of these repeated shared
  grounds wrapper scenes in room declarations.
- Extended `test/generated/test_declarations.gd` so:
  - the `grounds scene prop contract` covers these kinds too
  - builder-default coverage proves the new substrate kinds build through
    `RoomAssembler`
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Mount payloads gained substrate-kind support

- Added `substrate_prop_kind` to `engine/declarations/mount_payload_decl.gd`
- `RoomAssembler._instantiate_mount_payload()` now routes substrate-backed
  payloads through the same shared substrate-kind build path used for props
- Migrated the front-gate sign mount payload in
  `declarations/rooms/front_gate.tres` off raw `scene_path` authoring and onto
  `substrate_prop_kind = "front_gate_sign"`
- Promoted the greenhouse lily pedestal in
  `declarations/rooms/greenhouse.tres` onto `substrate_prop_kind =
  "greenhouse_pedestal"`
- Extended `test/generated/test_declarations.gd` with:
  - `mount payload substrate contract`
  - builder coverage for `greenhouse_pedestal`
  - builder coverage for substrate-backed mount payload instantiation
- There are now no remaining direct authored uses of:
  - `res://scenes/shared/front_gate/front_gate_menu_sign.tscn`
  - `res://scenes/shared/greenhouse/greenhouse_lily_pedestal.tscn`
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Open front-gate scene moved onto substrate kind

- Added `iron_gate_open` to the shared grounds substrate-kind path in
  `engine/room_assembler.gd`
- Migrated the open gate prop in `declarations/rooms/front_gate.tres` off raw
  `scene_path = "res://scenes/shared/grounds/estate_iron_gate.tscn"` and onto
  `substrate_prop_kind = "iron_gate_open"`
- Extended `test/generated/test_declarations.gd` so:
  - the grounds scene prop contract now expects `iron_gate_center` to use the
    substrate kind
  - builder-default coverage proves `iron_gate_open` builds successfully
- There are now no remaining direct authored uses of
  `res://scenes/shared/grounds/estate_iron_gate.tscn` in room declarations.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

- Added shared helper constructors in `estate_material_kit.gd` for:
  - tinted shadow/void fills
  - unshaded emissive surfaces
  - window glow
  - fog glow
  - star glow
  - legacy texture fallback surfaces
- Removed local `StandardMaterial3D.new()` usage from the remaining shared
  grounds scripts that were still inventing their own shadow/glow/star
  materials:
  - `scenes/shared/grounds/estate_front_door.gd`
  - `scenes/shared/grounds/estate_entry_portico.gd`
  - `scenes/shared/grounds/estate_mansion_facade.gd`
  - `scenes/shared/grounds/estate_outward_road.gd`
  - `scenes/shared/grounds/estate_starfield.gd`
- Those scripts now resolve:
  - door/portico/facade shadow recesses through shared `shadow_void` variants
  - village window glow and fog banks through shared emissive helpers
  - starfield stars through shared emissive helpers
- The old procedural door compatibility path now resolves through the same
  shared kit too:
  - `scripts/procedural/door_single.gd`
  - `scripts/procedural/door_double.gd`
  - legacy `Texture2D` fallback panels/frames now build through
    `EstateMaterialKit.legacy_texture_surface()` instead of local
    `StandardMaterial3D.new()` snippets
- Added a declaration-suite regression guard in
  `test/generated/test_declarations.gd` asserting those grounds scripts no
  longer contain local `StandardMaterial3D.new()` construction, and extended
  that same guard to the procedural door scripts.
- Added a broader declaration-suite allowlist guard too: local
  `StandardMaterial3D.new()` construction is now confined to the actual
  material factory layer only:
  - `builders/estate_material_kit.gd`
  - `builders/pbr_texture_kit.gd`
  Any new direct local material factory in `builders/`, `scenes/shared/`, or
  `scripts/procedural/` now fails validation unless it is intentionally added
  to that allowlist.
- Renamed the remaining procedural door compatibility inputs so they no longer
  read like first-class authoring fields:
  - `door_single.gd` now exports `legacy_door_texture`
  - `door_double.gd` now exports `legacy_door_texture` and
    `legacy_frame_texture`
- Added a declaration-suite contract asserting those procedural scripts no
  longer export plain `door_texture` / `frame_texture` fields.
- Removed the now-dead legacy texture fields from the declaration schema
  itself:
  - `RoomDeclaration.wall_texture`
  - `RoomDeclaration.floor_texture`
  - `RoomDeclaration.ceiling_texture`
  - `Connection.door_texture`
  - `Connection.frame_texture`
- Stripped the matching empty assignments from authored room declarations and
  from `declarations/world.tres`, so serialized data now matches the live
  resource classes instead of carrying dead compatibility keys.
- Normalized the remaining explicit compatibility hint values in authored data:
  - door/gate panels now use ids like `door_panel_03`
  - doorway frames now use ids like `doorway_frame_00`
  - window mesh hints now use ids like `window_clean`
- Tightened the declaration suite so windowed rooms now fail if they still use
  old `wall*_texture`-shaped hint values.
- Removed the remaining builder-side parsing for old texture-shaped window/door
  mesh selectors from the builder layer.
- Ordinary windows now default to native procedural frame geometry instead of
  fitted imported structure, and the room-side compatibility field has been
  removed entirely.
- Ordinary doors now stay procedural too; imported frame/panel meshes are no
  longer part of the common `DoorBuilder` path.
- `RoomAssembler` no longer creates local `StandardMaterial3D` instances for
  the procedural moon or world-label props; those visuals now route through
  `EstateMaterialKit`, and the material-factory guard now scans `engine/` too.
- `RoomAssembler` now intercepts declaration-authored `window_clean.glb` and
  `window_ray.glb` props and replaces those repeated imported structure props
  with procedural window / glow-plane visuals during assembly.
- `RoomAssembler` now intercepts declaration-authored `stairs0.glb`,
  `stairbanister.glb`, and `banisterbase.glb` props too, replacing those
  repeated imported circulation structure props with procedural stair / rail /
  newel geometry during assembly.
- Added `PropDecl.substrate_prop_kind` and migrated the repeated room-authored
  window/circulation structure props onto explicit substrate kinds instead of
  ordinary imported-model authoring.
- Removed the redundant ordinary-door mesh hints from authored world data:
  - parlor, dining room, kitchen, upper-floor bedroom/library/guest-room, and
    service-hatch doors now rely on the shared door builder’s native default
    panel path instead of explicit legacy panel hints
  - the front facade pair was then removed too; door connections no longer
    carry authored mesh hints at all
- Tightened the declaration contract so all authored `type = "door"`
  connections now fail if they carry redundant default door metadata.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Shared fixture scenes normalized onto recipe library

- Added new shared surface and foliage recipes in `estate_material_kit.gd`
  for:
  - greenhouse frame
  - terracotta pot
  - dark soil
  - lily leaves
  - lily petals
  - ash linen
  - tea ceramic
  - tea tray wood
  - chapel stone
  - pedestal stone
  - warm flame
- Converted the following shared fixture scene families off embedded
  `StandardMaterial3D` stacks and onto `shared_recipe_applicator.gd`:
  - `scenes/shared/greenhouse/greenhouse_glazed_shell.tscn`
  - `scenes/shared/greenhouse/greenhouse_hanging_lantern.tscn`
  - `scenes/shared/greenhouse/greenhouse_lily_pedestal.tscn`
  - `scenes/shared/greenhouse/greenhouse_lily_pot_intact.tscn`
  - `scenes/shared/greenhouse/greenhouse_lily_pot_disturbed.tscn`
  - `scenes/shared/parlor/parlor_tea_service_set.tscn`
  - `scenes/shared/parlor/parlor_tea_service_disturbed.tscn`
  - `scenes/shared/chapel/baptismal_font_still.tscn`
  - `scenes/shared/chapel/baptismal_font_disturbed.tscn`
  - `scenes/shared/chapel/baptismal_font_searched.tscn`
- Added a declaration-suite substrate guard in
  `test/generated/test_declarations.gd` that asserts those shared recipe scenes:
  - load successfully
  - use `shared_recipe_applicator.gd`
  - no longer contain embedded `StandardMaterial3D` subresources
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Builder fallback materials moved onto shared recipes

- Added explicit shared fallback recipes in `estate_material_kit.gd` for:
  - `surface/fallback_wood`
  - `surface/fallback_metal`
  - `surface/shadow_void`
- Replaced ad hoc `StandardMaterial3D.new()` fallback paths in:
  - `builders/ladder_builder.gd`
  - `builders/stairs_builder.gd`
  - `builders/window_builder.gd`
- The circulation/envelope fallback path now stays substrate-owned even when a
  specific room or connection surface reference fails to resolve.
- Confirmed there are no remaining `StandardMaterial3D.new()` calls in the
  shared circulation/envelope builder set:
  - `stairs_builder`
  - `ladder_builder`
  - `window_builder`
  - `door_builder`
  - `trapdoor_builder`
  - `wall_builder`
  - `floor_builder`
  - `ceiling_builder`
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Envelope and threshold builders moved to recipe-first defaults

- Added `EstateMaterialKit.resolve_surface_reference()` so builder defaults can
  stay in recipe-id space instead of implicit texture-path space.
- Converted the shared builder defaults to explicit recipe refs:
  - `FloorBuilder` now defaults to `recipe:surface/oak_board`
  - `CeilingBuilder` now defaults to `recipe:surface/lining_tan`
  - `WallBuilder` now defaults to `recipe:surface/cloth_brown`
  - `StairsBuilder` now defaults to `recipe:surface/oak_board`,
    `recipe:surface/oak_header`, and `recipe:surface/oak_dark`
  - `DoorBuilder` now defaults door frames/panels to oak recipes and gate
    frames/panels to brick/wrought-iron recipes
  - `WindowBuilder` now defaults to `recipe:surface/oak_dark`
- Updated builder metadata and fallback semantics so these builders resolve
  real surface refs even when the caller does not provide one explicitly.
- Kept model-selection heuristics only for actual mesh selection; recipe refs no
  longer masquerade as model selectors for door/window builders.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Builder default contract is now explicit in tests

- Extended `test/generated/test_declarations.gd` with direct builder-default
  coverage for:
  - floor
  - ceiling
  - wall
  - door
  - gate
  - window
  - stairs
  - ladder
- The declaration suite now asserts:
  - default builder surfaces resolve to recipe ids, not blank strings
  - gate defaults resolve to brick/wrought-iron rather than generic door wood
  - recipe refs do not route into door/window model-selection heuristics
  - base floor/ceiling/wall builders still emit usable materials with empty
    caller-surface input
- Cleaned up the new builder-default test path so it frees temporary builder
  roots and does not leak renderer objects in headless validation.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`

## 2026-04-13 - Legacy model hints split from surface recipe ownership

- Rewired runtime threshold/window assembly so recipe-owned surfaces and mesh
  hints travel separately through:
  - `engine/room_assembler.gd`
  - `builders/connection_assembly.gd`
  - `builders/door_builder.gd`
  - `builders/window_builder.gd`
- Doors and windows now record:
  - resolved shared recipe surfaces
  - resolved legacy model hints
  as distinct metadata values instead of using one field for both concerns.
- Extended the declaration suite to prove:
  - explicit door/window legacy model hints are recorded and still resolve
    the expected mesh heuristics
  - recipe ids still do not trigger those heuristics
- The substrate contract now fails if:
  - a connection still uses retired threshold texture fields as authored
    runtime inputs
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Trapdoor builder moved to recipe-first defaults

- Converted `builders/trapdoor_builder.gd` so hatch frame/panel surfaces now
  resolve through explicit shared defaults:
  - `recipe:surface/oak_header`
  - `recipe:surface/oak_dark`
- The trapdoor builder no longer treats `Connection.frame_texture` and
  `Connection.door_texture` as the primary surface contract; those fields are
  now only compatibility fallback inputs if no recipe-owned surface override is
  provided.
- Extended the declaration suite builder-default coverage with direct trapdoor
  assertions.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Legacy door/frame textures no longer own material fallback

- Tightened `builders/door_builder.gd` and `builders/trapdoor_builder.gd` so
  `Connection.door_texture` and `Connection.frame_texture` are no longer used
  as implicit surface fallbacks.
- Shared recipe defaults now fully own door/gate/trapdoor material resolution
  unless the caller passes an explicit surface override.
- The declaration suite builder-default coverage now proves that even with
  legacy texture fields populated, door and trapdoor surfaces still resolve to
  the shared recipe defaults while compatibility mesh hints remain separate.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Interior envelope surfaces now come from environment grammar only

- Tightened `engine/room_assembler.gd` so interior floor, wall, and ceiling
  surfaces no longer fall back to legacy `RoomDeclaration.floor_texture`,
  `wall_texture`, or `ceiling_texture`.
- Interior shell material ownership now resolves only from:
  - room-level recipe overrides
  - environment role recipes
- Extended the declaration substrate contract so every interior room's resolved
  environment must explicitly define `floor`, `wall`, and `ceiling` recipes.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Room legacy texture fields cleared from authored data

- Cleared `wall_texture`, `floor_texture`, and `ceiling_texture` values across
  authored room declarations now that they are no longer part of runtime
  material ownership.
- Tightened `engine/room_assembler.gd` so window assembly no longer falls back
  to `wall_texture`, and it now relies on the shared `window_clean` builder
  default instead of room-side hint metadata.
- Tightened the declaration substrate contract so:
  - all room declarations must keep those legacy texture fields empty
- Updated `docs/ENGINE_SPEC.md` to reflect that those fields are legacy
  compatibility metadata rather than active authored texture channels.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Connection legacy texture fields cleared from authored world data

- Cleared `door_texture` and `frame_texture` values across `declarations/world.tres`.
- Explicit threshold mesh compatibility now survives only as builder-call
  inputs used for targeted compatibility testing.
- Tightened the declaration substrate contract so world connections must keep
  `door_texture` and `frame_texture` empty in authored data.
- Updated `docs/ENGINE_SPEC.md` and the substrate authority docs to reflect
  that those connection fields are retired authored metadata rather than active
  declaration channels.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Declaration defaults and stale docs reconciled to the substrate contract

- Updated `engine/declarations/room_declaration.gd` so retired room texture
  fields now default to empty strings instead of legacy texture ids.
- Updated `engine/declarations/connection.gd` comments so retired connection
  texture fields are described as legacy metadata, not active fallback inputs.
- Corrected stale substrate-era doc references in:
  - `docs/PAPER_PLAYTEST.md`
  - `docs/ENGINE_SPEC.md`
- This closes the remaining obvious contract drift between runtime behavior,
  authored data, declaration defaults, and docs.

## 2026-04-13 - Door mesh compatibility now uses explicit hints only

- Tightened `builders/door_builder.gd` so threshold mesh selection no longer
  falls back from explicit builder-call hints to the
  retired `frame_texture` / `door_texture` fields.
- Extended the builder-default coverage in `test/generated/test_declarations.gd`
  to prove that populated retired texture fields do not override explicit mesh
  hints.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-13 - Legacy procedural door scripts moved onto recipe-first materials

- Converted `scripts/procedural/door_single.gd` and
  `scripts/procedural/door_double.gd` to use shared recipe refs by default:
  - panel defaults to `recipe:surface/oak_dark`
  - frame defaults to `recipe:surface/oak_header`
- Retained raw `Texture2D` inputs only as legacy compatibility fallback for
  those scripts.
- Extended `test/generated/test_declarations.gd` with direct regression
  coverage proving both procedural door scripts build with recipe-owned
  materials.
- Repo-local validation reran green:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## 2026-04-08 - Hard substrate freeze tranche started

- Added `docs/SUBSTRATE_FOUNDATION.md` as the canonical substrate authority.
- Added `docs/batches/hard-substrate-freeze.md` as the active execution
  contract.
- Added `docs/checkpoints/SF-001-substrate-inventory.md` to record the first
  tree-based repo/NAS substrate census.
- Added declaration-facing substrate resources:
  - `MaterialRecipeDecl`
  - `TerrainPresetDecl`
  - `SkyPresetDecl`
  - `SubstratePresetDecl`
  - `MountSlotDecl`
  - `MountPayloadDecl`
- Added `builders/estate_substrate_registry.gd`.
- Refactored shared material handling toward recipe/slot resolution in
  `estate_material_kit.gd` and `pbr_texture_kit.gd`.
- Added shared environment preset resolution in
  `builders/estate_environment_registry.gd`.
- Added concrete terrain presets under `declarations/terrain_presets/`.
- Added a concrete sky preset under `declarations/sky_presets/`.
- Added the first substrate preset matrix under
  `declarations/substrate_presets/`.
- Expanded environment and region declarations to carry substrate-facing
  defaults and policy.
- Wired `RoomAssembler` to resolve substrate preset metadata and mount payloads
  before bespoke room hacks.
- Wired `PSXBridge` to resolve authored sky presets into runtime sky
  declarations.
- Wired exterior floor assembly to resolve through the declared terrain preset
  base recipe instead of only raw room texture strings.
- Wired environment-level `surface_recipe_overrides` for `floor`, `wall`, and
  `ceiling`, so interior region grammar can resolve shared surfaces directly.
- The first substrate regressions were repaired:
  - explicit preload typing for new declaration/resource classes
  - `RoomAssembler` instantiation fixed in `room_manager.gd`
  - constant-expression fixes in `pbr_texture_kit.gd` and
    `estate_substrate_registry.gd`
- Repo-local validation reran green:
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- Runtime environment proof now shows the shared layer being consumed:
  - `front_gate` resolves `terrain=carriage_approach`
  - `front_gate` resolves `sky_preset=grounds_twilight_sky`
  - `front_gate` resolves `floor=recipe:terrain/carriage_road`
  - `foyer` resolves `floor=recipe:surface/oak_board`
  - `foyer` resolves `wall=recipe:surface/cloth_brown`
  - `foyer` resolves `ceiling=recipe:surface/lining_tan`

## Downstream Finish Tranche (provisional / deferred)

- `docs/batches/ralph-final-remaining-stories.md` remains the downstream finish
  tranche for late Android/export work after the substrate sweep.
- Current downstream status:
  - `US-020` visual polish and readable renderer-backed evidence — done
  - `US-021` repo-local freeze and convergence proof — done
  - `US-022` archive/handoff cleanup — done
  - `US-023` maintenance baseline and regression register — done
  - `US-024` Android/export audit — done
  - `US-025` packaged helper support — done
  - `US-026` packaged critical-path validation flow — blocked on semantic
    helper-label pickup on `ashworth_test`
  - `US-027` release-candidate proof — blocked on release keystore credentials

## 2026-04-07 - US-020 through US-027 closeout

- `US-020` landed:
  - late-room declaration lighting and walkthrough capture polish landed
  - new checkpoint: `docs/checkpoints/US-020-visual-polish.md`
- `US-021` landed:
  - full freeze bundle reran green:
    - boot
    - declarations
    - room specs
    - declared interactions
    - route progression
    - gdUnit route program
    - full playthrough
    - opening journey
    - walkthrough
  - new checkpoint: `docs/checkpoints/US-021-freeze-and-convergence.md`
- `US-022` landed:
  - weave-era design docs now carry archived/historical banners
  - source-map surfaces now distinguish archived docs explicitly
- `US-023` landed:
  - maintenance baseline and regression register recorded
- `US-024` landed:
  - Android audit recorded real local state: SDK/build-tools/AVD availability,
    debug signing present, release signing absent
- `US-025` landed:
  - added `scripts/debug/maestro_helper.gd`
  - helper is gated by debug build + non-headless + `--maestro-helper`
- `US-026` is blocked:
  - `maestro test test/maestro/smoke_test.yaml` passes on `ashworth_test`
  - helper-backed `test/maestro/full_playthrough.yaml` exists but fails at
    semantic label pickup (`dismiss document`) on the current AVD
- `US-027` is blocked:
  - debug export succeeds with Android SDK/build-tools on `PATH`
  - debug APK installs and launches on `ashworth_test`
  - debug device screenshot captured at `reports/android/debug-launch.png`
  - release export fails at signing because no release keystore is configured

## Codebase Patterns (Study These First)

### Doc Hierarchy Pattern
- `docs/GAME_BIBLE.md` is the single canonical authority for the shipped game
- All other narrative docs (PLAYER_PREMISE, ELIZABETH_ROUTE_PROGRAM, NARRATIVE, MASTER_SCRIPT) are focused supplements that defer to it
- Each supplement has a blockquote deference header pointing to GAME_BIBLE
- Supplements should not duplicate canonical claims — they reference GAME_BIBLE sections and add only what's unique to their focused scope
- When updating the shipped game: update GAME_BIBLE first, then propagate

### Three-Layer Content Pattern
- Interaction text exists in three layers: declaration (.tres, primary), dialogue (.dialogue, DialogueManager addon), scene metadata (.tscn, fallback)
- room_manager tries declaration assembly first (line 678); .tscn scenes are dead code for rooms with declarations
- When editing narrative content, update all three layers: declaration is the source of truth, dialogue serves live gameplay with the addon, .tscn metadata is defense-in-depth
- Thread-variant responses (captive/mourning/sovereign) may exist as orphaned sub_resources awaiting route migration

### Response → ConditionalEvent Indirection Pattern
- `ResponseDecl` only supports set_state, gives_item, play_sfx — no light_change or camera_shake
- To trigger visual/environmental changes on interaction: response sets a state flag → `ConditionalEventDecl` watches for that flag → fires ActionDecl with light_change/camera_shake/spawn_model
- Example: improvised_relight response sets `basement_relight: true` → `cond_relight` event fires `light_change` on mattress candle
- Same pattern used by parlor music_box_auto (fire_lit + elizabeth_aware → dim/restore/shake)

### Dark-State Gating Pattern
- Add high-priority conditional responses (first-match-wins) with `bad_air_active AND NOT basement_relight` to gate interactables in darkness
- These sit above default responses in the cascade and convert visual exploration to tactile/disoriented text
- Thread variants (captive/mourning/sovereign) are unaffected because `thread_responses` REPLACES the responses array

### Cross-Room State Propagation Pattern
- State flags are global but ConditionalEventDecl fires per-room. To propagate light changes across rooms: set a global flag (e.g., `gas_restored`) in one room's response → each affected room has its own ConditionalEventDecl watching that flag → each fires room-local `light_change` actions on its own lights
- Same pattern works for clearing ambient conditions: `bad_air_active: false` in boiler_room's response immediately stops storage_basement's ambient events (since the ambient condition check evaluates the global flag)
- When tightening ambient conditions for a new state tier, add the NOT clause to existing conditions (e.g., `bad_air_active AND basement_relight` → `bad_air_active AND basement_relight AND NOT gas_restored`)

### Tool Transition Pattern
- Tool phases (firebrand → walking stick → lantern hook) are acquired as `gives_item` on a ResponseDecl, with `set_state` updating both `walking_stick_phase` (or equivalent) and `current_light_tool`
- The new tool must have a prototype in `resources/item_prototypes.json` — gloot silently fails without one
- The tool's first meaningful use should be a physical interaction that changes game state (e.g., propping a hatch), not just narrative text
- The acquisition response cascade follows the 3-tier pattern: already-taken → blocked-by-prerequisite → default-pickup

### Re-Entry State Trigger Pattern
- To trigger events on "first re-entry after a state change" (e.g., returning from basement with gas restored): use condition `state_flag AND NOT consequence_flag`
- The trigger sets the consequence flag, making it fire exactly once
- This is cleaner than `visited_*` flags because it gates on the meaningful state transition
- Example: `gas_restored AND NOT stable_house_light` fires the kitchen re-emergence

### Route Thread_Responses Additive Pattern
- Adding a new route key (e.g., `"adult"`) to an interactable's `thread_responses` dictionary is purely additive — it doesn't affect existing weave keys or default responses
- Interactables can have `thread_responses` for only the routes that need custom content; missing keys simply fall through to the default `responses` array
- The content cascade within a route's response array follows the same first-match-wins pattern as the default responses — conditions at the top, unconditional default at the bottom
- Route thread_responses should bias toward the route's clue types (Adult: letters, portraits, private effects, denied adulthood) consistently across rooms to create cumulative evidence pressure

### Route Ending via State-Changed Pattern
- `ActionDecl` has no `trigger_ending` field — endings must fire through GDScript
- Wire route endings in `interaction_manager._on_game_state_changed`: watch for a route-specific flag (e.g., `attic_music_box_wound`), then call `GameManager.trigger_ending(route_id)` with a delay timer
- `trigger_ending` calls `mark_route_completed()` for any ending in `POSITIVE_ROUTE_ENDINGS`, recording completion and advancing route progression
- This matches the existing freedom ending pattern (puzzle_handler sets flag → timer → trigger_ending)

### Observation Type for Declaration-Driven Puzzle Solves
- The `interaction_manager` match statement only tries `_handle_declared_interaction` for types: note, painting, photo, mirror, clock, observation, switch, box
- The "puzzle" type falls to the default `_:` case which skips declaration handling entirely
- For solve objects driven entirely by response cascades (conditions + set_state + play_sfx), use type `"observation"` to route through the declaration engine

### Acceptance Two-Tier Pattern
- Tier 1 (Repo-Local Freeze): headless engine boot, declaration tests, room specs, interaction E2E, playthrough, walkthrough
- Tier 2 (Downstream Release): Android export, APK smoke, Maestro flows, device capture
- Tier 2 depends on Tier 1 passing first

---

## Post-Ralph Integration Follow-up

- On `codex/ralph-integration-harvest`, the stale `test/e2e/test_full_playthrough.gd`
  freedom-path failures were repaired by updating the lane to the current
  sign/valise opening, explicit threshold ids, parlor-firebrand prerequisite,
  and service-hatch descent semantics. The full playthrough lane now passes
  headless again.
- `US-011` (Elder clue topology / blackout grammar checkpoint) has now landed
  after Ralph's crash:
  - added `docs/checkpoints/elder-route-clue-topology.md`
  - added elder-biased declaration text in `foyer`, `upper_hallway`,
    `wine_cellar`, and `family_crypt`
  - extended `test/e2e/test_declared_interactions.gd` with elder route bias
    assertions
  - reran `test/e2e/test_room_walkthrough.gd` and regenerated walkthrough
    captures for touched spaces
- Remaining execution continues from `US-012` in
  `docs/batches/ralph-remaining-stories-batch.md`.
- `US-012` (Elder cellar-to-crypt resolution) has now landed:
  - attic music box redirects in Elder rather than resolving the route
  - `cellar_barrel_passage` now provides the burial-side bypass from the wine
    cellar
  - `crypt_gate_latch` and `crypt_music_box` now complete the Elder route in
    `family_crypt`
  - `new_game()` resets room-event runtime state so repeated route tests can
    re-fire the rupture honestly
  - headless declarations, room specs, route progression, declared
    interactions, and full playthrough all pass
  - walkthrough reran successfully, but generic burial-side entry captures are
    still poor showcase evidence and should be revisited during later visual
    polish
- Remaining execution now continues from `US-015` in
  `docs/batches/ralph-remaining-stories-batch.md`.
- `US-013` and `US-014` (Child clue topology + hidden-room resolution) have now landed:
  - added `docs/checkpoints/child-route-clue-topology.md`
  - added `docs/checkpoints/US-014-child-hidden-room-resolution.md`
  - child-biased declaration text landed in `upper_hallway`, `master_bedroom`,
    `library`, `guest_room`, and `attic_storage`
  - `attic_storage` now redirects Child route through `sealed_seam` into the
    sealed room rather than resolving in the attic
  - `hidden_chamber.tres` is now a sealed nursery and resolves through
    `child_music_box`
  - headless declarations, room specs, declared interactions, route
    progression, and full playthrough pass
  - renderer-backed opening journey and walkthrough reran successfully with the
    hidden-room manifest updated to the shipped nursery set
- `US-015` (route unification / progression hardening) has now landed:
  - `GameManager` exposes `set_route_context()` and explicit route mode via
    `get_route_mode()`
  - `test_route_progression.gd` now verifies canonical progression plus
    explicit post-third-run replay mode
  - `test_full_playthrough.gd` now stages `adult`, `elder`, and `child`
    directly through the route API instead of passing legacy thread ids as its
    primary control surface
- `US-016` and `US-017` have now landed:
  - critical-path room docs now describe the shared spine, attic redirect,
    burial bypass, and sealed-room route program in shipped terms
  - critical-path declarations now carry `child / adult / elder` route keys in
    the source-of-truth layer, with weave keys left only as compatibility shims
- Remaining execution now continues from `US-018` in
  `docs/batches/ralph-remaining-stories-batch.md`.
- `US-018` (automated coverage expansion) has now landed:
  - `test_full_playthrough.gd` drives the shipped `Adult -> Elder -> Child`
    program and distinguishes route-specific darkness, redirect, solve, and
    ending behavior
  - `test_route_progression.gd` now proves canonical progression plus
    post-third-run replay mode explicitly
  - `test/unit/route_program_test.gd` plus `GdUnitRunner.cfg` re-enable gdUnit4
    as a real repo-local route-program lane
  - the working gdUnit command for this repo is:
    `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode`
  - headless declarations, room specs, declared interactions, route
    progression, full playthrough, and gdUnit route-program coverage all pass
- Remaining execution now continues from `US-019` in
  `docs/batches/ralph-remaining-stories-batch.md`.
- `US-019` (renderer-backed acceptance rebuild) has now landed:
  - `test_opening_journey.gd` passes with the shipped opening capture manifest
  - `test_room_walkthrough.gd` passes with a rebuilt milestone manifest that
    now explicitly covers basement, boiler room, wine cellar, family crypt,
    attic storage, and hidden-room finale evidence
  - route-finale milestone captures now include `attic_storage_attic_music_box`,
    `family_crypt_crypt_music_box`, and `hidden_chamber_child_music_box`
  - the evidence surface is now reviewable, but the basement/cellar/crypt/attic
    captures reveal genuine underlighting and placeholder-material issues that
    should be treated as the real `US-020` polish front
- Remaining execution now continues from `US-020` in
  `docs/batches/ralph-remaining-stories-batch.md`.

## 2026-04-07 - US-001
- Consolidated the canonical whole-game documentation surface
- Established GAME_BIBLE.md as the single source of truth with explicit hierarchy
- Added deference headers to all four supplement docs (PLAYER_PREMISE, ELIZABETH_ROUTE_PROGRAM, NARRATIVE, MASTER_SCRIPT)
- Replaced duplicated content in supplements with cross-references to GAME_BIBLE sections
- Split acceptance surface into Tier 1 (repo-local freeze) and Tier 2 (downstream release validation)
- Updated INDEX.md, STRUCTURE.md, MEMORY.md, and docs/script/MASTER_SCRIPT.md to reflect the new hierarchy
- Files changed:
  - `docs/GAME_BIBLE.md` — canonical surface + acceptance tiers rewritten
  - `docs/PLAYER_PREMISE.md` — deference header added
  - `docs/ELIZABETH_ROUTE_PROGRAM.md` — deference header, shared spine → reference, transition rules → reference
  - `docs/NARRATIVE.md` — deference header, storyline order → reference, shared spine → design notes, equipment → reference, design rules → reference
  - `docs/MASTER_SCRIPT.md` — deference header, completion order → reference, route summaries → authoring notes, script rules → reference
  - `docs/script/MASTER_SCRIPT.md` — deference header, link list updated
  - `docs/INDEX.md` — canonical authority vs focused supplements hierarchy
  - `STRUCTURE.md` — narrative canon surface updated
  - `MEMORY.md` — canonical narrative decisions updated
- **Learnings:**
  - The five docs didn't actually contradict each other in substance — the real problem was massive duplication creating drift risk
  - The fix is hierarchy (one wins, others defer) plus deduplication (replace repeated claims with cross-references)
  - Supplements are valuable for authoring-level detail that doesn't belong in the Bible — don't delete them, refocus them
  - The headless boot test (`godot --headless --path . --quit-after 1`) is doc-change-safe and exits 0 quickly
---

## 2026-04-07 - US-002
- Repointed the four repo entry-point docs to name canonical sources first and distinguish them from historical/support surfaces
- Files changed:
  - `docs/INDEX.md` — added explicit note under Execution Surface labeling individual batch files as historical detail
  - `PLAN.md` — added Canonical Sources table at the top pointing to GAME_BIBLE, master task graph, INDEX, and STRUCTURE
  - `MEMORY.md` — restructured batch references into "Canonical Execution Contract" (master task graph) and "Historical Batch Detail" (all individual batch files, explicitly labeled as superseded)
  - `STRUCTURE.md` — restructured "Narrative Canon Surface" into "Canonical Surfaces" with explicit subsections: Narrative Authority, Execution Contract, Focused Supplements, and Historical/Support Surfaces
- **Learnings:**
  - US-001 did most of the heavy lifting (establishing GAME_BIBLE, adding deference headers); US-002 is the wiring story that makes the hierarchy visible at every entry point
  - The key missing piece was labeling historical batch files as superseded — without that label, contributors could treat them as independent execution drivers
  - MEMORY.md carried the most drift risk because it mixed "new authoritative batch" inline with eight "next batch" entries, creating the illusion of parallel execution tracks
---

## 2026-04-07 - US-003
- Captured the runtime baseline and defined the shared-spine state map
- Created checkpoint docs recording engine boot status, all 6 active headless test lanes, 2 renderer-backed lanes, and known gaps
- Defined 6 new canonical state keys for shared-spine Stages 6–7: `basement_relight`, `bad_air_active`, `gas_restored`, `basement_lights_awake`, `stable_house_light`, `walking_stick_phase`
- Added all 6 new state vars to `declarations/state_schema.tres` with set_by/read_by contracts
- Documented legacy weave → Adult/Elder/Child test evolution path with per-test migration notes
- Mapped existing state keys to GAME_BIBLE Stages 0–5 (already implemented) and new keys to Stages 6–7 (to be implemented in US-006/US-007)
- Added checkpoint section to `docs/INDEX.md`
- Verified: headless boot (exit 0), route progression (9/9 pass), declaration integrity (543/543 pass)
- Files changed:
  - `docs/checkpoints/US-003-runtime-baseline.md` — new: runtime baseline, test lane inventory, known gaps
  - `docs/checkpoints/shared-spine-state-map.md` — new: canonical state keys for all 8 spine stages, lifecycle diagram, test evolution plan
  - `declarations/state_schema.tres` — added 6 new state variable declarations for Stages 6–7
  - `docs/INDEX.md` — added Checkpoints section
- **Learnings:**
  - The `flags` dictionary in game_manager.gd serves double duty: boolean flags via `set_flag()` and typed state via `set_state()`. Both share the same backing store, so spine-stage keys and interaction flags coexist in one flat namespace. This is fine as long as naming conventions distinguish them.
  - state_schema.tres is runtime-loadable and declaration-test-validated (543 assertions including the new vars). Adding state keys here makes them part of the formal declaration integrity surface, not just docs.
  - Stages 0–5 (opening through Elizabeth's first seizure) are fully covered by existing state keys and tested by `test_opening_journey.gd`. Stages 6–7 (service reclamation and midgame possession) have no runtime implementation yet — only declarations and docs.
  - `test_full_playthrough.gd` still uses legacy thread IDs (`captive`, `mourning`, `sovereign`) for test setup. This works because game_manager.gd bridges them, but it should migrate to route-first setup in US-018.
---

## 2026-04-07 - US-004
- Aligned front-gate arrival narrative with canonical heir-return sequence (GAME_BIBLE Stages 0–2)
- Fixed `iron_gate` default text: replaced overtly supernatural claim ("someone burst through from within") with materially grounded observation (broken lock attributed to weather/time/neglect)
- Synced `front_gate.dialogue` with declaration layer on 4 of 5 entries (plaque, luggage, gate, lamp) — removed old supernatural texts and replaced with grounded estate-marker language
- Synced `front_gate.tscn` metadata with declaration layer on 4 of 5 entries (same set)
- Verified foyer handoff: chandelier at energy 0.0, threshold text describes darkness, moonlight-only — correct per GAME_BIBLE Stage 3
- Verified all six acceptance tests pass: boot (exit 0), declarations (543/543), room specs (371/371), opening journey (32/32), walkthrough (105/105)
- Files changed:
  - `declarations/rooms/front_gate.tres` — `resp_gate_default` text rewritten
  - `dialogue/grounds/front_gate.dialogue` — 4 entries synced with declaration texts
  - `scenes/rooms/grounds/front_gate.tscn` — 4 metadata blocks synced with declaration texts
- **Learnings:**
  - The codebase has three content layers for interaction text: declaration (.tres, primary), dialogue (.dialogue, DialogueManager addon), and scene metadata (.tscn, fallback). Declarations always win when present — room_manager tries declaration assembly first at line 678. The .tscn scene is dead code for rooms with declarations but should stay synced for defense-in-depth.
  - The front_gate declaration already had mostly grounded defaults (plaque, luggage, bench, lamp) — only `iron_gate` was still supernatural on first visit. The dialogue file had the most drift, carrying old supernatural text on 4 of 5 entries.
  - Thread-variant responses (captive/mourning/sovereign) exist as orphaned sub_resources in front_gate.tres — defined but not wired into any interactable's `thread_responses` dictionary. This is intentional: the weave-to-route migration will connect them to route IDs in US-016/US-017.
  - The opening journey test (32 assertions) drives state changes rather than asserting on text content, so narrative text changes don't break it. This is a well-designed separation of concerns.
---

## 2026-04-07 - US-005
- Verified all first-warmth runtime mechanics already passing: firebrand acquisition through parlor hearth, Elizabeth's laugh + firebrand loss + kitchen-side forced descent
- Synced dialogue layer with declaration layer for three critical interactions where three-layer drift was causing incoherent player-facing text:
  - `parlor.dialogue`: fireplace section expanded from 2-state to 3-state cascade matching declaration (`elizabeth_aware AND parlor_fire_lit` → `parlor_fire_lit` → default). Default text now describes active fire-lighting and brand extraction, not passive observation.
  - `kitchen.dialogue`: note section synced with declaration's cook's note ("DO NOT go upstairs. DO NOT answer if she calls."). `knows_attic_girl` variant rewritten to reference the declaration text.
  - `kitchen.dialogue`: hearth section expanded from 2-state to 3-state cascade matching declaration (`examined_hearth_loose` → `elizabeth_aware` → default). Default text now sets up flagstone puzzle, not cooking residue.
- All six acceptance tests pass: boot (exit 0), declarations (208/208), room specs (opening journey 32/32), walkthrough (105/105)
- Files changed:
  - `dialogue/ground_floor/parlor.dialogue` — fireplace section rewritten (3-state cascade, active fire-lighting text)
  - `dialogue/ground_floor/kitchen.dialogue` — note and hearth sections rewritten (declaration-synced text, flagstone puzzle setup)
- **Learnings:**
  - Dialogue drift is the most common three-layer coherence failure. Declarations drive state but dialogue is what the player reads. When these diverge, the player sees passive text while getting active gameplay results (e.g., "embers still glow" but inventory gets a firebrand).
  - The dialogue cascade must mirror the declaration response ordering exactly: same conditions, same evaluation priority, same first-match-wins behavior. A 2-state dialogue for a 3-state declaration drops an entire player experience (the "fire already lit, brand in hand" state had no dialogue).
  - Runtime tests validate state mechanics, not text coherence. All 32 opening journey assertions passed before the dialogue fix. The test suite won't catch three-layer drift — that requires manual audit comparing .tres, .dialogue, and .tscn for each interactable.
---

## 2026-04-07 - US-006
- Implemented storage-basement fall landing bodily consequence, improvised relight, and bad-air pressure
- Enhanced fall-landing entry trigger: added `camera_shake: 0.35` for bodily impact and `bad_air_active: true` to state mutations
- Added new `improvised_relight` interactable (type: switch) at the dead lamp position — match-strike narrative sets `basement_relight: true`, `ConditionalEventDecl` fires `light_change` to wake mattress candle at energy 1.2 over 2s
- Added dark-state gating on all 4 existing interactables: high-priority `bad_air_active AND NOT basement_relight` responses that make touch and disorientation the primary senses when the player is in the dark
- Added 2-tier bad-air ambient events: aggressive 8-15s coughing/gasping text in the dark (`bad_air_active AND NOT basement_relight`), gentler 20-40s candle-lean reminders after relight (`bad_air_active AND basement_relight`)
- Added `prop_match_tin` small prop next to dead lamp for visual affordance
- Synced dialogue layer (storage_basement.dialogue) with all new declaration content including dark-state branches and improvised_relight entry
- Synced scene metadata layer (storage.tscn) with declaration texts and added improvised_relight Area3D with collision shape
- All headless tests pass: boot (exit 0), declarations (545/545, up from 543), room specs (371/371), declared interactions (208/208)
- Renderer-backed tests (opening journey, walkthrough) require manual review with display
- Files changed:
  - `declarations/rooms/storage_basement.tres` — fall shake + bad_air_active, improvised_relight interactable, dark-state responses, ambient events, conditional event, match_tin prop
  - `dialogue/basement/storage_basement.dialogue` — dark-state branches, improvised_relight entry, synced with declaration texts
  - `scenes/rooms/basement/storage.tscn` — improvised_relight Area3D + collision, metadata synced with declarations
- **Learnings:**
  - `ConditionalEventDecl` (not TriggerDecl or AmbientEventDecl) is the correct class for state-reactive events — fires when a condition becomes true while in-room. Used for the relight light_change, following the parlor music_box_auto pattern.
  - `ResponseDecl` only supports set_state, gives_item, and play_sfx. For light_change or camera_shake on interaction, the pattern is: response sets a flag → ConditionalEventDecl watches for that flag → fires the action. This is a two-step indirection but keeps the response/action systems cleanly separated.
  - Ambient events with state-gated conditions create pressure without timers: `bad_air_active AND NOT basement_relight` fires coughing text every 8-15s, making the dark feel actively hostile. After relight, the condition shifts to the gentler tier. The player never sees a countdown but feels urgency.
  - Dark-state gating on interactables (first-match condition cascade) is a powerful narrative tool: the portrait becomes "you cannot see it" and the mattress becomes "fabric under your knees," converting the room from visual exploration to tactile survival. Thread variants are unaffected because they REPLACE the responses array entirely.
  - Declaration test count increased from 543 to 545 — the 2 new assertions come from the `improvised_relight` interactable validation (existence + response count).
---

## 2026-04-07 - US-007
- Re-authored boiler room from occult framing to concise service machinery per GAME_BIBLE Stage 6
- Replaced 3-step valve progressive puzzle + electrical panel fuse puzzle + metal mask with single `gas_restore` switch interactable
- Gas restoration sets `gas_restored`, `basement_lights_awake`, clears `bad_air_active` in one response
- ConditionalEventDecl in both boiler_room and storage_basement fires staggered `light_change` on wall sconces when `gas_restored` becomes true
- Added 2 gas sconce lights (energy 0.0, candle flicker) + 2 sconce props to each basement room (4 new lights total)
- Lowered boiler_glow energy from 0.8 to 0.3 and range from 5.0 to 4.0 — the room should feel dim before gas restore
- Dark-gated the gas_restore itself: `NOT basement_relight` response blocks operation until player has light
- Split pipe ambient into pre-restore (cold rattle) and post-restore (warm machine hum) tiers
- Re-authored entry text, boiler observation, maintenance log, clock, and pipes — all now read as grounded infrastructure
- Thread variants (captive/mourning/sovereign) preserved on maintenance_log and boiler_observation but rewritten to remove occult content
- Synced dialogue layer (boiler_room.dialogue) — 5 nodes matching declaration cascade
- Synced scene metadata layer (boiler_room.tscn) — 5 interactables matching declaration IDs and text
- Updated state_schema.tres `set_by`/`read_by` for gas_restored and basement_lights_awake to match actual implementation
- Updated test assertions: first-entry text, maintenance_log text, replaced mask test with gas_restore test (6 new assertions)
- Updated room_spec_data (interactable list, min_lights) and walkthrough_data for both basement rooms
- All headless tests pass: boot (exit 0), declared interactions (211/211, up from 206), room specs (371/371)
- Renderer-backed tests (opening journey, walkthrough) require manual review with display
- Files changed:
  - `declarations/rooms/boiler_room.tres` — full rewrite: service machinery, gas_restore, sconces, conditional event
  - `declarations/rooms/storage_basement.tres` — 2 sconce lights, 2 sconce props, gas_restore conditional event, bad_air_lit condition tightened
  - `declarations/state_schema.tres` — set_by/read_by for gas_restored and basement_lights_awake updated
  - `dialogue/basement/boiler_room.dialogue` — full rewrite: 5 nodes matching new declarations
  - `scenes/rooms/basement/boiler_room.tscn` — interactable metadata synced, mask removed, gas_restore added
  - `test/e2e/test_declared_interactions.gd` — boiler_room test section rewritten for new content
  - `test/e2e/room_spec_data.gd` — boiler_room and storage_basement interactable lists and light counts updated
  - `test/e2e/walkthrough_data.gd` — boiler_room walkthrough entry updated
- **Learnings:**
  - The `gas_restore` response cascade (done → dark-blocked → default) is the cleanest version of the three-tier pattern: state-gated top, sensory-gated middle, action default. This is more concise than the storage_basement relight because it gates on upstream state (`basement_relight`) rather than on its own room condition.
  - ConditionalEventDecl fires per-room, not globally. Sconce wake in storage_basement requires its own conditional event watching `gas_restored`, separate from the boiler_room's event. Cross-room light propagation works because the state flag is global but the light_change actions are room-local.
  - When removing interactables (mask, pipe_valves, electrical_panel), three test data files need updating: room_spec_data (interactable list), walkthrough_data (visit sequence), and test_declared_interactions (assertion blocks). Missing any one causes test failures.
  - The bad_air_active → false mutation in the gas_restore response means the storage_basement's ambient bad_air events stop immediately on gas restore. The ambient_bad_air_lit condition was tightened to `AND NOT gas_restored` to prevent it firing in the restored state. This is the first time a response in one room (boiler) clears an ambient condition originated in another room (storage_basement).
---

## 2026-04-07 - US-008
- Implemented service-world return through utilitarian circulation (existing stairs connection) and walking-stick midgame transition
- Added `walking_cane` interactable to boiler_room: caretaker's ash-wood cane with iron-shod tip, 3-tier response cascade (taken → blocked before gas → default pickup)
- Added `walking_cane` prototype to `resources/item_prototypes.json` (gloot inventory requires prototype registration)
- Added kitchen re-emergence entry trigger `kitchen_service_return`: fires on `gas_restored AND NOT stable_house_light`, sets `stable_house_light: true`, wakes kitchen lights, narrates return from service world
- Added `service_hatch_prop` interactable to kitchen: walking stick's first meaningful use — player levers the hatch into its stays with the cane's iron tip, securing the service route
- Added `service_hatch_propped` state var to state_schema.tres
- Updated state_schema.tres set_by/read_by for `walking_stick_phase`, `stable_house_light`, `current_light_tool`
- Synced all three content layers (declaration → dialogue → scene metadata) for boiler_room and kitchen
- Added 15 new test assertions across 2 new test functions: `_test_boiler_room_walking_cane` (8 assertions) and `_test_kitchen_service_return` (7 assertions)
- All headless tests pass: boot (exit 0), route progression (9/9), declared interactions (226/226, up from 211), room specs (373/373, up from 371)
- Renderer-backed tests (opening journey, walkthrough) require manual review with display
- Files changed:
  - `declarations/rooms/boiler_room.tres` — walking_cane interactable + prop + 3 responses
  - `declarations/rooms/kitchen.tres` — service_return entry trigger + service_hatch_prop interactable + 3 responses
  - `declarations/state_schema.tres` — service_hatch_propped var, updated set_by/read_by contracts
  - `resources/item_prototypes.json` — walking_cane prototype for gloot inventory
  - `dialogue/basement/boiler_room.dialogue` — walking_cane node (3-state cascade)
  - `dialogue/ground_floor/kitchen.dialogue` — service_hatch_prop node (3-state cascade)
  - `scenes/rooms/basement/boiler_room.tscn` — walking_cane Area3D + collision
  - `scenes/rooms/ground_floor/kitchen.tscn` — service_hatch_prop Area3D + collision
  - `test/e2e/test_declared_interactions.gd` — 2 new test functions
  - `test/e2e/room_spec_data.gd` — kitchen + boiler_room interactable lists updated
  - `test/e2e/walkthrough_data.gd` — kitchen + boiler_room visit entries updated
- **Learnings:**
  - The gloot inventory addon requires every giveable item to have a prototype in `resources/item_prototypes.json`. `create_and_add_item()` silently fails without one. When adding a new `gives_item` response, always register the prototype first.
  - Entry triggers with `delay_seconds` on text actions don't resolve before synchronous test assertions. For testable triggers, keep text actions without delay or use await-based tests. The light_change actions can retain delays for visual pacing since tests don't assert on light state.
  - The service return trigger pattern (`gas_restored AND NOT stable_house_light`) is reusable for any "first re-entry after a state change" event. It's cleaner than using `visited_*` flags because it gates on the meaningful state transition, not just room visit history.
  - The walking stick's first use (propping the hatch) is a physical interaction that changes game state, not just narrative text. This makes the tool transition feel mechanical — the player does something with the stick, not just reads about it. This pattern should be used for the lantern-hook transition too.
---

## 2026-04-07 - US-009
- Authored the Adult-route clue topology and shared-room bias across 7 rooms
- Created canonical Adult Route Clue Topology checkpoint doc at `docs/checkpoints/adult-route-clue-topology.md` — maps clue chain, room biases, discovery cascade, and state tracking
- Added `"adult"` thread_responses to 15 interactables across 7 rooms:
  - **Parlor** (3): Lady portrait, diary page, music box — all biased toward Victoria mourning an adult daughter, Elizabeth's mature handwriting, and the music box as a coming-of-age gift
  - **Library** (4): globe, binding book, family tree, bookshelves — Elizabeth's adult fingerprints on the globe, Edmund's language shifting from "girl" to "woman," family tree with questioned dates, and Elizabeth's reading marginalia
  - **Upper hallway** (2): children's painting, notice — repainted adult face in children's group, notice amended with "I am twenty-three years old"
  - **Master bedroom** (4): diary, mirror, wardrobe, medical book — Edmund's diary shifting to "the woman upstairs," reflection aging, hidden adult dress, and passages about confining adults of sound mind
  - **Guest room** (1): ledger — Helena met "a young woman, not a child"
  - **Foyer** (3): painting, mirror, mail — Edmund's exhaustion from watching her grow up, brief reflection of adult Elizabeth, intercepted letter addressed to "Miss Elizabeth Ashworth"
  - **Attic storage** (3): portrait, letter, trunk — self-portrait of 23-year-old Elizabeth, adult letter to Mama, and childhood clothes remade into adult garments
- Added new `elizabeth_papers` interactable to library (type: note) — Elizabeth's hidden folio of adult writings, the primary evidence of adult intellectual life
- Added `found_elizabeth_papers` state variable to `declarations/state_schema.tres`
- Updated `docs/GAME_BIBLE.md` Adult Route section with clue topology reference and key interactable mention
- Updated `docs/INDEX.md` checkpoint table with new topology doc
- All headless tests pass: boot (exit 0), declarations (549/549, up from 226 due to test renumbering)
- Files changed:
  - `docs/checkpoints/adult-route-clue-topology.md` — new: canonical Adult route clue map
  - `docs/GAME_BIBLE.md` — Adult Route section expanded with topology reference
  - `docs/INDEX.md` — checkpoint table updated
  - `declarations/rooms/parlor.tres` — 3 adult thread_responses added
  - `declarations/rooms/library.tres` — 4 adult thread_responses + elizabeth_papers interactable + 2 responses
  - `declarations/rooms/upper_hallway.tres` — 2 adult thread_responses added
  - `declarations/rooms/master_bedroom.tres` — 4 adult thread_responses added (2 on existing thread_responses dicts, 2 on new thread_responses dicts)
  - `declarations/rooms/guest_room.tres` — 1 adult thread_response added
  - `declarations/rooms/foyer.tres` — 3 adult thread_responses added (1 new thread_responses dict on mail)
  - `declarations/rooms/attic_storage.tres` — 3 adult thread_responses added (1 new thread_responses dict on trunk)
  - `declarations/state_schema.tres` — found_elizabeth_papers state variable
- **Learnings:**
  - Adding `"adult"` to `thread_responses` alongside existing weave keys (`captive/mourning/sovereign`) is safe — the dictionary is keyed by thread ID, so adding a key is purely additive. The runtime won't select `"adult"` until `macro_thread` or `elizabeth_route` is set to that value.
  - Interactables that previously had no `thread_responses` can gain one for a single route without needing entries for all routes. The dictionary is optional and only consulted when a thread/route is active.
  - The Adult route's narrative strength is in CUMULATIVE evidence — no single clue is definitive, but by the time you reach the attic, you've seen adult handwriting in 4 rooms, adult clothing in 2, adult private effects in 3, and external testimony (Helena) confirming Elizabeth was a grown woman. The cascade design (parlor hints → hallway confirmation → bedroom guilt → library evidence → guest room witness → attic resolution) mirrors the GAME_BIBLE's Stage 7 "route-specific clue pressure."
  - The `elizabeth_papers` interactable is the one new physical addition. It uses the existing response cascade pattern (diary-conditioned → default) and the existing `play_sfx` stinger convention for major discoveries.
---

## 2026-04-07 - US-010
- Implemented the Adult route's complete late-game resolution: late-darkness rupture, lantern hook acquisition, attic music box solve, and Adult ending trigger
- Late-game transition: upper_hallway entry trigger fires when `entered_attic AND walking_stick_phase AND NOT late_darkness_active`, setting `late_darkness_active: true` and clearing `stable_house_light`. ConditionalEventDecl keeps sconces dark on re-entry.
- Lantern hook: 3-tier response cascade (taken → no-darkness → default-pickup) in attic_stairs, follows Tool Transition Pattern with `gives_item` + `set_state`
- Attic music box: 4-tier response cascade (wound → no-lantern → no-key → solve) in attic_storage as type "observation". Sets `attic_music_box_wound` and `adult_route_complete` on solve.
- Adult ending: `interaction_manager._on_game_state_changed` watches for `attic_music_box_wound` flag, fires `trigger_ending("adult")` with 6s delay (same pattern as freedom ending in puzzle_handler)
- Route completion: `trigger_ending("adult")` calls `mark_route_completed()` since "adult" is in `POSITIVE_ROUTE_ENDINGS`, recording completion and unlocking Elder
- Synced all three content layers (declaration → dialogue → scene) for attic_stairs and attic_storage
- Added 4 state variables: `late_darkness_active`, `lantern_hook_phase`, `attic_music_box_wound`, `adult_route_complete`
- Added `lantern_hook` item prototype to `item_prototypes.json`
- Added 20 new test assertions: `_test_attic_stairs_lantern_hook` (9), `_test_attic_music_box_adult_resolution` (11), and `_test_adult_route` in full playthrough (8)
- All headless tests pass: boot (exit 0), declarations (553/553, up from 549), room specs (375/375, up from 373), declared interactions (249/249, up from 226)
- Full playthrough: Adult route test path passes all 8 assertions. The previously stale `_test_freedom_route` headless failures were later repaired on `codex/ralph-integration-harvest` by updating the lane to the current sign/valise opening, explicit threshold ids, parlor-firebrand requirement, and service-hatch descent semantics. `test/e2e/test_full_playthrough.gd` now exits successfully headless.
- Renderer-backed tests (opening journey, walkthrough) require manual review with display
- Files changed:
  - `declarations/state_schema.tres` — 4 new state variables
  - `declarations/rooms/upper_hallway.tres` — late rupture trigger + conditional event + ext_resource
  - `declarations/rooms/attic_stairs.tres` — lantern hook interactable + prop + 3 responses
  - `declarations/rooms/attic_storage.tres` — attic music box interactable + prop + 4 responses + ext_resource
  - `resources/item_prototypes.json` — lantern_hook prototype
  - `scripts/interaction_manager.gd` — Adult ending trigger in _on_game_state_changed (3 lines)
  - `dialogue/attic/attic_stairs.dialogue` — lantern hook node + synced texts
  - `dialogue/attic/attic_storage.dialogue` — attic music box node
  - `test/e2e/test_declared_interactions.gd` — 2 new test functions (20 assertions)
  - `test/e2e/test_full_playthrough.gd` — _test_adult_route function (8 assertions)
  - `test/e2e/room_spec_data.gd` — attic_stairs + attic_storage interactable lists updated
  - `test/e2e/walkthrough_data.gd` — attic_stairs + attic_storage visit entries updated
  - `docs/GAME_BIBLE.md` — Adult Late Game implementation details
  - `docs/INDEX.md` — checkpoint table updated
  - `docs/checkpoints/US-010-adult-attic-resolution.md` — new: implementation checkpoint
- **Learnings:**
  - `ActionDecl` has no `trigger_ending` field — endings must be triggered through GDScript. The Adult ending uses `interaction_manager._on_game_state_changed` watching for `attic_music_box_wound`, with a 6s timer before `trigger_ending("adult")`. This matches the freedom ending pattern in puzzle_handler.gd.
  - Response cascade ordering is critical for multi-blocking-condition interactables. When both "no lantern" and "no key" conditions can be true simultaneously, the more fundamental blocker (no lantern = can't see the box) must come first in the array. First-match-wins means the player gets the most relevant feedback.
  - The `interaction_manager` match statement only tries `_handle_declared_interaction` for known types (note, painting, observation, switch, box). The "puzzle" type falls to the default `_:` case which skips declaration handling. Using type "observation" for the attic music box ensures the response cascade runs through the declaration engine correctly.
  - The late rupture condition (`entered_attic AND walking_stick_phase AND NOT late_darkness_active`) is intentionally route-agnostic. Elder and Child routes will reuse the same trigger — the route-specific divergence happens downstream (where the music box is found, what the ending means). This avoids duplicating the rupture trigger per route.
  - The stale `_test_freedom_route` failures in `test_full_playthrough.gd` were not a runtime defect; they came from obsolete test assumptions. The repaired lane now uses the real front-gate sign/valise flow, explicit connection ids, and the parlor-firebrand prerequisite for the kitchen service hatch.
  ---

## 2026-04-08 - SF-003 / SF-005 Threshold Builder Adoption
- Extended `EnvironmentDeclaration.surface_recipe_overrides` into active
  threshold-facing roles: `threshold`, `door`, `gate_leaf`, and `window`
- `RoomAssembler` now resolves and records those roles beside
  `resolved_floor_surface`, `resolved_wall_surface`, and
  `resolved_ceiling_surface`
- `ConnectionAssembly`, `DoorBuilder`, and `WindowBuilder` now consume the
  environment-owned threshold grammar directly; legacy connection/wall texture
  strings remain only as geometry/model-selection compatibility fallbacks
- `TrapdoorBuilder` now consumes the same threshold-facing substrate grammar,
  so the threshold builder stack is no longer split between env-owned surfaces
  and one raw-texture hatch exception
- `StairsBuilder` and `LadderBuilder` now consume environment-owned circulation
  roles (`stair_tread`, `stair_structure`, `stair_rail`, `ladder_rail`,
  `ladder_rung`) instead of hardcoded wood-color defaults
- authored `type = "door"` connections no longer carry compatibility mesh
  hints; ordinary thresholds now rely on the shared door builder default path
- authored hidden-door connections no longer serialize the default
  `secret_panel` presentation, `slide` mechanism, or default concealment mesh;
  `ConnectionAssembly` owns those defaults instead
- `test_declarations.gd` now fails if authored hidden-door data carries those
  default values without a real override
- the kitchen service hatch no longer serializes the default trapdoor `lift`
  mechanism; `TrapdoorBuilder` now records resolved presentation/mechanism
  metadata instead of raw declaration strings
- `DoorBuilder` now records resolved presentation/mechanism metadata too, so
  default `door_threshold`, `gate_threshold`, and `swing` policy lives in the
  shared builder instead of raw declaration strings
- the front entrance still carries its real `facade_door` presentation
  override, but no longer serializes the default `swing` mechanism
- `DoorBuilder`, `TrapdoorBuilder`, `StairsBuilder`, and `LadderBuilder` now
  record resolved `mechanism_state` / `reveal_state` metadata instead of raw
  declaration defaults
- that closes the hidden-door metadata mismatch where Area3D state could still
  say `idle` / `visible` while the shared connection logic treated it as
  concealed
- `Connection.mechanism_state` and `Connection.reveal_state` now default to
  empty strings in the schema instead of `idle` / `visible`
- builder/runtime default policy now owns those states directly without the
  old “ignore the schema default” compatibility logic
- the dead `Connection.visible_model` field is gone
- the old hidden-door `concealment_model` path is gone from the schema too
- `ConnectionAssembly` now records the resolved concealment kind directly and
  owns the default hidden-door wall mask as native procedural geometry in the
  shared builder layer
- `RoomDeclaration.legacy_window_model_hint`,
  `Connection.legacy_frame_model_hint`, and
  `Connection.legacy_panel_model_hint` are now gone from the schema
- ordinary windows and ordinary door/gate thresholds now rely on shared
  builder defaults directly; targeted mesh compatibility survives only as
  explicit builder-call input where tests still need it
- `StairsBuilder` no longer depends on `banisterbase.glb` in the default path;
  stair newels are now procedural geometry too
- Updated the environment matrix so the shared region presets now carry
  threshold/door/window/gate policy for:
  - `grounds`
  - `forecourt_lamplit`
  - `ground_floor`
  - `upper_floor`
  - `attic`
  - `basement`
  - `deep_basement`
  - `garden_mist`
  - `greenhouse_gaslit`
  - `crypt_candle`
- Updated the environment matrix for circulation policy in:
  - `ground_floor`
  - `upper_floor`
  - `attic`
  - `basement`
  - `deep_basement`
- `test_environment_probe.gd` now prints the resolved threshold surface grammar
  in addition to floor/wall/ceiling
- `test_environment_probe.gd` now also prints the resolved circulation grammar
  and probes `upper_hallway` plus `storage_basement` so stair and ladder
  adoption is visible in the runtime evidence surface
- `test/generated/test_declarations.gd` now enforces that environments
  declaring stair/ladder role grammar resolve through substrate presets whose
  `approved_builders` explicitly include `stairs_builder` / `ladder_builder`
- `test/generated/test_declarations.gd` now also derives required builders per
  room from the actual assembled envelope/connection shape:
  - every room requires `floor_builder`
  - interior rooms require `wall_builder` and `ceiling_builder`
  - window segments require `window_builder`
  - outgoing connection types require the matching threshold/circulation builder
- That room-aware gate caught and corrected real preset drift:
  - `ground_floor_warmth` now explicitly approves `trapdoor_builder`
  - `garden_mist` now explicitly approves `wall_builder` and `ceiling_builder`
- The shared material/shader substrate now has its own static contract:
  - `PBRTextureKit` exposes standardized slot support checks
  - `EstateMaterialKit` exposes recipe family/kind introspection
  - declaration validation now walks every recipe, verifies supported families
    and kinds, and verifies each referenced slot asset exists on disk
- The shared foliage shader path was upgraded instead of bypassed:
  - `estate_foliage_forward_plus.gdshader` now supports richer gust-driven sway
  - `EstateMaterialKit` exposes those controls through the foliage recipe path
    used by the hedge card substrate
- Mount-family governance is now enforced across the full substrate stack:
  - `RoomAssembler` resolves `region_id`
  - `RoomAssembler` records region/env/substrate mount-family metadata
  - `RoomAssembler` resolves final `allowed_mount_families` as the
    intersection of region, environment, and substrate policy
  - mount payloads now fail closed if they target missing slots or disallowed
    slot families
- `test/generated/test_declarations.gd` now enforces that:
  - environment mount families are approved by both the resolved substrate
    preset and the room's region
  - mount slot ids are unique per room
  - mount payloads target declared slots
  - mount payloads declare a real scene/model source
- That gate exposed and corrected more matrix drift:
  - `entrance_exterior` now admits `threshold`
  - `rear_estate` now admits the broader union required by `garden_mist`,
    `greenhouse_gaslit`, and `crypt_candle`
  - `carriage_house_isolate` now matches the `garden_mist` mount-family set it
    currently inherits
- `test_environment_probe.gd` now prints `region=` and the resolved
  `mounts=` family intersection in addition to substrate/material roles
- Runtime proof:
  - `front_gate` resolves `threshold=recipe:surface/brick_masonry`
  - `front_gate` resolves `door=recipe:surface/oak_dark`
  - `front_gate` resolves `gate_leaf=recipe:surface/wrought_iron`
  - `front_gate` resolves `window=recipe:surface/wrought_iron`
  - `foyer` resolves `threshold=recipe:surface/oak_header`
  - `foyer` resolves `door=recipe:surface/oak_dark`
  - `foyer` resolves `window=recipe:surface/oak_dark`
  - `upper_hallway` resolves `stair_tread=recipe:surface/oak_dark`
  - `upper_hallway` resolves `stair_structure=recipe:surface/oak_header`
  - `upper_hallway` resolves `stair_rail=recipe:surface/oak_dark`
  - `storage_basement` resolves `stair_tread=recipe:surface/oak_dark`
  - `storage_basement` resolves `stair_structure=recipe:surface/oak_dark`
  - `storage_basement` resolves `stair_rail=recipe:surface/wrought_iron`
  - `storage_basement` resolves `ladder_rail=recipe:surface/wrought_iron`
  - `storage_basement` resolves `ladder_rung=recipe:surface/chain_iron`
  - `front_gate` resolves `region=entrance_exterior`
  - `front_gate` resolves `mounts=path_edge,hedge_terminator,facade_anchor,gate_leaf`
  - `foyer` resolves `region=ground_floor`
  - `foyer` resolves `mounts=wall,floor,ceiling,threshold,table,shelf,sill,mantel`
  - `storage_basement` resolves `region=basement`
  - `storage_basement` resolves `mounts=wall,floor,ceiling,threshold,shelf,path_edge`
- Verification:
  - `godot --headless --path . --quit-after 1`
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- Mounted payloads are now live in representative rooms, not just declared:
  - `foyer` now mounts table lamps, a wall picture, and a route-specific upper portrait
  - `front_gate` now mounts the gate sign and gate lamp through facade anchors
  - `storage_basement` now mounts the two wall sconces through declared wall slots
- `RoomAssembler` route matching for mounted payloads now understands both
  concrete route ids (`adult`, `elder`, `child`) and broader replay/progression
  state, so route-specific mounted dressing can ride on the shared substrate
- `test/e2e/test_mount_payloads.gd` now proves the representative live mount path
- The shared material library now also covers shader-backed glass/liquid families:
  - `EstateMaterialKit` supports `shader_material`
  - supported recipe families now include `glass` and `liquid`
  - the library now owns `glass/window_glass`, `glass/facade_dark`,
    `glass/door_lamplit`, `glass/crystal_glass`,
    `glass/greenhouse_glass`, `liquid/estate_pond_water`, `liquid/wine_still`,
    `liquid/wine_agitated`, `liquid/font_still`, `liquid/font_disturbed`,
    `liquid/font_searched`, `liquid/bucket_still`, `liquid/bucket_rippled`,
    `liquid/tea_still`, and `liquid/tea_disturbed`
- Shared builders now consume the shared glass recipes directly:
  - `WindowBuilder`
  - `estate_front_door.gd`
  - `estate_entry_portico.gd`
  - `estate_mansion_facade.gd`
- A new shared scene applicator now normalizes the non-builder scene layer too:
  - `scenes/shared/shared_recipe_applicator.gd`
  - greenhouse shell panes now resolve through `glass/greenhouse_glass`
  - greenhouse lantern glass and dining wine glass shells now resolve through
    `glass/crystal_glass`
  - chapel font, kitchen bucket, parlor tea, dining wine, and pond wrappers
    now resolve through the shared `liquid/*` recipe family
  - those shared scenes no longer pin their primary glass/liquid look through
    direct `resources/water/*` or `resources/glass/*` material references
- Verification after the mount + glass/liquid substrate pass:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_mount_payloads.gd`
  - `godot --path . --script test/e2e/test_environment_probe.gd`
  - `godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- Verification after the generic shared-scene applicator pass:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --quit-after 1`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- The next repeated shared structure props are now off raw model authoring too:
  - `floor3.glb` -> `stone_slab`
  - `pillar0_002.glb` / `pillar0_003.glb` -> `plinth_tall`
  - `pillar1.glb` -> `round_pillar`
- `RoomAssembler` now owns procedural builders for those repeated structure
  pieces, and the affected declarations now author them via
  `substrate_prop_kind`
- Affected rooms:
  - `front_steps`
  - `front_gate`
  - `drive_lower`
  - `drive_upper`
  - `foyer`
- Verification after the slab/plinth/pillar migration:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- The last authored shared-structure prop holdout is gone:
  - `door1.glb` -> `facade_door_leaf`
- `front_gate` now authors the facade leaf through `substrate_prop_kind`, and
  `RoomAssembler` owns the procedural facade-door-leaf path
- Authored room declarations now contain no direct
  `res://assets/shared/structure/*.glb` prop references
- Verification after the facade-door migration:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- The repeated mansion facade / trim kit is now migrated too:
  - `SM_Door_Wall` -> `manor_wall_panel`
  - `SM_Window_Wall` -> `manor_window_panel`
  - `SM_Big_Wall` -> `manor_wing_panel`
  - `SM_Wall_Column` -> `manor_wall_column`
  - `SM_Door_Frame` -> `doorway_trim`
  - `SM_Roof` -> `manor_roof_panel`
  - `SM_Big_Roof_Molding` -> `manor_roof_molding`
  - `SM_Big_Wall_Molding` -> `manor_frieze`
- Affected declarations:
  - `front_gate`
  - `front_steps`
  - `foyer`
- Verification after the mansion facade/trim migration:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- The next contract gate is now explicit waivers rather than silent exceptions:
  - `PropDecl` adds `substrate_waiver_reason`
  - any `architectural_trim` / `threshold_trim` prop that bypasses
    `substrate_prop_kind` must now declare a waiver reason
- Current narrow waivers:
  - none in the previously identified front-gate / greenhouse slice
- The first waiver reductions are landed:
  - `front_gate_menu_sign` -> `front_gate_sign`
  - `greenhouse_glass_shell` -> `greenhouse_shell`
  - `greenhouse_hanging_lantern` -> `greenhouse_lantern`
- Those substrate kinds currently route through the existing shared scenes, but
  they now live under the substrate contract instead of exception handling
- Current authored waiver count: `0`
- Current authored `.tscn` misuse in `PropDecl.model`: `0`
- The repeated raw front-gate approach imports are now under substrate kinds
  too:
  - `lamp_mx_1_b_on.glb` -> `front_gate_lamp`
  - `tree01_winter.glb` -> `front_gate_tree_01`
  - `tree02_winter.glb` -> `front_gate_tree_02`
  - `tree03_winter.glb` -> `front_gate_tree_03`
  - `tree04_winter.glb` -> `front_gate_tree_04`
  - `bush01_winter.glb` -> `front_gate_bush_01`
  - `bush02_winter.glb` -> `front_gate_bush_02`
  - `bush03_winter.glb` -> `front_gate_bush_03`
  - `bush04_winter.glb` -> `front_gate_bush_04`
  - `rocks.glb` -> `front_gate_rocks`
  - `iron_gate.glb` -> `iron_gate_leaf_angled`
- Affected declarations:
  - `front_gate`
  - `front_steps`
  - `drive_lower`
  - `drive_upper`
- The front-gate lamp mount payload now uses `substrate_prop_kind` too, and
  the front-gate room payload now actually includes the migrated tree/bush/rock
  and facade-lamp props in its `props` array instead of leaving them as dead
  subresources
- The remaining front-gate lamp interactable visual is migrated too:
  - `gate_lamp` now uses `visual_kind = "front_gate_lamp_lit"`
  - `InteractableVisuals` owns the mapping to
    `res://assets/grounds/front_gate/lamp_mx_1_b_on.glb`
  - `front_gate.tres` no longer carries a raw lamp model path for that
    interactable
- Verification after the waiver-contract pass:
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/generated/test_declarations.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_room_specs.gd`
  - `/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --script test/e2e/test_full_playthrough.gd`
