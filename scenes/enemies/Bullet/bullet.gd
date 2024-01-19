class_name Bullet
extends RigidBody2D

@export var damage:float = 30.0
@export var explosion_VFX: PackedScene = preload("res://scenes/VFX/bullet_exposion.tscn")
@onready var _damage_area: Area2D =$DamageArea2D
@onready var _visible_notifier : VisibleOnScreenNotifier2D = $BulletVisibleOnScreenNotifier2D


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	if _visible_notifier.screen_exited.connect(queue_free): printerr("Fail: ",get_stack()) 
	if _damage_area.area_entered.connect(_on_body_entered): printerr("Fail: ",get_stack())


func _on_body_entered(area: Area2D)->void:
	if( area.is_in_group("Enemy")):
		return
	var explosion_VFX_instance: GPUParticles2D = explosion_VFX.instantiate() as GPUParticles2D
	get_tree().current_scene.add_child(explosion_VFX_instance)
	explosion_VFX_instance.global_position = self.global_position
	explosion_VFX_instance.restart()
	queue_free()
