extends Node

signal player_got_ability

var is_player_has_dark_ability: bool = false:
	set(value):
		player_got_ability.emit()
		is_player_has_dark_ability = value

var is_rematch: bool = false

var is_good_ending: bool = false

func set_defaults()->void:
	StoryState.is_rematch = false
	StoryState.is_player_has_dark_ability =  false
