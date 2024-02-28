extends CanvasLayer


@onready var _continue_button: Button = %Continue
@onready var _controls_button: Button = %OpenControls
@onready var _exit_button: Button =  %ExitGame
@onready var _controls_pc: PackedScene = preload("res://scenes/ui/atomic_widgets/controls_window.tscn")

func _ready() -> void:
	if (self as Node).tree_exiting.connect(_on_free): printerr("Fail: ",get_stack())
	if _continue_button.pressed.connect(_on_continue_pressed): printerr("Fail: ",get_stack())
	if _controls_button.pressed.connect( _on_pressed_controls_window_button): printerr("Fail: ",get_stack()) 
	if _exit_button.pressed.connect(_on_exit_pressed): printerr("Fail: ",get_stack()) 
	get_tree().paused = true

func _on_continue_pressed()->void:
	get_tree().paused = false
	queue_free()

func _on_pressed_controls_window_button()->void:
	var controls_window: CanvasItem = _controls_pc.instantiate() as CanvasItem
	controls_window.z_index = 2
	$".".add_child(controls_window)

func _on_exit_pressed()->void:
	get_tree().quit()

func _on_free()->void:
	get_tree().paused = false
