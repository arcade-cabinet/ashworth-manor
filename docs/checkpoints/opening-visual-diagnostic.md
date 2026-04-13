# Opening Visual Diagnostic

## Purpose

This checkpoint records the first design-oriented read of the rebuilt opening
capture surface. The question is no longer only whether the opening journey
executes. The question is whether the captures are sufficient to judge if the
player experience is **right**.

## Evidence Reviewed

- renderer lane:
  `godot --path . --script test/e2e/test_opening_journey.gd`
- capture directory:
  `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/opening_journey/`
- contextual manifest:
  `/Users/jbogaty/Library/Application Support/Godot/app_userdata/Ashworth Manor/screenshots/opening_journey/opening_manifest.md`

## Verdict

The capture lane is now **sufficient for diagnosis**, and the opening visuals
have improved materially, but the opening is **still not yet fully acceptable**.

## Second Pass Update

After the latest opening-polish rerender:

- the gate sign and valise now read as one threshold composition instead of
  unrelated slab/menu objects
- the sign is smaller, more plausible, and less visually dominant in the first
  arrival frame
- the valise is now visibly present beneath the sign in the overview frame, so
  the player can understand that their luggage has been left there by the
  departing driver
- the lower-drive still fails the stricter review bar: it now reads as a guided
  approach, but the hedge masses remain too box-forward and too dark to sell
  well-maintained clipped estate hedges

## Third Pass Update

After the shared procedural hedge and threshold rebuild:

- the drive sides now read as continuous hedge-wall corridors rather than short
  repeated hedge stubs
- the family crypt first-person walkthrough framing defect is resolved in the
  broader debug audit
- the stray bright paper-like artifact around the sign/valise composition is
  mostly gone in the main opening and valise evidence frames

But the latest renderer pass is still **not yet acceptable** for two reasons:

- the hedge geometry is now structurally closer to the intended design, but the
  material language still reads too synthetic and under-detailed
- the dedicated outward-road frame is still failing to prove the social/world
  read beyond the gate; it remains the weakest and least truthful opening shot

So the opening threshold itself is markedly better. The remaining visual weak
point is the drive, especially the hedge language.

The difference matters:

- before this pass, the opening screenshots mostly proved that the route ran
- after this pass, the screenshots and manifest provide enough intent, pose, and
  state context to make a grounded player-experience judgment
- that judgment is currently negative for several opening compositions

## Primary Findings

### 1. Front-gate sign is now legible, but still slightly too menu-forward

The sign no longer reads as stacked black slabs. It is now readable as one
estate-side sign assembly, which is a major correction. The remaining problem is
finer-grained:

- it still feels somewhat like a game menu prop rather than a naturally attached
  estate notice surface
- the board text is brighter and clearer, but still slightly more assertive than
  the world around it

This is now a polish problem, not a total composition failure.

### 2. Valise embodiment is improved but still not fully persuasive

The valise now opens and behaves like a real object, which is correct. However,
the surrounding composition still does too little to make the player feel:

- this is my luggage
- the driver has just left it here
- opening it is a socially motivated necessity

The object itself is much better. The threshold composition around it is still
underperforming, and the current renderer-backed valise close study still does
not show the opened case as clearly as it should.

### 3. Hedge language is better but still wrong

The hedge-specific captures are improved: the masses now have topiary-like crown
shapes and some face variation. Even so, they still do not convincingly read as
clipped estate hedges with maintained face-work.

Current read:

- over-dark block masses on the shadow side
- too little color separation
- insufficient top and shoulder variation
- the silhouette still starts from box primitives rather than foliage first

### 4. Drive composition is improved, but still too sparse

The lower and upper drive captures answer the right questions, and the removal
of the bright repeated drive-stone plates was the correct move. The remaining
issue is that the approach still lacks enough estate layering to fully escape
the corridor feeling.

### 5. Mansion pull is clearer than the gate, but still visually sparse

The upper-drive and front-steps captures do a better job of expressing the
obligation to continue. The house now pulls the eye more effectively than the
gate sign does. Even so, the facade still risks reading as a lit placeholder
front rather than a fully authored Victorian threshold.

### 6. The outward-road evidence frame is still not trustworthy

The capture contract is good in principle, but the current outward-road pose is
still not giving a usable design verdict. It is too dominated by edge-of-sign /
backface noise and empty darkness to answer the question it was added to answer:

