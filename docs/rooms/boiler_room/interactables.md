# Boiler Room — Interactables

## 1. Maintenance Log (EXISTS)
```yaml
id: maintenance_log
type: note
position: (2, 1, -2)
```

### Text
> **Maintenance Log**
> "Dec 15, 1891 — Strange sounds from the pipes again. The staff refuse to come down here after dark. Something is wrong with this house."

### Flags Set: `read_maintenance_log`, `knows_staff_afraid`

---

## 2. Industrial Clock (NEW)
```yaml
id: boiler_clock
type: clock
position: (-2, 2, 3)
```

### Text
> **Clock**
> "3:33. Even here, in the belly of the house. The industrial clock is built for reliability — spring mechanism, not pendulum. It shouldn't have stopped. Nothing should have stopped it."

### Flags Set: `examined_boiler_clock`

---

## 3. Boiler (NEW)
```yaml
id: boiler_observation
type: observation
position: (0, 1, 3)
```

### Text — All Variants

**Default:**
> **Boiler**
> "Massive cast iron. Still warm to the touch. The firebox has ash in it — grey, not black. Someone fed this boiler recently. But who? The house has been abandoned for over a century."

**After `elizabeth_aware`:**
> **Boiler**
> "The warmth isn't from coal. There's no fuel in the firebox. The boiler generates its own heat now. The house has a heartbeat."

---

## 4. Pipes (NEW)
```yaml
id: boiler_pipes
type: observation
position: (0, 2.5, 0)
```

### Text — All Variants

**Default:**
> "Pipes snake across the ceiling and into the walls. They carry heat — or carried it, once. They run to every room. The entire house is connected through these veins."

**After `elizabeth_aware`:**
> "The pipes groan. For a moment, you hear words in the groaning. Not your name. Hers."

---

## 5. Mask on Wall (NEW)
```yaml
id: boiler_mask
type: observation
position: (-2.5, 1.8, 0)
model: mask_mx_2.glb
```

### Text
> **Mask**
> "A metallic mask on a nail. The expression is frozen in a scream. Industrial safety equipment? Or something the occultist wore? The inside is stained dark."

---

## Summary
| ID | Status |
|----|--------|
| `maintenance_log` | EXISTS |
| `boiler_clock` | NEW |
| `boiler_observation` | NEW |
| `boiler_pipes` | NEW |
| `boiler_mask` | NEW — model exists |
