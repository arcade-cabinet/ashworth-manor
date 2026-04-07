# Library — Interactables

## 1. Globe — Puzzle Solution

```yaml
id: library_globe
type: observation
position: (-3, 0.9, 3)  # West reading corner
collision: BoxShape3D(1.5, 1.5, 1.5)
item_found: attic_key
```

### Live Response Selection

**Default:**
> **Globe**
> "A brass-framed globe on a mahogany stand. The northern hemisphere is slightly askew -- someone twisted it and did not put it back. The seam between the hemispheres is wider than it should be. Is there something inside?"

**After `read_ashworth_diary`:**
> **Globe**
> "The diary mentioned the globe. 'The key is inside the globe -- she will never think to look there.' You turn the northern hemisphere. It clicks. A hidden compartment opens. Inside: an iron key."

**Macro-thread variants:**
- `captive`: the globe reads as part of Elizabeth's imprisonment
- `mourning`: the globe reads as a map of places Elizabeth never saw
- `sovereign`: the globe turns toward England as if the house is orienting you itself

### Flags Set
- `found_attic_key_globe`

### Items Given
- `attic_key`

### Phantom Camera
- Not yet authored

---

## 2. Rituals of Binding — Pickable Item

```yaml
id: binding_book
type: note
position: (0, 1.2, 4.5)  # North lectern/shelf focus
collision: BoxShape3D(1.0, 1.0, 1.0)
pickable: true
item_id: binding_book
```

### Live Response Selection

> **Rituals of Binding**
> The default version presents `Rites of Passage: The Binding and Loosing of Spirits, 1743`, with annotations in Edmund Ashworth's hand and bookmarks at `Containment` and `The Vessel`.

**Macro-thread variants:**
- `captive`: emphasizes the book as the manual for Elizabeth's cage
- `mourning`: emphasizes Edmund's remorse and the pressed lily
- `sovereign`: emphasizes Elizabeth re-reading and reinterpreting the rite

### Flags Set
- `examined_binding_book`

### Items Given
- `binding_book`

### Phantom Camera
- Not yet authored

---

## 3. Family Tree — Key Narrative

```yaml
id: family_tree
type: painting
position: (3.5, 2, 4.5)  # North wall frame
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Family Tree**
> "A framed family tree on the wall. 'The Ashworth Line, 1720-1891.' Five branches descend from Edmund and Victoria. Four names are legible. The fourth has been scratched out -- not with ink, but with something sharp. A nail? A pin? The paper beneath is torn."

**After `read_ashworth_diary`:**
> **Family Tree**
> "Five branches for five children. The fourth name -- Elizabeth -- has been scratched out so deeply the paper tore. Someone erased her from the family. The scratches look fresh. Recent. As if this happened after everything else."

**Macro-thread variants:**
- `captive`: the erasure reads as violence
- `mourning`: the blank branch reads as grief and refusal
- `sovereign`: the scratches imply Elizabeth renamed herself

### Flags Set
- `examined_family_tree`

### Phantom Camera
- Not yet authored

---

## 4. Ancient Artifact

```yaml
id: library_artifact
type: observation
position: (-3, 1, -3)  # Display shelf
collision: BoxShape3D(0.5, 0.5, 0.5)
model: ancient_artifact_mx_1.glb
```

### Live Response Selection

**Default:**
> **Stone Tablet**
> "A stone tablet covered in symbols you don't recognize. It hums faintly when touched. The surface is warm, like the jewelry box. Like the gate lamp. Like everything Elizabeth has touched."

### Flags Set
- None

---

## 5. Bookshelf Observation

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

## 6. Gears Display

```yaml
id: library_gears
type: observation
position: (3.5, 1.5, -4)  # South study wall
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
| `library_globe` | observation | (-3, 0.9, 3) | Implemented |
| `binding_book` | note | (0, 1.2, 4.5) | Implemented |
| `family_tree` | painting | (3.5, 2, 4.5) | Implemented |
| `library_artifact` | observation | (-2.8, 1, -2.5) | Implemented |
| `library_shelves` | observation | (3.8, 1.5, 0) | Implemented |
| `library_gears` | observation | (3.5, 1.5, -4) | Implemented |
