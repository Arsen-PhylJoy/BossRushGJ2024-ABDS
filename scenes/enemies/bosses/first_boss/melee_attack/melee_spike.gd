extends Area2D

@export var time_to_emerge: float = 0.9
@export var time_to_disappear: float = 0.4
@onready var animations: AnimationPlayer = $MeleeSpikeAnimationPlayer

func _ready() -> void:
	_start_lifetime()
	
	
func _start_lifetime()->void:
	animations.play("emerge",-1, 1.0/time_to_emerge)
	await animations.animation_finished
	_disappear()
	
func 	_disappear()->void:
	animations.play("disappear",-1, 1.0/time_to_disappear)
	await animations.animation_finished
	queue_free()