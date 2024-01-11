extends Area2D

# Player parameters
@export var player_speed = 80
@export var total_life = 100
var actual_life = total_life

var is_light_player = true

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if actual_life <= 0:
		print_debug(actual_life)
		hide()
		
	if Input.is_action_just_pressed("ui_accept"):
		Change_Player_Dark_Light()

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

func Change_Player_Dark_Light():
	if is_light_player == true:
		$Sprite2D.visible = false
		$Sprite_Player_Dark.visible = true
		is_light_player = false
	else:
		$Sprite_Player_Dark.visible = false
		$Sprite2D.visible = true
		is_light_player = true

func _on_body_entered(body):
	if is_light_player == true:
		actual_life -= 30
		print_debug("Light player life:" + actual_life)
