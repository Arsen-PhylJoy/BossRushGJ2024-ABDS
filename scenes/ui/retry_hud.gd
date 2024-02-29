extends CanvasLayer


@onready var _retry_button: Button = %RetryButton
@onready var _exit_button: Button = %ExitMenu

func _ready() -> void:
	if _retry_button.pressed.connect(_on_retry_pressed): printerr("Fail: ",get_stack())
	if _exit_button.pressed.connect(_exit_button_pressed): printerr("Fail: ",get_stack())
	get_tree().paused = true

func _on_retry_pressed()->void:
	LevelManager.load_level("res://scenes/levels/2_boss_fight/2_boss_fight.tscn")
	get_tree().paused = false
	queue_free()

func _exit_button_pressed()->void:
	LevelManager.load_level("res://scenes/levels/0_menu/0_menu.tscn")
	get_tree().paused = false
	queue_free()
