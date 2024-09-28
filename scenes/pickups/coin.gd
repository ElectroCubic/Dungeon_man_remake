extends Area2D

class_name Coin

signal coin_picked

var picked: bool = false

@onready var level = get_node("../../") as Level

func _ready() -> void:
	level.connect("twinkle_mode", activate_twinkle_mode)

func activate_twinkle_mode() -> void:
	await get_tree().create_timer(randf_range(0.5,2.5)).timeout
	twinkle()

func _on_body_entered(body) -> void:
	if body.name == "Player" and not picked:
		picked = true
		Global.coins += 1
		Global.total_coins += 1
		coin_picked.emit()
		AudioManager.play_sfx(AudioManager.coin_collect_sfx,0.9,1.1)
		$AnimatedSprite2D.hide()
		$ShiningParticles.emitting = true
		await $ShiningParticles.finished
		queue_free()

func twinkle() -> void:
	$AnimatedSprite2D2.show()
	$AnimatedSprite2D2.play("Twinkle")
	$AnimatedSprite2D2.rotation_degrees = randi_range(0,360)
