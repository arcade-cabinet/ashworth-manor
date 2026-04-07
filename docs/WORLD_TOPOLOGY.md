# World Topology Plan

This document defines the canonical spatial model for Ashworth Manor.

It exists to reconcile:

- the master script
- the room-by-room design docs
- the declaration/runtime world graph
- the intended shipped player journey

This is the authority for routing and domain structure. Runtime declarations
must align to this document, not the other way around.

Compiler direction:

- the estate validates as one coherent graph
- the mansion and grounds are authored as contiguous places
- runtime compiles them into a small number of coherent worlds
- thresholds are functional assemblies, not placeholder connectors

See:

- `docs/GRAPH_COMPILER_ARCHITECTURE.md`
- `docs/GROUNDS_WORLD_SPEC.md`
- `docs/GROUNDS_TABLEAUX.md`

---

## Core Rule

Ashworth Manor is one coherent estate with staged access.

The player should feel:

- a controlled ceremonial arrival
- a believable front-to-side-to-rear estate geography
- a strong threshold once inside the house
- later realization that the grounds wrap around the mansion as a real property

The grounds are not one flat bucket of "outside."

They are one exterior topology with three progression zones:

- `Front Approach`
- `Side Circulation`
- `Rear Discovery Grounds`

---

## Canonical Estate Domains

### 1. Front Approach

Purpose:

- prologue
- theatrical arrival
- mansion framing
- final return frame for endings

Canonical authored beats:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`

Design role:

- New Game begins at `front_gate`
- the diegetic menu belongs at the gate threshold
- the player then walks the hedge-lined drive toward the mansion
- `front_steps` is the front-door commitment beat before `foyer`

Important rule:

- `front_gate` is not "the whole grounds"
- it is only the first beat of the approach

### 2. Public Interior

Purpose:

- social face of the house
- ground-floor orientation
- first-act narrative setup

Rooms:

- `foyer`
- `parlor`
- `dining_room`
- `upper_hallway`
- `guest_room`

### 3. Service Interior

Purpose:

- practical circulation
- servant knowledge
- backstage truth
- plausible hidden-routing anchor

Rooms:

- `kitchen`
- `storage_basement`
- `boiler_room`
- `wine_cellar`

### 4. Private / Forbidden Interior

Purpose:

- family secrecy
- key revelations
- vertical escalation

Rooms:

- `master_bedroom`
- `library`
- `attic_stairs`
- `attic_storage`
- `hidden_chamber`

### 5. Side Circulation

Purpose:

- believable mansion wraparound
- class-coded circulation split
- foreshadowing of the larger estate

Canonical authored beats:

- `west_side_path`
- `east_side_path`

Design role:

- both branches split from the forecourt / front-steps area
- west side reads as service access toward `carriage_house`
- east side reads as garden-side access toward `greenhouse`

### 6. Rear Discovery Grounds

Purpose:

- reveal the back of the estate as a real place
- host deeper outdoor discovery
- hold the sacred, burial, reflective, and boundary landscapes

Existing rooms:

- `garden`
- `chapel`
- `greenhouse`
- `carriage_house`
- `family_crypt`

Planned authored beats:

- `rear_court`
- `pond_edge`
- `woodland_path`

---

## Canonical Exterior Graph

### Structural Topology

```text
front_gate -> drive_lower -> drive_upper -> front_steps -> foyer
front_steps -> west_side_path -> carriage_house
front_steps -> east_side_path -> greenhouse
west_side_path -> rear_court
east_side_path -> rear_court
rear_court -> garden
garden -> pond_edge
garden -> woodland_path
woodland_path -> chapel
woodland_path -> family_crypt
```

This is the intended shipped topology.

### Progression Topology

The whole exterior structure exists as one estate logic graph, but access should
be staged.

Act I:

- only the front approach is open

Act II:

- one or both side routes become available

Act III:

- rear grounds become fully legible as part of the estate

---

## Legacy Graph Problems

The older room graph overloaded `front_gate`.

That produced three bad results:

- the ceremonial approach had to carry too many unrelated spatial jobs
- the opening looked like a stage instead of a journey
- the grounds felt disconnected instead of wraparound

The old mental model was too close to:

```text
front_gate = all front exterior
garden = all rear exterior
```

That is not a believable mansion property.

The corrected model is:

- `front_gate` is the threshold
- the drive is a sequence
- the forecourt is the split
- the sides wrap around the house
- the rear is a real domain

---

## Routing Decisions By Exterior Space

### `front_gate`

Status:

- keep as the opening threshold and return frame

Do:

- keep diegetic menu here
- keep plaque / gate / luggage / bench / lamp observations here
- use it to frame the estate and endings

Do not:

- make it the full grounds exploration hub
- route greenhouse or carriage access directly off it

### `drive_lower` and `drive_upper`

Status:

- planned new authored spaces

Role:

- make the approach feel long enough and wealthy enough
- keep hedges and tree masses occluding side views
- escalate the facade read as the player advances

### `front_steps`

Status:

- planned new authored space

Role:

- front-door commitment beat
- branch point to both side paths
- hinge between ceremonial arrival and estate circulation

### `west_side_path`

Status:

- planned new authored space

Role:

- service-side access
- rougher, more practical, more hidden
- leads toward `carriage_house` and rear service circulation

### `east_side_path`

Status:

- planned new authored space

Role:

- ornamental garden-side access
- cleaner planting and greenhouse adjacency
- leads toward `greenhouse` and rear garden circulation

### `rear_court`

Status:

- planned new authored space

Role:

- back-of-house read
- hardscape transition from side routes to rear grounds

### `pond_edge`

Status:

- approved new authored space

Role:

- reflective moonlit landscape
- melancholic exterior beat
- spatial depth beyond greenhouse / garden zone

### `woodland_path`

Status:

- approved new authored space

Role:

- boundary occlusion
- dread corridor
- route to `chapel` and `family_crypt`

---

## Estate Logic Rules

### Visibility Rule

The player should not be able to casually see off the estate from the front
approach.

Use:

- clipped hedges
- side gates
- tree masses
- wall segments
- house wings

### Class Rule

The west and east sides should not feel identical.

West:

- service
- carriage
- maintenance
- rougher circulation

East:

- ornamental
- cultivated
- greenhouse adjacency
- quieter beauty

### Rear Rule

The rear should feel larger, stranger, and more secluded than the front.

It is where:

- the pond adds reflection and lyrical dread
- the woods hide the estate boundary
- the chapel and crypt gain proper context

---

## Current Implementation Reality

The live runtime is not fully here yet.

Current interim state:

- `front_gate` still carries too much of the opening approach
- the grounds are only partially broken into separate authoring rooms
- `garden`, `greenhouse`, `carriage_house`, `chapel`, and `family_crypt` still behave like a discovery cluster rather than a fully wrapped property

Shipped target:

- the approach is split into multiple exterior rooms
- the side paths wrap around the house
- the rear includes pond and woods
- the player eventually reads the whole estate as one place
