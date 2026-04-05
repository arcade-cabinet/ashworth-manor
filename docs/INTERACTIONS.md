# Interaction System

This document details the interaction system, including object types, behaviors, and implementation patterns.

## Overview

Ashworth Manor uses a **diegetic interaction system** where all player interactions occur within the game world rather than through abstract UI elements. When a player interacts with an object, the response feels like examining something in the physical space.

## Interaction Flow

```
Player Tap
    │
    ▼
Ray Cast (scene.pick)
    │
    ▼
Check mesh.metadata
    │
    ├─► interactable: true
    │       │
    │       ▼
    │   handleInteraction(id, type)
    │       │
    │       ▼
    │   Get object data
    │       │
    │       ▼
    │   Set activeInteraction state
    │       │
    │       ▼
    │   Render overlay (Game.tsx)
    │
    ├─► walkable: true
    │       │
    │       ▼
    │   walkTo(pickResult.pickedPoint)
    │
    └─► transition: true
            │
            ▼
        handleTransition(targetRoom)
```

## Interactable Object Types

### Paintings

**Purpose**: Environmental storytelling, family history

**Visual**: Flat rectangle attached to wall
```typescript
mesh = MeshBuilder.CreatePlane('painting', {
  width: item.scale.x,
  height: item.scale.y
}, this.scene);
```

**Data Structure**:
```typescript
{
  id: 'foyer_painting',
  type: 'painting',
  position: { x: 0, y: 3, z: -6.5 },
  rotation: { x: 0, y: 0, z: 0 },
  scale: { x: 3, y: 2, z: 0.1 },
  data: {
    title: 'Lord Ashworth',
    content: 'The patriarch stares down with hollow eyes...'
  }
}
```

**Interaction Result**: Overlay showing title and description

---

### Notes

**Purpose**: Direct narrative exposition, diary entries, letters

**Visual**: Small rectangle (paper-sized)
```typescript
mesh = MeshBuilder.CreatePlane('note', {
  width: 0.3,
  height: 0.4
}, this.scene);
```

**Data Structure**:
```typescript
{
  id: 'parlor_note',
  type: 'note',
  position: { x: 2, y: 0.8, z: 2 },
  rotation: { x: -0.2, y: 0.5, z: 0 },
  scale: { x: 1, y: 1, z: 1 },
  data: {
    title: 'Torn Diary Page',
    content: 'The children have been hearing whispers from the attic again...'
  }
}
```

**Interaction Result**: Overlay with aged paper styling, italic text

---

### Photos

**Purpose**: Visual clues, family documentation

**Visual**: Small rectangle with slight depth
```typescript
mesh = MeshBuilder.CreatePlane('photo', {
  width: 0.3,
  height: 0.4
}, this.scene);
```

**Data Structure**:
```typescript
{
  id: 'guest_photo',
  type: 'photo',
  position: { x: 0, y: 1.5, z: 3.5 },
  rotation: { x: 0, y: Math.PI, z: 0 },
  scale: { x: 0.5, y: 0.4, z: 0.1 },
  data: {
    title: 'Unknown Guest',
    content: 'A woman in white stands at the attic window...'
  }
}
```

**Interaction Result**: Description of photograph contents

---

### Mirrors

**Purpose**: Atmospheric unease, self-reflection themes

**Visual**: Rectangular plane with reflective material
```typescript
mesh = MeshBuilder.CreatePlane('mirror', {
  width: item.scale.x,
  height: item.scale.y
}, this.scene);
```

**Material**:
```typescript
mat.diffuseColor = new Color3(0.5, 0.5, 0.55);
mat.specularColor = new Color3(0.8, 0.8, 0.8);
```

**Interaction Result**: Eerie observation about reflection

---

### Clocks

**Purpose**: Time symbolism, frozen moment

**Visual**: 3D box representing grandfather clock
```typescript
mesh = MeshBuilder.CreateBox('clock', {
  width: item.scale.x * 0.6,
  height: item.scale.y,
  depth: item.scale.z
}, this.scene);
```

