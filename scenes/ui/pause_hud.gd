extends CanvasLayer


@onready var continue_button: Button = $HSplitContainer/OptionList/ContinueButton

func _ready() -> void:
	if continue_button.pressed.connect(_on_continue_pressed): printerr("Fail: ",get_stack()) 
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_continue_pressed()->void:
	get_tree().paused = false
	queue_free()
