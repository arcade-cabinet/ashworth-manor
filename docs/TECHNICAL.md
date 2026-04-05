# Technical Guide

This document covers the technical implementation details, Babylon.js usage, and performance considerations.

## Technology Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Engine | Babylon.js | 9.1.0 |
| Framework | React | 19.x |
| Language | TypeScript | 5.7.x |
| Styling | Tailwind CSS | 4.x |
| Animation | Framer Motion | 12.x |
| Build | Vite | 6.x |

## Babylon.js Implementation

### Engine Configuration

```typescript
this.engine = new Engine(canvas, true, {
  preserveDrawingBuffer: true,  // Screenshot capability
  stencil: true,                // Stencil buffer for effects
  antialias: true,              // Smooth edges
});
```

**Mobile Considerations**:
- `preserveDrawingBuffer` has slight performance cost but enables screenshots
- Antialiasing is critical for thin lines (trim, door frames)
- Stencil buffer used by post-processing pipeline

### Scene Setup

```typescript
this.scene = new Scene(this.engine);
this.scene.clearColor = new Color4(0.02, 0.01, 0.02, 1);
this.scene.ambientColor = new Color3(0.08, 0.03, 0.03);
this.scene.fogMode = Scene.FOGMODE_EXP2;
this.scene.fogDensity = 0.015;
this.scene.fogColor = new Color3(0.05, 0.02, 0.02);
```

**Why EXP2 Fog**: Exponential squared fog creates more natural falloff than linear, especially important for the moody atmosphere.

### Camera System

```typescript
this.camera = new UniversalCamera('camera', new Vector3(0, 1.7, -5), this.scene);
this.camera.minZ = 0.1;    // Near plane for close objects
this.camera.maxZ = 100;    // Far plane (rooms are small)
this.camera.fov = 0.9;     // Slightly wide for mobile
this.camera.inputs.clear(); // Remove default inputs
```

**Why UniversalCamera**: 
- Simpler than ArcRotateCamera for first-person
- Easy to control position and rotation directly
- Better for tap-to-walk pattern

### Render Loop

```typescript
this.engine.runRenderLoop(() => {
  this.update();          // Game logic
  this.scene.render();    // Babylon rendering
});
```

**update() handles**:
- Player movement interpolation
- Light flickering updates
- Any per-frame game logic

---

## Lighting System

### Light Types Used

| Babylon Type | Game Usage | Shadows |
|--------------|------------|---------|
| HemisphericLight | Base ambient | No |
| PointLight | Candles, sconces | Selective |
| SpotLight | Windows (directional) | No |

### Hemisphere Light (Global Ambient)

```typescript
const hemiLight = new HemisphericLight('hemi', new Vector3(0, 1, 0), this.scene);
hemiLight.intensity = 0.08;  // Very dim
hemiLight.diffuse = new Color3(0.4, 0.25, 0.2);
hemiLight.groundColor = new Color3(0.1, 0.05, 0.05);
```

This provides baseline visibility without visible source—kept very low.

### Point Lights (Room Sources)

```typescript
const pointLight = new PointLight('light', position, this.scene);
pointLight.intensity = 0.6;
pointLight.range = 8;  // Light falloff distance
pointLight.diffuse = new Color3(1, 0.7, 0.4);
```

### Shadow Generation

```typescript
const shadowGen = new ShadowGenerator(512, pointLight);
shadowGen.useBlurExponentialShadowMap = true;
shadowGen.blurKernel = 32;
shadowGen.darkness = 0.5;
```

**Performance Note**: Shadow generators are expensive. Only applied to:
- Chandeliers (key room lights)
- Fireplaces (dramatic shadows)

Limited to 512x512 shadow maps for mobile performance.

### Flickering Implementation

```typescript
private updateFlickeringLights(): void {
  const time = performance.now() / 1000;
  
  this.lightSources.forEach((light) => {
    if (light.metadata?.flickering) {
      const baseIntensity = light.metadata.baseIntensity;
      const flicker = 
        Math.sin(time * 8 + Math.random() * 0.1) * 0.15 +
        Math.sin(time * 13) * 0.1 +
        Math.random() * 0.05;
      light.intensity = baseIntensity * (0.85 + flicker);
    }
  });
}
```

Uses multiple sine waves plus noise for organic feel.

---

## Post-Processing Pipeline

```typescript
const pipeline = new DefaultRenderingPipeline(
  'defaultPipeline',
  true,
  this.scene,
  [this.camera]
);

// Bloom - Light glow
pipeline.bloomEnabled = true;
pipeline.bloomThreshold = 0.7;
pipeline.bloomWeight = 0.3;
pipeline.bloomKernel = 64;
pipeline.bloomScale = 0.5;

// Chromatic Aberration - Unease
pipeline.chromaticAberrationEnabled = true;
pipeline.chromaticAberration.aberrationAmount = 15;

// Vignette - Focus
pipeline.imageProcessingEnabled = true;
pipeline.imageProcessing.vignetteEnabled = true;
pipeline.imageProcessing.vignetteWeight = 2;
pipeline.imageProcessing.vignetteColor = new Color4(0.1, 0.02, 0.02, 1);

// Color Grading
pipeline.imageProcessing.colorCurvesEnabled = true;
pipeline.imageProcessing.colorCurves.globalSaturation = 80;
pipeline.imageProcessing.colorCurves.shadowsHue = 0;
pipeline.imageProcessing.colorCurves.shadowsSaturation = 30;

// Film Grain
pipeline.grainEnabled = true;
pipeline.grain.intensity = 8;
pipeline.grain.animated = true;
```

---

## Mesh Generation

### Room Geometry

Rooms are built from simple primitives:

