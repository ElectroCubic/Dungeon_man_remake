extends Node2D

@onready var player = $Player

func _ready():
	player.connect("fright_mode_activated", activate_fright_mode)
	player.connect("fright_mode_deactivated", deactivate_fright_mode)
	player.connect("battery_died", player_death)
	
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		enemy.connect("player_hit", player_death)
	
func activate_fright_mode():
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		if enemy is ActiveEnemy:
			enemy.current_path.clear()
			enemy.get_child(-1).stop()

func deactivate_fright_mode():
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		if enemy is ActiveEnemy:
			enemy.get_child(-1).start(enemy.chase_timer)

func player_death():
	#print("Game Over!")
	#get_tree().quit()
	pass
