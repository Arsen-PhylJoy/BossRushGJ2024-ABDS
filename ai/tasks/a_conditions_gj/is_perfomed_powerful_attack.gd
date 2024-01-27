@tool
extends BTCondition


func _tick(_delta: float) -> Status:
	#Violation of encapsulation
	#TODO fix
	if(!(agent as FirstBoss)._can_move):
		return SUCCESS
	else:
		return FAILURE
