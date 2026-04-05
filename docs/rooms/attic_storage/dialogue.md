# Attic Storage — Dialogue

```
~ elizabeth_portrait
	A young girl in a white dress clutches a porcelain doll. Her eyes have been painted over in black.
	
	The plaque reads: "Elizabeth Ashworth, 1880-1889. Beloved daughter. Forgotten by none."
	
	She painted this herself. The brushwork is a child's — careful, earnest, imperfect. The black eyes were the last thing she added.
do GameManager.set_flag("seen_elizabeth_portrait")


~ porcelain_doll
if GameManager.has_flag("read_elizabeth_letter") and GameManager.has_flag("examined_doll") and not GameManager.has_item("hidden_key")
	You turn the doll over. Inside the hollow body, wrapped in a child's handkerchief, is a tarnished key.
	
	The doll's cracked face seems to relax.
elif not GameManager.has_flag("examined_doll")
	A porcelain doll with cracked features. Its painted eyes seem to follow you.
	
	Behind it, scratched into the wood: "SHE NEVER LEFT."
else
	The doll sits quietly. Empty now.


~ elizabeth_letter
	Dearest Mother,
	
	They say I'm sick but I feel fine. Father won't let me leave my room anymore. The doll talks to me now. She says I'll be here forever.
	
	I'm scared.
	
	— Your Elizabeth
do GameManager.set_flag("read_elizabeth_letter")


~ hidden_door
if GameManager.has_item("hidden_key")
	The hand-shaped lock accepts the key. The door swings inward, revealing a small chamber beyond.
	
	The air that escapes is warm. And it smells of candle wax and drawings.
else
	A door, almost invisible behind the trunks. The lock is unlike any other in the house — shaped like an open hand.
	
	Waiting.


~ attic_window
	The window faces the garden. You can see the lily from here — the one living thing in the dead winter grounds.
	
	Elizabeth could see it too. She grew it from this window. Her last connection to the world outside.


~ elizabeth_trunk
	Elizabeth's trunk. Clothes for a nine-year-old, folded neatly by someone who cared.
	
	A nightgown. A ribbon. A drawing of a family with four children — the only place all four exist together.
```
