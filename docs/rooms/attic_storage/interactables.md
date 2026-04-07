# Attic Storage — Interactables

## 1. Elizabeth's Portrait — Key Narrative
```yaml
id: elizabeth_portrait
type: painting
position: (-6, 2, 0)
```

### Text
The declaration uses a default truth-facing reading plus captive, mourning, and sovereign thread variants. All versions set:

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

The declaration frames the letter differently per macro thread, but it always functions as Elizabeth's unheard voice and the trigger that makes the doll's hidden key legible.

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
> "A child's trunk with carefully folded clothes inside. A nightgown. A ribbon. A drawing of a family with four children holding hands. The paper is creased from being opened and refolded until the corners went soft."

---

## 6. Hidden Chamber Door
The west-wall threshold to `hidden_chamber` remains a real room connection rather than a second declaration interactable. It is still locked by `hidden_key` and presented as a concealed door behind attic clutter.

---

## Summary
| ID | Type | Status |
|----|------|--------|
| `elizabeth_portrait` | painting | Implemented |
| `porcelain_doll` | doll | Implemented |
| `elizabeth_letter` | note | Implemented |
| `attic_window` | observation | Implemented |
| `elizabeth_trunk` | observation | Implemented |
