# Library — Interactables

## 1. Globe — PUZZLE SOLUTION (EXISTS)

```yaml
id: library_globe
type: box
position: (-3, 1.2, 3)  # Corner pedestal
collision: BoxShape3D(1.5, 1.5, 1.5)
locked: false
item_found: attic_key
```

### Text — All Variants

**Default (before `knows_key_location`):**
> **Globe**
> "A terrestrial globe on a brass pedestal. The continents are hand-painted, faded with age. It spins freely. The equator seam is visible — the globe is hollow."

**After `knows_key_location`:**
> **Globe**
> "Inside the hollow globe, you find an old brass key labeled 'ATTIC.' Hidden here by Lord Ashworth himself. The key to his daughter's prison, tucked inside a model of the world she'd never see."

### Flags Set
- `has_attic_key`

### Items Given
- `attic_key`

### Phantom Camera
- **Yes** — zoom to globe, opens to reveal key

---

## 2. Rituals of Binding — PICKABLE ITEM (EXISTS)

```yaml
id: binding_book
type: note
position: (3, 1.2, -2)  # Bookshelf, prominent placement
collision: BoxShape3D(1.0, 1.0, 1.0)
pickable: true
item_id: binding_book
```

### Text

> **Rituals of Binding**
> "To trap a spirit, one must first give it form. The doll shall be the vessel, the blood the seal, and the attic the prison eternal..."
>
> The pages are marked with Lord Ashworth's annotations. He understood what he was doing. He did it anyway.

### Flags Set
- `knows_binding_ritual`
- `has_binding_book` (when picked up — counter-ritual component)

### Phantom Camera
- **Yes** — zoom to book on shelf

---

## 3. Family Tree — KEY NARRATIVE (EXISTS)

```yaml
id: family_tree
type: note
position: (0, 1.6, -4.5)  # Wall-mounted frame, south wall
collision: BoxShape3D(1.5, 1.0, 0.5)
```

### Text — All Variants

**Default:**
> **Family Tree**
> "The tree shows four children, but the household records only mention three. The fourth name has been scratched out: 'E_iza_eth.' Scratched with something sharp — a knife? A fingernail? Whoever did this was angry, not careful."

**After `knows_full_truth`:**
> **Family Tree**
> "Elizabeth Ashworth. You can read her name now, even through the scratches. She existed. They tried to erase her from history, from memory, from the family tree itself. They failed."

### Flags Set
- `examined_family_tree`

### Phantom Camera
- **Yes** — zoom to see the scratched-out name

---

## 4. Ancient Artifact (NEW — upgrade from prop to interactable)

```yaml
id: library_artifact
type: observation
position: (-3, 1, -3)  # Display shelf
collision: BoxShape3D(0.5, 0.5, 0.5)
model: ancient_artifact_mx_1.glb
```

### Text — All Variants

**Default:**
> **Stone Tablet**
> "A stone tablet covered in symbols you don't recognize. It hums faintly when touched. The surface is warm, like the jewelry box. Like the gate lamp. Like everything Elizabeth has touched."

**After `knows_binding_ritual`:**
> **Stone Tablet**
> "The symbols match some of those in the binding book. This isn't decorative — it's a tool. The occultist brought it. Part of the ritual apparatus used to imprison Elizabeth."

### Flags Set
- None

---

## 5. Bookshelf Observation (NEW)

```yaml
id: library_shelves
type: observation
position: (4, 1.5, 0)  # East wall bookshelves
collision: BoxShape3D(1.0, 2.0, 0.5)
```

### Text

> **Bookshelves**
> "Legitimate scholarship mixed with occult texts. Geology next to demonology. Mathematics beside necromancy. Lord Ashworth wasn't stupid — he was desperate. He read everything, understood enough to be dangerous, and found someone willing to act on it."

### Flags Set
- None

---

## 6. Gears Display (NEW)

```yaml
id: library_gears
type: observation
position: (3, 1, 2)  # Display table
collision: BoxShape3D(1.0, 0.5, 1.0)
models: gear_mx_1.glb, gear_mx_2.glb, gear_mx_3.glb
```

### Text

> **Clockwork Gears**
> "Disassembled clock mechanisms. Lord Ashworth collected them — or dismantled them. Every clock in this house stopped at 3:33. Was that coincidence? Or did he know how to stop time?"

### Flags Set
- None

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `library_globe` | box | (-3, 1.2, 3) | EXISTS — update content |
| `binding_book` | note | (3, 1.2, -2) | EXISTS — verify pickable |
| `family_tree` | note | (0, 1.6, -4.5) | EXISTS — update content |
| `library_artifact` | observation | (-3, 1, -3) | NEW — model exists |
| `library_shelves` | observation | (4, 1.5, 0) | NEW |
| `library_gears` | observation | (3, 1, 2) | NEW — models exist |
