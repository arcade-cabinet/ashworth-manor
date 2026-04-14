# Ashworth Manor Substrate Foundation

## Summary

This document is the canonical authority for the shared physical language of
Ashworth Manor. `docs/GAME_BIBLE.md` remains the narrative authority for the
shipped game; this file defines the reusable visual/runtime substrate that all
rooms, routes, and evidence lanes must build on.

The current story-complete build is provisional until the substrate sweep is
complete.

## Decision Rules

- Primary architecture, terrain, hedges, gates, boundary walls, water, glass,
  and sky must come from shared builders, shaders, and factories.
- Imported models are reserved for discrete props and hero objects.
- PBRs, HDRIs, heightmaps, atlases, and decals are substrate inputs, not
  substitutes for the substrate.
- Declarations remain the source of truth. The substrate is addressed through
  declaration-facing presets, slots, and payloads.
- No deliberate PSX degradation is the target look. Existing `psx_*` systems
  remain compatibility/compositor shims until replaced.

## Primitive Families

- `surface`
- `architecture`
- `foliage`
- `terrain_path`
- `liquid_glass_sky`
- `prop`

## Shared Shader / Material Families

- `estate_surface`
- `estate_foliage`
- `estate_terrain`
- `estate_glass`
- `estate_water`
- `estate_sky_twilight`

## Builder / Factory Policy

- Architecture builders are the default path for walls, floors, ceilings,
  stairs, ladders, trapdoors, doors, windows, and thresholds.
- Exterior factories are the default path for hedge walls and terminators,
  gate posts, iron gates, fence runs, brick boundary walls, carriage roads,
  outward roads, forecourts, and entry facades.
- Shared set-dressing factories must carry repeated estate logic rather than
  one-off room hacks.

## Declaration-Facing Substrate Types

- `SubstratePresetDecl`
- `MaterialRecipeDecl`
- `TerrainPresetDecl`
- `SkyPresetDecl`
- `MountSlotDecl`
- `MountPayloadDecl`

## Environment Role Recipes

Environment declarations own the default surface grammar for shared room
envelopes and thresholds. The active role keys are:

- `floor`
- `wall`
- `ceiling`
- `threshold`
- `door`
- `gate_leaf`
- `window`
- `stair_tread`
- `stair_structure`
- `stair_rail`
- `ladder_rail`
- `ladder_rung`
- `terrain`
- `foliage`

`RoomAssembler` resolves those roles before falling back to legacy room or
connection texture strings.

For interior envelope surfaces, that fallback is now gone. Shared floor, wall,
and ceiling materials resolve from room recipe overrides or environment role
recipes only.

The old room-level `floor_texture`, `wall_texture`, and `ceiling_texture`
fields have now been removed from the declaration schema entirely. Where a room
needs an ordinary window mesh, the shared window builder now owns that path
directly via its built-in `window_clean` default.

The shared declaration contract also verifies builder approval against actual
room topology, not only against environment metadata. If a room's envelope or
connections require `wall_builder`, `ceiling_builder`, `window_builder`,
`door_builder`, `trapdoor_builder`, `stairs_builder`, or `ladder_builder`,
the resolved substrate preset must explicitly approve that builder unless the
room declares an explicit `bespoke_waiver`.

## Material Recipe Contract

- Shared recipes are resolved through `EstateMaterialKit`
- Shared slot loading/composition is resolved through `PBRTextureKit`
- Supported recipe kinds are currently:
  - `standard`
  - `foliage_shader`
  - `shader_material`
- Supported recipe families are currently:
  - `surface`
  - `terrain_path`
  - `foliage`
  - `glass`
  - `liquid`
- Supported shared slots are currently:
  - `albedo`
  - `normal`
  - `roughness`
  - `opacity`
  - `height`
  - `thickness`
  - `detail`
  - `hdri`
  - `ao`

Recipe validation is part of the declaration suite. The suite verifies that
every registered recipe uses a supported family/kind and that every declared
slot asset exists on disk.

Shared builder fallbacks also now route through the recipe library rather than
creating local one-off materials in builder files. The current explicit
fallback recipes are:

- `surface/fallback_wood`
- `surface/fallback_metal`
- `surface/shadow_void`

Those defaults now back the remaining circulation/envelope fallback paths in
stairs, ladders, windows, and portal shadow fills.

