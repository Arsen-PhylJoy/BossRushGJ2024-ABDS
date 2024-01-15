extends CharacterBody2D


@export var max_velocity: Vector2 = Vector2(200,200)
@export var max_speed: float = 200
@export var melee_attack_cooldown: float = 0.3
var spike_projectile_melee_ps: PackedScene = preload("res://scenes/enemies/bosses/first_boss/melee_attack/melee_spike.tscn")
var marks_for_spawn_spikes: Array[Marker2D]

@onready var melee_attack_timer: Timer = $MeleeAttackCooldown

#TESTING /->
@export var is_controlable_by_player: bool = true;
#TESTING \<-

func _ready() -> void:
	for mark in  $Marks_for_spawn_spikes.get_children():
		marks_for_spawn_spikes.append(mark)
#TESTING /->
	if is_controlable_by_player:
		$FirstBossBT.queue_free()
#TESTING \<-

func _physics_process(delta: float) -> void:
#TESTING /->
	if is_controlable_by_player:
		var velocity = Vector2.ZERO
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
#TESTING \<-
	else:
		move_and_collide(velocity*delta)

func melee_attack(position_to_attack:Vector2)->void:
	if( melee_attack_timer.is_stopped()):
		_set_melee_attack(position_to_attack)
		melee_attack_timer.start(melee_attack_cooldown)
	
func range_attack()->void:
	pass

func powerful_attack()->void:
	pass
#RENAME
func _set_melee_attack(position_to_attack:Vector2)->void:
	var spike_ref: Area2D = spike_projectile_melee_ps.instantiate() as Area2D
	add_child(spike_ref)
	spike_ref.look_at(position_to_attack)
	spike_ref.global_position = _get_closest_mark_position(position_to_attack)
	spike_ref.rotate(PI/2)


func _get_closest_mark_position(to_position:Vector2)->Vector2:
	var closest_distance: float = 200000
	var mark_position: Vector2 = marks_for_spawn_spikes[0].global_position
	for mark in marks_for_spawn_spikes:
		var tmp_distance: float = to_position.distance_to(mark.global_position)
		if(closest_distance > tmp_distance):
			closest_distance = tmp_distance
			mark_position = mark.global_position
	return mark_position
