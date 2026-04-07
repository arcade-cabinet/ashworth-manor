extends SceneTree
## Retired omnibus E2E harness.
## The declaration-era test lanes now cover this scope explicitly:
## - test/generated/test_declarations.gd
## - test/e2e/test_declared_interactions.gd
## - test/e2e/test_room_specs.gd
## - test/e2e/test_room_walkthrough.gd
## - test/e2e/test_full_playthrough.gd
## - test/e2e/test_opening_journey.gd


func _initialize() -> void:
	print("run_e2e.gd is retired.")
	print("Use the declaration-era focused suites instead:")
	print("  - test/generated/test_declarations.gd")
	print("  - test/e2e/test_declared_interactions.gd")
	print("  - test/e2e/test_room_specs.gd")
	print("  - test/e2e/test_room_walkthrough.gd")
	print("  - test/e2e/test_full_playthrough.gd")
	print("  - test/e2e/test_opening_journey.gd")
	quit(0)
