extends Node

@onready var _controls_window: PackedScene = preload("res://scenes/ui/controls_window.tscn")
var _click_sound: AudioStreamPlayer
var _choice_button_sound: AudioStreamPlayer

func _ready() -> void:
	_click_sound = AudioStreamPlayer.new()
	_choice_button_sound = AudioStreamPlayer.new()
	add_child(_click_sound)
	add_child(_choice_button_sound)
	_click_sound.bus = "SFX"
	_click_sound.stream = load("res://assets/audio/sfx/click.wav")
	_choice_button_sound.bus = "SFX"
	_choice_button_sound.stream = load("res://assets/audio/sfx/choice_button.wav")

func show_opened_abilities()->void:
	var controls_window: ControlsWindow = _controls_window.instantiate()
	controls_window.start_animation = true
	get_tree().current_scene.add_child(controls_window)

func play_click_sound()->void:
	_click_sound.play()

func play_choice_sound()->void:
	_choice_button_sound.play()

func show_ending()->void:
	LevelManager.load_level("res://scenes/levels/endings/ending.tscn")
