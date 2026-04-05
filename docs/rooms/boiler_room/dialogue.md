# Boiler Room — Dialogue

```
~ maintenance_log
	Dec 15, 1891 — Strange sounds from the pipes again. The staff refuse to come down here after dark.
	
	Something is wrong with this house.
do GameManager.set_flag("read_maintenance_log")
do GameManager.set_flag("knows_staff_afraid")


~ boiler_clock
	3:33. Even here, in the belly of the house.
	
	The industrial clock is built for reliability — spring mechanism, not pendulum. It shouldn't have stopped. Nothing should have stopped it.
do GameManager.set_flag("examined_boiler_clock")


~ boiler_observation
if GameManager.has_flag("elizabeth_aware")
	The warmth isn't from coal. There's no fuel in the firebox.
	
	The boiler generates its own heat now. The house has a heartbeat.
else
	Massive cast iron. Still warm to the touch. The firebox has ash in it — grey, not black.
	
	Someone fed this boiler recently. But who? The house has been abandoned for over a century.


~ boiler_pipes
if GameManager.has_flag("elizabeth_aware")
	The pipes groan. For a moment, you hear words in the groaning.
	
	Not your name. Hers.
else
	Pipes snake across the ceiling and into the walls. They carry heat — or carried it, once.
	
	They run to every room. The entire house is connected through these veins.


~ boiler_mask
	A metallic mask on a nail. The expression is frozen in a scream.
	
	Industrial safety equipment? Or something the occultist wore? The inside is stained dark.
```
