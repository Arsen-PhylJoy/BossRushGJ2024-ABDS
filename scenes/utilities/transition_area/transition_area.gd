extends Area2D

@export var level_to_load: String
##Default is fade_to_black
@export var transition_to_use: String

func _ready() -> void:
	connect("body_entered", _on_player_entered)
	
func _on_player_entered(body: Node2D)->void:
	if !body.is_in_group("Player"):
		return
	LevelManager.load_level(level_to_load)
