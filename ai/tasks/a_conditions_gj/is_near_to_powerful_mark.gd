@tool
extends BTCondition


# Called when the task is executed.
func _tick(_delta: float) -> Status:
	var boss: FirstBoss = agent as FirstBoss
	var powerful_attack_mark: Array[Marker2D] = [boss.powerful_attack_mark]
	if(boss.navigation_agent.is_target_reached()):
		return SUCCESS
	else:
		return FAILURE


func _get_closest_mark_position(from_marks: Array[Marker2D],to_position:Vector2)->Vector2:
	var closest_distance: float = 200000
	var shortest_position: Vector2 = from_marks[0].global_position
	for mark: Marker2D in from_marks:
		var tmp_distance: float = to_position.distance_to(mark.global_position)
		if(closest_distance > tmp_distance):
			closest_distance = tmp_distance
			shortest_position = mark.global_position
	return shortest_position
