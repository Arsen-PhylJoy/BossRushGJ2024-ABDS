@tool
extends BTAction

var boss: FirstBoss

func _setup()->void:
	boss = agent as FirstBoss

func _enter()->void:
	(agent as CharacterBody2D).velocity = Vector2(0,0)
	boss.speed = boss.go_to_mark_speed
	var powerful_attack_mark: Array[Marker2D] = [boss.powerful_attack_mark]
	boss.set_movement_target(_get_longest_mark_position(powerful_attack_mark,boss.global_position))

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
