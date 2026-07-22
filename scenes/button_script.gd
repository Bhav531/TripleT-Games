extends TextureButton

func _ready() -> void:
	# Connects this button's press event to make it hide itself instantly
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	hide() # Hides the icon from the screen immediately!
	# Alternatively, use queue_free() if you want to completely delete it from memory:
	# queue_free()
