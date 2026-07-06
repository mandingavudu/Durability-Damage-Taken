# Durability Damage Taken

A World of Warcraft: Midnight addon that reports non-combat durability loss and warns when equipment needs repair.

## Behavior

- Prints durability lost and remaining after every non-combat reduction, including deaths and Spirit Healer resurrections.
- Shows large red text and plays the raid-warning sound when entering an instance or delve below 80% durability.
- Optionally triggers the same warning when using a current-season dungeon portal.
- Repeats that warning after a death or other non-combat reduction inside an instance or delve below 50% durability.

## Durability colors

- Green: 80% or higher
- Yellow: above 50% and below 80%
- Red: 50% or lower

## Commands

- `/ddt`: print current durability
- `/ddt warning on`: enable major text and sound warnings (default)
- `/ddt warning off`: disable major text and sound warnings
- `/ddt warning followup on`: enable warnings after durability loss (default)
- `/ddt warning followup off`: keep only instance/delve entry warnings
- `/ddt warning portal on`: enable warnings when using seasonal dungeon portals (default)
- `/ddt warning portal off`: disable seasonal dungeon portal warnings

The same warning controls are available under Options → AddOns → Durability Damage Taken.
