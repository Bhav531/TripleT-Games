extends Node2D

# Grabs the RichTextLabel node we named "timer"
@onready var timer: RichTextLabel = $timer

# Set our starting time to 6.7 seconds
var time_left: float = 6.7
var timer_ended: bool = false

func _process(delta: float) -> void:
	# This runs every single frame
	if time_left > 0:
		time_left -= delta
		# Updates the text to show the time with 1 decimal place (e.g., "6.7")
		timer.text = str("%.1f" % time_left)
	elif not timer_ended:
		# What happens when it hits 0
		time_left = 0
		timer.text = "0.0"
		timer_ended = true
		
		print("Time's up!")
		# Put your game over or transition code right here!
