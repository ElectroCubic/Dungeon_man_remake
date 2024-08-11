extends Area2D

class_name Door

@onready var bg_tile_map = get_node("../../BgTileMap") as TileMap
@onready var interaction_manager = $InteractionManager
@onready var animated_sprite_2d = $AnimatedSprite2D
@export var coins_to_open: int = 1
var is_closed: bool = true

func _ready() -> void:
	bg_tile_map.set_barrier(global_position)

func _on_body_entered(body) -> void:
	if body.name == "Player" and is_closed:
		var display_text = str(Global.coins) + " / " + str(coins_to_open)
		interaction_manager.update_label_text(display_text)
		
		if Global.coins >= coins_to_open:
			is_closed = false
			animated_sprite_2d.play("open_door")
			await animated_sprite_2d.animation_finished
			$LightOccluder2D.hide()
			bg_tile_map.remove_barrier(global_position)