- can the player perceive that they begin outside the estate wall
- can they read a road / village-world orientation if they pivot away from the
  gate
- does the threshold communicate social arrival rather than abstract void

Until this frame is fixed, the opening evidence surface remains partially
honest rather than fully honest.

## Practical Result

The capture contract is now good enough to support visual design review.
The opening art/composition is not yet good enough to pass that review.

That is the correct state to be in: the evidence surface is honest.

## Immediate Fix Priorities

1. Recompose the sign/valise/drive relationship so the player understands why
   the valise must be opened.
2. Replace the current hedge material treatment with a more convincing clipped-
   hedge surface so the continuous corridor geometry does not read synthetic.
3. Fix the outward-road frame so the player-facing evidence actually proves the
   threshold is outside the wall and connected to a wider world.
4. Add more estate layering to the drive so the ceremonial approach feels
   cultivated rather than merely bounded.
5. Improve the dedicated valise evidence shot so reviewers can judge the opened
   luggage object directly.

## Fourth Pass Update

After the latest local-debug opening pass:

- the hedge corridor is now using the shared procedural wall builder with
  continuous full-length hedge rows on both sides; the earlier short-stub /
  perpendicular-segment bug is gone
- the outward-road shot no longer collapses into a pure void or dark portal;
  the road, verge dressing, and village lamp now read as an actual exterior
  continuation
- a dedicated sky probe and valise probe now exist in
  `test/e2e/test_front_gate_visual.gd`
- the valise is now visibly present in the dedicated sign-side evidence frame,
  which was not true before this pass

But the opening still does **not** clear final visual acceptance:

- the hedge walls now read as enclosing walls, which is correct, but they are
  still too synthetic and too smooth to sell stately clipped Victorian topiary
- the sky still fails the brief; moon presence is visible, but the stars and
  twilight nuance are still not reading strongly enough in captures
- the outward-road world read is improved but still too abstract and under-
  layered to feel like a nearby village road disappearing into fog

So the opening is now better instrumented and more truthful again. The
remaining work is no longer structural confusion. It is specific visual craft.

## Fifth Pass Update

The latest local-debug pass fixed two major truth-surface failures:

- the sky now reads as an actual night sky in the photographed corridor wedge;
  stars are visible in both the opening overview and the dedicated sky probe
- the front-gate probe lane now includes village-side left/right probes, so the
  outward world is no longer judged from one ambiguous straight-on frame

It also moved the opening composition materially closer to the brief:

- the valise remains clearly readable under the sign
- the gate-and-sign threshold now reads as one arrival composition instead of a
  broken menu prop cluster
- the outward-road side probes now show actual roadside architecture rather
  than only empty darkness

But the opening still does **not** pass final visual acceptance.

The remaining defects are narrower and more honest now:

- the hedge walls still do not read as finished clipped Victorian topiary;
  their enclosure logic is correct, but the face treatment is still too
  synthetic and too procedural-looking
- the outward-road world now reads as a road with cottages, but it is still
  too schematic and stagey to pass as a convincing nearby village approach
- the carriage-road material language is still too stark and planar in the
  captures, which keeps the whole threshold from achieving the intended Myst-
  like grounded richness

That is the correct current state: star readability is fixed, evidence coverage
is better, and the remaining work is now specific environmental craft rather
than missing fundamentals.

## Sixth Pass Update

The latest local-debug pass moved the *upper drive and front steps* materially
forward:

- the upper-drive mansion pull no longer collapses into a blank wall; the
  approach now reads as a real entrance with a visible portico silhouette and
  a darker central threshold
- the front-steps commit frame now has an actual procedural entry composition
  rather than the earlier wallpaper-like placeholder facade
- the hedge corridor has been simplified away from the over-dotted relief pass;
  it now reads more like a continuous enclosing wall and less like a patterned
  prop surface

The local debug verification surface is still green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --headless --path . --script test/e2e/test_room_walkthrough.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

But the opening still does **not** clear final visual acceptance.

The remaining defects are narrower and more truthful:

- the drive and front-steps entrance now read correctly at a macro level, but
  they are still too abstract and under-detailed to feel fully Myst-like and
  convincingly Victorian
- the hedge walls are no longer the worst offender, but they still need richer
  material craft and more natural clipped-face variation before they feel like
  finished topiary
- the carriage-road surface is still too banded and planar in the captures,
  which keeps the approach from feeling fully grounded
