class_name PlayerCharacter
extends CharacterBody2D

signal dead
signal health_changed(max_health:float,health_value: float)
signal energy_changed(max_energy:float,energy_value: float)

@export var player_speed: float = 80.0
@export var total_life: float = 70.0
@export var attack_bullet : PackedScene
@export var is_in_parry : bool = false
@export var magnitude_parry:float = 800.0
@export var camera2d : Camera2D
@onready var camera2dclass : PlayerCamera = camera2d as PlayerCamera

@onready var actual_life: float = total_life:
	set(value):
		health_changed.emit(total_life,value)
		actual_life = value

@onready var hit_box: Area2D = $HitboxArea2D
#player animations light
@onready var light_knight_idle: Sprite2D = $Sprite_Idle
#player animations dark
@onready var dark_knight_sprite: Sprite2D = $Sprite_Player_Dark
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var playback_node : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var VFX_dark_knight : GPUParticles2D = $DarkKnightVFX
@onready var sfx_Player : AudioStreamPlayer2D = $SFX_Atk
@onready var sfx_Audio1 : AudioStream = preload("res://assets/audio/sfx/player/sword_1.wav") as AudioStream
@onready var sfx_Audio2 : AudioStream = preload("res://assets/audio/sfx/player/sword_2.wav") as AudioStream
@onready var sfx_Audio3 : AudioStream = preload("res://assets/audio/sfx/player/sword_3.wav") as AudioStream
@onready var sfx_Audio4 : AudioStream = preload("res://assets/audio/sfx/player/sword_4.wav") as AudioStream
@onready var sfx_Audio5 : AudioStream = preload("res://assets/audio/sfx/player/sword_5.wav") as AudioStream
@onready var sfx_Audio6 : AudioStream = preload("res://assets/audio/sfx/player/sword_6.wav") as AudioStream
@onready var sfx_Audio7 : AudioStream = preload("res://assets/audio/sfx/player/sword_7.wav") as AudioStream
@onready var sfx_Audio8 : AudioStream = preload("res://assets/audio/sfx/player/sword_8.wav") as AudioStream
@onready var sfx_walk : AudioStreamPlayer2D = $SFX_Walk
@onready var sfx_swap : AudioStreamPlayer2D = $SFX_Swap
@onready var sfx_swap_to_dark : AudioStream = preload("res://assets/audio/sfx/player/turning_dark.wav") as AudioStream
@onready var sfx_swap_to_light : AudioStream = preload("res://assets/audio/sfx/player/swap.wav") as AudioStream
#sfx damage
@onready var sfx_damage_dark : AudioStream = preload("res://assets/audio/sfx/player/player_damaged_light.wav") as AudioStream
@onready var sfx_damage_light : AudioStream = preload("res://assets/audio/sfx/player/player_damaged_dark.wav") as AudioStream
@onready var sfx_parry_audio : AudioStream = preload("res://assets/audio/sfx/player/parry.wav") as AudioStream
@onready var sfx_perfect_parry : AudioStream = preload("res://assets/audio/sfx/player/perfect_parry.wav") as AudioStream
@onready var sfx_damage : AudioStreamPlayer2D = $SFX_Damage
@onready var sfx_parry : AudioStreamPlayer2D = $SFX_Parry

@export var attack_light: float = 15.0
@export var attack_dark:float = 25.0
@export var defense_light:float = 25.0
@export var defense_dark:float = 50.0
@export var enemy_bullet_damage_multiply : float = 1.6

@export var stamina : float = 0: # 100 to 100%, 0 of stamina is 0%, 50 is 50%
	set(value):
		if(StoryState.is_player_has_dark_ability == false):
			return
		energy_changed.emit(100,value)
		stamina = value

@export var magnitude_parry_enemy:float = 50
#
##Is_Light_form?
@export var is_light_player: bool = true
var knight_time: float = 0
@export var knight_delay: float = 20 #20 seconds? I don't know if this is necessary
var dark_knight_inputs : float = 0.1
var dark_knight_frame_shot : bool = false
var is_in_swap_anim : bool = false

var is_in_atk_anim : bool = false
var atk_anim_time : float = 0.0
var atk_anim_delay : float = 0.4
#
##Damange Delay
var invensible : bool = false
var invensible_time : float = 0.0
var invensible_delay : float = 1.0

var parry_time : float = 0
@export var parry_delay : float = 0.8

