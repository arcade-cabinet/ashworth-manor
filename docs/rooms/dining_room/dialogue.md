# Dining Room — Dialogue

Complete `.dialogue` file content for `dialogue/ground_floor/dining_room.dialogue`.

```
~ dinner_photo
if GameManager.has_flag("knows_full_truth")
	Eight people. Three would die. Two would vanish. Three children would flee and never return.
	
	December 24th, 1891. The last photograph ever taken at Ashworth Manor.
elif GameManager.has_flag("read_maintenance_log")
	You recognize the room. The table is set identically — same places, same candles.
	
	As if the photograph was a blueprint and the room was built to match it. Or as if time simply stopped.
else
	A formal dinner photograph. Eight people arranged around this very table. Stiff poses, forced smiles.
	
	The host — Lord Ashworth — stands at the head. Three of these guests would be dead within the week.
do GameManager.set_flag("examined_dinner_photo")


~ dining_pushed_chair
if GameManager.has_flag("elizabeth_aware")
	The chair faces away from the table. Away from the other guests. Toward the door.
	
	Whoever sat here saw something in the doorway. Something that made them abandon their dinner and run.
else
	One chair pushed back from the table at a sharp angle. The plate in front of it is untouched.
	
	The wine glass is overturned — a dark stain has soaked into the wood. Someone left this seat in a hurry. Or was pulled from it.
do GameManager.set_flag("examined_pushed_chair")


~ dining_wine_glass
if GameManager.has_flag("has_mothers_confession")
	Lady Ashworth's confession mentions "what was done to the guests."
	
	The residue in this glass is dark as dried blood. The dinner wasn't just a gathering. It was a sacrifice.
else
	Dried residue clings to the inside. Not wine — too dark, too thick.
	
	Whatever was in this glass, it wasn't served at dinner. It was added afterward.
do GameManager.set_flag("examined_wine_glass")


~ dining_place_settings
	Set for eight. Five show signs of use — moved cutlery, crumpled napkins, water rings.
	
	Three are pristine. Those three guests never sat down. Or arrived and immediately wished they hadn't.


~ dining_candles
	Wax has pooled and hardened mid-drip. The candles burned down to nothing and were never replaced.
	
	Time stopped here between courses — the dinner was never finished.
do GameManager.set_flag("examined_dining_candles")


~ dining_vessel
	A silver tureen, lid askew. Inside: desiccated remains of soup. Still sitting where it was placed on the night no one finished dinner.
	
	The ladle has never been cleaned.
```
