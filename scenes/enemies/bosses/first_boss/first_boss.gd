class_name FirstBoss
extends CharacterBody2D

@export var max_velocity: Vector2 = Vector2(200,200)
@export var max_speed: float = 200
@export var melee_attack_cooldown: float = 0.3
@export var powerful_attack_cooldown: float = 15.0
var _is_perfoming_powerful_attack: bool = false
var _spike_projectile_melee_ps: PackedScene = preload("res://scenes/enemies/bosses/first_boss/melee_attack/melee_spike.tscn")
var _marks_for_spawn_spikes: Array[Marker2D]
@onready var _spike_powerful_attack_spawner: PowerfulSpikesSpawner = $PowerfulSpikesSpawner
@onready var melee_attack_timer: Timer = $MeleeAttackCooldown
@onready var range_attack_timer: Timer = $MeleeAttackCooldown
@onready var powerful_attack_timer: Timer = $MeleeAttackCooldown

#TESTING /->
@export var is_controlable_by_player: bool = true;
#TESTING \<-

func _ready() -> void:
	if _spike_powerful_attack_spawner.powerful_attack_finished.connect(_on_powerful_attack_done): printerr("Fail: ",get_stack())
	for mark: Marker2D in  $MarksForSpawnMeleeSpikes.get_children():
		_marks_for_spawn_spikes.append(mark)
#TESTING /->
	if is_controlable_by_player:
		$FirstBossBT.queue_free()
#TESTING \<-
	
func _physics_process(delta: float) -> void:
	if(_is_perfoming_powerful_attack):
		return
#TESTING /->
	if is_controlable_by_player:
		_player_control(delta)
	else:
#TESTING \<-
		move_and_collide(velocity*delta)

func melee_attack(position_to_attack:Vector2)->void:
	if( melee_attack_timer.is_stopped()):
		_set_melee_attack(position_to_attack)
		melee_attack_timer.start(melee_attack_cooldown)
	
func range_attack()->void:
	pass

func powerful_attack()->void:
	if( powerful_attack_timer.is_stopped() and !_is_perfoming_powerful_attack):
		_is_perfoming_powerful_attack = true
		var marks_for_spawn_first_phase_spikes: Array[Node] = $MarksForSpawnFirstPhaseSpikes.get_children()
		var marks_for_spawn_second_phase_spikes: Array[Node] = $MarksForSpawnSecondPhaseSpikes.get_children()
		var marks_for_spawn_third_phase_spikes: Array[Node] = $MarksForSpawnThirdPhaseSpikes.get_children()
		_spike_powerful_attack_spawner.spawn_spikes(marks_for_spawn_first_phase_spikes,marks_for_spawn_second_phase_spikes,marks_for_spawn_third_phase_spikes)
		powerful_attack_timer.start(powerful_attack_cooldown)

func _set_melee_attack(position_to_attack:Vector2)->void:
	var spike_ref: Area2D = _spike_projectile_melee_ps.instantiate() as Area2D
	add_child(spike_ref)
	spike_ref.look_at(position_to_attack)
	spike_ref.global_position = _get_closest_mark_position(position_to_attack)
	spike_ref.rotate(PI/2)

func _get_closest_mark_position(to_position:Vector2)->Vector2:
	var closest_distance: float = 200000
	var mark_position: Vector2 = _marks_for_spawn_spikes[0].global_position
	for mark: Marker2D in _marks_for_spawn_spikes:
		var tmp_distance: float = to_position.distance_to(mark.global_position)
		if(closest_distance > tmp_distance):
			closest_distance = tmp_distance
			mark_position = mark.global_position
	return mark_position

func _on_powerful_attack_done()->void:
	_is_perfoming_powerful_attack = false

func _player_control(delta:float)->void:
	velocity = Vector2.ZERO
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1.0
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1.0
	if Input.is_key_pressed(KEY_S):
		velocity.y += 1.0
	if Input.is_key_pressed(KEY_W):
		velocity.y -= 1.0
	velocity = velocity.normalized() * max_speed
	move_and_collide(velocity*delta)
	if Input.is_key_pressed(KEY_Q):
		melee_attack(get_global_mouse_position())
	if Input.is_key_pressed(KEY_E):
		range_attack()
	if Input.is_key_pressed(KEY_R):
		powerful_attack()		