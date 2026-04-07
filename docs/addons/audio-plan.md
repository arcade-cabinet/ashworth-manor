# Audio Plan — AdaptiSound

## Source
- Addon: `MrWalkmanDev/AdaptiSound`
- Location: `addons/AdaptiSound/`

## Purpose

Replace `scripts/audio_manager.gd` (basic dual-player crossfade) with layered adaptive audio that responds to game state.

## Audio Layer Architecture

Each room has up to 3 audio layers that blend based on game state:

| Layer | Content | When Active | Volume |
|-------|---------|-------------|--------|
| Base | Room ambient loop (36 OGGs) | Always | -6 dB |
| Tension | Whispers, creaks, distant sounds | When `elizabeth_aware` flag set | -12 dB → -6 dB |
| Stinger | One-shot event sounds | On flag changes, discoveries | 0 dB |

## Per-Floor Audio Design

| Floor | Base Loop Character | Tension Layer | Example Stinger |
|-------|-------------------|---------------|-----------------|
| Grounds | Wind, crickets, distant owl | Rustling, gate creak | Gate slam |
| Ground Floor | Settling house, distant clock | Whispers, fire dying | Clock chime |
| Upper Floor | Floorboard creaks, wind | Sobbing through walls | Door rattle |
| Basement | Dripping, pipe groans | Whispers in pipes | Metal clang |
| Deep Basement | Near silence, torch crackle | Heartbeat building | Stone grinding |
| Attic | Wind through rafters, scratching | Child's humming | Music box melody |

## Reverb Zones (Built-in Godot)

Each room gets an Area3D with reverb bus assignment:

| Room Type | Reverb Preset | Room Size |
|-----------|--------------|-----------|
| Grand rooms (foyer) | Hall | 0.8 |
| Medium rooms (parlor, dining) | Room | 0.5 |
| Small rooms (guest room) | Small Room | 0.3 |
| Basement stone | Stone Corridor | 0.7 |
| Wine cellar | Dungeon | 0.9 |
| Attic wood | Wooden Hall | 0.4 |
| Exterior | Open Air | 0.1 |

## Implementation Steps

1. Configure AdaptiSound as autoload (replaces audio_manager.gd)
2. Create AudioSynchronizedPlayer nodes per floor with base + tension layers
3. Set up reverb audio buses per room type
4. Add Area3D reverb zones to each room scene
5. Connect LimboAI HSM state changes to AdaptiSound layer activation
6. Map all 36 OGG loops to room IDs
7. Test: walk through all rooms, verify crossfade, verify tension layer activates after attic entry
