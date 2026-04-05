# Items & Inventory System

This document catalogs all collectible items, keys, and their functions in Ashworth Manor.

---

## Item Design Philosophy

### Core Principles

1. **Meaningful Items Only**
   - Every item has a purpose
   - No "junk" collectibles
   - Each item advances story or gameplay

2. **Narrative Integration**
   - Items reveal character or history
   - Finding items is a form of storytelling
   - Items connect to the Ashworth family

3. **Clear Function**
   - Purpose should be discoverable
   - No obscure use cases
   - If it's a key, it opens something

---

## Item Categories

### Keys
Physical keys that unlock doors, boxes, and passages.

### Documents
Readable items that provide story information.

### Artifacts
Objects with narrative significance that may be used in puzzles.

### Ritual Components
Items needed for the counter-ritual ending.

---

## Complete Item Catalog

### Keys

#### Attic Key
```yaml
id: attic_key
name: "Brass Key"
category: key
description: "An old brass key with 'ATTIC' etched into the bow."

location:
  room: library
  container: library_globe
  
acquisition:
  type: container_open
  prerequisites: []
  
unlocks:
  - target: attic_door
    location: upper_hallway
    
flags_set:
  - has_attic_key
  
narrative_significance: |
  Lord Ashworth hid this key to keep Elizabeth imprisoned.
  Finding it means defying his final wish.
```

#### Cellar Key
```yaml
id: cellar_key
name: "Iron Key"
category: key
description: "A heavy iron key, cold to the touch."

location:
  room: carriage_house
  container: carriage_portrait (behind frame)
  
acquisition:
  type: container_search
  clue: "Wine cellar note: 'The key is with the portrait'"
  
unlocks:
  - target: wine_box
    location: wine_cellar
    
narrative_significance: |
  Hidden behind a duplicate portrait of Lord Ashworth stored
  in the carriage house. Opens the wine cellar box containing
  Lady Ashworth's confession letter.
```

#### Jewelry Key
```yaml
id: jewelry_key
name: "Tiny Brass Key"
category: key
description: "A delicate key with a heart-shaped bow."

location:
  room: family_crypt
  container: loose_flagstone (beneath floor)
  
acquisition:
  type: environment_search
  clue: "Lady Ashworth's note: 'I hid the locket key here'"
  prerequisites:
    - item: gate_key (to enter crypt)
  
unlocks:
  - target: jewelry_box
    location: master_bedroom
    
narrative_significance: |
  Hidden by Lady Ashworth in the family crypt — she could not
  bear to look at Elizabeth's portrait in the locket. Opens the
  jewelry box containing Elizabeth's locket with lock of hair.
```

#### Hidden Key
```yaml
id: hidden_key
name: "Tarnished Key"
category: key
description: "A key so old the metal has darkened. It feels... warm."

location:
  room: attic_storage
  container: porcelain_doll (inside hollow body)
  
acquisition:
  type: multi_interact
  prerequisites:
    - flag: read_elizabeth_letter
    - flag: examined_doll (first interaction)
  puzzle: puzzle_hidden_key
  
unlocks:
  - target: hidden_door
    location: attic_storage
    
narrative_significance: |
  Hidden inside the porcelain doll — Elizabeth's vessel.
  The doll held both her spirit and the key to her inner
  sanctum. She wanted it to be found.
```

#### Gate Key
```yaml
id: gate_key
name: "Iron Gate Key"
category: key
description: "A plain iron key, inexplicably warm."

location:
  room: greenhouse
  container: terra_cotta_pot (next to white lily)
  
acquisition:
  type: container_search
  
unlocks:
  - target: crypt_gate
    location: family_crypt
    
narrative_significance: |
  Found next to Elizabeth's living lily in the greenhouse.
  The warmth of the key mirrors the warm soil around the lily —
  Elizabeth's life force reaching beyond the house.
```

---

### Documents (Non-Inventory)

These are readable documents that exist in the world but are not collected:

