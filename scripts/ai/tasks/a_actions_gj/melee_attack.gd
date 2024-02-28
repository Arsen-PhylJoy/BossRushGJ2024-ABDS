@tool
extends BTAction

#TODO violation of encapsulation FIX (_is_buried)
func _tick(_delta: float) -> Status:
	(agent as FirstBoss).bury()	
	if((agent as FirstBoss).melee_attack((blackboard.get_var("player") as PlayerCharacter).global_position)):
		blackboard.set_var("remaining_melee_attacks",(blackboard.get_var("remaining_melee_attacks") as int) - 1)
		return SUCCESS
	return FAILURE
