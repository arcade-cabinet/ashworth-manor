# Ashworth Manor Game Bible

## Purpose

This document is the canonical whole-game reference for Ashworth Manor.

Use it when you need the complete shipped game in one place:

- premise
- player journey
- room program
- route structure
- tool and light grammar
- solve and ending rules
- implementation priorities

If an older doc disagrees with this file, this file wins.

---

## High Concept

Ashworth Manor is a first-person PSX-style haunted-estate mystery about
inheritance, buried family history, and a house that remembers the player more
completely than the player remembers it.

The player returns shortly after the collapse of the Victorian Ashworth family.
They are not a stranger, and not a random investigator. They are the legal
heir, an adult with standing elsewhere, summoned after the death of the final
caretaker to inspect and assume responsibility for a burden-estate that should
have been settled long ago.

The game is melancholic, bodily, and architectural. Fear comes from omission,
distance, classed circulation, unstable light, and the sense that the house is
answering the player personally.

The invariant symbolic center is Elizabeth Ashworth's music box. Every route
ends there. What changes is who Elizabeth truly was, where the box is found,
and what its final meaning becomes.

---

## Canonical Order

The first three completions are fixed:

1. `Adult`
2. `Elder`
3. `Child`

Only later repeat runs may randomize among unlocked routes.

The old `Captive / Mourning / Sovereign` weave is not the shipped model.

---

## Player Premise

### Playable Present

- The game takes place shortly after the Victorian collapse, not in a modern
  ruin.
- The estate is intact but recently dropped.
- The house should feel maintained until the caretaker's death, then left in
  strained stillness.
- Ashworth Manor is a burden, not a dream inheritance.

### Player Position

- The player already knows they are Ashworth blood.
- They are an established adult, likely arriving from London by rail and hired
  carriage.
- They visited the estate as a child and were abruptly kept away.
- They return to discover what was hidden from their family line.

### Inciting Packet

- The opening document is an inner page from a larger solicitor's packet.
- The estate has already passed to the player by the time the game begins.
- The packet is professional, external, and neutral.
- The packet later survives as an inventory document bundle.

---

## Core Design Rules

- Outside paperwork and estate signage remain neutral.
- Elizabeth's laugh only marks significant events.
- Lighting must always have a visible or narratively coherent source.
- The player should feel physical thresholds, not abstract menu progression.
- No combat, enemies, or gamified HUD overlays.
- The game must preserve tap-to-walk and swipe-to-look embodiment.
- The mansion is procedural-first and model-assisted.
- The music box always resolves the route.

---

## Tool and Light Grammar

### Tool Phases

1. `firebrand`
   - early improvised light
   - fragile, temporary, bodily

2. `walking stick`
   - midgame investigative tool
   - steadiness, probing, bodily certainty

3. `lantern hook`
   - late-game reach/pull/descent tool
   - forbidden access and final architecture

Major transitions consume the prior tool phase.

### Light Phases

1. Exterior practicals and carried light only
2. Dark interior on arrival
3. First reclaimed warmth via hearth
4. Early fragile personal light
5. Midgame stable estate light after gas restoration
6. Late loss of stable house light
7. Route-specific final darkness / chamber logic

---

## Shared Spine

All three routes share the same broad early and midgame structure.

### Stage 0: Solicitor Packet

Narrative job:
- justify the return
- establish duty and inheritance
- begin in professional reality, not ghost spectacle

Canonical beats:
- open on an inheritance page from the solicitor's packet
- establish that the estate has already passed to the player

### Stage 1: Front Gate Arrival

Narrative job:
- convert legal premise into bodily arrival
- establish burden, wealth, and etiquette failure

Canonical beats:
- first-person resolves as the hired cab departs
- the valise sits beneath the estate sign
- nobody is present to receive the player
- the player opens the valise to establish inventory

### Stage 2: Ceremonial Approach

Narrative job:
- create distance, formality, and commitment

Canonical beats:
- front gate, drive lower, drive upper, and front steps operate as one opening
  chain
