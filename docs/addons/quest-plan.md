# Quest Plan — quest-system

## Source
- Addon: `shomykohai/quest-system`
- Location: `addons/quest_system/`

## Purpose

High-level puzzle tracking. Flags remain for granular state; quests give player-visible progress.

## Quest Definitions

| Quest ID | Name | Objective | Completion Flag |
|----------|------|-----------|-----------------|
| 1 | Find the Attic Key | Discover what's hidden above | `attic_unlocked` |
| 2 | Find the Hidden Key | Unlock Elizabeth's inner sanctum | `hidden_chamber_unlocked` |
| 3 | Wine Cellar Secret | Open the locked box | `wine_box_unlocked` |
| 4 | Lady's Jewelry Box | Find what Lady Ashworth kept close | `jewelry_box_opened` |
| 5 | Open the Crypt Gate | Enter the family burial ground | `crypt_gate_opened` |
| 6 | Free Elizabeth | Perform the counter-ritual | `freed_elizabeth` |

## Integration

- Quest starts when player discovers the puzzle (e.g., finds locked attic door)
- Quest completes when completion flag is set
- Quest completion triggers UI notification via UIOverlay
- Quest state serialized via SaveMadeEasy

## Implementation Steps

1. Create Quest resources (`.tres`) for each of the 6 puzzles
2. Register quests in QuestManager autoload
3. Connect GameManager.flag_set to quest start/complete triggers
4. Add quest progress display to pause menu
5. Test: complete each puzzle chain, verify quest state updates
