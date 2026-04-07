# Secret Passages

This document defines how secret passages work in Ashworth Manor.

Secret passages are not novelty gimmicks. They exist to solve a specific design problem:

- preserve believable Victorian estate geography
- preserve the planned diamond puzzle ordering
- deepen the "house as machine" feeling

They must always feel diegetic, spatial, and narratively motivated.

---

## Design Rule

Use a secret passage only when all three are true:

1. A room or route should move for historical or architectural plausibility.
2. That move would otherwise damage puzzle ordering, clue routing, or A/B parity.
3. A concealed route is more believable than leaving the old topology in place.

If a normal overt connection works, prefer the overt connection.

---

## Passage Types

### Service Passage

Purpose:

- servant movement
- backstage circulation
- practical estate maintenance

Examples:

- kitchen wall panel to side yard
- storage area passage to carriage access
- hidden utility stair

Use for:

- `carriage_house`
- service-side grounds
- backstage mansion-to-outbuilding flow

### Family Concealment Passage

Purpose:

- private movement
- shame-driven concealment
- avoidance of public rooms

Examples:

- panel behind wardrobe
- concealed stair from private room
- hidden corridor behind wood paneling

Use for:

- secret family circulation
- route concealment tied to Elizabeth or parental secrecy

### Occult Passage

Purpose:

- ritual secrecy
- concealed access to forbidden places
- house-as-instrument logic

Examples:

- false wall near ritual machinery
- concealed opening behind symbolic object
- passage revealed by state or thread condition

Use sparingly.

This category should not become supernatural nonsense. It still needs architectural grounding.

---

## Presentation Rules

Secret passages must read as real things in real space.

They require:

- a visible architectural host
- a consistent room-local position
- a believable traversal form
- a before/discovered/opened state

Good hosts:

- bookshelf
- hearth panel
- servant's door in paneling
- floor hatch
- wardrobe back
- hedge gap hidden by statuary

Bad hosts:

- arbitrary glowing wall
- floating UI marker
- puzzle door with no architectural reason to exist

---

## Discovery Rules

A passage can be discovered by:

- direct examination of a suspicious object
- reading a clue that changes how an object is interpreted
- puzzle completion
- thread/junction resolution
- state-based reveal after a key story beat

Discovery should feel like:

- noticing
- understanding
- confirming

Not:

- randomly tapping every wall until one opens

---

## State Rules

Each passage has up to three states:

1. `unknown`
2. `revealed`
3. `opened`

Some passages may skip `revealed` and go directly from `unknown` to `opened`.

Rules:

- if a route is mechanically important, its state must be testable
- once a route is opened, it usually stays opened
- one-way-until-revealed is allowed when it improves dramatic flow
- hidden routes must not silently invalidate a required puzzle dependency

---

## Spatial Rules

Every secret passage must define:

- which room owns each end
- exact local position in each room
- the architectural surface it occupies
- trigger bounds
- spawn position after traversal
- facing direction after traversal

This is non-negotiable.

If the route cannot be placed convincingly in 3D space, it should not exist.

---

## Puzzle Graph Rules

Secret passages are allowed to preserve the diamond structure.

They are not allowed to trivialize it.

A secret passage must not:

- bypass a required key without an equivalent gate
- let one diamond branch become dramatically faster or safer than its counterpart without intent
- collapse discovery pacing by exposing late-game exterior spaces from the opening approach

The main approved use case is preserving access to a historically better room location without moving the room's diamond function.

---

## Approved Initial Use

### Carriage House Service Route

Status:

- approved in principle

Goal:

- move `carriage_house` off the ceremonial front-drive logic
- preserve Diamond #3 A-path

Approved anchors:

- `storage_basement` <-> `carriage_house`

Preferred feel:

- servant route
- backstage access
- discovered through clue/context, not obvious from the opening approach

---

## Non-Goals

Secret passages are not being added to make the house "more gamey."

They are being added to:

- improve estate plausibility
- support the Clue-like architectural connectedness
- preserve the puzzle weave under better topology
