extends Node2D

func _ready() -> void:
	# Ensure the game is fully unpaused whenever the title screen loads
	get_tree().paused = false

func _process(delta: float) -> void:
	pass

# Called when your Start button is clicked
func _on_start_pressed() -> void:
	# 1. Reset global stats back to fresh starting values
	Global.lives = 5
	Global.minigames_done = 0
	
	# 2. Jump back into the start of your game loop
	get_tree().change_scene_to_file("res://scenes/level_scene.tscn")

# Called when your Quit button is clicked
func _on_quit_pressed() -> void:
	get_tree().quit()
