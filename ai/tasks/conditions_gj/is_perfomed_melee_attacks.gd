@tool
extends BTCondition

func _setup()->void:
	blackboard.set_var("remaining_melee_attacks",blackboard.get_data().get("melee_attacks"))

# Called when the task is executed.
func _tick(_delta: float) -> Status:
	if((blackboard.get_data().get("remaining_melee_attacks") as int) == 0):
		blackboard.set_var("remaining_melee_attacks",blackboard.get_data().get("melee_attacks"))
		return SUCCESS
	else:
		return FAILURE
		
