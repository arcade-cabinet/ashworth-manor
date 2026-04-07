# Greenhouse — Interactables

## 1. Terra Cotta Pot — PUZZLE ITEM
```yaml
id: greenhouse_pot
type: observation
position: (0, 0.82, -1.95)
```

### Runtime Visual States
- Intact: [`greenhouse_lily_pot_intact.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_lily_pot_intact.tscn)
- Disturbed / searched: [`greenhouse_lily_pot_disturbed.tscn`](/Users/jbogaty/src/arcade-cabinet/ashworth-manor/scenes/shared/greenhouse/greenhouse_lily_pot_disturbed.tscn)

### Text
**Default:** "A terra cotta pot with a white lily. The soil is warm despite the cold room. Something is buried in it besides roots."
**After disturbance:** "The lily still stands, but the soil has been turned over. Whatever was hidden here has already been taken."

### Items Given: `gate_key`

---

## 2. Dead Plants
```yaml
id: greenhouse_dead_plants
type: observation
position: (-2.45, 0.5, 0.35)
```
### Text
> "Everything dead except the lilies. Rows of withered stems. Pots cracked by frost. But wherever Elizabeth's flowers grow, the soil is warm and the leaves are green."

---

## 3. Potting Bench
```yaml
id: greenhouse_bench
type: observation
position: (2.75, 0.8, -1.7)
```
### Text
> "A workbench with dried soil, twine, trowels, and Victoria's gloves left where she last set them down."

---

## 4. Broken Glass
```yaml
id: greenhouse_glass
type: observation
position: (0, 2.1, -3.05)
```
### Text
> "Several glass panels shattered. The shards point outward — something pushed through from inside. Not wind. Not decay. Force."

---

## Connections
| Target | Type |
|--------|------|
| `garden` | path |
