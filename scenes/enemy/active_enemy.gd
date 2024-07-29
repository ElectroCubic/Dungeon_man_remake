extends Enemy

class_name ActiveEnemy

@onready var tile_map = get_node("../../TileMap") as TileMap
@onready var player = get_node("../../Player") as Player
@onready var teleporters = get_node("../../Teleporters").get_children()
@export var enemy_speed: int = 20
@export var chase_timer: float = 5
var radar_icon: String = "ActiveEnemy"
var spawn_pos: Vector2
var can_teleport: bool = true

func _ready() -> void:
	for t in teleporters:
		t.connect("player_near", player_near_teleport)

	$ChaseTimer.wait_time = chase_timer
	speed = enemy_speed
	spawn_pos = position

func player_near_teleport(pos: Vector2):
	if not Global.fright_mode and can_teleport:
		print(pos)
		get_path_to_pos(pos)
		can_teleport = false
		$TeleportTimer.start()
		
func _on_body_entered(body) -> void:
	if body.name == "Player":
		player_hit.emit()
	
func _process(delta: float) -> void:
	if not is_moving:
		return
	
	if current_path.is_empty():
		if not Global.fright_mode:
			get_path_to_pos(player.position)
		else:
			get_path_to_pos(spawn_pos)
	elif is_moving:
		move_enemy(delta)

func move_enemy(delta: float) -> void:
	var target_pos: Vector2 = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_pos, speed * delta)

	if global_position == target_pos:
		current_path.pop_front()
		changed_pos.emit()

func get_path_to_pos(pos: Vector2) -> void:
	current_path = tile_map.astar.get_id_path(
		get_current_tile(global_position),
		tile_map.local_to_map(pos)
	).slice(1)
	
func get_current_tile(pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(pos)

func _on_chase_timer_timeout():
	current_path.clear()			# Retarget

func _on_teleport_timer_timeout():
	can_teleport = true
