extends Node


func _ready() -> void:
	if DialogueManager.dialogue_ended.connect(_on_dialogue_ended): printerr("Fail: ",get_stack())
	@warning_ignore("return_value_discarded")
	if(StoryState.is_rematch == false):
		DialogueManager.show_dialogue_balloon(load("res://dialogues/_3_light_meeting_the_magic_helm.dialogue") as DialogueResource)
	elif(StoryState.is_rematch == true and StoryState.is_player_has_dark_ability == true):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/_3_dark_talk_with_helmet_after_boss_defeat.dialogue") as DialogueResource)
	
func _on_dialogue_ended(dialogue_res: DialogueResource)->void:
	if(dialogue_res.get_titles()[0] == "_3_light_meeting_the_magic_helm"):
		for node: Node in get_tree().current_scene.get_children():
			if(node is ControlsWindow):
				await (node as ControlsWindow).exit
				break
		LevelManager.load_level("res://scenes/levels/2_boss_fight/2_boss_fight.tscn")
