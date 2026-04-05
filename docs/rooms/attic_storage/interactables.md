# Attic Storage — Interactables

## 1. Elizabeth's Portrait — KEY NARRATIVE (NEW — or update existing)
```yaml
id: elizabeth_portrait
type: painting
position: (-5, 2, 5)
```

### Text
> **The Fourth Child**
> "A young girl in a white dress clutches a porcelain doll. Her eyes have been painted over in black. The plaque reads: 'Elizabeth Ashworth, 1880-1889. Beloved daughter. Forgotten by none.'
>
> She painted this herself. The brushwork is a child's — careful, earnest, imperfect. The black eyes were the last thing she added."

### Flags Set: `seen_elizabeth_portrait`
### Phantom Camera: **Yes** — zoom to portrait, face detail

**Flashback on examine:** Brief vision of Elizabeth (bloodwraith, child-scale) standing where portrait hangs. Text: "She painted this herself. The eyes were the last thing she added. She said she couldn't see anymore."

---

## 2. Porcelain Doll — MULTI-STEP PUZZLE (EXISTS in concept)
```yaml
id: porcelain_doll
type: doll
position: (3, 0.8, 4)
model: doll1.glb
```

### Interaction Flow
**First tap:** "A porcelain doll with cracked features. Its painted eyes seem to follow you. Behind it, scratched into the wood: 'SHE NEVER LEFT.'" Sets `examined_doll`

**Second tap (requires `read_elizabeth_letter`):** "You turn the doll over. Inside the hollow body, wrapped in a child's handkerchief, is a tarnished key. The doll's cracked face seems to relax." Gives `hidden_key`. Then doll becomes pickable → gives `porcelain_doll` (counter-ritual component).

### Flags Set: `examined_doll`, `has_hidden_key`, `has_porcelain_doll`

---

## 3. Elizabeth's Unsent Letter — KEY NARRATIVE (NEW)
```yaml
id: elizabeth_letter
type: note
position: (-2, 0.5, 0)  # In trunk
```

### Text
> **Unsent Letter**
> "Dearest Mother,
>
> They say I'm sick but I feel fine. Father won't let me leave my room anymore. The doll talks to me now. She says I'll be here forever.
>
> I'm scared.
>
> — Your Elizabeth"

### Flags Set: `read_elizabeth_letter`

---

## 4. Hidden Door (NEW)
```yaml
id: hidden_door
type: locked_door
position: (-6, 1.2, 0)  # West wall, behind furniture
key_id: hidden_key
target_room: hidden_room
message_locked: "A door, almost invisible behind the trunks. The lock is shaped like an open hand."
```

---

## 5. Window (NEW)
```yaml
id: attic_window
type: observation
position: (6, 2, 3)
```

### Text
> "The window faces the garden. You can see the lily from here — the one living thing in the dead winter grounds. Elizabeth could see it too. She grew it from this window. Her last connection to the world outside."

---

## 6. Trunk/Belongings (NEW)
```yaml
id: elizabeth_trunk
type: observation
position: (-2, 0.3, 0)
```

### Text
> "Elizabeth's trunk. Clothes for a nine-year-old, folded neatly by someone who cared. A nightgown. A ribbon. A drawing of a family with four children — the only place all four exist together."

---

## Summary
| ID | Type | Status |
|----|------|--------|
| `elizabeth_portrait` | painting | NEW |
| `porcelain_doll` | doll | EXISTS in logic — need Area3D + model |
| `elizabeth_letter` | note | NEW |
| `hidden_door` | locked_door | NEW |
| `attic_window` | observation | NEW |
| `elizabeth_trunk` | observation | NEW |
