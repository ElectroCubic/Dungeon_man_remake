extends MarginContainer

class_name Radar

@export var scan_time: float = 3
@onready var player = get_node("../../Player") as Player
@onready var tile_map = get_node("../../TileMap") as TileMap
@onready var grid := $GridFrame/Grid
@onready var scan_line = $GridFrame/ScanLine
@onready var player_marker := $GridFrame/Grid/PlayerMarker
@onready var active_enemy_marker := $GridFrame/Grid/ActiveEnemyMarker
@onready var passive_enemy_marker := $GridFrame/Grid/PassiveEnemyMarker
@onready var pickup_marker := $GridFrame/Grid/PickupMarker
@onready var icons := {"ActiveEnemy": active_enemy_marker, "PassiveEnemy": passive_enemy_marker, "Pickup": pickup_marker}

const radar_grid_box_size: Vector2 = Vector2(20,20)
var markers: Dictionary = {}
var grid_scale: Vector2

func set_player_marker_rotation() -> void:
	if player.direction == Vector2.LEFT:
		player_marker.rotation_degrees = 270
	elif player.direction == Vector2.RIGHT:
		player_marker.rotation_degrees = 90
	elif player.direction == Vector2.UP:
		player_marker.rotation_degrees = 0
	elif player.direction == Vector2.DOWN:
		player_marker.rotation_degrees = 180

func _ready() -> void:
	grid.size = grid.custom_minimum_size
	player_marker.position = grid.size / 2
	set_player_marker_rotation()
	grid_scale = radar_grid_box_size / Vector2(tile_map.tile_set.tile_size) 		# 20 / 16 = 1.25

	var radar_entities = get_tree().get_nodes_in_group("Radar_Entity")
	for entity in radar_entities:
		if not entity is Pickup:
			add_marker(entity)

	update_radar_pos()

func update_radar_pos() -> void:
	for entity in markers:
		var entity_pos = ((entity.position - player.position) * grid_scale) + grid.size / 2
		entity_pos.x = clamp(entity_pos.x,0,grid.size.x)
		entity_pos.y = clamp(entity_pos.y,0,grid.size.y)
		markers[entity].position = entity_pos
		
		if entity is Pickup:
			if entity_pos.x == 0 or entity_pos.x == grid.size.x or entity_pos.y == 0 or entity_pos.y == grid.size.y:
				markers[entity].scale = Vector2(0.55,0.55)
			else:
				markers[entity].scale = Vector2(0.45,0.45)

func add_marker(item) -> void:
	var new_marker = icons[item.radar_icon].duplicate()
	grid.add_child(new_marker)
	new_marker.show()
	markers[item] = new_marker
	if not item is Pickup:
		item.connect("changed_pos",update_radar_pos)
	else:
		item.connect("item_picked",remove_marker)

func remove_marker(item) -> void:
	if markers.has(item):
		markers[item].queue_free()
		markers.erase(item)

func _process(delta: float) -> void:
	scan_line.rotation_degrees += (360 / scan_time) * delta

	if not player.is_moving:
		return
	set_player_marker_rotation()
