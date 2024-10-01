extends CanvasLayer

class_name UI

@onready var animation_player := $AnimationPlayer
@onready var player = get_node("../Player") as Player
@onready var battery_bar = $BatteryLevel/BatteryBar
@onready var coin_counter = $CoinDisplay/CoinCounter
@onready var total_coins: int = get_node("../Pickups").get_child_count()

func _ready() -> void:
	Global.connect("stat_change", update_stats)
	battery_bar.max_value = player.max_battery_time_sec
	$Radar.hide()
	update_stats()
	
	if not Global.has_played:
		animation_player.play("show_info")
	else:
		animation_player.play("show_lvl_info")

func update_lvl_info_text() -> void:
	$LvlInfo.text = "Level " + str(Global.lvlCount)

func update_battery_bar() -> void:
	battery_bar.value = Global.battery_level_sec

func update_coins() -> void:
	coin_counter.text = str(Global.coins) + " / " + str(total_coins)

func update_fright_bar() -> void:
	player.fright_bar.value = Global.fright_level

func update_stats() -> void:
	update_battery_bar()
	update_coins()
	update_fright_bar()

func _unhandled_input(event) -> void:
	if Global.game_over == false:
		if event.is_action_pressed("Show_Radar"):
			player.is_controlled = false
			AudioManager.walking_sfx.stop()
			$Radar.show()
		elif event.is_action_released("Show_Radar"):
			player.is_controlled = true
			$Radar.hide()

func _on_radar_ping_timer_timeout() -> void:
	if $Radar.visible and not AudioManager.radar_ping_sfx.playing:
		AudioManager.play_sfx(AudioManager.radar_ping_sfx,0.9,1.2)