- the outward-road/village side remains schematic; it reads as an exterior
  continuation now, but not yet as a persuasive social world beyond the gate

So this pass fixed a real structural problem: the player can now read the house
pull at the end of the drive. What remains is environmental richness and final
craft, not missing architectural intent.

## Seventh Pass Update

The latest local-debug pass fixed two more structural exterior failures:

- the end of the drive now has a **visible closed front door** again; the
  threshold no longer collapses into a lit blank wall after the procedural
  entrance rebuild
- the gate-side outward road now carries a much stronger roadside settlement
  read because the village houses and terraces have been pulled materially
  closer to the carriage road

This pass also landed deeper procedural alignment:

- the front door is now a shared procedural scene instead of the old odd
  edge-on imported door prop
- the forecourt now includes procedural brick boundary-wall logic between the
  side gates and the house, which is closer to the intended estate layout
- the hedge walls have had another geometry pass to reduce the worst horizontal
  banding and flatten the clipped-wall silhouette

Local debug verification remains green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

But the opening still does **not** clear final visual acceptance.

The remaining defects are now narrower and more specific:

- the outward-road side is no longer a void and no longer feels disconnected
  from a village-world, but it still reads too schematic and blocky to count
  as fully persuasive Victorian roadside architecture
- the hedge corridors are structurally correct and more wall-like, but still
  too smooth and synthetic to feel like finished clipped topiary
- the upper-drive and front-steps entrance finally read as a real destination,
  but the facade composition is still too austere and under-articulated to
  feel fully authored and production-rich

So this pass made the opening **more truthful again**: the player can now read
both a real house entrance and a real world beyond the gate. What remains is
craft, richness, and final surface credibility.

## Eighth Pass Update

The latest debug-only exterior pass tightened the two dominant opening reads:

- the hedge walls no longer artifact into obvious dark panel rows; the drive
  now reads as a continuous clipped corridor again
- the front-steps commitment frame now has a lighter, more architectural door
  surround, so the threshold reads as a real stone-framed entrance rather than
  dark wood floating inside a flat wall

This pass also corrected a shared-systems issue:

- `PBRTextureKit` now supports explicit opacity-map composition for alpha-cut
  materials
- `EstateMaterialKit` now wires the hedge atlas opacity path explicitly
- this does not yet produce a final hedge-card look, but it closes a real gap
  in the shared PBR pipeline instead of leaving foliage transparency as dead
  configuration

Local debug verification remains green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

The remaining truth is now more specific:

- the hedge corridor is structurally right again, but still too smooth and
  under-varied to count as finished clipped Victorian topiary
- the commitment frame is better, but the portico/facade still read as too
  austere and low-detail for final production richness
- the drive surface is still too planar and broad-toned in the captures

So this pass removed another false read from the opening. The house approach is
clearer and less broken, but still not yet fully art-complete.

## Ninth Pass Update

The next shared procedural pass improved the opening at both the macro and
meso level:

- the facade now carries more readable architectural relief in the drive pull:
  stronger plinth/cornice logic, a more legible central projection, and a
  clearer door-zone wall composition
- the front-steps commitment frame now reads as a proper stone-framed entrance
  set into a more articulated wall instead of a near-flat backdrop
- the drive surface no longer has the failed bright gravel-dot read from the
  previous experiment; that artifact was replaced with darker shoulder wear

Local debug verification remains green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

The remaining defects are now narrower:

- the hedge corridor is structurally right and no longer artifacting, but the
  surface still needs more believable clipped-topiary richness
- the road still reads too broad and smooth, even after the latest wear pass
- the facade is less austere than before, but still not yet at the level of
  final Victorian/Myst-like craft

So this pass moved the opening away from blockout and further into authored
space, but it still does not clear final visual acceptance.

## Tenth Pass Update

The latest shared-systems pass replaced more of the opening's mismatched model
language with reusable procedural work:

- the front gate now uses shared procedural gate posts instead of unrelated
  pillar props
- the forecourt side gates now use shared procedural gate posts and iron fence
  runs instead of crypt-specific columns and fence models
- the family-crypt and garden gate columns were also moved onto the new shared
  gate-post surface, so the reusable gate vocabulary is no longer confined to
  one room
- the iron-gate builder now has more readable threshold/latch/strap detail,
  which makes the gates feel more like authored estate ironwork and less like
  bare bar frames
