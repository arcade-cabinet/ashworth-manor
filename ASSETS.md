# ASSETS.md — Complete Asset Manifest

Every GLB model, texture, and audio loop mapped to its room, puzzle, or scene element.

**Total Assets**: 376 GLBs + 596 PNGs (textures + Godot imports) + 36 audio loops = **1000+ files** across named room directories

---

## Art Direction

- **Style**: PSX/PS1 retro — low-poly, vertex-lit, affine texture warping
- **Primary Source**: Retro PSX Style Mansion v2.0 (all interior structure and furniture)
- **Supplemental**: Horror-Fantasy (dolls), Fantasy (bottles/crates/nature), SBS Horror Textures
- **Audio**: Loops - Lonely Nightmare (horror ambient loops, OGG format)
- **NO AI-generated content** — all assets are from purchased/licensed packs

---

## Room-by-Room Asset Mapping

### PROLOGUE: Front Gate & Drive (`front_gate`)

| Asset | Source | Usage |
|-------|--------|-------|
| `nature.glb` | props | Overgrown hedges, dead trees |
| `pillar0.glb` + `pillar0_001.glb` | mansion/structure | Gate pillars |
| Horror_Stone_* textures | horror/textures | Gate and drive surfaces |
| Horror_Brick_* textures | horror/textures | Approach wall |
| **Audio**: `Tempest Loop1.ogg` | loops | Cold wind, isolation |

---

### Grand Foyer (`foyer`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor0.glb` | mansion/structure | Marble checkered floor |
| `wall_0.glb` - `wall_3.glb` | mansion/structure | Red wallpaper walls (4 walls) |
| `cieling0.glb` | mansion/structure | Ornate plaster ceiling |
| `doorway0.glb` | mansion/structure | North door → Parlor |
| `doorway1.glb` | mansion/structure | East door → Dining |
| `doorway2.glb` | mansion/structure | West door → Kitchen |
| `stairs0.glb` | mansion/structure | Grand staircase up |
| `stairbanister.glb` | mansion/structure | Staircase banister |
| `banister.glb` + `banisterbase.glb` | mansion/structure | Upper landing rail |
| `chandelier.glb` | mansion/decor | Central chandelier (primary light) |
| `candle_holder.glb` | mansion/decor | Wall sconces ×2 |
| `picture_blank.glb` | mansion/decor | Lord Ashworth portrait (south wall) |
| `window.glb` + `window_ray.glb` | mansion/structure | High window + moonlight ray |
| `pillar0_002.glb` + `pillar0_003.glb` | mansion/structure | Foyer columns |
| `rug0.glb` | mansion/decor | Entry rug |
| **Interactable**: `picture_blank.glb` | mansion/decor | Portrait of Lord Ashworth |
| **Interactable**: (box mesh) | — | Grandfather clock |
| **Interactable**: (plane mesh) | — | Entry mirror |
| **Interactable**: (box mesh) | — | Light switch |
| **Audio**: `Moonlight Loop1.ogg` | loops | Gentle unease, moonlit |

---

### Parlor (`parlor`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor1.glb` | mansion/structure | Wood parquet floor |
| `wall_4.glb` - `wall_4_001.glb` | mansion/structure | Green wallpaper walls |
| `cieling1.glb` | mansion/structure | Molded plaster ceiling |
| `doorway3.glb` | mansion/structure | South door → Foyer |
| `fireplace.glb` | mansion/decor | Cold fireplace (primary light) |
| `candle0.glb` + `candle1.glb` | mansion/items | Table candles ×2 |
| `double_sofa.glb` | mansion/furniture | Velvet settee facing fire |
| `sofa.glb` | mansion/furniture | Second settee |
| `table.glb` | mansion/furniture | Side table |
| `picture_blank_001.glb` | mansion/decor | Lady Ashworth portrait |
| `rug1.glb` | mansion/decor | Persian rug |
| `page0.glb` | mansion/items | Torn diary page (on table) |
| **Interactable**: `picture_blank_001.glb` | — | Lady Ashworth portrait |
| **Interactable**: `page0.glb` | — | CRITICAL: Torn diary page |
| **Interactable**: (box) | — | Music box |
| **Audio**: `Comfort Loop1.ogg` | loops | False warmth, dying fire |

