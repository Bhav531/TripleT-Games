extends TextureButton

func _pressed() -> void:
	var main_scene = get_tree().current_scene
	
	if main_scene.has_method("target_clicked"):
		main_scene.target_clicked()
		
	hide()
	queue_free()
