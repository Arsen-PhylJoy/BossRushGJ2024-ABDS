extends Node

var loading_screen:LoadingScreen
var _loading_screen_scene:PackedScene = preload("res://scenes/utilities/loading_screen/loading_screen.tscn")
var _transition_name:String
var _level_scene:PackedScene

func _ready() -> void:
	print(get_tree().current_scene.name)
	
func load_level(level_path:String, transition_name:String="fade_to_black") -> void:
	_level_scene = load(level_path)
	_transition_name = transition_name
	_start_load_level()
	
func _start_load_level()-> void:
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	loading_screen.connect("transition_in_ended", _on_transition_in_ended)
	loading_screen.start_transition(_transition_name)
	
func _end_load_level()-> void:
	var _new_level_node: Node2D = _level_scene.instantiate()
	add_sibling(_new_level_node,true)
	get_tree().current_scene = _new_level_node
	print(get_tree().current_scene.name)
	loading_screen.finish_transition()

func _on_transition_in_ended()->void:
	get_tree().current_scene.queue_free()
	_end_load_level()