Primary envelope builders now also default in recipe-id space instead of
legacy texture-path space. The current recipe-first builder defaults are:

- floor: `surface/oak_board`
- ceiling: `surface/lining_tan`
- wall: `surface/cloth_brown`
- stairs: `surface/oak_board`, `surface/oak_header`, `surface/oak_dark`
- door: oak frame/panel for normal doors, brick plus wrought iron for gates
- window: `surface/oak_dark`
- trapdoor: `surface/oak_header` and `surface/oak_dark`

Legacy texture/model selectors may still exist as compatibility hints for mesh
selection, but the surface contract is now explicitly recipe-first.

Repeated interactable scene sets are now moving under the same explicit
substrate contract. For the current shared observation-state fixtures
(`kitchen_bucket`, `gate_luggage`, `greenhouse_pot`, `parlor_tea`,
`baptismal_font`, and `wine_glass`), declarations now author `visual_kind`
and `state_visual_kind_map` instead of direct shared `.tscn` scene paths.
`InteractableVisuals` owns the mapping from those runtime visual kinds to the
shared scene assets, and the declaration suite now fails if those repeated
fixtures fall back to direct `scene_path` / `state_model_map` authoring.

That contract is now also enforced directly in the declaration suite. The suite
contains explicit builder-default coverage proving that:

- empty builder inputs still resolve to shared recipe defaults
- gate defaults remain materially distinct from ordinary doors
- recipe ids do not silently activate door/window model heuristics

Legacy mesh-selection compatibility is now narrowed to builder-owned escape
hatches only. Door/gate mesh compatibility survives only as an explicit
builder input instead of a declaration-schema field, and hidden-door
concealment is now fully owned by the shared builder default as well. That
keeps compatibility selectors available without letting declaration data
pretend they are part of the substrate contract.

That reduction is now complete on the room and ordinary-threshold schema side:
`RoomDeclaration` no longer carries a window mesh hint field, and `Connection`
no longer carries door/gate frame or panel mesh hint fields. Ordinary windows
and ordinary thresholds now rely on shared builder defaults directly.

The same adoption has now reached stair newels too. `StairsBuilder` no longer
depends on the imported `banisterbase.glb` in the default path; the normal
stair run now uses native procedural newel geometry, with imported structure
meshes no longer sitting in the common circulation builder path by default.

The old texture-shaped compatibility selectors are gone from the ordinary
builder path. Doors and windows no longer accept texture-path or
`wall*_texture` tokens, and the common runtime no longer exposes normalized
mesh-selector ids like `door_panel_03`, `doorway_frame_00`, or `window_clean`
as part of the substrate contract.

For ordinary windows, the builder now owns the common case directly:
`WindowBuilder` always emits native procedural frame geometry. That removed the
need for any room-side window hint field, so `RoomDeclaration` no longer
carries one.

The same cleanup now applies to doors generally. Authored `type = "door"`
connections no longer carry mesh hints for their panels or frames; the shared
door builder’s native default panel path now owns that case. Any future
threshold exception now has to be introduced deliberately instead of surviving
as passive compatibility carryover.

The same reduction has now reached hidden doors too. The authored
`storage_basement <-> carriage_house` hidden-door pair no longer serializes the
default `secret_panel` presentation, `slide` mechanism, or the default
concealment mesh. `ConnectionAssembly` owns those defaults at runtime, and the
declaration suite now fails if authored hidden-door data carries those values
without a real override.

Trapdoors now follow the same rule more strictly too. The kitchen service hatch
no longer serializes the default `lift` mechanism, and `TrapdoorBuilder` now
records resolved presentation/mechanism metadata instead of raw declaration
strings. That keeps authored trapdoor data focused on real overrides like the
service-hatch presentation while leaving the default mechanism policy in the
shared builder layer.

The same cleanup now applies to ordinary doors and gates at the metadata layer.
`DoorBuilder` now records resolved presentation/mechanism metadata instead of
raw declaration strings, so default `door_threshold`, `gate_threshold`, and
`swing` policy lives in the builder. The front entrance still carries the real
`facade_door` presentation override, but no longer serializes the default
`swing` mechanism in authored data.

