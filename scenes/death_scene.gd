extends Node2D

func _on_retry_pressed() -> void:

	get_tree().paused = false
	

	Global.lives = 5
	Global.minigames_done = 0
	
	
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	

func _on_quit_pressed() -> void:
	get_tree().quit()