- the hedge wall got a denser face-frond pass through the shared builder
  instead of one-off prop clutter
- the shared boundary-wall builder now carries more relief and coping detail,
  which helps the front-gate and forecourt masonry stop reading as flat brick
  slabs

Verification widened cleanly after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`
- `godot --headless --path . --script test/e2e/test_room_walkthrough.gd`
- `godot --headless --path . --script test/e2e/test_full_playthrough.gd`

That matters because this was no longer just an opening-only art tweak. Shared
runtime surfaces changed, and the broader critical-path debug lanes still held.

The opening still does **not** clear final visual acceptance yet.

The remaining defects are now the familiar final-craft issues:

- the hedge corridor is richer and structurally correct, but the face still
  reads too synthetic and too procedurally even to count as finished clipped
  Victorian topiary
- the carriage road is less broken, but still too broad and smooth-toned in
  the captures
- the outward-road village is no longer void-like, but still too schematic to
  feel like a persuasive nearby settlement
- the house pull is materially stronger, but the facade/forecourt still need
  more final richness before the approach feels truly production-finished

So this pass was real progress: more of the opening is now on the intended
shared procedural language, and the repo stayed green. What remains is not
structural incoherence. It is final surface craft.

## Eleventh Pass Update

The next local-debug pass moved the opening further away from the washed,
placeholder look and into an authored night approach:

- the opening exterior now uses selected repo-local PBR source sets for hedge
  mass, carriage road, verge earth, and boundary brick through
  `EstateMaterialKit`, rather than relying entirely on the older placeholder
  exterior surfaces
- the grounds environment no longer depends on the HDRI blend path; the
  authored twilight/moon/star sky is now generated directly, which also removed
  the repeated HDR header warnings from the opening visual lanes
- the front gate and drive moonlight/ambient wash were reduced substantially,
  so the warm lamps and door-pull now read as the dominant light anchors
- the hedge corridor now has explicit clipped-bay/pilaster articulation through
  the shared `estate_hedgerow.gd` builder, so the drive reads more like a
  formal topiary wall than a plain green slab
- the front-gate outward road now has real authored village lamp spill in room
  space instead of relying only on emissive props

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`

This pass did fix several real defects:

- the opening is no longer washed out by sky ambient and strong moon fill
- the drive hedge walls now read as deliberate clipped-wall architecture in the
  hedge-side probes
- the outward road has stronger warm light anchors and no longer depends on the
  HDRI path for exterior sky

The opening still does **not** clear final visual acceptance.

The remaining blockers are now more specific:

- the hedge corridor is stronger, but the new bay rhythm is still too even and
  mechanical; it needs more variation and softer craft to feel like finished
  Victorian topiary rather than repeated panels
- the drive surface is darker and less broken, but still too plain and broad in
  the forward captures
- the outward-road village is more legible, but still too schematic and does
  not yet sell the “nearby foggy village road” fantasy strongly enough
- the authored twilight is cleaner in the sky system, but the visible dusk band
  is still subtler than intended in the outward-looking frames

So this pass materially improved the opening’s shared systems, lighting logic,
and hedge-wall read. What remains is the final layer of visual craft and
variation, not a broken runtime surface.

## Twelfth Pass Update

The latest local-debug pass attacked the remaining declaration- and
builder-level repetition directly instead of only tinting around it:

- `drive_lower.tres` and `drive_upper.tres` now stop stacking multiple giant
  hedge-row instances on each side of the drive; the corridor is carried by one
  continuous hedge wall per side instead of several overlapping rows
- `estate_hedgerow.gd` no longer stamps hard face pilasters into the hedge
  surface; the face detail is now softer clipped relief, which removed the most
  obvious vertical seam rhythm in the hedge-side probe
- `estate_outward_road.gd` now uses pitched roof silhouettes for the nearby
  village houses instead of only flat-lidded box forms, which materially
  improves the outward-road read
- `front_gate_menu_sign.gd` now presents the menu as one estate directory board
  with inset brass plates rather than three separate hanging placards
