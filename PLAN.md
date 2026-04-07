# Ashworth Manor Polished Completion Plan

## Summary

Ashworth Manor is no longer in simple production-recovery mode. The active goal
is polished completion around a single coherent shipped game:

- a near-post-Victorian heir-return premise
- a strong shared early/mid mansion spine
- three bespoke Elizabeth routes
- declaration-first runtime implementation
- production-grade visual, interaction, and narrative alignment

## Active Tracks

### 1. Canon Migration

- Replace the old `Captive / Mourning / Sovereign` framing with the new
  `Adult / Elder / Child` route program across docs, declarations, runtime
  flows, and tests.
- Keep outside documents and estate signage neutral.

### 2. Opening and Shared Spine

- Make the packet → valise → gate → drive → dark-house-entry sequence fully
  playable and visually convincing.
- Implement the first warmth/light occupation beat, service-side fall, basement
  reclamation, and walking-stick midgame transition as the stable shared spine.

### 3. Route-Specific Late Game

- `Adult`: attic truth and attic music-box resolution
- `Elder`: crypt truth and crypt music-box resolution
- `Child`: attic-clue route into the sealed hidden room and hidden-room
  music-box resolution

### 4. Tool and Light Grammar

- `firebrand` early phase
- `walking stick` midgame phase
- `lantern hook` late phase
- major transitions should consume prior held states

### 5. Art, Lighting, and Asset Direction

- keep the project procedural-first and model-assisted
- use textures/material families and lighting source logic to carry the period
  look
- reserve models for silhouette-critical objects

### 6. Acceptance

- declarations, runtime, docs, tests, and renderer walkthrough lanes must all
  describe the same game

## Current Priorities

1. Execute the single master batch in `docs/batches/ashworth-master-task-graph.md`
2. Finish the shared early/mid mansion spine
3. Ship `Adult`, then `Elder`, then `Child`
4. Unify the winding-key/music-box finale system
5. Migrate critical-path docs and declaration text off the old weave
6. Rebuild automated and renderer-backed acceptance for the shipped game
7. Close archive/handoff and release-candidate validation

## Status

- [x] Declaration runtime remains canonical
- [x] Forward+ remains the visual baseline
- [x] Procedural-first, model-assisted creative direction is documented
- [x] Canonical route order is now `Adult -> Elder -> Child`
- [x] Whole-game canonical doc now exists in `docs/GAME_BIBLE.md`
- [x] Single master implementation batch now exists in `docs/batches/ashworth-master-task-graph.md`
- [x] Opening packet, valise, keyed front-door entry, and first warmth beat are implemented
- [ ] Shared early/mid mansion spine implemented end-to-end
- [ ] Adult route complete
- [ ] Elder route complete
- [ ] Child route complete
- [ ] Room docs and declaration text fully migrated off the old weave
- [ ] Full visual and playability acceptance complete
