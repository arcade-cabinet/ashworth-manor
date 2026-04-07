# Front Gate — Interactables

## 1. Diegetic Gate Menu — New Game

```yaml
id: gate_sign_new_game
type: observation
scene_role: threshold_control
position: (-3.0, 3.2, -10.8)
collision: BoxShape3D(2.2, 1.2, 0.8)
```

### Runtime Behavior
- selecting it starts a fresh run in-place at the gate
- sets `front_gate_menu_selection = "new_game"`
- sets `front_gate_threshold_acknowledged = true`
- reloads `front_gate` so the opening path is the beginning of the run, not a detached menu screen

### Visual Design
- procedural hanging sign board with in-world serif text
- left sign of the gate trio
- meant to read before the player commits to the hedge-lined approach

---

## 2. Diegetic Gate Menu — Load Game

```yaml
id: gate_sign_load_game
type: observation
scene_role: threshold_control
position: (0, 3.2, -11.0)
collision: BoxShape3D(2.2, 1.2, 0.8)
```

### Runtime Behavior
- loads the current save if one exists
- otherwise shows a short "no prior journey" failure response

### Visual Design
- central hanging sign in the gate trio
- same procedural board stack as the other menu signs

---

## 3. Diegetic Gate Menu — Settings

```yaml
id: gate_sign_settings
type: observation
scene_role: threshold_control
position: (3.0, 3.2, -10.8)
collision: BoxShape3D(2.2, 1.2, 0.8)
```

### Runtime Behavior
- toggles the pause/settings surface from the world, not from a detached boot screen

### Visual Design
- right sign of the gate trio
- completes the diegetic boot flow across the threshold

---

## 4. Gate Plaque

