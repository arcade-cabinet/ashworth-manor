# Audio Wiring Plan

How every audio file in the project connects to game systems. 280 audio files organized across 11 directories — this is how they get USED.

---

## Audio Directory Map

```
assets/audio/
├── loops/              36 OGG  — Room ambient base layers (already wired)
├── tension/            10 WAV  — Floor-specific tension layers (Dark Ambient pack)
├── sfx/
│   ├── horror/         50 OGG  — Whispers, drones, stingers, screams, metal, glitch
│   ├── stinger/        20 WAV  — Phase transition + event stinger music
│   ├── inventory/      36 OGG  — Item pickup, chest open, key, scroll, button, error
│   ├── impact/         21 OGG  — Click, heavy, stone, metal, wood impacts
│   ├── ambient/        40 OGG  — Wind, fire, dungeon, night, rain, ruins, machine
│   ├── music_box/       3 OGG  — Elizabeth's melody, fairytale, rag doll
│   └── echoes/         11 MP3  — Breath, steps, ghost scream, bells, thunder
├── footsteps/          36 WAV  — PSX pack (9 surfaces x 4 variants)
└── footsteps_extra/    17 OGG  — Supplemental stone, metal, wood, mud, sneak
```

---

## Wiring: What Plays When

### 1. Room Ambient (audio_manager.gd — ALREADY WIRED)

Base layer crossfades on room transition. Each room has `audio_loop` export:

| Room | Loop File | Character |
|------|-----------|-----------|
| front_gate | Tempest Loop1 | Wind, storm |
| foyer | Moonlight Loop1 | Settling house |
| parlor | Comfort Loop1 | Fire crackling |
| dining_room | Keep it up Loop1 | Formal silence |
| kitchen | Without a Trace Loop1 | Dripping, cold |
| upper_hallway | Keep it up Loop1 | Floorboards |
| master_bedroom | Lying Down Loop1 | Intimate gloom |
| library | Value Loop1 | Scholarly quiet |
| guest_room | Lost in Polaroids Loop1 | Isolation |
| storage_basement | Echoes at Dusk Loop1 | Stone echo |
| boiler_room | Insufficient Loop1 | Industrial hum |
| wine_cellar | Empty Hope Loop1 | Deep silence |
| attic_stairs | Silent Voices Loop1 | Wind gaps |
| attic_storage | Lonely Nightmare Loop1 | Scratching |
| hidden_chamber | I Can't Go On Loop1 | Presence |
| garden | Subtle Changes Loop3_D | Dead winter |
| chapel | Silent Voices Loop2 | Desecrated |
| greenhouse | Subtle Changes Loop2 | Glass frost |
| carriage_house | Echoes at Dusk Loop1 | Drafty shed |
| family_crypt | Empty Hope Loop2 | Cold stone |

### 2. Tension Layer (audio_manager.gd — PATHS FIXED, needs audio_manager update)

Activates when `elizabeth_aware` flag is set. Volume scaled by game phase via `set_tension_volume()`.

| Floor | Tension File | Path |
|-------|-------------|------|
| Ground floor | `tension_ground.wav` | `res://assets/audio/tension/tension_ground.wav` |
| Upper floor | `tension_upper.wav` | `res://assets/audio/tension/tension_upper.wav` |
| Basement | `tension_basement.wav` | `res://assets/audio/tension/tension_basement.wav` |
| Deep basement | `tension_deep.wav` | `res://assets/audio/tension/tension_deep.wav` |
| Attic | `tension_attic.wav` | `res://assets/audio/tension/tension_attic.wav` |
| Phase overlays | `tension_horror_overlay.wav`, `tension_discovery.wav`, `tension_resolution.wav` | Reserve for phase-specific atmosphere |

### 3. Interaction SFX (interaction_manager.gd + puzzle_handler.gd — TO WIRE)

