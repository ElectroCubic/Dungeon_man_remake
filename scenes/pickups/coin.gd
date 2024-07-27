extends Area2D

class_name Coin

func _on_body_entered(body):
	if body.name == "Player":
		Global.coins += 1
		queue_free()
