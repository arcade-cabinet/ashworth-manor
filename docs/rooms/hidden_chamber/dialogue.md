# Hidden Chamber — Dialogue

```
~ elizabeth_final_note
	I understand now. The doll showed me.
	
	I was never sick — they were afraid of what I could see. The house has eyes. The walls have ears. And now I am part of it forever.
	
	Find me. Free me. Or join me.
do GameManager.set_flag("knows_full_truth")
do GameManager.set_flag("read_final_note")


~ chamber_drawings
	Hundreds of drawings cover every inch of wall. The same girl, over and over. Black eyes. The doll. The house with eyes in every window.
	
	Written across the ceiling: "THEY MADE ME THIS." And below it: "IT SEES EVERYTHING."


~ hidden_mirror
	In the mirror, behind you, stands a girl in white. Small. Dark eyes. She doesn't move. She doesn't speak. She just watches.
	
	When you turn — nothing. But the mirror remembers.


~ ritual_circle
if not GameManager.can_perform_ritual()
	Something is missing. You haven't found the whole truth yet.
	
	The circle waits.
else
	The circle drawn on the floor pulses faintly. The drawings on the walls converge on this point.
	
	Everything leads here.


~ chamber_artifact
	A stone figure in the center of a chalk circle. The occultist's work. This is where the binding was performed.
	
	Elizabeth was standing right here when they took her away.
```