- the generated sky path was retuned in `grounds.tres` and `psx_bridge.gd` so
  the moon is smaller and the twilight band is carried more by the horizon than
  by raw ambient wash

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`

This pass fixed real defects:

- the worst overlapping hedge seam cues are gone from the drive corridor
- the front-gate sign now reads more like one estate-side notice structure than
  a cluster of menu placards
- the outward road is less box-town-flat because the closest houses now have
  actual roof profiles

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the hedge walls are structurally more honest now, but they still read too
  smooth and too synthetic to count as finished clipped Victorian topiary
- the outward-road village is improved, but still too schematic and regular to
  feel like a persuasive nearby settlement
- the generated twilight is closer in intent, but it still is not fully right:
  the horizon band is present, yet the overall sky remains too stylized and not
  subtle enough in the upward and outward probes
- the drive road remains too plain and broad-toned in the forward approach

So the opening is moving in the right direction, and the changes are now
showing up in the actual probe frames. But this is still a live polish front,
not a finished threshold.

## Thirteenth Pass Update

The next local-debug pass corrected two more concrete opening problems and also
proved one dead end:

- the bogus pale road slabs in the outward-road probes were not lighting or fog
  issues; they were live `floor3.glb` leftovers still authored into
  `front_gate.tres`, and they have now been removed from the active prop list
- the outward-road village materials were retuned darker and warmer, so the
  houses now read more like shadowed Victorian brick and less like pale
  placeholder boxes with glowing windows
- the roadside poplar silhouettes were simplified away from the stacked
  three-ball read into taller continuous crowns, which improves the village-side
  skyline
- the drive rooms and front steps now use earth as the base room floor again,
  so the carriage-road prop is not fighting an all-gravel full-room floorbed

This pass also surfaced an important negative result:

- multiple new hedge-form experiments were tried and rejected in renderer
  probes; both the spotted relief pass and the stacked-body-chain pass made the
  drive read *more* artificial, so `estate_hedgerow.gd` was explicitly returned
  to the smoother baseline instead of pretending the experiments were progress

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

This pass fixed real defects:

- the outward-road probes no longer contain the large pale slab artifacts
- the village-side read is darker, warmer, and less toy-white than before
- the opening journey still runs cleanly after the front-gate and drive changes

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the hedge corridor is still the weakest surface in the opening; it remains
  too smooth and too synthetic, and the attempted fixes in this pass did not
  solve it
- the outward-road village is better after the material and silhouette pass,
  but it still reads too schematic to fully sell a nearby foggy settlement
- the twilight sky is directionally better than earlier in development, but it
  still feels too stylized and not subtle enough in the outward-facing probes
- the drive lane is cleaner than before, but still needs more final carriage-
  road craft to stop reading as a simplified strip between walls

So this pass made the opening more honest again: a real road artifact is gone,
the outside world reads better, and the repo stayed green. The hedge remains
the unresolved opening blocker.

## Fourteenth Pass Update

This pass corrected one real structural hedge problem, improved the moon/star
read, and also ruled out two more false solutions:

- `drive_lower.tres` and `drive_upper.tres` now use multiple smaller
  `estate_hedgerow` runs per side instead of relying on a single giant
  stretched hedge instance; this makes the drive composition more consistent
  with the intended contiguous hedge-wall approach
- `estate_hedgerow.gd` now allows shorter hedge runs, so the declaration layer
  can actually author hedge rhythm instead of stretching one procedural module
  across an entire room span
- `grounds.tres` and `psx_bridge.gd` were retuned so the grounds sky is cooler,
  stars read cleanly, and the moon finally appears as a credible exterior
  anchor rather than being lost in the old muddy-red sky treatment

Two hedge-surface attempts in this pass were explicitly rejected after
renderer review:

- a clipped face-panel layer made the drive read like paneled masonry instead
  of topiary and was backed out
- a face-card veneer created a row of dark pasted rectangles near the crown and
  was also backed out

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

This pass fixed real defects:

- the drive hedge authoring is less brittle because it no longer depends on one
  oversized stretched row per side
- the gate-sky probe now clearly shows stars and a moon
- the opening journey still runs cleanly through front gate, drive, forecourt,
  foyer, parlor, kitchen, and the basement fall after the exterior changes

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the hedge corridor is structurally better but still too smooth and synthetic;
  the real remaining problem is surface richness, not just hedge placement
- the outward-road village remains too schematic and under-layered to fully
  sell a nearby foggy settlement
- the sky is cooler and more coherent than before, but the twilight band is
  still too faint in outward-looking frames
- the drive road still reads too plain in the forward approach

So this pass improved the opening honestly: the hedge layout is less wrong, the
moon/stars now read, and the repo stayed green. But the hedge surface and the
outward-road craft remain live polish fronts.

## Fifteenth Pass Update

This pass improved the two other live opening blockers beyond the hedge:

- `estate_carriage_road.gd` now uses a clearer lane-versus-track material split
  plus small gravel patches, so the drive no longer reads as one completely
  undifferentiated dark strip in the forward probes
- `estate_outward_road.gd` now has deeper lamp progression, additional distant
  terrace layers, an extra horizon road segment, and more layered fog banks so
  the village-side road has better depth than before

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

This pass fixed real defects:

- the carriage road is more legible as a worn twin-track surface
- the outward-road probe now has stronger road detail and more settlement depth
  than the previous flatter pass
- the full opening critical path still runs cleanly after the exterior builder
  changes

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the hedge corridor still reads too smooth and synthetic; the core remaining
  issue is hedge-surface craft, not hedge placement
- the outward-road horizon is more layered, but the final foggy dusk terminus
  is still too faint and under-persuasive
- the village remains more credible than before, but still slightly schematic
  at distance
- the sky is improved from earlier muddy-red passes, but still needs a more
  convincing twilight band in outward-facing frames

So this pass materially improved both the drive surface and the village road,
but the opening threshold is still a live polish front rather than a finished
production scene.

## Sixteenth Pass Update

This pass focused on two things that were still materially wrong in the
opening: the hedge corridor still reading like built walling, and the gate
review surface still hiding the sign/valise cluster behind context.

What changed:

- `estate_material_kit.gd` and `estate_hedgerow.gd` were reworked so the drive
  hedges are back on dense foliage mass rather than a leaf-sheet wall; the
  builder now relies on dark clipped mass and broader shaping instead of the
  rejected panel/card tricks
- the brightest hedge shoulder/crown reads were pulled back so the drive no
  longer looks like a plaster cornice with a green base
- `test_front_gate_visual.gd` now emits dedicated sign and valise detail probes
  in addition to the contextual gate probes, which is a better review surface
  for whether the opening interaction cluster is actually legible
- an attempted sign-cluster layout shift in `front_gate.tres` was explicitly
  backed out after renderer review because it made the sign read worse, not
  better
- `grounds.tres` and `psx_bridge.gd` were both retuned again to widen the dusk
  band and soften the moon, but the resulting gain in the gate probes was only
  marginal

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

This pass fixed real defects:

- the hedge corridor now reads much more like a dark clipped wall and much less
  like assembled green masonry
- the gate evidence surface is stronger because the repo now captures close
  sign/valise review shots instead of only the wider occluded contextual shot
- the failed sign-layout detour was identified and reverted instead of being
  left behind as silent regression

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the outward-road sky is still too hard black-purple; the dusk terminus is
  still not carrying enough twilight atmosphere
- the outward-road village remains too schematic despite the added depth and
  lamps
- the sign/valise cluster is now better documented, but the contextual sign
  view is still partially stolen by the gate leaf and the close probes are
  still a bit wall-heavy
- the hedge corridor is materially better than before, but it still needs more
  final surface richness before it feels fully production-finished

So this pass materially improved the hedge language and the review surface, but
the front-gate sky/village read and the final sign-cluster composition are
still live polish fronts.

## Seventeenth Pass Update

This pass corrected a real regression in the drive corridor and pushed the
debug evidence surface forward again.

What changed:

- `drive_lower.tres` and `drive_upper.tres` were simplified back toward
  continuous hedge runs per side instead of the more segmented hedge cadence;
  the corridor now reads as two longer clipped walls again instead of a chain
  of visible hedge modules
- `estate_hedgerow.gd` was restored away from the failed embossed/paneled
  experiments; the current hedge builder is back on the cleaner clipped-mass
  profile with darker foliage tones
- `grounds.tres` and `psx_bridge.gd` were pushed further in an attempt to
  isolate the sky problem by removing the HDRI from the grounds environment and
  forcing a cooler authored twilight gradient

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`

