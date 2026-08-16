extends Node2D

var targets_clicked: int = 0
var total_targets: int = 6
var time_left: float = 10.0
var game_started: bool = false
var transitioning: bool = false

@onready var timer_label: Label = $TimerLabel
@onready var instructions_ui: CanvasLayer = $InstructionsUI
@onready var close_button: Button = $InstructionsUI/Panel/CloseButton

func _ready() -> void:
	get_tree().paused = true
	instructions_ui.show()
	close_button.pressed.connect(_on_close_button_pressed)

func _on_close_button_pressed() -> void:
	instructions_ui.hide()
	get_tree().paused = false
	game_started = true

func _process(delta: float) -> void:
	if not game_started or transitioning:
		return

	if time_left > 0:
		time_left -= delta
		if timer_label:
			timer_label.text = str(snapped(time_left, 0.1))
	else:
		transitioning = true
		Global.lives -= 1
		Global.minigames_done = 2
		
		if Global.lives <= 0:
			call_deferred("_change_scene", "res://scenes/death_scene.tscn")
		else:
			call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func target_clicked() -> void:
	if transitioning or not game_started:
		return
		
	targets_clicked += 1
	
	if targets_clicked >= total_targets and not transitioning:
		transitioning = true
		Global.minigames_done = 3
		call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func _change_scene(target_path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(target_path)
