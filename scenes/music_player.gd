extends AudioStreamPlayer

func _ready() -> void:
	# Ensures music keeps playing/pausing even when get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_music()

func update_music() -> void:
	stream_paused = not Global.music_enabled