This pass fixed real defects:

- the drive corridor no longer reads like segmented green wall-panelling; it
  is back to continuous hedge rows framing the approach
- the worst visible hedge seam rhythm was removed from the lower and upper
  drive authoring
- the repo now has a clearer honest result on the sky: several more authored
  sky changes were tried, and the gate probes prove they are still not moving
  enough

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the hedge corridor is structurally closer now, but the hedge face itself is
  still too smooth and synthetic in close probes
- the front-gate sky is still reading as a hard maroon-black dome with stars
  and moon on top, rather than a convincing twilight atmosphere
- the outward-road village is more place-like than before, but still too
  schematic and under-authored at distance
- the contextual sign/valise opening composition still is not yet final

So this pass removed the wrong segmented/paneled hedge answer and restored the
drive to a more honest continuous-wall read, but the sky remains the clearest
live blocker in the opening frames.

## Eighteenth Pass Update

This pass replaced key opening materials with photoreal PBR sources and pushed
the sky/village composition further toward the intended read.

What changed:

- `estate_material_kit.gd` now points the hedge wall at a denser photoreal
  grass material and the carriage road at a coarser gravel material copied in
  from `/Volumes/home/assets/2DPhotorealistic`; both materials were retuned
  for stronger normals and less dead-flat roughness
