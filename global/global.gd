extends Node

signal stat_change

var coins: int = 0:
	set(value):
		coins = value
		stat_change.emit()

var battery_level_sec: float = 0:
	set(value):
		battery_level_sec = value
		stat_change.emit()

var fright_level: float = 0:
	set(value):
		fright_level = value
		stat_change.emit()
		#print("emitting")

var fright_mode: bool = false


