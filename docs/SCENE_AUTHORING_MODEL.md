# Scene Authoring Model

This document defines the intended scene grammar for Ashworth Manor.

It exists to keep the docs, declarations, runtime, and asset map aligned around the same mental model.

---

## Core Rule

Every playable space is authored as:

1. the room shell
2. static scene models
3. dynamic/stateful setpieces
4. self-contained local puzzles
5. cross-room diamond weaving

If those categories blur together, rooms become hard to compile, hard to validate, and hard to reason about visually.

---

## 1. Room Shell

The shell is the stable spatial container:

- room dimensions
- floor, wall, and ceiling textures
- openings in walls
- entry anchors
- focal anchors
- lighting volumes
- ambient and environmental feel

The shell should be mostly procedural and texture-driven.

For architecture, the intended stack is:

`procedural shell -> inset trim/moulding model -> procedural moving piece`

Examples:

- procedural wall with wall texture
- inset doorway/window moulding model scaled to fit that opening
- procedural door panel or window pane inside the opening

This keeps scale, animation, and collision sane.

For Ashworth Manor, the default bias should now be even stronger:

- primitive shapes first
- estate material families second
- imported models only where silhouette complexity genuinely matters

See [`/Users/jbogaty/src/arcade-cabinet/ashworth-manor/docs/SHAPE_KIT_SYSTEM.md`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/docs/SHAPE_KIT_SYSTEM.md).

### Spatial Grammar

The current game needs more than a binary `is_exterior`.

Each room should declare what kind of space it is, because outlook logic changes by type:

- `interior_room`
  - enclosed domestic or clue room
  - windows are framed outlook moments
- `exterior_ground`
  - outside navigable estate space under sky
  - facade, path, horizon, and silhouette dominate
- `glazed_room`
  - a room whose enclosure is visibly glass and whose orientation changes the read
  - greenhouse is the clearest example
- `threshold_room`
  - ascent, descent, entry, and commitment spaces
  - foyer and attic stairwell are both threshold-driven
- `service_space`
  - circulation and maintenance spaces where hidden routes and infrastructure matter

Each room can also declare:

- `exposure_faces`
  - which sides meaningfully expose the player to sky, grounds, facade, or glass
- `outlook_zones`
  - what those sides are supposed to read as
- `window_view_mode`
  - whether an opening should behave like a local outlook, distant backdrop, facade read, or glazed enclosure

This matters because:

- an exterior approach wants sky and destination
- a manor wing room wants an outlook framed in a window
- a greenhouse must read differently when facing the house-side return path than when facing the glass envelope itself

---

## 2. Static Scene Models

These are always present and do heavy environmental storytelling:

- table
- chairs
- fireplace surround
- bookshelf
- bed
- sideboard
- rugs
- candlesticks
- framing and moulding details

Static models are not puzzle state.

They are declared as `PropDecl` and should answer:

- what is always in this room
- what gives the room its silhouette
- what supports the first frame composition

`PropDecl` may point to either:

- a direct GLB model
- an authored `scene_path` wrapper for composite environmental props

Use `scene_path` when the prop is still static in gameplay terms but needs a
small authored scene to combine procedural and shader-driven parts. Example:
a future `pond_edge` water surface can be a scene prop that wraps a tuned water
shader rather than a static mesh.

---

## 3. Dynamic / Stateful Setpieces

These are the objects that can change meaning or state:

- teapot empty / full
- lamp off / on
- trapdoor closed / opened / lowered
- ladder hidden / deployed
- painting inert / opened into secret passage
- box closed / unlocked / opened

These are declared as `InteractableDecl`.

They can:

- change visible state
- yield inventory
- respond differently per condition
- unlock thresholds
- become inert on one branch and active on another

They should be treated as **setpieces**, not generic props.

### Authoring Balance For Stateful Things

Yes, this needs a stricter rule than we have had so far.

The correct default is:

