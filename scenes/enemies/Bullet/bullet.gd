class_name Bullet
extends RigidBody2D

@export var damange:float = 30.0
@export var explosion_VFX: PackedScene = preload("res://scenes/VFX/bullet_exposion.tscn")
@onready var _visible_notifier : VisibleOnScreenNotifier2D = $BulletVisibleOnScreenNotifier2D
@onready var damage_area: Area2D = $DamageArea2D


# Called when the node enters the scene tree for the first time.
func _ready()->void:
	if _visible_notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited): printerr("Fail: ",get_stack()) 
	if damage_area.area_entered.connect(_on_body_entered): printerr("Fail: ",get_stack())
	
func _on_visible_on_screen_notifier_2d_screen_exited()->void:
	queue_free()

func _on_body_entered(area: Area2D)->void:
	var explosion_VFX_instance: GPUParticles2D = explosion_VFX.instantiate() as GPUParticles2D
	get_tree().current_scene.add_child(explosion_VFX_instance)
	explosion_VFX_instance.emitting = true;
	explosion_VFX_instance.global_position = area.global_position
	queue_free()
