extends CharacterBody2D

class_name Player

signal fright_mode_activated
signal fright_mode_deactivated
signal battery_died(sig_name)

@export var MAX_SPEED: int = 80
@export var fright_time: int = 10
@export var max_battery_time_sec: float = 180
@export var initial_light_energy_lvl: float = 3
@export var min_light_radius: float = 0.18
@export var max_light_radius: float = 0.25
@onready var tile_map = get_node("../TileMap") as TileMap
@onready var bg_tile_map = $"../BgTileMap" as TileMap
@onready var anim := $AnimatedSprite2D
@onready var point_light_2d := $PointLight2D
@onready var fright_bar := $FrightLevel/FrightBar

var target_pos: Vector2
var is_moving: bool = false
var is_controlled: bool = true
var is_move_key_pressed: bool = false
var direction: Vector2 = Vector2.DOWN

var scale_down_threshold_time: int = 60
var total_time_range: float
var scaled_down_range: float

func _ready() -> void:
	total_time_range = max_battery_time_sec - scale_down_threshold_time
	scaled_down_range = max_light_radius - min_light_radius
	fright_bar.hide()
	$FrightTimer.wait_time = fright_time
	fright_bar.max_value = fright_time
	point_light_2d.energy = initial_light_energy_lvl
	point_light_2d.texture_scale = max_light_radius
	Global.battery_level_sec = max_battery_time_sec

func animate_player() -> void:
	if is_move_key_pressed and is_moving:
		if direction == Vector2.LEFT:
			anim.flip_h = true
			if Global.fright_mode:
				anim.play("Powered_right")
			else:
				anim.play("Right")
			
		elif direction == Vector2.RIGHT:
			anim.flip_h = false
			if Global.fright_mode:
				anim.play("Powered_right")
			else:
				anim.play("Right")
			
		elif direction == Vector2.UP:
			anim.play("Back")
			
		elif direction == Vector2.DOWN:
			if Global.fright_mode:
				anim.play("Powered_front")
			else:
				anim.play("Front")
			
	else:
		if direction == Vector2.LEFT:
			anim.flip_h = true
			if Global.fright_mode:
				anim.play("Powered_right_idle")
			else:
				anim.play("Idle_Right")
			
		elif direction == Vector2.RIGHT:
			anim.flip_h = false
			if Global.fright_mode:
				anim.play("Powered_right_idle")
			else:
				anim.play("Idle_Right")
			
		elif direction == Vector2.UP:
			anim.animation = "Idle_Back"
			
		elif direction == Vector2.DOWN:
			if Global.fright_mode:
				anim.play("Powered_front_idle")
			else:
				anim.play("Idle_Front")

func check_battery_level(delta: float):
	if Global.battery_level_sec > max_battery_time_sec:
		if not $FrightTimer.time_left:
			fright_mode_activated.emit()
			Global.fright_mode = true
			$FrightTimer.start()
			point_light_2d.color = Color.BLUE_VIOLET
			
		Global.fright_level = $FrightTimer.time_left
		
	elif Global.battery_level_sec > 0:
		Global.battery_level_sec -= delta

		if Global.battery_level_sec > 30:
			point_light_2d.energy = float(Global.battery_level_sec) / 60
		
		if Global.battery_level_sec > scale_down_threshold_time:
			point_light_2d.texture_scale = (((float(Global.battery_level_sec) - scale_down_threshold_time) * scaled_down_range) / total_time_range) + min_light_radius
			
			#OldRange = (OldMax - OldMin)  
			#NewRange = (NewMax - NewMin)  
			#NewValue = (((OldValue - OldMin) * NewRange) / OldRange) + NewMin
			
			#old_range = 180 - 60 = 120
			#new_range = 0.25 - 0.18 = 0.07
			#new_value = (((180 - 60) * 0.07) / 120) + 0.18

	else:
		if not Global.game_over:
			battery_died.emit(self.battery_died.get_name())

func _process(delta: float) -> void:
	if not Global.intro_scene:
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
	direction = dir

	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	var tile_data := tile_map.get_cell_tile_data(0,target_tile)
	
	if tile_data and not tile_data.get_custom_data("Collidable"):
		assign_target_pos(target_tile)
	else:
		var bg_tile_data := bg_tile_map.get_cell_tile_data(0,target_tile)
		
		if bg_tile_data and not bg_tile_data.get_custom_data("Collidable"):
			assign_target_pos(target_tile)

func assign_target_pos(tile_pos: Vector2i):
	is_moving = true
	is_move_key_pressed = true
	target_pos = tile_map.map_to_local(tile_pos)

func move_player(delta: float) -> void:
	global_position = global_position.move_toward(target_pos, MAX_SPEED * delta)
	
	if global_position == target_pos:
		is_moving = false

func _on_fright_timer_timeout() -> void:
	fright_mode_deactivated.emit()
	Global.fright_mode = false
	Global.battery_level_sec = max_battery_time_sec
	point_light_2d.color = Color.WHITE

func player_pit_fall_anim() -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self,"modulate:a",0,0.7)
	tween.tween_property(self,"rotation_degrees",360,0.7)
	tween.tween_property(self,"scale",Vector2(0,0),1.4)
	await tween.finished
