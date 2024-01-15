extends Node

@export var player: PackedScene
@export var player_start_position: Vector2
@export var boss: PackedScene
@export var boss_start_position: Vector2


func _ready():
	var player_instance = player.instantiate()
	var boss_instance = boss.instantiate()
	
	add_child(player_instance)
	add_child(boss_instance)
