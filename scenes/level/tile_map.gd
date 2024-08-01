extends TileMap

@onready var coin_scene = preload("res://scenes/pickups/coin.tscn")
@export var coins_to_spawn: int = 1

var astar: AStarGrid2D = AStarGrid2D.new()
var coin_spawns: Array[Vector2i]
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var tile_map_pos := get_used_rect().position
	var map_rect: Rect2i = Rect2i(tile_map_pos,get_used_rect().size)
	
	astar.region = map_rect
	astar.cell_size = get_tileset().tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	var x_range = range(tile_map_pos.x, get_used_rect().end.x)
	var y_range = range(tile_map_pos.y, get_used_rect().end.y)
	
	for i in x_range:
		for j in y_range:
			var coords := Vector2i(i,j)
			var tile_data := get_cell_tile_data(0,coords)
			var tile_atlas_pos := get_cell_atlas_coords(0,coords)
			
			if tile_data and tile_data.get_custom_data("Collidable") == true:
				astar.set_point_solid(coords)
				
			elif tile_atlas_pos == Vector2i(1,1):
				coin_spawns.append(coords)
	
	for i in range(coins_to_spawn):
		spawn_coin()

func spawn_coin():
	var coin: Coin = coin_scene.instantiate()
	var random_index: int = rng.randi_range(0,coin_spawns.size() - 1)
	coin.global_position = map_to_local(coin_spawns[random_index])
	coin_spawns.remove_at(random_index)
	get_node("../Pickups").add_child(coin)

