# US-019 — Renderer-Backed Acceptance Rebuild

## Purpose

Re-establish the renderer-backed evidence surface so the shipped game can be
reviewed as a coherent visual/traversal artifact rather than a pile of
leftover screenshots.

## What Changed

- `test/e2e/test_room_walkthrough.gd` milestone capture coverage was expanded
  to explicitly track:
  - `storage_basement_entry`
  - `storage_basement_overview`
  - `boiler_room_entry`
  - `wine_cellar_entry`
  - `wine_cellar_overview`
  - `family_crypt_entry`
  - `family_crypt_overview`
  - `attic_stairs_entry`
  - `attic_storage_entry`
  - `attic_storage_overview`
  - `attic_storage_attic_music_box`
  - `hidden_chamber_entry`
  - `hidden_chamber_overview`
  - `family_crypt_crypt_music_box`
  - `hidden_chamber_child_music_box`
- critical-entry framing checks now also treat `boiler_room`, `wine_cellar`,
  and `family_crypt` as first-class review rooms
- the opening-journey manifest remains the dedicated opening proof surface:
  packet, valise, drive, dark foyer, parlor first warmth, and basement fall
- the opening manifest is now contextual rather than filename-only:
  each capture records room, pose, state, purpose, and review questions so
  opening screenshots can be judged for correctness, not just execution

## Evidence Surface

Renderer-backed outputs now live in:

- opening journey:
  - `~/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/opening_journey/`
  - manifest:
    `~/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/opening_journey/opening_manifest.txt`
- room walkthrough:
  - `~/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/walkthrough/`
  - milestone manifest:
    `~/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/walkthrough/milestone_manifest.txt`

The evidence now covers the shipped critical path directly:

- opening chain
- first basement/service descent
- boiler/service restoration space
- wine-cellar bypass surface
- family crypt burial chamber
- attic ascent and attic storage
- hidden-room final chamber
- route-finale interactables:
  - `milestones/attic_storage_attic_music_box.png`
  - `milestones/family_crypt_crypt_music_box.png`
  - `milestones/hidden_chamber_child_music_box.png`

## Verification

Verified during this checkpoint:

```bash
godot --path . --script test/e2e/test_opening_journey.gd
godot --path . --script test/e2e/test_room_walkthrough.gd
```

Observed results at checkpoint time:

- `OPENING JOURNEY: 32 passed, 0 failed`
- `WALKTHROUGH: 112 found, 0 missing`
- `Framing: 0 warnings, 0 failures`

## Result

`US-019` is satisfied for repo-local acceptance:

- opening and walkthrough capture lanes both execute successfully
- manifests now name the shipped basement, cellar, crypt, attic, and hidden-room
  milestones explicitly
- the capture surface is organized enough for later visual-polish and freeze
  review without re-deriving the route from raw filenames
