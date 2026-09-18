extends Node2D

## Snooker Rush: the target changes with difficulty, but every shot still counts.
## This scene owns its local scoring/chances and only touches Global when a round ends.

const BALL_RADIUS := 18.0
const TABLE_LEFT := 103.0
const TABLE_RIGHT := 1097.0
const TABLE_TOP := 101.0
const TABLE_BOTTOM := 559.0
const STOP_SPEED := 9.0
const FRICTION := 245.0
const MAX_POWER := 980.0
const POCKET_MOUTH_RADIUS := 68.0
const CUE_START := Vector2(850.0, 335.0)
const POCKETS := [
	Vector2(61.0, 101.0), Vector2(576.0, 101.0), Vector2(1091.0, 101.0),
	Vector2(61.0, 579.0), Vector2(576.0, 586.0), Vector2(1091.0, 579.0),
]

@onready var cue_ball: Node2D = $Balls/CueBall
@onready var balls: Node2D = $Balls
@onready var cue_sprite: Sprite2D = $Cue
@onready var cue_line: Line2D = $CueLine
@onready var aim_line: Line2D = $AimLine
@onready var power_bar: ProgressBar = $HUD/PowerBar
@onready var score_label: Label = $HUD/ScoreLabel
@onready var chances_label: Label = $HUD/ChancesLabel
@onready var lives_label: Label = $HUD/LivesLabel
@onready var timer_label: Label = $HUD/TimerLabel
@onready var status_label: Label = $HUD/StatusLabel
@onready var start_panel: Control = $StartPanel
@onready var rules_label: Label = $StartPanel/Panel/Rules
@onready var start_button: Button = $StartPanel/Panel/StartButton

var object_balls: Array[Node2D] = []
var score := 0
var target_score := 5
var shots_left := 10
var time_left := 40.0
var charge := 0.0
var charging := false
var started := false
var round_over := false
var cue_ball_sunk := false
var waiting_for_balls := false
var cue_velocity := Vector2.ZERO
var ball_velocities: Dictionary = {}

func _ready() -> void:
	_configure_difficulty()
	_build_rack()
	_reset_cue_ball()
	_update_start_card()
	start_button.pressed.connect(_start_round)
	_update_hud()
	status_label.text = "LINE UP THE FIRST BREAK"

func _configure_difficulty() -> void:
	match Global.difficulty:
		"Easy":
			target_score = 1
			shots_left = 7
			time_left = 60.0
			_spawn_object_balls(4)
		"Hard":
			target_score = 5
			shots_left = 10
			time_left = 35.0
			_spawn_object_balls(9)
		_: # Normal
			target_score = 5
			shots_left = 67.0
			time_left = 670.0
			_spawn_object_balls(6)

func _update_start_card() -> void:
	rules_label.text = "%s mode: pot %d ball%s.\nYou have %d shots and %.0f seconds.\nHold LEFT CLICK or SPACE to build power, then release." % [
		Global.difficulty,
		target_score,
		"" if target_score == 1 else "s",
		shots_left,
		time_left,
	]

func _spawn_object_balls(count: int) -> void:
	for index in count:
		var ball := Node2D.new()
		ball.name = "ObjectBall%d" % (index + 1)
		ball.set_meta("object_ball", true)
		var sprite := Sprite2D.new()
		sprite.texture = load("res://ball_%d.png" % (index % 15 + 1))
		ball.add_child(sprite)
		balls.add_child(ball)
		object_balls.append(ball)

func _build_rack() -> void:
	var rack_origin := Vector2(360.0, 330.0)
	var ball_index := 0
	for column in 4:
		for row in column + 1:
			if ball_index >= object_balls.size():
				return
			var offset := Vector2(column * 32.0, (row - column * 0.5) * 37.0)
			object_balls[ball_index].position = rack_origin + offset
			ball_velocities[object_balls[ball_index]] = Vector2.ZERO
			ball_index += 1

func _reset_cue_ball() -> void:
	if not is_instance_valid(cue_ball):
		cue_ball = Node2D.new()
		cue_ball.name = "CueBall"
		var sprite := Sprite2D.new()
		sprite.texture = load("res://ball_16.png")
		cue_ball.add_child(sprite)
		balls.add_child(cue_ball)
	cue_ball.position = CUE_START
	cue_ball.show()
	cue_velocity = Vector2.ZERO
	ball_velocities[cue_ball] = Vector2.ZERO
	cue_ball_sunk = false

