class_name PlayerCharacter
extends CharacterBody2D

@export var player_speed: float = 80.0
@export var total_life: float = 100.0
@export var attack_bullet : PackedScene
var actual_life: float = total_life
@onready var hit_box: Area2D = $HitboxArea2D
@onready var light_knight_sprite: Sprite2D = $Sprite2D
@onready var dark_knight_sprite: Sprite2D = $Sprite_Player_Dark
@onready var animation_tree : AnimationTree = $AnimationTree

var attack_light: float = 10.0
var attack_dark:float = 20.0
var defense_light:float = 25.0
var defense_dark:float = 50.0
var stamina : float = 0 # 100 to 100%, 0 of stamina is 0%, 50 is 50%

var Vector_parry: Vector2 = Vector2(1, 0)
var magnitude_parry:float = 400.0

#
##Is_Light_form?
var is_light_player: bool = true
#
##Damange Delay
var damage_timer : float = 0.0
var damage_delay : float = 2.0


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
	if is_light_player == true:
		light_knight_sprite.set("visible", false)
		dark_knight_sprite.set("visible", true)
		is_light_player = false
	else:
		light_knight_sprite.set("visible", true)
		dark_knight_sprite.set("visible", false)
		is_light_player = true
#

func set_damange_player()->void:
	var random_damange : float
	random_damange = randf_range(1, 1.8)
	
	if is_light_player == true:
		print_debug(attack_light * random_damange)
	else:
		print_debug(attack_dark * random_damange)

func _on_attacked(body: Area2D)-> void:
	if(body.is_in_group("Bullet")):
		var damage_bullet : float = (body.get_parent() as Bullet).damage
		print_debug(damage_bullet)
		if Input.is_action_pressed("reflect_parry"):
			print_debug("you_do_a_parry!")
			#body.get_parent().apply_central_impulse(Vector_parry.normalized() * magnitude_parry)
		else:
			get_damage_player(damage_bullet)

func get_damage_player(damage_of_enemy:float)->void:
	if is_light_player == true:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_light / 100)
		print_debug(actual_life)
	else:
		actual_life -= damage_of_enemy - (damage_of_enemy * defense_dark / 100)
		print_debug(actual_life)
