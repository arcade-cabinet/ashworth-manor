# Family Crypt — Interactables

The family crypt is now the `Elder` final chamber. It is where burial truth and
failed memorial logic finally resolve.

## 1. Ashworth Graves

```yaml
id: crypt_graves
type: observation
```

Route reading:
- default: Elizabeth has no honest grave
- `elder`: the fifth place has been altered over and over, as if the family
  kept trying to make a burial fit a life that kept exceeding it

---

## 2. Lady Ashworth's Note

```yaml
id: crypt_note
type: note
```

Function:
- carries Victoria's private guilt into the burial space
- supports the crypt as intimate family truth rather than only atmosphere

---

## 3. Loose Flagstone

```yaml
id: crypt_flagstone
type: observation
```

Function:
- keeps Victoria's hidden acts physically present in the crypt
- supports the room as layered concealment, not just terminal evidence

---

## 4. Scattered Bones

```yaml
id: crypt_bones
type: observation
```

Function:
- reinforces that the space has been disturbed intentionally and repeatedly
- supports the crypt as maintained, revisited burial infrastructure

---

## 5. Gate Latch

```yaml
id: crypt_gate_latch
type: observation
```

Function:
- usable on `Elder`
- requires the hook
- unlocks the gate from the burial side
- proves the crypt had been sealed from the wrong side

---

## 6. Crypt Music Box

```yaml
id: crypt_music_box
type: observation
```

Function:
- final solve object for `Elder`
- requires `crypt_gate_unlocked`
- requires the brass winding key from the gate valise
- winding it sets `elder_music_box_wound` and `elder_route_complete`

---

## Summary

| ID | Role |
|----|------|
| `crypt_graves` | burial truth / route bias |
| `crypt_note` | Victoria's private guilt |
| `crypt_flagstone` | concealed family mercy |
| `crypt_bones` | repeated disturbance evidence |
| `crypt_gate_latch` | burial-side gate release |
| `crypt_music_box` | `Elder` final solve |
