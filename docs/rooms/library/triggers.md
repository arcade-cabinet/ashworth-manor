# Library — Triggers & Events

## Entry Events

### First Entry
```yaml
event: library_first_entry
conditions:
  - flag_not_set: visited_library
actions:
  - set_flag: visited_library
  - show_room_name: "Library"
```

## Conditional Events

### Post-`binding_book`: Binding Aftershock
```yaml
event: library_binding_aftershock
conditions:
  - inventory_has: binding_book
  - flag_not_set: library_flashback_triggered
actions:
  - set_flag: library_flashback_triggered
  - play_sfx: "paper_rustle"
  - light_change: library_desk_lamp -> 0.45 over 1.2s
  - delay: 1.8s
  - observation: "The pages move without wind. Not turning -- recoiling. In the hush that follows, you can almost hear the occultist reading across the desk from Edmund Ashworth, each line of the rite making the room smaller."
  - delay: 5.8s
  - light_change: library_desk_lamp -> 1.2 over 2.4s
```

### Paper Rustling (Ambient)
```yaml
event: library_rustle
trigger: Random, every 20-40 seconds
conditions:
  - player_in_room: library
actions:
  - play_sfx: "paper_rustle" (positional, from bookshelves, very quiet)
```

## Phase-Specific Changes

| Phase | Effect |
|-------|--------|
| Exploration | Quiet. Scholarly. The knowledge here seems benign. |
| Discovery | Paper rustling more frequent. Books seem to shift on shelves. |
| Horror | The binding-book aftershock can dim the desk lamp and make the stacks answer back. |
| Resolution | Calm. The book is just a book now. The knowledge is understood. |
