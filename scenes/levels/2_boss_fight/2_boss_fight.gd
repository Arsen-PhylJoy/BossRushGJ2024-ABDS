extends Node

func _ready() -> void:
	await LevelManager.transition_finished
	DialogueManager.show_dialogue_balloon(load("res://dialogues/pre_boss.dialogue") as DialogueResource)
