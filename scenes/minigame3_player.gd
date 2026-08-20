extends StaticBody2D

var win_height : int
var p_height : int


func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y


func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += get_parent().PADDLE_SPEED * delta
		
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