- the mansion remains mostly withheld
- side routes are only revealed at the forecourt and begin locked/gated
- the player unlocks the front door personally

### Stage 3: First Occupation

Narrative job:
- make the house feel cold, dark, and not ready to receive anyone
- let the first answer come from a family-centered interior space

Canonical beats:
- the mansion is dark on arrival
- the player must reclaim first warmth and light

### Stage 4: Early Ground-Floor Cluster

Narrative job:
- teach the foyer, parlor, kitchen, and dining relations as lived spaces
- let the player feel briefly in control

Canonical beats:
- no humans are encountered
- the environment is alive but the house is socially dead

### Stage 5: Elizabeth's First Seizure

Narrative job:
- make Elizabeth's agency undeniable
- force the player below through service architecture

Canonical beats:
- after meaningful early exploration, the player inspects a kitchen-side
  service opening
- Elizabeth's laugh signals the event
- the player is forced into the service basement

### Stage 6: Service Reclamation

Narrative job:
- reveal how the estate functioned out of sight
- move the player from improvised light to restored house light

Canonical beats:
- the player relights themselves under pressure
- the basement reads as a real service world
- gas restoration changes the house state
- the player re-emerges through utilitarian circulation

### Stage 7: Midgame Possession

Narrative job:
- shift from survival to deliberate investigation
- let the house become socially and mechanically legible

Canonical beats:
- `walking stick` becomes active
- stable house light is now normal
- route-specific clue pressure begins

### Stage 8: Late-Game Transition

Narrative job:
- remove earned stability
- force the route-specific truth to the surface

Canonical beats:
- a route-specific rupture ends the midgame certainty
- the player enters final Elizabeth truth architecture

---

## Room Program

This section defines the job of every playable room or room-chain in the
shipped game.

### Exterior Arrival Chain

#### `front_gate`

- first embodied room
- sign, valise, etiquette failure, threshold
- no overt supernatural display

#### `drive_lower`

- distance
- hedge-lined wealth
- commitment corridor

#### `drive_upper`

- mounting pressure
- withheld mansion silhouette

#### `front_steps`

- forecourt revelation
- side gates visible but initially closed
- center path dominates

### Ground Floor

#### `foyer`

- public face of lineage and authority
- dark on arrival
- great-hall emotional job
- stronger route significance in `Elder`

#### `parlor`

- first intimate warmth
- first house answer in many routes
- strongest early emotional fit for `Adult`

#### `dining_room`

- formal family performance space
- social image versus hidden violence

#### `kitchen`

- service truth enters the game
- practical domestic space
- service hatch descent trigger

### Upper Floor

#### `upper_hallway`

- family circulation
- private threshold into route-specific truth
- becomes more charged in all three late routes

#### `master_bedroom`

- patriarchal guilt
- locks, medicine, private authority
- useful for `Child` and `Adult` clue pressure

#### `library`

- books, records, sanctioned knowledge
- strongest clue engine for `Adult`

#### `guest_room`

- family spillover, social residue, ledger logic
- flexible supporting clue room

### Service Basement

#### `storage_basement`

- forced-fall landing
- improvised relight
- bad-air pressure
- first service-world revelation

#### `boiler_room`

- estate machinery
- concise gas-restoration sequence
- transition from personal light to house light

### Deep Basement

#### `wine_cellar`

- lateral burial-side truth space
- strongest in `Elder`
- should feel worldly, secretive, and familial

### Grounds Side Branches

#### `garden`

- memory, observation, and line-of-sight truth

#### `chapel`

- sacred family performance, not sub-basement architecture

#### `greenhouse`

- cultivated concealment
- later route/tool utility

#### `carriage_house`

- practical estate residue
- service-side or reach-tool utility

#### `family_crypt`

- final chamber in `Elder`
- buried continuity and personal funerary truth

### Attic Chain

#### `attic_stairs`

- vertical anxiety
- route rupture surface
- threshold into late truth

#### `attic_storage`

- clue engine for `Adult` and `Child`
- never just generic clutter

#### `hidden_chamber`

