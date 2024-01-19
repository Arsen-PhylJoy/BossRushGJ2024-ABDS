class_name PlayerCharacter
extends CharacterBody2D

## Player parameters
@export var player_speed: float = 80.0
@export var total_life: float = 100.0
@export var attack_bullet : PackedScene
var actual_life: float = total_life

##player stats
var attack_light: float = 10.0
var attack_dark:float = 20.0
var defense_light:float = 25.0
var defense_dark:float = 50.0
var stamina : float = 0 # 100 to 100%, 0 of stamina is 0%, 50 is 50%

#
##Is_Light_form?
var is_light_player: bool = true
#
##Damange Delay
var damage_timer : float = 0.0
var damage_delay : float = 2.0
#
#var screen_size: Vector2
#
func _ready()->void:
	#screen_size = get_viewport_rect().size
	pass
#
func _process(delta: float)->void:
	if actual_life <= 0:
		print_debug(actual_life)
		hide()
		#
	if Input.is_action_just_pressed("ui_accept"):
		Change_Player_Dark_Light()
	if Input.is_action_just_pressed("simple_attack"):
		set_damange_player()
	#
	damage_timer += delta 
	#
	#var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	#if collision:
		#var collider: Object = collision.get_collider()
##TODO Fix bug. collision.get_collider() return Object. Object doesn't have collision layer property
		#var collider_layer = collider.collision_layer
		#if collider_layer == 2 and damage_timer >= damage_delay:
			#get_damage_player(collider.get("damange"))
			#damage_timer = 0.0
	#if damage_timer >= 10:
		#damage_timer = 0.0
#
func _physics_process(delta: float)->void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1.0
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1.0
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1.0
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1.0
	#
	if velocity != Vector2.ZERO:
		#
		$AnimationTree.set("parameters/idle/blend_position", velocity.normalized())
		$AnimationTree.set("parameters/walk/blend_position", velocity.normalized())
		var animation_tree : AnimationTree = $AnimationTree
		var playback_node : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
		playback_node.travel("walk")
		velocity = velocity.normalized() * player_speed
		position += velocity * delta
	else:
		var animation_tree : AnimationTree = $AnimationTree
		var playback_node : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
		playback_node.travel("idle")

func Change_Player_Dark_Light()->void:
	if is_light_player == true:
		$Sprite2D.set("visible", false)
		$Sprite_Player_Dark.set("visible", true)
		is_light_player = false
	else:
		$Sprite2D.set("visible", true)
		$Sprite_Player_Dark.set("visible", false)
		is_light_player = true
#

func set_damange_player()->void:
	var random_damange : float
	random_damange = randf_range(1, 1.8)
	
	if is_light_player == true:
		print_debug(attack_light * random_damange)
		#var Attack_instance: Bullet = attack_bullet.instantiate() as Bullet
		#bullet_instance.position = Vector2(offset + position.x, position.y)
		#bullet_instance.apply_central_impulse(Vector_bullet.normalized() * magnitude_bullet)
		#get_parent().add_child(bullet_instance)
	else:
		print_debug(attack_dark * random_damange)

func get_damage_player(damage_of_enemy:float)->void:
	if is_light_player == true:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_light / 100)
		print_debug(actual_life)
	else:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_dark / 100)
		print_debug(actual_life)
