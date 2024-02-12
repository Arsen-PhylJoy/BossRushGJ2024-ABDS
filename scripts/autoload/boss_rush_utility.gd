extends Node

@onready var _controls_window: PackedScene = preload("res://scenes/ui/atomic_widgets/controls_window.tscn")
var _choice_button_sound: AudioStreamPlayer

func _ready() -> void:
	_choice_button_sound = AudioStreamPlayer.new()
	add_child(_choice_button_sound)
	_choice_button_sound.bus = "SFX"
	_choice_button_sound.stream = load("res://assets/audio/sfx/choice_button.wav")

func show_opened_abilities()->void:
	var controls_window: ControlsWindow = _controls_window.instantiate()
	controls_window._start_animation = true
	get_tree().current_scene.add_child(controls_window)


func play_choice_sound()->void:
	_choice_button_sound.play()

func show_ending()->void:
	LevelManager.load_level("res://scenes/levels/endings/ending.tscn")