func _start_round() -> void:
	start_panel.hide()
	started = true
	status_label.text = "POT %d BALLS!" % target_score
	_pulse(status_label)

func _process(delta: float) -> void:
	if not started or round_over:
		return

	time_left = maxf(0.0, time_left - delta)
	if time_left <= 0.0:
		_finish_round(false, "TIME'S UP!")
		return

	var can_aim := not waiting_for_balls and is_instance_valid(cue_ball)
	if can_aim:
		_update_aim()
		_update_charge(delta)
	else:
		cue_line.hide()
		cue_sprite.hide()
		aim_line.hide()
	_update_hud()

func _physics_process(delta: float) -> void:
	if not started or round_over:
		return

	var moving := _advance_balls(delta)
	if waiting_for_balls and not moving:
		waiting_for_balls = false
		if cue_ball_sunk:
			if shots_left <= 0:
				_finish_round(false, "SCRATCHED ON THE LAST SHOT!")
			else:
				_reset_cue_ball()
				status_label.text = "SCRATCH! NEW CUE BALL"
				_pulse(status_label)
		elif shots_left <= 0 and score < target_score:
			_finish_round(false, "OUT OF SHOTS!")

func _update_aim() -> void:
	var direction := (get_viewport().get_mouse_position() - cue_ball.position).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.LEFT
	cue_line.show()
	cue_sprite.show()
	aim_line.show()
	cue_sprite.global_position = cue_ball.position - direction * 142.0
	cue_sprite.rotation = direction.angle()
	cue_line.points = PackedVector2Array([cue_ball.position - direction * 215.0, cue_ball.position - direction * 25.0])
	aim_line.points = PackedVector2Array([cue_ball.position + direction * 24.0, cue_ball.position + direction * 175.0])

