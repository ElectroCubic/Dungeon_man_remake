extends Enemy

class_name PassiveEnemy

@onready var anim := $AnimatedSprite2D
@onready var ray_cast_2d := $RayCast2D
@onready var player = get_node("../../Player") as Player
@export var enemy_speed: int = 48
@export var offset: int = 0
@export var forward: bool = true
var path: Path2D
var path_follow: PathFollow2D
var radar_icon: String = "PassiveEnemy"

func _ready() -> void:
	speed = enemy_speed
	path = get_children().back()
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.progress = offset

func _physics_process(delta: float) -> void:
	set_ray_dir()
	animate(ray_cast_2d.rotation_degrees)
	check_player_presence()
	move_enemy(delta)

func animate(ray_angle: float):
	# face right or face left
	if ray_angle == 0 or ray_angle == 180:
		anim.flip_v = false
		
		if ray_angle == 180:
			anim.flip_h = true if not Global.fright_mode else false
		else:
			anim.flip_h = false if not Global.fright_mode else true
		
		anim.animation = "scared_horizontal" if Global.fright_mode else "horizontal"

	# face down or face up
	elif ray_angle == 90 or ray_angle == 270:
		anim.flip_h = false
		
		if ray_angle == 270:
			anim.flip_v = true if not Global.fright_mode else false
		else:
			anim.flip_v = false if not Global.fright_mode else true
			
		anim.animation = "scared_vertical" if Global.fright_mode else "vertical"

func set_ray_dir() -> void:
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
	
	if ray_cast_2d.rotation_degrees < 0:
		ray_cast_2d.rotation_degrees += 360

	ray_cast_2d.force_update_transform()
	ray_cast_2d.force_raycast_update()
	#if name == "PassiveEnemy2":
		#print(ray_cast_2d.rotation_degrees)

func check_player_presence() -> void:
	var player_dir := global_position.direction_to(player.position)
	
	if player_dir.normalized() != Vector2.ZERO:
		if ray_cast_2d.is_colliding():
			forward = !forward

func move_enemy(delta: float) -> void:
	if not is_moving:
		return
		
	var dir = 1 if forward else -1
	path_follow.progress += enemy_speed * dir * delta
	position = path_follow.position

func _on_body_entered(body) -> void:
	if body.name == "Player" and not Global.fright_mode:
		player_hit.emit()
