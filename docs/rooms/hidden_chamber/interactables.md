# Hidden Chamber — Interactables

## 1. Elizabeth's Final Words — THE TRUTH
```yaml
id: elizabeth_final_note
type: note
position: (0, 1.2, 2.5)  # On wall, center of drawings
```

### Text
> **Elizabeth's Last Words**
> "I understand now. The doll showed me.
>
> I was never sick — they were afraid of what I could see. The house has eyes. The walls have ears. And now I am part of it forever.
>
> Find me. Free me. Or join me."

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
> "Hundreds of drawings cover every inch of wall. The same girl, over and over. Black eyes. The doll. The house with eyes in every window. Mouths in the walls.
>
> Written across the ceiling: 'THEY MADE ME THIS.' And below it: 'IT SEES EVERYTHING.'"

---

## 3. Mirror — Elizabeth Appears
```yaml
id: hidden_mirror
type: mirror
position: (2.5, 1.5, 0)
```

### Text
> "In the mirror, behind you, stands a girl in white. Small. Dark eyes. She doesn't move. She doesn't speak. She just watches. When you turn — nothing. But the mirror remembers."

### Flags Set: Triggers `event_elizabeth_appears` (camera shake, child's laugh, lights flicker)

---

## 4. Ritual Circle — COUNTER-RITUAL
```yaml
id: ritual_circle
type: ritual
position: (0, 0.1, 0)  # Center of floor
```

### Interaction
Handled by `interaction_manager.gd` `_handle_ritual()`:
1. Place doll → "The candles flicker."
2. Pour blessed water → "The drawings shift."
3. Read binding book → **"Elizabeth Ashworth. Born in light. Free."**
   - Doll cracks. Light. Drawings fade. Silence.
   - "Thank you."
   - → Freedom Ending

### Prerequisites: All 6 counter-ritual components in inventory + `read_final_note`

---

## 5. Ritual Artifact
```yaml
id: chamber_artifact
type: observation
position: (0, 0.3, -2)
model: ritual_artifact.glb
```

### Text
> "A stone figure in the center of a chalk circle. The occultist's work. This is where the binding was performed. Elizabeth was standing right here when they took her away."

---

## Summary
| ID | Type | Status |
|----|------|--------|
| `elizabeth_final_note` | note | NEW |
| `chamber_drawings` | observation | NEW |
| `hidden_mirror` | mirror | NEW |
| `ritual_circle` | ritual | NEW |
| `chamber_artifact` | observation | NEW — model exists |