| Event | SFX File | When |
|-------|----------|------|
| Item pickup (key) | `sfx/inventory/pl_key_pickup_01.ogg` | Player acquires any key |
| Item pickup (document) | `sfx/inventory/pl_scroll_pickup_01.ogg` | Player picks up binding book, confession |
| Item pickup (artifact) | `sfx/inventory/pl_item_pickup_01.ogg` | Doll, locket, blessed water |
| Chest/box open (unlocked) | `sfx/inventory/pl_chest_loot_01.ogg` | Jewelry box, wine box opened with key |
| Locked — no key | `sfx/inventory/pl_inventory_error_01.ogg` | Tap locked container without key |
| Lock mechanism click | `sfx/impact/pl_impact_click_01.ogg` | Key turns in lock |
| Switch toggle | `sfx/impact/pl_impact_click_02.ogg` | Light switch |
| Document open | `sfx/inventory/pl_menu_open_soft_01.ogg` | Dialogue balloon appears |
| Document close | `sfx/inventory/pl_menu_close_soft_01.ogg` | Dialogue balloon dismissed |

**Implementation:** Add `AudioManager.play_sfx()` calls in `interaction_manager.gd` at each event point. Use `AudioStreamRandomizer` with 2-4 variants per event type for variety.

### 4. Phase Transition Stingers (game_state_machine.gd — TO WIRE)

| Transition | Stinger File | Character |
|------------|-------------|-----------|
| → Discovery | `sfx/stinger/pl_horror_tension_08_subtle.wav` | Subtle shift |
| → Horror | `sfx/stinger/pl_horror_tension_04_dark.wav` | Dark, entering attic |
| → Resolution | `sfx/stinger/pl_horror_tension_05_slow.wav` | Somber realization |
| Ending: Freedom | `sfx/stinger/pl_horror_stinger_10_final.wav` | Triumphant release |
| Ending: Escape | `sfx/stinger/pl_horror_stinger_09_slam.wav` | Door slam, finality |
| Ending: Joined | `sfx/stinger/pl_horror_stinger_08_dark_hit.wav` | Trapped forever |

**Implementation:** `game_state_machine.gd` calls `AudioManager.play_sfx()` on each HSM state transition.

### 5. Flashback SFX (flashback_manager.gd — TO WIRE)

| Moment | SFX Files | Sequence |
|--------|-----------|----------|
| Flashback start | `sfx/horror/horror_reverse_01.ogg` | Plays during PSX dither-to-white |
| Model visible | `sfx/stinger/pl_horror_stinger_01_hit.wav` | Impact when figure appears |
| Flashback end | `sfx/horror/horror_reverse_02.ogg` | Reverse when returning to normal |

### 6. Room Events (room_events.gd — TO WIRE)

| Event | SFX File | Room | Trigger |
|-------|----------|------|---------|
| Gate creak | `sfx/horror/horror_door_01.ogg` | Front gate | Every 15-30s |
| Wind gust | `sfx/ambient/pl_ambient_wind_strong_01.ogg` | Front gate | Every 20-40s |
| Water drip | `sfx/ambient/pl_ambient_cave_01.ogg` | Kitchen | Every 8-15s |
| Pipe whisper | `sfx/horror/horror_whisper_01.ogg` | Boiler room | 30s if elizabeth_aware |
| Torch gutter | `sfx/ambient/pl_ambient_fire_02.ogg` | Wine cellar | 60s if elizabeth_aware |
| Child crying | `sfx/echoes/ghost_scream.mp3` | Upper hallway | Near attic door, elizabeth_aware |
| Attic door rattle | `sfx/horror/horror_door_03.ogg` | Upper hallway | 30s if knows_attic_locked |
| Stairs creak | `sfx/impact/pl_impact_wood_02.ogg` | Attic stairwell | On entry |
| Silverware clink | `sfx/impact/pl_impact_metal_01.ogg` | Dining room | Every 40-80s |
| Boiler rumble | `sfx/ambient/pl_ambient_machine_01.ogg` | Boiler room | Continuous |
| Fire crackle | `sfx/ambient/pl_ambient_fire_01.ogg` | Parlor | On first entry |
| Mysterious bells | `sfx/echoes/mysterious_bells.mp3` | Chapel | On first entry |
| Eerie steps | `sfx/echoes/eerie_steps_approach.mp3` | Hidden chamber | 10s after entry |