- final chamber in `Child`
- sealed childhood horror
- must read as architecturally erased domestic truth, not occult bonus room

---

## Route Program

### Adult Route

Signature:
- stolen adulthood
- partial erasure
- unfinished biography

Dominant spaces:
- parlor
- library
- attic

Clue types:
- letters
- portraits
- private adult effects
- evidence of denied adulthood

Clue topology:
- see `docs/checkpoints/adult-route-clue-topology.md` for the complete
  room-by-room clue map, discovery cascade, and state tracking

Key new interactable:
- `elizabeth_papers` in the library — Elizabeth's hidden folio of adult
  writings, the strongest single proof of her adult intellectual life

Late structure:
- the attic becomes the final truth space
- the music box is found in the attic

Ending meaning:
- Elizabeth lived into adulthood and was denied a full life

### Elder Route

Signature:
- continuity that should have ended
- burial and memory turned accusatory

Dominant spaces:
- great hall / foyer
- wine cellar
- crypt

Clue types:
- burial records
- caretaker residue
- altered family memory
- preserved objects that lasted too long

Clue topology:
- see `docs/checkpoints/elder-route-clue-topology.md` for the complete
  room-by-room clue map, late-rupture grammar, and state-tracking notes

Late structure:
- the attic becomes the rupture point, not the answer
- clues drive the player toward wine cellar and crypt
- the music box is found with Elder Elizabeth in the crypt

Ending meaning:
- Elizabeth lived into old age and still was never released

### Child Route

Signature:
- sealed childhood horror
- blocked architecture
- recovered family shame

Dominant spaces:
- attic
- childhood memory intrusions
- hidden room

Clue types:
- nursery traces
- plastered or boarded architecture
- family concealment
- the player's own childhood memories

Late structure:
- the attic appears to be the answer
- attic clues expose the hidden room
- the music box is found in the hidden room

Ending meaning:
- the player reaches the foundational family crime: a child erased inside the
  estate itself

---

## Route-by-Route Stage Differences

### Shared Through Midgame

All three routes share:

- packet
- front gate and valise
- ceremonial drive
- dark entry
- first warmth/light
- kitchen-side service descent
- basement relight
- gas restoration
- walking-stick midgame

### Adult Late Game

- clue emphasis turns biographical
- attic remains the answer
- late chamber is private and archival
- late rupture: returning to upper hallway after attic visit triggers
  `late_darkness_active`, extinguishing stable house light
- lantern hook acquired in attic stairs (replaces walking stick)
- attic music box wound with brass winding key from valise
- ending fires via `trigger_ending("adult")` on `attic_music_box_wound`

### Elder Late Game

- clue emphasis turns funerary and residual
- attic becomes rupture, not resolution
- crypt becomes the final answer
- late darkness strips stable house light before the descent
- lantern-on-hook replaces the walking stick at the rupture
- attic music box redirects the player downward instead of resolving the route
- wine cellar opens the maintained barrel-side bypass into the crypt
- crypt gate is opened from the burial side with the hook
- the crypt music box is wound with the brass valise key
- ending fires via `trigger_ending("elder")` on `elder_music_box_wound`

### Child Late Game

- clue emphasis turns architectural and remembered
- attic becomes false answer / clue engine
- hidden room becomes final answer
- late darkness strips stable house light before the last attic return
- lantern hook replaces the walking stick at attic stairs
- attic music box only echoes and redirects the player to the west wall
- sealed seam requires hook leverage and reveals the erased room
- child music box is wound in the sealed room with the brass valise key
- ending fires via `trigger_ending("child")` on `child_music_box_wound`

---

## Solve Object Rule

The brass winding key in the valise and Elizabeth's music box are one symbolic
and mechanical arc.

The player carries the key from the beginning.

The route determines:

- where the box is found
- who Elizabeth truly was
- what the final act of winding and playing means

The final interaction should always feel route-specific, never generic.

---

## Endings

### Adult

- attic resolution
- stolen adulthood made visible

### Elder

- crypt resolution
- continuity that should have ended

### Child

- hidden-room resolution
- foundational family crime exposed

