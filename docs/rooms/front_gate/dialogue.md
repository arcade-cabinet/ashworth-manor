# Front Gate — Dialogue

Complete `.dialogue` file content for the front_gate room. This will be written to `dialogue/grounds/front_gate.dialogue`.

```
~ gate_plaque
if GameManager.has_flag("knows_full_truth")
	"ASHWORTH MANOR — Est. 1847."

	The family name looks different now. Not larger. Just less complete. Elizabeth was always inside it, even when they tried to strike her out.
else
	"ASHWORTH MANOR — Est. 1847."

	The brass has gone green at the edges, but someone has kept the name legible. It feels less abandoned than unattended.
do GameManager.set_flag("examined_gate_plaque")


~ gate_luggage
if GameManager.has_flag("read_guest_ledger")
	Helena Pierce's suitcase. She arrived November 3rd, 1891. Her departure date was left blank. Now you know why — she never left the house alive.
else
	A leather traveling case, clasps still fastened. Packed but never carried beyond the gate. The luggage tag reads: "H. Pierce — London." The ink has run in the rain.
do GameManager.set_flag("found_helena_luggage")


~ gate_bench
if GameManager.has_flag("knows_full_truth")
	The children sat here the night they fled. Charles, Margaret, William. They looked back once. None of them ever returned.
else
	Cold stone, damp at the edges. The sort of bench where a child might have been told to wait while adults decided something out of earshot.


~ iron_gate
if GameManager.has_flag("elizabeth_aware")
	You notice now how deliberate the opening feels. Not forced. Not welcoming either. Simply waiting.
else
	One iron leaf stands partly open. The chain has been unhooked, not cleanly put away. Someone expected arrival, or failed to finish departing.
do GameManager.set_flag("examined_iron_gate")


~ gate_lamp
if GameManager.has_flag("elizabeth_aware")
	The flame gutters once as you near it, though the air is otherwise still. That is enough.
else
	Still lit. The flame is small, sheltered behind glass, and steady enough to suggest recent tending. For a supposedly empty estate, that is unsettling enough.
```
