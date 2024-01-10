extends Area2D

# Player parameters
@export var player_speed = 80
@export var total_life = 100
var actual_life = total_life

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if actual_life <= 0:
		print_debug(actual_life)
		hide()

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0
	
	if velocity != Vector2.ZERO:
		$AnimationTree.set("parameters/idle/blend_position", velocity.normalized())
		$AnimationTree.set("parameters/walk/blend_position", velocity.normalized())
		$AnimationTree.get("parameters/playback").travel("walk")
		velocity = velocity.normalized() * player_speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	else:
		$AnimationTree.get("parameters/playback").travel("idle")


func _on_body_entered(body):
	print_debug(body)
	actual_life -= 30
	print_debug(actual_life)
