extends Area2D

class_name Enemy

signal changed_pos
signal player_hit

var speed: int
@export var is_moving: bool = true
var current_path: Array[Vector2i]
