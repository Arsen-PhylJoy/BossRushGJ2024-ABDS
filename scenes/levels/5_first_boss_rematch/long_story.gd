extends Node2D

func _ready() -> void:
	$ContinueButton.connect("pressed", _on_continue_pressed)
	
func _on_continue_pressed() -> void:
	LevelManager.load_level("res://scenes/levels/6_chamber_before_last_boss/chamber_before_last_boss.tscn")
