# Ashworth Manor Polished Completion Plan

## Canonical Sources

| Surface | Document |
|---------|----------|
| **Narrative authority** | `docs/GAME_BIBLE.md` — the single source of truth for the shipped game |
| **Substrate authority** | `docs/SUBSTRATE_FOUNDATION.md` — the single source of truth for the shared physical language |
| **Active execution contract** | `docs/batches/hard-substrate-freeze.md` — the current substrate-first batch |
| **Whole-game scope contract** | `docs/batches/ashworth-master-task-graph.md` — the master task graph for total ship scope |
| **Remaining-work PRD** | `tasks/prd-post-merge-closeout-and-release-candidate.md` — the canonical PRD for all work still open after the merged closeout tranche |
| **Source map** | `docs/INDEX.md` — master index to all docs, canonical and support |
| **Architecture** | `STRUCTURE.md` — runtime architecture and canonical surface map |

## Summary

Ashworth Manor is no longer in simple production-recovery mode. The current
story-complete build is provisional. The active goal is substrate-first
completion around a single coherent shipped game:

- a near-post-Victorian heir-return premise
- a strong shared early/mid mansion spine
- three bespoke Elizabeth routes
- declaration-first runtime implementation
- a reusable shader/builder/factory substrate that covers the whole estate
- production-grade visual, interaction, and narrative alignment

## Active Tracks

### 1. Hard Substrate Freeze

- Build and lock the shared “lego box” first:
  - shader families
  - material recipes
  - builders/factories
  - substrate presets
  - mount slots/payloads
  - region/environment matrices

### 2. Grounds and Exterior Rebuild

- Rebuild the estate exterior as substrate-first:
  - hedge corridors as enclosing topiary walls
  - unified gate families and pivot semantics
  - shared road/terrain grammar
  - authored twilight sky and village frontage

### 3. Whole-House Interior Adoption

- Apply the same substrate rules to every floor and estate edge:
  - ground floor
  - upper floor
  - attic
  - basement and deep basement
  - greenhouse, garden, pond side, carriage side, and crypt

### 4. Route-State Integration

- Keep `Adult`, `Elder`, and `Child` as state layers over one physical
  substrate.
- Route differences should come from mounted clues, blocked passages, light
  states, and declaration-driven payload swaps, not bespoke environment tech.

### 5. Visual QA and Acceptance Rebuild

- Extend renderer-backed evidence into macro/meso/micro substrate review for
  critical spaces and finales.
- Treat visual acceptance as a product gate, not a debug convenience.

### 6. Downstream Release Work

- Android/export/device validation remains downstream and should not displace
  the substrate sweep until repo-local gates are green again.

## Current Priorities

1. Finish `SF-001` by rebasing the repo source-map surfaces onto the substrate authority and hard-freeze batch.
2. Stabilize `SF-002` through `SF-005` by proving the new recipe registry, declaration types, mount system, and region/environment matrix through targeted Godot lanes.
3. Move `SF-006` and `SF-007` into adoption mode once the substrate layer is green enough to carry exterior and whole-house coverage honestly.

## Status

- [x] Declaration runtime remains canonical
- [x] Forward+ remains the visual baseline
- [x] Procedural-first, model-assisted creative direction is documented
- [x] `docs/SUBSTRATE_FOUNDATION.md` now exists as the substrate authority
- [x] `docs/batches/hard-substrate-freeze.md` now exists as the active substrate-first batch
- [x] Substrate-facing declaration classes now exist for presets, slots, and payloads
- [x] Shared material recipe ids and standardized material slots now exist
- [x] Region/environment substrate matrix resources now exist
- [x] Canonical route order is now `Adult -> Elder -> Child`
- [x] Whole-game canonical doc now exists in `docs/GAME_BIBLE.md`
- [x] Single master implementation batch now exists in `docs/batches/ashworth-master-task-graph.md`
- [x] Remaining-story execution batch now exists in `docs/batches/ralph-remaining-stories-batch.md`
- [x] Opening packet, valise, keyed front-door entry, and first warmth beat are implemented
- [x] Shared early/mid mansion spine implemented end-to-end
- [x] Adult route complete
- [x] Elder route complete
- [x] Child route complete
- [x] Route context API and post-canonical replay mode are explicit
- [x] Critical-path room docs and declarations migrated off the old weave
- [x] Three-route automated coverage and gdUnit route-program lane are working
- [x] Full repo-local freeze acceptance complete
- [x] Android debug packaging, install, and direct launch proof exist
- [x] Source-map and progress surfaces fully rebased onto the hard substrate freeze
- [x] Targeted declaration/environment validation rerun against the new substrate layer
- [x] Remaining-work PRD now exists in `tasks/prd-post-merge-closeout-and-release-candidate.md`
- [ ] Grounds and whole-house substrate adoption sweep complete
- [ ] Release-signed Android export complete
- [ ] Helper-backed packaged critical-path flow device-verified