---

### Dining Room (`dining_room`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor1.glb` | mansion/structure | Dark wood floor |
| `wall_5.glb` | mansion/structure | Burgundy wallpaper walls |
| `cieling0.glb` | mansion/structure | Ornate ceiling |
| `doorway4.glb` | mansion/structure | West door → Foyer |
| `chandelier.glb` | mansion/decor | Dining chandelier |
| `table.glb` | mansion/furniture | Long dining table |
| `chair.glb` ×8 | mansion/furniture | Dining chairs |
| `plate.glb` ×8 | mansion/items | Place settings |
| `mug.glb` ×4 | mansion/items | Wine glasses (mug as proxy) |
| `candle2.glb` ×2 | mansion/items | Table candelabras |
| `picture_blank_002.glb` | mansion/decor | Dinner party photograph |
| **Interactable**: `picture_blank_002.glb` | — | Dinner party photo |
| **Audio**: `Keep it up Loop1.ogg` | loops | Formal dread |

---

### Kitchen (`kitchen`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor2.glb` | mansion/structure | Stone kitchen floor |
| `wall_7.glb` | mansion/structure | Aged plaster walls |
| `cieling2.glb` | mansion/structure | Exposed beam ceiling |
| `doorway5.glb` | mansion/structure | East door → Foyer |
| `stairs1.glb` | mansion/structure | Stairs down → Basement |
| `fireplace.glb` | mansion/decor | Kitchen hearth |
| `table.glb` | mansion/furniture | Work table |
| `drawers.glb` | mansion/furniture | Kitchen storage |
| `page1.glb` | mansion/items | Cook's note |
| `plate.glb` | mansion/items | Cutting board proxy |
| **Interactable**: `page1.glb` | — | Cook's note about attic |
| **Interactable**: `stairs1.glb` | — | Transition → Basement |
| **Audio**: `Without a Trace Loop1.ogg` | loops | Service area unease |

---

### Storage Basement (`storage_basement`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor3.glb` | mansion/structure | Stone brick floor |
| `wall_6.glb` | mansion/structure | Stone walls |
| `cieling2.glb` | mansion/structure | Wood beam ceiling |
| `stairs1.glb` | mansion/structure | Stairs up → Kitchen |
| `doorway6.glb` | mansion/structure | East door → Boiler Room |
| `candle0.glb` | mansion/items | Single candle (only light) |
| `chair.glb` | mansion/furniture | Broken chair |
| `crates_barrels.glb` | props | Storage crates |
| `picture_blank_003.glb` | mansion/decor | Scratched family portrait |
| `rubbish.glb` | mansion/decor | Piled furniture |
| **Interactable**: `picture_blank_003.glb` | — | CRITICAL: Scratched portrait |
| **Interactable**: (ladder mesh) | — | Ladder down → Wine Cellar |
| **Audio**: `Echoes at Dusk Loop1.ogg` | loops | First darkness |

---

### Boiler Room (`boiler_room`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor4.glb` | mansion/structure | Metal grate floor |
| `wall_8.glb` | mansion/structure | Brick walls |
| `cieling2.glb` | mansion/structure | Pipe-covered ceiling |
| `doorway7.glb` | mansion/structure | West door → Storage |
| `fireplace.glb` | mansion/decor | Industrial boiler fire |
| `study_desk.glb` | mansion/furniture | Work desk |
| `page2.glb` | mansion/items | Maintenance log |
| **Interactable**: `page2.glb` | — | Maintenance log |
| **Interactable**: (clock mesh) | — | Industrial clock (3:33) |
| **Audio**: `Insufficient Loop1.ogg` | loops | Industrial menace |

---

### Wine Cellar (`wine_cellar`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor3.glb` | mansion/structure | Dark flagstone floor |
| `wall_6.glb` | mansion/structure | Rough stone walls |
| `bottles.glb` | props | Wine rack bottles |
| `bookcase.glb` ×2 | mansion/furniture | Wine rack structure |
| `candle_holder.glb` ×2 | mansion/decor | Wall torches |
| `crates_barrels.glb` | props | Barrels and crates |
| `page3.glb` | mansion/items | Wine inventory note |
| `treasure.glb` | props | Locked box |
| **Interactable**: `page3.glb` | — | Wine inventory note |
| **Interactable**: `treasure.glb` | — | Locked box (cellar_key) → Mother's Confession |
| **Audio**: `Empty Hope Loop1.ogg` | loops | Deepest isolation |

