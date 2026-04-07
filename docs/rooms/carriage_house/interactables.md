# Carriage House — Interactables

## 1. Duplicate Portrait — PUZZLE ITEM
```yaml
id: carriage_portrait
type: box
locked: false
item_found: cellar_key
position: (0, 1.5, 3)
```

### Text
**Default:** "Another portrait of Lord Ashworth. Why store a duplicate out here? Behind the backing, taped to the frame — a small iron key."
**After `read_wine_note`:** "'The key is with the portrait.' This is what they meant — not the one in the foyer. The cellar key, hidden with the spare portrait."

### Items Given: `cellar_key`

---

## 2. Old Mattress
```yaml
id: carriage_mattress
type: observation
position: (-2, 0.2, -2)
model: old_mattress_mx_1.glb
```
### Text
> "Someone slept here. Not in the house — here, in the carriage house. A servant who refused to sleep under the same roof as whatever was in the attic."

---

## 3. Boarding Materials
```yaml
id: carriage_boards
type: observation
position: (2, 0.5, 0)
```
### Text
> "Boards with nails driven through them. Used to seal something — windows? The attic? Some of these nails are bent. Someone pulled the boards off again."

---

## Connections
| Target | Type |
|--------|------|
| `storage_basement` | secret_path / service path |
