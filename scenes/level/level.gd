extends Node2D

class_name Level

signal twinkle_mode

@onready var player := $Player
@onready var tile_map := $TileMap
@export var twinkle_mode_coin_amt: int = 10
var player_last_pos: Vector2i

func _ready():
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

func check_coins():
	if (tile_map.coins_to_spawn - Global.coins) == twinkle_mode_coin_amt:
		twinkle_mode.emit()

func activate_fright_mode():
	player.fright_bar.show()
	player_last_pos = get_current_tile(player.position)
	tile_map.astar.set_point_solid(player_last_pos)
	
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		if enemy is ActiveEnemy:
			enemy.current_path.clear()
			enemy.get_child(-1).stop()

func deactivate_fright_mode():
	player.fright_bar.hide()
	tile_map.astar.set_point_solid(player_last_pos,false)
	
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		if enemy is ActiveEnemy:
			enemy.get_child(-1).start(enemy.chase_timer)

func get_current_tile(pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(pos)

func player_death():
	print("Game Over!")
	#get_tree().quit()
