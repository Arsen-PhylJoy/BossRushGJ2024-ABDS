extends Area2D

@export var time_to_emerge: float = 0.9
@export var time_to_disappear: float = 0.4
@export var damage:float = 40.0
@onready var animations: AnimationPlayer = $MeleeSpikeAnimationPlayer
@onready var collision_polygon: CollisionPolygon2D = $MeleeSpikeCollision
func _ready() -> void:
	_start_lifetime()
	#TODO make first frame germinates and turn towards the player
func _start_lifetime()->void:
	animations.play("emerge",-1, 1.0/time_to_emerge)
	await animations.animation_finished
	_disappear()
	
func 	_disappear()->void:
	animations.play("disappear",-1, 1.0/time_to_disappear)
	await animations.animation_finished
	queue_free()