---

### Upper Hallway (`upper_hallway`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor1.glb` | mansion/structure | Wood floor + runner |
| `wall_1.glb` | mansion/structure | Dark wallpaper |
| `cieling1.glb` | mansion/structure | Aged plaster ceiling |
| `stairs0.glb` | mansion/structure | Stairs down → Foyer |
| `doorway0.glb` | mansion/structure | West → Master Bedroom |
| `doorway1.glb` | mansion/structure | West → Library |
| `doorway2.glb` | mansion/structure | East → Guest Room |
| `door.glb` | mansion/structure | North → LOCKED Attic Door |
| `candle_holder.glb` ×2 | mansion/decor | Wall sconces |
| `window.glb` | mansion/structure | End window (moonlight) |
| `picture_blank_004.glb` | mansion/decor | "Three Children" painting |
| `rug2.glb` | mansion/decor | Hallway runner |
| **Interactable**: `picture_blank_004.glb` | — | Children painting (only 3!) |
| **Interactable**: `door.glb` | — | LOCKED attic door |
| **Audio**: `Subtle Changes Loop1.ogg` | loops | Growing tension |

---

### Master Bedroom (`master_bedroom`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor1.glb` | mansion/structure | Wood floor |
| `wall_2.glb` | mansion/structure | Prussian blue wallpaper |
| `cieling1.glb` | mansion/structure | Plaster ceiling |
| `doorway3.glb` | mansion/structure | East door → Hallway |
| `master_bed.glb` | mansion/furniture | Four-poster bed |
| `drawers.glb` | mansion/furniture | Nightstand |
| `wardrobe.glb` | mansion/furniture | Wardrobe (ajar) |
| `candle0.glb` + `candle1.glb` | mansion/items | Bedside candles |
| `window.glb` | mansion/structure | Window (moonlight) |
| `rug0.glb` | mansion/decor | Persian carpet |
| `page4.glb` | mansion/items | Lord Ashworth's diary |
| **Interactable**: `page4.glb` | — | CRITICAL: Diary → "key in library globe" |
| **Interactable**: (plane mesh) | — | Large mirror |
| **Interactable**: (box mesh) | — | Jewelry box (jewelry_key) → Locket → Lock of Hair |
| **Audio**: `Lying Down Loop1.ogg` | loops | Violated intimacy |

---

### Library (`library`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor1.glb` | mansion/structure | Dark wood floor |
| `wall_3.glb` | mansion/structure | Wood paneling |
| `cieling2.glb` | mansion/structure | Coffered wood ceiling |
| `doorway4.glb` | mansion/structure | East door → Hallway |
| `bookcase.glb` ×4 | mansion/furniture | Floor-to-ceiling books |
| `books_scrolls.glb` | props | Additional book props |
| `candle_holder.glb` ×2 | mansion/decor | Sconces |
| `candle2.glb` | mansion/items | Desk candle |
| `study_desk.glb` | mansion/furniture | Reading desk |
| `chair.glb` | mansion/furniture | Desk chair |
| `openbook0.glb` | mansion/items | "Rituals of Binding" |
| `page5.glb` | mansion/items | Family tree display |
| **Interactable**: (sphere mesh) | — | PUZZLE: Globe → attic_key |
| **Interactable**: `openbook0.glb` | — | "Rituals of Binding" (pickable → counter-ritual) |
| **Interactable**: `page5.glb` | — | Family tree ("E_iza_eth") |
| **Audio**: `Value Loop1.ogg` | loops | Scholarly dread |

---

