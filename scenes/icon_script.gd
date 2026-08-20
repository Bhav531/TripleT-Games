extends Node2D

@onready var self_area = $Area2D
@onready var player_area = $"../Player/Area2D"
@onready var icon_sprite: TextureRect = $icon

signal icon_collected

var is_collected: bool = false
var float_tween: Tween

func _ready() -> void:
	float_tween = create_tween()
	float_tween.set_loops()
	float_tween.tween_property(self, "position:y", position.y - 8.0, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	float_tween.tween_property(self, "position:y", position.y + 8.0, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _process(_delta: float) -> void:
	if player_area.overlaps_area(self_area):
		if not is_collected:
			is_collected = true
			emit_signal("icon_collected")
			await _play_collect_effect()

func _play_collect_effect() -> void:
	set_process(false)
	self_area.set_deferred("monitoring", false)
	self_area.set_deferred("monitorable", false)
	if float_tween:
		float_tween.kill()

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 34.0, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(icon_sprite, "scale", icon_sprite.scale * 1.3, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(icon_sprite, "rotation", 0.16, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	hide()
