extends Node

@onready var _play_button: Button = %PlayButton
@onready var _controls_button: Button = %Controls
@onready var _exit_button: Button =  %Exit
@onready var _controls_pc: PackedScene = preload("res://scenes/ui/atomic_widgets/controls_window.tscn")

func _ready() -> void:
	StoryState.set_defaults()
	if _play_button.connect("pressed", _on_pressed_play_button): printerr("Fail: ",get_stack()) 
	if _controls_button.connect("pressed", _on_pressed_controls_window_button): printerr("Fail: ",get_stack()) 
	if _exit_button.pressed.connect(_on_exit_pressed): printerr("Fail: ",get_stack())

func _on_pressed_play_button()->void:
	SoundManager.click_sound.play()
	LevelManager.load_level("res://scenes/levels/1_prologue/1_prologue.tscn")

func _on_pressed_controls_window_button()->void:
	var controls_window: CanvasItem = _controls_pc.instantiate() as CanvasItem
	controls_window.z_index = 2
	$CanvasLayer.add_child(controls_window)

func _on_exit_pressed()->void:
	get_tree().quit()
