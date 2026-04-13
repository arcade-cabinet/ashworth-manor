# SF-001 Substrate Inventory

## Summary

This checkpoint records the first hard substrate freeze census and the repo
decision rules that now govern implementation.

## Repo Inventory

- `engine/declarations/`
  - declaration runtime is the canonical authoring layer
  - substrate-facing declaration classes now exist for presets, slots, and payloads
- `builders/`
  - shared builders exist for floors, ceilings, walls, doors, windows, stairs,
    ladders, trapdoors, and connection assembly
  - material and substrate registries are now the shared entry point for surface policy
- `shaders/`
  - active shared shader families currently present for foliage, glass, materials,
    water, and compatibility/compositor surfaces
- `scenes/shared/`
  - grounds builders/factories are currently the most mature shared exterior family
  - stateful scene surfaces exist for a smaller set of prop-like situations

## NAS Inventory

- `/Volumes/home/assets/2DPhotorealistic`
  - `ATLAS/1K-JPG`
  - `DECAL/1K-JPG`
  - `HDRI/1K`
  - `MATERIAL/1K-JPG`
  - `PLAIN/*`
  - `TERRAIN/*`

## Decision Rules Locked

- use `tree` for curated inventory passes rather than broad repeated searches
- primary architecture and estate topology must come from shared builders/factories
- foliage atlases are shader inputs, not direct hedge-wall materials
- HDRIs are optional backing, not the primary authored sky solution
- imported models remain prop-only unless a waiver is recorded

## Active Contract

- substrate authority
  - `docs/SUBSTRATE_FOUNDATION.md`
- active execution contract
  - `docs/batches/hard-substrate-freeze.md`
- whole-game scope contract
  - `docs/batches/ashworth-master-task-graph.md`

## Verification

