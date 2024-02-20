extends Node

@onready var _exit_button: Button =  %Exit

func _ready() -> void:
	if(StoryState.is_good_ending):
		(%TextureRect as TextureRect).texture = load("res://assets/graphic/cg_s/ending_good.jpg")
	else:
		(%TextureRect as TextureRect).texture = load("res://assets/graphic/cg_s/ending_bad.jpg")
	if _exit_button.pressed.connect(_on_exit_pressed): printerr("Fail: ",get_stack()) 

func _on_exit_pressed()->void:
	LevelManager.load_level("res://scenes/levels/0_menu/0_menu.tscn")
