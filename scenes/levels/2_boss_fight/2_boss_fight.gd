extends Node

@onready var _pause_screen_pc: PackedScene = preload("res://scenes/ui/pause_hud.tscn")
@onready var _music: AudioStreamPlayer2D = %AudioStreamPlayer2D

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	if(StoryState.is_rematch == false):
		_hide_ui()
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/pre_boss.dialogue") as DialogueResource)
	elif(StoryState.is_rematch == true and StoryState.is_player_has_dark_ability == true):
		_hide_ui()
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/rematch_agree_with_helmet.dialogue") as DialogueResource)
	if DialogueManager.dialogue_ended.connect(_on_dialogue_ended): printerr("Fail: ",get_stack())
	if (%FirstBoss as FirstBoss).dead.connect(_on_boss_dead): printerr("Fail: ",get_stack())

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
	_music.stop()
	if( StoryState.is_player_has_dark_ability == true and StoryState.is_rematch==true):
		(%Player as PlayerCharacter).process_mode = Node.PROCESS_MODE_DISABLED
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/after_boss_defeat.dialogue") as DialogueResource)

func _on_dialogue_ended(dialogue_res: DialogueResource)->void:
	if(dialogue_res.get_titles()[0] == "pre_boss"):
		_music.play()
		_show_ui()
	elif(dialogue_res.get_titles()[0] == "after_boss_defeat"):
		%FirstBoss.queue_free()
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/after_boss_talk_in_boss_arena.dialogue") as DialogueResource)
	elif(dialogue_res.get_titles()[0] == "after_boss_talk_in_boss_arena"):
		LevelManager.load_level("res://scenes/levels/3_magic_helmet/3_magic_helmet.tscn")
