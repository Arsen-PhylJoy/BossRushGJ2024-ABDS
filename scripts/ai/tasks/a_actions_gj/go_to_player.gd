@tool
extends BTAction

func _enter()->void:
	(agent as FirstBoss).velocity = Vector2(0,0)
	(agent as FirstBoss).speed = (agent as FirstBoss).default_speed
	

func _tick(_delta: float) -> Status:
		(agent as FirstBoss).un_bury()
		(agent as FirstBoss).set_movement_target((blackboard.get_data().get("player") as PlayerCharacter).global_position)
		return RUNNING
