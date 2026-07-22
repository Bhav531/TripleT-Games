extends Node2D

func _on_retry_pressed() -> void:
	# 1. CRITICAL: Unpause the game so inputs and buttons start working again!
	get_tree().paused = false
	
	# 2. Reset global stats back to fresh starting values
	Global.lives = 5
	Global.minigames_done = 0
	
	# 3. Go back to the title screen cleanly
	get_tree().change_scene_to_file("res://scenes/title_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
