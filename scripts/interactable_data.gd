@tool
class_name InteractableData
extends Resource
## Custom resource for interactable objects in rooms

@export var object_id: String = ""
@export var object_type: String = ""  # note, painting, photo, mirror, clock, switch, box, locked_door, doll, ritual, observation
@export var title: String = ""
@export_multiline var content: String = ""
@export var locked: bool = false
@export var key_id: String = ""
@export var item_found: String = ""
@export var gives_also: String = ""
@export var on_read_flags: PackedStringArray = []
@export var pickable: bool = false
@export var item_id: String = ""
@export var message_locked: String = "It's locked. You need a key."
@export var target_room: String = ""  # For locked_door type
@export var controls_light: String = ""  # For switch type

# Doll-specific
@export_multiline var first_content: String = ""
@export_multiline var second_content: String = ""
@export var requires_flag: String = ""
@export var on_first_flags: PackedStringArray = []
@export var on_second_flags: PackedStringArray = []
@export var pickable_after_key: bool = false
