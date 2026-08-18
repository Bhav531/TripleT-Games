extends Control

@onready var difficulty_button: OptionButton = $VBoxContainer/DifficultyBox/DifficultyButton
@onready var music_toggle: CheckButton = $VBoxContainer/MusicBox/MusicToggle
@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var back_button: Button = $VBoxContainer/Back

func _ready() -> void:
	difficulty_button.clear()
	difficulty_button.add_item("Easy")
	difficulty_button.add_item("Normal")
	difficulty_button.add_item("Hard")

	match Global.difficulty:
		"Easy":
			difficulty_button.select(0)
		"Normal":
			difficulty_button.select(1)
		"Hard":
			difficulty_button.select(2)

	music_toggle.button_pressed = Global.music_enabled

	difficulty_button.item_selected.connect(_on_difficulty_selected)
	music_toggle.toggled.connect(_on_music_toggled)
	play_button.pressed.connect(_on_play_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _on_difficulty_selected(index: int) -> void:
	Global.difficulty = difficulty_button.get_item_text(index)

func _on_music_toggled(toggled_on: bool) -> void:
	Global.music_enabled = toggled_on
	if has_node("/root/MusicPlayer"):
		MusicPlayer.update_music()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_scene.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
