# PRD: Post-Merge Closeout and Release Candidate

## Overview

This PRD is the canonical remaining-work surface after the merge/cleanup tranche
that landed PR #6 and PR #7. There are no open GitHub PRs or issues, `main` is
the active integration branch, and the repo-local declaration/runtime baseline
is already green. The work that remains is no longer broad implementation
recovery. It is final substrate closeout, final renderer-backed acceptance,
packaged debug validation closeout, and honest Android release-candidate proof.

This document is intentionally scoped to work **not completed in the push that
authors this PRD**. The purpose of the push is to leave a clear backlog surface
for everything still outstanding after the current documentation update lands.

## Current State

- PR #6 substrate/declaration hardening is merged.
- PR #7 release/changelog/CI cleanup is merged.
- `main` is the current execution branch.
- There are no open GitHub PRs.
- There are no open GitHub issues.
- Repo-local declaration and E2E suites are green on the merged baseline.
- Android debug packaging, install, direct launch, and Maestro smoke proof
  already exist on the local `ashworth_test` AVD.
- The two known ship-closeout blockers are:
  - packaged critical-path Maestro automation still failing on helper-label
    pickup on the AVD
  - Android release export still blocked by missing release-signing credentials

## Why This PRD Exists

The repo still has multiple historical execution artifacts:

- substrate freeze batch docs
- whole-game ship-plan PRDs
- Ralph recovery and closeout batches
- packaged-validation docs and checkpoints

Those are useful as historical record, but they no longer provide a single,
concise answer to one practical question: **what still remains after the merged
closeout tranche, and in what order should it be done?**

This PRD answers that directly.

## Goals

- Finish the remaining shared-substrate adoption work across the estate.
- Clear the remaining opening visual blockers with renderer-backed evidence.
- Re-run and re-document the final repo-local freeze after the remaining
  substrate work lands.
- Make packaged debug critical-path validation pass on the current Android AVD.
- Produce a signed Android release APK, then validate install and launch.
- Leave the repo with one truthful, explicit remaining-work surface instead of
  scattered implied status.

## Non-Goals

- No new routes, new endings, or macro-narrative rewrites.
- No combat, enemies, or HUD-first redesign.
- No reopening already-merged PR archaeology unless a regression requires it.
- No cleanup of third-party addon TODOs in `addons/`.
- No storefront, publishing, or marketing work.

## Product Constraints

- Declarations remain canonical.
- `docs/GAME_BIBLE.md` remains the narrative authority.
- `docs/SUBSTRATE_FOUNDATION.md` remains the substrate authority.
- Lighting must remain visibly sourced.
- Imported models remain valid for discrete props and hero objects, not primary
  room envelopes.
- Visual review is required for critical-path completion.
- Packaged-validation truth must stay honest. Environment blockers must be
  recorded as blockers, not blurred into “almost done.”

## Quality Gates

Base gate for every remaining story:

- `godot --headless --path . --quit-after 1`

Declaration/data-authoring gate:

- `godot --headless --path . --script test/generated/test_declarations.gd`

Room topology/traversal gate:

- `godot --headless --path . --script test/e2e/test_room_specs.gd`

Interaction/state/progression gates:

- `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `godot --headless --path . --script test/e2e/test_route_progression.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`

Perception-sensitive renderer-backed gates:

- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `godot --path . --script test/e2e/test_environment_probe.gd`

Packaged-validation gates:

- `maestro test test/maestro/smoke_test.yaml`
- `maestro test test/maestro/full_playthrough.yaml`
- `godot --headless --path . --export-release "Android" build/android/ashworth-manor-release.apk`

## Remaining Workstreams

### RM-001: Reconcile source-map and status truth

**Why it remains:**  
The repo still names older active execution surfaces in `PLAN.md`,
`MEMORY.md`, and `.ralph-tui/progress.md`. That makes the remaining work harder
to resume honestly.

**What must happen:**
- point contributor-facing source-map surfaces at the post-merge remaining-work
  PRD/batch
- keep historical batches, but stop presenting stale ones as current truth
- remove wording that still implies active branch review work when everything is
  now on `main`

**Acceptance Criteria:**
- `PLAN.md`, `MEMORY.md`, and `.ralph-tui/progress.md` agree on the current
  remaining-work surface
- no first-party status surface still implies an open review branch or open PR
- the active remaining-work surface is obvious to a new contributor

**Verification:**
- targeted review of the updated source-map files

**Depends On:** none

### RM-002: Finish opening exterior visual acceptance

**Why it remains:**  
The latest opening visual diagnostic still names live blockers:
- hedge face still too smooth/synthetic
- drive floor still lacks final authored richness
- outward-road village remains schematic
- twilight sky and contextual sign/valise framing are still not final

**What must happen:**
- finish hedge-wall surface craft in the close drive probe
- improve drive material/silhouette craft without flattening the approach
- push the outward-road frontage and twilight band until they read as
  persuasive distant settlement context
- finish the contextual sign/valise composition without resorting to non-diegetic emphasis

**Acceptance Criteria:**
- the latest opening diagnostic can be closed without carrying forward those
  named blockers
- hedge rows read as clipped topiary mass rather than smooth synthetic slabs
- drive surfaces read as intentionally authored estate approach
- outward-road and sky read as persuasive twilight context
- sign/valise composition is legible both in contextual and close review frames

**Verification:**
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`
- renderer-backed review of emitted captures