```typescript
// Floor
const floor = MeshBuilder.CreateGround('floor', { 
  width, 
  height: depth 
}, this.scene);

// Walls
const wall = MeshBuilder.CreatePlane('wall', { 
  width, 
  height 
}, this.scene);

// Architectural trim
const baseboard = MeshBuilder.CreateBox('baseboard', {
  width: wallLength,
  height: 0.15,
  depth: 0.05
}, this.scene);
```

**Why Primitives**: 
- Minimal draw calls
- Low poly count for mobile
- Fast to generate procedurally
- Easy to dispose and recreate

### Material System

```typescript
private createMaterial(textureName: string, emissiveLevel: number, specularLevel: number): StandardMaterial {
  const mat = new StandardMaterial(`mat_${textureName}`, this.scene);
  
  const baseColor = colorMap[textureName] || defaultColor;
  mat.diffuseColor = baseColor;
  mat.specularColor = new Color3(specularLevel, specularLevel * 0.8, specularLevel * 0.6);
  mat.emissiveColor = baseColor.scale(emissiveLevel);
  mat.specularPower = 32;
  
  return mat;
}
```

**Why StandardMaterial over PBR**:
- Better mobile performance
- Simpler to configure
- Sufficient for stylized look
- Lower memory usage

---

## Input Handling

### Touch Detection

```typescript
let touchStartX = 0;
let touchStartY = 0;
let touchStartTime = 0;
let isSwiping = false;
const TAP_THRESHOLD = 15;      // pixels
const TAP_TIME_THRESHOLD = 300; // ms

canvas.addEventListener('touchstart', (e) => {
  touchStartX = e.touches[0].clientX;
  touchStartY = e.touches[0].clientY;
  touchStartTime = Date.now();
  isSwiping = false;
}, { passive: true });

canvas.addEventListener('touchmove', (e) => {
  const deltaX = e.touches[0].clientX - touchStartX;
  const deltaY = e.touches[0].clientY - touchStartY;
  
  if (Math.abs(deltaX) > TAP_THRESHOLD || Math.abs(deltaY) > TAP_THRESHOLD) {
    isSwiping = true;
    handleSwipe(deltaX, deltaY);
  }
}, { passive: true });

canvas.addEventListener('touchend', (e) => {
  const touchDuration = Date.now() - touchStartTime;
  
  if (!isSwiping && touchDuration < TAP_TIME_THRESHOLD) {
    handleTap(e.changedTouches[0].clientX, e.changedTouches[0].clientY);
  }
});
```

### Ray Picking

```typescript
const handleTap = (x: number, y: number) => {
  const pickResult = this.scene.pick(x, y);
  
  if (pickResult?.hit && pickResult.pickedMesh) {
    const mesh = pickResult.pickedMesh;
    
    if (mesh.metadata?.interactable) {
      this.handleInteraction(mesh.metadata.id, mesh.metadata.type);
    }
    
    if (mesh.metadata?.walkable && pickResult.pickedPoint) {
      this.walkTo(pickResult.pickedPoint);
    }
  }
};
```

---

## Memory Management

### Room Transitions

```typescript
private clearCurrentRoom(): void {
  // Dispose room meshes
  this.roomMeshes.forEach((meshes) => {
    meshes.forEach(mesh => mesh.dispose());
  });
  this.roomMeshes.clear();
  
  // Dispose interactables
  this.interactableMeshes.forEach((mesh) => mesh.dispose());
  this.interactableMeshes.clear();
  
  // Dispose lights
  this.lightSources.forEach((light) => light.dispose());
  this.lightSources.clear();
  
  // Clear shadow generators
  this.shadowGenerators.forEach(sg => sg.dispose());
  this.shadowGenerators = [];
}
```

### Component Cleanup

```typescript
// In Game.tsx useEffect
useEffect(() => {
  const sceneManager = new SceneManager(canvasRef.current);
  sceneManagerRef.current = sceneManager;
  
  return () => {
    sceneManager.dispose();  // Full cleanup
  };
}, []);
```

---

## Performance Optimizations

### Current Optimizations

1. **Single Room Rendering**: Only active room meshes exist
2. **Limited Shadows**: Max 2 shadow generators per room
3. **StandardMaterial**: No PBR overhead
4. **Simple Geometry**: Boxes and planes only
5. **Texture Caching**: TextureGenerator reuses textures
6. **Passive Event Listeners**: Touch events marked passive

### Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| Frame Rate | 60 fps | ~60 fps |
| Draw Calls | <50 per room | ~30 |
| Memory | <100MB | ~80MB |
| Load Time | <3s | ~2s |

### Future Optimizations

1. **Mesh Instancing**: Repeated elements (trim, candles)
2. **LOD System**: Simplified distant objects
3. **Texture Atlasing**: Reduce material switches
4. **Occlusion Culling**: Hide objects behind walls
5. **Web Workers**: Offload room generation

---

## Build Configuration

### Vite Config

```typescript
// vite.config.ts
export default defineConfig({
  plugins: [react()],
  build: {
    target: 'esnext',
    minify: 'terser',
  },
  optimizeDeps: {
    include: ['@babylonjs/core', '@babylonjs/loaders'],
  },
});
```

### TypeScript Config

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "strict": true,
    "skipLibCheck": true
  }
}
```

---

## Debugging

### Babylon.js Inspector

```typescript
// Add temporarily to SceneManager constructor
this.scene.debugLayer.show();
```

### Performance Monitoring

```typescript
// Log frame time
this.engine.runRenderLoop(() => {
  const start = performance.now();
  this.scene.render();
  console.log(`Frame: ${performance.now() - start}ms`);
});
```

### Mesh Inspection

```typescript
// Log all meshes
this.scene.meshes.forEach(m => {
  console.log(m.name, m.getTotalVertices());
});
```
