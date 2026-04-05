# Family Crypt — Interactables

## 1. Crypt Gate (at entrance)
```yaml
id: crypt_gate
type: locked_door
key_id: gate_key
target_room: family_crypt
position: (0, 1.5, -5)
message_locked: "An iron gate, locked. The key must be somewhere on the grounds."
```

---

## 2. Graves
```yaml
id: crypt_graves
type: observation
position: (0, 0.5, 0)
```

### Text — All Variants
**Default:** "Three headstones. Edmund. Victoria. And one blank, weathered stone. No grave for a fourth child."
**After `knows_full_truth`:** "Edmund. Victoria. They buried themselves here but left no room for Elizabeth. There was never going to be a grave for her."

---

## 3. Lady's Note — CLUE
```yaml
id: crypt_note
type: note
position: (-2, 0.8, 2)
```
### Text
> "I hid the locket key here because I cannot bear to see her face. Forgive me, Elizabeth. Forgive us all."

---

## 4. Loose Flagstone — PUZZLE ITEM
```yaml
id: crypt_flagstone
type: box
locked: false
item_found: jewelry_key
position: (-2, 0.1, 2)
```
### Text
> "Beneath the flagstone — a tiny brass key with a heart-shaped bow. Hidden by a mother who loved her daughter but helped destroy her."

### Items Given: `jewelry_key`

---

## 5. Scattered Bones
```yaml
id: crypt_bones
type: observation
position: (3, 0.1, -2)
model: scattered_bones.glb
```
### Text
> "Not in the graves. Outside them. Disturbed. Not by animals — the crypt gate was locked. Whatever moved these bones had a key."

---

## Connections
| Target | Type | Locked |
|--------|------|--------|
| `garden` | path | Yes — requires `gate_key` |

## Flashback (Post-`knows_full_truth`)
Lady Ashworth kneeling at blank stone, placing flowers. Text: "Victoria came here every night. She mourned a daughter she helped imprison. The flowers never lasted."
