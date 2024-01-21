@tool
extends BTAction

func _enter()->void:
	(agent as CharacterBody2D).velocity = Vector2(0,0)

func _tick(_delta: float) -> Status:
	(agent as FirstBoss).set_movement_target((blackboard.get_data().get("player") as CharacterBody2D).global_position)
	return RUNNING
