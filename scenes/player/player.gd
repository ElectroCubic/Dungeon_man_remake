extends CharacterBody2D

class_name Player

signal fright_mode_activated
signal fright_mode_deactivated
signal battery_died

@export var MAX_SPEED: int = 70
@export var fright_time: int = 10
@export var max_battery_time_sec: float = 180
@export var initial_light_energy_lvl: float = 3
@onready var tile_map = get_node("../TileMap") as TileMap
@onready var anim = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D

var target_pos: Vector2
var is_moving: bool = false
var is_controlled: bool = true
var is_move_key_pressed: bool = false
var direction: Vector2 = Vector2.DOWN

func _ready():
	$FrightTimer.wait_time = fright_time
	point_light_2d.energy = initial_light_energy_lvl
	Global.battery_level_sec = initial_light_energy_lvl * 60

func animate_player():
	if is_move_key_pressed:
		if direction == Vector2.LEFT:
			anim.play("Left")
		elif direction == Vector2.RIGHT:
			anim.play("Right")
		elif direction == Vector2.UP:
			anim.play("Back")
		elif direction == Vector2.DOWN:
			anim.play("Front")
	else:
		if direction == Vector2.LEFT:
			anim.play("Idle_Left")
		elif direction == Vector2.RIGHT:
			anim.play("Idle_Right")
		elif direction == Vector2.UP:
			anim.play("Idle_Back")
		elif direction == Vector2.DOWN:
			anim.play("Idle_Front")

func check_battery_level(delta: float):
	if Global.battery_level_sec > max_battery_time_sec:
		if not $FrightTimer.time_left:
			fright_mode_activated.emit()
			Global.fright_mode = true
			$FrightTimer.start()
			point_light_2d.color = Color.BLUE_VIOLET
		
	elif Global.battery_level_sec > 0:
		Global.battery_level_sec -= delta
		point_light_2d.energy = float(Global.battery_level_sec) / 60
	else:
		battery_died.emit()

func _process(delta: float) -> void:
	check_battery_level(delta)
	
	if is_controlled and not is_moving:
		player_input()

	elif is_moving:
		move_player(delta)
	
func player_input() -> void:
	# Player Movement Controls
	
	is_move_key_pressed = false
	
	if Input.is_action_pressed("Left"):
		get_target_pos(Vector2i.LEFT)
	elif Input.is_action_pressed("Right"):
		get_target_pos(Vector2i.RIGHT)
	elif Input.is_action_pressed("Up"):
		get_target_pos(Vector2i.UP)
	elif Input.is_action_pressed("Down"):
		get_target_pos(Vector2i.DOWN)

	animate_player()

func get_target_pos(dir: Vector2i) -> void:
	is_moving = true
	is_move_key_pressed = true
	direction = dir

	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	var tile_data := tile_map.get_cell_tile_data(0,target_tile)
	
	if tile_data and not tile_data.get_custom_data("Collidable"):
		target_pos = tile_map.map_to_local(target_tile)

func move_player(delta: float) -> void:
	global_position = global_position.move_toward(target_pos, MAX_SPEED * delta)
	
	if global_position == target_pos:
		is_moving = false

func _on_fright_timer_timeout():
	fright_mode_deactivated.emit()
	Global.fright_mode = false
	Global.battery_level_sec = max_battery_time_sec
	point_light_2d.color = Color.WHITE
