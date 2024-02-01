class_name PlayerAttack
extends RigidBody2D

@export var damage:float = 0
@export var explosion_VFX: PackedScene = preload("res://scenes/VFX/bullet_exposion.tscn")
@onready var _damage_area: Area2D = $CollisionArea
@onready var _visible_notifier : VisibleOnScreenNotifier2D = $BulletVisibleOnScreenNotifier2D

@export var stamina_increase:float = 10

var life_time : float = 0
var life_delay : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	if _visible_notifier.screen_exited.connect(queue_free): printerr("Fail: ",get_stack()) 
	if _damage_area.area_entered.connect(_on_body_entered): printerr("Fail: ",get_stack())

func _process(delta: float)->void:
	life_time += delta
	if (life_time > life_delay):
		queue_free()

func _on_body_entered(area: Area2D)->void:
	if( area.is_in_group("Player") or area.is_in_group("PlayerBullet") or area.is_in_group("Bullet") or area.is_in_group("Spike")):
		return
	elif (area.is_in_group("Enemy")):
		var Player : PlayerCharacter = get_parent().get_node("Player") as PlayerCharacter
		if Player.is_light_player:
			Player.set("stamina", stamina_increase + Player.stamina)
		var explosion_VFX_instance: GPUParticles2D = explosion_VFX.instantiate() as GPUParticles2D
		get_tree().current_scene.add_child(explosion_VFX_instance)
		explosion_VFX_instance.global_position = self.global_position
		explosion_VFX_instance.restart()
		queue_free()
	else:
		var explosion_VFX_instance: GPUParticles2D = explosion_VFX.instantiate() as GPUParticles2D
		get_tree().current_scene.add_child(explosion_VFX_instance)
		explosion_VFX_instance.global_position = self.global_position
		explosion_VFX_instance.restart()
		queue_free()
