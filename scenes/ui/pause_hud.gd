extends CanvasLayer


@onready var _continue_button: Button = %ContinueButton
@onready var _controls_button: Button = %ControlsWindowButton
@onready var _exit_button: Button =  %Exit
@onready var _controls_pc: PackedScene = preload("res://scenes/ui/controls_window.tscn")

func _ready() -> void:
	if _controls_button.connect("pressed", _on_pressed_controls_window_button): printerr("Fail: ",get_stack()) 
	if _continue_button.pressed.connect(_on_continue_pressed): printerr("Fail: ",get_stack())
	if _exit_button.pressed.connect(_on_exit_pressed): printerr("Fail: ",get_stack()) 
	get_tree().paused = true

func _on_continue_pressed()->void:
	BossRushUtility.play_click_sound()
	get_tree().paused = false
	queue_free()

func _on_pressed_controls_window_button()->void:
	BossRushUtility.play_click_sound()
	var controls_window: CanvasItem = _controls_pc.instantiate() as CanvasItem
	controls_window.z_index = 2
	$".".add_child(controls_window)

func _on_exit_pressed()->void:
	BossRushUtility.play_click_sound()
	get_tree().quit()
