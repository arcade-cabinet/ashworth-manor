# Garden — Interactables

## 1. White Lily — KEY NARRATIVE
```yaml
id: garden_lily
type: observation
position: (3, 0.2, 5)
```

### Text — All Variants
**Default:** "A single white lily. Alive. In December. The soil around it is warm to the touch."
**After `knows_attic_girl`:** "Elizabeth's flower. She tended it from the attic window. It kept growing even after she couldn't."

---

## 2. Frozen Fountain
```yaml
id: garden_fountain
type: observation
position: (0, 0.5, 0)
model: fountain01_round.glb
```
### Text
> "Frozen solid. The stone angel weeping icicles. Water turned to crystal mid-fall. Beautiful and dead."

---

## 3. Gazebo
```yaml
id: garden_gazebo
type: observation
position: (-5, 1, -3)
model: gazebo.glb
```
### Text
> "Bare lattice. In summer this would be beautiful. Now it's a cage of dead vines. A wrought-iron bench inside — cold to the touch."

---

## 4. Dead Flower Beds
```yaml
id: garden_beds
type: observation
position: (-3, 0.1, 3)
model: flowerbed_2x2_empty.glb
```
### Text
> "Empty flower beds. Stone borders, black soil, nothing growing. Except — there, in the corner. One white lily. Impossibly alive."

---

## Connections
| Target | Type | Position |
|--------|------|----------|
| `front_gate` | path | (-8, 1.5, 0) |
| `chapel` | path | (8, 1.5, 5) |
| `greenhouse` | path | (0, 1.5, 8) |