```yaml
id: gate_plaque
type: note
position: (-2, 1.5, -10)
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — Shared + Thread Variants

**Default:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. The iron lettering is green with verdigris. Below, in smaller script barely legible: 'Abandon memory, all ye who enter.'"

**Captive thread:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. The plaque hangs like a warning plate on a cell door. 'Abandon memory, all ye who enter.' Not invitation. Instruction. This is a place built to keep truths locked up until they stop sounding human."

**Mourning thread:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. Verdigris has softened every letter, as if even the metal has been grieving. 'Abandon memory, all ye who enter.' The house does not threaten. It laments."

**Sovereign thread:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. The green-black iron seems damp though no rain falls. 'Abandon memory, all ye who enter.' The plaque reads less like a motto than a command from the thing that now speaks through the estate."

**After `knows_full_truth`:**
> **Ashworth Manor**
> "'Abandon memory, all ye who enter.' They meant it literally. They tried to make the world forget Elizabeth existed."

### Flags Set
- `examined_gate_plaque`
- causes `front_gate_threshold_acknowledged` via room trigger

### Visual Design
- Wrought iron plaque bolted to gate pillar
- Green patina, Victorian lettering
- The sub-text is hard to read (player must examine closely)
- Reading it should subtly wake the approach: a gate creak, a lamp pulse, a bodily sense that the manor has accepted the player's attention

---

## 5. Abandoned Luggage

```yaml
id: gate_luggage
type: observation
position: (4, 0.3, -7)
collision: BoxShape3D(1.5, 1.0, 1.0)
```

### Text — All Variants

**Default:**
> **Abandoned Suitcase**
> "A leather traveling case, clasps still fastened. Packed but never carried beyond the gate. The luggage tag reads: 'H. Pierce — London.' The ink has run in the rain."

**After `read_guest_ledger` (guest room):**
> **Abandoned Suitcase**
> "Helena Pierce's suitcase. She arrived November 3rd, 1891. Her departure date was left blank. Now you know why — she never left the house alive."

### Flags Set
- `found_helena_luggage`

### Visual Design
- GLB: `luggage_mp_1.glb`
- Leather with brass clasps, slightly tilted as if dropped
- Luggage tag visible by implication rather than a separate prop

---

## 6. Stone Bench

```yaml
id: gate_bench
type: observation
position: (5, 0.5, -5)
collision: BoxShape3D(2.0, 1.0, 1.0)
```

### Text — All Variants

**Default:**
> **Stone Bench**
> "Cold stone. Snow has settled in the seat — undisturbed for decades. Someone sat here once, looking at the house, deciding whether to go in."

**After `knows_full_truth`:**
> **Stone Bench**
> "The children sat here the night they fled. Charles, Margaret, William. They looked back once. None of them ever returned."

### Flags Set
- None

### Visual Design
- GLB: `bench_mx_1.glb` (already placed)
- Snow accumulation implied by text (no separate snow mesh needed)

---

## 7. Iron Gate

```yaml
id: iron_gate
type: observation
position: (0, 1.5, -10)
collision: BoxShape3D(3.0, 3.0, 1.0)
```

### Text — Shared + Thread Variants

**Default:**
> **The Gate**
> "Iron bars, rusted open. The lock is broken — not from outside. Someone burst through from within. The hinges scream when the wind catches them."

**Captive thread:**
> **The Gate**
> "The broken lock tells the story plainly: something imprisoned here pushed against the bars until iron gave way. The gate is not an entrance feature. It is evidence."

**Mourning thread:**
> **The Gate**
> "The gate has been left open too long. Not flung wide in triumph. Left. Forgotten in the confusion after something terrible no one could undo. Even the hinges sound tired."

**Sovereign thread:**
> **The Gate**
> "The bars bow outward as though the house exhaled through them. The iron did not fail from neglect. It yielded to a force that had already decided this threshold belonged to it."

**After `elizabeth_aware`:**
> **The Gate**
> "The gate hangs open like a mouth. You notice now: the iron bars are bent outward. Whatever left this house was stronger than iron."

### Flags Set
- `examined_iron_gate`

### Visual Design
- GLB: none on the interactable itself; the gate read comes from surrounding fence/pillar dressing so the threshold stays visually open
- Emphasis in text: broken from inside, not forced from the road side

---

## 8. Gate Lamp

```yaml
id: gate_lamp
type: observation
position: (-4, 2.5, -10)
collision: BoxShape3D(1.0, 2.0, 1.0)
```

### Text — Shared + Thread Variants

**Default:**
> **Gas Lamp**
> "Still lit. After over a century, the gas lamp by the gate still burns. The flame doesn't flicker like fire — it pulses, like breathing."

**Captive thread:**
> **Gas Lamp**
> "The lamp keeps watch like a gaoler who never sleeps. Its pulse is too steady to be gas pressure and too patient to be weather. Something at the gate is keeping vigil."

**Mourning thread:**
> **Gas Lamp**
> "The old lamp burns with the weak persistence of a memorial candle. Not bright enough to guide, only enough to remember. It feels less like illumination than mourning made visible."

**Sovereign thread:**
> **Gas Lamp**
> "The flame breathes. Not metaphorically. Deliberately. The pressure rises and falls in a rhythm too intimate to ignore, as if the house has lungs and this is one of its visible breaths."

**After `elizabeth_aware`:**
> **Gas Lamp**
> "The lamp pulses in rhythm. You realize you've been breathing in sync with it. Since when?"

### Flags Set
- None

### Visual Design
- GLB: `lamp_mx_1_b_on.glb`
- Attached to the left gate pillar
- Warm omni light at `(-4, 3, -10)` with gas-flicker metadata

---

## Summary Table

| ID | Type | Position | Asset | Status |
|----|------|----------|-------|--------|
| `gate_sign_new_game` | observation | (-3.0, 3.2, -10.8) | procedural hanging board | Implemented |
| `gate_sign_load_game` | observation | (0, 3.2, -11.0) | procedural hanging board | Implemented |
| `gate_sign_settings` | observation | (3.0, 3.2, -10.8) | procedural hanging board | Implemented |
| `gate_plaque` | note | (-2, 1.5, -10) | gate pillar text | Implemented |
| `gate_luggage` | observation | (4, 0.3, -7) | `luggage_mp_1.glb` | Implemented |
| `gate_bench` | observation | (5, 0.5, -5) | `bench_mx_1.glb` | Implemented |
| `iron_gate` | observation | (0, 1.5, -10) | threshold volume only | Implemented |
| `gate_lamp` | observation | (-4, 2.5, -10) | `lamp_mx_1_b_on.glb` | Implemented |
