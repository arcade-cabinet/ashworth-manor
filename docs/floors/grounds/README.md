# Grounds (Exterior)

**Theme**: Ceremonial Arrival, Secluded Estate, Rear Discovery  
**Ambient Darkness Range**: 0.3 - 0.7  
**Access**: Prologue, later side-circulation unlocks, rear-estate discovery, endings

---

## Overview

The Grounds of Ashworth Manor are not a single front lawn. They are a coherent
estate wrapped around the house.

The player should gradually understand four exterior ideas:

1. the **front approach** is ceremonial and controlled
2. the **sides** of the mansion carry different class-coded meanings
3. the **rear** of the property is larger and stranger than the front implies
4. the estate boundary is hidden by hedges, walls, trees, pond edge, and woods

The canonical shipped model is:

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

See `docs/GROUNDS_WORLD_SPEC.md` for the authoritative path and gating model.

---

## Exterior Structure

### 1. Front Approach

Purpose:

- first impression
- diegetic menu
- moonlit hedge-lined drive
- commitment to entering the house

Canonical beats:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`

### 2. Side Circulation

The forecourt/front-steps area should branch in both directions.

West side:

- servant/service logic
- carriage route
- rougher circulation
- leads toward `carriage_house`

East side:

- ornamental/garden logic
- more cultivated feel
- leads toward `greenhouse`

Both should eventually connect to the back.

### 3. Rear Estate

The rear should feel like the estate opening up.

Core rear spaces:

- `rear_court`
- `garden`
- `pond_edge`
- `woodland_path`
- `chapel`
- `family_crypt`

This is where the grounds stop being "approach" and start becoming "world."

---

## Canonical Layout

```text
                         NORTH / REAR

                 [woodland_path]----[chapel]
                        | \
                        |  \----[family_crypt]
                        |
                  [garden]----[pond_edge]
                        |
                    [rear_court]
                     /         \
        [carriage_house]       [greenhouse]
                 |                   |
          [west_side_path]     [east_side_path]
                    \             /
                     [front_steps]
                           |
                      [drive_upper]
                           |
                      [drive_lower]
                           |
                       [front_gate]
                           |
                         SOUTH
```

---

## Access Staging

### Prologue

Accessible:

- `front_gate`
- `drive_lower`
- `drive_upper`
- `front_steps`
- `foyer`

Not yet open:

- west side path
- east side path
- rear grounds

### Midgame

One or both side routes open depending on pacing.

### Late Exterior Discovery

The rear becomes legible as a full estate geography with:

- greenhouse wing
- carriage side
- pond
- woods
- chapel
- crypt

---

## Design Rules

### Occlusion

The front route should not allow the player to see the end of the world.

Use:

- clipped hedges
- side gate structures
- walls and fence runs
- mansion wings
- winter tree masses

### Class Contrast

West side and east side should not feel interchangeable.

West side:

- practical
- servant-coded
- carriage/service atmosphere

East side:

- ornamental
- cultivated
- greenhouse-adjacent

### Rear Expansion

The rear must add scale, not just more squares to traverse.

The pond and woods are approved because they:

- deepen atmosphere
- create spatial depth
- hide the estate boundary
- give the chapel/crypt branch a stronger landscape context

---

## Existing vs Planned Spaces

### Existing exterior rooms to preserve

- `front_gate`
- `garden`
- `greenhouse`
- `carriage_house`
- `chapel`
- `family_crypt`

### Planned new exterior rooms

- `drive_lower`
- `drive_upper`
- `front_steps`
- `west_side_path`
- `east_side_path`
- `rear_court`
- `pond_edge`
- `woodland_path`

These should be added as authored exterior rooms in the same estate topology,
not improvised as one giant replacement for `front_gate`.
