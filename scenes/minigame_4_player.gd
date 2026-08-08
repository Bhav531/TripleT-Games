extends CharacterBody2D

const SPEED = 500.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# This stops the player from walking off the edges of the screen
	var view_size = get_viewport_rect().size
	position.x = clamp(position.x, 32.0, view_size.x - 32.0)
