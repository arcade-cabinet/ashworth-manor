# Hidden Chamber — Interactables

The hidden chamber is no longer documented as a ritual room. In the shipped
game it is the sealed room: erased domestic truth preserved behind plaster.

## 1. Child Music Box — Final Solve
```yaml
id: child_music_box
type: observation
position: child-height table / bed-adjacent surface
```

Function:
- requires the brass winding key carried from the gate
- sets `child_music_box_wound`
- sets `child_route_complete`
- sets `knows_full_truth`
- resolves the `Child` route

---

## 2. Nursery Drawings
```yaml
id: nursery_drawings
type: observation
position: wall surface
```

Reading:
- not occult diagrams
- exit attempts, room memory, and childish persistence
- the declaration explicitly treats them as the record of a child trying to
  imagine her way out

---

## 3. Child Bed
```yaml
id: child_bed
type: observation
position: sealed-room focal furniture
```

Function:
- proves the room remained a child's room
- anchors the room as domestic erasure rather than supernatural theater

---

## 4. Height Marks
```yaml
id: height_marks
type: observation
position: wall beside the bed
```

Function:
- makes time, watching, and stopping visible
- keeps the room architectural and bodily

---

## 5. Nursery Mirror
```yaml
id: nursery_mirror
type: mirror
position: wall-mounted frame
```

Function:
- provides the room's reflective memory beat
- supports the feeling that the sealed room remembers the child that the house
  tried to deny

---

## Summary
| ID | Type | Status |
|----|------|--------|
| `child_music_box` | observation | Active |
| `nursery_drawings` | observation | Active |
| `child_bed` | observation | Active |
| `height_marks` | observation | Active |
| `nursery_mirror` | mirror | Active |
