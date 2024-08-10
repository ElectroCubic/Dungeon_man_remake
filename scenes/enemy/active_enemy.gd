extends Enemy

class_name ActiveEnemy

@onready var anim := $AnimatedSprite2D
@onready var tile_map = get_node("../../TileMap") as TileMap
@onready var player = get_node("../../Player") as Player
@onready var teleporters = get_node("../../Teleporters").get_children()
@export var enemy_speed: int = 32
var radar_icon: String = "ActiveEnemy"
var spawn_pos: Vector2
var random_pos: Vector2
var can_teleport: bool = true
var can_chase: bool = false

func _ready() -> void:
	speed = enemy_speed
	spawn_pos = position
	get_random_pos()
	
	for t in teleporters:
		t.connect("player_near", player_near_teleport)

func animate():
	direction = current_path.front() - get_current_tile(global_position)
	
	if direction == Vector2.LEFT:
		anim.flip_h = true
		anim.animation = "scared_right" if Global.fright_mode else "right"
	elif direction == Vector2.RIGHT:
		anim.flip_h = false
		anim.animation = "scared_right" if Global.fright_mode else "right"
	elif direction == Vector2.UP:
		anim.animation = "scared_up" if Global.fright_mode else "up"
	elif direction == Vector2.DOWN:
		anim.animation = "scared_down" if Global.fright_mode else "down"

func player_near_teleport(pos: Vector2):
	if not Global.fright_mode and can_teleport:
		print(pos)
		get_path_to_pos(pos)
		can_teleport = false
		$TeleportTimer.start()

func _on_body_entered(body) -> void:
	if body.name == "Player" and not Global.fright_mode:
		player_hit.emit()

func _process(delta: float) -> void:
	if not is_moving:
		anim.animation = "scared_idle" if Global.fright_mode else "idle"
		return
	
	if current_path.is_empty():
		if not Global.fright_mode and can_chase:
			get_path_to_pos(player.position)
		elif not Global.fright_mode and not can_chase:
			get_random_pos()
			get_path_to_pos(random_pos)
		else:
			get_path_to_pos(spawn_pos)
	elif is_moving:
		animate()
		move_enemy(delta)

func move_enemy(delta: float) -> void:
	var target_pos: Vector2 = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_pos, speed * delta)

	if global_position == target_pos:
		current_path.pop_front()
		changed_pos.emit()

func get_random_pos():
	random_pos = tile_map.map_to_local(tile_map.coin_spawns.pick_random())

func get_path_to_pos(pos: Vector2) -> void:
	current_path = tile_map.astar.get_id_path(
		get_current_tile(global_position),
		tile_map.local_to_map(pos)
	).slice(1)
	
func get_current_tile(pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(pos)

func _on_teleport_timer_timeout():
	can_teleport = true

func _on_detection_zone_body_entered(body):
	if body.name == "Player":
		can_chase = true
		current_path.clear()

func _on_detection_zone_body_exited(body):
	if body.name == "Player":
		can_chase = false
