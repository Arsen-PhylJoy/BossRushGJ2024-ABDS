@tool
extends BTAction

func _tick(_delta: float) -> Status:
	(agent as FirstBoss).powerful_attack()
	return SUCCESS
