extends Area2D
@export var time_to_notify: float = 1.0
@export var time_to_emerge: float = 0.9
@export var time_to_disappear: float = 0.4

@onready var animations: AnimationPlayer = $PowerfulSpikeAnimationPlayer
@onready var collision: CollisionShape2D = $PowerfulSpikeCollision2D
@onready var spike_sprite: Sprite2D = $PowerfulSpikeSprite2D
@onready var notify_sprite: Sprite2D = $NotifySprite

func _ready() -> void:
	spike_sprite.hide()
	collision.disabled = true;
	start()
	
func start()->void:
	animations.play("notify",-1,1.0/time_to_notify )
	await animations.animation_finished
	_start_lifetime()
	
func _start_lifetime()->void:
	notify_sprite.hide()
	spike_sprite.show()
	collision.disabled = false
	animations.play("emerge",-1, 1.0/time_to_emerge)
	await animations.animation_finished
	_disappear()
	
func 	_disappear()->void:
	animations.play("disappear",-1, 1.0/time_to_disappear)
	await animations.animation_finished
	queue_free()
