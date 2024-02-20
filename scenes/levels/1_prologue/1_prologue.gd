extends Node

@onready var prologue_dialogue: DialogueResource = preload("res://dialogues/_1_prologue.dialogue")

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	DialogueManager.show_dialogue_balloon(prologue_dialogue)
	if DialogueManager.dialogue_ended.connect(_on_prologue_end): printerr("Fail: ",get_stack()) 

func _on_prologue_end(_dialogue: DialogueResource)->void:
	LevelManager.load_level("res://scenes/levels/2_boss_fight/2_boss_fight.tscn")
