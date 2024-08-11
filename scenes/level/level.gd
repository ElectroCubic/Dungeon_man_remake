extends Node2D

class_name Level

signal twinkle_mode

@onready var player := $Player
@onready var tile_map := $TileMap
@export var twinkle_mode_coin_amt: int = 10
var player_last_pos: Vector2i
var game_over: bool = false

func _ready() -> void:
	player.connect("fright_mode_activated", activate_fright_mode)
	player.connect("fright_mode_deactivated", deactivate_fright_mode)
	player.connect("battery_died", player_death)
	
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		enemy.connect("player_hit", player_death)
		
	var pickups := get_node("Pickups").get_children()
	for pickup in pickups:
		if pickup is Coin:
			pickup.connect("coin_picked", check_coins)

func check_coins() -> void:
	if (tile_map.coins_to_spawn - Global.coins) == twinkle_mode_coin_amt:
		twinkle_mode.emit()
		
	elif Global.coins == tile_map.coins_to_spawn:
		print("You Win!")

func activate_fright_mode() -> void:
	player.fright_bar.show()
	player_last_pos = get_current_tile(player.position)
	tile_map.astar.set_point_solid(player_last_pos)

func deactivate_fright_mode() -> void:
	player.fright_bar.hide()
	tile_map.astar.set_point_solid(player_last_pos,false)

func get_current_tile(pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(pos)

func player_death() -> void:
	RenderingServer.viewport_set_snap_2d_transforms_to_pixel(get_window().get_viewport_rid(),true)
	player.is_controlled = false
	game_over = true
	player.anim.play("Death")
	$Enemies.hide()
	$UI.hide()
