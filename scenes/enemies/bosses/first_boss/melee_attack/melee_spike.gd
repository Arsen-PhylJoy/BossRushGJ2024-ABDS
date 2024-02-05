class_name Spike
extends Area2D

@export var time_to_emerge: float = 0.9
@export var time_to_disappear: float = 0.4
@export var damage:float = 90.0
@onready var animations: AnimationPlayer = $MeleeSpikeAnimationPlayer
@onready var collision_polygon: CollisionPolygon2D = $MeleeSpikeCollision
@onready var _sound: Array[AudioStreamWAV] = [preload("res://assets/audio/sfx/first_boss/plant_spike_1.wav"),preload("res://assets/audio/sfx/first_boss/plant_spike_3.wav"),preload("res://assets/audio/sfx/first_boss/plant_spike_2.wav")]
@onready var _sound_player: AudioStreamPlayer2D = %MeleeSpikeAudioStreamPlayer2D
	
func _ready() -> void:
	_start_lifetime()
	
func _start_lifetime()->void:
	_sound_player.stream = _sound[randi_range(0,2)]
	_sound_player.play()
	animations.play("emerge",-1, 1.0/time_to_emerge)
	await animations.animation_finished
	_disappear()
	
func 	_disappear()->void:
	animations.play("disappear",-1, 1.0/time_to_disappear)
	await animations.animation_finished
	queue_free()
