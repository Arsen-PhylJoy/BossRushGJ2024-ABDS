class_name PowerfulSpikesSpawner 
extends Node2D
	
signal powerful_attack_finished

@onready var _spike_ps: PackedScene = preload("res://scenes/enemies/bosses/first_boss/powerful_attack/powerful_spike.tscn")
@onready var _attack_cooldown: Timer = $AttackCooldown
@onready var _attack_duration: Timer = $AttackDuration
var _spikes_pool: Array[PowerfulSpike]

func _ready() -> void:
	if _attack_duration.timeout.connect(_on_powerful_attack_finished):printerr("Fail: ",get_stack()) 

func attack(position_to_attack: Vector2, duration_of_attack: float = 8.0,attack_cooldown:float = 0.9)->void:
	attack_handle(duration_of_attack)
	if(_spikes_pool.size()<3 and _attack_cooldown.is_stopped()):
		_attack_cooldown.start(attack_cooldown)
		var spike_node: PowerfulSpike = _spike_ps.instantiate() as PowerfulSpike
		if( StoryState.is_player_has_dark_ability == false ):
			spike_node.damage = 10000.0
			spike_node.time_to_notify = 0.5
			spike_node.time_to_emerge = 0.3
		get_parent().add_child(spike_node)
		spike_node.global_position = position_to_attack
		if spike_node.tree_exited.connect(_on_spike_exited):printerr("Fail: ",get_stack()) 
		_spikes_pool.append(spike_node)


func attack_handle(duration_of_attack: float = 8.0)->void:
	if(_attack_duration.is_stopped()):
		_attack_duration.start(duration_of_attack)

func _on_spike_exited()->void:
	_spikes_pool.pop_back()

func _on_powerful_attack_finished()->void:
	powerful_attack_finished.emit()
