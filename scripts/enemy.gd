extends Area2D

class_name Enemy

signal changed_pos
signal player_hit(sig_name)

var speed: int
var direction: Vector2
@export var is_moving: bool = true
var current_path: Array[Vector2i]
