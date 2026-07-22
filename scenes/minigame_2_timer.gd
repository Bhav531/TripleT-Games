extends Node2D

@onready var timer_label: Label = $timer_label

var time_left: float = 7.0
var timer_running: bool = true

func _process(delta: float) -> void:
	if not timer_running:
		return
		
	if time_left > 0:
		time_left -= delta
		timer_label.text = str(snapped(time_left, 0.1))
	else:
		time_left = 0
		timer_running = false

func reset_timer(new_time: float) -> void:
	time_left = new_time
	timer_running = true
