extends Node2D

func  _ready() -> void:
	$ContinueButton.connect("pressed",_on_continue_pressed)
	
func _on_continue_pressed() -> void:
	LevelManager.load_level("res://scenes/levels/2_acquaintance_with_artifact/acquaintance_with_artifact.tscn")
	
