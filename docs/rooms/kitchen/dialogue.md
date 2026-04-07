# Kitchen — Dialogue

Complete `.dialogue` file content for `dialogue/ground_floor/kitchen.dialogue`.

```
~ kitchen_note
if GameManager.has_flag("knows_attic_girl")
	Not rats. Elizabeth. The cook heard her — "rats that whisper names."
	
	She knew. The servants always know.
else
	The master has forbidden anyone from the attic. Says the rats have grown too bold.
	
	But I've heard no rats that whisper names...
do GameManager.set_flag("read_cook_note")


~ kitchen_cutting_board
	Vegetables half-chopped. Desiccated to husks. A knife rests mid-cut in what was once a turnip.
	
	The cook walked away in the middle of preparing dinner and never came back.


~ kitchen_hearth
if GameManager.has_flag("elizabeth_aware")
	The iron is cold. But you notice: soot on the chimney breast has been disturbed.
	
	Five small handprints. A child's. At a height no child could reach from the floor.
else
	Cold iron grate. No warmth. A pot sits over dead ashes — the bottom burned black.
	
	Whatever was cooking boiled dry and scorched. The smell of char has faded but the stain remains.


~ kitchen_knives
	Six slots. Five knives. One missing. The handle shapes match the kitchen knives on the counter — except for the empty slot.
	
	That one is different. Longer. Not for cooking.
do GameManager.set_flag("noticed_missing_knife")


~ kitchen_bucket
	A wooden bucket, half-full of water that should not have sat this clean for so long.
	
	The water is perfectly still. No reflection of the ceiling. Just dark.
```
