extends Node2D

const FALLING_ICON_SCENE: PackedScene = preload("res://scenes/falling_icon.tscn")

var time_left: float = 10.0
var game_ended: bool = false
var game_started: bool = false
var items_collected: int = 0
var items_missed: int = 0
var target_items: int = 6
var icons_spawned: int = 0
var max_icons: int = 7

@onready var score_label: Label = $ScoreLabel
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	get_tree().paused = false
	game_started = true
	randomize()

	match Global.difficulty:
		"Easy":
			target_items = 5
			time_left = 12.0
		"Hard":
			target_items = 7
			time_left = 8.0
		_: # Normal
			target_items = 6
			time_left = 10.0

	spawn_timer.wait_time = 1.0
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	_update_score_label()
	_on_spawn_timer_timeout()

func _process(delta: float) -> void:
	if not game_started or game_ended:
		return

	if time_left > 0:
		time_left -= delta
		_update_score_label()
	else:
		game_ended = true
		time_left = 0.0
		_update_score_label()
		_on_timer_timeout()

# Call this custom function whenever your player touches a collectible node
func _on_item_collected() -> void:
	if game_ended or not game_started:
		return

	items_collected += 1
	_update_score_label()

	if items_collected >= target_items:
		game_ended = true
		spawn_timer.stop()
		Global.minigames_done += 1

		if Global.minigames_done > 4:
			call_deferred("_change_scene", "res://scenes/winner_scene.tscn")
		else:
			call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func _on_item_missed() -> void:
	if game_ended or not game_started:
		return

	items_missed += 1
	_update_score_label()

	if items_missed > max_icons - target_items:
		_on_timer_timeout()

func _on_spawn_timer_timeout() -> void:
	if game_ended or not game_started:
		return

	if icons_spawned >= max_icons:
		spawn_timer.stop()
		return

	icons_spawned += 1
	var icon := FALLING_ICON_SCENE.instantiate()
	icon.position = Vector2(randf_range(40.0, get_viewport_rect().size.x - 110.0), -80.0)
	icon.icon_caught.connect(_on_item_collected)
	icon.icon_missed.connect(_on_item_missed)
	add_child(icon)

func _update_score_label() -> void:
	score_label.text = "Caught: %d/%d\nMissed: %d\nTime: %.1f" % [items_collected, target_items, items_missed, max(time_left, 0.0)]

func _on_timer_timeout() -> void:
	if game_ended and time_left > 0:
		return

	# If the timer runs out before target_items is reached, the player loses
	game_ended = true
	spawn_timer.stop()
	Global.lives -= 1
	Global.minigames_done = 4 # Or whatever number represents minigame 4

	if Global.lives <= 0:
		call_deferred("_change_scene", "res://scenes/death_scene.tscn")
	else:
		call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func _change_scene(target_path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(target_path)
