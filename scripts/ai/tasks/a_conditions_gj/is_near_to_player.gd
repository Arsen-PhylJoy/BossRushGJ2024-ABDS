@tool
extends BTCondition

# Called when the task is executed.
func _tick(_delta: float) -> Status:
	var distance_to_player: float = (blackboard.get_var("player") as CharacterBody2D).global_position.distance_to((agent as Node2D).global_position)
	if(distance_to_player <= (blackboard.get_var("melee_attack_distance") as float)):
		return SUCCESS
	else:
		return FAILURE
