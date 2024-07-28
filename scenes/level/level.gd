extends Node2D

@onready var player := $Player
@onready var tile_map := $TileMap
var player_last_pos: Vector2i

func _ready():
	player.connect("fright_mode_activated", activate_fright_mode)
	player.connect("fright_mode_deactivated", deactivate_fright_mode)
	player.connect("battery_died", player_death)
	
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		enemy.connect("player_hit", player_death)
	
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
	#print("Game Over!")
	#get_tree().quit()
	pass
