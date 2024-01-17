extends Node

@export var player: PackedScene
@export var player_start_position: Vector2
@export var boss: PackedScene
@export var boss_start_position: Vector2


func _ready()->void:
	var player_instance:Node2D = player.instantiate()
	var boss_instance:Node2D = boss.instantiate()
	
	add_child(player_instance)
	add_child(boss_instance)
