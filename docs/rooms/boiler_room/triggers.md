# Boiler Room — Triggers

### First Entry
```yaml
- set_flag: visited_boiler_room
- play_sfx: "boiler_rumble" + "pipe_groan"
- show_room_name: "Boiler Room"
```

### Pipe Whisper (30s after entry, `elizabeth_aware`)
```yaml
- play_sfx: "whisper_through_pipes"
- observation: "Was that... a voice? In the pipes?"
```

### Boiler Pulse (Ambient): Constant low rumble, metal expanding/contracting sounds
