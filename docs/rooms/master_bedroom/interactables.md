# Master Bedroom — Interactables

## 1. Lord Ashworth's Diary — CRITICAL CLUE (EXISTS)

```yaml
id: diary_lord
type: note
position: (3, 0.9, 3)  # Nightstand, near bed
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Lord Ashworth's Diary**
> "She won't stop crying. Even after we locked her away, I hear her sobbing through the walls. My wife says I'm mad, but I know what I hear.
>
> The attic key is hidden in the library globe. No one must find her."

### Flags Set
- `read_ashworth_diary`
- `knows_key_location` — **This drives the player to the library globe**

### Phantom Camera
- **Yes** — zoom to nightstand, diary opens in frame

---

## 2. Bedroom Mirror (EXISTS)

```yaml
id: bedroom_mirror
type: mirror
position: (-4, 2, 0)  # West wall
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Mirror**
> "Your reflection stares back from tarnished glass. Was it always a fraction of a second late?"

**After `entered_attic`:**
> **Mirror**
> "In the mirror — movement behind you. You spin. Nothing. But the mirror shows an empty room for one beat too long before matching reality."

**After `found_hidden_chamber`:**
> **Mirror**
> "Your reflection doesn't match your expression. It looks... sad. Pitying. As if it knows something you haven't accepted yet."

### Flags Set
- `examined_bedroom_mirror`

---

## 3. Jewelry Box — PUZZLE ITEM (EXISTS)

```yaml
id: jewelry_box
type: box
position: (-3, 1, 3)  # Dresser, near mirror
collision: BoxShape3D(1.0, 0.5, 0.5)
locked: true
key_id: jewelry_key
item_found: elizabeths_locket
gives_also: lock_of_hair
```

### Text — All Variants

**Locked:**
> **Jewelry Box**
> "An ornate wooden box with a heart-shaped lock. It won't open. The wood is warm — warmer than the room."

**Unlocked (has `jewelry_key`):**
> **Elizabeth's Locket**
> "Inside: a tarnished silver locket on a fine chain. The inscription reads: 'Our Elizabeth, born in light.' Inside the locket: a miniature portrait of an infant with pale eyes. Behind the portrait, wrapped in tissue — a tiny lock of golden hair tied with white ribbon."

### Flags Set
- `jewelry_box_opened`
- `has_elizabeths_locket`
- `has_lock_of_hair` (via `gives_also`)

### Items Given
- `elizabeths_locket`
- `lock_of_hair` (counter-ritual component)

---

## 4. Unmade Bed (NEW)

```yaml
id: bedroom_bed
type: observation
position: (2, 0.5, 2)  # Bed area
collision: BoxShape3D(2.5, 1.0, 2.0)
```

### Text — All Variants

**Default:**
> **Bed**
> "Unmade on one side — Lord Ashworth's. The sheets are tangled, the pillow dented. Lady Ashworth's side is pristine, untouched. She didn't sleep here. Not for a long time."

**After `has_mothers_confession`:**
> **Bed**
> "He slept alone. She slept in the parlor — or didn't sleep at all. Two people living in the same house, consumed by the same guilt, unable to face each other."

### Flags Set
- None

---

## 5. Nightstand Book (NEW)

```yaml
id: bedroom_book
type: observation
position: (3, 0.9, 1)  # Same nightstand, different position
collision: BoxShape3D(0.5, 0.3, 0.5)
```

### Text — All Variants

**Default:**
> **Book**
> "Open to a page about 'childhood afflictions of the mind.' Several passages underlined: 'confinement is the only cure,' 'the afflicted child must be isolated,' 'no recovery has been documented.' The margins are filled with Lord Ashworth's frantic handwriting."

### Flags Set
- `read_afflictions_book`

---

## 6. Wardrobe (NEW)

```yaml
id: bedroom_wardrobe
type: observation
position: (-4, 1, -3)  # Against wall
collision: BoxShape3D(1.5, 2.0, 0.5)
```

### Text — All Variants

**Default:**
> **Wardrobe**
> "Ajar. Men's clothing on the left — formal suits, worn at the elbows. Women's clothing on the right — all black. The mourning dress from Lady Ashworth's portrait hangs at the front. She wore nothing else."

### Flags Set
- None

---

## 7. Broken Bottle (NEW)

```yaml
id: bedroom_broken_bottle
type: observation
position: (4, 0.1, -2)  # Floor, near wall
collision: BoxShape3D(0.5, 0.5, 0.5)
model: glass_bottle_mx_3_broken.glb
```

### Text
> **Broken Bottle**
> "Shattered glass on the floor. The label is too damaged to read, but the smell — sharp, medicinal. Laudanum? He was self-medicating. Trying to sleep through the crying."

### Flags Set
- None

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `diary_lord` | note | (3, 0.9, 3) | EXISTS — update content |
| `bedroom_mirror` | mirror | (-4, 2, 0) | EXISTS — update content |
| `jewelry_box` | box | (-3, 1, 3) | EXISTS — verify lock/key wiring |
| `bedroom_bed` | observation | (2, 0.5, 2) | NEW |
| `bedroom_book` | observation | (3, 0.9, 1) | NEW |
| `bedroom_wardrobe` | observation | (-4, 1, -3) | NEW |
| `bedroom_broken_bottle` | observation | (4, 0.1, -2) | NEW — model exists |
