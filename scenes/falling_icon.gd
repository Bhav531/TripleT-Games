extends Area2D

signal icon_caught
signal icon_missed

var speed: float = 150
var is_collected: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.y += speed * delta
	
	if position.y > 700:
		emit_signal("icon_missed")
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.name == "PlayerArea" or area.get_parent().name == "Player":
		_collect()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		_collect()

func _collect() -> void:
	if is_collected:
		return
	is_collected = true

	set_process(false)
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	emit_signal("icon_caught")

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 32.0, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "scale", sprite.scale * 1.35, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "rotation_degrees", 18.0, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
