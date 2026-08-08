extends Node2D

@onready var icon_container: HBoxContainer = $IconHolder
@onready var icon: TextureRect = $IconHolder/Icon
@onready var icon_2: TextureRect = $IconHolder/Icon2
@onready var icon_3: TextureRect = $IconHolder/Icon3
@onready var icon_4: TextureRect = $IconHolder/Icon4
@onready var icon_5: TextureRect = $IconHolder/Icon5

@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer

var time: float = 0.0

func _ready() -> void:
	await start_countdown(5.0) 
	
	if Global.minigames_done < 1:
		Global.minigames_done = 1
	
	if Global.minigames_done <= 4: 
		var next_scene_path = "res://scenes/minigame_" + str(Global.minigames_done) + ".tscn"
		
		if ResourceLoader.exists(next_scene_path):
			get_tree().change_scene_to_file(next_scene_path)
		else:
			print("ERROR: Scene file not found at path: ", next_scene_path)
	else:
		get_tree().change_scene_to_file("res://scenes/winner_scene.tscn") 

func _process(delta: float) -> void: 
	match Global.lives: 
		4:
			icon.hide()
		3:
			icon.hide()
			icon_2.hide()
		2:
			icon.hide()
			icon_2.hide()
			icon_3.hide()
		1:
			icon.hide()
			icon_2.hide()
			icon_3.hide()
			icon_4.hide()
		0:
			icon_container.hide()
	
	timer.text = str(snapped(time, 0.1)) 
	level.text = "Level " + str(Global.minigames_done) 

func start_countdown(start_time: float): 
	time = start_time 
	
	while time > 0.0: 
		await get_tree().create_timer(0.1).timeout 
		time = max(0.0, time - 0.1)
	
	time = 0.0
