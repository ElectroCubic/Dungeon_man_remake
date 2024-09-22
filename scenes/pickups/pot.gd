extends Area2D

@onready var sprite_2d := $Sprite2D

func _on_body_entered(body) -> void:
	if body.name == "Player":
		AudioManager.play_pot_break_sfx()
		sprite_2d.frame = 15
