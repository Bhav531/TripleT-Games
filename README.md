**Quick Start:**

No installation required! Just click the Play Live button above to play the HTML5 web export directly in your browser.

Move: A / D or Left / Right Arrow
Jump: W, Up Arrow, or Space

**Features :**

Rapid-Fire Microgames: Players have exactly 6.7 seconds to figure out the objective (e.g., collect 3 garlics) and execute it.

Global Progression System: Seamlessly transitions between games, tracking minigames_done and carrying over your  li5ves until you hit the Victory or Game Over screens.

Snappy Platforming Physics: Custom CharacterBody2D implementation optimized for precise, quick-reaction jumping and movement.

Modular UI: Independent, standalone scene components for countdown timers, making the HUD universally adaptable to fute minigames.

**How to run it locally**
If you want to poke around the source code or build new microgames, you will need Godot v4.7.1-stable.
Clone this repository: Bash git clone https://github.com/Bhav531/WarioWareGame.git
Open Godot v4.7.1.
Click Import and select the project.godot file in the root of the cloned folder.
Press F5 to run the project from the Title Screen.

**How it works**
To replicate the chaotic, fast-paced nature of WarioWare, the game relies heavily on Godot's modular scene architecture. Instead of loading one massive level, every single microgame (like the garlic platformer) is built as a completely isolated 2D Scene. State management—like tracking the player's 5 lives or how many games they've beaten—is handled entirely through a Global.gd Autoload script. When a microgame's independent 6.7-second %Timer hits zero, or the objective is cleared, the scene root simply evaluates the global state and fires get_tree().change_scene_to_file() to instantly snap to the next microgame, the Winner screen, or the Death screen.

**Minigames** - 

1) Platformer Minigame
2) Clicker Minigame

**Credits**

1 - Built with Godot.4.71
2 - Hackatime (time tracking)
