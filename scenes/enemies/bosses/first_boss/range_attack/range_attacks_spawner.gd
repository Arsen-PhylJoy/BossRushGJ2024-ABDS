class_name RangeAttackSpawner
extends Node2D

@export_category("Bullets spawner settings")
@export_group("Spawn settings")
@export var distance_from_spawn: float = 300
@export var convexity: float = 30
@export var concentration: float = 45
@export_range(1,8) var bullets_amount: int = 6
@export_group("Launch settings")
@export var initial_speed: float = 350.0
@export var _waves: int = 5
@export var _wave_cooldown: float = 0.3
@export var _lauch_by_one_cooldown: float = 0.15
@onready var bullet_pc: PackedScene = preload("res://scenes/enemies/bullet/bullet.tscn")

var _launch_direction: Vector2

func launch_one_by_one(spawn_position:Vector2, aim_position:Vector2,lauch_by_one_cooldown: float = _lauch_by_one_cooldown)->void:
	for bullet: Bullet in _create_bullets(spawn_position, aim_position):
		_launch_bullets([bullet])
		await get_tree().create_timer(lauch_by_one_cooldown).timeout

func launch_odd_even(spawn_position:Vector2, aim_position:Vector2,wave_cooldown: float = _wave_cooldown)->void:
	var odd_bullets: Array[Bullet] = []
	var even_bullets: Array[Bullet] = []
	var i:int = -1
	for bullet: Bullet in _create_bullets(spawn_position, aim_position):
		i+=1
		if(i % 2 == 0):
			even_bullets.append(bullet)
		else:
			odd_bullets.append(bullet)
	_launch_bullets(odd_bullets)
	await get_tree().create_timer(wave_cooldown).timeout
	_launch_bullets(even_bullets)

func launch_wave(spawn_position:Vector2, aim_position:Vector2,waves:int = _waves,wave_cooldown: float = _wave_cooldown)->void:
	for i: int in waves:
		_launch_bullets(_create_bullets(spawn_position, aim_position))
		await get_tree().create_timer(wave_cooldown).timeout

func  _create_bullets(spawn_position:Vector2, aim_position:Vector2)->Array[Bullet]:
	var bullets: Array[Bullet] = []
	_launch_direction = (aim_position - spawn_position).normalized()
	var side_direction: Vector2 = _launch_direction.orthogonal().rotated(PI)
	bullets_amount = randi_range(2,8)
	for i: int in bullets_amount:
		var bullet_instance: Bullet = bullet_pc.instantiate()
		bullets.append(bullet_instance)
	#i - counter for "bullets" index
	var i: int = 0
	for bullet: Bullet in bullets:
		bullet.global_position=_launch_direction*distance_from_spawn
		@warning_ignore("integer_division")
		var moves_to_side: int = i + bullets_amount/2 - i*2
		bullet.global_position+=side_direction*concentration*moves_to_side
		var moves_to_back: int
		@warning_ignore("integer_division")
		var a: int = bullets_amount/2
		if(i<a):
			@warning_ignore("integer_division")
			moves_to_back = abs(i+bullets_amount/2-i*2)
		else:
			@warning_ignore("integer_division")
			moves_to_back = abs(i-bullets_amount/2)
		bullet.global_position+=_launch_direction*convexity*moves_to_back*-1
		i+=1
	return bullets

func _launch_bullets(bullets: Array[Bullet])->void:
	for bullet: Bullet in bullets:
		bullet.global_position+=(get_parent() as Node2D).global_position
		get_tree().current_scene.add_child(bullet)
		bullet.apply_impulse(_launch_direction*initial_speed)
