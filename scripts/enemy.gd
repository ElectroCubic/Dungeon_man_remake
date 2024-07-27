extends Area2D

class_name Enemy

signal changed_pos
signal player_hit

var speed: int
var is_chasing: bool = false
var is_moving: bool = false
var current_path: Array[Vector2i]
