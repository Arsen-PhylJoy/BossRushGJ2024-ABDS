extends Node

@onready var _music: AudioStreamPlayer2D = %AudioStreamPlayer2D
@onready var retry_hud: PackedScene = preload("res://scenes/ui/retry_hud.tscn")

func _ready() -> void:
	if DialogueManager.dialogue_ended.connect(_on_dialogue_ended): printerr("Fail: ",get_stack())
	if (%FirstBoss as FirstBoss).dead.connect(_on_boss_dead): printerr("Fail: ",get_stack())
	if (%Player as PlayerCharacter).dead.connect(_on_player_dead): printerr("Fail: ",get_stack())
	_hide_ui()
	_music.stop()
	if(StoryState.is_rematch == false):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/_2_light_pre_boss_fight.dialogue") as DialogueResource)
	elif(StoryState.is_player_has_dark_ability == true):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/_2_dark_pre_boss_fight.dialogue") as DialogueResource)
	elif(StoryState.is_player_has_dark_ability == false):
		_show_ui()
		_music.play()

func _hide_ui()->void:
	var player_ui: CanvasLayer
	var boss_ui: CanvasLayer
	for canvas: Node in (%Player as PlayerCharacter).get_children():
		if(canvas is CanvasLayer):
			player_ui = canvas
	for canvas: Node in (%FirstBoss as FirstBoss).get_children():
		if(canvas is CanvasLayer):
			boss_ui = canvas
	player_ui.hide()
	boss_ui.hide()

func _show_ui()->void:
	var player_ui: CanvasLayer
	var boss_ui: CanvasLayer
	for canvas: Node in (%Player as PlayerCharacter).get_children():
		if(canvas is CanvasLayer):
			player_ui = canvas
	for canvas: Node in (%FirstBoss as FirstBoss).get_children():
		if(canvas is CanvasLayer):
			boss_ui = canvas
	player_ui.show()
	boss_ui.show()

func _on_boss_dead()->void:
	if(StoryState.is_player_has_dark_ability == false):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/_2_light_after_boss_defeat.dialogue") as DialogueResource)
	elif(StoryState.is_player_has_dark_ability == true):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/_2_dark_after_boss_defeat_1.dialogue") as DialogueResource)
func _on_player_dead()->void:
	if(StoryState.is_rematch == false):
		LevelManager.load_level("res://scenes/levels/3_magic_helmet/3_magic_helmet.tscn")
	else:
		add_child(retry_hud.instantiate())
	
func _on_dialogue_ended(dialogue_res: DialogueResource)->void:
	if(dialogue_res.get_titles()[0] == "_2_light_pre_boss_fight" or dialogue_res.get_titles()[0] == "_2_dark_pre_boss_fight"):
		_music.play()
		_show_ui()
	if(dialogue_res.get_titles()[0] == "_2_light_after_boss_defeat"):
		LevelManager.load_level("res://scenes/levels/ending/ending.tscn")
	if(dialogue_res.get_titles()[0] == "_2_dark_after_boss_defeat_1"):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/_2_dark_after_boss_defeat_2.dialogue") as DialogueResource)
	if(dialogue_res.get_titles()[0] == "_2_dark_after_boss_defeat_2"):
		LevelManager.load_level("res://scenes/levels/3_magic_helmet/3_magic_helmet.tscn")
