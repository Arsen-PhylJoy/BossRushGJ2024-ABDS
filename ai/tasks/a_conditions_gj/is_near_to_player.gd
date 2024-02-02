@tool
extends BTCondition

func _enter()->void:
	blackboard.set_var("is_moved_to_player", false)
	var player: PlayerCharacter
	for node: Node in agent.get_tree().current_scene.get_children():
		if (node is PlayerCharacter):
			player = node
			break
	blackboard.set_var("player",player)

# Called when the task is executed.
func _tick(_delta: float) -> Status:
	var distance_to_player: float = (blackboard.get_data().get("player") as CharacterBody2D).global_position.distance_to((agent as Node2D).global_position)
	if(distance_to_player <= (blackboard.get_data().get("melee_attack_distance") as float)):
		return SUCCESS
	else:
		return FAILURE
