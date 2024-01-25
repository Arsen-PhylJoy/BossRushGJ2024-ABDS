extends Node

var pause_screen_pc: PackedScene = preload("res://scenes/ui/pause_hud.tscn")

func _ready() -> void:
	await LevelManager.transition_finished
	DialogueManager.show_dialogue_balloon(load("res://dialogues/pre_boss.dialogue") as DialogueResource)

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		var pause_screen: CanvasLayer =  pause_screen_pc.instantiate()
		get_tree().current_scene.add_child(pause_screen)
