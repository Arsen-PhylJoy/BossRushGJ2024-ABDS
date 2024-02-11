extends Button



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (self as Button).pressed.connect(_on_gj_button_pressed): printerr("Fail: ",get_stack())

func _on_gj_button_pressed()->void:
	SoundManager.click_sound.play()
