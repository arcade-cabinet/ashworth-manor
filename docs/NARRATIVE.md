# Narrative Design

This document defines the current narrative structure for Ashworth Manor.

It supersedes the older macro-thread framing built around `Captive`,
`Mourning`, and `Sovereign`. Those materials now survive only as legacy
reference while the game is migrated to the new authored route model.

See also:

- [PLAYER_PREMISE.md](./PLAYER_PREMISE.md)
- [ELIZABETH_ROUTE_PROGRAM.md](./ELIZABETH_ROUTE_PROGRAM.md)
- [MASTER_SCRIPT.md](./MASTER_SCRIPT.md)

---

## Story Overview

Ashworth Manor is a first-person haunted-estate mystery about inheritance,
repressed family history, and a return to a house that remembers the player
more completely than the player remembers it.

The player arrives shortly after the Victorian collapse of the Ashworth family.
They come not as a stranger but as the estate's legal heir, summoned by a
solicitor's packet after the death of the final caretaker. They already know
they are Ashworth blood. What they do not know is what became of Elizabeth
Ashworth, why their childhood visits ended, and why the manor still seems to
answer them.

The game is built around three authored Elizabeth storylines. Each one
culminates in the same solve object, Elizabeth's music box, but makes the
player reach it through a different life-truth.

---

## Canonical Storyline Order

Ashworth Manor should no longer treat its macro narrative as PRNG.

The intended route order is:

1. `Adult`
2. `Elder`
3. `Child`

After all three have been completed, later runs may randomize among unlocked
routes. The first three completions are not random.

---

## Elizabeth Storylines

### Adult Elizabeth

- Signature feeling: a life stolen and partially erased
- Dominant spaces: parlor, library, attic
- Dominant clue types: letters, portraits, private effects, unfinished adult
  selfhood
- Final truth: Elizabeth lived into adulthood but was denied a normal life
- Final chamber: attic
- Music box meaning: the treasured object of a life interrupted, not a nursery
  relic alone

### Elder Elizabeth

- Signature feeling: continuity that should have ended
- Dominant spaces: great hall, wine cellar, crypt
- Dominant clue types: burial records, caretaking residue, altered family
  memory, old-age endurance
- Final truth: Elizabeth lived into old age and was still not released
- Final chamber: crypt
- Music box meaning: a keepsake buried with a woman the family never admitted
  had fully lived

### Child Elizabeth

- Signature feeling: sealed childhood horror and recovered family shame
- Dominant spaces: attic, childhood memory intrusions, hidden sealed room
- Dominant clue types: nursery traces, blocked architecture, family concealment
- Final truth: the deepest wound is a child erased inside the house itself
- Final chamber: hidden room discovered through attic clues
- Music box meaning: the core childhood object preserved inside the sealed lie

---

## Shared Spine

All three playthroughs share the same broad early and midgame spine.

### Prologue and Arrival

- Open on an inner page from a solicitor's packet
- Resolve first-person at the front gate as the hired cab departs
- Establish inventory by opening the valise beneath the estate sign
- Walk the long ceremonial drive and unlock the front door personally

### First House Occupation

- Enter a dark mansion
- Receive the first unmistakable house answer in a family-centered space
- Solve the first warmth and light problem through hearth- and room-driven play
- Learn the house through parlor/kitchen/foyer relations rather than abstract
  exposition

### First Supernatural Seizure

- After meaningful early exploration, Elizabeth's laugh heralds the first major
  event
- The player is forced through service architecture into the basement layer
- The fall is dangerous but intentional, not a random trap kill

### Service Reclamation

- The player relights themselves under pressure
- The service basement reveals how the estate actually functioned
- Restoring gas returns stable house light and changes the manor's state
- The player re-emerges through practical circulation rather than the grand
  stair fantasy

### Midgame Possession

- The player graduates from improvised survival to deliberate investigation
- The house becomes legible in rooms, grounds, and classed circulation
- The route-specific Elizabeth truth gradually biases which clues feel most
  charged

---

## Equipment and Light Progression

These are story and mood systems, not just mechanics.

### Early Game

- Held state: `firebrand`
- Meaning: fragile, improvised habitation

### Midgame

- Held state: `walking stick`
- Meaning: steadiness, probing, bodily investigation
- Trigger: restored house light and reclaimed circulation

### Late Game

- Transitional state: `lantern on hook`
- Final held state: `lantern hook`
- Meaning: descent, reach, pull, forbidden access

Each major transition should consume the previous held tool rather than letting
the player accumulate every prior affordance forever.

---

## Design Rules

- Outside paperwork and estate signage remain neutral. The house owns the
  uncanny layer.
- Elizabeth's laugh is never ambient flavor. When heard, a meaningful event is
  happening.
- The house should not default to source-less ambient uplift. Light must have a
  visible or narratively coherent source.
- The music box is always the final solve object.
- The three routes should feel like three authored storylines, not cosmetic
  variants of one seed.

---

## Narrative Priorities

1. Make the arrival and first occupation of the house socially believable.
2. Make the player's childhood relation to the estate emotionally legible.
3. Make each Elizabeth route feel distinct in signature, geography, and ending.
4. Keep the game melancholic, bodily, and haunted by omission rather than
   noisy.
