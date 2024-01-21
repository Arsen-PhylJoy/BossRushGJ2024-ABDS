@tool
extends BTAction

func _tick(_delta: float) -> Status:
	(agent as FirstBoss).set_movement_target(Vector2(randf_range(-1000,1000),randf_range(-1000,1000)) +(agent as FirstBoss).global_position)
	return SUCCESS