- `grounds.tres`, `estate_starfield.gd`, `room_assembler.gd`, and
  `front_gate.tres` were retuned together so the opening sky keeps the cooler
  authored-night treatment, but with a smaller moon, more visible stars, and a
  less pasted-looking moon disc between the hedge walls
- `estate_outward_road.gd` was pushed further so the nearby village frontage
  sits closer to the road, windows and lane lamps read more strongly, and the
  outward probe no longer feels like an almost featureless dark block
- `estate_carriage_road.gd` and `estate_hedgerow.gd` were both revised again:
  the road now has clearer wheel-lane logic, while the hedge builder tried a
  stronger organic face-relief pass

Verification stayed green after this pass:

- `godot --headless --path . --script test/generated/test_declarations.gd`
- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`
- `godot --path . --script test/e2e/test_opening_journey.gd`

This pass fixed real defects:

- the front-gate sky no longer reads like the old maroon-black dome; the sky
  probe now has a smaller moon and a more convincing star field
- the outward-road frame now reads more clearly as a nearby lamplit village
  road rather than a near-empty silhouette corridor
- the shared opening materials are now using better photoreal PBR inputs
  instead of depending only on the previous flatter placeholder set

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the hedge face is still too smooth and synthetic in the close drive probe,
  even after the denser material swap and the additional face-relief pass
- the drive floor has better lane logic now, but it still needs richer final
  craft before it feels fully authored instead of broadly blocked in
- the outward-road village is clearer than before, but it still remains more
  schematic than fully persuasive Victorian settlement detail
- the contextual sign/valise frame is improved by the stronger sky, but the
  opening composition as a whole is still not final

So this pass materially improved the sky and outward-road read and moved the
opening onto better PBR sources, but the hedge wall close-up remains the
clearest live visual defect.

## Nineteenth Pass Update

This pass stayed on the hedge wall and corrected a real sculpting mistake in
the previous iteration.

What changed:

- the shared hedge material in `estate_material_kit.gd` was pushed again so
  the wall mass uses stronger normal response and a larger visible foliage
  scale in shadow
- `estate_hedgerow.gd` was corrected after the first relief pass exposed a bad
  implementation detail: most of the earlier face relief had been living
  inside the wall volume, which is why the close probe kept reading as a flat
  slab
- after moving the relief outward, a follow-up pass backed away from the most
  obvious bead/button artifacts and softened the hedge cross-section so it
  reads less like masonry moulding and more like clipped mass

Verification stayed green on the focused visual lanes:

- `godot --path . --script test/e2e/test_front_gate_visual.gd`
- `godot --path . --script test/e2e/test_drive_visual.gd`

This pass fixed real defects:

- the drive hedge close-up no longer reads as a perfectly flat painted wall
- the worst circular button artifacts from the first outward-relief attempt
  were removed
- the corridor keeps the improved sky and outward-road gains from the previous
  pass while the hedge wall itself is less false than before

The opening still does **not** clear final visual acceptance.

Current remaining blockers:

- the hedge face is improved again, but it is still too smooth and too clean
  to fully sell stately clipped Victorian topiary in the closest drive probe
- the drive floor still needs richer authored craft even though its wheel-lane
  logic is now clearer
- the outward-road village is clearer than before, but it still remains a
  stylized schematic read rather than a fully persuasive distant settlement

So this pass corrected the flawed hedge-relief implementation and left the wall
better than the earlier flat slab and better than the later buttoned version,
but the hedge close-up is still the main remaining lie in the opening.
