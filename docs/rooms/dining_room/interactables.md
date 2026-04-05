# Dining Room — Interactables

Currently: ZERO interactables. All of these need to be added.

## 1. Dinner Party Photo (NEW)

```yaml
id: dinner_photo
type: photo
position: (3.9, 1.6, 0)  # East wall, center (picture_blank_002.glb already placed)
collision: BoxShape3D(1.0, 1.0, 0.5)
```

### Text — All Variants

**Default:**
> **Dinner Photograph**
> "A formal dinner photograph. Eight people arranged around this very table. Stiff poses, forced smiles. The host — Lord Ashworth — stands at the head. Three of these guests would be dead within the week."

**After `read_maintenance_log` (boiler room):**
> **Dinner Photograph**
> "You recognize the room. The table is set identically — same places, same candles. As if the photograph was a blueprint and the room was built to match it. Or as if time simply stopped."

**After `knows_full_truth`:**
> **Dinner Photograph**
> "Eight people. Three would die. Two would vanish. Three children would flee and never return. December 24th, 1891. The last photograph ever taken at Ashworth Manor."

### Flags Set
- `examined_dinner_photo`

### Phantom Camera
- **Yes** — inspection camera. Smooth zoom to photo level for reading detail.

---

## 2. Pushed Chair (NEW)

```yaml
id: dining_pushed_chair
type: observation
position: (2.2, 0.5, 2)  # The already-angled chair model (ChPushed in scene)
collision: BoxShape3D(1.0, 1.0, 1.0)
```

### Text — All Variants

**Default:**
> **Pushed Chair**
> "One chair pushed back from the table at a sharp angle. The plate in front of it is untouched. The wine glass is overturned — a dark stain has soaked into the wood. Someone left this seat in a hurry. Or was pulled from it."

**After `elizabeth_aware`:**
> **Pushed Chair**
> "The chair faces away from the table. Away from the other guests. Toward the door. Whoever sat here saw something in the doorway. Something that made them abandon their dinner and run."

### Flags Set
- `examined_pushed_chair`

---

## 3. Wine Glass (NEW)

```yaml
id: dining_wine_glass
type: observation
position: (0.3, 0.85, 0.2)  # On table, near center (wine_glass.glb exists)
collision: BoxShape3D(0.5, 0.5, 0.5)
```

### Text — All Variants

**Default:**
> **Wine Glass**
> "Dried residue clings to the inside. Not wine — too dark, too thick. Whatever was in this glass, it wasn't served at dinner. It was added afterward."

**After `has_mothers_confession`:**
> **Wine Glass**
> "Lady Ashworth's confession mentions 'what was done to the guests.' The residue in this glass is dark as dried blood. The dinner wasn't just a gathering. It was a sacrifice."

### Flags Set
- `examined_wine_glass`

---

## 4. Place Settings (NEW)

```yaml
id: dining_place_settings
type: observation
position: (-0.5, 0.85, -2)  # Table surface, south end
collision: BoxShape3D(1.5, 0.3, 1.0)
```

### Text — All Variants

**Default:**
> **Place Settings**
> "Set for eight. Five show signs of use — moved cutlery, crumpled napkins, water rings. Three are pristine. Those three guests never sat down. Or arrived and immediately wished they hadn't."

### Flags Set
- None

---

## 5. Table Candles (NEW)

```yaml
id: dining_candles
type: observation
position: (0, 0.9, 0)  # Center table
collision: BoxShape3D(0.5, 0.5, 0.5)
```

### Text — All Variants

**Default:**
> **Table Candles**
> "Wax has pooled and hardened mid-drip. The candles burned down to nothing and were never replaced. Time stopped here between courses — the dinner was never finished."

### Flags Set
- `examined_dining_candles`

---

## 6. Serving Vessel (NEW)

```yaml
id: dining_vessel
type: observation
position: (-0.4, 0.85, -0.5)  # On table (serving_vessel.glb exists)
collision: BoxShape3D(0.5, 0.5, 0.5)
```

### Text — All Variants

**Default:**
> **Serving Vessel**
> "A silver tureen, lid askew. Inside: desiccated remains of soup. Still sitting where it was placed over a century ago. The ladle has never been cleaned."

### Flags Set
- None

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `dinner_photo` | photo | (3.9, 1.6, 0) | NEW — model exists, add Area3D |
| `dining_pushed_chair` | observation | (2.2, 0.5, 2) | NEW — model exists (ChPushed), add Area3D |
| `dining_wine_glass` | observation | (0.3, 0.85, 0.2) | NEW — model exists, add Area3D |
| `dining_place_settings` | observation | (-0.5, 0.85, -2) | NEW — covers existing plate models, add Area3D |
| `dining_candles` | observation | (0, 0.9, 0) | NEW — model exists, add Area3D |
| `dining_vessel` | observation | (-0.4, 0.85, -0.5) | NEW — model exists, add Area3D |
