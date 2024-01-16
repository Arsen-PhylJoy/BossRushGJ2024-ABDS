extends Node2D

signal attack_done

@export var time_to_second_phase :float = 2.0
@export var time_to_third_phase :float = 3.0

@onready var _spike_ps: PackedScene = preload("res://scenes/enemies/bosses/first_boss/powerful_attack/powerful_spike.tscn")
@onready var _phase_timer: Timer = $PhaseTimer
var _positions_for_spawn_first: Array[Vector2]
var _positions_for_spawn_second: Array[Vector2]
var _positions_for_spawn_third: Array[Vector2]

func _ready() -> void:
	connect("attack_done",_on_attacks_done)

func spawn_spikes(marks_for_spawn_first: Array[Node], marks_for_spawn_second: Array[Node],marks_for_spawn_third: Array[Node])->void:
	for mark in marks_for_spawn_first:
		_positions_for_spawn_first.append(mark.global_position)
	for mark in marks_for_spawn_second:
		_positions_for_spawn_second.append(mark.global_position)
	for mark  in marks_for_spawn_third:
		_positions_for_spawn_third.append(mark.global_position)
	_spawn_first_spikes()

	
func _spawn_first_spikes()->void:
	_spawn_spikes(_positions_for_spawn_first)
	_phase_timer.connect("timeout",_spawn_second_spikes)
	_phase_timer.wait_time = time_to_second_phase
	_phase_timer.start()

func _spawn_second_spikes()->void:
	_phase_timer.disconnect("timeout",_spawn_second_spikes)
	_spawn_spikes(_positions_for_spawn_second)
	_phase_timer.connect("timeout",_spawn_third_spikes)
	_phase_timer.wait_time = time_to_third_phase
	_phase_timer.start()

func _spawn_third_spikes()->void:
	_phase_timer.disconnect("timeout",_spawn_third_spikes)
	_spawn_spikes_random_time(_positions_for_spawn_third,0.1,0.3)

func _spawn_spikes(positions: Array[Vector2])->void:
	for pos in positions:
		var spike_node = _spike_ps.instantiate() as Area2D
		add_child(spike_node)
		spike_node.global_position = pos

func _spawn_spikes_random_time(positions: Array[Vector2], delay_from: float, delay_to: float)->void:
	positions.shuffle()
	var timer: Timer = Timer.new()
	add_child(timer)
	var spike_node: Area2D
	for pos in positions:
		spike_node = _spike_ps.instantiate() as Area2D
		add_child(spike_node)
		spike_node.global_position = pos
		timer.start(randfn(delay_from,delay_to))
		await timer.timeout
	timer.wait_time = spike_node.time_to_notify + spike_node.time_to_emerge + spike_node.time_to_disappear
	timer.start()
	await timer.timeout
	timer.queue_free()
	emit_signal("attack_done")

func _on_attacks_done()->void:
	_positions_for_spawn_first.clear()
	_positions_for_spawn_second.clear()
	_positions_for_spawn_third.clear()
