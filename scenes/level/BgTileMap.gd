extends TileMap

func remove_barrier(pos: Vector2) -> void:
	var tile_data := get_cell_tile_data(0,local_to_map(pos))
	tile_data.set_custom_data("Collidable",false)
	
func set_barrier(pos: Vector2) -> void:
	var tile_data := get_cell_tile_data(0,local_to_map(pos))
	tile_data.set_custom_data("Collidable",true)
