extends Area2D

class_name Coin

signal coin_picked

var picked: bool = false

@onready var level = get_node("../../") as Level

func _ready():
	level.connect("twinkle_mode", activate_twinkle_mode)

func activate_twinkle_mode():
	await get_tree().create_timer(randf_range(0.5,2.5)).timeout
	twinkle()

func _on_body_entered(body):
	if body.name == "Player" and not picked:
		picked = true
		Global.coins += 1
		coin_picked.emit()
		$AnimatedSprite2D.hide()
		$ShiningParticles.emitting = true
		await $ShiningParticles.finished
		queue_free()

func twinkle():
	$AnimatedSprite2D2.show()
	$AnimatedSprite2D2.play("Twinkle")
	$AnimatedSprite2D2.rotation_degrees = randi_range(0,360)
