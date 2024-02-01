extends Control

@export var db_coefficient: float = 75.0
@onready var _master_slider: HSlider = $SoundContainer/MasterHBox/MasterVBox/MasterHSlider
@onready var _music_button: TextureButton = $SoundContainer/MusicContainer/MusicHBox/MusicButton
@onready var _music_slider: HSlider = $SoundContainer/MusicContainer/MusicHBox/MusicHSlider
@onready var _sfx_button: TextureButton = $SoundContainer/SFXContainer/SFXHBox/SFXButton
@onready var _sfx_slider: HSlider = $SoundContainer/SFXContainer/SFXHBox/SFXHSlider
@onready var _click_sound: AudioStreamPlayer = $Click
@onready var _check_master: AudioStreamPlayer = $CheckMaster
@onready var _check_music: AudioStreamPlayer = $CheckMusic
@onready var _check_sfx: AudioStreamPlayer = $CheckSFX
@onready var _music_on_texture: CompressedTexture2D = preload("res://assets/graphic/ui/Music.png")
@onready var _music_off_texture: CompressedTexture2D = preload("res://assets/graphic/ui/MusicOff.png")
@onready var _sfx_on_texture: CompressedTexture2D = preload("res://assets/graphic/ui/Sound.png")
@onready var _sfx_off_texture: CompressedTexture2D = preload("res://assets/graphic/ui/SoundOff.png")
@onready var _master_bus_id: int = AudioServer.get_bus_index("Master")
@onready var _music_bus_id: int = AudioServer.get_bus_index("Music")
@onready var _sfx_bus_id: int = AudioServer.get_bus_index("SFX")
var _music_on: bool = true
var _sfx_on: bool = true

func _ready() -> void:
	if _master_slider.value_changed.connect(_on_master_value_changed) : printerr("Fail: ",get_stack())
	if _music_slider.value_changed.connect(_on_music_value_changed) : printerr("Fail: ",get_stack())
	if _sfx_slider.value_changed.connect(_on_sfx_value_changed) : printerr("Fail: ",get_stack())
	if _music_button.pressed.connect(_on_pressed_music) : printerr("Fail: ",get_stack()) 
	if _sfx_button.pressed.connect(_on_pressed_sfx) : printerr("Fail: ",get_stack()) 
	if _master_slider.drag_started.connect(_on_master_drag_started) : printerr("Fail: ",get_stack())
	if _music_slider.drag_started.connect(_on_music_drag_started) : printerr("Fail: ",get_stack())
	if _sfx_slider.drag_started.connect(_on_sfx_drag_started) : printerr("Fail: ",get_stack())
	_master_slider.value = Settings.master_volume
	_music_slider.value = Settings.music_volume
	_sfx_slider.value = Settings.sfx_volume
	_check_master.stop()
	_check_music.stop()
	_check_sfx.stop()
	
func _process(_delta: float) -> void:
	if(_check_master.get_playback_position()>31.0):
		_check_master.stop()
	if(_check_music.get_playback_position()>31.0):
		_check_music.stop()
	if(_check_master.get_playback_position()>31.0):
		_check_master.stop()

func _on_master_value_changed(value:float)->void:
	AudioServer.set_bus_volume_db(_master_bus_id,linear_to_db(value/db_coefficient))
	AudioServer.set_bus_mute(_master_bus_id,value<0.05)
	if(!_check_master.playing):
		_check_master.play(30.0)

func _on_music_value_changed(value:float)->void:
	if(_music_on == false and value<0.05):
		return
	_music_button.texture_normal = _music_on_texture
	_music_on = true	
	AudioServer.set_bus_volume_db(_music_bus_id,linear_to_db(value/db_coefficient))
	AudioServer.set_bus_mute(_music_bus_id,value<0.05)
	if(!_check_music.playing):
		_check_music.play(30.0)
		
func _on_sfx_value_changed(value:float)->void:
	if(_sfx_on == false and value<0.05):
		return
	_sfx_button.texture_normal = _sfx_on_texture
	_sfx_on = true	
	AudioServer.set_bus_volume_db(_sfx_bus_id,linear_to_db(value/db_coefficient))
	AudioServer.set_bus_mute(_sfx_bus_id,value<0.05)
	if(!_check_sfx.playing):
		_check_sfx.play(30.0)

func _on_pressed_music()->void:
	_click_sound.play()
	if(_music_on):
		_music_button.texture_normal = _music_off_texture
		_music_on = false
	else:
		_music_button.texture_normal = _music_on_texture
		_music_on = true	
	AudioServer.set_bus_mute(_music_bus_id,!_music_on)

func _on_pressed_sfx()->void:
	_click_sound.play()
	if(_sfx_on):
		_sfx_button.texture_normal = _sfx_off_texture
		_sfx_on = false
	else:
		_sfx_button.texture_normal = _sfx_on_texture
		_sfx_on = true	
	AudioServer.set_bus_mute(_sfx_bus_id,!_sfx_on)

func _on_master_drag_started()->void:
	_click_sound.play()

func _on_sfx_drag_started()->void:
	_click_sound.play()

func _on_music_drag_started()->void:
	_click_sound.play()
