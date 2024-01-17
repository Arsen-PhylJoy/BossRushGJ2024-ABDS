extends GPUParticles2D

func _ready() -> void:
	if finished.connect(queue_free): printerr("Fail: ",get_stack()) 
