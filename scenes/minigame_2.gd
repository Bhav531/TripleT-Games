extends Node2D

var time_left: float = 8.0
var game_ended: bool = false
var game_started: bool = false
var icons_clicked: int = 0
const TARGET_ICONS: int = 6

@onready var timer_label: Label = $minigame_2_timer/timer_label
@onready var timer_node: Node2D = $minigame_2_timer
@onready var instructions_ui: CanvasLayer = $InstructionsUI
@onready var panel: Panel = $InstructionsUI/Panel
@onready var close_button: Button = $InstructionsUI/Panel/CloseButton

func _ready() -> void:
	get_tree().paused = true
	timer_node.set_process(false)
	instructions_ui.show()
	panel.modulate = Color(1.4, 1.4, 1.4, 0.95)
	
	match Global.difficulty:
		"Easy":
			time_left = 10.0
		"Hard":
			time_left = 5.0
		_: # Normal
			time_left = 8.0
			
	close_button.pressed.connect(_on_close_button_pressed)

func _on_close_button_pressed() -> void:
	instructions_ui.hide()
	get_tree().paused = false
	await get_tree().process_frame
	game_started = true

func _process(delta: float) -> void:
	if not game_started or game_ended:
		return

	if time_left > 0:
		time_left -= delta
		timer_label.text = str(snapped(time_left, 0.1))
	else:
		game_ended = true
		time_left = 0.0
		timer_label.text = "0.0"
		_on_timer_timeout()

func _on_icon_pressed() -> void:
	if game_ended or not game_started:
		return

	icons_clicked += 1

	if icons_clicked >= TARGET_ICONS:
		game_ended = true
		Global.minigames_done += 1
		
		if Global.minigames_done > 4:
			call_deferred("_change_scene", "res://scenes/winner_scene.tscn")
		else:
			call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func _on_timer_timeout() -> void:
	if game_ended and time_left > 0:
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
