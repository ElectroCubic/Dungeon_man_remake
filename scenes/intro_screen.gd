extends Node2D

@onready var info_text = $Instructions/InfoText
@onready var player := $Player as Player
@onready var tile_map := $TileMap as TileMap
var pit_tile_atlas_coords: Vector2i = Vector2i(2,3)

func place_pit():
	block_controls()
	var spawn_pos: Vector2i = tile_map.local_to_map(player.position)
	tile_map.set_cell(0,spawn_pos,0,pit_tile_atlas_coords)
	player.player_pit_fall_anim()
	await get_tree().create_timer(1).timeout
	Global.intro_scene = false
	TransitionLayer.change_scene("res://scenes/level/level.tscn")

func block_controls() -> void:
	player.is_controlled = false
	Global.game_over = true

func _on_pit_area_body_entered(body):
	if body.name == "Player":
		place_pit()
