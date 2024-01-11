extends Area2D

@export var dialogue_resorce: DialogueResource

func _ready() -> void:
	connect("body_entered", _on_body_entered_)
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended_)
	
func _on_body_entered_(body:Node2D) ->void:
	if(!body.is_in_group("Player")):
		return
	for node in get_tree().get_nodes_in_group("Player"):
		node.set_physics_process(false)
	for node in get_tree().get_nodes_in_group("Enemy"):
		node.set_physics_process(false)
	DialogueManager.show_example_dialogue_balloon(dialogue_resorce)
	
func _on_dialogue_ended_(resource: DialogueResource)->void:
	for node in get_tree().get_nodes_in_group("Player"):
		node.set_physics_process(true)
	for node in get_tree().get_nodes_in_group("Enemy"):
		node.set_physics_process(true)

