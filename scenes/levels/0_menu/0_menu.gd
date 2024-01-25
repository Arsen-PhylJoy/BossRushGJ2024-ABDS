extends Node

@onready var play_button: Button = $CanvasLayer/Wrapper/PlayButton


func _ready() -> void:
	if play_button.connect("pressed", _on_pressed_play_button): printerr("Fail: ",get_stack()) 

func _on_pressed_play_button()->void:
	LevelManager.load_level("res://scenes/levels/1_prologue/1_prologue.tscn")
