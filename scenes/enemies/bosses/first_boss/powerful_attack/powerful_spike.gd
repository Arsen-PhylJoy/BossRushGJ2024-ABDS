class_name PowerfulSpike
extends Area2D

@export var time_to_notify: float = 1.0
@export var time_to_emerge: float = 0.9
@export var time_to_disappear: float = 0.4

@onready var animations: AnimationPlayer = $PowerfulSpikeAnimationPlayer
@onready var collision: CollisionPolygon2D = $PowefulSpikeCollisionPolygon
@onready var powerful_spike_a_sprite_2d: AnimatedSprite2D = $PowerfulSpikeASprite2D
@onready var notify_sprite: Sprite2D = $NotifySprite

func _ready() -> void:
	start()

func start()->void:
	notify_sprite.show()
	powerful_spike_a_sprite_2d.hide()
	collision.disabled = true
	animations.play("notify",-1,1.0/time_to_notify )
	await animations.animation_finished
	_start_lifetime()
	
func _start_lifetime()->void:
	notify_sprite.hide()
	powerful_spike_a_sprite_2d.show()
	collision.disabled = false
	animations.play("emerge",-1, 1.0/time_to_emerge)
	await animations.animation_finished
	_disappear()
	
func 	_disappear()->void:
	animations.play("disappear",-1, 1.0/time_to_disappear)
	await animations.animation_finished
	queue_free()
