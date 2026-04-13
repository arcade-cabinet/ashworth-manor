# Water System

Ashworth Manor now has a project-local stylized water surface pipeline.

The purchased `godot-stylized-water` package is kept in the repo root as the
vendor source, but the reusable shader pieces used by the game now live in the
project itself:

- `res://shaders/water/stylized_water_surface.gdshader`
- `res://shaders/water/stylized_underwater.gdshader`

Current authored wrappers:

- `res://scenes/shared/water/estate_water_surface.tscn`
- `res://scenes/shared/water/estate_pond_water.tscn`
- `res://scenes/shared/chapel/baptismal_font_still.tscn`
- `res://scenes/shared/chapel/baptismal_font_disturbed.tscn`
- `res://scenes/shared/chapel/baptismal_font_searched.tscn`
- `res://scenes/shared/kitchen/kitchen_bucket_still.tscn`
- `res://scenes/shared/kitchen/kitchen_bucket_rippled.tscn`
- `res://scenes/shared/parlor/parlor_tea_service_set.tscn`
- `res://scenes/shared/parlor/parlor_tea_service_disturbed.tscn`
- `res://scenes/shared/dining_room/dining_wine_glass_still.tscn`
- `res://scenes/shared/dining_room/dining_wine_glass_agitated.tscn`

Current shared recipe applicator:

- `res://scenes/shared/shared_recipe_applicator.gd`

Current shared liquid recipes:

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

Legacy tuned material resources still exist under `res://resources/water/`, but
they are now compatibility wrappers rather than the primary authored path for
shared scenes.

---

## Core Rule

This is a **visual water system**, not a full fluid simulation system.

That is the correct fit for Ashworth Manor.

The game needs:

- convincing moonlit pond surfaces
- fonts, basins, troughs, and bucket contents
- fill-state visuals for puzzle objects
- controlled pour/reveal/readability beats

The game does **not** need:

- freeform Navier-Stokes simulation
- physically correct liquid transfer
- splash-heavy arcade behavior

---

## Intended Uses

### 1. Large Exterior Water

Use for:

- `pond_edge`
- greenhouse-adjacent troughs
- ornamental basins if added later

Preferred wrapper:

- `res://scenes/shared/water/estate_pond_water.tscn`

This should read as:

- dark
- reflective
- moonlit
- calm enough for dread, not ocean spectacle

### 2. Small Architectural Water

Use for:

- chapel font
- greenhouse wash basins
- service buckets or troughs

Preferred wrapper:

- `res://scenes/shared/water/estate_water_surface.tscn`
- or a room-specific authored wrapper such as the chapel font scenes above

These are not “ponds in miniature.” They now resolve through dedicated
`liquid/*` recipes for the actual fiction of the scene rather than all
pretending to be one pond material.

### 3. Fill-State Puzzle Visuals

Use for:

- teapot empty / filled
- tea cup empty / filled
- bucket empty / filled
- grease can empty / filled
- ritual vessel empty / filled

The correct implementation is:

- declaration-authored state changes
- authored model or scene swaps
- optional small shader-based water inserts where the container opening is visible

Not:

- real simulated pouring

---

## Relation To Puzzle Grammar

The current repo already has the beginning of the right authoring model:

- `InteractableDecl.default_visual_state`
- `InteractableDecl.state_model_map`
- `InteractableDecl.state_tags`

Those fields should drive liquid-state presentation for puzzle objects.

The important distinction is:

- `functional role`: “vessel containing liquid”
- `visual state`: empty, filled, pourable, spent

Different objects can satisfy the same functional role while presenting
different fiction:

- tea in a teapot
- grease in a can
- holy water in a vessel

---

## Authoring Guidance

Use direct GLBs for:

- static buckets
- empty basins
- frozen water meshes

Use `scene_path` on `PropDecl` when the object needs a small authored scene that
combines:

- a mesh container or surround
- a tuned water surface scene
- placement offsets that are awkward to encode as one GLB

This is why `PropDecl` now supports both:

- `model`
- `scene_path`

---

## Current Limitations

Right now the runtime supports scene-based props, and liquid/stateful objects
can now consume declared visual-state swaps for interactables as well as
scene-based props.

The correct next implementation step for liquid gameplay is:

1. keep adding empty/filled or calm/agitated recipe coverage as new vessel types appear
2. let declarations choose between shared wrappers and state-scene swaps
3. reserve the larger water surface wrappers for estate-scale and basin-scale uses

That keeps the game authored, readable, and mechanically tractable.