Resolved state ownership is now consistent across the threshold builders too.
`DoorBuilder`, `TrapdoorBuilder`, `StairsBuilder`, and `LadderBuilder` now
record resolved `mechanism_state` and `reveal_state` metadata instead of
mirroring raw declaration defaults. That closes the mismatch where hidden-door
areas could still advertise `visible` / `idle` even though the shared
connection logic already treated them as concealed.

The `Connection` schema is now neutral here as well. `mechanism_state` and
`reveal_state` default to empty strings in the declaration resource instead of
pre-populating `idle` / `visible`. That lets the shared builders and
`ConnectionAssembly` own the effective default policy directly instead of
having to detect and ignore legacy schema defaults.

The last hidden-door geometry holdout is explicit now too. The dead
`visible_model` field is gone, and the old `concealment_model` path has been
removed from the declaration schema entirely. `ConnectionAssembly` now records
the resolved concealment kind directly and builds the default hidden-door mask
as native procedural geometry in the shared builder layer.

Door and trapdoor builders now go one step further: threshold mesh/material
compatibility no longer depends on `door_texture` or `frame_texture` at all.
Those old connection-level fields have been removed from the declaration schema
entirely, and the common `DoorBuilder` path is now procedural rather than an
imported-mesh compatibility branch.

The same rule now covers the remaining legacy procedural door scripts too.
`scripts/procedural/door_single.gd` and `scripts/procedural/door_double.gd`
now default to shared recipe refs and only fall back to raw `Texture2D`
compatibility inputs if those older fields are explicitly populated. Even that
compatibility path now resolves through a shared `EstateMaterialKit`
constructor rather than local `StandardMaterial3D.new()` snippets. Those
procedural scripts now name those inputs explicitly as `legacy_*` texture
fields so they no longer read like first-class authoring channels.

The same cleanup now covers the remaining shared grounds-side shadow and glow
exceptions. `estate_front_door.gd`, `estate_entry_portico.gd`,
`estate_mansion_facade.gd`, `estate_outward_road.gd`, and
`estate_starfield.gd` no longer create local `StandardMaterial3D` instances for
void fills, village window glow, fog banks, or stars. Those paths now resolve
through shared `EstateMaterialKit` helpers instead.

That same rule now reaches the runtime assembler too. `RoomAssembler` no longer
hand-builds local materials for procedural moon props or world-label boards and
hangers; those runtime visuals now resolve through `EstateMaterialKit` as well.
It also now intercepts declaration-authored `window_clean.glb` and
`window_ray.glb` prop uses and replaces those repeated structure props with
shared procedural window and glow-plane visuals at assembly time.
The same runtime seam now covers the repeated circulation structure props too:
`stairs0.glb`, `stairbanister.glb`, and `banisterbase.glb` prop uses are now
replaced by shared procedural stair, rail, and newel geometry during assembly.
Those repeated structure props are now also represented explicitly in authored
room data via `PropDecl.substrate_prop_kind` instead of normal imported-model
authoring. The declaration suite now rejects those old shared structure model
ids unless they have been migrated to their substrate kind.

## Foliage Shader

Foliage remains shader-driven substrate, not wall-cladding by texture alone.
The shared foliage path in `shaders/foliage/estate_foliage_forward_plus.gdshader`
now exposes gust-driven sway alongside thickness-based light response, and
`EstateMaterialKit` maps those controls into reusable foliage recipes.

## Glass And Liquid Shader Recipes

Glass and liquid are now first-class shared recipe families instead of side
channels. `EstateMaterialKit` exposes shader-backed shared recipes for:

- `glass/window_glass`
- `glass/facade_dark`
- `glass/door_lamplit`
- `glass/crystal_glass`
- `glass/greenhouse_glass`
- `liquid/estate_pond_water`
- `liquid/wine_still`
- `liquid/wine_agitated`
- `liquid/font_still`
- `liquid/font_disturbed`
- `liquid/font_searched`
- `liquid/bucket_still`
- `liquid/bucket_rippled`
- `liquid/tea_still`
- `liquid/tea_disturbed`

Those recipes are now consumed directly by the shared builder path:

- `WindowBuilder` resolves panes through the shared glass recipe library
- `estate_front_door.gd` resolves sidelight/transom glazing through the shared
  door-lamplit glass recipe
- `estate_entry_portico.gd` resolves fanlight glazing through the same shared
  door-lamplit glass recipe
- `estate_mansion_facade.gd` resolves facade windows through the shared
  dark-facade glass recipe
