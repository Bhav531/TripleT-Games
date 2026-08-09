# Triple-T Games
A fast-paced, Tung Tung Sahur- themed, WarioWare-style 2D minigame rush where players must survive four intense, distinct micro-challenges - all built in Godot.

<img width="1152" height="642" alt="image" src="https://github.com/user-attachments/assets/711831a7-3d6d-4eb6-8f5c-580b0365f6e2" />


**[🎮 Play the Live Demo on Itch.io!](ITCH_IO_URL_HERE)**

Triple-T Games is a fast-paced survival rush where players are thrown into a series of rapid-fire microgames. You start with 5 lives. Between each round, a dynamic intermission screen counts down to the next challenge. If you lose all your lives, it's game over. Survive the gauntlet, and you win.

## 🚀 Quick Start
Want to just play the game? 
1. Head over to the **[Itch.io Live Demo](ITCH_IO_URL_HERE)** to play directly in your browser.
2. Alternatively, grab the latest executable for your OS from the [Releases page](RELEASE_URL_HERE), extract, and run!

## 🕹️ The Gauntlet (Features)
The core loop consists of four distinct minigames, each testing a completely different player skill. The game seamlessly transitions between them without dropping a frame:

*   **Minigame 1: The Platformer Rush**
    *   *Mechanic:* 2D physics-based platforming.
    *   *Objective:* Navigate platforms using `CharacterBody2D` physics to collect 3 spawned items before the **4.67-second** timer expires.
*   **Minigame 2: The Clicker**
    *   *Mechanic:* High-speed UI interaction.
    *   *Objective:* A test of mouse accuracy. Players must click and destroy 6 randomized UI targets within exactly 7 seconds. 
*   **Minigame 3: Survival Pong**
    *   *Mechanic:* Kinematic deflection and AI tracking.
    *   *Objective:* Survive for 20 seconds against an AI paddle. If the CPU scores even a single point, the player loses a life.
*   **Minigame 4: Tung Catcher**
    *   *Mechanic:* Horizontal spatial tracking and dynamic spawning.
    *   *Objective:* Tung icons spawn at random X-coordinates at the top of the screen every 2 seconds. The player must catch at least 6 out of 7 falling icons. Missing 2 instantly triggers a game over for that round.

## 🧠 Under the Hood (Architecture & Technical Depth)
This project was built to be highly modular. Instead of a single massive scene, the game relies on isolated minigame scenes orchestrated by a global state manager. 

Here are the key technical implementations that make it work:

### 1. Global State Management (Autoload)
To keep the minigames completely decoupled from one another, the game uses Godot's Singleton (Autoload) pattern via a `Global.gd` script. 
*   `Global.lives`: Tracks the player's remaining health across all scenes.
*   `Global.minigames_done`: Acts as the master level index. 

When a minigame concludes, it simply updates the Global state and routes the player back to the hub scene, completely resetting its own local memory.

### 2. The Dynamic Hub (`level_scene.tscn`)
Rather than hardcoding transitions between Level 1, 2, and 3, a centralized hub scene handles all routing. 
*   **Dynamic UI:** It reads `Global.lives` via a `match` statement to dynamically hide `TextureRect` life icons from an `HBoxContainer`.
*   **Smart Routing:** After a 5-second asynchronous countdown (`await get_tree().create_timer(0.1).timeout`), it automatically concatenates the next scene path (e.g., `"res://scenes/minigame_" + str(Global.minigames_done) + ".tscn"`), verifying the file exists via `ResourceLoader` before transitioning.

### 3. Safe Physics Transitions (`call_deferred`)
A common pitfall in Godot is attempting to change scenes or free nodes while the physics engine is mid-calculation (e.g., exactly when a ball hits a score zone in Minigame 3). 
*   To prevent engine crashes and undesired behavior during `_on_body_entered` callbacks, all scene transitions and critical node removals are pushed to the end of the frame using `call_deferred("_change_scene", target_path)`.

### 4. Code-Driven Signal Connections
In Minigame 4 (Tung Catcher), the falling objects (`FallingIcon` instances) are not placed in the editor. They are preloaded and instantiated purely via script.
*   To avoid brittle UI dependencies, signals (`icon_caught` and `icon_missed`) are connected dynamically via code (`icon_instance.icon_caught.connect(_on_icon_caught)`).
*   Collision detection uses Godot's Scene Groups (`is_in_group("player")`) to ensure the falling icons can identify the player regardless of how the Node tree is structured.

## 💻 How to Run it Locally
Want to look at the node trees and scripts yourself?

1. Install **Godot Engine 4.x**.
2. Clone this repository:
   ```bash
   git clone REPO_URL_HERE
