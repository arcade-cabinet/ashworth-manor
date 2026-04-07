# Upper Hallway — Dialogue

Complete `.dialogue` file content for `dialogue/upper_floor/hallway.dialogue`.

```
~ attic_door
if GameManager.has_item("attic_key")
	The old lock clicks open. Stale air rushes past you — air that hasn't moved in years.
	
	The stairs beyond are dark. Something shifts in the shadows above.
elif GameManager.has_flag("knows_key_location")
	The attic door. The diary said the key is hidden in the library globe.
	
	You can almost hear something behind it. Breathing? Or just the wind?
else
	The door is locked. Heavy iron bands reinforce the wood. The lock is cold — colder than the air.
	
	This door wasn't built to keep something out. It was built to keep something in.
do GameManager.set_flag("knows_attic_locked")


~ children_painting
if GameManager.has_flag("knows_full_truth")
	Charles, Margaret, William. They heard their sister calling through the walls.
	
	They fled the night of December 24th and never came back. Three children who survived by leaving the fourth behind.
elif GameManager.has_flag("knows_attic_girl")
	Three children. But Elizabeth would have been six in 1886. Old enough to stand for a portrait. Old enough to be included.
	
	They painted her out of the family before they locked her in the attic.
else
	Three children in white stand before a summer garden. Charles, the eldest, looks serious. Margaret smiles politely. William clutches a toy soldier.
	
	The painting is titled "The Ashworth Children, 1886." But the household records say there were four.
do GameManager.set_flag("examined_children_painting")


~ hallway_mask
if GameManager.has_flag("elizabeth_aware")
	The mask's expression has changed. You're certain it was smiling before. Now both corners of the mouth turn down.
	
	The empty eye sockets seem deeper.
else
	A theatrical mask mounted on the wall. The expression is frozen between comedy and tragedy — the mouth curves up on one side and down on the other.
	
	The eyes are empty sockets.


~ hallway_poster
	A household notice, framed and hung for all to see:
	
	"The third floor is closed for repairs. No staff or family are to enter under any circumstances. — Lord Ashworth, October 1887."
	
	The date: two months before Elizabeth was officially confined.
do GameManager.set_flag("read_hallway_notice")
```
