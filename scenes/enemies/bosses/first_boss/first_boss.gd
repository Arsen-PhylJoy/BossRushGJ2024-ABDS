class_name FirstBoss
extends CharacterBody2D

signal dead
signal health_changed(max_health: float, actual_health:float)

@export_category("Artificial intelligent")
@export_subgroup("Speed")
@export var default_speed: float = 350.0
@export var max_speed: float = 800.0
@export_subgroup("Melee attacks")
@export var min_melee_attacks: int = 2
@export var max_melee_attacks: int = 4
@export var melee_attack_distance: float = 250.0
@export_subgroup("Range attacks")
@export var min_range_attacks: int = 2
@export var max_range_attacks: int = 4
@export_subgroup("Powerful attack")
@export var duration_of_poweful_attack: float = 6.0
@export var cooldown_between_attacks: float = 0.9
@export_subgroup("Positions for perform shoot and powerful attack")
@export var shooting_marks: Array[Marker2D]
@export var powerful_attack_mark: Marker2D
@export_category("Boss")
@export var health: float = 400.0
@export var speed: float = 350.0
@export var melee_attack_cooldown: float = 0.9
@export var powerful_attack_cooldown: float = 15.0
@export var range_attack_cooldown: float = 0.5
var _is_buried: bool = false
var _is_doing_powerful_attack: bool = false
var is_done_powerful_attack: bool = false
var _is_doing_range_attack: bool = false
var _spike_projectile_melee_ps: PackedScene = preload("res://scenes/enemies/bosses/first_boss/melee_attack/melee_spike.tscn")
var _marks_for_attacks: Array[Marker2D]
var movement_target_position: Vector2
var is_alife: bool = true
@onready var _melee_cooldown_timer: Timer = Timer.new()
@onready var _powerful_cooldown_timer: Timer = Timer.new()
@onready var _range_cooldown_timer: Timer = Timer.new()
@onready var _range_attack_spawner: RangeAttackSpawner = $RangeAttacksSpawner
@onready var _spike_powerful_attack_spawner: PowerfulSpikesSpawner = $PowerfulSpikesSpawner
@onready var _navigation_agent: NavigationAgent2D = $FirstBossNavigationAgent2D
@onready var _behaviour_tree: BTPlayer = $FirstBossBehaviorTree
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _hit_box: Area2D = $DamageArea2D
@onready var _particle_effect: GPUParticles2D = %VFX_leaves
@onready var _health: float = health:
	set(value):
		health_changed.emit(health,_health)
		_health = value
		_update_fight_mode(value)

func _ready() -> void:
	(%BossHUD as CanvasLayer).show()
	if _hit_box.area_entered.connect(_on_area_entered): printerr("Fail: ",get_stack())
	if _navigation_agent.velocity_computed.connect(_on_velocity_computed): printerr("Fail: ",get_stack())
	if _animation_tree.animation_finished.connect(_on_range_attack_finished): printerr("Fail: ",get_stack())
	if _spike_powerful_attack_spawner.powerful_attack_finished.connect(_on_powerful_attack_finished): printerr("Fail: ",get_stack())
	if _powerful_cooldown_timer.timeout.connect(_on_powerful_cooldown_timeout): printerr("Fail: ",get_stack())
	add_child(_melee_cooldown_timer)
	_melee_cooldown_timer.one_shot = true
	add_child(_powerful_cooldown_timer)
	_powerful_cooldown_timer.one_shot = true
	add_child(_range_cooldown_timer)
	_range_cooldown_timer.one_shot = true
	for mark: Marker2D in  $MarksForBossAttacks.get_children():
		_marks_for_attacks.append(mark)
	_setup_ai()
	call_deferred("_actor_setup")
	
func _physics_process(delta: float) -> void:
	_control_ai(delta)
	
func _process(_delta: float) -> void:
	if(velocity==Vector2(0,0)):
		(%WalkSound2D as AudioStreamPlayer2D).stop()
	elif(!(%WalkSound2D as AudioStreamPlayer2D).playing):
		(%WalkSound2D as AudioStreamPlayer2D).play()
	_update_animation()

func set_movement_target(movement_target: Vector2)->void:
	_navigation_agent.target_position = movement_target

func bury()->void:
	if(!_animation_tree.animation_finished.is_connected(_on_buried)):
		if _animation_tree.animation_finished.connect(_on_buried): printerr("Fail: ",get_stack())
	velocity = Vector2.ZERO
	_animation_tree.set("parameters/conditions/is_melee_attack_started",true)
	_animation_tree.set("parameters/conditions/is_attacks_finished",false)

func un_bury()->void:
	if(!_animation_tree.animation_finished.is_connected(_on_unburied)):
		if _animation_tree.animation_finished.connect(_on_unburied): printerr("Fail: ",get_stack())
	if(!_is_doing_powerful_attack):
		_particle_effect.emitting = false
		_animation_tree.set("parameters/conditions/is_melee_attack_started",false)
		_animation_tree.set("parameters/conditions/is_attacks_finished",true)

func melee_attack(position_to_attack: Vector2)->bool:
	if(_is_buried and _melee_cooldown_timer.is_stopped()):
		_melee_cooldown_timer.start(melee_attack_cooldown)
		var spike_ref: Area2D = _spike_projectile_melee_ps.instantiate() as Area2D
		add_child(spike_ref)
		spike_ref.look_at(position_to_attack)
		spike_ref.global_position = _get_closest_mark_position(_marks_for_attacks,position_to_attack)
		spike_ref.rotate(PI/2)
		return true
	return false
	
