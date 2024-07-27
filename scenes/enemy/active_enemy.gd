extends Enemy

class_name ActiveEnemy

@onready var tile_map: TileMap = get_node("../../TileMap")
@onready var player: Player = get_node("../../Player")
@export var enemy_speed: int = 20
@export var chase_timer: float = 3
var radar_icon: String = "ActiveEnemy"
var spawn_pos: Vector2

func _ready() -> void:
	spawn_pos = position
	$ChaseTimer.wait_time = chase_timer
	is_moving = true
	speed = enemy_speed

func _on_body_entered(body) -> void:
	if body.name == "Player":
		player_hit.emit()
	
func _process(delta: float) -> void:
	if current_path.is_empty():
		if not Global.fright_mode:
			get_path_to_pos(player.position)
		else:
			get_path_to_pos(spawn_pos)
	else:
		move_enemy(delta)

func move_enemy(delta: float) -> void:
	var target_pos: Vector2 = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_pos, speed * delta)

	if global_position == target_pos:
		is_moving = false
		current_path.pop_front()
		changed_pos.emit()

func get_path_to_pos(pos: Vector2) -> void:
	current_path = tile_map.astar.get_id_path(
		get_current_tile(),
		tile_map.local_to_map(pos)
	).slice(1)
	
func get_current_tile() -> Vector2i:
	return tile_map.local_to_map(global_position)

func _on_chase_timer_timeout():
	current_path.clear()			# Retarget
