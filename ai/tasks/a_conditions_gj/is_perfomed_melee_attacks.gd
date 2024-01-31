@tool
extends BTCondition

var attacks_done: bool = true

func _enter()->void:
	if(attacks_done):
		attacks_done = false
		var min_attacks: int = blackboard.get_data().get("min_melee_attacks") as int
		var max_attacks: int = blackboard.get_data().get("max_melee_attacks") as int
		blackboard.set_var("remaining_melee_attacks",randi_range(min_attacks,max_attacks))

#TODO _can_move violation of encapsulation FIX IT
# Called when the task is executed.
func _tick(_delta: float) -> Status:
	if((blackboard.get_data().get("remaining_melee_attacks") as int) == 0):
		attacks_done = true
		return SUCCESS
	else:
		return FAILURE
