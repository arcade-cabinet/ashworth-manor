# Vision Document: A World That Exists Without You

This document captures the design philosophy of Ashworth Manor, informed by Myst's approach to world-building.

## What Myst Actually Did

### The Feeling of Trespass

Myst never told you that you were alone. It never told you to be afraid. You simply *were* afraid because:

- Every space felt like it belonged to someone else
- Objects were left mid-use (books open, machines running)
- The world continued existing whether you were there or not
- You were clearly not supposed to be here

**Key insight**: Myst's dread came from *presence*, not absence. The island felt inhabited even when empty.

### Limited Palette, Unlimited Atmosphere

Myst's 256-color palette forced constraints that became strengths:

- Colors had to do more work - each hue carried meaning
- Shadows weren't black, they were deep blues and purples
- Light sources tinted everything in their vicinity
- The limited palette created visual *coherence*

```
Myst's actual palette approach:
- Stonework: 6-8 shades of grey-blue
- Wood: 5-6 shades of warm brown
- Foliage: 4-5 muted greens
- Sky/Water: Gradient of 10-12 blues
- Accent: Rust orange, aged brass (sparingly)
```

### Silence as Design

Myst used sound sparingly:
- Ambient loops were minimal (wind, water, machinery hum)
- Footsteps changed with surface
- Mechanical sounds had weight and consequence
- Music was almost absent - reserved for significant moments

The silence made you *listen*. Every sound meant something.

### Machines That Made Sense

Every puzzle in Myst was a machine that:
- Had a clear physical mechanism
- Existed for a reason in the world
- Could be understood through observation
- Rewarded patience over trial-and-error

**Key insight**: Myst puzzles weren't "game puzzles" - they were systems you had to understand.

---

## Reframing Ashworth Manor

### From Horror to Unease

**Current approach** (wrong):
- Flickering lights for "creepy" effect
- Notes explicitly stating scary things
- Post-processing effects screaming "horror game"
- Interaction overlays breaking immersion

**Myst approach** (right):
- Steady lights that feel *watched*
- Objects that imply narrative through placement
- Visual clarity that lets wrongness emerge naturally
- Interactions that keep you in the world

### The House as Machine

Myst's islands were machines. Ashworth Manor should be too:

- The house has *systems* (heating, lighting, plumbing)
- These systems reveal how the family lived
- Understanding the systems reveals what happened
- Elizabeth didn't just live here - she understood the house

### What the Player Should Feel

**Not**: "This is a scary haunted house game"
**But**: "I am in someone's home. They might still be here."

The dread comes from:
- Finding a meal half-eaten, decades old
- A bed that looks slept-in this morning
- A music box that starts playing when you enter
- Clocks that all show the same time
- Your reflection arriving a moment late

---

## Victorian Color Philosophy

### Authentic Victorian Palette

Victorians loved deep, saturated color. This was a statement of wealth and permanence. Our mansion reflects this:

**Walls - Rich and Substantial**:
```
William Morris Red:   #732F26  - Drawing rooms, dining
Arsenic Green:        #335938  - Parlors (yes, it was toxic)
Prussian Blue:        #384A6B  - Bedrooms, studies
Deep Claret:          #612630  - Formal spaces
```

**Wood - The Bones of the House**:
```
Ebonized Mahogany:    #2E1F14  - Formal trim, furniture
Walnut:               #6B4824  - Parquet floors
Dark Oak:             #4A3520  - Paneling, stairs
```

**Stone and Plaster**:
```
Carrara Marble:       #D1C7B8  - Entry hall floors
Aged Plaster:         #ADA598  - Ceilings, moldings
Foundation Stone:     #2D2A28  - Basement, cellar
```

**Fabric and Carpet**:
```
Persian Crimson:      #85382E  - Rugs, upholstery
Velvet Burgundy:      #5C1F24  - Drapes, settees
Brocade Gold:         #8B7335  - Accents, trim
```

### The Quality of Light

Victorian interiors were lit by:
- Gas lamps (warm, steady)
- Candles (intimate, flickering gently)
- Fireplaces (deep orange, breathing slowly)
- Daylight through heavy curtains (diffuse, warm)

Light in this world should feel *warm* and *alive*, not horror-movie harsh.

---

## Revised Interaction Philosophy

### Myst's Interaction Model

In Myst, you didn't "interact with objects." You:
- Pushed buttons and pulled levers
- Turned pages and read books
- Operated machinery
- Observed consequences

There were no "press E to interact" prompts. No glowing outlines.

### Ashworth Manor Interactions

