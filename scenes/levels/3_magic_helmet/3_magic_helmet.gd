extends Node

@onready var dialogue_with_magic_helmet: DialogueResource = preload("res://dialogues/meeting_the_magic_helm.dialogue")

func _ready() -> void:
	#await LevelManager.transition_finished
	@warning_ignore("return_value_discarded")
	DialogueManager.show_dialogue_balloon(dialogue_with_magic_helmet)
