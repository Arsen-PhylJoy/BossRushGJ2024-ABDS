extends CharacterBody2D

# Player parameters
@export var player_speed = 80
@export var total_life = 100
var actual_life = total_life

#player stats
var Attack_light = 10
var Attack_dark = 20
var Defense_light = 25
var Defense_dark = 50

#Is_Light_form?
var is_light_player = true

#Damange Delay
var damage_timer := 0.0
var damage_delay := 2.0

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if actual_life <= 0:
		print_debug(actual_life)
		hide()
		
	if Input.is_action_just_pressed("ui_accept"):
		Change_Player_Dark_Light()
	
	damage_timer += delta 
	
	var collision = move_and_collide(velocity * delta)
	if collision:	
		var collider = collision.get_collider()
		var collider_layer = collider.collision_layer
		if collider_layer == 2 and damage_timer >= damage_delay:
			Get_Damange_Player(collider.get("damange"))
			damage_timer = 0.0
	if damage_timer >= 10:
		damage_timer = 0.0

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

func Get_Damange_Player(Damange_of_enemy):
	if is_light_player == true:
		actual_life -= Damange_of_enemy - (Damange_of_enemy * Defense_light / 100)
		print_debug(actual_life)
	else:
		actual_life -= Damange_of_enemy - (Damange_of_enemy * Defense_dark / 100)
		print_debug(actual_life)
