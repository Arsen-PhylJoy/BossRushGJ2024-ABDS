class_name RangeAttackSpawner
extends Node2D

@export var spawn_radius: float = 100.0
@export var intial_speed: float = 100.0
@export var accuracy: float = 50.0
@export var waves: int = 5
@export var bullets_in_wave: int = 4
@onready var bullet_pc: PackedScene = preload("res://scenes/enemies/bullet/bullet.tscn")

func spawn_bullets(position: Vector2, aim_direction:Vector2)->void:
	pass
	
	
func  _create_bullet(aim_direction:Vector2)->Bullet:
	var bullet: Bullet = Bullet.new()
	bullet.apply_force()
	return bullet
