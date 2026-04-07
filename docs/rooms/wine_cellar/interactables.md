# Wine Cellar — Interactables

## 1. Wine Inventory Note
```yaml
id: wine_note
type: note
position: (-3.5, 1.2, 2)
```

### Text
> **Inventory List — 1887**
> "The 1872 Bordeaux has been moved to the hidden alcove. Master insists no one shall find it. The key is with the portrait."

### Flags Set: `read_wine_note`

---

## 2. Locked Box — Puzzle Item
```yaml
id: wine_box
type: box
locked: true
key_id: cellar_key
item_found: mothers_confession
position: (-3.5, 0.3, 0)
```

### Text — Locked
> "A wooden chest, bound with iron. Heavy padlock. The inventory note mentioned 'the key is with the portrait' — but which one?"

### Text — Unlocked (has `cellar_key`)
> **Lady Ashworth's Confession**
> "I am complicit in what was done to our daughter. When Elizabeth first spoke of seeing the dead, I told myself she was ill. When Edmund brought the occultist, I told myself it was medicine. When they locked her in the attic with that horrible doll, I told myself it was for her safety.
>
> I lied. To everyone. To myself.
>
> Elizabeth was never dangerous. She was gifted. And we destroyed her for it.
>
> If anyone finds this, know that we deserve what is coming. The house knows. Elizabeth knows. And soon, so shall we.
>
> — Victoria Ashworth, December 23rd, 1891"

### Items Given: `mothers_confession` (counter-ritual component)

---

## 3. Wine Racks
```yaml
id: wine_racks
type: observation
position: (-3.3, 1, 0)
```

### Text
> "Most bottles covered in dust — decades undisturbed. But several gaps where bottles were recently removed. No dust in those spots. Recently? That's impossible."

---

## 4. Footprints
```yaml
id: wine_footprints
type: observation
position: (0, 0.1, 3)
```

### Text
> "Footprints in the dust. They lead from the ladder to the wall. And stop. No return prints. Whoever walked here went to the wall and... through it?"

---

## Summary
| ID | Status |
|----|--------|
| `wine_note` | Implemented |
| `wine_box` | Active |
| `wine_racks` | Active |
| `wine_footprints` | Active |
