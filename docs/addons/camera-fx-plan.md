# Camera FX Plan — shaky-camera-3d

## Source
- Addon: `synalice/shaky-camera-3d`
- Location: `addons/shaky_camera_3d/`

## Purpose

Camera shake for horror moments. Per VISION.md: NO jump scares, NO strobing. Shake is subtle and intentional.

## Usage Map

| Event | Shake Type | Trauma | Duration | Frequency |
|-------|-----------|--------|----------|-----------|
| Walking | Head bob | 0.02 | Continuous | Tied to step cycle |
| First clue found | Single jolt | 0.15 | 0.3s | Once |
| Enter attic | Sustained tremor | 0.1 | 2.0s | Low |
| Elizabeth mirror event | Sharp shake | 0.3 | 0.5s | Once |
| Ritual step completion | Building pulse | 0.1→0.4 | 3.0s | Increasing |
| Ritual final moment | Heavy + release | 0.5→0.0 | 2.0s | Decaying |
| Ending trigger | Sustained deep | 0.2 | 5.0s | Slow |

## Integration

Add `ShakyCamera3D` as sibling/replacement for player's Camera3D. Control via:
```gdscript
shaky_cam.add_trauma(amount)  # 0.0 - 1.0
```

Connected to LimboAI HSM state changes and specific flag events.

## Implementation Steps

1. Replace player Camera3D with ShakyCamera3D (or nest it)
2. Create shake profiles for each event type
3. Connect GameManager.flag_set to shake triggers
4. Test: verify no shake during normal exploration, verify shake on Elizabeth events
