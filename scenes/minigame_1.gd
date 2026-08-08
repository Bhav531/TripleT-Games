extends Node2D

var icon_collected: int = 0
var time_left: float = 4.67
var transitioning: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if time_left > 0 and not transitioning:
		time_left -= delta
	elif time_left <= 0 and not transitioning:
		transitioning = true
		Global.lives -= 1
		Global.minigames_done = 1
		
		if Global.lives <= 0:
			call_deferred("_change_scene", "res://scenes/death_scene.tscn")
		else:
			call_deferred("_change_scene", "res://scenes/level_scene.tscn")

	if icon_collected >= 3 and not transitioning:
		transitioning = true
		Global.minigames_done = 2
		call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func icon_collect() -> void:
	icon_collected += 1

func _change_scene(target_path: String) -> void:
	get_tree().change_scene_to_file(target_path)
