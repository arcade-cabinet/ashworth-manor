# Grand Foyer — Interactables

## 1. Portrait of Lord Ashworth (EXISTS)

```yaml
id: foyer_painting
type: painting
position: (0, 2.5, -4.5)  # South wall, above eye level
collision: BoxShape3D(1.5, 1.5, 1.5)
model: picture_blank.glb (already placed)
```

### Text — All Variants

**Default:**
> **Lord Ashworth**
> "The patriarch stares down with hollow eyes. His hand rests on a book titled 'Rites of Passage.' The oil paint has darkened with age, but the eyes remain vivid — as if they were painted last."

**After `read_ashworth_diary`:**
> **Lord Ashworth**
> "The patriarch who locked his daughter in the attic. His hand rests on 'Rites of Passage' — the book that started it all. The hollow eyes make sense now. That's not authority. That's guilt."

**After `knows_full_truth`:**
> **Lord Ashworth**
> "Edmund Ashworth. Father. Industrialist. Jailer. You know what those hollow eyes saw. You know what that book taught him to do. The portrait is the only part of him that remained in this house."

### Flags Set
- `examined_foyer_painting`

### Puzzle Connection
- "Rites of Passage" → points player toward occult book in Library

---

## 2. Entry Mirror (EXISTS)

```yaml
id: foyer_mirror
type: mirror
position: (-5, 2, 3)  # West wall, south end
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Mirror**
> "Your reflection stares back from a full-length mirror in an ornate dark wood frame. The silver is tarnished. For a moment, you could swear it moved independently."

**After `elizabeth_aware`:**
> **Mirror**
> "Your reflection stares back. It moved independently. You're sure of it this time. The delay is fractional — but real."

**After `found_hidden_chamber`:**
> **Mirror**
> "In the mirror, behind your reflection — a girl in white. Small. Pale. Eyes dark as ink. When you blink, she's gone. But the mirror is warm to the touch."

### Flags Set
- `examined_foyer_mirror`

### Narrative Function
- Introduces mirror motif (mirrors progressively more disturbing)
- First hint of supernatural presence
- Escalates with game phase (3 tiers of text)

---

## 3. Grandfather Clock (EXISTS)

```yaml
id: grandfather_clock
type: clock
position: (5, 1, -4)  # East wall, south end
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Grandfather Clock**
> "The hands point to 3:33. The pendulum hangs motionless. No ticking breaks the silence. The moon phase dial shows a full moon. December 24th, 1891."

**After `examined_boiler_clock` (all clocks seen):**
> **Grandfather Clock**
> "3:33. Every clock in this house shows the same time. Whatever happened, happened everywhere at once."

### Flags Set
- `examined_foyer_clock`

### Sound Design
- Conspicuous ABSENCE of ticking — the silence IS the horror
- After all clocks examined: distant chime event (see triggers.md)

---

## 4. Light Switch (EXISTS)

```yaml
id: entry_switch
type: switch
position: (5.5, 1.3, -5)  # East wall, near south door
collision: BoxShape3D(1.5, 1.5, 1.5)
controls_light: foyer_chandelier
```

### Text
No text display — switch is purely mechanical.

### Function
- Toggles chandelier on/off via `GameManager.toggle_light("foyer_chandelier")`
- Demonstrates light interaction system
- Creates player agency in first room
- Turning off chandelier makes mirror more visible (moonlight)

---

## 5. Unopened Mail (NEW — add)

```yaml
id: foyer_mail
type: observation
position: (-5, 0.9, -4)  # On top of drawers, west wall south
collision: BoxShape3D(1.0, 0.5, 0.5)
```

### Text — All Variants

**Default:**
> **Unopened Letters**
> "A stack of letters on the hall table. Addressed to Lord Ashworth. Postmarked November and December 1891. None opened. He stopped reading his mail."

**After `read_ashworth_diary`:**
> **Unopened Letters**
> "The letters are from solicitors, creditors, a physician. He ignored them all. The last letter is from a doctor at Bethlem Hospital: 'Regarding your daughter's condition...' Still sealed."

### Flags Set
- `found_unopened_mail`

### Narrative Function
- Environmental storytelling: the house stopped functioning
- Letter from Bethlem (Bedlam) hints Elizabeth was nearly institutionalized

---

## 6. Staircase Observation (NEW — add)

```yaml
id: foyer_stairs
type: observation
position: (2, 1, -2)  # Near staircase base
collision: BoxShape3D(2.0, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Grand Staircase**
> "The staircase sweeps upward into shadow. Carved banisters wound with wooden vines. A carpet runner, faded crimson, muffles imagined footsteps. The upper floor is dark."

**After `entered_attic`:**
> **Grand Staircase**
> "The stairs feel different now. You know what's above the upper floor. What's above the ceiling. Who's been there this whole time."

### Flags Set
- None

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `foyer_painting` | painting | (0, 2.5, -4.5) | EXISTS — update content text |
| `foyer_mirror` | mirror | (-5, 2, 3) | EXISTS — update content text |
| `grandfather_clock` | clock | (5, 1, -4) | EXISTS — update content text |
| `entry_switch` | switch | (5.5, 1.3, -5) | EXISTS — OK |
| `foyer_mail` | observation | (-5, 0.9, -4) | NEW — add Area3D |
| `foyer_stairs` | observation | (2, 1, -2) | NEW — add Area3D |