func range_attack(position_to_attack: Vector2)->bool:
	if(_range_cooldown_timer.is_stopped() and !_is_buried and velocity == Vector2.ZERO):
		_is_doing_range_attack = true
		_range_cooldown_timer.start(range_attack_cooldown)
		var spawn_position:Vector2 = _get_closest_mark_position(_marks_for_attacks,position_to_attack)
		var i: int = randi_range(0,1)
		match i:
			0:
				_range_attack_spawner.launch_wave(spawn_position,position_to_attack,1,range_attack_cooldown)
			1:
				_range_attack_spawner.launch_odd_even(spawn_position,position_to_attack)
		return true
	return false

func powerful_attack(position_to_attack: Vector2)->void:
	if(_is_buried):
		_particle_effect.emitting = true
		_is_doing_powerful_attack = true
		_spike_powerful_attack_spawner.attack(position_to_attack,duration_of_poweful_attack,cooldown_between_attacks)
	
func _control_ai(delta:float)->void:
	if _navigation_agent.is_navigation_finished():
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = _navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position).normalized() * speed
	@warning_ignore("return_value_discarded")
	if(_is_buried):
		velocity = Vector2(0.0,0.0)
	@warning_ignore("return_value_discarded")
	move_and_collide(velocity*delta)

func _update_fight_mode(new_health:float)->void:
	max_speed = lerpf(900,350,new_health/health)
	default_speed = lerpf(700,300,new_health/health)
	melee_attack_cooldown = lerpf(0.3,0.9,new_health/health)
	cooldown_between_attacks = lerpf(0.4,0.9,new_health/health)
	if(_health <= 0 and is_alife):
		is_alife = false
		dead.emit()
	if(_health < 250):
		range_attack_cooldown = 0.1
		min_range_attacks = 10
		max_range_attacks = 15
	
func _update_animation()->void:
	_animation_tree.set("parameters/conditions/is_idle", !_is_buried and velocity.x == 0)
	_animation_tree.set("parameters/conditions/is_move_right", velocity.x>0)
	_animation_tree.set("parameters/conditions/is_move_left", velocity.x<0)
	_animation_tree.set("parameters/conditions/is_range_attack_started", _is_doing_range_attack)

func _get_closest_mark_position(from_marks: Array[Marker2D],to_position:Vector2)->Vector2:
	var closest_distance: float = 200000
	var shortest_position: Vector2 = from_marks[0].global_position
	for mark: Marker2D in from_marks:
		var tmp_distance: float = to_position.distance_to(mark.global_position)
		if(closest_distance > tmp_distance):
			closest_distance = tmp_distance
			shortest_position = mark.global_position
	return shortest_position

#Special function for navigation
func _actor_setup()->void:
	await get_tree().physics_frame
	_navigation_agent.avoidance_enabled = true

func _setup_ai()->void:
	_behaviour_tree.blackboard.set_var("max_speed",max_speed)
	_behaviour_tree.blackboard.set_var("default_speed",default_speed)
	_behaviour_tree.blackboard.set_var("min_melee_attacks",min_melee_attacks)
	_behaviour_tree.blackboard.set_var("max_melee_attacks",max_melee_attacks)
	_behaviour_tree.blackboard.set_var("melee_attack_distance",melee_attack_distance)
	_behaviour_tree.blackboard.set_var("min_range_attacks",min_range_attacks)
	_behaviour_tree.blackboard.set_var("max_range_attacks",max_range_attacks)
	_behaviour_tree.blackboard.set_var("remaining_melee_attacks",0)
	_behaviour_tree.blackboard.set_var("remaining_range_attacks",0)
	_behaviour_tree.blackboard.set_var("is_moved_to_player",false)

func _on_area_entered(area: Area2D)->void:
	if( area.is_in_group("PlayerBullet")):
		_health-=(area.get_parent() as PlayerAttack).damage
		(%OnAttacked as AnimationPlayer).stop()
		(%OnAttacked as AnimationPlayer).play("on_attacked")
	if (area.is_in_group("Bullet") and (area.get_parent() as Bullet).damage_to_enemy):
		(%OnAttacked as AnimationPlayer).stop()
		(%OnAttacked as AnimationPlayer).play("on_attacked")
		_health-=(area.get_parent() as Bullet).damage  

#If boss meet nav_collision then it uses  safe_vector for movement
func _on_velocity_computed(safe_vector:Vector2)->void:
	velocity = safe_vector
	if(!_is_buried):
		@warning_ignore("return_value_discarded")
		move_and_slide()

func _on_powerful_attack_finished()->void:
	_is_doing_powerful_attack = false
	is_done_powerful_attack = true
	un_bury()
	_powerful_cooldown_timer.start(powerful_attack_cooldown)

func _on_powerful_cooldown_timeout()->void:
	is_done_powerful_attack = false

func _on_buried(animation: StringName)->void:
	if( animation == "PrePower&MeleeAttack"):
		_is_buried = true

func _on_unburied(animation: StringName)->void:
	if( animation == "PostPower&MeleeAttack"):
		_is_buried = false

func _on_range_attack_finished(animation: StringName)->void:
	if( animation == "PreRangeAttack"):
		_is_doing_range_attack = false
