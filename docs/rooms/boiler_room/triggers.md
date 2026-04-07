# Boiler Room — Triggers

### First Entry
```yaml
- set_flag: visited_boiler_room
- play_sfx: "ambient/pl_ambient_machine_02"
- show_room_name: "Boiler Room"
- observation: "Heat and iron press close around you, and every pipe in the room feels tuned to something listening from above."
```

### Pipe Whisper (30s after entry, `elizabeth_aware`)
```yaml
- play_sfx: "whisper_through_pipes"
- observation: "Was that... a voice? In the pipes?"
```

### Boiler Pulse (Ambient): Constant low rumble, metal expanding/contracting sounds
