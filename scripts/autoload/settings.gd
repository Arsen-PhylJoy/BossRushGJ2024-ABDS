extends Node


var master_volume: float = 100:
	set(value):
		if(value > 100):
			return
		else:
			master_volume = value
var music_volume: float = 100:
	set(value):
		if(value > 100):
			return
		else:
			master_volume = value
var sfx_volume: float = 100:
	set(value):
		if(value > 100):
			return
		else:
			master_volume = value
