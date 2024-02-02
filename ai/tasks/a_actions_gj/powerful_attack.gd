@tool
extends BTAction

func _tick(_delta: float) -> Status:
	if(!(agent as FirstBoss).is_done_powerful_attack):
		(agent as FirstBoss).bury()
		(agent as FirstBoss).powerful_attack((blackboard.get_data().get("player") as PlayerCharacter).global_position + (blackboard.get_data().get("player") as PlayerCharacter).velocity.normalized()*150.0)
	return SUCCESS
