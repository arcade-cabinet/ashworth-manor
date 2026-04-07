# Boiler Room — Interactables

## 1. Maintenance Log
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

## 2. Industrial Clock
```yaml
id: boiler_clock
type: clock
position: (0, 3, 3.5)
```

### Text
> **Clock**
> "3:33. Even here, in the belly of the house. The industrial clock is built for reliability — spring mechanism, not pendulum. It shouldn't have stopped. Nothing should have stopped it."

### Flags Set: `examined_boiler_clock`

---

## 3. Boiler
```yaml
id: boiler_observation
type: observation
position: (0, 1.5, 3.5)
```

### Text — All Variants

**Default:**
> **Boiler**
> "Massive cast iron. Still warm to the touch. The firebox has ash in it — grey, not black. Someone fed this boiler recently. But who? The house was supposed to have gone still."

**After `elizabeth_aware`:**
> **Boiler**
> "The warmth isn't from coal. There's no fuel in the firebox. The boiler generates its own heat now. The house has a heartbeat."

---

## 4. Pipe Valves
```yaml
id: boiler_pipe_valves
type: switch
position: (2.5, 1.2, 3.5)
```

### Function
- Progressive three-step valve interaction
- Delivers the A-path clue through the pipe chord / Elizabeth voice sequence

---

## 5. Electrical Panel
```yaml
id: boiler_electrical_panel
type: switch
position: (-2.5, 1.2, 3.5)
```

### Function
- Alternate B-path interaction
- Restores power and reveals clue-bearing details elsewhere

---

## 6. Mask on Wall
```yaml
id: boiler_mask
type: observation
position: (-2.4, 1.8, 0.2)
model: mask_mx_2.glb
```

### Text
> **Mask**
> "A metallic mask on a nail. The expression is frozen in a scream. Industrial safety equipment? Or something the occultist wore? The inside is stained dark."

---

## Summary
| ID | Status |
|----|--------|
| `maintenance_log` | Implemented |
| `boiler_clock` | Active |
| `boiler_observation` | Active |
| `boiler_pipe_valves` | Active |
| `boiler_electrical_panel` | Active |
| `boiler_mask` | Active |
