extends Node2D

@export var dialogue_resorce: DialogueResource

func show_dialog() ->void:
	for node in get_tree().get_nodes_in_group("Player"):
		node.set_physics_process(false)
	for node in get_tree().get_nodes_in_group("Enemy"):
		node.set_physics_process(false)
	DialogueManager.show_example_dialogue_balloon(dialogue_resorce)
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended_)
	
func _on_dialogue_ended_(resource: DialogueResource)->void:
	for node in get_tree().get_nodes_in_group("Player"):
		node.set_physics_process(true)
	for node in get_tree().get_nodes_in_group("Enemy"):
		node.set_physics_process(true)
	
