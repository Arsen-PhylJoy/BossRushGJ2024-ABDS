extends Node

var click_sound: AudioStreamPlayer
var choice_button_sound: AudioStreamPlayer

func _ready() -> void:
	click_sound = AudioStreamPlayer.new()
	click_sound.bus = "UI"
	click_sound.stream = preload("res://assets/audio/sfx/click.wav")
	add_child(click_sound)
	choice_button_sound = AudioStreamPlayer.new()
	choice_button_sound.bus = "UI"
	choice_button_sound.stream = preload("res://assets/audio/sfx/choice_button.wav")
	add_child(choice_button_sound)
