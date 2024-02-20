class_name PlayerCamera
extends Camera2D

var shake_duration : float = 0.0 
var shake_amplitude : float = 10.0 

func _ready()->void:
	pass 

func _process(delta: float)->void:
	if shake_duration > 0.0:
		var shake_vector : Vector2 = Vector2(randf(), randf()).normalized() * shake_amplitude
		offset = shake_vector
		shake_duration -= delta
	else:
		offset = Vector2.ZERO

func apply_shake(duration: float, amplitude: float)->void:
	shake_duration = duration
	shake_amplitude = amplitude
