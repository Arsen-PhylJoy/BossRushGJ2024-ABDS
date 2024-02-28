@tool
extends BTCondition


func _tick(_delta: float) -> Status:
	if((agent as FirstBoss).is_done_powerful_attack):
		return SUCCESS
	else:
		return FAILURE
