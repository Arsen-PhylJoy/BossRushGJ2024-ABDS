extends Node2D

@export var speed: float 
@export var limit_distance: float
var passed_distance: float

func _process(delta: float) -> void:
	position.x += speed*delta;
	passed_distance += speed*delta;
	if(abs(passed_distance) > limit_distance):
		speed*=-1
