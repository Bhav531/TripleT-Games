extends Node2D

@onready var minigame_timer = $minigame_2_timer

var buttons_pressed := 0
var transitioning: bool = false # Safety lock to prevent double-triggering

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# --- 1. LOSE CONDITION (Timer ran out) ---
	if minigame_timer and minigame_timer.time_left <= 0 and not transitioning:
		transitioning = true
		Global.lives -= 1
		# Keep minigames_done at 2 so if they retry, they replay Minigame 2
		Global.minigames_done = 2
		
		if Global.lives <= 0:
			get_tree().change_scene_to_file("res://scenes/death_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn")

# --- 2. CLICK HANDLER FOR YOUR BUTTONS ---
func _on_icon_pressed() -> void:
	if transitioning:
		return

	buttons_pressed += 1
	
	# WIN CONDITION (Cleared Minigame 2 -> Advance to Level 3!)
	if buttons_pressed >= 6: 
		transitioning = true
		Global.minigames_done = 3 # Set level index to 3
		
		# Send to level_scene so the player gets the "Level 3" intermission screen!
		get_tree().change_scene_to_file("res://scenes/level_scene.tscn")
