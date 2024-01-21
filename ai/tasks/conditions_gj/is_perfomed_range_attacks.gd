@tool
extends BTCondition

func _setup()->void:
	blackboard.set_var("remaining_range_attacks",blackboard.get_data().get("range_attacks"))

# Called when the task is executed.
func _tick(_delta: float) -> Status:
	if((blackboard.get_data().get("remaining_range_attacks") as int) == 0):
		blackboard.set_var("remaining_range_attacks",blackboard.get_data().get("range_attacks"))
		(agent as FirstBoss).speed = (agent as FirstBoss).wander_speed
		return SUCCESS
	else:
		return FAILURE
		
