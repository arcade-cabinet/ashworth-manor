# Upper Hallway — Interactables

Currently: ZERO interactables. All need to be added.

## 1. Locked Attic Door — CRITICAL PUZZLE GATE (NEW)

```yaml
id: attic_door
type: locked_door
position: (0, 1.5, 7.5)  # North end of hallway
collision: BoxShape3D(2.0, 3.0, 0.5)
key_id: attic_key
target_room: attic_stairs
message_locked: "The door is locked. Heavy iron bands reinforce the wood. The lock is cold — colder than the air."
```

### Text — All Variants

**Locked (no key, first time):**
> "The door is locked. Heavy iron bands reinforce the wood. The lock is cold — colder than the air. This door wasn't built to keep something out. It was built to keep something in."

**Locked (after `knows_key_location`):**
> "The attic door. The diary said the key is hidden in the library globe. You can almost hear something behind it. Breathing? Or just the wind?"

**Unlocked (has `attic_key`):**
> "The old lock clicks open. Stale air rushes past you — air that hasn't moved in over a century. The stairs beyond are dark. Something shifts in the shadows above."

### Flags Set
- `knows_attic_locked` (on first locked interaction)
- `attic_unlocked` (on successful unlock)

---

## 2. Children's Painting — KEY NARRATIVE (NEW)

```yaml
id: children_painting
type: painting
position: (1.5, 1.6, 3)  # East wall, north section
collision: BoxShape3D(1.0, 1.0, 0.5)
model: poster_cx_11.glb (or picture_blank variant)
```

### Text — All Variants

**Default:**
> **Children's Portrait**
> "Three children in white stand before a summer garden. Charles, the eldest, looks serious. Margaret smiles politely. William clutches a toy soldier. The painting is titled 'The Ashworth Children, 1886.' But the household records say there were four."

**After `knows_attic_girl`:**
> **Children's Portrait**
> "Three children. But Elizabeth would have been six in 1886. Old enough to stand for a portrait. Old enough to be included. They painted her out of the family before they locked her in the attic."

**After `knows_full_truth`:**
> **Children's Portrait**
> "Charles, Margaret, William. They heard their sister calling through the walls. They fled the night of December 24th and never came back. Three children who survived by leaving the fourth behind."

### Flags Set
- `examined_children_painting`

### Phantom Camera
- **Yes** — inspection zoom to see detail of the three children.

---

## 3. Decorative Mask (NEW)

```yaml
id: hallway_mask
type: observation
position: (-1.5, 1.8, 1)  # West wall
collision: BoxShape3D(0.5, 0.5, 0.5)
model: mask_mx_1.glb (already in assets)
```

### Text — All Variants

**Default:**
> **Mask**
> "A theatrical mask mounted on the wall. The expression is frozen between comedy and tragedy — the mouth curves up on one side and down on the other. The eyes are empty sockets."

**After `elizabeth_aware`:**
> **Mask**
> "The mask's expression has changed. You're certain it was smiling before. Now both corners of the mouth turn down. The empty eye sockets seem deeper."

### Flags Set
- None

### Narrative Function
- One of 5 masks across the mansion (one per floor, increasingly disturbing)
- Upper floor mask is theatrical — the family's performance of normality
- Changes expression after `elizabeth_aware` (implied, via text — no model swap needed)

---

## 4. Framed Notice/Poster (NEW)

```yaml
id: hallway_poster
type: observation
position: (-1.5, 1.6, -5)  # West wall, south section
collision: BoxShape3D(1.0, 1.0, 0.5)
model: poster_cx_11.glb (already in scene assets)
```

### Text — All Variants

**Default:**
> **Framed Notice**
> "A household notice, framed and hung for all to see: 'The third floor is closed for repairs. No staff or family are to enter under any circumstances. — Lord Ashworth, October 1887.' The date: two months before Elizabeth was officially confined."

### Flags Set
- `read_hallway_notice`

### Narrative Function
- The "official" explanation for why the attic is sealed
- "Closed for repairs" — the lie they told the servants
- Date reveals the timeline: Elizabeth confined in 1887, "died" 1889

---

## 5. Light Switch (NEW)

```yaml
id: hallway_switch
type: switch
position: (1.8, 1.3, -6)  # East wall, near stairs
collision: BoxShape3D(0.5, 0.5, 0.5)
controls_light: hallway_sconce_north
```

### Function
- Toggles north sconce. The south sconce stays on always.
- Turning off the north sconce darkens the approach to the attic door.

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `attic_door` | locked_door | (0, 1.5, 7.5) | NEW — critical puzzle gate |
| `children_painting` | painting | (1.5, 1.6, 3) | NEW — key narrative |
| `hallway_mask` | observation | (-1.5, 1.8, 1) | NEW — asset exists |
| `hallway_poster` | observation | (-1.5, 1.6, -5) | NEW — asset exists |
| `hallway_switch` | switch | (1.8, 1.3, -6) | NEW |