var is_dead : bool = false

func _ready()->void:
	($PlayerHUD as CanvasLayer).show()
	actual_life = total_life
	if hit_box.area_entered.connect(_on_attacked): printerr("Fail: ",get_stack())
	if (self as PlayerCharacter).dead.connect(_on_dead): printerr("Fail: ",get_stack())
	
#
func _process(delta: float)->void:
	if actual_life <= 0:
		hide()
		if(!is_dead):
			dead.emit()
		#
	if Input.is_action_just_pressed("activate_dark_knight") and StoryState.is_player_has_dark_ability:
		change_player_dark_light()
	if is_light_player == false:
		if Input.is_action_just_pressed("simple_attack"):
			set_damange_player(false)
			if is_light_player == false and dark_knight_frame_shot == false:
				dark_knight_inputs += 0.1
				dark_knight_frame_shot = true
	else:
		if Input.is_action_pressed("simple_attack") and (%LightAttackCooldown as Timer).is_stopped():
			(%LightAttackCooldown as Timer).start()
			set_damange_player(false)

	if Input.is_action_pressed("parry"):
		if is_light_player == true:
			parry_time += delta
	if Input.is_action_just_pressed("parry"):
		if is_light_player == true:
			is_in_parry = true
			sfx_parry.stream = sfx_parry_audio
			sfx_parry.play()
			ParryAnimation()
		elif is_light_player == false and dark_knight_frame_shot == false:
			dark_knight_inputs += 0.1
			set_damange_player(true)
			dark_knight_frame_shot = true
	if Input.is_action_just_released("parry"):
		is_in_parry = false
		parry_time = 0
		if is_light_player:
			playback_node.start("idle")
	if is_in_parry and parry_time > parry_delay:
		is_in_parry = false
		playback_node.start("idle")
		
	if(invensible):
		invensible_time += delta
		if(invensible_time > invensible_delay):
			invensible = false
			invensible_time = 0
			light_knight_idle.modulate = "ffffff"
			dark_knight_sprite.modulate = "ffffff"
			
	if(is_in_atk_anim):
		atk_anim_time += delta
		if(atk_anim_time > atk_anim_delay):
			playback_node.start("idle")
			is_in_atk_anim = false
			atk_anim_time = 0
			
	if(!is_light_player):
		knight_time +=delta
		dark_knight_inputs -= delta
		if dark_knight_inputs <= 0:
			dark_knight_inputs = 0.1
		if(knight_time > knight_delay):
			change_player_dark_light()
			knight_time = 0
			
	animation_tree.set("parameters/Attack/blend_position", get_local_mouse_position().normalized())
	animation_tree.set("parameters/Attack_r/blend_position", get_local_mouse_position().normalized())
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
		#sfx_walk.stop()
		velocity = velocity.normalized() * player_speed
		@warning_ignore("return_value_discarded")
		move_and_collide(velocity * delta)
	else:
		playback_node.travel("idle")
		sfx_walk.play()

func change_player_dark_light()->void:
	if is_light_player == true and stamina >= 100:
		is_in_swap_anim = true
		playback_node.travel("swaptodark")
		sfx_swap.stream = sfx_swap_to_dark
		sfx_swap.play()
		
		await get_tree().create_timer(0.6).timeout
		playback_node.start("idle")
		dark_knight_sprite.set("visible", true)
		light_knight_idle.visible = false
		is_in_swap_anim = false
		
		VFX_dark_knight.set("visible", true)
		VFX_dark_knight.set("emitting", true)
		is_light_player = false
		stamina = 0
	elif(is_light_player == false):
		VFX_dark_knight.set("visible", false)
		VFX_dark_knight.set("emitting", false)
		is_in_swap_anim = true
		sfx_swap.stream = sfx_swap_to_light
		sfx_swap.play()
		
		playback_node.travel("swaptolight")
		await get_tree().create_timer(0.6).timeout
		dark_knight_sprite.visible = false
		light_knight_idle.set("visible", true)
		is_in_swap_anim = false
		is_light_player = true

func ParryAnimation()->void:
	if is_in_swap_anim == false and !is_in_atk_anim and is_in_parry:
		playback_node.travel("Dreflect")

