# Dining Room — Interactables

## 1. Dinner Party Photo

```yaml
id: dinner_photo
type: photo
position: (-3.5, 2.0, 0)
collision: BoxShape3D(1.5, 1.5, 1.5)
model: picture_blank_002.glb
```

### Text — Shared + Thread Variants

**Default:**
> **Dinner Party Photo**
> "A photograph of a dinner party. Eight guests, formal dress, candlelight. Everyone is smiling except Lord Ashworth, who stares directly at the camera. The date on the back: December 23rd, 1891."

**After `read_maintenance_log`:**
> **Dinner Party Photo**
> "The caretaker wrote 'they dine while the girl screams.' This photo was taken that night. Everyone is smiling. One of them is already dead by morning."

**After `knows_full_truth`:**
> **Dinner Party Photo**
> "The last dinner. December 23rd, 1891. Three guests dead within the week. And somewhere above them, behind a locked door, a child they had all agreed to forget."

**Captive thread:**
> **Dinner Party Photo**
> "Eight guests at dinner. Everyone smiling. But look at the background -- the ceiling above them. Is that a shadow? A handprint on the plaster, directly above the table? She was there. Above them. Listening to them laugh while she sat in the dark. The photograph captured the party. It also captured her prison."

**Mourning thread:**
> **Dinner Party Photo**
> "Eight guests at dinner. Seven smiling. Victoria, at the far end of the table, is not smiling. She is looking at the empty chair -- the ninth place setting. Set but unused. She set a plate for Elizabeth every night. The servants knew not to clear it. Grief made visible in china and silverware."

**Sovereign thread:**
> **Dinner Party Photo**
> "Eight guests at dinner. The candles in the photograph are all tilted the same direction -- toward Lord Ashworth's end of the table. Not from a draft. From her. She was pulling the flames. Testing her reach. Everyone in the photograph is smiling at the camera. The candles are looking at something else entirely."

### Flags Set
- `examined_dinner_photo`

---

## 2. Pushed Chair

```yaml
id: pushed_chair
type: observation
position: (1, 0.5, -2)
collision: BoxShape3D(1.0, 1.0, 1.0)
```

### Text

**Default:**
> **Pushed Chair**
> "One chair pushed back from the table, angled as if someone stood suddenly. The plate is untouched. The napkin is on the floor. Whoever sat here left mid-course -- or was taken."

### Flags Set
- `examined_pushed_chair`

---

## 3. Wine Glass

```yaml
id: wine_glass
type: observation
position: (-1, 0.78, -2)
collision: BoxShape3D(0.5, 0.5, 0.5)
scene_path: res://scenes/shared/dining_room/dining_wine_glass_still.tscn
state_model_map:
  agitated: res://scenes/shared/dining_room/dining_wine_glass_agitated.tscn
```

### Text — Shared + Thread Variants

**Default:**
> **Wine Glass**
> "A single wine glass, still full. Dark red, almost black. After 130 years, it has not evaporated. The wine surface trembles faintly -- as if something beneath the table breathes."

**Captive thread:**
> **Wine Glass**
> "A full wine glass. The liquid is dark, still, preserved. Was it poisoned? In a house where a child is locked in the attic, the wine at the dinner table feels like evidence. Someone poured this glass and no one drank it. Someone knew what was in it. Or what was above them."

**Mourning thread:**
> **Wine Glass**
> "A full wine glass. Untouched. Saved for someone who never came down to dinner. Victoria poured this glass -- you know it the way you know everything about grief in this house. She poured it for Elizabeth. Every night. And every night it sat untouched. And every morning she poured it out and set a fresh glass. The ritual of a mother who cannot let go."

**Sovereign thread:**
> **Wine Glass**
> "A full wine glass. The liquid trembles. Not from vibration -- from within. Small ripples pulse outward from the center at regular intervals. A heartbeat. The wine is not preserved. It is maintained. She is keeping it fresh. She is keeping everything in this room exactly as it was on the night of December 23rd, 1891. The whole room is a display case and she is the curator."

### Flags Set
- `examined_wine_glass`

### Visual States
- `still` on room load
- `agitated` after inspection

---

## 4. Table Candles

```yaml
id: dining_candles
type: observation
position: (0, 1.2, 0)
collision: BoxShape3D(1.0, 1.0, 1.0)
```

### Text

**Default:**
> **Candelabra**
> "Silver candelabra with half-melted candles. The wax has dripped and frozen in mid-flow. Even the candles stopped at the same moment as the clocks."

### Flags Set
- `examined_dining_candles`

---

## 5. Service Bell

```yaml
id: service_bell
type: observation
position: (2, 0.8, 3)
collision: BoxShape3D(0.5, 0.5, 0.5)
```

### Text

**Default:**
> **Service Bell**
> "A small brass bell for summoning servants. You ring it. The sound is muffled -- as if the air itself absorbs the vibration. No one is coming."

### Flags Set
- None

---

## Summary Table

| ID | Type | Position | Status |
|----|------|----------|--------|
| `dinner_photo` | photo | (-3.5, 2.0, 0) | Implemented |
| `pushed_chair` | observation | (1, 0.5, -2) | Implemented |
| `wine_glass` | observation | (-1, 0.78, -2) | Active stateful setpiece |
| `dining_candles` | observation | (0, 1.2, 0) | Implemented |
| `service_bell` | observation | (2, 0.8, 3) | Implemented |
