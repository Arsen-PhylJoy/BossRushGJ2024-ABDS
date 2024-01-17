extends Node2D

func _ready() -> void:
	$Button.connect("pressed",_on_go_to_level_pressed)
	
	
func _on_go_to_level_pressed()->void:
	LevelManager.load_level("res://_debug/test_transition_level_system/scenes/levels/test_level_1.tscn")
