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
