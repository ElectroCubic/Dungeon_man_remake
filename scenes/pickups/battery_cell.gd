extends Area2D

class_name Pickup

signal item_picked(item: Pickup)
signal item_spawned(item: Pickup)

@export var float_offset: int = 3
@export_range(0.1,1.0) var float_duration: float = 0.8
@export_range(0.1,1.0) var float_interval: float = 0.1
@export var battery_refill_value: float = 60

var radar_icon: String = "Pickup"
var float_tween: Tween
var picked: bool = false

func _ready() -> void:
	item_spawned.emit(self)
	start_floating()
	
func start_floating() -> void:
	float_tween = get_tree().create_tween().set_loops()
	float_tween.tween_property($Sprite2D, "position:y", -float_offset, float_duration).as_relative()
	float_tween.tween_interval(float_interval)
	float_tween.tween_property($Sprite2D, "position:y", float_offset, float_duration).as_relative()
	float_tween.tween_interval(float_interval)

func stop_floating() -> void:
	float_tween.stop()
	float_tween.kill()

func remove_battery() -> void:
	var tween: Tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Sprite2D, "modulate:a", 0, 0.5)
	tween.tween_property($Sprite2D, "position:y", -12, 0.8)
	tween.tween_callback(stop_floating)
	await tween.finished

func _on_body_entered(body) -> void:
	if body.name == "Player" and not picked:
		picked = true
		Global.battery_level_sec += battery_refill_value
		item_picked.emit(self)
		await remove_battery()
		queue_free()
