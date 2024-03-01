class_name SecondBoss
extends CharacterBody2D


var speed: float = 400.0
var is_perfoming_attack:bool = false
@onready var _navigation_agent: NavigationAgent2D = %SeconBossNavAgent
@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _hit_box: Area2D = %DamageArea2D

func _ready() -> void:
	if _animation_tree.animation_finished.connect(_on_attacks_animations_finished): printerr("Fail: ",get_stack())

func _physics_process(delta: float) -> void:
	#_control_ai(delta)
	_control_player(delta)
	
func _process(_delta: float) -> void:
	_update_animation()

func set_movement_target(movement_target: Vector2)->void:
	_navigation_agent.target_position = movement_target

func _control_ai(delta:float)->void:
	if _navigation_agent.is_navigation_finished():
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = _navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position).normalized() * speed
	move_and_collide(velocity*delta)

func _control_player(delta: float)->void:
	velocity = Vector2.ZERO
	if(Input.is_action_pressed("move_left")):
		velocity.x -= speed
	if(Input.is_action_pressed("move_right")):
		velocity.x += speed
	if(Input.is_action_pressed("move_up")):
		velocity.y -= speed
	if(Input.is_action_pressed("move_down") and !is_perfoming_attack):
		velocity.y += speed
	if(Input.is_action_just_pressed("simple_attack") and !is_perfoming_attack):
		is_perfoming_attack = true
		var i: int = randi_range(0,1)
		if(i == 0):
			_animation_tree.set("parameters/conditions/is_melee",true)
		else:
			_animation_tree.set("parameters/conditions/is_w_melee_ranged",true)
	if(Input.is_action_just_pressed("parry")):
		is_perfoming_attack = true
		var i: int = randi_range(0,1)
		if(i == 0):
			_animation_tree.set("parameters/conditions/is_ranged",true)
		else:
			_animation_tree.set("parameters/conditions/is_w_melee_ranged",true)
	move_and_collide(velocity*delta)
	
func _update_animation()->void:
	_animation_tree.set("parameters/conditions/is_idle",velocity.x == 0)
	_animation_tree.set("parameters/conditions/is_move_right", velocity.x>0 and !is_perfoming_attack)
	_animation_tree.set("parameters/conditions/is_move_left", velocity.x<0 and !is_perfoming_attack)

#Special function for navigation
func _actor_setup()->void:
	await get_tree().physics_frame
	_navigation_agent.avoidance_enabled = true

#If boss meet nav_collision then it uses  safe_vector for movement
func _on_velocity_computed(safe_vector:Vector2)->void:
	velocity = safe_vector

func _on_attacks_animations_finished(animation: StringName)->void:
	if( animation == "melee" or animation == "w_melee_ranged" or animation == "ranged" ):
		_animation_tree.set("parameters/conditions/is_melee",false)
		_animation_tree.set("parameters/conditions/is_ranged",false)
		_animation_tree.set("parameters/conditions/is_w_melee_ranged",false)
	elif( animation == "melee_reverse" or animation == "w_melee_ranged_reverse" or animation == "ranged_reverse" ):
		is_perfoming_attack = false
		
