extends TileMap

var astar: AStarGrid2D = AStarGrid2D.new()

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
			
			if tile_data and tile_data.get_custom_data("Collidable") == true:
				astar.set_point_solid(coords)
