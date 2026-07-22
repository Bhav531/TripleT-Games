extends Node2D

func _on_retry_pressed() -> void:
	# 1. Unpause the game just in case it was paused
	get_tree().paused = false
	
	# 2. Fully reset your global stats
	Global.lives = 5
	Global.minigames_done = 0
	
	# 3. Jump straight back into the first minigame (bypassing the title screen completely!)
	get_tree().change_scene_to_file("res://scenes/level_scene.tscn")
	# (Note: If your game starts at level_scene.tscn instead, change minigame_1.tscn to level_scene.tscn)

func _on_quit_pressed() -> void:
	get_tree().quit()
