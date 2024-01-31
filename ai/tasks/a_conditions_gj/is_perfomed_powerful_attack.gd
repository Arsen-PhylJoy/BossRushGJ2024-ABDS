@tool
extends BTCondition


func _tick(_delta: float) -> Status:
	#Violation of encapsulation _is_doing_powerful_attack and _is_buried
	#TODO fix
	if(!(agent as FirstBoss)._is_doing_powerful_attack and (agent as FirstBoss)._is_buried):
		return SUCCESS
	else:
		return FAILURE
