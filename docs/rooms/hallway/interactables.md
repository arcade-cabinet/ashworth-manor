# Upper Hallway — Interactables

## 1. Locked Attic Door — Critical Puzzle Gate

```yaml
id: attic_door
type: observation
position: (0, 1.2, 7.5)  # North end of hallway
collision: BoxShape3D(2.0, 3.0, 0.5)
key_id: attic_key
target_room: attic_stairs
message_locked: "The attic door is locked. The iron lock is cold and heavy. You need a key."
```

### Text — All Variants

**Default observation:**
> **Attic Door**
> "A heavy oak door at the end of the hallway. The lock is iron, oversized for a domestic door. Scratches surround the keyhole -- someone tried many keys, or one key many times."

**Locked transition text (no key):**
> "The attic door is locked. The iron lock is cold and heavy. You need a key."

### Flags Set
- None directly on observation

---

## 2. Children's Painting — Key Narrative

```yaml
id: children_painting
type: painting
position: (1.5, 2.0, 4)  # East wall, north section
collision: BoxShape3D(1.0, 1.0, 0.5)
model: picture_blank_003.glb
```

### Text — All Variants

**Default:**
> **Children's Portrait**
> "Five children posed on the garden lawn. The eldest stands tall. The youngest sits on a blanket. But there are only four faces visible. The fifth child -- second from right -- has been painted over. A smear of dark pigment where a face should be."

**Macro-thread variants:**
- `captive`: the face has been painted out badly, but the outline still shows
- `mourning`: the face has been covered gently, like a blanket
- `sovereign`: the missing child has been displaced to the attic window in the background

### Flags Set
- `examined_children_painting`

---

## 3. Decorative Mask

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
- One of the mansion's repeated mask motifs
- The upper-floor mask is theatrical: the family's performance of normality curdling into unease
- Changes by text only after `elizabeth_aware`

---

## 4. Framed Notice/Poster

```yaml
id: hallway_poster
type: note
position: (-1.5, 1.5, 6)  # West wall, north section
collision: BoxShape3D(1.0, 1.0, 0.5)
model: poster_cx_11.glb (already in scene assets)
```

### Text — Shared + Thread Variants

**Default:**
> **Notice**
> "A handwritten notice tacked to the wall: 'ATTIC -- CLOSED FOR REPAIRS. DO NOT ENTER.' The paper is yellowed. The ink is faded. No repairs were ever made."

**Macro-thread variants:**
- `captive`: the notice becomes a formal order of imprisonment
- `mourning`: the notice becomes Victoria's pleading attempt at containment
- `sovereign`: the notice bears Elizabeth's answering pencil marks

### Flags Set
- `examined_hallway_poster`

### Narrative Function
- The official lie for why the attic is sealed
- A public-facing version of the family cover story

---

## 5. Light Switch

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
| `attic_door` | observation | (0, 1.2, 7.5) | Active critical puzzle gate |
| `children_painting` | painting | (1.5, 2.0, 4) | Active key narrative |
| `hallway_mask` | observation | (-1.5, 1.8, 1) | Active |
| `hallway_poster` | note | (-1.5, 1.5, 6) | Active |
| `hallway_switch` | switch | (1.8, 1.3, -6) | Active |
