class_name FirstBoss
extends CharacterBody2D
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
@export_subgroup("Positions for perform shoot and powerful attack")
@export var shooting_marks: Array[Marker2D]
@export var powerful_attack_mark: Marker2D
@export_category("Boss")
@export var player_control: bool = false
@export var speed: float = 350.0
@export var melee_attack_cooldown: float = 0.9
@export var powerful_attack_cooldown: float = 15.0
@export var range_attack_cooldown: float = 0.5
var _is_buried: bool = false
var _is_doing_powerful_attack: bool = false
var _is_doing_range_attack: bool = false
var _spike_projectile_melee_ps: PackedScene = preload("res://scenes/enemies/bosses/first_boss/melee_attack/melee_spike.tscn")
var _marks_for_attacks: Array[Marker2D]
var movement_target_position: Vector2
@onready var _melee_cooldown_timer: Timer = Timer.new()
@onready var _powerful_cooldown_timer: Timer = Timer.new()
@onready var _range_cooldown_timer: Timer = Timer.new()
@onready var _range_attack_spawner: RangeAttackSpawner = $RangeAttacksSpawner
@onready var _spike_powerful_attack_spawner: PowerfulSpikesSpawner = $PowerfulSpikesSpawner
@onready var navigation_agent: NavigationAgent2D = $FirstBossNavigationAgent2D
@onready var behaviour_tree: BTPlayer = $FirstBossBehaviorTree
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	#TESTING/->
	behaviour_tree.active = !player_control
	#TESTING/<-
	if navigation_agent.velocity_computed.connect(_on_velocity_computed): printerr("Fail: ",get_stack())
	if animation_tree.animation_finished.connect(_on_buried): printerr("Fail: ",get_stack())
	if animation_tree.animation_finished.connect(_on_unburied): printerr("Fail: ",get_stack())
	if animation_tree.animation_finished.connect(_on_range_attack_finished): printerr("Fail: ",get_stack())
	if _spike_powerful_attack_spawner.powerful_attack_finished.connect(_on_powerful_attack_finished): printerr("Fail: ",get_stack())
	add_child(_melee_cooldown_timer)
	_melee_cooldown_timer.one_shot = true
	add_child(_powerful_cooldown_timer)
	_powerful_cooldown_timer.one_shot = true
	add_child(_range_cooldown_timer)
	_range_cooldown_timer.one_shot = true
	for mark: Marker2D in  $MarksForBossAttacks.get_children():
		_marks_for_attacks.append(mark)
	_ai_setup()
	call_deferred("_actor_setup")
	
func _physics_process(delta: float) -> void:
#TESTING /->
	if !behaviour_tree.active:
		_player_control(delta)
	else:
#TESTING \<-
		_control_ai(delta)
	_update_animation()
		
func set_movement_target(movement_target: Vector2)->void:
	navigation_agent.target_position = movement_target

func bury()->void:
	velocity = Vector2.ZERO
	animation_tree.set("parameters/conditions/is_melee_attack_started",true)
	animation_tree.set("parameters/conditions/is_attacks_finished",false)

func un_bury()->void:
	if(!_is_doing_powerful_attack):
		animation_tree.set("parameters/conditions/is_melee_attack_started",false)
		animation_tree.set("parameters/conditions/is_attacks_finished",true)

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
		_range_attack_spawner.launch_wave(spawn_position,position_to_attack,1,1)
		return true
	return false

func powerful_attack()->void:
	if(_is_buried and _powerful_cooldown_timer.is_stopped()):
		_powerful_cooldown_timer.start(powerful_attack_cooldown)
		_is_doing_powerful_attack = true
		var marks_for_spawn_first_phase_spikes: Array[Node] = $MarksForSpawnFirstPhaseSpikes.get_children()
		var marks_for_spawn_second_phase_spikes: Array[Node] = $MarksForSpawnSecondPhaseSpikes.get_children()
		var marks_for_spawn_third_phase_spikes: Array[Node] = $MarksForSpawnThirdPhaseSpikes.get_children()
		_spike_powerful_attack_spawner.spawn_spikes(marks_for_spawn_first_phase_spikes,marks_for_spawn_second_phase_spikes,marks_for_spawn_third_phase_spikes)
	
func _control_ai(delta:float)->void:
	if navigation_agent.is_navigation_finished():
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position).normalized() * speed
	@warning_ignore("return_value_discarded")
	if(_is_buried):
		velocity = Vector2(0.0,0.0)
	move_and_collide(velocity*delta)
	
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
	if(_is_buried or _is_doing_range_attack or _is_doing_powerful_attack):
		velocity = Vector2.ZERO
	velocity = velocity.normalized() * speed
	@warning_ignore("return_value_discarded")
	move_and_collide(velocity*delta)
	if Input.is_key_pressed(KEY_Q):
		melee_attack(get_global_mouse_position())
	if Input.is_key_pressed(KEY_E):
		range_attack(get_global_mouse_position())
	if Input.is_key_pressed(KEY_R):
		powerful_attack()
	if Input.is_key_pressed(KEY_Z):
		bury()
	if Input.is_key_pressed(KEY_X):
		un_bury()	
#TESTING \<-

func _update_animation()->void:
	animation_tree.set("parameters/conditions/is_idle", !_is_buried and velocity.x == 0)
	animation_tree.set("parameters/conditions/is_move_right", velocity.x>0)
	animation_tree.set("parameters/conditions/is_move_left", velocity.x<0)
	animation_tree.set("parameters/conditions/is_range_attack_started", _is_doing_range_attack)

func _get_closest_mark_position(from_marks: Array[Marker2D],to_position:Vector2)->Vector2:
	var closest_distance: float = 200000
	var shortest_position: Vector2 = from_marks[0].global_position
	for mark: Marker2D in from_marks:
		var tmp_distance: float = to_position.distance_to(mark.global_position)
		if(closest_distance > tmp_distance):
			closest_distance = tmp_distance
			shortest_position = mark.global_position
	return shortest_position

#Special function for navigation, just utility
func _actor_setup()->void:
	await get_tree().physics_frame
	navigation_agent.avoidance_enabled = true

func _ai_setup()->void:
	var bb_data: Dictionary = {
		"max_speed"                     : max_speed,
		"default_speed"                 : default_speed,
		"min_melee_attacks"             : min_melee_attacks,
		"max_melee_attacks"             : max_melee_attacks,
		"melee_attack_distance"         : melee_attack_distance,
		"min_range_attacks"             : min_range_attacks,
		"max_range_attacks"             : max_range_attacks,
#next key:values is used for AI internally
		"remaining_melee_attacks"       : 0,
		"remaining_range_attacks"       : 0,
		"is_moved_to_player"            : false,
	}
	
	for node: Node in get_tree().current_scene.get_children():
		if(node.is_in_group("Player")):
			bb_data.merge({"player" : node})
			break
	behaviour_tree.blackboard.set_data(bb_data)
	
#If boss meet nav_collision then it uses  safe_vector for movement
func _on_velocity_computed(safe_vector:Vector2)->void:
	velocity = safe_vector
	if(!_is_buried):
		@warning_ignore("return_value_discarded")
		move_and_slide()

func _on_powerful_attack_finished()->void:
	_is_doing_powerful_attack = false

func _on_buried(animation: StringName)->void:
	if( animation == "PrePower&MeleeAttack"):
		_is_buried = true

func _on_unburied(animation: StringName)->void:
	if( animation == "PostPower&MeleeAttack"):
		_is_buried = false

func _on_range_attack_finished(animation: StringName)->void:
	if( animation == "PreRangeAttack"):
		_is_doing_range_attack = false