### 7. Elizabeth Events (elizabeth_presence.gd — TO WIRE)

| State | SFX | When |
|-------|-----|------|
| Watching → shadow | `sfx/horror/horror_noise_01.ogg` | Peripheral shadow effect |
| Active → whisper | `sfx/horror/horror_whisper_02.ogg` | Periodic whisper |
| Active → mirror | `sfx/echoes/laughing_ghost.mp3` | Mirror apparition |
| Confrontation | `sfx/echoes/breath_howling.mp3` | "You found me" moment |

### 8. Music Box (parlor events — TO WIRE)

| Trigger | File | Context |
|---------|------|---------|
| Music box auto-play | `sfx/music_box/elizabeth_melody.ogg` | Parlor, after elizabeth_aware + attic_storage visited |
| Music box distant (from attic) | `sfx/music_box/elizabeth_melody.ogg` (low volume, muffled) | Attic storage, if music_box_auto_triggered |
| Doll interaction | `sfx/music_box/forlorn_fairytale.ogg` | When examining porcelain doll |

### 9. Door Animations (door_frame.gd — TO BUILD)

| Door Type | Open SFX | Close SFX |
|-----------|----------|-----------|
| Standard wood | `sfx/horror/horror_door_01.ogg` | `sfx/impact/pl_impact_wood_01.ogg` |
| Heavy attic | `sfx/horror/horror_metal_01.ogg` | `sfx/impact/pl_impact_heavy_02.ogg` |
| Iron gate | `sfx/horror/horror_metal_03.ogg` | `sfx/impact/pl_impact_metal_01.ogg` |
| Trapdoor | `sfx/impact/pl_impact_wood_03.ogg` | `sfx/impact/pl_impact_heavy_01.ogg` |
| Hidden door | `sfx/horror/horror_door_03.ogg` | `sfx/impact/pl_impact_soft_01.ogg` |

### 10. Footsteps (MaterialFootstepPlayer3D — TO CONFIGURE)

Each surface type maps to 4 WAV files from `assets/audio/footsteps/{surface}/step_01-04.wav`:

| Surface | Rooms |
|---------|-------|
| marble | Foyer |
| wood_parquet | Parlor, Dining, Bedrooms, Library |
| stone | Kitchen, Basement, Wine Cellar, Chapel, Crypt |
| metal_grate | Boiler Room |
| rough_wood | Attic rooms |
| carpet | Upper Hallway |
| dirt | Grounds exterior |
| grass | Garden |
| gravel | Front Gate path |

Supplemental OGGs from `footsteps_extra/` can replace the PSX pack versions for stone and metal if they sound better — test both.

### 11. UI SFX (ui_pause.gd, ui_document.gd — TO WIRE)

| Event | SFX |
|-------|-----|
| Pause menu open | `sfx/inventory/inventory_open_01.ogg` |
| Pause menu close | `sfx/inventory/pl_inventory_close_01.ogg` |
| Menu button hover | `sfx/inventory/pl_button_soft_01.ogg` |
| Menu button click | `sfx/inventory/pl_button_soft_02.ogg` |

---

## Implementation Priority

1. **Footstep configuration** — Most impactful, every step the player takes
2. **Interaction SFX** — Item pickup, locked fail, switch toggle
3. **Door animation sounds** — Open/close for every door transition
4. **Room event ambient** — Gate creak, water drip, pipe whisper, fire crackle
5. **Phase transition stingers** — Discovery, Horror, Resolution shifts
6. **Elizabeth event SFX** — Whispers, shadows, mirror
7. **Flashback SFX** — Reverse + stinger
8. **Music box melody** — Parlor auto-play + attic distant
9. **UI sounds** — Menu open/close, button clicks
