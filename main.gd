extends Node2D

func _on_play_pressed() -> void:
	TransitionLayer.change_scene("res://scenes/level/level.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
