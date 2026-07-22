extends Node2D

var icon_collected = 0 # tracking how many icons collected
var time_left: float = 6.7 # 6.7 second countdown for the minigame
var transitioning: bool = false # Safety lock to stop multiple scene changes on the same frame

func _ready() -> void:
	pass 

func _process(delta: float) -> void: 
	# --- 1. COUNTDOWN TIMER (Runs every frame) ---
	if time_left > 0 and not transitioning:
		time_left -= delta
	elif time_left <= 0 and not transitioning:
		# --- 2. LOSE CONDITION (Time ran out) ---
		transitioning = true # Lock it so this code only runs once!
		Global.minigames_done -= 1 # go back a minigame index
		Global.lives -= 1 # lose a life
		
		# Check if lives are completely gone
		if Global.lives <= 0:
			get_tree().change_scene_to_file("res://scenes/death_scene.tscn")
		else:
			# Otherwise, take them back to the intermission/level scene
			get_tree().change_scene_to_file("res://scenes/level_scene.tscn")

	# --- 3. WIN CONDITION (Got the 3 icons!) ---
	if icon_collected >= 3 and not transitioning: 
		transitioning = true # Lock it so it doesn't trigger multiple times
		Global.minigames_done = Global.minigames_done + 1
		
		if Global.minigames_done > 3: 
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn") 
		else:
			# Dynamically loads minigame_2, minigame_3, etc.!
			get_tree().change_scene_to_file("res://scenes/minigame_" + str(Global.minigames_done) + ".tscn") 

func icon_collect() -> void: # function connected to your icon pickups
	icon_collected = icon_collected + 1
