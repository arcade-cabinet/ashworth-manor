# Grand Foyer — Props (Non-Interactable)

## Structural Grammar

The foyer is no longer a hand-placed scene stack. It is a procedural room shell with:

- procedural walls, floor, ceiling, and stair run
- inset trim/models for doorway framing, balcony fascia, pillars, and moulding
- visible light-source props layered on top of the shell

The staircase is authored as a procedural threshold assembly sized from the `foyer <-> upper_hallway` connection, not as a single fixed stair mesh.

## Furniture & Decor

| Name | GLB | Position | Notes |
|------|-----|----------|-------|
| Chandelier | `shared/decor/chandelier.glb` | (0, 3.98, 0) | Lowered so the light source actually reads in the entry frame |
| Rug | `shared/decor/rug0.glb` | (0, 0.01, 0) | Persian rug, center |
| Entry runner | `shared/decor/rug2.glb` | (0, 0.02, -2.1) | Pulls the eye inward from the front door |
| North runner | `shared/decor/rug1.glb` | (0, 0.02, 2.1) | Extends the formal axis toward stairs/parlor |
| Portrait frame | `shared/decor/picture_blank.glb` | (0, 2.5, -4.5) | For `foyer_painting` on the south wall |
| Candle holders | `shared/decor/candle_holder.glb` | west/east south wall + north wall pair | Visible physical sources for foyer candle light |
| Drawers | `shared/furniture/drawers.glb` | (-5, 0, -4) | Hall table (mail on top) |
| Drawers (east) | `shared/furniture/drawers.glb` | (4.95, 0, -1.45) | Brought forward so the dining side no longer reads as dead void on entry |
| Coat stand | `ground_floor/foyer/stand_mx_1.glb` | (4.7, 0, 0.65) | Keeps the dining branch dressed without overpowering the stair pull |
| Package | `ground_floor/foyer/package_hr_1.glb` | (4.1, 0, -3.6) | Near clock table, slight recent-arrival disorder |
| Wall map | `ground_floor/foyer/map_mx_1.glb` | (-5, 1.5, 4) | Decorative map |
| East wall picture | `shared/decor/picture_blank_001.glb` | (5, 1.75, -1.1) | Helps break the right-side wall blankness on entry |
| Table lamp | `ground_floor/foyer/lamp_mx_1_a_on.glb` | (-5, 0.8, -3) | On west drawers, visible source for warm table light |
| Table lamp (east) | `ground_floor/foyer/lamp_mx_1_a_on.glb` | (4.95, 0.8, -1.4) | Softens the dining branch and keeps the foyer asymmetry intentional |
| North doorway frame | `mansion_psx/models/SM_Door_Frame.glb` | (0, 0, 4.95) | Formalizes the far wall aperture beyond the stair pull |
| East doorway frame | `mansion_psx/models/SM_Door_Frame.glb` | (5.88, 0, 0.25) | Converts the dining-side opening from a raw cutout into a proper branch |
| West doorway frame | `mansion_psx/models/SM_Door_Frame.glb` | (-5.88, 0, 0.25) | Matches the dining-side branch and supports a more believable hall shell |
| North wall columns | `mansion_psx/models/SM_Wall_Column.glb` | (-1.5, 0, 4.88), (1.5, 0, 4.88) | Break up the far wall mass behind the stair reveal |
| Upper friezes | `mansion_psx/models/SM_Big_Wall_Molding.glb` | north wall upper band | Keeps the upper volume from reading as a plain box |
