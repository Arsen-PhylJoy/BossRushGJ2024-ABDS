extends RigidBody2D

var bullet_scene = preload("res://scenes/enemies/Bullet/bullet.tscn")
var time_between_shots = 2.0
var time_since_last_shot = 0.0

var Vector_bullet = Vector2(-1, 0)
var magnitude_bullet = 400

var offset = -50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_since_last_shot += delta
	if time_since_last_shot > time_between_shots:
		shoot()
		time_since_last_shot = 0.0

func shoot():
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = Vector2(offset + position.x, position.y)
	bullet_instance.apply_central_impulse(Vector_bullet.normalized() * magnitude_bullet)
	get_parent().add_child(bullet_instance)