- the more something changes state, moves, opens, lowers, fills, drains, or reveals,
  the more procedural its core should be
- the more something is pure dressing and silhouette, the more model-driven it can be
- hero setpieces usually want a hybrid

So the project should prefer three buckets:

#### A. Procedural-first stateful mechanisms

Use mostly procedural geometry plus textures for:

- doors
- windows
- gates
- trapdoors
- ladders
- stairs
- secret-passage panels
- any moving threshold part
- simple liquid surfaces or fill inserts

Why:

- easier to scale
- easier to animate
- easier to keep collision honest
- easier to make state transitions readable

#### B. Hybrid hero setpieces

Use a procedural core plus inset models/trim for:

- baptismal font
- fireplace surrounds with moving grate or flame logic
- greenhouse basins and troughs
- bookcases that open
- ritual tables or altars with changing surface state
- vessels whose body is modeled but whose contents are procedural or state-swapped

This is often the sweet spot for Ashworth Manor.

Examples:

- modeled teapot body, but authored/procedural liquid insert or explicit empty/filled state swap
- procedural font bowl and pedestal, but modeled trim and ornament
- procedural hidden panel motion, but modeled painting frame or moulding

#### C. Model-first static dressing

Use mostly direct models for:

- chairs
- rugs
- sideboards
- static books
- static luggage
- inert bottles
- decorative statuary
- trim that never changes state

These exist to support the tableau, not to become a mini-system.

### Practical Rule Of Thumb

If the player must notice the state change, the changing part should usually not
be a fixed sculpted GLB.

It should be one of:

- procedural geometry
- a small authored scene with procedural pieces and trim
- explicit visual-state swaps driven by declaration state

That is especially true for:

- liquid containers
- opening panels
- lowered ladders
- trapdoors
- visible lock/unlock states
- secret passages

---

## 4. Self-Contained Local Puzzles

A self-contained puzzle is solvable from one room or one tightly linked setpiece cluster.

Examples:

- unlock bookcase to reveal secret passage
- use a key on the right lock in the same room
- heat a vessel
- fill a vessel
- combine two nearby clues to open a local threshold

These should feel understandable in local space, even if their payoff feeds a larger graph.

---

## 5. Diamond Weaving

Ashworth Manor also uses cross-room A/B/C cause-effect structures.

### Macro

The emotional thread:

- `captive`
- `mourning`
- `sovereign`

This changes interpretation and some branch preference, but does not change the core scene grammar.

### Meso

The diamond branch:

- `A` side: one possible way to produce a functional role
- `B` side: a different way to produce that same functional role
- `C` side: consume that role to advance the story

Example:

- `A`: a teapot can be filled and pour tea
- `B`: a can can be filled with grease
- `C`: a later action needs a vessel containing liquid

Different object fiction, same functional role.

### Micro

The small trigger/state edges inside a room:

- tap teapot
- set `teapot_filled`
- pour into cup
- add filled cup to inventory
- reveal clue text

Micro edges should stay readable inside one room even when they serve a meso diamond.

---

## Asset Intent

The repo already contains:

- models for framing, trim, moulding, banisters, doorway/window details
- textures for walls, doors, windows, floors, ceilings
- sounds for threshold and atmosphere work

So the intended assembly is not:

- giant monolithic architectural GLB as the whole room

It is:

- procedural room shell using textures
- models used as inset details where shape matters
- procedural moving parts where animation/state matters

This is especially important for:

- doors
- windows
- trapdoors
- ladders
- stairs
- secret passages

because those need convincing animation, collision, and state changes.

---

## Authoring Checklist

For each room, the declarations should let us answer:

- what is the room shell
- what models are always present
- which objects are dynamic and can change state
- which puzzle is self-contained here
- which diamond branch roles are produced or consumed here
- what the first frame should communicate

If a room cannot answer those questions from its declarations and docs, the room spec is too fuzzy.
