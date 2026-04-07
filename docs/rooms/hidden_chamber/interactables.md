# Hidden Chamber — Interactables

## 1. Elizabeth's Final Note — THE TRUTH
```yaml
id: elizabeth_final_note
type: note
position: (0, 0.5, 0.0)  # Center of ritual circle
```

### Text
**Default framing:**
> **Elizabeth's Final Note**
> "A sheet of paper in the center of the ritual circle. Elizabeth's handwriting -- older now, steadier. This is not a child's desperate letter. This is a statement written with purpose."

**Thread variants:**
- `captive`: explicitly asks to be found and freed from the cage built around her
- `mourning`: asks the reader to forgive and release the family's grief
- `sovereign`: frames the house as Elizabeth's chosen becoming rather than a prison

### Flags Set: `knows_full_truth`, `read_final_note`
### Phase Transition: Horror → Resolution

---

## 2. Drawings on Walls
```yaml
id: chamber_drawings
type: observation
position: (-2.5, 1.5, 0)  # Wall
```

### Text
**Default framing:**
> "The walls are covered in drawings. Charcoal on stone. A child's drawings at first -- houses, flowers, a family. Then older: diagrams, symbols, things that look like blueprints of the house itself."

**Thread variants:**
- `captive`: prison maps, exits, keys, and the final drawing of an open door
- `mourning`: a family growing further apart until Elizabeth is left alone with unsent letters
- `sovereign`: architectural and anatomical drawings of the house as something Elizabeth became from the inside

---

## 3. Mirror — Elizabeth Appears
```yaml
id: hidden_mirror
type: mirror
position: (2.5, 1.5, 0)
```

### Text
> "In the mirror, behind you, stands a girl in white. Small. Dark eyes. She doesn't move. She doesn't speak. She just watches. When you turn — nothing. But the mirror remembers."

### Runtime Notes
- Mirror effect metadata is attached through the declaration.
- This is a diegetic vision beat, not a separate cutscene trigger.

---

## 4. Ritual Circle — COUNTER-RITUAL
```yaml
id: ritual_circle
type: ritual
position: (0, 0.1, 0)  # Center of floor
```

### Interaction
Handled by `interaction_manager.gd` `_handle_ritual()`:
1. Place doll
2. Pour blessed water
3. Read the binding book
   - Doll cracks. Light. Drawings fade. Silence.
   - "Thank you."
   - → Freedom Ending

### Declaration Ready State
- Default text identifies the circle as a binding circle.
- Ready-state text appears only when `knows_full_truth AND HAS binding_book AND HAS blessed_water`.

---

## 5. Ritual Artifact
```yaml
id: chamber_artifact
type: observation
position: (0, 0.3, -2)
model: ritual_artifact.glb
```

### Text
> "A carved stone figure at the edge of the circle. The occultist's work, or Lord Ashworth's imitation of it. The stone is warm. Whatever this object once anchored, it still participates in."

---

## Summary
| ID | Type | Status |
|----|------|--------|
| `elizabeth_final_note` | note | Active |
| `chamber_drawings` | observation | Active |
| `hidden_mirror` | mirror | Active |
| `ritual_circle` | ritual | Active |
| `chamber_artifact` | observation | Active |
