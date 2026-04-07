# Environment Design

This document summarizes the intended shipped estate layout and environmental zoning.

## Estate Structure

Ashworth Manor is one coherent estate with one exterior topology and staged access.

The exterior is best understood as:

- `Front Approach`: gate, hedge-lined drive, and front steps
- `Side Circulation`: west/service and east/garden-side wraparound routes
- `Rear Grounds`: rear court, garden, pond, woods, chapel, crypt, greenhouse, carriage house

The live declaration world graph is still partially split, but the shipped goal
is one coherent grounds world.

## Spatial Layers

### Interior
- Ground Floor: public/formal rooms
- Upper Floor: private family rooms
- Basement / Deep Basement: service depth and buried truth
- Attic: confinement, revelation, endgame

### Exterior
- `front_gate`, `drive_lower`, `drive_upper`, `front_steps`: ceremonial arrival chain
- `west_side_path`: service-side circulation
- `east_side_path`: greenhouse/garden-side circulation
- `rear_court`, `garden`, `pond_edge`, `woodland_path`: rear estate backbone
- `chapel`, `greenhouse`, `family_crypt`, `carriage_house`: destination beats on that backbone

## Current Route Logic

```text
front_gate -> drive_lower -> drive_upper -> front_steps -> foyer
front_steps -> west_side_path -> carriage_house / rear_court
front_steps -> east_side_path -> greenhouse / rear_court
rear_court -> garden -> pond_edge / woodland_path
woodland_path -> chapel / family_crypt

foyer -> parlor / dining_room / kitchen / upper_hallway / front_gate
kitchen -> storage_basement -> boiler_room / wine_cellar / carriage_house
upper_hallway -> master_bedroom / library / guest_room / attic_stairs
attic_stairs -> attic_storage -> hidden_chamber
```

## Environmental Read

### Front Approach
- controlled, theatrical, invitational
- hedge-lined allée and gate threshold
- distant mansion silhouette and lit-window pull

### Side Circulation
- west side should read practical and servant-coded
- east side should read ornamental and greenhouse-adjacent
- both should hug hedge/wall and mansion massing rather than exposing open voids

### Rear Grounds
- less ceremonial, more secluded and expansive
- includes pond and wooded boundary to increase scale and occlusion
- supports the deeper puzzle-bearing exterior path

### Service Side
- storage/basement/carriage route expresses hidden labor and concealment

### Attic / Hidden Chamber
- progressively stripped and pressurized
- final transition from concealed domestic ruin to revelation space

## Room Authoring Model

Room environment is primarily defined through declarations:
- dimensions
- textures/material presets
- wall openings
- props
- lights
- audio loop
- atmosphere triggers

The room docs under `docs/rooms/` are the room-by-room environmental reference.

## Design Rules

- atmosphere must come from visible sources
- room identity should be legible from composition and dressing before text
- exterior spaces must reinforce the mansion’s world model, not fragment it
- the front drive is not a puzzle hub
- the grounds should eventually wrap around the mansion as a coherent place
