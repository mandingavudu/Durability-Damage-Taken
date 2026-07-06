# Durability Damage Taken

A small World of Warcraft: Midnight addon that tracks durability loss and warns when durability is low.

The message includes:

- durability percentage lost
- durability percentage remaining
- green remaining durability at 80% or higher
- red remaining durability at 50% or lower
- yellow remaining durability between 50% and 80%

You can also run `/ddt` in chat to print your current durability on demand with the same color coding.

Entering an instance or delve below 80% durability displays a warning and plays the raid-warning sound.
The warning uses large red text near the top of the screen and remains visible for five seconds.
After a death in an instance or delve, the warning also appears below 50% durability.
