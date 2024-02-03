extends Node

@onready var _pause_screen_pc: PackedScene = preload("res://scenes/ui/pause_hud.tscn")
@onready var _music: AudioStreamPlayer2D = %AudioStreamPlayer2D

func _ready() -> void:
	get_tree().paused = true
	await LevelManager.transition_finished
	_hide_ui()
	get_tree().paused = false
	@warning_ignore("return_value_discarded")
	DialogueManager.show_dialogue_balloon(load("res://dialogues/pre_boss.dialogue") as DialogueResource)
	if DialogueManager.dialogue_ended.connect(_on_entry_dialogue_finished): printerr("Fail: ",get_stack())

func _physics_process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		var _pause_screen: CanvasLayer =  _pause_screen_pc.instantiate()
		get_tree().current_scene.add_child(_pause_screen)

func _hide_ui()->void:
	var player_ui: CanvasLayer
	var boss_ui: CanvasLayer
	for node: Node in get_tree().current_scene.get_children():
		if(node is PlayerCharacter):
			for canvas: Node in node.get_children():
				if(canvas is CanvasLayer):
					player_ui = canvas
		elif(node is FirstBoss):
			for canvas: Node in node.get_children():
				if(canvas is CanvasLayer):
					boss_ui = canvas
	player_ui.hide()
	boss_ui.hide()

func _show_ui()->void:
	var player_ui: CanvasLayer
	var boss_ui: CanvasLayer
	for node: Node in get_tree().current_scene.get_children():
		if(node is PlayerCharacter):
			for canvas: Node in node.get_children():
				if(canvas is CanvasLayer):
					player_ui = canvas
		elif(node is FirstBoss):
			for canvas: Node in node.get_children():
				if(canvas is CanvasLayer):
					boss_ui = canvas
	player_ui.show()
	boss_ui.show()

func _on_entry_dialogue_finished(dialogue: DialogueResource)->void:
	_music.play()
	_show_ui()
	DialogueManager.dialogue_ended.disconnect(_on_entry_dialogue_finished)
