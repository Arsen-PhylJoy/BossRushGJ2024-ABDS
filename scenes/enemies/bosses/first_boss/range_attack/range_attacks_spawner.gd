class_name RangeAttackSpawner
extends Node2D

@export var initial_speed: float = 20.0
@export var _waves: int = 5
@export var _wave_cooldown: float = 0.3
@export var _lauch_by_one_cooldown: float = 0.15
@onready var bullet_pc: PackedScene = preload("res://scenes/enemies/bullet/bullet.tscn")


func attack_one_by_one(central_point:Vector2, aim_points: Array[Vector2],lauch_by_one_cooldown: float = _lauch_by_one_cooldown)->void:
	for point: Vector2 in aim_points:
		var point_pos: Array[Vector2] = [point]
		var bullet: Array[Bullet] = _create_bullets(point_pos)
		_launch_bullets(bullet, central_point)
		await get_tree().create_timer(lauch_by_one_cooldown).timeout

func attack_odd_even(central_point:Vector2, aim_points: Array[Vector2],wave_cooldown: float = _wave_cooldown)->void:
	var odd_bullets_positions: Array[Vector2] = []
	var even_bullets_positions: Array[Vector2] = []
	var i:int = -1
	for point: Vector2 in aim_points:
		i+=1
		if(i % 2 == 0):
			even_bullets_positions.append(point)
		else:
			odd_bullets_positions.append(point)
	var odd_bullets: Array[Bullet] = _create_bullets(odd_bullets_positions)
	_launch_bullets(odd_bullets, central_point)
	await get_tree().create_timer(wave_cooldown).timeout
	var even_bullets: Array[Bullet] = _create_bullets(even_bullets_positions)
	_launch_bullets(even_bullets, central_point)

func attack_wave(central_point:Vector2, aim_points: Array[Vector2],waves:int = _waves,wave_cooldown: float = _wave_cooldown)->void:
	for i: int in waves:
		var bullets: Array[Bullet] = _create_bullets(aim_points)
		_launch_bullets(bullets, central_point)
		await get_tree().create_timer(wave_cooldown).timeout


func  _create_bullets(spawn_positions:Array[Vector2])->Array[Bullet]:
	var bullets: Array[Bullet] = []
	for pos: Vector2 in spawn_positions:
		var bullet: Bullet = bullet_pc.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = pos
		bullets.append(bullet)
	return bullets

func _launch_bullets(bullets: Array[Bullet] ,cental_point: Vector2)->void:
	for bullet: Bullet in bullets:
		var direction: Vector2 = bullet.global_position - cental_point
		bullet.apply_impulse(direction*initial_speed)
