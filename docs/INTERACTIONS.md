# Interaction System

This document describes the live interaction model used by the declaration runtime.

## Overview

Ashworth Manor uses diegetic interactions authored in room declarations and resolved at runtime.

The key runtime chain is:
- `player_controller.gd`
- `interaction_manager.gd`
- `engine/interaction_engine.gd`
- `ui_overlay.gd`
- `game_manager.gd`

## Interaction Flow

```text
Player tap / click
  -> PlayerController raycast
  -> interactable or connection Area3D
  -> InteractionManager
  -> declaration response resolution
  -> UI / state / item / event effects
```

For interactables:
1. runtime node carries a stable interactable ID plus declaration metadata
2. `InteractionManager` receives the interaction
3. declaration responses are evaluated in priority order
4. the chosen response may:
   - show text
   - set state
   - give items
   - play SFX
   - trigger puzzle progression

For connections:
1. `InteractionManager` checks lock/state requirements
2. ending/front-gate logic is applied where relevant
3. `RoomManager` performs the transition

## Authored Interaction Types

Common live types include:
- `note`
- `painting`
- `photo`
- `mirror`
- `observation`
- `ritual`

Special-case progression still exists where needed, but the preferred model is declaration-authored behavior first.

## Response Resolution

The current resolution order is:
1. conditioned base responses
2. thread-specific responses
3. unconditional base responses
4. fallback response when present

Important consequence:
- macro-thread flavor does not override higher-priority truth states

## State And Rewards

Responses can directly author:
- `set_state`
- `gives_item`
- `play_sfx`

That means many clue/reward paths no longer require custom one-off room logic.

## Progressive Puzzle Paths

Live examples:
- `kitchen_hearth` supports a staged reward path to `cellar_key`
- `library_globe` yields `attic_key`
- `porcelain_doll` yields `hidden_key` through the attic route
- `ritual_circle` resolves the counter-ritual sequence in the endgame path

## Room Events And Interaction Pressure

Some interactions are backed by room-event state:
- first-entry beats
- aftershock events
- music-box auto event
- threshold acknowledgement at `front_gate`
- `foyer` commitment beat

These are evaluated through `room_events.gd`, not by bolting more UI logic onto the interaction layer.

## Runtime Authoring Model

Interactables are declaration-authored with:
- stable `id`
- type
- placement
- collision bounds
- response list
- optional thread responses
- optional model/effects metadata

Connections are authored through the world/room declaration graph and built into runtime thresholds.

## Testing

The authoritative interaction validation lane is:
- `test/e2e/test_declared_interactions.gd`

That suite covers:
- entry triggers
- conditional response precedence
- thread-specific flavor
- item rewards
- threshold gating
- delayed room-event behavior
- endgame-side reveal behavior