### Guest Room (`guest_room`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor1.glb` | mansion/structure | Simple wood floor |
| `wall_1.glb` | mansion/structure | Simple wallpaper |
| `cieling1.glb` | mansion/structure | Simple plaster ceiling |
| `doorway5.glb` | mansion/structure | West door → Hallway |
| `bed.glb` | mansion/furniture | Guest bed |
| `drawers.glb` | mansion/furniture | Bedside table |
| `candle_unlit0.glb` | mansion/items | Single candle |
| `window.glb` | mansion/structure | Window |
| `picture_blank_005.glb` | mansion/decor | Photo of woman at attic window |
| `papers.glb` | mansion/items | Guest ledger |
| **Interactable**: `picture_blank_005.glb` | — | Guest photo |
| **Interactable**: `papers.glb` | — | Guest ledger (Helena Pierce) |
| **Audio**: `Lost in Polaroids Loop1.ogg` | loops | Isolation, another victim |

---

### Attic Stairwell (`attic_stairs`)

| Asset | Source | Usage |
|-------|--------|-------|
| `stairs2.glb` | mansion/structure | Narrow creaking stairs |
| `wall_7.glb` | mansion/structure | Cracked plaster |
| Horror_Wall_* textures | horror | Water-stained plaster overlay |
| `candle_unlit1.glb` | mansion/items | Unlit candle (no light) |
| **Audio**: `Silent Voices Loop1.ogg` | loops | Dread building |

---

### Attic Storage (`attic_storage`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor2.glb` | mansion/structure | Rough wood floor |
| `wall_7.glb` | mansion/structure | Bare wood / aged plaster |
| `cieling2.glb` | mansion/structure | Exposed rafters |
| `window_clean.glb` | mansion/structure | Dormer window (moonlight) |
| `candle0.glb` | mansion/items | Single candle near doll |
| `crates_barrels.glb` | props | Old trunks |
| `rubbish.glb` | mansion/decor | Piled furniture |
| `picture_blank_006.glb` | mansion/decor | Elizabeth's portrait (eyes blacked out) |
| `doll1.glb` | horror | **THE PORCELAIN DOLL** — Elizabeth's vessel |
| `page0.glb` | mansion/items | Elizabeth's unsent letter (in trunk) |
| `door1.glb` | mansion/structure | Hidden door → Hidden Chamber (locked) |
| `bat.glb` | props | Bats in rafters (atmosphere) |
| **Interactable**: `picture_blank_006.glb` | — | Elizabeth's portrait |
| **Interactable**: `doll1.glb` | — | PUZZLE: Porcelain doll (hidden_key inside) |
| **Interactable**: `page0.glb` | — | Unsent letter |
| **Interactable**: `door1.glb` | — | Locked hidden door |
| **Audio**: `Lonely Nightmare Loop1.ogg` | loops | Elizabeth's domain |

---

### Hidden Chamber (`hidden_room`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor2.glb` | mansion/structure | Bare wood floor |
| Horror_Wall_* textures | horror | Walls covered in drawings |
| Horror_Misc_* textures | horror | Elizabeth's drawings overlay |
| `candle_unlit2.glb` ×2 | mansion/items | Two candles (barely lit) |
| `doll2.glb` | horror | Second doll variant (placed during ritual) |
| **Interactable**: `page1.glb` | — | Elizabeth's final note |
| **Interactable**: (plane mesh) | — | The final mirror |
| **Interactable**: (floor circle) | — | Ritual circle for counter-ritual |
| **Audio**: `I Can't Go On Loop1.ogg` → then `My Room Loop1.ogg` | loops | Revelation, Elizabeth's space |

---

### Chapel (`chapel`)

| Asset | Source | Usage |
|-------|--------|-------|
| Horror_Stone_* textures | horror | Limestone walls |
| `floor3.glb` | mansion/structure | Flagstone floor |
| `chair.glb` ×8 | mansion/furniture | Pew proxies |
| `candle_unlit0.glb` ×2 | mansion/items | Altar candles (unlit) |
| `window.glb` | mansion/structure | Rose window (moonlight) |
| `openbook1.glb` | mansion/items | Prayer book |
| **Interactable**: (stone basin) | — | Baptismal font → blessed_water |
| **Interactable**: (cross mesh) | — | Inverted cross |
| **Interactable**: `openbook1.glb` | — | Prayer book margin note |
| **Audio**: `Silent Voices Loop2.ogg` | loops | Sacred silence |

