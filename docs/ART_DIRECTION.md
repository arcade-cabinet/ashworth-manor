# Art Direction

This document defines the visual style, atmosphere, and aesthetic guidelines for Ashworth Manor.

## Visual Identity

### Core Aesthetic
**Victorian Gothic Horror** — A grand mansion frozen in 1891, where opulence has decayed into dread. The aesthetic draws from:
- English Victorian manor houses (1837-1901)
- Gothic Revival architecture
- Pre-Raphaelite color sensibilities
- Period-accurate interior design

### What This Is NOT
- Cyberpunk or futuristic
- Neon-lit or high-saturation
- Jump-scare horror
- Modern minimalist
- Steampunk (no brass gears or goggles)

## Color Palette

Victorians embraced rich, saturated color as a display of wealth and taste. Our palette is authentic to the period.

### Wallpaper Colors
| Color | Hex | Room Usage |
|-------|-----|------------|
| William Morris Red | `#732F26` | Foyer, formal rooms |
| Arsenic Green | `#335938` | Parlor, drawing room |
| Prussian Blue | `#384A6B` | Bedrooms, study |
| Deep Claret | `#612630` | Dining room |
| Charcoal Damask | `#38302C` | Hallways |

### Wood Tones
| Color | Hex | Usage |
|-------|-----|-------|
| Ebonized Mahogany | `#2E1F14` | Formal trim, banisters |
| Dark Walnut | `#4A3520` | Parquet, paneling |
| Aged Oak | `#5C4428` | Simple rooms, servants |

### Stone and Plaster
| Color | Hex | Usage |
|-------|-----|-------|
| Carrara Marble | `#D1C7B8` | Entry floors |
| Aged Plaster | `#E0D8CC` | Ceilings |
| Foundation Stone | `#2D2A28` | Basement |

### Lighting Colors
| Light Type | Color (RGB) | Character |
|------------|-------------|-----------|
| Candle | `(1.0, 0.85, 0.55)` | Intimate, warm |
| Gas Lamp | `(1.0, 0.88, 0.65)` | Steady, golden |
| Fireplace | `(1.0, 0.6, 0.3)` | Deep, breathing |
| Daylight | `(0.95, 0.92, 0.85)` | Diffuse, warm |
| Moonlight | `(0.7, 0.75, 0.85)` | Cold, pale |

## Lighting Philosophy

### Architectural Honesty
Every light source must have a physical presence:
- Candles on surfaces or in holders
- Sconces mounted on walls
- Chandeliers suspended from ceilings
- Fireplaces built into walls
- Windows allowing exterior light

**Never create ambient light without a visible source.**

### Visibility vs. Atmosphere
The balance between mood and playability:
- Player must always see where they can walk
- Interactable objects should be discernible
- Darkness should feel intentional, not frustrating
- Use `ambientDarkness` values between 0.4 (bright) and 0.9 (very dark)

### Light Behavior

Real flames don't strobe—they breathe. Our lights should feel alive, not alarming.

**Candles**: Gentle, slow breathing with occasional tiny flutter
- Cycle: 2-3 seconds
- Variation: ±4%
- Occasional micro-flutter (rare)

**Fireplaces**: Deep, slow pulsing as embers glow and fade
- Cycle: 5+ seconds  
- Variation: ±6%
- Feels like breathing

**Gas Lamps/Sconces**: Nearly steady with subtle warmth shifts
- Cycle: 8+ seconds
- Variation: ±2%
- Almost imperceptible

```typescript
// Candle: gentle breathing
flicker = Math.sin(time * 2.5) * 0.04 + Math.sin(time * 4.3) * 0.02;

// Fireplace: deep, slow
flicker = Math.sin(time * 1.2) * 0.06 + Math.sin(time * 2.7) * 0.03;
```

## Materials & Textures

