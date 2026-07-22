extends Node2D

@onready var minigame_timer = $minigame_2_timer

var buttons_pressed := 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# --- 1. LOSE CONDITION (Timer ran out -> Death Screen) ---
	if minigame_timer and minigame_timer.time_left <= 0:
		Global.lives -= 1
		Global.minigames_done -= 1
		
		# If lives hit 0, go to death screen, otherwise go to level selection/intermission
		if Global.lives <= 0:
			get_tree().change_scene_to_file("res://scenes/death_scene.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn")

# --- 2. CLICK HANDLER FOR YOUR BUTTONS ---
func _on_icon_pressed() -> void:
	buttons_pressed += 1
	
	# WIN CONDITION (Completed Minigame 2 -> Winner Screen!)
	if buttons_pressed >= 6: 
		get_tree().change_scene_to_file("res://scenes/winner_scene.tscn")