**Depends On:** RM-001

### RM-003: Finish grounds topology and exterior estate substrate coverage

**Why it remains:**  
`SF-006` is still open. The repo has made large substrate gains, but the
exterior estate still needs one truthful finish pass that proves the grounds
are one coherent substrate-owned system.

**What must happen:**
- audit all exterior rooms against the final substrate/content authoring rules
- remove or explicitly classify any remaining exterior shared-asset path that
  still bypasses substrate/content registries
- confirm gate families, roads, boundary logic, hedges, sky, and frontage all
  resolve through the shared declaration-facing contract

**Acceptance Criteria:**
- `SF-006` can be marked done honestly
- exterior rooms no longer rely on unclassified direct shared-asset authoring
- declaration validation and renderer review tell the same exterior-substrate
  story

**Verification:**
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_environment_probe.gd`

**Depends On:** RM-001, RM-002

### RM-004: Finish whole-house interior substrate coverage

**Why it remains:**  
`SF-007` is still open. Interior floors still need one honest whole-house audit
that proves shared builders/content registries own the primary physical
language everywhere that matters.

**What must happen:**
- audit ground floor, upper floor, attic, basement, deep basement, greenhouse,
  and other interior edges for remaining non-substrate envelope ownership
- classify any remaining direct interior asset usage as substrate, shared
  content, or deliberate hero-object exception
- remove any silent dependence on imported architecture shells for primary room
  envelopes

**Acceptance Criteria:**
- `SF-007` can be marked done honestly
- every floor resolves through the region/environment matrix and shared
  builder/content contract
- imported architecture shells are not silently carrying core envelope duties

**Verification:**
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`

**Depends On:** RM-001

### RM-005: Finish route-state integration on top of the substrate

**Why it remains:**  
`SF-008` is still open. Route differences need one final proof that they live
on top of shared physical language rather than bespoke environment
implementations.

**What must happen:**
- audit `Adult`, `Elder`, and `Child` route-specific physical differences
- keep route variance in mounted clues, blocked passages, light states, and
  declaration-driven dressing
- remove any remaining route-specific environment-tech divergence

**Acceptance Criteria:**
- `SF-008` can be marked done honestly
- route-specific physical differences do not depend on separate environment
  tech stacks
- clean-save route order remains `Adult -> Elder -> Child`

**Verification:**
- `godot --headless --path . --script test/e2e/test_route_progression.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --headless --path . --script test/generated/test_declarations.gd`

**Depends On:** RM-003, RM-004

### RM-006: Rebuild visual evidence and rerun the repo-local freeze

**Why it remains:**  
The repo still needs one final truthful freeze pass after the remaining
substrate and opening work is done. The old freeze proof is no longer enough
once more adoption work lands.

**What must happen:**
- rerun the full canonical headless bundle
- rerun renderer-backed walkthrough/opening/environment captures
- update checkpoints so they record the actual final freeze evidence
- close `SF-009` and `SF-010` only if the evidence supports that

**Acceptance Criteria:**
- the full repo-local freeze bundle passes
- critical spaces and route finales have fresh reviewable evidence
- docs, declarations, tests, and captures describe the same shipped game

