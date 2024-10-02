extends Control

func _ready():
	if OS.get_name() in ["Windows","macOS"]:
		queue_free()