---

### Greenhouse (`greenhouse`)

| Asset | Source | Usage |
|-------|--------|-------|
| `nature.glb` | props | Dead plants, pots |
| `window_clean.glb` ×multiple | mansion/structure | Glass panels |
| Horror_Floor_* textures | horror | Flagstone path |
| `openbook2.glb` | mansion/items | Garden journal |
| **Interactable**: (plant mesh) | — | White lily (alive) |
| **Interactable**: `openbook2.glb` | — | Lady's garden journal |
| **Interactable**: (pot mesh) | — | Gate key hidden in pot |
| **Audio**: `Subtle Changes Loop2.ogg` | loops | Organic unease |

---

### Carriage House (`carriage_house`)

| Asset | Source | Usage |
|-------|--------|-------|
| `floor2.glb` | mansion/structure | Rough wood floor |
| Horror_Wall_* textures | horror | Rough wooden walls |
| `crates_barrels.glb` | props | Storage crates/trunks |
| `picture_blank_007.glb` | mansion/decor | Lord Ashworth duplicate portrait |
| `candle_holder.glb` | mansion/decor | Hanging lantern |
| **Interactable**: `picture_blank_007.glb` | — | PUZZLE: Portrait → cellar_key behind frame |
| **Interactable**: (trunk mesh) | — | Elizabeth's packed clothes |
| **Interactable**: (carriage mesh proxy) | — | Broken carriage, claw marks |
| **Audio**: `Echoes at Dusk Loop1.ogg` | loops | Abandoned space |

---

### Family Crypt (`family_crypt`)

| Asset | Source | Usage |
|-------|--------|-------|
| Horror_Stone_* textures | horror | Ancient stone walls |
| `floor3.glb` | mansion/structure | Flagstone floor |
| Horror_Brick_* textures | horror | Stone exterior |
| `statue.glb` | mansion/decor | Stone angel (face weathered) |
| `picture_blank_008.glb` + `picture_blank_009.glb` | mansion/decor | Memorial plaques |
| **Interactable**: (sarcophagus mesh) | — | Empty sarcophagi ×2 |
| **Interactable**: (wall section) | — | Missing fourth plaque |
| **Interactable**: (floor section) | — | Loose flagstone → jewelry_key |
| **Audio**: `Empty Hope Loop2.ogg` | loops | Grief, finality |

---

## Audio Loop Master Assignment

| Room | Primary Loop | Mood | Intensity |
|------|-------------|------|-----------|
| Front Gate | Tempest Loop1 | Cold wind, isolation | Low |
| Foyer | Moonlight Loop1 | Gentle unease | Low |
| Parlor | Comfort Loop1 | False warmth | Low |
| Dining Room | Keep it up Loop1 | Formal dread | Medium |
| Kitchen | Without a Trace Loop1 | Service unease | Medium |
| Storage Basement | Echoes at Dusk Loop1 | First darkness | Medium |
| Boiler Room | Insufficient Loop1 | Industrial menace | Medium |
| Wine Cellar | Empty Hope Loop1 | Deepest isolation | High |
| Upper Hallway | Subtle Changes Loop1 | Growing tension | Medium |
| Master Bedroom | Lying Down Loop1 | Violated intimacy | Medium |
| Library | Value Loop1 | Scholarly dread | Medium |
| Guest Room | Lost in Polaroids Loop1 | Isolation | Medium |
| Attic Stairwell | Silent Voices Loop1 | Dread building | High |
| Attic Storage | Lonely Nightmare Loop1 | Elizabeth's domain | High |
| Hidden Chamber | I Can't Go On Loop1 | Revelation | Max |
| Chapel | Silent Voices Loop2 | Sacred silence | Low |
| Greenhouse | Subtle Changes Loop2 | Organic unease | Low |
| Carriage House | Echoes at Dusk Loop1 | Abandoned | Medium |
| Garden | Subtle Changes Loop3_D | Unease outdoors | Low |
| Family Crypt | Empty Hope Loop2 | Grief | High |

