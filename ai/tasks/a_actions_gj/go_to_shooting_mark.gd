@tool
extends BTAction

func _enter()->void:
	(agent as FirstBoss).un_bury()
	(agent as FirstBoss).speed = (agent as FirstBoss).max_speed
	(agent as FirstBoss).set_movement_target(_get_longest_mark_position((agent as FirstBoss).shooting_marks,(agent as FirstBoss).global_position))

func _tick(_delta: float) -> Status:
	return RUNNING

func _get_longest_mark_position(from_marks: Array[Marker2D],to_position:Vector2)->Vector2:
	var farest_distance: float = 0
	var longest_position: Vector2 = from_marks[0].global_position
	for mark: Marker2D in from_marks:
		var tmp_distance: float = to_position.distance_to(mark.global_position)
		if(farest_distance < tmp_distance):
			farest_distance = tmp_distance
			longest_position = mark.global_position
	return longest_position
