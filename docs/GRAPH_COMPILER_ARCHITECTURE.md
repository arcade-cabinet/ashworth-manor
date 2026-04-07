# Graph Compiler Architecture

This document defines the next-stage architecture for Ashworth Manor.

It exists because the current declaration runtime is correct in spirit but too flat in execution:

- rooms are still compiled too much like isolated boxes
- traversal builders still inject placeholder geometry into authored spaces
- exterior/interior continuity is not validated as one estate
- connection feel is too abstract for a game whose emotional language depends on doors, windows, ladders, trapdoors, and secret passages

The goal is not one giant always-live mansion scene.

The goal is one coherent **world graph** that compiles into a small number of **compiled worlds**, each of which may contain one or more authoring regions plus functional threshold assemblies.

---

## Core Rule

Ashworth Manor is one estate graph, not 20 disconnected scene islands.

Godot should treat it as:

1. one canonical graph of space and logic
2. a handful of compiled worlds loaded and unloaded by the main runtime
3. authoring regions inside those worlds
4. functional thresholds that preserve continuity between worlds and rooms

This is more aligned with Godot's strengths:

- `PackedScene` instancing
- scene composition
- on-demand loading
- explicit parent ownership in the scene tree

---

## Runtime Layers

### 1. Main Runtime

`main.tscn` remains the shell that owns:

- player controller
- UI overlay
- audio manager
- save/load
- state machine
- flashback manager
- active compiled-world lifecycle

This scene should not hand-assemble room geometry itself.

It should ask the graph compiler for the active compiled world, keep neighbor worlds prewarmed when needed, and only mask when crossing world boundaries.

### 2. World Graph

The graph remains declaration-driven.

Canonical sources:

- `declarations/world.tres`
- `declarations/rooms/*.tres`
- puzzle declarations
- state schema
- secret passage declarations

The graph defines:

- adjacency
- connection types
- locking and gating
- macro-thread and junction constraints
- intended estate topology
- entry anchors and focal anchors

### 3. Region Compiler / World Compiler

The new middle layer.

It compiles graph data into a few coherent runtime worlds.

Interim runtime today still distinguishes:

- `entrance_path_world`
- `manor_interior_world`
- `rear_grounds_world`
- `service_basement_world`

Shipped target should be simpler and truer to the estate:

- `estate_grounds_world`
- `manor_interior_world`
- `service_basement_world`

Each compiled world can contain one or more macro authoring regions. For example, the manor interior world currently spans:

- `ground_floor`
- `upper_floor`
- `attic`

These are not hand-authored `.tscn` scenes. They are generated `PackedScene` outputs or live-assembled subtrees produced from declarations plus compiler rules.

### 4. Room Specs

Room declarations remain the local authoring surface, but they stop pretending each room is a self-sufficient world box.

They should define:

- local dimensions and wall segmentation
- authored props and interactables
- room-local lights and ambient events
- entry anchors
- focal anchors
- spatial class
- exposure faces
- outlook zones
- window view mode
- allowed threshold surfaces
- local atmosphere and thread variation

### 5. Threshold Assemblies

Connections stop being generic helper geometry.

They become first-class assemblies:

- `DoorAssembly`
- `WindowAssembly`
- `TrapdoorAssembly`
- `LadderAssembly`
- `SecretPassageAssembly`
- `PathThresholdAssembly`

Each assembly owns:

- visible presentation
- collision
- interaction volume
- animation state
- locked/open/revealed state
- destination metadata

### 6. Flashback Layer

Flashbacks are not regions in the same sense as the mansion and grounds.

They are a presentation/state layer injected into the active region:

- temporary scene branch
- ghosted set dressing
- lighting override
- time-state overlay
- apparition/event sequence

This keeps the estate topology stable while allowing authored memory states.

---

## Compiled Worlds

### Estate Grounds World

Target shipped exterior world.

Contains authoring regions such as:

- `entrance_approach_region`
- `west_service_region`
- `east_garden_region`
- `rear_grounds_region`

