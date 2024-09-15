extends Node2D

class_name Spawner

@onready var radar: Radar = get_node("../UI/Radar")
@onready var battery := preload("res://scenes/pickups/battery_cell.tscn")
@export var batteries_to_spawn: int = 1
var spawn_locations: Array[Vector2]
var current_batteries: Dictionary

func _ready() -> void:
	var spawn_count := get_child_count()
	
	if spawn_count != 0:
		for child in get_children():
			spawn_locations.append(child.position)
		
		for i in range(batteries_to_spawn):
			spawn_battery()
		
	else:
		push_warning("Can't Spawn Batteries!")

func spawn_battery() -> void:
	var battery_temp: Pickup = battery.instantiate()
	battery_temp.position = get_available_locations().pick_random()
	current_batteries[battery_temp] = battery_temp.position
	battery_temp.connect("item_picked", check_batteries)
	battery_temp.item_spawned.connect(radar.add_marker)
	var node = get_node("../Pickups")
	node.add_child.bind(battery_temp).call_deferred()

func get_available_locations() -> Array[Vector2]:
	if current_batteries.is_empty():
		return spawn_locations
		
	else:
		var locations = spawn_locations.duplicate()
		
		for batt_pos in current_batteries.values():
			for pos in spawn_locations:
				if batt_pos == pos:
					locations.remove_at(locations.find(pos))
		
		return locations

func check_batteries(battery_ref: Pickup) -> void:
	spawn_battery()
	for batt in current_batteries.keys():
		if batt == battery_ref:
			current_batteries.erase(batt)
