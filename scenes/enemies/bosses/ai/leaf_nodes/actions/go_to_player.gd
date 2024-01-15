extends ActionLeaf

func tick(actor: Node, blackboard: Blackboard) ->int:
	actor.velocity = (blackboard.get_value("player_position") - actor.global_position).normalized() * actor.max_speed;
	return RUNNING
