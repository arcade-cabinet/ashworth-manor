# Phantom Camera Plan

## Source
- Addon: `ramokz/phantom-camera`
- GitHub: https://github.com/ramokz/phantom-camera
- Requires: Godot 4.4+ (we're on 4.6.2)
- Status: **TO INSTALL**

## Purpose

Cinemachine-inspired camera management for:
1. **Document inspection** — Smooth zoom toward paintings/notes/objects when examining
2. **First-entry room reveals** — Camera slowly pans to show the room on first visit
3. **Ending cinematics** — Camera pulls back, pans, follows during ending sequences
4. **Return to exploration** — Seamless blend back to player camera

## Camera Setup

```
PlayerController
├── PhantomCameraHost (manages which PCam is active)
├── PhantomCamera3D "ExplorationCam"
│   ├── Priority: 10 (default)
│   ├── Follow: Player head position
│   └── Damping: minimal (responsive exploration)
│
└── [Per-room inspection cameras as needed]

Room Scene
├── PhantomCamera3D "InspectPainting" (placed per interactable)
│   ├── Priority: 0 (inactive by default)
│   ├── Position: Close to painting, angled for reading
│   └── On interact: set priority to 20 → camera smoothly transitions
│
└── PhantomCamera3D "RoomReveal" (optional, for key rooms)
    ├── Priority: 0
    ├── Path follow along room reveal trajectory
    └── On first entry: set priority to 15 → camera sweeps room
```

## Interaction Flow

```
1. Player taps painting
2. Code sets InspectPainting.priority = 20
3. PhantomCameraHost detects priority change
4. Camera smoothly tweens from ExplorationCam → InspectPainting
5. Dialogue balloon appears with document text
6. Player taps to dismiss
7. Code sets InspectPainting.priority = 0
8. Camera smoothly returns to ExplorationCam
```

## Which Rooms Get Inspection Cameras

Only rooms with key narrative objects get dedicated inspect cameras:
- Foyer: Lord Ashworth portrait, grandfather clock
- Parlor: Lady Ashworth portrait, diary page
- Dining Room: Dinner party photo
- Master Bedroom: Lord's diary, jewelry box
- Library: Family tree, binding book, globe
- Attic Storage: Elizabeth's portrait, doll, letter
- Hidden Chamber: Elizabeth's final words, mirror
- Chapel: Baptismal font
- Family Crypt: Flagstone, Lady's note

Other interactables (clocks, switches, generic observations) use the standard dialogue overlay without camera movement.

## Implementation Steps

1. Add to `plug.gd`: `plug("ramokz/phantom-camera")`
2. Run gd-plug install
3. Add PhantomCameraHost to PlayerController
4. Create ExplorationCam PhantomCamera3D on player
5. For each key room: place inspection PhantomCamera3D nodes at interactable positions
6. Update `interaction_manager.gd` to set camera priorities on interact/dismiss
7. Create room reveal cameras for: foyer, attic_storage, hidden_chamber
8. Test: interact with every key object, verify smooth camera transitions