#### Lord Ashworth's Diary
```yaml
id: diary_lord
location: master_bedroom
type: note
content:
  title: "Lord Ashworth's Diary"
  text: |
    She won't stop crying. Even after we locked her away,
    I hear her sobbing through the walls. My wife says I'm
    mad, but I know what I hear. The attic key is hidden in
    the library globe. No one must find her.

flags_set:
  - read_ashworth_diary
  - knows_key_location
  
reveals:
  - Elizabeth was locked in the attic
  - Lord Ashworth felt guilt
  - The key's location
```

#### Rituals of Binding
```yaml
id: book_binding
location: library
type: note
content:
  title: "Rituals of Binding"
  text: |
    To trap a spirit, one must first give it form. The doll
    shall be the vessel, the blood the seal, and the attic
    the prison eternal...

flags_set:
  - knows_binding_ritual
  
reveals:
  - Elizabeth was bound, not just locked up
  - The doll is significant
  - This was occult, not just imprisonment
```

#### Elizabeth's Unsent Letter
```yaml
id: letter_elizabeth
location: attic_storage
type: note
content:
  title: "Unsent Letter"
  text: |
    Dearest Mother,
    They say I'm sick but I feel fine. Father won't let me
    leave my room anymore. The doll talks to me now. She says
    I'll be here forever. I'm scared.
    - Your Elizabeth

flags_set:
  - read_elizabeth_letter
  
reveals:
  - Elizabeth's own perspective
  - She wasn't actually sick
  - The doll communicated with her
  - She was terrified
```

#### Elizabeth's Final Words
```yaml
id: note_final
location: hidden_room
type: note
content:
  title: "Elizabeth's Last Words"
  text: |
    I understand now. The doll showed me. I was never sick -
    they were afraid of what I could see. The house has eyes.
    The walls have ears. And now I am part of it forever.
    Find me. Free me. Or join me.

flags_set:
  - knows_full_truth
  - read_final_note
  
reveals:
  - Complete truth about Elizabeth
  - Her abilities (second sight)
  - Her transformation
  - Player's choice
```

---

### Artifacts (Planned)

#### The Porcelain Doll
```yaml
id: porcelain_doll
name: "Elizabeth's Doll"
category: artifact
description: |
  A porcelain doll with cracked features. Its painted eyes
  seem to follow your movement. Cold to the touch.

location:
  room: attic_storage
  
acquisition:
  type: interact
  prerequisites:
    - flag: seen_elizabeth_portrait
    
properties:
  - ritual_component: true
  - weight: medium
  - breakable: false
  
used_in:
  - puzzle_counter_ritual
  
narrative_significance: |
  The vessel that contains Elizabeth's bound spirit.
  Central to both her imprisonment and potential freedom.
```

#### Elizabeth's Locket (Planned)
```yaml
id: locket_elizabeth
name: "Silver Locket"
category: artifact
description: |
  A tarnished silver locket. Inside is a miniature portrait
  of a young girl with knowing eyes.

location:
  room: master_bedroom
  container: jewelry_box
  
acquisition:
  type: container_open
  prerequisites:
    - item: jewelry_key
    
properties:
  - ritual_component: true
  - wearable: false
  
narrative_significance: |
  Lady Ashworth kept this close. Evidence she loved Elizabeth
  even as she helped imprison her.
```

---

### Ritual Components (FINALIZED)

For the counter-ritual ending, the player must collect:

| # | Component | Location | Acquisition | Puzzle Required |
|---|-----------|----------|-------------|-----------------|
| 1 | Porcelain Doll | Attic Storage | Pick up after extracting hidden_key | puzzle_hidden_key |
| 2 | Rituals of Binding | Library | Pick up after reading | None |
| 3 | Lock of Hair | Inside Locket → Inside Jewelry Box | Open locket | puzzle_jewelry_box |
| 4 | Blessed Water | Chapel Baptismal Font | Interact with font | None (chapel access) |
| 5 | Mother's Confession | Wine Cellar Box | Open box with cellar_key | puzzle_cellar_box |
| 6 | Elizabeth's Final Note | Hidden Chamber | Read (flag only, not collected) | puzzle_hidden_key |

