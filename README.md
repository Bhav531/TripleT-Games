# Triple-T Games

A fast-paced, **Tung Tung Sahur-themed, WarioWare-style 2D minigame rush** where players must survive a sequence of intense, distinct micro-challenges, all built in **Godot 4.1**.
<img width="1152" height="642" alt="image" src="https://github.com/user-attachments/assets/711831a7-3d6d-4eb6-8f5c-580b0365f6e2" />
**[Play the Game!](https://bh4v-xy.itch.io/triple-t-games)**

Triple-T Games is a rapid-fire survival rush where players are thrown into a series of unpredictable microgames. You begin with **5 lives**, navigate through increasingly frantic challenges, and must react quickly to survive. Between each round, a dynamic intermission screen prepares you for the next challenge. Lose all your lives and the run ends. Survive the complete gauntlet and you win.

## Quick Start

Want to jump straight into the game?

* Head over to the **[Itch.io Live Demo](https://bh4v-xy.itch.io/triple-t-games)** to play directly in your browser.

---

## The Gauntlet

The core gameplay loop consists of **five distinct minigames**, each designed around a different skill, mechanic, and style of interaction. The game seamlessly transitions between challenges while maintaining a fast and continuous pace.

### Minigame 1: The Platformer Rush

* **Mechanic:** 2D physics-based platforming.
* **Objective:** Navigate platforms using `CharacterBody2D` physics and collect **3 spawned items** before the **4.67-second** timer expires.
* **Technical Focus:** Character movement, collision handling, item spawning, and timed objectives.

### Minigame 2: The Clicker

* **Mechanic:** High-speed UI interaction.
* **Objective:** Test mouse accuracy and reaction speed by clicking and destroying **6 randomized UI targets** within exactly **7 seconds**.
* **Technical Focus:** Dynamic UI generation, mouse input, target positioning, and countdown management.

### Minigame 3: Survival Pong

* **Mechanic:** Kinematic deflection and AI tracking.
* **Objective:** Survive for **20 seconds** against an AI-controlled paddle. If the CPU scores even a single point, the player loses a life.
* **Technical Focus:** Paddle movement, ball physics, collision detection, AI tracking, and score zones.

### Minigame 4: Tung Catcher

* **Mechanic:** Horizontal spatial tracking and dynamic object spawning.
* **Objective:** Tung icons spawn at random X-coordinates at the top of the screen every **2 seconds**. The player must catch at least **6 out of 7** falling icons.
* **Failure Condition:** Missing **2 icons** instantly ends the round.
* **Technical Focus:** Runtime instantiation, collision detection, dynamic signals, and scene groups.

### Minigame 5: Snooker Rush

* **Mechanic:** Physics-driven snooker with intelligent collision handling.
* **Objective:** Complete the snooker challenge under pressure by accurately controlling the cue and interacting with the balls using realistic physical interactions.
* **Technical Focus:** Built around **Godot's `RigidBody2D` physics and collision systems**, allowing balls to respond dynamically to impacts, momentum, and physical interactions.
* **Physics Systems:** Smart collision handling and physics-body processes create responsive ball movement and realistic chain reactions across the table.

The Snooker Rush introduces a more physically driven challenge to the gauntlet, contrasting with the reaction-based and UI-focused mechanics of the other minigames.

---

## Features

### Five Unique Minigames

Each challenge introduces a completely different gameplay mechanic, ranging from platforming and precision clicking to Pong survival, falling-object interception, and physics-based snooker.

### Five-Life Survival System

Players begin each run with **5 lives**. Losing a challenge costs a life, while reaching zero lives triggers the game-over sequence.

### Level Skip System

Players can **skip levels** when necessary, providing an alternative route through the gauntlet and allowing faster progression through individual challenges.

### Music & Volume Controls

A dedicated settings system allows players to control the game's audio experience.

* **Global music toggle**
* **Adjustable music volume**
* Audio settings remain accessible through the Settings menu.

### Difficulty Settings

Choose between:

* **Easy**
* **Normal**
* **Hard**

Difficulty affects gameplay parameters such as timers, spawn pools, and challenge intensity.

### Dynamic Time Scaling

Challenge parameters dynamically adapt according to the selected difficulty, modifying timer constraints and spawning behaviour to create increasingly demanding runs.

### Visual Polish & Juice

The game uses Tween-driven animations and responsive UI effects to make transitions and interactions feel more dynamic.

* Smooth Tween animations
* Icon rotations
* Dynamic scaling
* UI entrance transitions
* Animated intermission screens

---

## Under the Hood

Triple-T Games was designed to be modular rather than relying on one enormous scene. Individual minigames exist as isolated scenes and are orchestrated through a centralized global state system.

### 1. Global State Management

The game uses Godot's **Singleton (Autoload)** architecture through `Global.gd`.

* `Global.lives` tracks the player's remaining lives across scenes.
* `Global.minigames_done` tracks progression through the minigame sequence.
* Global settings manage gameplay and audio-related state.

When a minigame concludes, the global state is updated and the player is routed back through the central hub before the next challenge begins.

### 2. Dynamic Hub

The `level_scene.tscn` scene functions as the central routing hub rather than hardcoding individual level transitions.

* **Dynamic UI:** Reads `Global.lives` and updates the displayed life icons accordingly.
* **Smart Routing:** Determines the next minigame dynamically and constructs its scene path.
* **Resource Validation:** Uses `ResourceLoader` to verify that the requested scene exists before attempting to load it.
* **Level Progression:** Supports the game's sequential progression and level-skipping functionality.

### 3. Safe Physics Transitions

A common Godot issue occurs when attempting to change scenes or remove nodes while the physics engine is actively processing a collision.

For example, a ball may trigger a scoring zone while the physics engine is still calculating its current frame.

To prevent unsafe modifications, critical scene transitions and node removals are deferred using:

```gdscript
call_deferred("_change_scene", target_path)
```

This ensures that physics callbacks can complete before the scene tree is modified.

### 4. Physics-Based Snooker

The Snooker Rush minigame makes extensive use of Godot's physics system.

* `RigidBody2D` objects handle ball movement.
* Collision bodies detect impacts between balls and the environment.
* Physics processing determines how momentum is transferred between objects.
* Collision interactions allow multiple balls to react naturally to a single impact.

This creates a physics-driven minigame where the outcome of one collision can influence subsequent interactions across the table.

### 5. Code-Driven Signal Connections

In Minigame 4, falling objects are not manually placed into the scene.

Instead, `FallingIcon` instances are preloaded and instantiated directly through code.

Signals such as:

```gdscript
icon_instance.icon_caught.connect(_on_icon_caught)
```

are connected dynamically at runtime.

This reduces dependence on rigid scene-tree structures and makes the spawning system easier to modify.

### 6. Scene Groups for Collision Detection

Collision detection in Minigame 4 uses Godot's **Scene Groups**.

```gdscript
is_in_group("player")
```

This allows falling objects to identify the player without relying on a specific node path, making the system more modular and resilient to changes in the scene hierarchy.

---

## How to Run Locally

Want to inspect the scenes, node trees, scripts, and physics systems yourself?

1. Install **Godot Engine 4.x**.
2. Clone this repository:

```bash
git clone https://github.com/Bhav531/TripleT-Games
```

3. Open the project in Godot.
4. Run the main scene.

---

## Credits

**Coding Editor:** Godot 4.1

**Developer:** Bhav Kartik Jindal

**Images:** Google

**Generative AI:** No generative AI was used.
