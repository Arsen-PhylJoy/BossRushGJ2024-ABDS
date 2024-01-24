extends Node

func _ready() -> void:
	$CanvasLayer/Wrapper/PlayButton.connect("pressed", _on_pressed_play_button)
	
func _on_pressed_play_button()->void:
	LevelManager.load_level("res://scenes/levels/level_1/level_1.tscn","fade_to_prologue")