The ending system must record progression through the canonical order:

- complete `Adult` -> unlock `Elder`
- complete `Elder` -> unlock `Child`
- complete `Child` -> enter post-canonical repeat-run state

Post-canonical repeat-run state:
- route unlocks stop progressing
- replay mode stays inside `Adult / Elder / Child`
- the canonical story order remains recorded even when later runs replay

---

## Canonical Documentation Surface

**This file is the single canonical source of truth for the shipped game.**

If any other document disagrees with this file about premise, route order,
shared spine, endings, critical rooms, tools, or acceptance, this file wins.

### Supporting docs (focused supplements, not competing authorities)

| Document | Focused scope |
|----------|--------------|
| `docs/PLAYER_PREMISE.md` | Extended player-position, arrival, and lighting detail |
| `docs/ELIZABETH_ROUTE_PROGRAM.md` | Route design rationale and migration context |
| `docs/NARRATIVE.md` | Emotional framing, narrative priorities, memory layers |
| `docs/MASTER_SCRIPT.md` | Stage-by-stage beat detail for script authoring |
| `docs/script/MASTER_SCRIPT.md` | Authoring-oriented mirror (defers to the above) |

These supplements add depth but must not redefine any canonical claim made
here. When updating the shipped game, update this file first, then propagate.

### Execution and architecture docs

| Document | Role |
|----------|------|
| `PLAN.md` | Current execution priorities and product status |
| `MEMORY.md` | Execution memory, discoveries, and acceptance notes |
| `STRUCTURE.md` | Runtime architecture and canonical source map |
| `docs/batches/ashworth-master-task-graph.md` | Primary implementation contract |

### Legacy and support material

Room docs under `docs/rooms/`, floor docs under `docs/floors/`, older weave
docs, and design experiments are support or legacy material. They should not
be treated as canonical until explicitly migrated to match this file.

---

## Acceptance Surface

The shipped game is not considered real until all of these agree:

- declarations
- runtime behavior
- canonical docs
- automated tests
- renderer-backed walkthrough and opening captures

### Tier 1 — Repo-Local Freeze

These lanes validate the game as a coherent repo artifact. All must pass
before the repo can be considered frozen for release.

| Lane | Command |
|------|---------|
| Engine boot | `godot --headless --path . --quit-after 1` |
| Declaration integrity | `godot --headless --path . --script test/generated/test_declarations.gd` |
| Room specs | `godot --headless --path . --script test/e2e/test_room_specs.gd` |
| Declared interactions | `godot --headless --path . --script test/e2e/test_declared_interactions.gd` |
| gdUnit route program | `godot --headless --path . -s addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://test/unit -c --ignoreHeadlessMode` |
| Full playthrough | `godot --headless --path . --script test/e2e/test_full_playthrough.gd` |
| Room walkthrough | `godot --path . --script test/e2e/test_room_walkthrough.gd` |
| Opening journey | `godot --path . --script test/e2e/test_opening_journey.gd` |

### Tier 2 — Downstream Release Validation

These lanes validate the game as a shippable product on target devices.
They depend on Tier 1 passing first and require export toolchains and
device infrastructure beyond the repo itself.

| Lane | Scope |
|------|-------|
| Android export build | `godot --headless --path . --export-release "Android" build/android/ashworth-manor-release.apk` succeeds |
| Debug APK smoke test | `godot --headless --path . --export-debug "Android" build/android/ashworth-manor-debug.apk`, then install on device/emulator and confirm boot |
| Critical-path Maestro flows | Automated tap-through of landing → packet → valise → drive → dark entry → first warmth → one deeper continuation |
| Device walkthrough capture | Renderer-backed opening journey on target hardware |
| Release-candidate evidence | Collected screenshots, logs, and flow results archived per RC |

See `docs/MAESTRO_E2E_PLAN.md` for Maestro automation details and
`docs/batches/release-candidate-and-device-validation.md` for the full
release validation batch.

Downstream validation is not out of scope — it is deferred until repo-local
freeze is achieved, then executed as its own acceptance gate.
