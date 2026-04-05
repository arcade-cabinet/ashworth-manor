# Library — Dialogue

```
~ library_globe
if GameManager.has_flag("knows_key_location")
	Inside the hollow globe, you find an old brass key labeled "ATTIC."
	
	Hidden here by Lord Ashworth himself. The key to his daughter's prison, tucked inside a model of the world she'd never see.
else
	A terrestrial globe on a brass pedestal. The continents are hand-painted, faded with age. It spins freely.
	
	The equator seam is visible — the globe is hollow.


~ binding_book
	To trap a spirit, one must first give it form. The doll shall be the vessel, the blood the seal, and the attic the prison eternal...
	
	The pages are marked with Lord Ashworth's annotations. He understood what he was doing. He did it anyway.
do GameManager.set_flag("knows_binding_ritual")


~ family_tree
if GameManager.has_flag("knows_full_truth")
	Elizabeth Ashworth. You can read her name now, even through the scratches.
	
	She existed. They tried to erase her from history, from memory, from the family tree itself. They failed.
else
	The tree shows four children, but the household records only mention three. The fourth name has been scratched out: "E_iza_eth."
	
	Scratched with something sharp — a knife? A fingernail? Whoever did this was angry, not careful.
do GameManager.set_flag("examined_family_tree")


~ library_artifact
if GameManager.has_flag("knows_binding_ritual")
	The symbols match some of those in the binding book. This isn't decorative — it's a tool.
	
	The occultist brought it. Part of the ritual apparatus used to imprison Elizabeth.
else
	A stone tablet covered in symbols you don't recognize. It hums faintly when touched.
	
	The surface is warm, like the jewelry box. Like the gate lamp. Like everything Elizabeth has touched.


~ library_shelves
	Legitimate scholarship mixed with occult texts. Geology next to demonology. Mathematics beside necromancy.
	
	Lord Ashworth wasn't stupid — he was desperate. He read everything, understood enough to be dangerous, and found someone willing to act on it.


~ library_gears
	Disassembled clock mechanisms. Lord Ashworth collected them — or dismantled them.
	
	Every clock in this house stopped at 3:33. Was that coincidence? Or did he know how to stop time?
```
