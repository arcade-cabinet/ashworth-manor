# Visual Language

This document defines what Ashworth Manor should **look like**.

It exists because a game can be mechanically correct and still visually wrong.

Ashworth Manor is not aiming for a retro filter, an ironic PSX throwback, or a
deliberately degraded horror look. Its visual target is closer to:

- Myst-like spatial dignity
- deliberate Victorian material richness
- brass, oak, stone, glass, cloth, iron
- twilight and candle/gas light that feel physically present

## Core Rule

The game should look like a haunted country estate with real weight, not like a
nostalgia effect.

That means:

- no deliberate visual degradation for style points
- no custom shaders whose main job is to make things look worse
- no flat “retro because retro” texture choices when better PBR surfaces exist
- no prop piles standing in for architecture or traversable structure

## Material Direction

Ashworth should default to **PBR-forward, StandardMaterial-first** authoring.

Use:

- Godot `StandardMaterial3D`
- photorealistic texture families
- heightmaps or terrain surfaces where grounds relief materially helps
- HDRI skies for authored twilight, storm, and morning exterior moods
- decals for age, runoff, soot, dampness, and wear when they clarify the surface story
- subtle, restrained metal/roughness response
- visible differentiation between brass, iron, oak, leather, stone, hedge, paper

Avoid:

- intentionally crunchy sky/water/glass treatments
- fake-low-fidelity materials used only to signal “retro”
- overreliance on flat legacy texture packs when `/Volumes/home/assets/2DPhotorealistic`
  contains a better answer

## Palette

The palette should feel Victorian and composed:

- dark varnished oak
- soot-dark iron
- aged brass
- parchment and cream paper
- deep brown leather
- weathered stone and gravel
- clipped dark green/brown hedges
- moonlit blue-grey shadow
- warm amber gas and hearth light

This is a **brassy, woody, candlelit estate palette**, not a neon palette, not
an all-black palette, and not a deliberately dithered one.

## Spatial Direction

The manor should feel like one place with real depth and presence.

The correct bias is:

- procedural shell first
- procedural traversal first
- model-assisted silhouette detail second
- hero props and ornament last

This especially applies to:

- walls
- ceilings
- floors
- stair runs
- ladders
- trapdoors
- gates
- hedge boundaries
- path edges
- forecourt structure

Models should be used where silhouette complexity matters:

- statuary
- furniture
- decorative trim
- props
- hero ornaments

They should not be the default answer for the building itself.

## Grounds Direction

Exterior spaces must always provide:

- a readable twilight sky
- the right sky technology for the job:
  - HDRI when a specific outdoor light mood matters
  - generated panorama fallback when no better source exists
- a believable moon presence when composition calls for it
- visible stars and clouding when the weather allows
- horizon or estate enclosure appropriate to the room
- path edges that feel authored, not debug-generated
- hedges that read as clipped estate landscape, not black modular walls

Grounds should also stop pretending flat floors are enough when relief matters.
Use terrain/height-driven surfaces for:

- pond surrounds
- outer grounds beyond the clipped hedge axes
- carriage and greenhouse approach grading
- crypt court and chapel-side grade changes

The opening grounds specifically should feel:

- disciplined
- private
- stately
- lonely
- recently unmaintained, not ruined

## Visual Acceptance Rule

Screenshots are not only for proving a route executes.

Each capture must be usable to answer:

- Is the frame correct?
- Is the material language correct?
- Is the space believable?
- Is the player’s next movement implied diegetically?
- Does this feel like Ashworth Manor specifically?

If the answer is “it works but it still looks wrong,” the work is not done.
