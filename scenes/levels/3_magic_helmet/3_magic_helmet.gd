extends Node


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	if(StoryState.is_rematch == false):
		DialogueManager.show_dialogue_balloon(load("res://dialogues/meeting_the_magic_helm.dialogue") as DialogueResource)
	elif(StoryState.is_rematch == true and StoryState.is_player_has_dark_ability == true):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/helmet_and_boss_is_killed.dialogue") as DialogueResource)
	if DialogueManager.dialogue_ended.connect(_on_dialogue_ended): printerr("Fail: ",get_stack())
	
func _on_dialogue_ended(dialogue_res: DialogueResource)->void:
	if(dialogue_res.get_titles()[0] == "meeting_the_magic_helm"):
		for node: Node in get_tree().current_scene.get_children():
			if(node is ControlsWindow):
				await (node as ControlsWindow).exit
				break
		LevelManager.load_level("res://scenes/levels/2_boss_fight/2_boss_fight.tscn")
