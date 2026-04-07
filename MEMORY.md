# Memory

## Architecture Decisions

### Canonical Runtime
- `declarations/*.tres` and the declaration-driven runtime are the source of truth
- Legacy `.tscn` room scenes are fallback/reference material, not the main authored game path
- Rooms remain authoring units
- Compiled worlds are becoming the runtime traversal units

### Compiled Worlds
- Current intended runtime groupings:
  - `entrance_path_world`
  - `manor_interior_world`
  - `rear_grounds_world`
  - `service_basement_world`
- Flashbacks should be their own world/overlay state, not ordinary room transitions
- Same-world ordinary doors should be seamless by default
- Same-world vertical traversal should be embodied by default
- Hard masking belongs to inter-world swaps, endings, and flashbacks

### Procedural Architecture Stack
- Keep the stack as:
  - procedural shell
  - inset trim/frame/moulding/detail models
  - procedural moving mechanisms
- Do not replace walls or full rooms with architectural GLBs
- Source GLBs remain untouched; fitting and normalization live in code
- Stairs should remain procedural even when using banister/newel trim models

### Threshold Feel
- Thresholds are part of the game’s language, not optional polish
- Doors should open visibly before traversal
- Ladders, trapdoors, and secret passages should reveal/deploy visibly
- The first complete secret-passage benchmark is `storage_basement <-> carriage_house`

### Visual Acceptance
- Code is not enough; screenshots are acceptance artifacts
- Renderer walkthrough and opening-journey captures are the product-truth lanes
- Player-entry framing beats overview prettiness
- The opening must read as:
  - diegetic sign/menu at the front gate
  - moonlit hedge-lined approach
  - walk to the front door
  - strong foyer handoff

### Renderer Baseline
- `Forward+` is now the canonical renderer
- That switch is justified by atmosphere, transparent materials, pond/water response, volumetric fog, and glass readability
- Use the new glass shader/material stack for hero glass surfaces rather than relying on bare `StandardMaterial3D` transparency

### Stateful Setpieces
- The interactable visual-state pipeline now drives authored scene swaps, not just static models
- Chapel font is the first liquid benchmark:
  - `still`
  - `disturbed`
  - `searched`
- Kitchen bucket is the second:
  - `still`
  - `rippled`
- Parlor tea service is now the third:
  - `set`
  - `disturbed`
- Dining-room wine glass is now the fourth:
  - `still`
  - `agitated`
- The next sensible extensions are greenhouse/garden water beats, other service containers, and greenhouse/window glass rollouts

## Current Known Defects

- `front_gate` still reads as a flat stage facade instead of a convincing manor approach
- `foyer` front-door handoff still has a blocker-heavy threshold read
- Same-world traversal is better, but still not fully free continuous walk-through everywhere
- Puzzle sense and actionability have not yet been comprehensively audited from player perspective

## Validation Notes

- The renderer walkthrough now exits cleanly with no leak warning
- The opening-journey lane exists and should be used whenever the opening path changes
- Critical commands currently in use:
  - `godot --headless --path . --script test/generated/test_declarations.gd`
  - `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
  - `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
  - `godot --path . --script test/e2e/test_room_walkthrough.gd`
  - `godot --path . --script test/e2e/test_opening_journey.gd`

## Authoring Grammar

- Static scene models are always-present dressing or architectural trim
- Dynamic setpieces are stateful, interactable, and may change visual state
- Local self-contained puzzles should be explicit
- Cross-room puzzle logic should be expressible as functional roles, not just item names
- Spatial grammar matters:
  - `interior_room`
  - `exterior_ground`
  - `glazed_room`
  - `threshold_room`
  - `service_space`
