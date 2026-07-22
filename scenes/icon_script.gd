# The onreadys below run immediately at the start of the game, preventing 
# errors related to variables that haven't been defined yet in later scripts 

extends Node2D

@onready var player: CharacterBody2D = $"../Player" # grabs the parent node
@onready var self_area = $Area2D
@onready var player_area = $"../Player/Area2D"

# Updated signal name to match your icons
signal icon_collected

func _process(delta: float) -> void: # this runs EVERY FRAME! 
	
	if player_area.overlaps_area(self_area): # checks if overlapping
		if self.visible:
			emit_signal("icon_collected") # signal broadcast
			self.hide() # removed from player sight; collected

func icon_collect() -> void:
	pass # Replace with function body.