**Verification:**
- `godot --headless --path . --quit-after 1`
- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_specs.gd`
- `godot --headless --path . --script test/e2e/test_declared_interactions.gd`
- `godot --headless --path . --script test/e2e/test_route_progression.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`
- `godot --path . --script test/e2e/test_room_walkthrough.gd`
- `godot --path . --script test/e2e/test_environment_probe.gd`

**Depends On:** RM-002, RM-003, RM-004, RM-005

### RM-007: Unblock packaged critical-path validation on the local AVD

**Why it remains:**  
`US-026` is still blocked. Smoke packaging works, but helper-backed critical
path automation still fails on semantic helper-label pickup on `ashworth_test`.

**What must happen:**
- reproduce and narrow the current failure around `dismiss document`
- stabilize the current helper-label path or replace it with a more reliable
  packaged-debug automation surface
- preserve debug-only gating so helper affordances do not leak into normal play

**Acceptance Criteria:**
- `maestro test test/maestro/full_playthrough.yaml` passes on `ashworth_test`,
  or the exact remaining blocker is narrowed to a concrete emulator/tool limit
  with evidence
- helper affordances remain debug-gated

**Verification:**
- `maestro test test/maestro/smoke_test.yaml`
- `maestro test test/maestro/full_playthrough.yaml`

**Depends On:** RM-006

### RM-008: Close packaged-validation documentation truthfully

**Why it remains:**  
Once `RM-007` is resolved, the docs need to record the actual passing/blocked
surface clearly instead of leaving stale partial truth in packaged-validation
checkpoints.

**What must happen:**
- update `docs/MAESTRO_E2E_PLAN.md`
- update the packaged-validation checkpoint docs
- distinguish clearly between smoke proof, critical-path proof, emulator proof,
  and any environment caveats

**Acceptance Criteria:**
- `US-026` can be marked complete honestly
- a reviewer can execute the packaged debug flows from the docs without
  guesswork

**Verification:**
- doc review
- `maestro test test/maestro/smoke_test.yaml`
- `maestro test test/maestro/full_playthrough.yaml`

**Depends On:** RM-007

### RM-009: Configure release signing and export the Android release APK

**Why it remains:**  
`US-027` is still blocked by missing release-signing credentials.

**What must happen:**
- provide release keystore credentials in the local export environment
- keep secrets out of repo-tracked files
- verify the `Android` preset uses the intended release signing material
- export the signed release APK successfully

**Acceptance Criteria:**
- release export is no longer blocked by missing signing configuration
- the release APK is produced successfully on the local machine

**Verification:**
- `godot --headless --path . --export-release "Android" build/android/ashworth-manor-release.apk`

**Depends On:** RM-006

**Current Blocker:** local release-signing credentials are missing

### RM-010: Validate release install/launch and close release-readiness docs

**Why it remains:**  
The whole-game ship plan ends with actual packaged evidence, not only repo-local
confidence.

**What must happen:**
- install the signed release APK on emulator or device
- validate launch and one meaningful continuation
- record evidence and caveats in release-readiness docs/checkpoints

**Acceptance Criteria:**
- the signed release APK installs and launches successfully on a real runtime
  target
- release-readiness docs record actual packaged-validation scope, evidence, and
  caveats
- `US-027` can be marked complete honestly, or the final blocker is recorded
  with exact evidence

**Verification:**
- `adb install -r build/android/ashworth-manor-release.apk`
- launch validation on emulator or device
- release-doc review

**Depends On:** RM-008, RM-009

**Current Blocker:** blocked behind RM-009 release signing

### RM-011: Clear remaining first-party placeholder residue

**Why it remains:**  
First-party doc TODO/TBD residue is now minimal, so it should be removed as part
of final closeout rather than left to drift.

**What must happen:**
- clear the `TBD` audio-loop placeholder in `docs/rooms/foyer/README.md`
- sweep first-party docs for any remaining stale placeholder language exposed
  during the final freeze pass

**Acceptance Criteria:**
- no first-party TODO/TBD markers remain in canonical repo-owned docs unless
  they are explicitly historical/archive surfaces

**Verification:**
- `rg -n "TODO|FIXME|TBD" engine scripts declarations scenes docs/rooms PLAN.md MEMORY.md STRUCTURE.md .ralph-tui/progress.md -g '!addons/**'`

**Depends On:** RM-001, RM-006

## Remaining Dependency Order

1. `RM-001`
2. `RM-002`, `RM-004`
3. `RM-003`
4. `RM-005`
5. `RM-006`
6. `RM-007`
7. `RM-008`
8. `RM-009`
9. `RM-010`
10. `RM-011`

## Explicit Blockers

- **Blocked now:** `RM-009`
  - reason: release-signing credentials are not configured locally
- **Blocked now:** `RM-010`
  - reason: depends on signed release export from `RM-009`
- **Not blocked, but failing:** `RM-007`
  - reason: packaged critical-path automation still fails on helper-label
    pickup on the current AVD surface

## Definition Of Done

This remaining-work PRD is complete only when:

- source-map surfaces point to one truthful remaining-work contract
- opening visual blockers are actually cleared in renderer-backed evidence
- `SF-006`, `SF-007`, and `SF-008` are closed honestly
- the final repo-local freeze bundle is rerun and recorded
- packaged debug smoke and critical-path flows are both proven
- a signed Android release APK is built, installed, and launched, or the final
  blocker is documented with exact evidence
- no first-party canonical doc still hides unresolved ship work behind vague
  placeholders

## Canonical Relationship To Other Planning Surfaces

- `docs/batches/hard-substrate-freeze.md`
  - remains the substrate-specific execution contract
- `docs/batches/ashworth-master-task-graph.md`
  - remains the broad whole-game scope contract
- `docs/batches/post-merge-closeout-and-release-candidate.md`
  - is the execution-oriented closeout batch for the same remaining work
- this PRD
  - is the canonical **remaining-work product surface** for anything not
    finished in the PRD-authoring push itself
