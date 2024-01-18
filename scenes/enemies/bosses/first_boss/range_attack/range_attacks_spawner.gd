class_name RangeAttackSpawner
extends Node2D

@export var initial_speed: float = 20.0
@export var wave_cooldown: float = 0.3
@export var waves: int = 5
@onready var bullet_pc: PackedScene = preload("res://scenes/enemies/bullet/bullet.tscn")

func attack(central_point:Vector2, aim_points: Array[Vector2])->void:
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
