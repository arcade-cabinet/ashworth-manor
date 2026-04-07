# Archive and Handoff Hygiene

## Summary
Close Ashworth Manor after production acceptance by archiving or clearly deprecating non-canonical legacy design material, making the canonical source map explicit for future contributors, and leaving a durable handoff surface once the game is considered complete. This batch exists so the repo does not remain technically “done” while still presenting multiple contradictory design centers to the next person who opens it.

## Scope
- Included work
  - audit and classify remaining non-canonical legacy design/docs surfaces after final integration
  - add explicit archive/deprecation markers to historical weave-era documents that are being retained
  - create or tighten the canonical source map for runtime, docs, route program, and execution batches
  - consolidate acceptance evidence references so future contributors know what proves the shipped game
  - close the checkpoint surface for post-freeze maintenance
- Explicitly excluded work
  - new gameplay, route, or puzzle implementation
  - re-opening canonical route design after final acceptance
  - mass deletion of historical design material that is still useful as archive context
  - release engineering outside repo-local documentation and handoff structure

## Constraints
- Declarations remain canonical.
- This batch assumes the final integration and acceptance batch has already landed or is materially complete.
- Historical weave-era documents may remain in the repo, but they must stop reading like current truth.
- Prefer explicit deprecation/archival notes over destructive removal when the material still has research value.
- Do not let the archive surface mutate current canonical docs back into comparative essays.
- Keep the final canonical path easy to discover from the repo root and `docs/`.

## Assumptions
- The shipped canonical story model is `Adult -> Elder -> Child`.
- The main canonical doc surface is:
  - `docs/PLAYER_PREMISE.md`
  - `docs/ELIZABETH_ROUTE_PROGRAM.md`
  - `docs/NARRATIVE.md`
  - `docs/MASTER_SCRIPT.md`
  - `docs/script/MASTER_SCRIPT.md`
- The main execution/checkpoint surface is:
  - `PLAN.md`
  - `MEMORY.md`
  - `STRUCTURE.md`
  - active batch files under `docs/batches/`
- Some legacy docs such as `docs/WEAVE_ARCHITECTURE.md`, `docs/WEAVE_BALANCE.md`, `docs/WEAVE_PLAYTEST.md`, and `docs/PAPER_PLAYTEST.md` are likely worth retaining as archive material if clearly marked.

## Execution Policy
- Completion standard
  - The batch is complete only when a new contributor can open the repo, find the canonical game definition quickly, distinguish archive from source-of-truth material, and locate the evidence that the shipped game is the one described by current docs.
- Stop conditions
  - Stop if the final integration batch has not yet stabilized the canonical docs/runtime/test surface.
  - Stop if archive/deprecation work would require re-litigating product decisions rather than labeling historical material honestly.
  - Stop if a proposed archive move would break active references needed by current execution batches.
- Verification cadence
  - Re-run targeted `rg` checks before and after archive/deprecation edits.
  - Review the main docs entry surfaces after each classification/editing slice.
  - Prefer structural sanity checks over heavy runtime verification unless canonical surfaces are touched.
- Partial completion
  - Acceptable only at verified checkpoint boundaries inside this batch.
  - Do not leave half-labeled archival docs that still mix current-canon and legacy language ambiguously.

## Task Graph

### H01
- `ID:` H01
- `Title:` Audit and classify post-freeze legacy and archive candidate documents
- `Depends on:` none
- `Why it exists:` archive hygiene only works if the repo knows which documents are still canonical, which are compatibility notes, and which are purely historical.
- `Implementation notes:`
  - search `docs/` for legacy weave-era and pre-route-program material
  - classify files as:
    - canonical
    - active support/reference
    - archive/deprecate
  - focus especially on old weave docs, old playtests, and design explorations
  - record the classification in `MEMORY.md`
- `Acceptance criteria:`
  - there is a concrete classification list for major design/docs surfaces
  - archive candidates are clearly separated from canonical blockers
  - downstream tasks can update the right files without guesswork
- `Verification:`
  - `rg -n "Captive|Mourning|Sovereign|weave" docs`
  - update `MEMORY.md` with the archive classification summary
- `Status:` pending

### H02
- `ID:` H02
- `Title:` Mark retained weave-era and pre-route-program docs as archived or non-canonical
- `Depends on:` H01
- `Why it exists:` the repo should retain useful historical material without letting it masquerade as the current game plan.
- `Implementation notes:`
  - add short archive/deprecation notices to retained historical docs
  - clarify what replaced them and where the reader should go now
  - avoid rewriting their contents unless needed for safety/clarity
  - ensure archive wording is factual and concise
