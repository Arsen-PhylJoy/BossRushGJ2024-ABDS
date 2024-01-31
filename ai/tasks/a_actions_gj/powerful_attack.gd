@tool
extends BTAction

func _tick(_delta: float) -> Status:
	(agent as FirstBoss).bury()
	if((agent as FirstBoss)._is_buried):
		(agent as FirstBoss).powerful_attack()
		return SUCCESS
	return FAILURE
