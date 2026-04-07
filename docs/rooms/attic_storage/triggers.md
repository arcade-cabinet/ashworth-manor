# Attic Storage — Triggers

### First Entry
```yaml
- set_flag: reached_attic_storage
- show_room_name: "Attic"
- play_sfx: "wind_through_rafters"
- observation: "Something moved in the shadows beyond the window."
```

### Portrait Flashback (on examine)
```yaml
- psx_fade: 70% white, 1s
- spawn: bloodwraith.glb, child-scale, at portrait position
- text: "She painted this herself. The eyes were the last thing she added. She said she couldn't see anymore."
- despawn, fade, shake
```

### Music Box Echo (from parlor below)
```yaml
conditions: flag_set: music_box_auto_triggered
trigger: 20s after entry
- play_sfx: "music_box_melody_distant" (from below, muffled)
- text: None — the melody speaks
```

### Scratching Sounds (Ambient)
Every 15-25s: `play_sfx: "scratching"` from walls. Not rats.
