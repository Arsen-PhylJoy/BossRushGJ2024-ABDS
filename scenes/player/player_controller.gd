class_name PlayerCharacter
extends CharacterBody2D

@export var player_speed: float = 80.0
@export var total_life: float = 100.0
@export var attack_bullet : PackedScene
@export var is_in_parry : bool = false
@export var magnitude_parry:float = 800.0
var actual_life: float = total_life
@onready var hit_box: Area2D = $HitboxArea2D
#player animations light
@onready var light_knight_sprite: Sprite2D = $Sprite2D
@onready var light_knight_idle: Sprite2D = $Sprite_Idle
@onready var light_knight_attack: Sprite2D = $Sprite_Attack_Light
@onready var light_knight_parry: Sprite2D = $Sprite_Attack_Parry
@onready var light_swap: Sprite2D = $Sprite_Swap_toDark
#player animations dark
@onready var dark_knight_sprite: Sprite2D = $Sprite_Player_Dark
@onready var dark_knight_swap: Sprite2D = $Sprite_Swap_toLight
@onready var dark_knight_LAttack: Sprite2D = $Sprite_Dark_AttackL
@onready var dark_knight_RAttack: Sprite2D = $Sprite_Dark_AttackR
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var playback_node : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback

@onready var VFX_dark_knight : GPUParticles2D = $GPUParticles2D

@export var attack_light: float = 10.0
@export var attack_dark:float = 20.0
@export var defense_light:float = 25.0
@export var defense_dark:float = 50.0
@export var stamina : float = 0 # 100 to 100%, 0 of stamina is 0%, 50 is 50%
@export var magnitude_parry_enemy:float = 50
#
##Is_Light_form?
@export var is_light_player: bool = true
var knight_time: float = 0
@export var knight_delay: float = 20 #20 seconds? I don't know if this is necessary
var dark_knight_inputs : float = 0.1
var dark_knight_frame_shot : bool = false
var is_in_swapAnim : bool = false
var is_in_AtkAnim : bool = false

#
##Damange Delay
var invensible : bool = false
var invensible_time : float = 0.0
var invensible_delay : float = 1.0

var parry_time : float = 0
@export var parry_delay : float = 0.8

func _ready()->void:
	if hit_box.area_entered.connect(_on_attacked): printerr("Fail: ",get_stack())
	pass
#
func _process(delta: float)->void:
	if actual_life <= 0:
		print_debug(actual_life)
		hide()
		#Game_over() function?
		#
	if Input.is_action_just_pressed("ui_accept"):
		Change_Player_Dark_Light()
	if Input.is_action_just_pressed("simple_attack"):
		set_damange_player(false)
		if is_light_player == false and dark_knight_frame_shot == false:
			dark_knight_inputs += 0.1
			dark_knight_frame_shot = true

	if Input.is_action_pressed("parry"):
		if is_light_player == true:
			parry_time += delta
	if Input.is_action_just_pressed("parry"):
		if is_light_player == true:
			is_in_parry = true
			ParryAnimation()
			print_debug("is_in_parry_mode")
		elif is_light_player == false and dark_knight_frame_shot == false:
			dark_knight_inputs += 0.1
			set_damange_player(true)
			dark_knight_frame_shot = true
	if Input.is_action_just_released("parry"):
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
		dark_knight_inputs -= delta
		if dark_knight_inputs <= 0:
			dark_knight_inputs = 0.1
		if(knight_time > knight_delay):
			Change_Player_Dark_Light()
			knight_time = 0
			
	animation_tree.set("parameters/Attack/blend_position", get_local_mouse_position().normalized())
	dark_knight_frame_shot = false
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
		animation_tree.set("parameters/Dreflect/blend_position", velocity.normalized())
		playback_node.travel("walk")
		if is_light_player and playback_node.get_current_node() == "walk" and !is_in_AtkAnim:
			light_knight_idle.set("visible", false)
			light_knight_sprite.set("visible", true)
			setOffDarkSprites()
		elif is_light_player == false and playback_node.get_current_node() == "walk":
			setOffLightSprites()
		velocity = velocity.normalized() * player_speed
		position += velocity * delta
	else:
		playback_node.travel("idle")
		if is_light_player and playback_node.get_current_node() == "idle" and !is_in_AtkAnim:
			light_knight_idle.set("visible", true)
			light_knight_sprite.set("visible", false)
			setOffDarkSprites()
		elif is_light_player == false and playback_node.get_current_node() == "walk":
			setOffLightSprites()

func Change_Player_Dark_Light()->void:
	if is_light_player == true and stamina >= 100:
		
		setOffLightSprites()
		light_swap.visible = true
		is_in_swapAnim = true
		playback_node.travel("swaptodark")
		
		await get_tree().create_timer(0.6).timeout
		playback_node.start("idle")
		dark_knight_sprite.set("visible", true)
		light_swap.visible = false
		is_in_swapAnim = false
		
		VFX_dark_knight.set("visible", true)
		VFX_dark_knight.set("emitting", true)
		is_light_player = false
		stamina = 0
	elif(is_light_player == false):
		setOffDarkSprites()
		
		VFX_dark_knight.set("visible", false)
		VFX_dark_knight.set("emitting", false)
		is_in_swapAnim = true
		dark_knight_swap.visible = true
		playback_node.travel("swaptolight")
		await get_tree().create_timer(0.6).timeout
		
		light_knight_idle.set("visible", true)
		dark_knight_swap.visible = false
		is_in_swapAnim = false
	
		is_light_player = true

