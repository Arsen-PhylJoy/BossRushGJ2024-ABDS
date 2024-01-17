extends CharacterBody2D

var speed:float = 600  # speed in pixels/sec

func get_input()->void:
	velocity = Vector2.ZERO
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_key_pressed(KEY_S):
		velocity.y += 1
	if Input.is_key_pressed(KEY_W):
		velocity.y -= 1
	# Make sure diagonal movement isn't faster
	velocity = velocity.normalized() * speed

func _physics_process(delta:float)->void:
	get_input()
	move_and_slide()
