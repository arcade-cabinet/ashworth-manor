# Guest Room — Interactables

## 1. Guest Ledger — Key Narrative

```yaml
id: guest_ledger
type: note
position: (-3.5, 0.9, -3.0)  # Desk on west wall
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text

**Default:**
> **Guest Ledger**
> "A leather guest book. Most entries are perfunctory: 'Lovely stay, splendid hospitality.' The last entry is from Helena Pierce, November 3rd, 1891: 'Arrived for research on spiritual phenomena. Lord Ashworth most accommodating. The house is remarkable.' She never wrote a departure entry."

**Captive thread:**
> Helena arrived to validate Lord Ashworth's imprisonment of Elizabeth and never left the house alive.

**Mourning thread:**
> Helena arrived believing she could help a grieving family and became another failure folded into the house's sorrow.

**Sovereign thread:**
> Helena recognized Elizabeth's power, treated it as remarkable rather than shameful, and seems to have entered into a correspondence with her.

### Flags Set
- `read_guest_ledger`

---

## 2. Helena's Photo

```yaml
id: helena_photo
type: photo
position: (-3.5, 1.6, 0.0)  # West wall frame
collision: BoxShape3D(0.8, 0.8, 0.4)
```

### Text — Live Variants

**Default:**
> **Photograph**
> "A woman in traveling clothes, smiling at the camera with the confidence of someone who expects to return home and tell a story about all this. Helena Pierce before Ashworth Manor corrected that assumption."

**After `knows_full_truth`:**
> **Photograph**
> "Helena Pierce. She came for a weekend and the house kept her. The smile in the photograph belongs to someone who still believed haunted houses were subjects to be studied instead of mouths that close."

### Flags Set
- `examined_helena_photo`

---

## 3. Luggage

```yaml
id: guest_luggage
type: observation
position: (3, 0.3, 2)  # Floor near door
collision: BoxShape3D(1.0, 0.8, 0.8)
model: luggage_mp_1.glb
```

### Text

> **Luggage**
> "Packed and nearly closed. One clasp is still open. Helena was preparing to leave, or pretending to. The folds inside are neat until the top layer, where everything becomes hurried and uncertain."

---

## 4. Bed

```yaml
id: guest_bed
type: observation
position: (2.0, 0.8, 0.0)
collision: BoxShape3D(2.0, 1.0, 2.0)
```

### Text

> **Guest Bed**
> "The bed is made but not pristine. The pillow still holds an impression. Helena slept here for seven weeks before she vanished. Her valise is open at the foot of the bed -- half unpacked, as if she planned to stay longer."

---

## 5. Dead Lamp

```yaml
id: guest_lamp
type: observation
position: (3, 0.8, 0)  # Desk
collision: BoxShape3D(0.5, 0.5, 0.5)
model: lamp_mx_3_off.glb
```

### Text

> **Lamp**
> "A dry oil lamp on the desk. The wick was trimmed for one more night and never lit. Helena wrote by moonlight after this. Or she stopped writing entirely."

---

## Summary

| ID | Type | Position | Status |
|----|------|----------|--------|
| `guest_ledger` | note | (-3.5, 0.9, -3) | Active |
| `helena_photo` | photo | (-3.5, 1.6, 0) | Active |
| `guest_luggage` | observation | (3, 0.3, 2) | Active |
| `guest_bed` | observation | (2, 0.8, 0) | Active |
| `guest_lamp` | observation | (3, 0.8, 0) | Active |
