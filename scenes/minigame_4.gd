extends Node2D

var falling_icon_scene = preload("res://scenes/falling_icon.tscn")

var total_spawned: int = 0
var collected: int = 0
var missed: int = 0
var transitioning: bool = false

@onready var score_label: Label = $ScoreLabel
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	update_hud()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start(4.0) 

func _on_spawn_timer_timeout() -> void:
	if total_spawned >= 7:
		spawn_timer.stop()
		return

	var icon_instance = falling_icon_scene.instantiate()
	
	var screen_width = get_viewport_rect().size.x
	var random_x = randf_range(50.0, screen_width - 50.0)
	icon_instance.position = Vector2(random_x, -50) 
	
	icon_instance.icon_caught.connect(_on_icon_caught)
	icon_instance.icon_missed.connect(_on_icon_missed)
	
	add_child(icon_instance)
	total_spawned += 1

func _on_icon_caught() -> void:
	if transitioning:
		return
		
	collected += 1
	update_hud()
	check_game_state()

func _on_icon_missed() -> void:
	if transitioning:
		return
		
	missed += 1
	check_game_state()

func update_hud() -> void:
	score_label.text = "Tung Icons: " + str(collected) + " / 7 (Need 6)"

func check_game_state() -> void:
	if missed > 1 and not transitioning:
		transitioning = true
		spawn_timer.stop()
		Global.lives -= 1
		Global.minigames_done = 4
		
		if Global.lives <= 0:
			call_deferred("_change_scene", "res://scenes/death_scene.tscn")
		else:
			call_deferred("_change_scene", "res://scenes/level_scene.tscn")

	elif collected >= 6 and not transitioning:
		transitioning = true
		spawn_timer.stop()
		Global.minigames_done += 1
		
		if Global.lives >= 1:
			call_deferred("_change_scene", "res://scenes/winner_scene.tscn")
		else:
			call_deferred("_change_scene", "res://scenes/death_scene.tscn")

func _change_scene(target_path: String) -> void:
	get_tree().change_scene_to_file(target_path)
