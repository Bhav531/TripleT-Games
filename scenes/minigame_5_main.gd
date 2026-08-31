extends Node

@export var ball_scene : PackedScene

var ball_images := []
var cue_ball
const START_POS := Vector2(820, 340)
const MAX_POWER := 8.0
var taking_shot : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the shoot signal in code
	if has_node("../Cue"):
		$"../Cue".shoot.connect(_on_cue_shoot)
		
	load_images()
	new_game()
	
func load_images():
	for i in range(1, 17, 1):
		var filename = str("res://ball_", i, ".png")
		var ball_image = load(filename)
		ball_images.append(ball_image)

func new_game():
	generate_balls()
	reset_cue_ball()
	show_cue()

func generate_balls():
	#setup game balls
	var count : int = 0
	var rows : int = 5
	var dia = 36
	for col in range(5):
		for row in range(rows):
			var b = ball_scene.instantiate()
			var pos = Vector2(250 + (col * (dia)), 267 + (row * (dia)) + (col * dia / 2))
			add_child(b)
			b.position = pos
			
			# Disable gravity on this ball directly
			if "gravity_scale" in b:
				b.gravity_scale = 0
				
			if b.has_node("Sprite2D"):
				b.get_node("Sprite2D").texture = ball_images[count]
				count += 1
		rows -= 1

func reset_cue_ball():
	cue_ball = ball_scene.instantiate()
	add_child(cue_ball)
	cue_ball.position = START_POS
	
	if "gravity_scale" in cue_ball:
		cue_ball.gravity_scale = 0
		
	cue_ball.get_node("Sprite2D").texture = ball_images.back()
	taking_shot = false	
	
	
func show_cue():
	$"../Cue".position = cue_ball.position	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var moving := false
	

func _on_cue_shoot(power):
	cue_ball.apply_central_impulse(power)
