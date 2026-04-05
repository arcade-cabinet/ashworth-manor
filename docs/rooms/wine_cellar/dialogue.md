# Wine Cellar — Dialogue

```
~ wine_note
	The 1872 Bordeaux has been moved to the hidden alcove. Master insists no one shall find it.
	
	The key is with the portrait.
do GameManager.set_flag("read_wine_note")


~ wine_box
if GameManager.has_item("cellar_key")
	I am complicit in what was done to our daughter.
	
	When Elizabeth first spoke of seeing the dead, I told myself she was ill. When Edmund brought the occultist, I told myself it was medicine. When they locked her in the attic with that horrible doll, I told myself it was for her safety.
	
	I lied. To everyone. To myself.
	
	Elizabeth was never dangerous. She was gifted. And we destroyed her for it.
	
	If anyone finds this, know that we deserve what is coming. The house knows. Elizabeth knows. And soon, so shall we.
	
	— Victoria Ashworth, December 23rd, 1891
else
	A wooden chest, bound with iron. Heavy padlock.
	
	The inventory note mentioned "the key is with the portrait" — but which one?


~ wine_racks
	Most bottles covered in dust — decades undisturbed.
	
	But several gaps where bottles were recently removed. No dust in those spots. Recently? That's impossible.


~ wine_footprints
	Footprints in the dust. They lead from the ladder to the wall. And stop.
	
	No return prints. Whoever walked here went to the wall and... through it?
```
