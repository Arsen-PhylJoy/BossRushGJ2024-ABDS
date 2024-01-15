extends Blackboard

var _player_reference: CharacterBody2D
var _player_position: Vector2 

func _ready() -> void:
	_player_reference = get_tree().get_first_node_in_group("Player")
	set_value("player_position",_player_reference.global_position)
	set_value("angle_to_player",get_parent().get_angle_to(_player_reference.global_position))
	set_value("distance_to_player",get_parent().global_position.distance_to(get_value("player_position")))
	
func _process(delta: float) -> void:
	_player_position = _player_reference.global_position
	set_value("player_position",_player_position)
	set_value("angle_to_player",get_parent().get_angle_to(_player_position))
	set_value("distance_to_player",get_parent().global_position.distance_to(_player_position))
