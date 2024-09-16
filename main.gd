extends Node2D

func _on_play_pressed() -> void:
	Global.intro_scene = true
	TransitionLayer.change_scene("res://scenes/intro_screen.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