Contains or stages rooms such as:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`
- `west_side_path`
- `east_side_path`
- `rear_court`
- `garden`
- `greenhouse`
- `carriage_house`
- `pond_edge`
- `woodland_path`
- `chapel`
- `family_crypt`

Purpose:

- prologue
- front approach
- side-circulation reveal
- rear-estate discovery
- ending frame

Important rule:

- the front gate is not the whole grounds
- the grounds should eventually read as a wraparound mansion estate

### Entrance Path World

Interim acceptable exterior slice while the grounds remain partially split.

Contains:

- region: `entrance_exterior`
- opening beats such as `front_gate`, `drive_lower`, `drive_upper`, `front_steps`

Purpose:

- support the opening sequence before the grounds are fully unified

### Manor Interior World

Contains:

regions:

- `ground_floor`
- `upper_floor`
- `attic`

rooms:

- `foyer`
- `parlor`
- `dining_room`
- `kitchen`
- `upper_hallway`
- `master_bedroom`
- `library`
- `guest_room`
- `attic_stairs`
- `attic_storage`
- `hidden_chamber`

Purpose:

- first interior read
- public/formal/service/private escalation
- room-to-room narrative escalation
- attic approach and climax

### Service Basement World

Contains:

- region: `basement`
- rooms: `storage_basement`, `boiler_room`, `wine_cellar`
- service-side secret route anchor

Purpose:

- machine/body of the house
- service knowledge
- diamond routing support

### Rear Grounds World

Interim acceptable exterior slice while the grounds remain partially split.

Contains:

- region: `rear_estate`
- rooms such as `garden`, `chapel`, `greenhouse`, `carriage_house`, `family_crypt`
- later planned rear beats such as `pond_edge` and `woodland_path`

Purpose:

- support rear discovery until the full exterior is merged into `estate_grounds_world`

---

## World Boundary Rule

Rooms are the authoring unit. Compiled worlds are the runtime traversal unit.

- Same compiled-world doors should be seamless by default.
- Same compiled-world stairs, ladders, and trapdoors should be embodied by default.
- Inter-world swaps may use soft masking and prewarm.
- Flashbacks and endings may use hard masking.

---

## Functional Connection Assemblies

The game's feel depends on these being real.

### DoorAssembly

Use for:

- standard room doors
- heavy attic doors
- double doors
- iron gates

Must support:

- hinge side
- inward/outward swing
- lock state
- key requirement
- open angle
- collision state after open
- sound hooks
- destination metadata

### WindowAssembly

Use for:

- normal windows
- boarded windows
- shuttered windows
- broken chapel windows

Must support:

- frame generation or frame model
- pane material
- boarded/shuttered variants
- window-ray attachment point
- exterior-facing light logic
- weather/visibility flags

### TrapdoorAssembly

Use for:

- basement access hatches
- floor-level hidden entries

Must support:

- hinge edge
- open animation
- open/closed collision change
- ladder deployment if attached
- sound hooks

### LadderAssembly

Use for:

- wall ladders
- drop-down attic/basement ladders

Must support:

- folded vs deployed state
- trigger mechanism
- collision/nav change when deployed
- rope/chain pull interaction

### SecretPassageAssembly

Use for:

- painting reveals
- bookcase slides
- hidden panels
- fireplace/hearth reveals
- service-route openings

Must support:

- reveal condition
- closed visual form
- opening animation
- persistent open state
- changed collision/nav after reveal
- reveal/open SFX

---

## Compiler Responsibilities

The compiler should do more than instantiate declared content.

It should validate and repair obvious bad states before the region is accepted.

### 1. Graph validation

- all required bidirectional links exist
- no region leaves required rooms disconnected
- secret passages do not bypass required puzzle slots improperly
- diamond routing remains solvable under every allowed variant

### 2. Spatial validation

- a doorway opening must align with a real threshold surface
- windows must not appear on impossible walls relative to compiled adjacency
- transition helpers must not occupy the player entry cone
- no compiled threshold assembly may intersect the default player camera volume

### 3. Composition validation

- each room needs at least one valid entry anchor
- each entry anchor must face a valid focal anchor
- large shared props must respect allowed envelope limits
- connection assemblies may not dominate the frame unless explicitly authored to do so

### 4. Presentation validation

- every major light has a visible source
- outdoor regions expose sky and distant framing
- indoor windows connect to believable exterior logic
- threshold assemblies match the declared tone of the space

---

## Self-Healing Rules

Self-healing should be conservative.

The compiler may:

- clamp known broken shared prop scales
- reject threshold geometry that enters a forbidden spawn/framing volume
- rotate to the best valid entry anchor if the authored one is blocked
- disable placeholder traversal meshes when a room already authors its own visual stairs/ladder/trapdoor

The compiler may not:

- silently rewrite puzzle logic
- move critical clue hosts across the graph
- invent missing threshold destinations

If a problem cannot be safely repaired, it should emit a validation failure.

---

## What Changes Next

### Current system

- `RoomAssembler` assembles one room at a time
- non-door connections still rely on generic helper builders
- region continuity is mostly inferred, not enforced

### Target system

1. Add graph compiler and region compiler layers
2. Add room entry anchors and focal anchors to declarations
3. Replace generic connection helper visuals with connection assemblies
4. Make traversal builders collision/interaction only unless a connection assembly explicitly owns visuals
5. Validate compiled regions against graph, spatial, and composition rules

---

## Immediate Priority

The first production step is not a full world rewrite.

It is:

1. stop non-door traversal builders from emitting ugly visual debug geometry
2. formalize connection assemblies in declarations and runtime
3. add entry/focal anchor validation
4. compile the mansion in macro regions rather than isolated room boxes

That path preserves the current declaration investment while moving the runtime toward a mansion that behaves like one coherent place.
