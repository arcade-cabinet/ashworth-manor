# Front Gate — Interactables

## 1. Diegetic Estate Sign — Enter the Grounds

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
- left sign of an equal-weight estate trio beneath the brass plaque
- meant to read before the player commits to the hedge-lined approach

---

## 2. Diegetic Estate Sign — Resume the Visit

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
- central hanging sign in the estate trio
- same procedural board stack as the other menu signs

---

## 3. Diegetic Estate Sign — Adjust the House

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
- right sign of the estate trio
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
> "ASHWORTH MANOR — Est. 1847. The brass has gone green at the edges, but someone has kept the name legible. It feels less abandoned than unattended."

**Child route:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. The plaque hangs with the politeness of old authority. That is what makes it oppressive. The house still expects obedience from people who no longer live here."

**Adult route:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. Verdigris has softened every letter, as if even the metal has been grieving. The name is still beautiful. That only deepens the sadness."

**Elder route:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. The plaque reads like a declaration of ownership that survived everyone who tried to bear it. The estate still speaks in the family name."

**After `knows_full_truth`:**
> **Ashworth Manor**
> "The family name looks different now. Not larger. Just less complete. Elizabeth was always inside it, even when they tried to strike her out."

### Flags Set
- `examined_gate_plaque`
- causes `front_gate_threshold_acknowledged` via room trigger

### Visual Design
- Brass estate plaque mounted where a visitor can read it before committing inward
- Green patina at the edges, but the inscription remains readable
- Respectable first, uncanny only in hindsight
- Reading it should deepen the sense of formal obligation rather than trigger an overt haunted effect

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
> "A leather traveling case, clasps still fastened. Packed but never carried beyond the gate. The luggage tag reads: 'H. Pierce — London.' No one bothered to reclaim it."

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
> "Cold stone, damp at the edges. The sort of bench where a child might have been told to wait while adults decided something out of earshot."

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
> "One iron leaf stands partly open. The chain has been unhooked, not cleanly put away. Someone expected arrival, or failed to finish departing."

**Child route:**
> **The Gate**
> "The gate is too formal to be harmless. Even left open, it still feels like something that decides who may pass."

**Adult route:**
> **The Gate**
> "The gate has been left open too long. Not flung wide in triumph. Merely left, as though whoever last crossed it could not bring themselves to finish the small courtesy of closing it."

**Elder route:**
> **The Gate**
> "The threshold still carries itself like property, not ruin. The gate is open, but the estate does not feel surrendered."

**After `elizabeth_aware`:**
> **The Gate**
> "You notice now how deliberate the opening feels. Not forced. Not welcoming either. Simply waiting."

### Flags Set
- `examined_iron_gate`

### Visual Design
- GLB: none on the interactable itself; the gate read comes from surrounding fence/pillar dressing so the threshold stays visually open
- Emphasis in text: left unsettled rather than violently exploded

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
> "Still lit. The flame is small, sheltered behind glass, and steady enough to suggest recent tending. For a supposedly empty estate, that is unsettling enough."

**Child route:**
> **Gas Lamp**
> "The lamp keeps watch like a servant who was never dismissed. Its small discipline makes the threshold feel supervised."

**Adult route:**
> **Gas Lamp**
> "The old lamp burns with the weak persistence of a memorial candle. Not bright enough to welcome, only enough to remember."

**Elder route:**
> **Gas Lamp**
> "The flame holds itself with more discipline than comfort. The estate may be empty, but it has not relaxed."

**After `elizabeth_aware`:**
> **Gas Lamp**
> "The flame gutters once as you near it, though the air is otherwise still. That is enough."

### Flags Set
- None

### Visual Design
- GLB: `lamp_mx_1_b_on.glb`
- hybrid target: brass body, glazed panes, procedural flame/light
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
