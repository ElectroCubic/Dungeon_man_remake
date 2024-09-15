extends CanvasLayer

class_name UI

@onready var player = get_node("../Player") as Player
@onready var battery_bar = $BatteryLevel/BatteryBar
@onready var coin_counter = $CoinDisplay/CoinCounter
@onready var total_coins: int = get_node("../Pickups").get_child_count()

func _ready() -> void:
	Global.connect("stat_change", update_stats)
	battery_bar.max_value = player.max_battery_time_sec
	$Radar.hide()
	update_stats()
	lvl_info_fade()

func update_lvl_info_text():
	$LvlInfo.text = "Level " + str(Global.lvlCount)

func lvl_info_fade():
	await get_tree().create_timer(5).timeout
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($LvlInfo,"modulate:a",0,1.5).set_trans(Tween.TRANS_SINE)

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
	update_lvl_info_text()

func _unhandled_key_input(event) -> void:
	if Global.game_over == false:
		if event.is_action_pressed("Show_Radar"):
			player.is_controlled = false
			$Radar.show()
		elif event.is_action_released("Show_Radar"):
			player.is_controlled = true
			$Radar.hide()
