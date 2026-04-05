@tool
extends "res://addons/gd-plug/plug.gd"

func _plugging() -> void:
	# === PSX RENDERING ===
	# Proper PS1 vertex snapping, affine texture mapping, color depth, dithering
	# Replaces our basic screen-space post-process with per-material PSX accuracy
	plug("AnalogFeelings/godot-psx")

	# === DIALOGUE / DOCUMENT SYSTEM ===
	# Branching dialogue manager with editor — replaces hardcoded string overlays
	# Can hold all narrative content (diary entries, notes, paintings) as resources
	plug("nathanhoad/godot_dialogue_manager")

	# === INVENTORY SYSTEM ===
	# Grid-based inventory with item database, slot system, UI components
	# Replaces our basic Array[String] inventory
	plug("peter-kish/gloot")

	# === ADAPTIVE AUDIO ===
	# Background audio manager with layers, crossfading, adaptive intensity
	# Replaces our basic dual-AudioStreamPlayer crossfade
	plug("MrWalkmanDev/AdaptiSound")

	# === CAMERA EFFECTS ===
	# Camera shake for horror moments (Elizabeth events, ritual, endings)
	# Head bob while walking, screen shake on discoveries
	plug("synalice/shaky-camera-3d")

	# === QUEST / PUZZLE TRACKING ===
	# Resource-based quest system — tracks puzzle chain progress properly
	# Replaces our flag-based system with structured quest state
	plug("shomykohai/quest-system")

	# === SAVE / LOAD ===
	# Robust save system with encryption, nested data, error handling
	# Replaces our basic JSON write
	plug("AdamKormos/SaveMadeEasy")
