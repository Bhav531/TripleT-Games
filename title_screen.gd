extends Node2D

@onready var start_button: Button = $VBoxContainer/Start
@onready var quit_button: Button = $VBoxContainer/Quit

func _ready() -> void:
	get_tree().paused = false
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_button_pressed() -> void:
	Global.lives = 5
	Global.minigames_done = 0
	get_tree().change_scene_to_file("res://scenes/settings_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
