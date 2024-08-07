extends CanvasLayer

@onready var player = get_node("../Player") as Player
@onready var battery_bar = $BatteryLevel/BatteryBar
@onready var coin_counter = $CoinDisplay/CoinCounter
@onready var total_coins: int = get_node("../Pickups").get_child_count()

func _ready():
	Global.connect("stat_change", update_stats)
	battery_bar.max_value = player.max_battery_time_sec
	$Radar.hide()
	update_stats()

func update_battery_bar():
	battery_bar.value = Global.battery_level_sec
	
func update_coins():
	coin_counter.text = str(Global.coins) + " / " + str(total_coins)

func update_fright_bar():
	player.fright_bar.value = Global.fright_level

func update_stats():
	update_battery_bar()
	update_coins()
	update_fright_bar()

func _unhandled_key_input(event):
	if event.is_action_pressed("Show_Radar"):
		player.is_controlled = false
		$Radar.show()
	elif event.is_action_released("Show_Radar"):
		player.is_controlled = true
		$Radar.hide()
