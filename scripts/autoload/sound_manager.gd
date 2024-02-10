extends Node

@onready var _controls_window: PackedScene = preload("res://scenes/ui/controls_window.tscn")
var click_sound: AudioStreamPlayer
var choice_button_sound: AudioStreamPlayer

func _ready() -> void:
	click_sound = AudioStreamPlayer.new()
	click_sound.bus = "UI"
	click_sound.stream = load("res://assets/audio/sfx/click_short_version.wav")
	add_child(click_sound)
	choice_button_sound = AudioStreamPlayer.new()
	choice_button_sound.bus = "UI"
	choice_button_sound.stream = load("res://assets/audio/sfx/choice_button.wav")
	add_child(choice_button_sound)