func setOffLightSprites()->void:
	light_knight_sprite.visible = false
	light_knight_idle.visible = false 
	light_knight_attack.visible = false 
	light_knight_parry.visible = false 
	light_swap.visible = false

func setOffDarkSprites()->void:
	dark_knight_sprite.visible = false
	dark_knight_swap.visible = false 
	dark_knight_LAttack.visible = false 
	dark_knight_RAttack.visible = false

func ParryAnimation()->void:
	if is_in_swapAnim == false and !is_in_AtkAnim:
		light_knight_parry.visible = true
		light_knight_sprite.visible = false
		light_knight_idle.visible = false
		light_knight_attack.visible = false
		playback_node.travel("Dreflect")
		await get_tree().create_timer(0.4).timeout
		playback_node.start("idle")
		light_knight_parry.visible = false
		light_knight_idle.visible = true

func set_damange_player(is_right_attack : bool)->void:
	
	if is_in_swapAnim == false:
		if is_light_player:
			light_knight_attack.set("visible", true)
			light_knight_idle.set("visible", false)
			light_knight_sprite.set("visible", false)
			light_knight_parry.set("visible", false)
		else:
			if is_right_attack:
				dark_knight_RAttack.visible = true
				dark_knight_LAttack.visible = false
				dark_knight_sprite.visible = false 
			else:
				dark_knight_LAttack.visible = true 
				dark_knight_RAttack.visible = false
				dark_knight_sprite.visible = false 
		playback_node.travel("Attack")
		is_in_AtkAnim = true
	
	var random_damange : float
	random_damange = randf_range(1, 1.8)
	
	if is_light_player == true:
		Player_shot(attack_light * random_damange)
	else:
		var more_attacks : float
		more_attacks = randf_range(0, 1)
		if(more_attacks <= dark_knight_inputs):
			Player_shot(attack_dark * random_damange)
		Player_shot(attack_dark * random_damange)
	
	if is_in_swapAnim == false:
		await get_tree().create_timer(0.4).timeout
		playback_node.start("idle")
		
		if is_light_player:
			light_knight_attack.set("visible", false)
			light_knight_idle.set("visible", true)
		else:
			if is_right_attack:
				dark_knight_RAttack.visible = false
				dark_knight_sprite.visible = true
			else:
				dark_knight_LAttack.visible = false
				dark_knight_sprite.visible = true
		is_in_AtkAnim = false


func Player_shot(player_damange: float)->void:
	var attack_instance : PlayerAttack = attack_bullet.instantiate() as PlayerAttack
	attack_instance.position = Vector2(position.x, position.y)
	var mouse_position : Vector2 = get_local_mouse_position().normalized()
	var rotation_angle : float = atan2(mouse_position.y, mouse_position.x)
	attack_instance.rotation = rotation_angle
	var particles : GPUParticles2D = attack_instance.get_node("GPUParticles2D") as GPUParticles2D
	particles.rotation = rotation_angle
	attack_instance.set("damage", player_damange)
	var attack_impulse : RigidBody2D = attack_instance as RigidBody2D
	attack_impulse.apply_central_impulse(mouse_position * 1000)
	get_parent().add_child(attack_impulse)

func _on_attacked(body: Area2D)-> void:
	if(body.is_in_group("Bullet")):
		var damage_bullet : float = (body.get_parent() as Bullet).damage
		if is_in_parry:
			parry_to_enemy(body)
		else:
			if (!invensible):
				get_damage_player(damage_bullet)
				invensible = true
	elif (body.is_in_group("Enemy")):
		if is_in_parry:
			parry_on_player()
	elif (body.is_in_group("Spike")):
		if is_in_parry:
			parry_on_player()
		else: 
			var damage_spike : float = body.get("damage")
			if (!invensible):
				get_damage_player(damage_spike)
				invensible = true

func parry_on_player()->void:
	var smoothness : float = 0.4
	var target_velocity : Vector2 = -self.velocity * magnitude_parry_enemy
	self.velocity = self.velocity.lerp(target_velocity, smoothness)
	move_and_slide()

func parry_to_enemy(body : Node)->void:
	var Enemy_bullet : RigidBody2D = body.get_parent() as RigidBody2D
	var Vector_parry : Vector2 = Enemy_bullet.linear_velocity
	Enemy_bullet.apply_central_impulse(-Vector_parry.normalized() * magnitude_parry)

func get_damage_player(damage_of_enemy:float)->void:
	if is_light_player == true:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_light / 100)
	else:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_dark / 100)
