extends Node

@onready var bgm_player = $BGMPlayer
@onready var walking_sfx = $WalkingSfx
@onready var click_sfx = $ClickSfx
@onready var rollover_sfx = $RolloverSfx
@onready var pot_breaking_sfx = $PotBreakingSfx
@onready var music_bus_id: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id: int = AudioServer.get_bus_index("SFX")

@export_range(0.0,5.0,0.1) var music_fade_in_time: float = 3.0
@export_range(0.0,5.0,0.1) var music_fade_out_time: float = 3.0
var current_set_music_vol: float = 1.0

func _ready() -> void:
	bgm_player.play()

func play_pot_break_sfx() -> void:
	pot_breaking_sfx.pitch_scale = randf_range(0.8,1.2)
	pot_breaking_sfx.play()

func play_walking_sfx() -> void:
	walking_sfx.play()

func fade_out_music() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(control_vol_music,current_set_music_vol,0.0,music_fade_out_time)
	await tween.finished

func fade_in_music() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(control_vol_music,0.0,current_set_music_vol,music_fade_in_time)
	await tween.finished

func control_vol_music(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id,linear_to_db(value))
