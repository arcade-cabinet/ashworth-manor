# Grounds Tableaux

This document defines the visual thesis for each exterior beat.

The rule is simple:

Every inch of the world must read like a deliberate tableau.

That means each space needs:

- a clear first frame
- a dominant silhouette
- visible physical light logic
- meaningful occlusion
- a spatial promise that makes the player want to advance

This applies especially to the grounds, where bad composition quickly becomes
"empty map" instead of "estate."

---

## Core Exterior Composition Rules

### 1. Never show pointless empty perimeter

If the player can see beyond the useful estate shape, the illusion collapses.

Use:

- hedges
- house wings
- side gates
- tree lines
- walls
- pond edge curvature
- woodland density

### 2. Every major beat needs one dominant destination

The player should know what the image is "about."

Examples:

- gate sign and mansion pull
- illuminated front door
- side gate and service path
- greenhouse glass
- carriage-house lantern
- moonlit pond
- chapel silhouette

### 3. Light must be physical

Exterior night light sources should come from:

- moon
- gas lamps
- lit windows
- greenhouse interior glow
- carriage-house/service lanterns
- chapel candles or slit-window bleed

### 4. Branches should feel socially different

West side:

- servant / carriage / practical

East side:

- ornamental / cultivated / genteel

Rear:

- secluded / uncanny / memory-haunted

---

## Exterior Beat Specs

### `front_gate`

First frame:

- diegetic hanging sign boards at the gate
- gate pillars and broken-open iron leaves
- mansion far beyond the hedge-lined drive
- visible moon in sky

Dominant read:

- trespass into wealth

Must show:

- menu sign as part of the world
- one living gas lamp
- one dead or dim counterpart
- clipped hedge corridor beginning beyond the gate

Must hide:

- meaningless side voids
- rear-estate reveal
- obvious map edges

Likely assets:

- current gate set in repo
- PSX metal gates
- hedge maze pack side gates
- winter tree masses

### `drive_lower`

First frame:

- path tightening between hedges
- mansion still distant but stronger
- trees and walls preventing lateral escape

Dominant read:

- ceremonial approach

Must show:

- paving/gravel rhythm underfoot
- hedge walls on both sides
- stronger facade pull than at `front_gate`

Must hide:

- side branches
- rear grounds

### `drive_upper`

First frame:

- mansion facade now fills much more of the horizon
- side hedge termini and branch hints begin to appear
- front steps are imminent

Dominant read:

- arrival becoming commitment

Must show:

- stronger vertical facade mass
- warmer window / door glow
- more formal hardscape

Must hide:

- too much of the side routes at once

### `front_steps`

First frame:

- grand stair or forecourt threshold up to the front door
- clear branch cues to west and east
- front door as immediate commitment

Dominant read:

- the mansion choosing between public entrance and side circulation

Must show:

- grand stair geometry or strong forecourt rise
- open or ajar front door with warm spill
- side gates or hedge breaks leading left/right

Must hide:

- the full rear grounds

### `west_side_path`

First frame:

- narrower path hugging house wall and hedge
- service lantern or side-door light
- route bending toward carriage side

Dominant read:

- backstage circulation

Must show:

- rougher ground
- tighter path
- servant/service character

Must hide:

- ornamental garden-side beauty language

### `east_side_path`

First frame:

- cleaner path
- more cultivated planting
- greenhouse promise ahead through glass or reflected light

Dominant read:

- cultivated side of the estate

Must show:

- formal edging
- more ornamental planting
- glimpse or glow of greenhouse structure

Must hide:

- service grime and carriage logic

### `rear_court`

First frame:

- back of house as architecture
- branching out into grounds rather than approaching the house

Dominant read:

- the mansion as a full object, not a front facade only

Must show:

- rear hardscape
- back doors, terraces, or yard edge
- lines toward garden / carriage / greenhouse zones

### `garden`

First frame:

- formal rear garden spine
- enough symmetry to feel once-maintained
- enough decay to feel haunted

Dominant read:

- cultivated memory

Must show:

- formal beds or path logic
- route toward pond or woods
- distant chapel/crypt hints only if composition supports them

### `pond_edge`

First frame:

- moon reflected in still dark water
- stone edging or bank profile
- dead lilies / reeds / possible small jetty ruin

Dominant read:

- lyrical dread

Must show:

- reflection
- water edge shape
- one strong silhouette element on the bank

Likely implementation:

- authored scene prop `res://scenes/shared/water/estate_pond_water.tscn`
- project-local `res://shaders/water/stylized_water_surface.gdshader` tuned
  down to a calm moonlit pond
- stone edging from structure kits
- bush/tree/reed dressing from current assets

### `woodland_path`

First frame:

- narrow path swallowed by winter trees
- crypt/chapel branch ambiguity

Dominant read:

- boundary dread

Must show:

- dense tree-line compression
- low visibility depth
- pathway commitment into darkness

Must hide:

- obvious skybox edge
- flat empty clearings

### `greenhouse`

First frame:

- glass enclosure thesis
- warm life inside cold estate

Dominant read:

- impossible preservation

Must show:

- glass silhouette
- cultivated interior remnants
- relation back to the garden side

### `carriage_house`

First frame:

- carriage/work/service identity
- believable side-yard or service-yard adjacency

Dominant read:

- labor and storage

Must show:

- practical clutter
- carriage logic
- lantern or low practical light

### `chapel`

First frame:

- sacred silhouette in the woods/rear estate

Dominant read:

- private devotion corrupted by distance and secrecy

Must show:

- chapel profile
- path arrival
- strong moon or candle logic

### `family_crypt`

First frame:

- hard stone and iron
- burial closure

Dominant read:

- sealed family shame

Must show:

- gate, stone, markers
- low approach angle or compression through trees

---

## Asset Notes

Current PSX asset scan says:

- gates: well covered
- hedge / bush systems: very well covered
- winter trees / wooded boundary: well covered
- pond-specific hero assets: thin

So exterior implementation should bias toward:

- procedural path and water surfaces
- model-assisted gates, hedges, fences, and tree lines
- careful composition before new asset requests

Likely future asset request only if needed:

- dedicated PSX pond edge / jetty / dock hero pieces
