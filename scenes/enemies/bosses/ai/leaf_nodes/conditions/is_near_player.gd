extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) ->int:
	if (blackboard.get_value("distance_to_player") > 200):
		return FAILURE
	else:
		actor.velocity = Vector2(0,0)
		return SUCCESS
