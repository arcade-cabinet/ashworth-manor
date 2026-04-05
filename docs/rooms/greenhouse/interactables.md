# Greenhouse — Interactables

## 1. Terra Cotta Pot — PUZZLE ITEM
```yaml
id: greenhouse_pot
type: box
locked: false
item_found: gate_key
position: (3, 0.3, 2)
```

### Text
**Default:** "A terra cotta pot with a white lily. Identical to the garden's. Behind the pot, pushed into the soil — an iron key. It's warm."
**After `knows_attic_girl`:** "Another of Elizabeth's lilies. She kept growing them even after death. The key was hers — she wanted it found."

### Items Given: `gate_key`

---

## 2. Dead Plants
```yaml
id: greenhouse_dead
type: observation
position: (-2, 0.5, 0)
```
### Text
> "Everything dead except the lilies. Rows of withered stems. Pots cracked by frost. But wherever Elizabeth's flowers grow, the soil is warm and the leaves are green."

---

## 3. Broken Glass
```yaml
id: greenhouse_glass
type: observation
position: (0, 2, -3)
```
### Text
> "Several glass panels shattered. The shards point outward — something pushed through from inside. Not wind. Not decay. Force."

---

## Connections
| Target | Type |
|--------|------|
| `garden` | path |