### Floor Materials
| Room Type | Texture | Character |
|-----------|---------|-----------|
| Grand Rooms | `marble_checkered` | Wealth, formality |
| Living Spaces | `wood_parquet` | Warmth, elegance |
| Service Areas | `stone_kitchen` | Utility, coldness |
| Basement | `stone_dark` | Dread, age |
| Attic | `wood_rough` | Neglect, secrets |

### Wall Materials
| Room Type | Texture | Character |
|-----------|---------|-----------|
| Formal | `wallpaper_victorian_red` | Authority |
| Intimate | `wallpaper_victorian_green` | Calm before storm |
| Private | `wallpaper_victorian_blue` | Melancholy |
| Servant | `plaster_aged` | Class divide |
| Hidden | `plaster_drawings` | Madness |

### Ceiling Materials
| Room Type | Texture | Character |
|-----------|---------|-----------|
| Grand | `plaster_ornate` | Aspiration |
| Standard | `plaster_molding` | Respectability |
| Service | `wood_beams` | Function |
| Attic | `wood_rafters` | Exposure |

## Architectural Details

### Victorian Elements
Every room should include period-appropriate details:
- **Baseboards**: Dark wood, 6-8 inches tall
- **Crown Molding**: Decorative ceiling edge
- **Chair Rails**: Wall division at 1/3 height
- **Corner Pillars**: In large rooms
- **Door Frames**: Substantial, carved

### Room Proportions
Victorian rooms had generous proportions:
- Ground floor: 4-6m ceiling height
- Upper floor: 3.5-4m ceiling height
- Basement: 3m ceiling height
- Attic: 3-4m, often with exposed structure

## Typography

### Primary Typeface: Cinzel
- Used for: Titles, room names, menu items
- Style: Serif, elegant, inspired by Roman inscriptions
- Weight: 400-700
- Tracking: Wide (0.15-0.3em)

### Secondary Typeface: Cormorant Garamond
- Used for: Body text, notes, descriptions
- Style: Serif, readable, classical
- Weight: 400-600
- Italic for handwritten notes

### Text Presentation
- Notes appear on aged paper texture
- Formal documents use upright type
- Personal writings use italic
- Dates always in Victorian format (December 24th, 1891)

## Post-Processing Effects

Post-processing should enhance the natural qualities of the scene, not impose a "look."

### Standard Pipeline
```typescript
// Bloom - warm glow from light sources
bloomThreshold: 0.75
bloomWeight: 0.2
bloomKernel: 48

// NO chromatic aberration - that's a horror trick

// Vignette - subtle, warm (natural lens effect)
vignetteWeight: 0.8
vignetteColor: warm brown (#1E1A14)

// NO film grain - we want clarity
```

### Atmospheric Haze
- Mode: Exponential squared (FOGMODE_EXP2)
- Density: 0.006 (very subtle)
- Color: Warm dust (#261F1E)
- Purpose: Softens distant walls, suggests still air and dust

## Emotional Tone

### Progression of Dread
| Floor | Atmosphere | Lighting Level |
|-------|------------|----------------|
| Ground | Faded grandeur | Moderate |
| Upper | Unsettling quiet | Dim |
| Basement | Industrial menace | Very dim |
| Deep Basement | Oppressive dark | Minimal |
| Attic | Suffocating secrets | Variable |

### Environmental Storytelling
Objects should suggest narrative:
- Dust on undisturbed surfaces
- Scratches on doors from the inside
- Clocks stopped at 3:33
- Faces scratched from photographs
- Beds that look recently occupied

## Reference Imagery

### Architectural Inspiration
- Highclere Castle interiors
- Waddesdon Manor
- Victorian townhouse restoration photos

### Atmospheric Inspiration
- Crimson Peak (2015) - Mansion aesthetic
- The Others (2001) - Lighting approach
- Amnesia: The Dark Descent - Exploration feel

### Color Inspiration
- John Atkinson Grimshaw paintings
- Pre-Raphaelite interiors
- Victorian photography (hand-tinted)
