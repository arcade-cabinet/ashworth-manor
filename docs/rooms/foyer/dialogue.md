# Grand Foyer — Dialogue

Complete `.dialogue` file content for `dialogue/ground_floor/foyer.dialogue`.

```
~ foyer_painting
if GameManager.has_flag("knows_full_truth")
	Edmund Ashworth. Father. Industrialist. Jailer.
	
	You know what those hollow eyes saw. You know what that book taught him to do. The portrait is the only part of him that remained in this house.
elif GameManager.has_flag("read_ashworth_diary")
	The patriarch who locked his daughter in the attic. His hand rests on "Rites of Passage" — the book that started it all.
	
	The hollow eyes make sense now. That's not authority. That's guilt.
else
	The patriarch stares down with hollow eyes. His hand rests on a book titled "Rites of Passage."
	
	The oil paint has darkened with age, but the eyes remain vivid — as if they were painted last.
do GameManager.set_flag("examined_foyer_painting")


~ foyer_mirror
if GameManager.has_flag("found_hidden_chamber")
	In the mirror, behind your reflection — a girl in white. Small. Pale. Eyes dark as ink.
	
	When you blink, she's gone. But the mirror is warm to the touch.
elif GameManager.has_flag("elizabeth_aware")
	Your reflection stares back. It moved independently. You're sure of it this time.
	
	The delay is fractional — but real.
else
	Your reflection stares back from a full-length mirror in an ornate dark wood frame. The silver is tarnished.
	
	For a moment, you could swear it moved independently.
do GameManager.set_flag("examined_foyer_mirror")


~ grandfather_clock
if GameManager.has_flag("examined_boiler_clock")
	3:33. Every clock in this house shows the same time.
	
	Whatever happened, happened everywhere at once.
else
	The hands point to 3:33. The pendulum hangs motionless. No ticking breaks the silence.
	
	The moon phase dial shows a full moon. December 24th, 1891.
do GameManager.set_flag("examined_foyer_clock")


~ foyer_mail
if GameManager.has_flag("read_ashworth_diary")
	The letters are from solicitors, creditors, a physician. He ignored them all.
	
	The last letter is from a doctor at Bethlem Hospital: "Regarding your daughter's condition..." Still sealed.
else
	A stack of letters on the hall table. Addressed to Lord Ashworth. Postmarked November and December 1891.
	
	None opened. He stopped reading his mail.
do GameManager.set_flag("found_unopened_mail")


~ foyer_stairs
if GameManager.has_flag("entered_attic")
	The stairs feel different now. You know what's above the upper floor. What's above the ceiling.
	
	Who's been there this whole time.
else
	The staircase sweeps upward into shadow. Carved banisters wound with wooden vines. A carpet runner, faded crimson, muffles imagined footsteps.
	
	The upper floor is dark.
```
