@tool
extends BTSetVar

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "SetBalckboardFirstBoss"


# Called once during initialization.
func _setup() -> void:
	for node: Node in agent.get_tree().current_scene.get_children():
		if(node.is_in_group("Player")):
			blackboard.set_var("player",node)

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if(blackboard.get_data().get("player")!=null):
		return SUCCESS
	else:
		printerr("Failure in Blackboard initilization!")
		return FAILURE


