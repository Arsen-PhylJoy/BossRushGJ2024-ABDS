extends CanvasLayer


@onready var _retry_button: Button = %RetryButton
@onready var _load_level_path: String

func _ready() -> void:
	if _retry_button.pressed.connect(_on_retry_pressed): printerr("Fail: ",get_stack())
	get_tree().paused = true

func _on_retry_pressed()->void:
	LevelManager.load_level("res://scenes/levels/2_boss_fight/2_boss_fight.tscn")
	get_tree().paused = false
	queue_free()
