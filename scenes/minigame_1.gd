extends Node2D

var game_ended: bool = false
var game_started: bool = false
var icons_collected: int = 0
const TARGET_ICONS: int = 4

@onready var instructions_ui: CanvasLayer = find_child("InstructionsUI", true, false)

func _ready() -> void:
	get_tree().paused = true
	_connect_icon_signals()
	
	if instructions_ui:
		instructions_ui.show()
		var close_btn = instructions_ui.find_child("CloseButton", true, false)
		if close_btn and not close_btn.pressed.is_connected(_on_close_button_pressed):
			close_btn.pressed.connect(_on_close_button_pressed)

func _connect_icon_signals() -> void:
	for icon in get_children():
		if icon and icon.has_signal(&"icon_collected") and not icon.is_connected(&"icon_collected", collect_icon):
			icon.connect(&"icon_collected", collect_icon)

func _on_close_button_pressed() -> void:
	if instructions_ui:
		instructions_ui.hide()
	get_tree().paused = false
	await get_tree().process_frame
	game_started = true

func collect_icon() -> void:
	if game_ended or not game_started:
		return
		
	icons_collected += 1
	
	if icons_collected >= TARGET_ICONS:
		game_win()

func game_win() -> void:
	if game_ended or not game_started:
		return
	game_ended = true
	Global.minigames_done += 1
	
	if Global.minigames_done >= 4:
		call_deferred("_change_scene", "res://scenes/winner_scene.tscn")
	else:
		call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func game_failed() -> void:
	if game_ended or not game_started:
		return
	game_ended = true
	Global.lives -= 1
	
	if Global.lives <= 0:
		call_deferred("_change_scene", "res://scenes/death_scene.tscn")
	else:
		call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func _change_scene(target_path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(target_path)
