extends Area2D

@onready var sprite_2d := $Sprite2D

func _on_body_entered(body) -> void:
	if body.name == "Player":
		sprite_2d.frame = 15