**Interaction Result**: Description noting time (always 3:33 AM)

---

### Switches

**Purpose**: Environmental control, agency

**Visual**: Small box on wall
```typescript
mesh = MeshBuilder.CreateBox('switch', {
  width: 0.08,
  height: 0.12,
  depth: 0.03
}, this.scene);
```

**Interaction Result**: Toggles associated light source
```typescript
case 'switch':
  const lightId = `${sceneManager.getCurrentRoom()}_0`;
  sceneManager.toggleLight(lightId);
  break;
```

---

### Boxes/Containers

**Purpose**: Item discovery, locked progression

**Visual**: 3D box
```typescript
mesh = MeshBuilder.CreateBox('box', {
  width: item.scale.x,
  height: item.scale.y,
  depth: item.scale.z
}, this.scene);
```

**Data Structure**:
```typescript
{
  id: 'jewelry_box',
  type: 'box',
  position: { x: -3, y: 1, z: 4 },
  rotation: { x: 0, y: 0.3, z: 0 },
  scale: { x: 0.4, y: 0.25, z: 0.3 },
  data: { 
    locked: true, 
    keyId: 'jewelry_key',
    content: 'Inside you find...'
  }
}
```

**Interaction Logic**:
```typescript
case 'box':
  if (data?.locked && data?.keyId) {
    if (gameState.inventory.includes(data.keyId)) {
      // Unlock and show contents
      setActiveInteraction({
        type: 'box',
        title: 'Unlocked',
        content: data.content || 'The box opens with a click.',
      });
    } else {
      // Show locked message
      setActiveInteraction({
        type: 'locked',
        content: 'The box is locked. You need a key.',
      });
    }
  } else {
    // Open and possibly find item
    if (data?.itemFound) {
      setGameState(prev => ({
        ...prev,
        inventory: [...prev.inventory, data.itemFound]
      }));
    }
  }
  break;
```

---

### Ladders

**Purpose**: Vertical room transitions

**Visual**: Rectangular indicator
```typescript
mesh = MeshBuilder.CreateBox('ladder', {
  width: 1,
  height: 0.2,
  depth: 1
}, this.scene);
```

**Data Structure**:
```typescript
{
  id: 'cellar_ladder',
  type: 'ladder',
  position: { x: 3, y: 1.5, z: 4 },
  rotation: { x: 0, y: 0, z: 0 },
  scale: { x: 1, y: 1, z: 1 },
  data: { 
    targetRoom: 'storage_basement', 
    targetFloor: -1 
  }
}
```

**Interaction Result**: Room transition

---

### Stairs

**Purpose**: Floor-level transitions

**Visual**: Floor indicator
```typescript
mesh = MeshBuilder.CreateBox('stairs', {
  width: 1,
  height: 0.2,
  depth: 1
}, this.scene);
```

**Interaction Result**: Room transition with fade

---

## Hover Feedback

### Visual Glow Effect

```typescript
// Register hover actions
mesh.actionManager = new ActionManager(this.scene);

mesh.actionManager.registerAction(
  new ExecuteCodeAction(ActionManager.OnPointerOverTrigger, () => {
    if (mat) {
      mat.emissiveColor = mat.diffuseColor.scale(0.4);  // Brighter
    }
  })
);

mesh.actionManager.registerAction(
  new ExecuteCodeAction(ActionManager.OnPointerOutTrigger, () => {
    if (mat) {
      mat.emissiveColor = mat.diffuseColor.scale(0.15);  // Normal
    }
  })
);
```

### Interaction Flash

```typescript
private handleInteraction(id: string, type: string): void {
  // Visual feedback - brief glow
  const mesh = this.interactableMeshes.get(id);
  if (mesh && mesh.material instanceof StandardMaterial) {
    const originalEmissive = mesh.material.emissiveColor.clone();
    mesh.material.emissiveColor = new Color3(0.8, 0.3, 0.2);
    
    setTimeout(() => {
      if (mesh.material instanceof StandardMaterial) {
        mesh.material.emissiveColor = originalEmissive;
      }
    }, 200);
  }
}
```

