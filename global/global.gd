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

var lvlCount: int = 1:
	set(value):
		lvlCount = value
		stat_change.emit()

var total_coins: int = 5
var fright_mode: bool = false
var game_over: bool = false
var intro_scene: bool = false
var has_played: bool = false
