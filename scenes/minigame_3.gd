extends Sprite2D

var score := [0, 0]
const PADDLE_SPEED : int = 500

var time_left: float = 20.0
var game_ended: bool = false
var game_started: bool = false

@onready var timer_label: Label = $HUD/TimerLabel

func _ready():
	$BallTimer.stop()
	
	score = [0, 0]
	$HUD/CPUScore.text = "0"
	$HUD/PlayerScore.text = "0"
	
	$Ball.new_ball()
	
	await get_tree().create_timer(0.2).timeout
	game_started = true

func _process(delta: float) -> void:
	if not game_ended:
		if time_left > 0:
			time_left -= delta
			timer_label.text = str(snapped(time_left, 0.1))
		else:
			game_ended = true
			time_left = 0.0
			timer_label.text = "0.0"
			_on_timer_timeout()

func _on_ball_timer_timeout():
	if not game_ended:
		$Ball.new_ball()

func _on_score_left_body_entered(body):
	if not game_started or game_ended:
		return

	score[1] += 1
	$HUD/CPUScore.text = str(score[1])
	
	if score[1] >= 1:
		game_ended = true
		Global.lives -= 1
		Global.minigames_done = 3
		
		if Global.lives <= 0:
			call_deferred("_change_scene", "res://scenes/death_scene.tscn")
		else:
			call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func _on_score_right_body_entered(body):
	if not game_started or game_ended:
		return

	score[0] += 1
	$HUD/PlayerScore.text = str(score[0])
	$BallTimer.start()

func _on_timer_timeout() -> void:
	if game_ended and time_left > 0:
		return

	game_ended = true
	Global.minigames_done += 1
	
	if Global.minigames_done > 4: 
		call_deferred("_change_scene", "res://scenes/winner_scene.tscn") 
	else:
		call_deferred("_change_scene", "res://scenes/level_scene.tscn")

func _change_scene(target_path: String) -> void:
	get_tree().change_scene_to_file(target_path)
