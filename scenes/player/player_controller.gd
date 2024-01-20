class_name PlayerCharacter
extends CharacterBody2D

@export var player_speed: float = 80.0
@export var total_life: float = 100.0
@export var attack_bullet : PackedScene
@export var is_in_parry : bool = false
@export var magnitude_parry:float = 800.0
var actual_life: float = total_life
@onready var hit_box: Area2D = $HitboxArea2D
@onready var light_knight_sprite: Sprite2D = $Sprite2D
@onready var dark_knight_sprite: Sprite2D = $Sprite_Player_Dark
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var VFX_dark_knight : GPUParticles2D = $GPUParticles2D

var attack_light: float = 10.0
var attack_dark:float = 20.0
var defense_light:float = 25.0
var defense_dark:float = 50.0
@export var stamina : float = 0 # 100 to 100%, 0 of stamina is 0%, 50 is 50%

#
##Is_Light_form?
var is_light_player: bool = true
var knight_time: float = 0
var knight_delay: float = 20 #20 seconds? I don't know if this is necessary

#
##Damange Delay
var invensible : bool = false
var invensible_time : float = 0.0
var invensible_delay : float = 1.0

var parry_time : float = 0
var parry_delay : float = 0.8

func _ready()->void:
	if hit_box.area_entered.connect(_on_attacked): printerr("Fail: ",get_stack())
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

	if Input.is_action_pressed("reflect_parry"):
		parry_time += delta
	if Input.is_action_just_pressed("reflect_parry"):
		is_in_parry = true
		print_debug("is_in_parry_mode")
	if Input.is_action_just_released("reflect_parry"):
		is_in_parry = false
		parry_time = 0
		print_debug("parry_off")
	if is_in_parry and parry_time > parry_delay:
		is_in_parry = false
		print_debug("parry_canceled")
		
	if(invensible):
		invensible_time += delta
		if(invensible_time > invensible_delay):
			invensible = false
			invensible_time = 0
			
	if(!is_light_player):
		knight_time +=delta
		if(knight_time > knight_delay):
			Change_Player_Dark_Light()
			knight_time = 0
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
		animation_tree.set("parameters/idle/blend_position", velocity.normalized())
		animation_tree.set("parameters/walk/blend_position", velocity.normalized())
		var playback_node : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
		playback_node.travel("walk")
		velocity = velocity.normalized() * player_speed
		position += velocity * delta
	else:
		var playback_node : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
		playback_node.travel("idle")

func Change_Player_Dark_Light()->void:
	if is_light_player == true and stamina >= 100:
		light_knight_sprite.set("visible", false)
		dark_knight_sprite.set("visible", true)
		VFX_dark_knight.set("visible", true)
		VFX_dark_knight.set("emitting", true)
		is_light_player = false
		stamina = 0
	elif(is_light_player == false):
		light_knight_sprite.set("visible", true)
		dark_knight_sprite.set("visible", false)
		VFX_dark_knight.set("visible", false)
		VFX_dark_knight.set("emitting", false)
		is_light_player = true
#

func set_damange_player()->void:
	var random_damange : float
	random_damange = randf_range(1, 1.8)
	
	if is_light_player == true:
		var attack_instance : Player_Attack = attack_bullet.instantiate() as Player_Attack
		attack_instance.position = Vector2(position.x, position.y)
		attack_instance.set("damage", attack_light * random_damange)
		var attack_impulse : RigidBody2D = attack_instance as RigidBody2D
		var mouse_position : Vector2 = get_global_mouse_position().normalized()
		attack_impulse.apply_central_impulse(mouse_position * 1000)
		get_parent().add_child(attack_impulse)
	else:
		var attack_instance : Player_Attack = attack_bullet.instantiate() as Player_Attack
		attack_instance.position = Vector2(position.x, position.y)
		attack_instance.set("damage", attack_dark * random_damange)
		var attack_impulse : RigidBody2D = attack_instance as RigidBody2D
		var mouse_position : Vector2 = get_global_mouse_position().normalized()
		attack_impulse.apply_central_impulse(mouse_position * 1000)
		get_parent().add_child(attack_impulse)

func _on_attacked(body: Area2D)-> void:
	if(body.is_in_group("Bullet")):
		var damage_bullet : float = (body.get_parent() as Bullet).damage
		if is_in_parry:
			var Enemy_bullet : RigidBody2D = body.get_parent() as RigidBody2D
			var Vector_parry : Vector2 = Enemy_bullet.linear_velocity
			Enemy_bullet.apply_central_impulse(-Vector_parry.normalized() * magnitude_parry)
		else:
			if (!invensible):
				get_damage_player(damage_bullet)
				invensible = true

func get_damage_player(damage_of_enemy:float)->void:
	if is_light_player == true:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_light / 100)
		print_debug(actual_life)
	else:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_dark / 100)
		print_debug(actual_life)
