class_name FirstBoss
extends CharacterBody2D

@export var speed: float = 200.0
@export var go_to_mark_speed: float = 400.0
@export var wander_speed: float = 200.0
@export var melee_attack_cooldown: float = 0.3
@export var powerful_attack_cooldown: float = 15.0
@export var range_attack_cooldown: float = 0.5
@export var shooting_marks: Array[Marker2D]
@export var powerful_attack_mark: Marker2D
var _is_perfoming_powerful_attack: bool = false
var _spike_projectile_melee_ps: PackedScene = preload("res://scenes/enemies/bosses/first_boss/melee_attack/melee_spike.tscn")
var _marks_for_spawn_spikes: Array[Marker2D]
var _marks_for_spawn_bullets: Array[Marker2D]
var movement_target_position: Vector2
@onready var _range_attack_spawner: RangeAttackSpawner = $RangeAttacksSpawner
@onready var _spike_powerful_attack_spawner: PowerfulSpikesSpawner = $PowerfulSpikesSpawner
@onready var navigation_agent: NavigationAgent2D = $FirstBossNavigationAgent2D


func _ready() -> void:
	if navigation_agent.velocity_computed.connect(_on_velocity_computed): printerr("Fail: ",get_stack())
	if _spike_powerful_attack_spawner.powerful_attack_finished.connect(_on_powerful_attack_done): printerr("Fail: ",get_stack())
	for mark: Marker2D in  $MarksForSpawnMeleeSpikes.get_children():
		_marks_for_spawn_spikes.append(mark)
	for mark: Marker2D in  $MarksForSpawnBullets.get_children():
		_marks_for_spawn_bullets.append(mark)
		# Make sure to not await during _ready.
	call_deferred("_actor_setup")

func _actor_setup()->void:
	await get_tree().physics_frame
	navigation_agent.avoidance_enabled = true
	
func set_movement_target(movement_target: Vector2)->void:
	navigation_agent.target_position = movement_target
	
func _physics_process(delta: float) -> void:
	if(_is_perfoming_powerful_attack):
		return
#TESTING /->
	if !($FirstBossBehaviorTree as BTPlayer).active:
		_player_control(delta)
	else:
#TESTING \<-
		_control_ai(delta)

func _control_ai(delta:float)->void:
	if navigation_agent.is_navigation_finished():
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position).normalized() * speed
	@warning_ignore("return_value_discarded")
	move_and_collide(velocity*delta)

func melee_attack(position_to_attack:Vector2)->void:
	var spike_ref: Area2D = _spike_projectile_melee_ps.instantiate() as Area2D
	add_child(spike_ref)
	spike_ref.look_at(position_to_attack)
	spike_ref.global_position = _get_closest_mark_position(_marks_for_spawn_spikes,position_to_attack)
	spike_ref.rotate(PI/2)

func range_attack(position_to_attack: Vector2)->void:
	var central_pos_for_attack:Vector2 = _get_closest_mark_position(_marks_for_spawn_bullets,position_to_attack)
	var aim_points: Array[Vector2] = []
	for mark: Marker2D in _marks_for_spawn_bullets:
		if(mark.global_position == central_pos_for_attack):
			for aim_point:Marker2D in mark.get_children():
				aim_points.append(aim_point.global_position)
		_range_attack_spawner.attack_one_by_one(central_pos_for_attack,aim_points)

func powerful_attack()->void:
	if(!_is_perfoming_powerful_attack):
		_is_perfoming_powerful_attack = true
		var marks_for_spawn_first_phase_spikes: Array[Node] = $MarksForSpawnFirstPhaseSpikes.get_children()
		var marks_for_spawn_second_phase_spikes: Array[Node] = $MarksForSpawnSecondPhaseSpikes.get_children()
		var marks_for_spawn_third_phase_spikes: Array[Node] = $MarksForSpawnThirdPhaseSpikes.get_children()
		_spike_powerful_attack_spawner.spawn_spikes(marks_for_spawn_first_phase_spikes,marks_for_spawn_second_phase_spikes,marks_for_spawn_third_phase_spikes)

	
#TESTING /->
func _player_control(delta:float)->void:
	velocity = Vector2.ZERO
	if Input.is_key_pressed(KEY_J):
		velocity.x += 1.0
	if Input.is_key_pressed(KEY_G):
		velocity.x -= 1.0
	if Input.is_key_pressed(KEY_H):
		velocity.y += 1.0
	if Input.is_key_pressed(KEY_Y):
		velocity.y -= 1.0
	velocity = velocity.normalized() * speed
	@warning_ignore("return_value_discarded")
	move_and_collide(velocity*delta)
	if Input.is_key_pressed(KEY_Q):
		melee_attack(get_global_mouse_position())
	if Input.is_key_pressed(KEY_E):
		range_attack(get_global_mouse_position())
	if Input.is_key_pressed(KEY_R):
		powerful_attack()		
#TESTING \<-

func _get_closest_mark_position(from_marks: Array[Marker2D],to_position:Vector2)->Vector2:
	var closest_distance: float = 200000
	var shortest_position: Vector2 = from_marks[0].global_position
	for mark: Marker2D in from_marks:
		var tmp_distance: float = to_position.distance_to(mark.global_position)
		if(closest_distance > tmp_distance):
			closest_distance = tmp_distance
			shortest_position = mark.global_position
	return shortest_position

func _on_velocity_computed(safe_vector:Vector2)->void:
	velocity = safe_vector
	if(!_is_perfoming_powerful_attack):
		@warning_ignore("return_value_discarded")
		move_and_slide()
	
func _on_powerful_attack_done()->void:
	_is_perfoming_powerful_attack = false
