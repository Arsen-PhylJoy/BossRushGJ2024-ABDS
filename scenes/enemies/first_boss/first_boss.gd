extends CharacterBody2D

var _player_reference: Node2D

func _ready() -> void:
	get_scene
	_player_reference = node;