- `Acceptance criteria:`
  - retained legacy docs no longer read as canonical design truth
  - each archived/deprecated doc points to the current canonical surface
  - canonical docs remain clean and non-defensive
- `Verification:`
  - targeted review of touched archive docs
  - `rg -n "non-canonical|archived|superseded|replaced by" docs`
- `Status:` pending

### H03
- `ID:` H03
- `Title:` Tighten the canonical source map and contributor handoff surface
- `Depends on:` H01
- `Why it exists:` even with archive markers, the repo still needs one obvious place that tells future contributors where truth actually lives.
- `Implementation notes:`
  - update or add a concise canonical source map in the docs index/handoff surfaces
  - ensure root checkpoints and major docs index point clearly to:
    - canonical narrative docs
    - declaration/runtime truth
    - active batches
    - acceptance evidence lanes
  - keep this as a handoff aid, not another sprawling meta-doc
- `Acceptance criteria:`
  - a contributor can discover the canonical source map from repo-root/doc surfaces quickly
  - canonical docs, runtime source-of-truth, and active batch surfaces are clearly named
  - archive material is visibly downstream from the canonical map
- `Verification:`
  - review `PLAN.md`, `MEMORY.md`, `STRUCTURE.md`, and any touched docs index surfaces together
- `Status:` pending

### H04
- `ID:` H04
- `Title:` Consolidate acceptance evidence references and close the maintenance handoff
- `Depends on:` H03
- `Why it exists:` after freeze, the repo should show not just what the game is, but what evidence proves it and how a maintainer should reason about it.
- `Implementation notes:`
  - point to the final command surface and renderer-backed evidence lanes
  - capture where screenshots/captures live and which tests matter most
  - update checkpoint files to reflect post-freeze maintenance posture rather than active large-scale redesign
  - keep the handoff practical and short
- `Acceptance criteria:`
  - the repo names the acceptance evidence lanes clearly
  - post-freeze maintenance can start from checkpoint surfaces without re-deriving the project state
  - the repo no longer looks like it is still deciding what game it wants to be
- `Verification:`
  - review `PLAN.md`, `MEMORY.md`, and `STRUCTURE.md`
  - confirm acceptance commands and evidence lanes are named consistently
- `Status:` pending

### H05
- `ID:` H05
- `Title:` Run final archive/handoff sanity pass
- `Depends on:` H02, H03, H04
- `Why it exists:` the repo should leave this batch with one coherent story about what is current, what is historical, and how to resume future maintenance safely.
- `Implementation notes:`
  - re-run archive-related searches
  - spot-check canonical docs, archive docs, and checkpoint files together
  - correct any remaining ambiguous or contradictory labels
  - leave a final note in `MEMORY.md` describing the archive posture
- `Acceptance criteria:`
  - canonical and archive surfaces are clearly distinguished
  - no major historical weave doc still presents itself as active canon without qualification
  - the handoff surface is usable without prior conversation context
- `Verification:`
  - `rg -n "Captive|Mourning|Sovereign|weave" docs`
  - targeted review of touched canonical and archived docs
- `Status:` pending

## Critical Gates
- Gate 1: H01 must classify the major doc surfaces before any archive labeling begins.
- Gate 2: H02 and H03 must together separate canonical truth from retained history before handoff work is credible.
- Gate 3: H05 must leave the repo with an unambiguous archive posture; partial labeling is not enough.

## Resume Instructions
- Start from this file and the final integration batch in `docs/batches/final-integration-and-acceptance.md`.
- Assume the upstream implementation batches are complete enough that this is post-freeze closeout work.
- Before editing, verify the current doc surface:
  - `rg -n "Captive|Mourning|Sovereign|weave" docs`
  - `sed -n '1,220p' PLAN.md`
  - `sed -n '1,220p' MEMORY.md`
  - `sed -n '1,220p' STRUCTURE.md`
- Resume at H01 unless an archive classification map already exists in `MEMORY.md`.
- After each task, update:
  - `MEMORY.md`
  - `PLAN.md`
  - `STRUCTURE.md`
  - this batch file’s task statuses
- If interrupted mid-task, stop at a verified checkpoint or record the exact archive/handoff ambiguity in `MEMORY.md`.
