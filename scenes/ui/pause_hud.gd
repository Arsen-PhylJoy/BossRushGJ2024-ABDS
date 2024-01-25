extends CanvasLayer


@onready var continue_button: Button = $HSplitContainer/OptionList/ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_continue_pressed()->void:
	get_tree().paused = false
	queue_free()