---

## Interaction Overlay (Game.tsx)

### Structure

```tsx
<motion.div
  className="relative max-w-sm mx-4 p-6 md:p-8"
  style={{
    background: 'linear-gradient(135deg, #D4C4A8 0%, #C9B896 50%, #BFA882 100%)',
    boxShadow: '0 10px 40px rgba(0,0,0,0.5), inset 0 0 50px rgba(139, 69, 19, 0.1)',
  }}
>
  {/* Paper texture overlay */}
  <div className="absolute inset-0 opacity-30 pointer-events-none"
    style={{ backgroundImage: 'noise texture' }}
  />
  
  {/* Aged edges */}
  <div className="absolute inset-0 pointer-events-none"
    style={{ boxShadow: 'inset 0 0 30px rgba(101, 67, 33, 0.4)' }}
  />
  
  {/* Content */}
  <h3 className="font-cinzel">{title}</h3>
  <p className="font-serif">{content}</p>
</motion.div>
```

### Styling by Type

| Type | Font Style | Additional |
|------|------------|------------|
| note | Italic | Handwritten feel |
| painting | Normal | Title prominent |
| photo | Normal | Description only |
| mirror | Normal | Eerie tone |
| locked | Normal | Red accent |

---

## Metadata Schema

### Interactable Mesh Metadata

```typescript
mesh.metadata = {
  interactable: true,      // Flag for interaction system
  id: string,              // Unique identifier
  type: string,            // Interaction type
  data: {                  // Type-specific data
    title?: string,
    content?: string,
    locked?: boolean,
    keyId?: string,
    targetRoom?: string,
    targetFloor?: number,
    itemFound?: string,
  }
};
```

### Walkable Mesh Metadata

```typescript
floor.metadata = {
  walkable: true,
  roomId: string,
};
```

### Transition Mesh Metadata

```typescript
indicator.metadata = {
  transition: boolean,     // false if locked
  targetRoom: string,
  targetFloor: number,
  locked: boolean,
  keyId?: string,
};
```

---

## Adding New Interaction Types

### Step 1: Define Type

In `houseLayout.ts`, add to `Interactable['type']` union:
```typescript
type: 'painting' | 'switch' | 'mirror' | ... | 'new_type';
```

### Step 2: Create Geometry

In `SceneManager.createInteractables()`:
```typescript
case 'new_type':
  mesh = MeshBuilder.CreateSomething('new_type', {
    // dimensions
  }, this.scene);
  break;
```

### Step 3: Add Color

In `SceneManager.getInteractableColor()`:
```typescript
'new_type': new Color3(r, g, b),
```

### Step 4: Handle Interaction

In `Game.tsx handleInteraction()`:
```typescript
case 'new_type':
  setActiveInteraction({
    type: 'new_type',
    title: data?.title,
    content: data?.content,
  });
  // Additional logic
  break;
```

### Step 5: Style Overlay

In `Game.tsx` overlay render, handle any special styling for the new type.

---

## State Tracking

### Interaction History

```typescript
// Track in GameState
interactedObjects: string[];

// Update on interaction
setGameState(prev => ({
  ...prev,
  interactedObjects: prev.interactedObjects.includes(id) 
    ? prev.interactedObjects 
    : [...prev.interactedObjects, id]
}));
```

### Light Toggle State

```typescript
// Track in GameState
lightsToggled: Record<string, boolean>;

// Update on switch interaction
setGameState(prev => ({
  ...prev,
  lightsToggled: {
    ...prev.lightsToggled,
    [lightId]: !prev.lightsToggled[lightId]
  }
}));
```

### Inventory

```typescript
// Track in GameState
inventory: string[];

// Add item when found
if (data?.itemFound) {
  setGameState(prev => ({
    ...prev,
    inventory: [...prev.inventory, data.itemFound]
  }));
}
```
