@tool
extends BTAction

func _tick(_delta: float) -> Status:
	(agent as FirstBoss).range_attack((blackboard.get_data().get("player") as CharacterBody2D).global_position)
	blackboard.set_var("remaining_range_attacks",(blackboard.get_data().get("remaining_range_attacks") as int) - 1)
	print(blackboard.get_data().get("remaining_range_attacks") as int)
	return SUCCESS
