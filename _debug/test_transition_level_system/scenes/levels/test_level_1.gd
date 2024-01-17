extends Node2D

func _ready() -> void:
	$Button.connect("pressed",on_go_to_menu_pressed)
	
func on_go_to_menu_pressed()->void:
	LevelManager.load_level("res://_debug/test_transition_level_system/scenes/levels/test_menu.tscn")
