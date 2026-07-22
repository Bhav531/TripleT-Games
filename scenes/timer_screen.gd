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
	# Using the renamed function so it doesn't break Godot!
	await start_countdown(5.0) 
	
	if Global.minigames_done < 3: 
		Global.minigames_done = Global.minigames_done + 1 
		get_tree().change_scene_to_file("res://scenes/minigame_" + str(Global.minigames_done) + ".tscn") 
	else:
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn") 
	
func _process(delta: float) -> void: 
	# Now using the new "icon" variables to hide them when you lose lives
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
			icon_container.hide() # Hides the whole container if out of lives
	
	timer.text = str(snapped(time, 0.1)) 
	level.text = "Level " + str(Global.minigames_done) 

# Renamed this from "Timer" to "start_countdown"
# The cleaner, bug-free countdown function
func start_countdown(start_time: float): 
	time = start_time 
	
	while time > 0.0: 
		# We put the timer directly in here instead of using a separate wait() function
		await get_tree().create_timer(0.1).timeout 
		time -= 0.1
