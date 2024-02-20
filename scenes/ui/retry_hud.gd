extends CanvasLayer


@onready var _retry_button: Button = %RetryButton
@onready var _load_level_path: String

func _ready() -> void:
	if (self as Node).tree_exiting.connect(_on_free): printerr("Fail: ",get_stack())
	if _retry_button.pressed.connect(_on_retry_pressed): printerr("Fail: ",get_stack())
	get_tree().paused = true

func _on_continue_pressed()->void:
	get_tree().paused = false
	queue_free()

func _on_retry_pressed()->void:
	LevelManager.load_level("res://scenes/levels/2_boss_fight/2_boss_fight.tscn")

func _on_exit_pressed()->void:
	get_tree().quit()

func _on_free()->void:
	get_tree().paused = false
