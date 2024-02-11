extends Node

var _pause_hud_pc:PackedScene = preload("res://scenes/ui/pause_hud.tscn")
var _is_settings_opened: bool = false
var _pause_hud: CanvasLayer
var _one_second_timer:float

var master_volume: float = 65
var music_volume: float = 100
var sfx_volume: float = 100

func _ready() -> void:
	self.process_mode =  PROCESS_MODE_ALWAYS
	_one_second_timer = 0.0

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and get_tree().current_scene.name!="Menu":
		if(!_is_settings_opened):
			_is_settings_opened = true
			_pause_hud =  _pause_hud_pc.instantiate() as CanvasLayer
			get_tree().current_scene.add_child(_pause_hud)
			_pause_hud.layer = 100
			if _pause_hud.tree_exiting.connect(_on_pause_exited): printerr("Fail: ",get_stack())
		elif(_is_settings_opened):
			_pause_hud.queue_free()

func _on_pause_exited()->void:
	_is_settings_opened = false
