# Storage Basement — Interactables

This room is now the first real survival beat after Elizabeth forces the player
down through the kitchen service hatch. The basement is dark, foul, and
service-minded rather than occult.

## 1. Improvised Relight — First Survival Action

```yaml
id: improvised_relight
type: switch
position: near dead lamp and oily rags
```

Purpose:
- the player reclaims light with a struck match and makeshift relight logic
- sets `basement_relight`
- wakes the first local candle/light response through conditional events

Without relight, the room's other interactions mostly collapse into touch,
disorientation, and bad-air pressure.

---

## 2. Scratched Family Portrait

```yaml
id: scratched_portrait
type: painting
position: west wall behind stacked service clutter
```

Default reading:
- Lord Ashworth's face has been clawed out and hidden below the house rather
  than destroyed outright

Route bias:
- `child`: rage against the man who erased the room
- `adult`: the portrait is damaged into honesty rather than reverence
- `elder`: the damage reads like the house reclaiming his authority

---

## 3. Iron Cage

```yaml
id: basement_cage
type: observation
position: floor-level service corner
```

Function:
- keeps the landing space materially ugly and wrong
- reinforces that the service basement once held watch, restraint, or both

---

## 4. Concealed Stack

```yaml
id: service_stack
type: observation
position: stacked crates hiding a hollow wall
```

Function:
- teaches that the service world conceals routes physically
- sets `noticed_service_route`
- prepares later service-house reasoning rather than solving a route by itself

---

## 5. Old Mattress

```yaml
id: basement_mattress
type: observation
position: laid directly on stone
```

Function:
- explains the player's softened landing
- implies prolonged service watching or caretaking below the family rooms

---

## Summary

| ID | Type | Role |
|----|------|------|
| `improvised_relight` | switch | first survival/light recovery action |
| `scratched_portrait` | painting | route-biased basement evidence |
| `basement_cage` | observation | material restraint residue |
| `service_stack` | observation | concealment / route foreshadowing |
| `basement_mattress` | observation | bodily landing + watcher residue |