func _update_charge(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_action_pressed("ui_accept"):
		charging = true
		charge = minf(1.0, charge + delta * 0.85)
	elif charging:
		_shoot()
	power_bar.value = charge * 100.0

func _shoot() -> void:
	if charge < 0.04 or round_over or shots_left <= 0:
		charge = 0.0
		charging = false
		return
	var direction := (get_viewport().get_mouse_position() - cue_ball.position).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.LEFT
	cue_velocity = direction * lerpf(240.0, MAX_POWER, charge)
	shots_left -= 1
	charge = 0.0
	charging = false
	waiting_for_balls = true
	cue_line.hide()
	cue_sprite.hide()
	aim_line.hide()
	status_label.text = "NICE SHOT!"
	_update_hud()

func _advance_balls(delta: float) -> bool:
	var active_balls: Array[Node2D] = []
	if is_instance_valid(cue_ball) and cue_ball.visible:
		active_balls.append(cue_ball)
	for ball in object_balls:
		if is_instance_valid(ball) and not ball.get_meta("potted", false):
			active_balls.append(ball)

	var is_moving := false
	for ball in active_balls:
		var velocity: Vector2 = cue_velocity if ball == cue_ball else ball_velocities.get(ball, Vector2.ZERO)
		if velocity.length() > STOP_SPEED:
			ball.position += velocity * delta
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			is_moving = true
		else:
			velocity = Vector2.ZERO
		if ball == cue_ball:
			cue_velocity = velocity
		else:
			ball_velocities[ball] = velocity
		if _try_pocket(ball):
			continue
		_bounce_from_cushion(ball)

	for first_index in active_balls.size():
		for second_index in range(first_index + 1, active_balls.size()):
			_resolve_ball_collision(active_balls[first_index], active_balls[second_index])
	return is_moving

func _try_pocket(ball: Node2D) -> bool:
	for pocket in POCKETS:
		if ball.position.distance_to(pocket) < 29.0:
			_pocket_ball(ball)
			return true
	return false

func _pocket_ball(ball: Node2D) -> void:
	ball_velocities.erase(ball)
	if ball == cue_ball:
		cue_ball_sunk = true
		cue_velocity = Vector2.ZERO
		ball.hide()
		return
	ball.set_meta("potted", true)
	object_balls.erase(ball)
	score += 1
	status_label.text = "BALL POTTED!  %d / %d" % [score, target_score]
	_pulse(status_label)
	var pop := create_tween()
	pop.tween_property(ball, "scale", Vector2.ZERO, 0.16)
	pop.tween_callback(ball.queue_free)
	_update_hud()
	if score >= target_score:
		_finish_round(true, "TABLE CLEARED! GREAT BREAK!")

func _bounce_from_cushion(ball: Node2D) -> void:
	var velocity: Vector2 = cue_velocity if ball == cue_ball else ball_velocities.get(ball, Vector2.ZERO)
	for pocket in POCKETS:
		if ball.position.distance_to(pocket) < POCKET_MOUTH_RADIUS:
			return
	if ball.position.x < TABLE_LEFT + BALL_RADIUS:
		ball.position.x = TABLE_LEFT + BALL_RADIUS
		velocity.x = absf(velocity.x) * 0.86
	elif ball.position.x > TABLE_RIGHT - BALL_RADIUS:
		ball.position.x = TABLE_RIGHT - BALL_RADIUS
		velocity.x = -absf(velocity.x) * 0.86
	if ball.position.y < TABLE_TOP + BALL_RADIUS:
		ball.position.y = TABLE_TOP + BALL_RADIUS
		velocity.y = absf(velocity.y) * 0.86
	elif ball.position.y > TABLE_BOTTOM - BALL_RADIUS:
		ball.position.y = TABLE_BOTTOM - BALL_RADIUS
		velocity.y = -absf(velocity.y) * 0.86
	if ball == cue_ball:
		cue_velocity = velocity
	else:
		ball_velocities[ball] = velocity

func _resolve_ball_collision(first: Node2D, second: Node2D) -> void:
	if not is_instance_valid(first) or not is_instance_valid(second) or not first.visible or not second.visible:
		return
	if first.get_meta("potted", false) or second.get_meta("potted", false):
		return
	var separation := second.position - first.position
	var distance := separation.length()
	if distance <= 0.0 or distance >= BALL_RADIUS * 2.0:
		return
	var normal := separation / distance
	var overlap := BALL_RADIUS * 2.0 - distance
	first.position -= normal * overlap * 0.5
	second.position += normal * overlap * 0.5
	var first_velocity: Vector2 = cue_velocity if first == cue_ball else ball_velocities.get(first, Vector2.ZERO)
	var second_velocity: Vector2 = cue_velocity if second == cue_ball else ball_velocities.get(second, Vector2.ZERO)
	var relative_speed := (first_velocity - second_velocity).dot(normal)
	if relative_speed <= 0.0:
		return
	var impulse := normal * (relative_speed * 0.96)
	first_velocity -= impulse
	second_velocity += impulse
	if first == cue_ball:
		cue_velocity = first_velocity
	else:
		ball_velocities[first] = first_velocity
	if second == cue_ball:
		cue_velocity = second_velocity
	else:
		ball_velocities[second] = second_velocity

func _update_hud() -> void:
	score_label.text = "POTTED  %d / %d" % [score, target_score]
	chances_label.text = "SHOTS  %d" % shots_left
	lives_label.text = "LIVES  %d" % Global.lives
	timer_label.text = "%.1f" % time_left
	power_bar.value = charge * 100.0

func _pulse(label: Label) -> void:
	var tween := create_tween()
	tween.tween_property(label, "scale", Vector2(1.14, 1.14), 0.09)
	tween.tween_property(label, "scale", Vector2.ONE, 0.16)

func _finish_round(won: bool, message: String) -> void:
	if round_over:
		return
	round_over = true
	charging = false
	status_label.text = message
	_pulse(status_label)
	if won:
		Global.minigames_done += 1
	else:
		Global.lives = max(0, Global.lives - 1)
		Global.minigames_done = 5
	await get_tree().create_timer(1.15).timeout
	if won and Global.minigames_done > 5:
		get_tree().change_scene_to_file("res://scenes/winner_scene.tscn")
	elif Global.lives <= 0:
		get_tree().change_scene_to_file("res://scenes/death_scene.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/level_scene.tscn")
