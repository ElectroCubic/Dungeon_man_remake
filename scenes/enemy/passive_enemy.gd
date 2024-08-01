extends Enemy

class_name PassiveEnemy

@onready var ray_cast_2d = $RayCast2D
@onready var player: Player = get_node("../../Player")
@export var enemy_speed: int = 48
@export var offset: int = 0
@export var forward: bool = true
var path: Path2D
var path_follow: PathFollow2D
var radar_icon: String = "PassiveEnemy"

func _ready():
	speed = enemy_speed
	path = get_children().back()
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.progress = offset

func _physics_process(delta):
	set_ray_dir()
	check_player_presence()
	move_enemy(delta)

func set_ray_dir():
	if not Global.fright_mode:
		if forward:
			ray_cast_2d.rotation_degrees = path_follow.rotation_degrees
		else:
			ray_cast_2d.rotation_degrees = path_follow.rotation_degrees - 180
	else:
		if forward:
			ray_cast_2d.rotation_degrees = path_follow.rotation_degrees - 180
		else:
			ray_cast_2d.rotation_degrees = path_follow.rotation_degrees

	ray_cast_2d.force_update_transform()
	ray_cast_2d.force_raycast_update()

func check_player_presence() -> void:
	var player_dir := global_position.direction_to(player.position)
	
	if player_dir.normalized() != Vector2.ZERO:
		if ray_cast_2d.is_colliding():
			forward = !forward

func move_enemy(delta: float) -> void:
	var dir = 1 if forward else -1
	path_follow.progress += enemy_speed * dir * delta
	position = path_follow.position
	
func _on_body_entered(body):
	if body.name == "Player" and not Global.fright_mode:
		player_hit.emit()
