@tool
extends BTCondition


# Called when the task is executed.
func _tick(_delta: float) -> Status:
	var distance_to_player: float = (blackboard.get_data().get("player") as CharacterBody2D).global_position.distance_to((agent as Node2D).global_position)
	if(distance_to_player <= 200.0):
		(agent as CharacterBody2D).velocity = Vector2(0,0)
		return SUCCESS
	else:
		return FAILURE
