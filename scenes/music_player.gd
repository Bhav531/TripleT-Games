extends AudioStreamPlayer

func _ready() -> void:
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_music()

func update_music() -> void:
	stream_paused = not Global.music_enabled
	volume_db = linear_to_db(maxf(Global.music_volume, 0.001))
