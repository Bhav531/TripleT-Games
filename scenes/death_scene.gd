extends Node2D

func _on_retry_pressed() -> void:
	# 1. Reset all lives and progress completely back to start!
	Global.lives = 5       # (or whatever your max starting lives are)
	Global.minigames_done = 0
	
	# 2. Go back to the title screen or level selection
	get_tree().change_scene_to_file("res://scenes/title_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
