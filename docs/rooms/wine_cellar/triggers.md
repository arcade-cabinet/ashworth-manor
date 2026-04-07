# Wine Cellar — Triggers

### First Entry
```yaml
- set_flag: visited_wine_cellar
- set_flag: reached_deepest
- play_sfx: "ambient/pl_ambient_dungeon_02"
- observation: "The weight of the house presses down. Stone, earth, old bottles, old lies. You are far enough below the manor now that daylight feels theoretical."
```

### Torch Gutter (60s, `elizabeth_aware`)
```yaml
- torch_west energy: 1.5 → 0.3 → 1.5 over 2s
- observation: "The torch guttered. As if something passed between you and the flame."
```

### No flashbacks — the isolation IS the horror. No supernatural overlay needed in the deepest dark.
