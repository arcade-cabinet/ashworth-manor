# Visual Acceptance Rubric

## Purpose

Ashworth Manor screenshots are not only evidence that a flow executes. They are
evidence that the player experience is **right**.

Every renderer-backed capture lane should answer:

- what the player is supposed to notice
- why the player would do the next thing diegetically
- whether click-anywhere movement still feels spatially and socially coherent
- whether the room composition expresses the canon rather than merely rendering

If a screenshot only proves that a test passed, it is an incomplete acceptance
surface.

## Required Questions For Any Review Frame

For every captured screenshot, ask:

1. What is the player meant to notice first?
2. What next action does the space imply without a floating UI instruction?
3. Does the composition support click-anywhere movement, or does it only work
   because the tester knows the hotspot?
4. Are the important objects readable as *the things they are meant to be*?
5. Does the lighting feel physically and narratively justified?
6. Does the frame preserve the social and architectural truth of the space?
7. If this were shown without code context, could someone make a grounded
   judgment about whether the design intent landed?

## What A Screenshot Must Carry

A good acceptance screenshot needs more than a filename.

It should be accompanied by:

- room id
- player pose or approximate local position
- yaw and pitch
- current tool/light phase where relevant
- key state context when relevant
- the purpose of the shot
- the questions the shot is meant to answer

Without that context, screenshots drift into vague mood boards or bug proof.

## Opening-Sequence Specific Questions

### Front Gate

- Does the first frame read as an estate threshold rather than a menu set?
- Does the sign read as one coherent estate signpost?
- Does the valise clearly belong to the arriving player?
- Is the drive open enough that the player feels free to walk, even though the
  valise remains the obvious first obligation?

### Packet And Valise

- Is the reason for opening the valise socially legible?
- Does the lack of a greeting make the player want confirmation of locale?
- Does opening the valise feel embodied rather than like loot presentation?

### Lower And Upper Drive

- Do the hedges read as clipped estate hedges rather than black walls?
- Does the drive suggest disciplined approach and classed privacy?
- Does the mansion pull the eye naturally without becoming a false beacon?

### Forecourt And Foyer

- Do the front steps widen the estate without confusing the player’s duty?
- Does the foyer feel dark by design, not dark by omission?
- Is the next likely movement path clear without coercion?

## Pass / Fail Standard

A screenshot set is acceptable only if it allows a reviewer to make a specific
diagnostic read about:

- composition
- legibility
- movement cueing
- embodied interaction
- spatial promise
- narrative/social fit

If a frame cannot support that read, the capture contract needs improvement even
before the scene art itself is fixed.
