@tool
extends BTCondition


func _tick(_delta: float) -> Status:
	#Violation of encapsulation
	#TODO fix
	if((agent as FirstBoss)._is_perfoming_powerful_attack):
		return SUCCESS
	else:
		return FAILURE
