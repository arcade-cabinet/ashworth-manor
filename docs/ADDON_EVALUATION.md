# Addon Plan — Ashworth Manor

Research date: 2026-04-05

## Principle

**No shader on PSX assets.** The 116 mansion GLBs and 596 texture PNGs are already PSX-quality (low-poly, low-res textures, baked colors). Per-material shaders (vertex snapping, affine mapping) are for making *modern* assets look retro — applying them to already-retro assets is double-processing for zero benefit. Only screen-space post-processing (dithering, resolution reduction) adds authentic PS1 frame-buffer feel.

---

## Addon Registry

| # | Addon | Status | Purpose | Plan Doc |
|---|-------|--------|---------|----------|
| 1 | godot-psx | INSTALLED | Screen-space dither + fade ONLY | [shader-plan.md](./addons/shader-plan.md) |
| 2 | godot_dialogue_manager | INSTALLED | Document/observation display | [dialogue-plan.md](./addons/dialogue-plan.md) |
| 3 | gloot | INSTALLED | Resource-based inventory | [inventory-plan.md](./addons/inventory-plan.md) |
| 4 | AdaptiSound | INSTALLED | Layered adaptive audio | [audio-plan.md](./addons/audio-plan.md) |
| 5 | shaky-camera-3d | INSTALLED | Subtle camera effects | [camera-fx-plan.md](./addons/camera-fx-plan.md) |
| 6 | quest-system | INSTALLED | High-level puzzle tracking | [quest-plan.md](./addons/quest-plan.md) |
| 7 | SaveMadeEasy | INSTALLED | Encrypted save/load | [save-plan.md](./addons/save-plan.md) |
| 8 | gdUnit4 | INSTALLED | Testing framework | [testing-plan.md](./addons/testing-plan.md) |
| 9 | godot-material-footsteps | **TO ADD** | Surface-based footstep sounds | [footsteps-plan.md](./addons/footsteps-plan.md) |
| 10 | phantom-camera | **TO ADD** | Document inspection + cinematic camera | [phantom-camera-plan.md](./addons/phantom-camera-plan.md) |
| 11 | limboai | **TO ADD** | HSM for game phases + Elizabeth presence | [state-machine-plan.md](./addons/state-machine-plan.md) |

---

## Rejected Addons

| Addon | Why Rejected |
|-------|-------------|
| inkgd (ephread) | No official Godot 4 release, 50x slower, no visual editor. Dialogue Manager already installed and better fit for document-reading game |
| COGITO | Full project template, not a plugin. Would require total rewrite of our codebase |
| Ultimate Retro Shader Collection | Per-material retro shaders — wrong approach for pre-made PSX assets |
| Retro Shaders Pro (Daniel Ilett) | Paid, per-material focus. Same issue |
| EgoVenture | Godot 3 only |
| Popochiu | 2D point-and-click, not 3D first-person |
| GOAT | Abandoned 2022 |
| Arcweave | External tool dependency |
| Godot VFX Library | Action-game focused. Our dust motes are simple GPUParticles3D |
| Text Animator for Godot | Over-engineered. Dialogue Manager's typewriter covers it |
| Raytraced Audio | Overkill. AdaptiSound + Godot's built-in Area3D reverb zones sufficient |
| godot-fancy-scene-changes | We use psx_fade.gdshader for authentic PSX dither transitions |

---

## Custom Shader Cleanup

**DELETE:** `shaders/psx.gdshader` — Per-material PSX shader. Not used in any scene. Wrong approach for PSX assets.

**REPLACE:** `shaders/psx_post.gdshader` — Currently referenced in `main.tscn`. Replace with godot-psx's `psx_dither.gdshader` which does the same thing (screen-space dither + color reduction) but is maintained upstream.

**USE from godot-psx:**
- `psx_dither.gdshader` — Screen-space dithering, color depth, resolution scaling (replaces our custom post shader)
- `psx_fade.gdshader` — Dither fade for room transitions (replaces linear ColorRect alpha fade in room_manager.gd)

**DO NOT USE from godot-psx:**
- `psx_lit.gdshader` — Per-material vertex snapping. Our GLBs are already PSX geometry.
- `psx_unlit.gdshader` — Same. Not for pre-made PSX assets.

---

## How Addons Interconnect

```
PLAYER INPUT
    │
    ├─ TAP on Interactable (Layer 3)
    │   ├─ phantom-camera → smooth zoom to object
    │   ├─ dialogue_manager → show document/observation (conditional on flags)
    │   ├─ gloot → add item to inventory if applicable
    │   ├─ quest-system → update puzzle progress
    │   └─ limboai HSM → transition game state (e.g., elizabeth_aware)
    │
    ├─ TAP on Connection (Layer 4)
    │   ├─ room_manager → transition with psx_fade dither
    │   ├─ AdaptiSound → crossfade ambient layers
    │   ├─ material-footsteps → detect new floor surface
    │   └─ SaveMadeEasy → auto-save
    │
    └─ TAP on Floor (Layer 1)
        ├─ Player walks to point
        ├─ material-footsteps → play surface-appropriate sound
        └─ shaky-camera-3d → subtle head bob

BACKGROUND SYSTEMS
    ├─ limboai HSM governs:
    │   ├─ Game phase (Exploration → Discovery → Horror → Resolution)
    │   ├─ Elizabeth presence (Absent → Aware → Active → Confrontation)
    │   └─ Drives AdaptiSound intensity layers
    │
    ├─ AdaptiSound manages:
    │   ├─ Base ambient loop (per room)
    │   ├─ Tension layer (activated by HSM)
    │   └─ Event stingers (on flag changes)
    │
    └─ psx_dither shader applied to SubViewportContainer
        └─ Entire game renders through PSX dither + color reduction
```

---

## Implementation Order

1. **Delete custom shaders** — Remove `shaders/psx.gdshader`, swap `psx_post.gdshader` for godot-psx's `psx_dither.gdshader`
2. **Install new addons** — Add footsteps, phantom-camera, limboai to `plug.gd` and run `gd-plug install`
3. **Write per-addon plan docs** — One `.md` per addon in `docs/addons/` detailing integration steps
4. **Integrate addons into scripts** — Update `game_manager.gd`, `interaction_manager.gd`, `room_manager.gd`, `player_controller.gd`
5. **Configure per-room** — Each room scene gets: footstep surface tags, audio layer config, phantom camera inspection points

---

## Related Documents

- [NARRATIVE.md](./NARRATIVE.md) — Story, characters, document catalog
- [VISION.md](./VISION.md) — Design philosophy (Myst approach, no horror tricks)
- [ART_DIRECTION.md](./ART_DIRECTION.md) — Color palette, lighting philosophy, materials
- [puzzles/README.md](./puzzles/README.md) — All 6 puzzles with flowcharts
- [items/README.md](./items/README.md) — Complete item catalog
- Floor docs: [ground-floor](./floors/ground-floor/README.md) | [upper-floor](./floors/upper-floor/README.md) | [basement](./floors/basement/README.md) | [deep-basement](./floors/deep-basement/README.md) | [attic](./floors/attic/README.md)