- `godot --headless --path . --quit-after 1`
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_environment_probe.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`

## Notes

- The first substrate-layer regressions were foundational rather than content
  defects:
  - custom declaration/resource types needed explicit preload-based typing
  - `room_manager.gd` needed explicit `RoomAssembler` script instantiation
  - substrate helper constant tables had to be rewritten into forms Godot would
    accept as compile-time constants
- Those regressions are now fixed and the initial repo-local validation surface
  is green again.
- Terrain and sky preset ids are no longer decorative strings:
  - concrete terrain presets now live under `declarations/terrain_presets/`
  - concrete sky presets now live under `declarations/sky_presets/`
  - `PSXBridge` resolves sky presets into runtime sky declarations
  - exterior floor assembly now resolves through the declared terrain preset
    base recipe
- Current runtime proof:
  - `front_gate` resolves `terrain=carriage_approach`
  - `front_gate` resolves `sky_preset=grounds_twilight_sky`
  - `front_gate` resolves `floor=recipe:terrain/carriage_road`
- Current interior runtime proof:
  - `foyer` resolves `env=ground_floor`
  - `foyer` resolves `floor=recipe:surface/oak_board`
  - `foyer` resolves `wall=recipe:surface/cloth_brown`
  - `foyer` resolves `ceiling=recipe:surface/lining_tan`
- Current threshold runtime proof:
  - `front_gate` resolves `threshold=recipe:surface/brick_masonry`
  - `front_gate` resolves `door=recipe:surface/oak_dark`
  - `front_gate` resolves `gate_leaf=recipe:surface/wrought_iron`
  - `front_gate` resolves `window=recipe:surface/wrought_iron`
  - `foyer` resolves `threshold=recipe:surface/oak_header`
  - `foyer` resolves `door=recipe:surface/oak_dark`
  - `foyer` resolves `window=recipe:surface/oak_dark`
- Current circulation runtime proof:
  - `upper_hallway` resolves `stair_tread=recipe:surface/oak_dark`
  - `upper_hallway` resolves `stair_structure=recipe:surface/oak_header`
  - `upper_hallway` resolves `stair_rail=recipe:surface/oak_dark`
  - `storage_basement` resolves `stair_tread=recipe:surface/oak_dark`
  - `storage_basement` resolves `stair_structure=recipe:surface/oak_dark`
  - `storage_basement` resolves `stair_rail=recipe:surface/wrought_iron`
  - `storage_basement` resolves `ladder_rail=recipe:surface/wrought_iron`
  - `storage_basement` resolves `ladder_rung=recipe:surface/chain_iron`
- The environment matrix now carries direct role recipes for:
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
- The environment matrix role grammar now covers:
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
- The shared threshold builder stack now adopts that grammar across:
  - `DoorBuilder`
  - `WindowBuilder`
  - `TrapdoorBuilder`
  - `ConnectionAssembly`
- The shared circulation builder stack now adopts that grammar across:
  - `StairsBuilder`
  - `LadderBuilder`
- The static substrate contract now also couples role grammar to builder
  approval:
  - declaration validation checks that environments declaring stair roles
    resolve through substrate presets approving `stairs_builder`
  - declaration validation checks that environments declaring ladder roles
    resolve through substrate presets approving `ladder_builder`
- The static substrate contract is now room-aware:
  - declaration validation derives required builders from each room's actual
    envelope and outgoing connection types instead of only looking at declared
    environment role keys
  - this catches drift where a room uses a builder through topology/runtime but
    the resolved substrate preset forgot to approve it
  - current examples fixed under that gate:
    `ground_floor_warmth` now approves `trapdoor_builder`, and `garden_mist`
    now approves `wall_builder` / `ceiling_builder` because it currently
    covers the chapel
- The material/shader library is now part of the audited substrate inventory:
  - recipe validation walks every `EstateMaterialKit` recipe id
  - supported recipe family and kind are checked explicitly
  - every normalized slot path is verified against the project filesystem
  - the shared foliage shader remains a first-class substrate primitive rather
    than an ad hoc scene material
  - `shader_material` is now a supported shared recipe kind alongside
    `standard` and `foliage_shader`
  - shared recipe families now explicitly include `glass` and `liquid`
  - the shared recipe inventory now includes shader-backed glass/liquid entries
    for estate windows, facade glass, lamplit threshold glass, greenhouse
    glazing, crystal glass, pond water, dining wine, chapel font water,
    kitchen bucket water, and parlor tea
- Current shared glass runtime proof:
  - `WindowBuilder` now resolves panes through `glass/window_glass`
  - `estate_front_door.gd` now resolves sidelight/transom glazing through
    `glass/door_lamplit`
  - `estate_entry_portico.gd` now resolves fanlight glazing through
    `glass/door_lamplit`
  - `estate_mansion_facade.gd` now resolves facade glazing through
    `glass/facade_dark`
  - `shared_recipe_applicator.gd` now resolves greenhouse shell panes through
    `glass/greenhouse_glass`
  - `shared_recipe_applicator.gd` now resolves lantern and dining glass scenes
    through `glass/crystal_glass`
  - `shared_recipe_applicator.gd` now resolves pond water, dining wine,
    chapel font water, kitchen bucket water, and parlor tea through the shared
    `liquid/*` recipe family
- Mount governance is now part of the audited substrate inventory too:
  - final allowed mount families are resolved as the intersection of region,
    environment, and substrate policy
  - environment mount families must be approved by both the room's region and
    the resolved substrate preset
  - mount slot ids must be unique per room
  - mount payloads must target declared slots and provide a scene/model source
  - runtime skips disallowed or orphaned payload mounts instead of accepting
    them silently
- Current mount runtime proof:
  - `front_gate` resolves `region=entrance_exterior`
  - `front_gate` resolves `mounts=path_edge,hedge_terminator,facade_anchor,gate_leaf`
  - `foyer` resolves `region=ground_floor`
  - `foyer` resolves `mounts=wall,floor,ceiling,threshold,table,shelf,sill,mantel`
  - `storage_basement` resolves `region=basement`
  - `storage_basement` resolves `mounts=wall,floor,ceiling,threshold,shelf,path_edge`
  - `foyer` mounts west/east table lamps plus route-aware upper portrait payloads
  - `front_gate` mounts the gate sign and gate lamp through declared facade anchors
  - `storage_basement` mounts the two wall sconces through declared wall slots
  - route-aware mount payload swapping is now proven by `test_mount_payloads.gd`
