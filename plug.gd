@tool
extends "res://addons/gd-plug/plug.gd"

func _plugging() -> void:
	# === PSX RENDERING ===
	# Screen-space dithering + color depth reduction (NO per-material shaders)
	plug("AnalogFeelings/godot-psx")

	# === DIALOGUE / DOCUMENT SYSTEM ===
	# Branching dialogue manager with editor -- replaces hardcoded string overlays
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
	# Resource-based quest system -- tracks puzzle chain progress properly
	# Replaces our flag-based system with structured quest state
	plug("shomykohai/quest-system")

	# === SAVE / LOAD ===
	# Robust save system with encryption, nested data, error handling
	# Replaces our basic JSON write
	plug("AdamKormos/SaveMadeEasy")

	# === MATERIAL FOOTSTEPS ===
	# Surface-based footstep sounds (marble, wood, stone, metal, etc.)
	# Reads surface metadata from floor meshes
	plug("COOKIE-POLICE/godot-material-footsteps")

	# === PHANTOM CAMERA ===
	# Priority-based camera system for inspection views and cinematics
	# Smooth transitions between exploration and object inspection cameras
	plug("ramokz/phantom-camera", {"include": ["addons/phantom_camera/"]})

	# === LIMBO AI / HSM ===
	# Hierarchical State Machine for game phases and Elizabeth AI behavior
	# NOTE: LimboAI is a GDExtension -- download prebuilt from GitHub releases
	# https://github.com/limbonaut/limboai/releases
	# Place .gdextension + .dylib/.so files in addons/limboai/
	# plug("limbonaut/limboai")  # Cannot install via gd-plug (GDExtension)

	# === TESTING ===
	# Unit + integration testing framework for Godot 4
	# Run via editor or CLI: godot --headless -s addons/gdUnit4/bin/GdUnitCmdTool.gd
	plug("MikeSchulze/gdUnit4", {"tag": "v6.1.2", "include": ["addons/gdUnit4/"]})
