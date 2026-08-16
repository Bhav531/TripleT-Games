extends Node2D

@onready var timer: RichTextLabel = $timer

var time_left: float = 10.00
var timer_ended: bool = false

func _process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		timer.text = str("%.1f" % time_left)
	elif not timer_ended:
		time_left = 0
		timer.text = "0.0"
		timer_ended = true
