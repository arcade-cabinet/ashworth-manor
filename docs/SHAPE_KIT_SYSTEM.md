# Shape Kit System

Ashworth Manor should default to a **procedural-first PSX build style**.

That means:

- start with primitive shapes
- wrap them in estate material shaders and texture families
- use authored models only when the silhouette or trim complexity truly requires them

This is a better fit for Godot than the earlier model-heavy bias, especially for a
PSX-style game where readable form, lighting, and material identity matter more
than dense mesh detail.

## Default Stack

The preferred stack is:

1. primitive body from the shape kit
2. estate material or texture treatment
3. optional inset trim / hero model detail
4. optional procedural moving part

Examples:

- wine glass: lathed or primitive-derived bowl/stem/foot + glass material
- Persian rug: plane or thin box + textile material/texture
- window: procedural frame and pane + optional trim model
- ladder: procedural rails/rungs + hardware material
- bathtub: primitive basin + claw-foot trim pieces if needed
- menu sign: posts/crossbar/plaque/chains from shapes + wood/brass/iron materials

## Use Models Sparingly

Models are still appropriate for:

- statues
- highly specific furniture silhouettes
- decorative clutter where hand-shaped asymmetry helps
- ornate trim that would be wasteful to rebuild from primitives every time

Models should **not** be the default for:

- doors
- windows
- stairs
- ladders
- gates
- signs
- containers
- vessels
- bathtubs
- tables that can be expressed through a small primitive recipe

## Material Families

The shape kit becomes powerful when paired with reusable material families:

- brass
- blackened iron / chain iron
- varnished oak / walnut / mahogany
- painted moulding wood
- marble
- porcelain / ceramic glaze
- carpet / runner textiles
- frosted / clear / stained glass
- slate / tile / stone

These materials should carry most of the period identity.

## Runtime Goal

The long-term goal is:

- a small reusable primitive authoring kit
- a strong estate material vocabulary
- fewer brittle imported meshes
- easier state changes
- easier animation
- easier scaling
- stronger tableau control

That is the correct bias for Ashworth Manor.
