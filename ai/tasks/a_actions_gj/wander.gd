@tool
extends BTAction

func _tick(_delta: float) -> Status:
	(agent as FirstBoss).set_movement_target(Vector2(randf_range(-50,50),randf_range(-50,50)) +(agent as FirstBoss).global_position)
	return SUCCESS
