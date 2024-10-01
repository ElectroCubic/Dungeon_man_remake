extends Control

func _ready():
	if not OS.get_name() in ["android","iOS"]:
		queue_free()

