extends Area2D

@export var level_to_load: String
##Default is fade_to_black
@export var transition_to_use: String

func _ready() -> void:
	connect("body_entered", _on_player_entered)
	
func _on_player_entered(bode: Node2D)->void:
	LevelManager.load_level(level_to_load)
