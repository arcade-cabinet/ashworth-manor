# Unresolved Design Questions

Items that need resolution before final polish. Parked here so they don't get lost.

---

## 1. Room Scale on Mobile

**Problem:** When entering a room on a phone/tablet, the room should feel like a SPACE you're standing IN, not a diorama you're looking AT. Walls should extend BEYOND the viewport. Player should have to swipe-look to see the whole room.

**Questions:**
- Are current room dimensions (e.g., foyer 12x10 units) too small for mobile viewports?
- Does the camera FOV (currently 70) need adjustment for mobile?
- Should rooms be physically larger, or should FOV be narrower to create the illusion of scale?
- What's the target: 60% of room visible on entry, requiring look-around to see the rest?

**Affects:** Every room scene, camera settings, spawn positions, player controller FOV.

---

## 2. Player Position Awareness

**Problem:** There should always be a sense of "I am IN this room" — walls visible to left and right, ceiling above, floor below. The player's position relative to the room boundaries should feel natural and enclosed.

**Questions:**
- Should the player spawn further inside the room (not at the door)?
- Should wall height be exaggerated (Victorian ceilings were tall)?
- Do we need floor/ceiling visible in the camera frustum at all times?
- How does this work for exterior spaces (garden, front gate)?

**Affects:** spawn_position and spawn_rotation_y in all rooms, ceiling height, wall placement.

---

## 3. Exterior Spaces as "Rooms"

**Problem:** Outdoor areas (garden, front gate, chapel grounds) need the same sense of enclosure — just with skybox, hedges, fences, walls instead of interior walls.

**Questions:**
- Hedge maze potential: should the garden have hedge walls?
- Skybox: what does the sky look like? (December night, moonlit, overcast?)
- How do boundary walls (brick, drystone, iron fence) define exterior "rooms"?
- Should exterior rooms be smaller than they currently are (20x20) to feel enclosed?

**Affects:** All 6 grounds room scenes, WorldEnvironment sky settings, boundary geometry.

---

## 4. Voice vs Text-Only for Elizabeth's Lines

**Problem:** MASTER_SCRIPT has specific whisper lines: "find me", "you found me", "thank you". Current horror_whisper SFX are generic, not spoken words.

**Options:**
- A) Text-only — keep as dialogue text, no voice
- B) Process TTS through PSX filter for ghostly whisper effect
- C) Source actual voice recordings

**Decision needed before:** Attic stairwell and hidden chamber implementation.

---

## 5. PSX Shader on Procedural Geometry

**Problem:** The PSX post-process shader (psx_dither) applies to the WHOLE screen. But procedural BoxMesh/QuadMesh geometry with retro textures might look different from the pre-baked GLB models under the same shader.

**Questions:**
- Do procedural meshes with 512x512 textures + filter_nearest + psx_dither look correct alongside mansion pack GLBs with baked 128x128 textures?
- Should we use 128x128 SBS textures instead of 512x512 to match the GLB texture resolution?
- Does the PSX post-process make the resolution difference irrelevant?

**Needs:** Visual comparison in the POC scene — render procedural geometry next to GLB geometry under the PSX shader and screenshot.
