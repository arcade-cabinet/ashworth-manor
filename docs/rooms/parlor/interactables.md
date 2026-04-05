# Parlor — Interactables

## 1. Portrait of Lady Ashworth (EXISTS)

```yaml
id: parlor_painting_1
type: painting
position: (-4.5, 2, 0)  # West wall, center height
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Lady Ashworth**
> "She wears a black mourning dress despite this being painted before any family deaths. Her expression is distant, resigned — as if she already knows what's coming. Her hands are folded in her lap. Hiding something? Or holding herself together?"

**After `read_ashworth_diary`:**
> **Lady Ashworth**
> "Victoria Ashworth. She knew. The diary says 'my wife says I'm mad' — but she heard the crying too. She chose the mourning dress for this portrait. She was mourning Elizabeth before Elizabeth was gone."

**After `has_mothers_confession`:**
> **Lady Ashworth**
> "'I am complicit in what was done to our daughter.' Her own words, written the night before everything ended. In this portrait she already wears her guilt. The mourning dress wasn't prescience — it was penance."

### Flags Set
- `examined_lady_portrait`

---

## 2. Torn Diary Page — CRITICAL CLUE (EXISTS)

```yaml
id: parlor_note
type: note
position: (2, 0.8, -3)  # Side table, south end
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Torn Diary Page**
> "The children have been hearing whispers from the attic again. I've locked the door but they say she still calls to them at night..."
>
> The handwriting is Lady Ashworth's — precise, controlled, trembling only at the edges.

### Flags Set
- `found_first_clue` — **TRIGGERS PHASE TRANSITION: Exploration → Discovery**
- `knows_attic_girl`

### Narrative Function
**This is the most important interactable in the first half of the game.** It:
- Reveals "she" exists in the attic
- Shows the family actively hid her
- Children heard her — she tried to reach them
- Sets `found_first_clue` which triggers Discovery phase via LimboAI HSM
- After this, tension audio layer activates across all rooms

---

## 3. Music Box (EXISTS)

```yaml
id: music_box
type: box
position: (-2, 0.8, -3)  # Side table, south end, opposite note
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Music Box**
> "A delicate music box with a dancing ballerina. The mechanism is jammed — it doesn't play when you try to open it. Dust covers the hinges. Someone loved this once."

**After `elizabeth_aware` + visited `attic_storage`:**
> **Music Box**
> "The music box begins to play on its own. A lullaby you've never heard before. The ballerina turns, slow and deliberate. The mechanism was never jammed. It was waiting."

### Flags Set
- `examined_music_box`

### Events
When the music box plays on its own:
- `play_sfx: "music_box_melody"` (Elizabeth's melody motif)
- Fireplace dims: energy 1.5 → 0.5 over 3s
- Then restores: energy 0.5 → 1.5 over 3s

---

## 4. Fireplace (NEW — add)

```yaml
id: parlor_fireplace
type: observation
position: (0, 1, 4.5)  # North wall, center
collision: BoxShape3D(2.0, 1.5, 1.0)
```

### Text — All Variants

**Default:**
> **Fireplace**
> "Embers still glow faintly. After 130 years? The iron grate holds ash that should have gone cold a century ago. The warmth is real — you can feel it on your face."

**After `elizabeth_aware`:**
> **Fireplace**
> "The embers pulse. Not like dying coals — like breathing. In. Out. The same rhythm as the gate lamp. The same rhythm as the mirrors."

### Flags Set
- None

---

## 5. Tea Service (NEW — add)

```yaml
id: parlor_tea
type: observation
position: (0, 0.8, -1)  # On table between settees
collision: BoxShape3D(1.0, 0.5, 1.0)
```

### Text — All Variants

**Default:**
> **Tea Service**
> "Two cups. One used, one untouched. The teapot is empty. Dried leaves cling to the inside — someone made tea for two and only one person drank."

**After `read_guest_ledger`:**
> **Tea Service**
> "Two cups — Lady Ashworth and Helena Pierce? The guest who arrived November 3rd and never left. Did they sit here, making small talk, while Elizabeth cried above them?"

### Flags Set
- None

### Visual Design
- Use existing bottle/jar props positioned on table surface
- `glass_bottle_mx_1.glb` and `jam_jar_mp_1_medium.glb` already in scene as visual texture

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `parlor_painting_1` | painting | (-4.5, 2, 0) | EXISTS — update content |
| `parlor_note` | note | (2, 0.8, -3) | EXISTS — update content |
| `music_box` | box | (-2, 0.8, -3) | EXISTS — update content + add event |
| `parlor_fireplace` | observation | (0, 1, 4.5) | NEW — add Area3D |
| `parlor_tea` | observation | (0, 0.8, -1) | NEW — add Area3D |
