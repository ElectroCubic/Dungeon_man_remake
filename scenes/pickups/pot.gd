extends Area2D

@onready var sprite_2d := $Sprite2D

var broken: bool = false

func _on_body_entered(body) -> void:
	if body.name == "Player" and not broken:
		AudioManager.play_sfx(AudioManager.pot_breaking_sfx,0.8,1.2)
		sprite_2d.frame = 15 		# Broken Pot Frame
		broken = true
