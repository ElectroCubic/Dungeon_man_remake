extends CanvasLayer

@onready var game_over_text := $GameOverText
@onready var level_info := $LevelInfo
@onready var coin_text := $CoinText
@onready var mystery_text := $MysteryText
@onready var retry_text := $RetryText
@export_range(0.1,1.0) var flash_duration: float = 0.8
@export_range(0.1,1.0) var flash_interval: float = 0.1
var flash_tween: Tween
var can_continue: bool = false
var mystery_text_list: Array[String] = [
	"Retry?",
	"PRO TIP: Don't Die :)",
	"Try Again?",
	"Struggle is the Only Way",
	"01001100 01001111 01001100",
	"You Cannot Escape",
	"Can you Survive Longer?",
	"Quit Button Exists, try pressing it",
	"Better Luck Next Time",
	"YOU SHALL NOT PASS!",
	"Retry?",
	"PRO TIP: Don't Die :)",
	"Try Again?",
	"Struggle is the Only Way",
	"01001100 01001111 01001100",
	"You Cannot Escape",
	"Can you Survive Longer?",
	"Quit Button Exists, try pressing it.",
	"Better Luck Next Time",
	"YOU SHALL NOT PASS!",
	"TIP: Try to Keep an Eye on the Radar",
	"TIP: Don't Stand in Corners or Deadends",
	"TIP: Always Keep Your Battery Charged",
	"TIP: The Last Few Coins Look Pretty Shiny in the Dark",
	"TIP: You are Immune When Battery Gets Overcharged",
	"TIP: Watch out for the Eye Monster... it's deceiving",
	"TIP: The Claw Monster Knows ALL",
	"TIP: Use the Shortcuts to Your Advantage",
	"TIP: You are NOT the Only One Who Can Use Shortcuts",
	"TIP: Keep your Eyes and Ears Open"
]

func _ready() -> void:
	display_lvl_count()
	display_mystery_text()
	seq_popup_text()

func coin_counter_anim() -> void:
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_method(display_total_coins,0,Global.total_coins,3)
	tween.chain().tween_callback(retry_enable)
	await tween.finished

func display_total_coins(count: int) -> void:
	$CoinText.text = "Total Coins: " + str(count)
	
func seq_popup_text() -> void:
	game_over_text.show()
	AudioManager.play_sfx(AudioManager.game_over_sfx)
	await get_tree().create_timer(1.5).timeout
	level_info.show()
	AudioManager.play_sfx(AudioManager.popup_sfx)
	await get_tree().create_timer(1).timeout
	coin_text.show()
	coin_counter_anim()
	if Global.total_coins != 0:
		if Global.total_coins < 10:
			AudioManager.coin_counter_sfx.play(0.35)
		else:
			AudioManager.coin_counter_sfx.play()
	else:
		AudioManager.play_sfx(AudioManager.popup_sfx)

func retry_enable() -> void:
	await get_tree().create_timer(1).timeout
	mystery_text.show()
	AudioManager.play_sfx(AudioManager.popup_sfx)
	await get_tree().create_timer(1.5).timeout
	retry_text.show()
	AudioManager.play_sfx(AudioManager.popup_sfx)
	can_continue = true
	Global.total_coins = 0
	flash_retry_text()

func display_lvl_count() -> void:
	$LevelInfo.text = "AT LEVEL " + str(Global.lvlCount)

func display_mystery_text() -> void:
	randomize()
	$MysteryText.text = mystery_text_list.pick_random()

func flash_retry_text() -> void:
	flash_tween = get_tree().create_tween().set_loops()
	flash_tween.tween_property(retry_text,"modulate:a",0,flash_duration).from(1).set_trans(Tween.TRANS_SINE)
	flash_tween.tween_interval(flash_interval)
	flash_tween.tween_property(retry_text,"modulate:a",1,flash_duration-0.15).from(0).set_trans(Tween.TRANS_SINE)
	flash_tween.tween_interval(flash_interval)

func stop_flashing() -> void:
	flash_tween.stop()
	flash_tween.kill()

func _unhandled_key_input(_event) -> void:
	# Retry
	
	if Input.is_action_just_pressed("Show_Radar") and can_continue:
		stop_flashing()
		AudioManager.play_sfx(AudioManager.rollover_sfx)
		Global.lvlCount = 1
		Global.coins = 0
		TransitionLayer.change_scene("res://scenes/level/level.tscn")
		
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
