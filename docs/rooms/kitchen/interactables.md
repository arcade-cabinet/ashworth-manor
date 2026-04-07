# Kitchen — Interactables

## 1. Cook's Note — Key Narrative

```yaml
id: kitchen_note
type: note
position: (3, 1.0, 2)  # On work surface, near hearth
collision: BoxShape3D(1.0, 0.5, 0.5)
```

### Text — All Variants

**Default:**
> **Cook's Note**
> "The master has forbidden anyone from the attic. Says the rats have grown too bold. But I've heard no rats that whisper names..."

**After `knows_attic_girl`:**
> **Cook's Note**
> "Not rats. Elizabeth. The cook heard her — 'rats that whisper names.' She knew. The servants always know."

### Flags Set
- `read_cook_note`

### Narrative Function
- Reinforces the attic mystery from a different perspective (servant, not family)
- "Whisper names" — Elizabeth tried to communicate with everyone, not just the children
- Shows Lord Ashworth lied to staff about why the attic was forbidden

---

## 2. Cutting Board

```yaml
id: kitchen_cutting_board
type: observation
position: (-2, 0.9, 0)  # On table, center
collision: BoxShape3D(1.0, 0.5, 1.0)
model: wooden_board_3.glb
```

### Text — All Variants

**Default:**
> **Cutting Board**
> "Vegetables half-chopped. Desiccated to husks. A knife rests mid-cut in what was once a turnip. The cook walked away in the middle of preparing dinner and never came back."

### Flags Set
- None

---

## 3. Stove/Hearth

```yaml
id: kitchen_hearth
type: observation
position: (0, 0.5, 4)  # North wall
collision: BoxShape3D(2.0, 1.5, 1.0)
```

### Text — All Variants

**Default:**
> **Hearth**
> "Cold iron grate. No warmth. A pot sits over dead ashes — the bottom burned black. Whatever was cooking boiled dry and scorched. The smell of char has faded but the stain remains."

**After `elizabeth_aware`:**
> **Hearth**
> "The iron is cold. But you notice: soot on the chimney breast has been disturbed. Five small handprints. A child's. At a height no child could reach from the floor."

### Flags Set
- None

---

## 4. Knife Block

```yaml
id: kitchen_knives
type: observation
position: (-3, 0.9, -2)  # On counter, south end
collision: BoxShape3D(0.5, 0.5, 0.5)
model: knife_block.glb
```

### Text — All Variants

**Default:**
> **Knife Block**
> "Six slots. Five knives. One missing. The handle shapes match the kitchen knives on the counter — except for the empty slot. That one is different. Longer. Not for cooking."

### Flags Set
- `noticed_missing_knife`

### Narrative Function
- Subtle dread — a knife is unaccounted for
- Was it used for something other than cooking?
- Connects to the binding ritual (blood seal)

---

## 5. Bucket

```yaml
id: kitchen_bucket
type: observation
position: (3, 0.2, -3)  # Floor, near door
collision: BoxShape3D(0.8, 0.8, 0.8)
scene_path: res://scenes/shared/kitchen/kitchen_bucket_still.tscn
state_model_map:
  rippled: res://scenes/shared/kitchen/kitchen_bucket_rippled.tscn
```

### Text — All Variants

**Default:**
> **Bucket**
> "A wooden bucket, half-full of water that should have evaporated decades ago. The water is perfectly still. No reflection of the ceiling. Just dark."

### Flags Set
- `examined_kitchen_bucket`

### Visual States
- `still` on first room load
- `rippled` after the first inspection

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `kitchen_note` | note | (3, 1.0, 2) | Active |
| `kitchen_cutting_board` | observation | (-2, 0.9, 0) | Represented through prop dressing |
| `kitchen_hearth` | observation | (0, 0.5, 4) | Active as `kitchen_hearth` |
| `kitchen_knives` | observation | (-3, 0.9, -2) | Represented through knife-block dressing |
| `kitchen_bucket` | observation | (3, 0.2, -3) | Active stateful setpiece |
