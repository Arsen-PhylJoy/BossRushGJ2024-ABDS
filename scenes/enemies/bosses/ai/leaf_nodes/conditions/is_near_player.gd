extends ConditionLeaf


func tick(actor: Node, blackboard: Blackboard) ->int:
	var player: PlayerCharacter = actor
	if (blackboard.get_value("distance_to_player") > 200):
		return FAILURE
	else:
		player.velocity = Vector2(0,0)
		return SUCCESS