### Event-Triggered Audio
| Event | Loop | When |
|-------|------|------|
| Document reading | Saved Notes Loop1 | Any note/document overlay |
| Mirror interaction | Reflection Loop1 | Any mirror examined |
| Sealed door | Sealed Loop1 | Locked door attempt |
| Elizabeth aware | Subtle Changes Loop3_D | Global tension increase |
| Music box event | Sayuri Loop1_01 | Music box plays in Parlor |
| Counter-ritual | Ceiling Stars Loop1 → Loop2 → Loop3 | Ritual progression |
| Freedom ending | A Place I've Seen Before Loop1 | Dawn/release |

### Unused Loops (Reserve)
| Loop | Potential Use |
|------|--------------|
| Comfort Loop2, Loop3 | Parlor return visits |
| Insufficient Loop2, Loop3_01 | Boiler room events |
| Subtle Changes Loop4 | Late-game tension |
| Tempest Loop2 | Escape ending exterior |
| Lying Down Loop1 | Already assigned |

---

## Texture Assignment Summary

### Mansion Textures (67 PNGs)
All mansion GLBs have embedded textures. The separate PNGs are for:
- Custom shader application in Godot
- Material overrides per room
- PSX shader UV distortion source

### Horror Textures (100 PNGs, 512×512)
| Category | Count | Usage |
|----------|-------|-------|
| Wall | 14 | Hidden Chamber drawings, Attic plaster, Chapel |
| Stone | 10 | Crypt, Basement, Chapel |
| Brick | 5 | Boiler Room, exterior walls |
| Floor | 15 | Basement, Kitchen, Crypt |
| Metal | 10 | Boiler Room pipes, gates |
| Stains | 10 | Water damage overlays (attic, basement) |
| Misc | 15 | Elizabeth's drawings, gore details |

---

## Picture Frame Assignment

10 blank picture frames (`picture_blank.glb` through `picture_blank_009.glb`):

| Frame | Room | Content |
|-------|------|---------|
| `picture_blank.glb` | Foyer | Lord Ashworth portrait |
| `picture_blank_001.glb` | Parlor | Lady Ashworth portrait |
| `picture_blank_002.glb` | Dining Room | Dinner party photograph |
| `picture_blank_003.glb` | Storage Basement | Scratched family portrait |
| `picture_blank_004.glb` | Upper Hallway | "Three Children" painting |
| `picture_blank_005.glb` | Guest Room | Woman at attic window photo |
| `picture_blank_006.glb` | Attic Storage | Elizabeth's portrait (eyes blacked) |
| `picture_blank_007.glb` | Carriage House | Lord Ashworth duplicate (cellar key behind) |
| `picture_blank_008.glb` | Family Crypt | Memorial plaque (Charles/Margaret) |
| `picture_blank_009.glb` | Family Crypt | Memorial plaque (William) |

---

## Asset Paths (Godot)

Assets are organized by floor and room name, mirroring the scene hierarchy:

```
assets/
├── ground_floor/
│   ├── foyer/           # GLBs + textures for the foyer
│   ├── parlor/
│   ├── dining_room/
│   └── kitchen/
├── upper_floor/
│   ├── hallway/
│   ├── master_bedroom/
│   ├── library/
│   └── guest_room/
├── basement/
│   ├── storage/
│   └── boiler_room/
├── deep_basement/
│   └── wine_cellar/
├── attic/
│   ├── stairwell/
│   ├── storage/
│   └── hidden_chamber/
├── grounds/
│   ├── front_gate/
│   ├── garden/
│   ├── chapel/
│   ├── greenhouse/
│   ├── carriage_house/
│   └── family_crypt/
├── shared/              # Models shared across rooms
│   ├── structure/       # Walls, floors, ceilings, stairs, doorways
│   ├── furniture/       # Beds, tables, chairs, bookcases, etc.
│   ├── decor/           # Chandeliers, rugs, picture frames, statues
│   ├── items/           # Candles, pages, plates, mugs, books
│   └── textures/        # Shared wall/floor/ceiling textures
├── horror/
│   ├── models/          # Dolls, bloodwraith
│   ├── textures/        # 100 horror textures (512x512)
│   └── flesh_fbx/       # Source FBX files
└── audio/
    └── loops/           # 36 OGG ambient loops
```
