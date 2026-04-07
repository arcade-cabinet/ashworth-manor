@tool
class_name EndingDecl
extends Resource
## An ending sequence triggered by state conditions.

@export var ending_id: String = ""
@export var trigger_condition: String = ""   # State expression
@export var trigger_room: String = ""        # Room where ending triggers
@export var text_sequence: PackedStringArray = [] # Lines shown in sequence
@export var timing: Array[float] = []        # Seconds between each line
@export var stinger_sfx: String = ""         # Music stinger path
