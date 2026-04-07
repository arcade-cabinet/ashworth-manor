# Storage Basement — Interactables

## 1. Scratched Family Portrait — Key Narrative

```yaml
id: scratched_portrait
type: painting
position: (-3.5, 1.5, -3)
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text — All Variants

**Default:**
> **Scratched Portrait**
> "A portrait shoved behind crates in the basement. Lord Ashworth's face has been scratched out with something sharp -- the canvas torn in long, deliberate strokes. Someone hated this image enough to destroy it but could not bring themselves to burn it."

**Macro-thread variants:**
- `captive`: the damage reads as rage against the jailer
- `mourning`: the damage reads as Victoria making the portrait honest
- `sovereign`: the scratches read like Elizabeth's symbols claiming him

### Flags Set
- `examined_scratched_portrait`

---

## 2. Iron Cage

```yaml
id: basement_cage
type: observation
position: (3, 0.5, 3)
collision: BoxShape3D(1.5, 1.5, 1.5)
```

### Text

**Default:**
> **Iron Cage**
> "An animal cage, large enough for a dog. Empty. The door hangs open. The lock is rusted shut in the open position. Whatever was kept here was released -- or escaped."

---

## 3. Concealed Stack

```yaml
id: service_stack
type: observation
position: (2.4, 1.0, 3.7)
collision: BoxShape3D(1.6, 2.0, 1.2)
```

### Text

> **Concealed Stack**
> "The crates here are stacked too deliberately for storage. They hide the wall rather than use it. When you press near the back, the wood gives a little and the stone behind it answers hollow. This corner was arranged to conceal movement, not clutter."

### Flags Set
- `noticed_service_route`

---

## 4. Old Mattress

```yaml
id: basement_mattress
type: observation
position: (2.7, 0.35, 2.0)
collision: BoxShape3D(1.5, 0.8, 2.0)
```

### Text

> **Old Mattress**
> "A mattress laid directly on the basement stone, close to the cage and farther from the stairs than anyone sleeping here would want. Someone stayed down here for many nights in a row. Not a guest. A servant, a guard, or someone who needed to watch this room without being seen."

---

## Summary

| ID | Type | Status |
|----|------|--------|
| `scratched_portrait` | painting | Implemented |
| `basement_cage` | observation | Implemented |
| `service_stack` | observation | Implemented |
| `basement_mattress` | observation | Implemented |
