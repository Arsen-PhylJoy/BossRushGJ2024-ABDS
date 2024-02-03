class_name Storystate
extends Node

signal player_got_ability

@export var is_player_has_dark_ability: bool = false:
	set(value):
		player_got_ability.emit()
		is_player_has_dark_ability = value
		print_debug(is_player_has_dark_ability)