func set_damange_player(is_right_attack : bool)->void:
	if is_in_swap_anim == false and !is_in_atk_anim:
		if is_right_attack:
			playback_node.travel("Attack_r")
		else:
			playback_node.travel("Attack")
		player_shot_sfx()
		animation_tree.set("parameters/idle/blend_position", get_local_mouse_position().normalized())
		animation_tree.set("parameters/walk/blend_position", get_local_mouse_position().normalized())
		is_in_atk_anim = true
	
	var random_damange : float
	random_damange = randf_range(1, 1.8)
	
	if is_light_player == true:
		player_shot(attack_light * random_damange)
	else:
		var more_attacks : float
		more_attacks = randf_range(0, 1)
		if(more_attacks <= dark_knight_inputs):
			player_shot(attack_dark * random_damange)
		player_shot(attack_dark * random_damange)

func player_shot_sfx()->void:
	var random_sfx : int
	random_sfx = randi_range(1, 8)
	match random_sfx:
		1:
			sfx_Player.stream = sfx_Audio1
		2:
			sfx_Player.stream = sfx_Audio2
		3:
			sfx_Player.stream = sfx_Audio3
		4:
			sfx_Player.stream = sfx_Audio4
		5:
			sfx_Player.stream = sfx_Audio5
		6:
			sfx_Player.stream = sfx_Audio6
		7:
			sfx_Player.stream = sfx_Audio7
		8:
			sfx_Player.stream = sfx_Audio8
		_:
			sfx_Player.stream = sfx_Audio1
	sfx_Player.play()

func player_shot(player_damange: float)->void:
	var attack_instance : PlayerAttack = attack_bullet.instantiate() as PlayerAttack
	if !is_light_player:
		attack_instance.get_node("SpriteLightAtk").set("visible", false)
		attack_instance.get_node("SpriteDarkAtk").set("visible", true)
		attack_instance.get_node("GPUParticles2D").set("modulate", "a618fff9")
	attack_instance.position = Vector2(position.x, position.y)
	var mouse_position : Vector2 = get_local_mouse_position().normalized()
	var rotation_angle : float = atan2(mouse_position.y, mouse_position.x)
	attack_instance.rotation = rotation_angle
	attack_instance.set("damage", player_damange)
	var attack_impulse : RigidBody2D = attack_instance as RigidBody2D
	attack_impulse.apply_central_impulse(mouse_position * 1000)
	get_parent().add_child(attack_impulse)

func _on_dead()->void:
	is_dead = true

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
			parry_on_player(body.position)
	elif (body.is_in_group("Spike") or body.is_in_group("PowerSpike")):
		if is_in_parry:
			parry_on_player(body.position)
		else: 
			var damage_spike : float = 0.0
			if(body is PowerfulSpike):
				damage_spike = (body as PowerfulSpike).damage
			else:
				damage_spike = (body as Spike).damage
			if (!invensible):
				get_damage_player(damage_spike)
				invensible = true

func parry_on_player(body_pos : Vector2)->void:
	var player_position : Vector2 = global_position
	@warning_ignore("unused_variable")
	var direction : Vector2 = (body_pos - player_position).normalized()
	var target_velocity : Vector2 = direction * magnitude_parry_enemy
	self.velocity = target_velocity
	@warning_ignore("return_value_discarded")
	move_and_slide()
	sfx_parry.stream = sfx_perfect_parry
	sfx_parry.play()

func parry_to_enemy(body : Node)->void:
	(body.get_parent() as Bullet).damage_to_enemy = true
	if is_light_player == true:
		(body.get_parent() as Bullet).damage =  attack_light * enemy_bullet_damage_multiply
	else:
		(body.get_parent() as Bullet).damage =  attack_dark * enemy_bullet_damage_multiply
	var Enemy_bullet : RigidBody2D = body.get_parent() as RigidBody2D
	var Vector_parry : Vector2 = Enemy_bullet.linear_velocity
	Enemy_bullet.apply_central_impulse(-Vector_parry.normalized() * magnitude_parry)
	sfx_parry.stream = sfx_perfect_parry
	sfx_parry.play()

func get_damage_player(damage_of_enemy:float)->void:
	camera2dclass.apply_shake(0.3, 7.0)
	if is_light_player == true:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_light / 100)
		light_knight_idle.modulate = "ff675b"
		sfx_damage.stream = sfx_damage_light
		sfx_damage.play()
	else:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_dark / 100)
		dark_knight_sprite.modulate = "ff675b"
		sfx_damage.stream = sfx_damage_dark
		sfx_damage.play()
