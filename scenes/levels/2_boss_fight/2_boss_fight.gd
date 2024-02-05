extends Node

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
		(%Player as PlayerCharacter).stamina = 100
		(%Player as PlayerCharacter).Change_Player_Dark_Light()
		DialogueManager.show_dialogue_balloon(load("res://dialogues/rematch_agree_with_helmet.dialogue") as DialogueResource)
	if(StoryState.is_rematch == true and StoryState.is_player_has_dark_ability == false):
		_music.play()
		_show_ui()
	if DialogueManager.dialogue_ended.connect(_on_dialogue_ended): printerr("Fail: ",get_stack())
	if (%FirstBoss as FirstBoss).dead.connect(_on_boss_dead): printerr("Fail: ",get_stack())
	if (%Player as PlayerCharacter).dead.connect(_on_player_dead): printerr("Fail: ",get_stack())

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
	set_deferred("(%FirstBoss as FirstBoss)._hit_box.monitoring",false)
	if( StoryState.is_player_has_dark_ability == true and StoryState.is_rematch==true):
		(%Player as PlayerCharacter).process_mode = Node.PROCESS_MODE_DISABLED
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/after_boss_defeat.dialogue") as DialogueResource)
	elif(StoryState.is_player_has_dark_ability == false and StoryState.is_rematch==true):
		%FirstBoss.queue_free()
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/boss_defeated_without_ability.dialogue") as DialogueResource)
		

func _on_player_dead()->void:
	_music.stop()
	if(StoryState.is_rematch == false and StoryState.is_player_has_dark_ability == false):
		LevelManager.load_level("res://scenes/levels/3_magic_helmet/3_magic_helmet.tscn")
	elif(StoryState.is_rematch == true and StoryState.is_player_has_dark_ability == true):
		LevelManager.load_level("res://scenes/levels/0_menu/0_menu.tscn")
		StoryState.set_defaults()
	elif(StoryState.is_rematch == true and StoryState.is_player_has_dark_ability == false):
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/player_dead_and_decline.dialogue") as DialogueResource)

func _on_dialogue_ended(dialogue_res: DialogueResource)->void:
	if(dialogue_res.get_titles()[0] == "pre_boss"):
		_music.play()
		_show_ui()
	elif(dialogue_res.get_titles()[0] == "rematch_agree_with_helmet"):
		_music.play()
		_show_ui()
	elif(dialogue_res.get_titles()[0] == "after_boss_defeat"):
		%FirstBoss.queue_free()
		_music.stop()
		@warning_ignore("return_value_discarded")
		DialogueManager.show_dialogue_balloon(load("res://dialogues/after_boss_talk_in_boss_arena.dialogue") as DialogueResource)
	elif(dialogue_res.get_titles()[0] == "after_boss_talk_in_boss_arena"):
		LevelManager.load_level("res://scenes/levels/3_magic_helmet/3_magic_helmet.tscn")
	elif (dialogue_res.get_titles()[0] == "boss_defeated_without_ability"):
		LevelManager.load_level("res://scenes/levels/0_menu/0_menu.tscn")
	elif(dialogue_res.get_titles()[0] == "player_dead_and_decline"):
		LevelManager.load_level("res://scenes/levels/0_menu/0_menu.tscn")