#### Blessed Water
```yaml
id: blessed_water
name: "Vial of Holy Water"
category: ritual_component
description: |
  Water from the chapel's baptismal font. Despite the
  frozen December night, it hasn't turned to ice. It
  feels impossibly cold in the vial.

location:
  room: chapel
  container: baptismal_font

acquisition:
  type: interact
  prerequisites: []

used_in:
  - puzzle_counter_ritual (step 2: pour on doll)

narrative_significance: |
  The chapel water represents purification — the opposite
  of the binding ritual's corruption. Elizabeth was never
  baptized, which her father believed allowed her "sight."
  The water that should have protected her now frees her.
```

#### Mother's Confession
```yaml
id: mothers_confession
name: "Lady Ashworth's Confession"
category: ritual_component
description: |
  A letter in Lady Ashworth's hand, confessing her role
  in Elizabeth's imprisonment. Dated December 23rd, 1891 —
  one day before everything ended.

location:
  room: wine_cellar
  container: wine_box (locked)

acquisition:
  type: container_open
  prerequisites:
    - item: cellar_key

used_in:
  - puzzle_counter_ritual (must be in inventory)

narrative_significance: |
  The confession represents truth — Lady Ashworth admitting
  what was done. Its presence in the player's inventory during
  the counter-ritual means the truth has been acknowledged.
  The ritual cannot succeed without honesty.
```

---

## Inventory System Design

### Capacity
- Unlimited item storage (no inventory management puzzles)
- Items persist across room transitions
- Items persist in save data

### Item Display
- Text-based inventory list in pause menu
- Item descriptions readable from inventory
- No visual item sprites (minimalist)

### Item Usage
```typescript
// When player uses item on interactable
function useItem(itemId: string, targetId: string): boolean {
  const target = getInteractable(targetId);
  
  // Check if target accepts this item
  if (target.lock?.keyId === itemId) {
    // Unlock the target
    unlockTarget(targetId);
    // Don't consume key items (realistic)
    return true;
  }
  
  // Check for combination uses
  if (target.acceptsItems?.includes(itemId)) {
    // Execute combination action
    executeCombination(itemId, targetId);
    return true;
  }
  
  return false; // Item doesn't work here
}
```

---

## Schema Integration

Items are defined in the mansion schema:

```typescript
export const InventoryItemSchema = z.object({
  id: z.string(),
  name: z.string(),
  description: z.string(),
  icon: z.string().optional(),
  combinable: z.boolean().default(false),
  combinesWith: z.array(z.string()).optional(),
  combinedResult: z.string().optional(),
});
```

### Adding New Items

1. Define item in schema-compliant format
2. Add to mansion's `items` array
3. Place in room via `containedItems` array
4. Connect to locks via `keyId` references
5. Test acquisition and usage

### Item State Tracking

```typescript
// In GameStateSchema
inventory: z.array(z.string()), // Item IDs currently held

// Checking if player has item
const hasKey = gameState.inventory.includes('attic_key');

// Adding item
gameState.inventory.push('attic_key');
setFlag('has_attic_key');
```

---

## Development Checklist

### Designed (All items fully specified)
- [x] Attic Key — Library Globe
- [x] Cellar Key — Carriage House portrait
- [x] Hidden Key — Inside porcelain doll
- [x] Jewelry Key — Family Crypt flagstone
- [x] Gate Key — Greenhouse pot
- [x] Blessed Water — Chapel font
- [x] Mother's Confession — Wine Cellar box
- [x] Elizabeth's Locket — Jewelry Box (contains lock of hair)
- [x] Porcelain Doll — Attic Storage (pickable after key extracted)
- [x] Rituals of Binding — Library (pickable after reading)
- [x] Counter-ritual sequence — 3 steps in Hidden Chamber
- [x] All three endings fully scripted
