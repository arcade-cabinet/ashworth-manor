# Guest Room — Interactables

## 1. Guest Ledger — KEY NARRATIVE (NEW)

```yaml
id: guest_ledger
type: note
position: (3, 0.9, -2)  # Writing desk
collision: BoxShape3D(1.0, 0.5, 0.5)
```

### Text

> **Guest Ledger**
> "Mrs. Helena Pierce, arriving Nov 3rd 1891. Purpose: Social visit. Expected departure: Nov 10th.
>
> DEPARTED: [The entry is blank.]
>
> Below it, in different handwriting: 'She stopped coming to dinner after the third night.'"

### Flags Set
- `read_guest_ledger`

---

## 2. Helena's Photo (NEW)

```yaml
id: helena_photo
type: photo
position: (-3.5, 1.6, 0)  # Wall, beside bed
collision: BoxShape3D(0.5, 0.5, 0.3)
```

### Text — All Variants

**Default:**
> **Photograph**
> "A woman in traveling clothes, smiling at the camera. Confident. Ready for an adventure. She has no idea what this house will do to her."

**After `knows_full_truth`:**
> **Photograph**
> "Helena Pierce. She came for a weekend. She stayed forever. The house collected her like the wine cellar collects bottles — sealed, preserved, forgotten."

### Flags Set
- `examined_helena_photo`

---

## 3. Luggage (NEW)

```yaml
id: guest_luggage
type: observation
position: (3, 0.3, 2)  # Floor near door
collision: BoxShape3D(1.0, 0.8, 0.8)
model: luggage_mp_1.glb
```

### Text

> **Luggage**
> "Packed and ready. The clasps are undone — she was about to close it when she stopped. The clothes inside are folded neatly, then disturbed, as if she changed her mind about what to bring. Or whether to leave at all."

---

## 4. Bed (NEW)

```yaml
id: guest_bed
type: observation
position: (-2, 0.5, 2)  # Against wall
collision: BoxShape3D(2.0, 1.0, 1.5)
```

### Text

> **Bed**
> "Perfectly made. Hospital corners. As if by a professional. But the maids left the house weeks before Helena arrived. Who made this bed? Who kept this room so... ready?"

---

## 5. Dead Lamp (NEW)

```yaml
id: guest_lamp
type: observation
position: (3, 0.8, 0)  # Desk
collision: BoxShape3D(0.5, 0.5, 0.5)
model: lamp_mx_3_off.glb
```

### Text

> **Lamp**
> "An oil lamp, dry. The wick has been trimmed but never lit again. Helena was alone in the dark. The guest room has no gas line — just this one lamp. When the oil ran out, she had nothing."

---

## Summary

| ID | Type | Position | Status |
|----|------|----------|--------|
| `guest_ledger` | note | (3, 0.9, -2) | NEW |
| `helena_photo` | photo | (-3.5, 1.6, 0) | NEW |
| `guest_luggage` | observation | (3, 0.3, 2) | NEW — model exists |
| `guest_bed` | observation | (-2, 0.5, 2) | NEW |
| `guest_lamp` | observation | (3, 0.8, 0) | NEW — model exists |
