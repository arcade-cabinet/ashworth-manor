extends CanvasLayer
## res://scripts/ui/document_balloon.gd -- Victorian paper balloon for Dialogue Manager
## Aged paper aesthetic, typewriter text, tap-to-dismiss. No response menu needed.

const PAPER_COLOR := Color("#D1C1A6")
const PAPER_TEXT := Color("#332619")
const PAPER_BORDER := Color("#8B7355")

## The dialogue resource
@export var dialogue_resource: DialogueResource

## Start from a given cue when using balloon as a Node in a scene.
@export var start_from_cue: String = ""

## If running as a Node in a scene then auto start the dialogue.
@export var auto_start: bool = false

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			_apply_dialogue_line()
		else:
			if owner == null:
				queue_free()
			else:
				hide()
	get:
		return dialogue_line

## A cooldown timer for delaying the balloon hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

@onready var balloon: Control = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var separator: HSeparator = %Separator
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var dismiss_hint: Label = %DismissHint


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)

	if auto_start:
		if not is_instance_valid(dialogue_resource):
			return
		start()


func _unhandled_input(_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(with_dialogue_resource: DialogueResource = null, cue: String = "", extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	if is_instance_valid(with_dialogue_resource):
		dialogue_resource = with_dialogue_resource
	if not cue.is_empty():
		start_from_cue = cue
	dialogue_line = await dialogue_resource.get_next_dialogue_line(start_from_cue, temporary_game_states)
	show()


## Apply any changes to the balloon given a new DialogueLine.
func _apply_dialogue_line() -> void:
	mutation_cooldown.stop()
	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()

	# Title from character field (we use interactable ID as character)
	if dialogue_line.character.is_empty():
		character_label.visible = false
		separator.visible = false
	else:
		var title: String = dialogue_line.character.replace("_", " ").capitalize()
		character_label.text = "[center]%s[/center]" % title
		character_label.visible = true
		separator.visible = true

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	balloon.show()
	will_hide_balloon = false
	dismiss_hint.visible = false

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		dialogue_label.type_out()
		await dialogue_label.finished_typing

	# No responses in our document system -- just wait for tap
	is_waiting_for_input = true
	dismiss_hint.visible = true
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()


## Go to the next line
func next(next_id: String) -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()


func _on_mutated(mutation: Dictionary) -> void:
	if not mutation.is_inline:
		is_waiting_for_input = false
		will_hide_balloon = true
		mutation_cooldown.start(0.1)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# Skip typing on tap
	if dialogue_label.is_typing:
		var mouse_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var touch: bool = event is InputEventScreenTouch and event.pressed
		if mouse_clicked or touch:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input:
		return

	# Dismiss on tap (advance to next line -- which will be null, ending dialogue)
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event is InputEventScreenTouch and event.pressed:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(&"ui_accept"):
		next(dialogue_line.next_id)
