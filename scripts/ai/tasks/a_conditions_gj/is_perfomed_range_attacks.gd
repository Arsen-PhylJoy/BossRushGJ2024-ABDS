@tool
extends BTCondition

var attacks_done: bool = true

func _enter()->void:
	if(attacks_done):
		attacks_done = false
		var min_attacks: int = blackboard.get_var("min_range_attacks") as int
		var max_attacks: int = blackboard.get_var("max_range_attacks") as int
		blackboard.set_var("remaining_range_attacks",randi_range(min_attacks,max_attacks))

# Called when the task is executed.
func _tick(_delta: float) -> Status:
	if((blackboard.get_var("remaining_range_attacks") as int) == 0):
		attacks_done = true
		return SUCCESS
	else:
		return FAILURE
