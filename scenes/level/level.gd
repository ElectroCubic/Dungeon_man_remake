extends Node2D

class_name Level

signal twinkle_mode

@onready var player := $Player as Player
@onready var tile_map := $TileMap as TileMap
@onready var fg_tile_map = $FgTileMap as TileMap
@export var twinkle_mode_coin_amt: int = 10
@onready var cave_bgm := preload("res://audio/bgm/Scary_cave_ambience.wav")
var player_last_pos: Vector2i
var pit_tile_atlas_coords: Vector2i = Vector2i(2,3)

func _ready() -> void:
	if AudioManager.bgm_player.stream != cave_bgm:
		AudioManager.change_bgm(cave_bgm)
	AudioManager.bgm_player.play()
	AudioManager.fade_in_music()
	
	if Global.game_over:
		Global.game_over = false
		player.is_controlled = true
		var window_rid = get_window().get_viewport_rid()
		RenderingServer.viewport_set_snap_2d_transforms_to_pixel(window_rid,false)
	
	if Global.lvlCount > 1:
		player.position = $BatterySpawner.get_available_locations().pick_random()
	
	player.connect("fright_mode_activated", activate_fright_mode)
	player.connect("fright_mode_deactivated", deactivate_fright_mode)
	player.connect("battery_died", player_death)
	
	var enemies := get_node("Enemies").get_children()
	for enemy in enemies:
		enemy.connect("player_hit", player_death)
		
	var pickups := get_node("Pickups").get_children()
	for pickup in pickups:
		if pickup is Coin:
			pickup.connect("coin_picked", check_coins)

func check_coins() -> void:
	if (tile_map.coins_to_spawn - Global.coins) == twinkle_mode_coin_amt:
		twinkle_mode.emit()
		
	elif Global.coins == tile_map.coins_to_spawn:
		go_to_next_level()

func go_to_next_level() -> void:
	AudioManager.fade_out_music()
	block_controls()
	Global.has_played = true
	Global.coins = 0
	Global.lvlCount += 1
	var spawn_pos: Vector2i = tile_map.local_to_map(player.position)
	tile_map.set_cell(0,spawn_pos,0,pit_tile_atlas_coords)
	fg_tile_map.erase_cell(0,spawn_pos)
	player.player_pit_fall_anim()
	AudioManager.play_sfx(AudioManager.rock_breaking_sfx)
	await get_tree().create_timer(1).timeout
	TransitionLayer.change_scene("res://scenes/level/level.tscn")

func activate_fright_mode() -> void:
	player.fright_bar.show()
	player_last_pos = get_current_tile(player.position)
	tile_map.astar.set_point_solid(player_last_pos)

func deactivate_fright_mode() -> void:
	player.fright_bar.hide()
	tile_map.astar.set_point_solid(player_last_pos,false)

func get_current_tile(pos: Vector2) -> Vector2i:
	return tile_map.local_to_map(pos)

func death_by_enemy() -> void:
	# Hide enemies
	var tween = get_tree().create_tween()
	tween.tween_property($Enemies,"modulate:a",0,1)
	await tween.finished
	$Enemies.process_mode = Node.PROCESS_MODE_DISABLED
	$Pickups.process_mode = Node.PROCESS_MODE_DISABLED
	# Enable this to remove pixel smudges
	var window_rid = get_window().get_viewport_rid()
	RenderingServer.viewport_set_snap_2d_transforms_to_pixel(window_rid,true)

func block_controls() -> void:
	$UI.hide()
	AudioManager.walking_sfx.stop()
	player.is_controlled = false
	player.walk_particles.emitting = false
	Global.game_over = true

func player_death(signal_name) -> void:
	if not AudioManager.death_sfx.playing:
		AudioManager.death_sfx.play()
	AudioManager.fade_out_music()
	block_controls()
	Global.has_played = true
	
	if signal_name == "player_hit":
		death_by_enemy()
		
		# Play Death/Cry Animation for 1 sec
		player.anim.play("Death")
		await player.anim.animation_finished
		player.anim.play("Crying")
		await get_tree().create_timer(1).timeout
		player.anim.stop()
	
	# Change to game over screen
	TransitionLayer.change_scene("res://scenes/level/game_over_screen.tscn")