**Remove**:
- Hover glow effects
- "TAP TO CLOSE" text
- Interaction result overlays
- Any UI that says "this is a game"

**Replace with**:
- Objects that respond physically (drawers open, pages turn)
- Documents that appear *in place* (zoom to painting, not overlay)
- Switches that actually control things
- Consequences that happen in the world

### Reading Documents

**Current** (wrong):
- Tap painting → overlay with description
- Aged paper texture overlay
- Close button

**Myst approach** (right):
- Approach painting → camera moves closer
- Details become visible naturally
- Step back to leave
- If text is needed, it's *on* the object (plaque, diary page)

---

## Revised Environmental Design

### The Lived-In House

Every room should answer: "What was someone doing here?"

**Foyer**: 
- Coat still on the hook
- Umbrella in the stand (wet? dry?)
- Mail on the table (unopened)

**Dining Room**:
- Places set for dinner
- One chair pushed back (someone left quickly)
- Wine glass still has residue

**Kitchen**:
- Pot on the stove (empty, burned bottom)
- Knife on the cutting board
- Vegetables half-chopped, now desiccated

**Master Bedroom**:
- Bed unmade on one side only
- Book on nightstand (what page?)
- Wardrobe door ajar

### Time as Character

Everything in the house should suggest a specific moment:
- December 24th, 1891, approximately 3:33 AM
- Something happened that made everyone stop
- The house has been frozen since

**Not** general decay. **Specific** interruption.

---

## Technical Approach

### Lighting Philosophy

**Authentic Sources**:
- Every light has a physical presence
- Candles breathe slowly (2-3 second cycles)
- Fireplaces pulse deeper (5+ second cycles)
- Gas lamps are steady with subtle warmth variation

**No Horror Tricks**:
- No strobing or rapid flicker
- No colored fog
- No "scary" shadows without logical sources
- Darkness means *absence of light*, not *presence of evil*

### Post-Processing (Subtle Enhancement)

```typescript
// Bloom - warm glow from light sources
pipeline.bloomEnabled = true;
pipeline.bloomThreshold = 0.75;
pipeline.bloomWeight = 0.2;

// Vignette - natural lens effect, warm
pipeline.imageProcessing.vignetteEnabled = true;
pipeline.imageProcessing.vignetteWeight = 0.8;
pipeline.imageProcessing.vignetteColor = new Color4(0.12, 0.10, 0.08, 1);

// NO chromatic aberration
// NO film grain
// NO aggressive color grading
```

### Materials

```typescript
// Victorian materials: rich color, subtle sheen from varnish/polish
mat.diffuseColor = baseColor;
mat.specularColor = new Color3(0.06, 0.05, 0.04); // Warm, subtle
mat.specularPower = 48;
mat.emissiveColor = Color3.Black(); // Light from sources only
```

---

## The Existential Dread

Myst's dread came from scale and abandonment:

1. **You are small**: The environments dwarf you
2. **You are late**: Everything important already happened
3. **You are watched**: But by what?
4. **You are trapped**: Not physically, but by needing to understand

### Implementing This

**Scale**:
- Ceilings higher than necessary
- Furniture slightly too large
- Doorways that make you feel small
- Windows that show vast, empty grounds

**Lateness**:
- Every clock shows 3:33
- Calendars open to December 24, 1891
- Newspapers yellowed but readable
- Food preserved by the cold (but clearly old)

**Being Watched**:
- Portraits with eyes that work too well
- Mirrors that don't quite sync
- The feeling of movement in peripheral vision
- Sounds that might be footsteps (but aren't... probably)

**The Trap**:
- The door you came through won't open
- Windows show the same view from every room
- The house doesn't obey normal geometry
- You have to understand to leave

---

## Summary: The Approach

| Aspect | Horror Game | Ashworth Manor |
|--------|-------------|----------------|
| Palette | Dark, desaturated | Rich Victorian colors |
| Lighting | Strobing, harsh | Warm, breathing, motivated |
| Effects | Heavy post-processing | Subtle enhancement |
| Interaction | UI overlays | Physical, in-world |
| Sound | Jump scares | Sparse, meaningful |
| Fear source | Monsters, surprises | Wrongness, presence |
| Player role | Victim | Trespasser, investigator |
| Goal | Survive | Understand |

**The Core Insight**:

This house was a home. People were born here, grew up here, loved here, died here. The horror isn't that it's haunted—it's that you're walking through someone's frozen moment. The breakfast they never finished. The letter they never sent. The door they never opened again.

The house doesn't want to scare you.
The house doesn't even know you're there.
That's what makes it terrifying.
