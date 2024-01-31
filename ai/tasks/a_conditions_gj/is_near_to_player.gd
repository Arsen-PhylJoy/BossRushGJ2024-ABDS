@tool
extends BTCondition

func _setup()->void:
	blackboard.set_var("is_moved_to_player", false)


# Called when the task is executed.
func _tick(_delta: float) -> Status:
	var distance_to_player: float = (blackboard.get_data().get("player") as CharacterBody2D).global_position.distance_to((agent as Node2D).global_position)
	if(distance_to_player <= (blackboard.get_data().get("melee_attack_distance") as float)):
		return SUCCESS
	else:
		return FAILURE
