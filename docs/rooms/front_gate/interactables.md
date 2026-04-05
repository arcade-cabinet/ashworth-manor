# Front Gate — Interactables

## 1. Gate Plaque (EXISTS — needs enrichment)

```yaml
id: gate_plaque
type: note
position: (-2, 1.5, -10)
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Ashworth Manor**
> "ASHWORTH MANOR — Est. 1847. The iron lettering is green with verdigris. Below, in smaller script barely legible: 'Abandon memory, all ye who enter.'"

**After `knows_full_truth`:**
> **Ashworth Manor**
> "'Abandon memory, all ye who enter.' They meant it literally. They tried to make the world forget Elizabeth existed."

### Flags Set
- `examined_gate_plaque`

### Visual Design
- Wrought iron plaque bolted to gate pillar
- Green patina, Victorian lettering
- The sub-text is hard to read (player must examine closely)

---

## 2. Abandoned Luggage (EXISTS — needs interactable data)

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
- GLB: `luggage_mp_1.glb` (already placed at (4,0,-7) with scale ~3)
- Leather with brass clasps, slightly tilted as if dropped
- Luggage tag visible (implied by text — no separate model needed)

---

## 3. Stone Bench (EXISTS — needs interactable data)

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

## 4. Iron Gate (NEW — add interactable)

```yaml
id: iron_gate
type: observation
position: (0, 1.5, -10)
collision: BoxShape3D(3.0, 3.0, 1.0)
```

### Text — All Variants

**Default:**
> **The Gate**
> "Iron bars, rusted open. The lock is broken — not from outside. Someone burst through from within. The hinges scream when the wind catches them."

**After `elizabeth_aware`:**
> **The Gate**
> "The gate hangs open like a mouth. You notice now: the iron bars are bent outward. Whatever left this house was stronger than iron."

### Flags Set
- `examined_iron_gate`

### Visual Design
- GLB: `iron_gate.glb` (already placed at (0,0,-10) scale 1.5)
- Emphasis in text: broken from INSIDE (not forced entry — forced exit)

---

## 5. Gate Lamp (NEW — add as interactable observation)

```yaml
id: gate_lamp
type: observation
position: (-4, 2.5, -10)
collision: BoxShape3D(1.0, 2.0, 1.0)
```

### Text — All Variants

**Default:**
> **Gas Lamp**
> "Still lit. After over a century, the gas lamp by the gate still burns. The flame doesn't flicker like fire — it pulses, like breathing."

**After `elizabeth_aware`:**
> **Gas Lamp**
> "The lamp pulses in rhythm. You realize you've been breathing in sync with it. Since when?"

### Flags Set
- None

### Visual Design
- GLB: `lamp_mx_1_b_on.glb` (already in assets, need to add to scene)
- Attached to gate pillar
- OmniLight3D already exists at (-4, 3, -10) with flickering metadata

---

## Summary Table

| ID | Type | Position | Asset | Status |
|----|------|----------|-------|--------|
| `gate_plaque` | note | (-2, 1.5, -10) | gate pillar text | EXISTS — update content |
| `gate_luggage` | observation | (4, 0.3, -7) | `luggage_mp_1.glb` | EXISTS as model — add Area3D |
| `gate_bench` | observation | (5, 0.5, -5) | `bench_mx_1.glb` | EXISTS as model — add Area3D |
| `iron_gate` | observation | (0, 1.5, -10) | `iron_gate.glb` | EXISTS as model — add Area3D |
| `gate_lamp` | observation | (-4, 2.5, -10) | `lamp_mx_1_b_on.glb` | Need to add model + Area3D |
