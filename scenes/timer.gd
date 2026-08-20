extends Node2D

var time_left: float = 9.0
var timer_active: bool = true

func _ready() -> void:
	match Global.difficulty:
		"Easy":
			time_left = 15.0
		"Hard":
			time_left = 7.6
		_: # Medium / Normal
			time_left = 12.0

func _process(delta: float) -> void:
	if not timer_active:
		return

	if time_left > 0:
		time_left -= delta
		for child in get_children():
			if child is RichTextLabel or child is Label:
				child.text = str(snapped(time_left, 0.1))
	else:
		time_left = 0.0
		timer_active = false
		for child in get_children():
			if child is RichTextLabel or child is Label:
				child.text = "0.0"
		
		var parent = get_parent()
		var owner_node = get_owner()
		if owner_node and owner_node.has_method("game_failed"):
			owner_node.game_failed()
		elif parent and parent.has_method("game_failed"):
			parent.game_failed()
