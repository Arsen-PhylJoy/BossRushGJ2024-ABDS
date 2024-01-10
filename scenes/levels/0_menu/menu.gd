extends Node2D

func _ready() -> void:
	$Wrapper/PlayButton.connect("pressed", _on_pressed_play_button)
	
func _on_pressed_play_button()->void:
	LevelManager.load_level("res://scenes/levels/1_prologue/prologue.tscn","fade_to_prologue")
