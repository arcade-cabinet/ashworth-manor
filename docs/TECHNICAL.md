# Technical Guide

This document covers the live technical implementation details for Ashworth Manor.

## Technology Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Engine | Godot | 4.6 |
| Language | GDScript | 4.x |
| Renderer | Forward+ | — |
| Assets | GLB (embedded textures) | glTF 2.0 |
| Audio | OGG Vorbis | — |

## Project Configuration

Key runtime entry:

```ini
run/main_scene="res://scenes/main.tscn"
```

Key runtime shape:
- `main.tscn` hosts the managers and player shell
- declarations drive room/world content
- autoload `GameManager` owns global state

## Scene Setup

The main scene contains the persistent runtime shell:
- `RoomManager`
- `PlayerController`
- `InteractionManager`
- `RoomEvents`
- `AudioManager`
- `UIOverlay`

`RoomContainer` and the assembled room content are managed at runtime rather than authored as the main content of `main.tscn`.

## Room Assembly

Rooms are built from `RoomDeclaration` resources through `RoomAssembler` and its builders.

Assembly responsibilities include:
- geometry and wall openings
- props and decorative models
- light placement
- interactable volumes
- connection volumes
- secret-passage metadata where applicable

Only one active room is assembled at a time.

## Interaction Pipeline

```text
tap / click
  -> PlayerController raycast
  -> interactable or connection Area3D
  -> InteractionManager
  -> InteractionEngine resolves declaration responses
  -> UIOverlay / GameManager / RoomEvents apply the result
```

Important behavior:
- conditional responses can override default authored text
- macro-thread flavor augments authored responses but does not replace higher-priority truth states
- declaration responses may set state, give items, and play SFX directly
- interaction focus now biases toward embodied motion: tap targets can pull yaw, pitch, FOV, and a small head-lean toward the object before the authored response resolves
- close-range interaction focus is collision-aware and intentionally limited so walls, columns, and frames do not get shoved into the center of the view
- suspicious geometry taps can now queue surface investigation: the player walks to a plausible standing point, then leans and narrows FOV toward the tapped wall, ceiling, or steep surface
- far interactable taps can now approach first and only fire the interaction after the player arrives, which keeps investigation from feeling like remote verb dispatch

## Event Pipeline

`room_events.gd` evaluates:
- first-entry triggers
- conditional room events
- ambient room events

Supported action families include:
- room-name display
- text display
- SFX
- camera shake
- light changes
- delayed follow-up actions

## Lighting

Lights are declaration-authored and then exposed through `room_base.gd`.

The runtime supports:
- light lookup by stable ID
- base-energy tracking
- authored pulses/dims/restores
- flicker patterns for candle-like sources

Lighting rule of thumb:
- visible physical source first
- atmosphere comes from source placement, not source-less ambient cheats

## Input And Movement

Primary interaction model:
- tap/click to move
- tap/click objects to interact
- tap/click thresholds to transition
- swipe/drag to look

`PlayerController` remains the movement shell, but progression and interaction meaning come from declarations.

Camera contract:
- room entry framing uses the live player camera, not a QA-only framing transform
- walkthrough framing evaluates compiled-world world-space positions, not local room-space guesses
- entry validation explicitly checks for structural crowding from nearby walls, columns, and threshold trim
- investigation framing should feel bodily: a suspicious patch on a wall is something the player walks up to and studies, not a detached cut camera or UI zoom

## Transitions

`RoomManager` owns transition sequencing:
- gate blocked or unlocked through `InteractionManager`
- fade transition by connection type
- room swap
- spawn placement from declaration data
- room-loaded notifications for audio/events/UI

## Save State

`GameManager` persists:
- inventory
- flags and generic state values
- visited-room state
- progression-relevant room/object state
- current room and thread-related state

## Performance Model

Current runtime assumptions:
1. only one room is active at a time
2. room content is assembled on load from declarations
3. GLBs carry their textures
4. tests exercise the same declaration path as the shipped game

## Acceptance Lanes

The technical baseline is considered healthy when these pass:
- boot smoke
- declaration validation
- interaction E2E
- room spec validation
- full playthrough
- walkthrough validation

Those lanes are now the real signal for regressions.
