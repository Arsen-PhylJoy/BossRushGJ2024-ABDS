@tool
extends BTCondition


func _tick(_delta: float) -> Status:
	if((agent as FirstBoss)._is_perfoming_powerful_attack):
		return FAILURE
	else:
		return SUCCESS
