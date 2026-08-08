extends Area2D

signal icon_caught
signal icon_missed

var speed: float = 350.0
var is_collected: bool = false

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
	
	emit_signal("icon_caught")
	hide()
	queue_free()
