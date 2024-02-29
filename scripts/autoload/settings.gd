extends Node

var _pause_hud_pc:PackedScene = preload("res://scenes/ui/pause_hud.tscn")
var _is_settings_opened: bool = false
var _pause_hud: CanvasLayer
var master_volume: float = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))*100
var music_volume: float = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))*100
var sfx_volume: float = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))*100
var _pause_cooldown: Timer

func _ready() -> void:
	self.process_mode =  PROCESS_MODE_ALWAYS
	_pause_cooldown = Timer.new()
	add_child(_pause_cooldown)
	_pause_cooldown.autostart = false
	_pause_cooldown.one_shot = true

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE) and get_tree().current_scene.name!="Menu" and _pause_cooldown.is_stopped():
		_pause_cooldown.start(0.25)
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
