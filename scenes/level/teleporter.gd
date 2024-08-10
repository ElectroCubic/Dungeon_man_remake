@tool
extends Area2D

class_name Teleporter

signal player_near(pos: Vector2)

@export var exit: Teleporter
var exit_pos: Vector2
var exit_direction: Vector2
@export_enum("Left","Right","Up","Down") var exit_dir: String = "Left":
	set(value):
		if value and value != "":
			exit_dir = value
			set_exit_pos()

func _ready():
	exit_pos = $Marker2D.global_position

func set_exit_pos():
	if exit_dir == "Left":
		exit_direction = Vector2.LEFT
		$Marker2D.position = Vector2(-16,0)
		$Sprite2D.flip_h = true
	elif exit_dir == "Right":
		exit_direction = Vector2.RIGHT
		$Marker2D.position = Vector2(16,0)
		$Sprite2D.flip_h = false
	elif exit_dir == "Up":
		exit_direction = Vector2.UP
		$Marker2D.position = Vector2(0,-16)
	elif exit_dir == "Down":
		exit_direction = Vector2.DOWN
		$Marker2D.position = Vector2(0,16)

func _on_body_entered(body):
	body.is_moving = false
	body.is_move_key_pressed = false
	body.direction = exit.exit_direction
	body.global_position = exit.exit_pos

func _on_area_entered(area):
	if area is ActiveEnemy:
		area.current_path.clear()
		area.is_moving = false
		area.global_position = exit.exit_pos
		area.is_moving = true

func _on_player_near_body_entered(body):
	if body.name == "Player":
		player_near.emit(global_position)
