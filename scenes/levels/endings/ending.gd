extends Node

@export var background: CompressedTexture2D 
@onready var _exit_button: Button =  %Exit
var _background: CompressedTexture2D

func _ready() -> void:
	_background = background
	(%TextureRect as TextureRect).texture = _background
	if _exit_button.pressed.connect(_on_exit_pressed): printerr("Fail: ",get_stack()) 

func _on_exit_pressed()->void:
	LevelManager.load_level("res://scenes/levels/0_menu/0_menu.tscn")