- `scenes/shared/shared_recipe_applicator.gd` now maps shared scene mesh targets
  onto shared recipe ids for pond water, dining wine, chapel font water,
  kitchen bucket water, parlor tea, greenhouse glazing, and lantern glass

This shifts glass off local `StandardMaterial3D` snippets and into the shared
substrate contract, and it shifts the shared pond water scenes off direct
material-resource pinning and onto the shared liquid recipe path too. The old
`resources/glass/*` and `resources/water/*` assets are now compatibility
wrappers rather than the primary authored path.

## Recipe-Driven Shared Fixtures

The shared recipe path now also owns representative non-prop fixture wrappers
that had been carrying bespoke embedded material stacks. The converted scene
families are:

- greenhouse shell and hanging lantern
- greenhouse lily pedestal and both lily-pot states
- parlor tea-service states
- chapel baptismal font states

Those scenes now resolve their repeated surfaces through shared recipe ids
instead of scene-local `StandardMaterial3D` blocks. The declaration suite also
contains an explicit regression guard for those wrappers so they cannot drift
back to embedded per-scene materials without failing validation.

That regression protection now extends to the grounds-side shared scripts named
above and to the legacy procedural door scripts: the declaration suite asserts
those files do not contain local `StandardMaterial3D.new()` construction
either.

The contract is now broader than a few named scripts. Outside the actual
material factory layer (`estate_material_kit.gd` and `pbr_texture_kit.gd`),
local `StandardMaterial3D.new()` construction is now treated as a regression
across `builders/`, `engine/`, `scenes/shared/`, and `scripts/procedural/`.

## Stable Mount Families

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

Mount families are not owned by a single layer. Region, environment, and
substrate preset policy must agree. Runtime mount eligibility is the
intersection of those three layers, and mounted payloads are rejected if they
target missing slots or slot families outside that resolved intersection.

Mounted payloads are also live now, not just declared. Representative rooms
already exercising the mount path are:

- `front_gate`
- `foyer`
- `storage_basement`

Route-aware mount swaps are proven in `foyer`, where the upper portrait payload
changes between `adult/child` and `elder` route contexts.

## Region Preset Matrix

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

## Visual Direction

- Myst-like Victorian, not retro degradation as an end in itself
- Brassy, woody, lamplit, mist-forward, materially grounded
- Lighting must remain visibly sourced
- Exterior hedge corridors must read as enclosing topiary walls, not prop rows
- The outside world reads openly only where the estate design intends it

## Acceptance Rules

- A room is not accepted because it “works”; it is accepted when the capture
  surface can answer:
  - Where am I?
  - What physical logic is guiding me?
  - Why would I interact here?
  - Can I look freely without losing spatial sense?
  - Does the material and lighting read as finished?
- No critical room or route finale may bypass the shared substrate without an
  explicit waiver.

## Recent Adoption

- Repeated authored structure props now migrate through `substrate_prop_kind`
  instead of raw shared structure model ids for:
  - window frames and window rays
  - stair runs, banister runs, and newel posts
  - front-drive stone slabs
  - exterior statue plinths
  - foyer round pillars
  - the front facade door leaf
  - repeated mansion facade and trim pieces:
    wall panels, window panels, wing panels, wall columns, doorway trim,
    roof panels, roof molding, and foyer frieze trim
- `RoomAssembler` now owns the common procedural path for those repeated
  structure pieces, with declaration-authored raw structure model ids kept only
  as compatibility interception.
- Authored room declarations no longer directly reference
  `res://assets/shared/structure/*.glb` for common substrate pieces.
- The front facade and foyer trim kit no longer depend on repeated
  `res://assets/mansion_psx/models/SM_*.glb` prop authoring either.
- Remaining architectural or threshold props that still bypass
  `substrate_prop_kind` must now carry an explicit waiver reason in the
  declaration. Silent exceptions are no longer allowed.
- The first waiver reductions are now landed too:
  - `front_gate_menu_sign` -> `front_gate_sign`
  - `greenhouse_glass_shell` -> `greenhouse_shell`
  - `greenhouse_hanging_lantern` -> `greenhouse_lantern`
- There are currently no active declaration waivers in the authored room set.
- Declaration channels are now stricter too:
  scene assets must use `scene_path`; the `model` field is reserved for asset
  models and may not point at `.tscn` files.
