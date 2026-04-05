# Chapel — Interactables

## 1. Baptismal Font — PUZZLE ITEM
```yaml
id: baptismal_font
type: box
position: (0, 0.8, 3)
locked: false
item_found: blessed_water
```

### Text
**Default:** "A stone baptismal font. The water inside hasn't frozen, despite everything. It feels impossibly cold in your hands."
**After `knows_binding_ritual`:** "Purification water. Elizabeth was never baptized — her father believed that's what gave her the sight. The water that should have protected her now frees her."

### Items Given: `blessed_water` (counter-ritual component)

---

## 2. Altar
```yaml
id: chapel_altar
type: observation
position: (0, 0.5, -3)
```
### Text
> "Bare. Stripped of every religious ornament. Crosses, candlesticks, cloth — removed. Not by time. Deliberately. Someone didn't want God watching what they did here."

---

## 3. Overturned Pews
```yaml
id: chapel_pews
type: observation
position: (-2, 0.3, 0)
```
### Text
> "Overturned. Not by decay — by force. Thrown aside. A congregation of one, destroying the chapel in rage or grief."

---

## 4. Stained Glass
```yaml
id: chapel_glass
type: observation
position: (3, 2, -2)
```
### Text
> "Fragments of a saint's face. Deliberately smashed. From inside — the glass lies outside the frame. Someone punched through the face of a saint."

---

## 5. Loose Bones
```yaml
id: chapel_bones
type: observation
position: (-3, 0.1, 3)
model: loose_bones.glb
```
### Text
> "Scattered near the entrance. Animal? The size says yes. The arrangement says no. Placed, not fallen."

---

## Connections
| Target | Type | Position |
|--------|------|----------|
| `garden` | path | (-3, 1.5, -5) |
