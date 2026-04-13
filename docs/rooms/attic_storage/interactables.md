# Attic Storage — Interactables

## 1. Elizabeth's Portrait — Key Narrative
```yaml
id: elizabeth_portrait
type: painting
position: (-6, 2, 0)
```

### Text
The declaration uses a default truth-facing reading plus child, adult, and elder thread variants. All versions set:

- `examined_elizabeth_portrait`

---

## 2. Porcelain Doll — Multi-Step Puzzle
```yaml
id: porcelain_doll
type: doll
position: (-2, 0.6, 4)
model: doll1.glb
```

### Interaction Flow
**Default:** The doll reads as an unnervingly preserved child's possession.

**After `read_elizabeth_letter`:** The player discovers the hidden key inside the doll.

### State / Item Effects
- sets `found_hidden_key_doll`
- gives `hidden_key`
- thread variants alter the reading without changing the puzzle role

---

## 3. Elizabeth's Unsent Letter — Key Narrative
```yaml
id: elizabeth_letter
type: note
position: (2, 0.6, 3)
```

The declaration frames the letter differently per route, but it always
functions as Elizabeth's unheard voice and the trigger that makes the doll's
hidden key legible.

### Flags Set
- `read_elizabeth_letter`
- `elizabeth_aware`

---

## 4. Attic Window
```yaml
id: attic_window
type: observation
position: (5.4, 2.1, -3.8)
```

### Text
> "The window looks down across the rear grounds. Bare hedges, dead beds, the garden wall. One pale lily still stands against the winter. Elizabeth must have watched that single living thing the way prisoners watch a keyhole."

---

## 5. Trunk / Belongings
```yaml
id: elizabeth_trunk
type: observation
position: (2, 0.7, 3)
```

### Text
Default:
> "A child's trunk with carefully folded clothes inside. A nightgown. A ribbon. A drawing of a family with four children holding hands. The paper is creased from being opened and refolded until the corners went soft."

Route role:
- `adult`: proves Elizabeth outgrew the garments and remade them
- `child`: keeps childhood layers on top and measurements on the wall hidden beneath

---

## 6. Attic Music Box
```yaml
id: attic_music_box
type: observation
position: writing desk
```

Route role:
- `adult`: true final solve object for the attic route
- `elder`: redirect object; the melody drags downward and refuses to resolve
- `child`: false answer; the melody only echoes and points the player to the west wall

Requires:
- brass winding key from the valise
- hook/light phase for the adult resolution path

---

## 7. Sealed Seam
```yaml
id: sealed_seam
type: observation
position: west wall
```

Function:
- initially reads as suspicious architecture only
- after the Child attic redirect, it becomes the physical reveal surface
- with the hook, it opens the erased room and sets `child_hidden_room_revealed`

---

## 8. Sealed Room Threshold
The west-wall threshold to `hidden_chamber` is now the concealed connection into
the sealed room. It is no longer documented as a conventional key-door puzzle.
The route now treats it as architecture that must be exposed and opened from
the attic side.

---

## Summary
| ID | Type | Status |
|----|------|--------|
| `elizabeth_portrait` | painting | Implemented |
| `porcelain_doll` | doll | Implemented |
| `elizabeth_letter` | note | Implemented |
| `attic_window` | observation | Implemented |
| `elizabeth_trunk` | observation | Implemented |
| `attic_music_box` | observation | Implemented |
| `sealed_seam` | observation | Implemented |
