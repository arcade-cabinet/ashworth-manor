# Guest Room — Dialogue

```
~ guest_ledger
	Mrs. Helena Pierce, arriving Nov 3rd 1891. Purpose: Social visit. Expected departure: Nov 10th.
	
	DEPARTED: [The entry is blank.]
	
	Below it, in different handwriting: "She stopped coming to dinner after the third night."
do GameManager.set_flag("read_guest_ledger")


~ helena_photo
if GameManager.has_flag("knows_full_truth")
	Helena Pierce. She came for a weekend. She stayed forever.
	
	The house collected her like the wine cellar collects bottles — sealed, preserved, forgotten.
else
	A woman in traveling clothes, smiling at the camera. Confident. Ready for an adventure.
	
	She has no idea what this house will do to her.
do GameManager.set_flag("examined_helena_photo")


~ guest_luggage
	Packed and ready. The clasps are undone — she was about to close it when she stopped.
	
	The clothes inside are folded neatly, then disturbed, as if she changed her mind about what to bring. Or whether to leave at all.


~ guest_bed
	Perfectly made. Hospital corners. As if by a professional.
	
	But the maids left the house weeks before Helena arrived. Who made this bed? Who kept this room so... ready?


~ guest_lamp
	An oil lamp, dry. The wick has been trimmed but never lit again.
	
	Helena was alone in the dark. The guest room has no gas line — just this one lamp. When the oil ran out, she had nothing.
```
