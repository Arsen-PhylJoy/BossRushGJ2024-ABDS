extends ActionLeaf



func tick(actor: Node, blackboard: Blackboard) ->int:
	print(blackboard.get_value("player_position"))
	actor.melee_attack(blackboard.get_value("player_position"))
	return SUCCESS
