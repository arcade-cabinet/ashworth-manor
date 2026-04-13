# Glass System

Ashworth Manor now treats `Forward+` as the canonical renderer when a surface
needs convincing transparency, specular response, and subtle refraction.

The first project-local glass shader lives at:

- `res://shaders/glass/estate_glass_forward_plus.gdshader`

Current shared glass recipes:

- `glass/window_glass`
- `glass/facade_dark`
- `glass/door_lamplit`
- `glass/crystal_glass`
- `glass/greenhouse_glass`

Current shared scene applicator:

- `res://scenes/shared/shared_recipe_applicator.gd`

Legacy `res://resources/glass/*` materials still exist, but they are now
compatibility wrappers rather than the primary authored path.

## Why Forward+

The project already leans heavily on low-poly silhouettes, procedural geometry,
and material response. `Forward+` gives those surfaces better tools:

- stronger transparent/specular response on glasses and panes
- screen-space refraction for vessel and window distortion
- volumetric fog for candlelit interiors and moonlit grounds
- better glow, SSAO, and SSIL support for atmospheric depth

This is the correct trade for Ashworth Manor because the game is a tableau-first
first-person horror exploration game, not a strict lowest-common-denominator
mobile renderer target.

## Authoring Rule

Use the glass shader when:

- the player should notice the surface itself
- highlights, moonlight, or candlelight should travel across the material
- the transparent object is part of the tableau thesis

Examples:

- wine glass
- greenhouse panes
- chapel stained glass accents
- hero windows and conservatory glazing

Do not use it blindly for every transparent surface. Prefer it for hero
tableaux and surfaces whose readability materially affects player experience.

## First Benchmark

The first live benchmark is the dining-room wine glass:

- `res://scenes/shared/dining_room/dining_wine_glass_still.tscn`
- `res://scenes/shared/dining_room/dining_wine_glass_agitated.tscn`

That benchmark is now joined by:

- `WindowBuilder` pane resolution through `glass/window_glass`
- greenhouse shell panes through `glass/greenhouse_glass`
- greenhouse hanging lantern glass through `glass/crystal_glass`
- front-door and portico glazing through `glass/door_lamplit`
- mansion facade glazing through `glass/facade_dark`
