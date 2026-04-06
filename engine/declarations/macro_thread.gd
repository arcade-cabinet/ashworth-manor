@tool
class_name MacroThread
extends Resource
## The emotional perspective -- one of 3 macro narrative threads.

@export var thread_id: String = ""           # "captive", "mourning", "sovereign"
@export var question: String = ""            # "How do I free her?"
@export var elizabeth_nature: String = ""    # "trapped spirit", "grieving soul", "being of power"
@export var house_nature: String = ""        # "cage", "memorial", "instrument"
@export var ending_id: String = ""           # Which positive ending this resolves to

# Key text overrides -- these core narrative texts change per macro thread
@export var diary_page_text: String = ""
@export var elizabeth_letter_text: String = ""
@export var elizabeth_final_note_text: String = ""
@export var ritual_sequence_texts: PackedStringArray = []
