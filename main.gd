extends Node2D

class_name Main

@onready var playBtn := $MainUI/Play
@onready var optionsBtn := $MainUI/Options
@onready var quitBtn := $MainUI/Quit
@onready var point_light_2d = $PointLight2D
@export var normal_btn_font_size1: int = 56
@export var expand_btn_font_size1: int = 78
@export var normal_btn_font_size2: int = 42
@export var expand_btn_font_size2: int = 56
@export_range(0.0,1.0,0.1) var move_time_sec: float = 0.1
@export_range(0.1,1.0) var float_duration: float = 0.8
@export_range(0.1,1.0) var float_interval: float = 0.1
@export var float_offset: int = 15
var min_mouse_hover_time: float = 0.05
var change_size: bool = false
var float_tween: Tween

func _ready() -> void:
	start_floating()
	RenderingServer.set_default_clear_color(Color.BLACK)

func _input(event) -> void:
	if event is InputEventMouseMotion:
		point_light_2d.position = event.position

func start_floating() -> void:
	float_tween = get_tree().create_tween().set_loops()
	float_tween.tween_property($MainUI/TitleText, "position:y", -float_offset, float_duration).as_relative()
	float_tween.tween_interval(float_interval)
	float_tween.tween_property($MainUI/TitleText, "position:y", float_offset, float_duration).as_relative()
	float_tween.tween_interval(float_interval)

func stop_floating() -> void:
	float_tween.stop()
	float_tween.kill()

func change_play_font_size(size: int) -> void:
	playBtn.add_theme_font_size_override("font_size",size)

func change_options_font_size(size: int) -> void:
	optionsBtn.add_theme_font_size_override("font_size",size)

func change_quit_font_size(size: int) -> void:
	quitBtn.add_theme_font_size_override("font_size",size)

func modify_play_btn_size(from_size: int, to_size: int, time_sec: float) -> void:

	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(change_play_font_size,from_size,to_size,time_sec)

func modify_options_btn_size(from_size: int, to_size: int, time_sec: float) -> void:

	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(change_options_font_size,from_size,to_size,time_sec)

func modify_quit_btn_size(from_size: int, to_size: int, time_sec: float) -> void:

	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(change_quit_font_size,from_size,to_size,time_sec)

func _on_play_pressed() -> void:
	AudioManager.click_sfx.play()
	AudioManager.fade_out_music()
	await get_tree().create_timer(0.5).timeout
	stop_floating()
	Global.intro_scene = true
	TransitionLayer.change_scene("res://scenes/intro_screen.tscn")

func _on_options_pressed() -> void:
	AudioManager.click_sfx.play()
	await get_tree().create_timer(0.5).timeout
	$OptionsMenuScreen.show()

func _on_quit_pressed() -> void:
	AudioManager.click_sfx.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_play_mouse_entered() -> void:
	AudioManager.rollover_sfx.play()
	modify_play_btn_size(normal_btn_font_size1,expand_btn_font_size1,move_time_sec)

func _on_play_mouse_exited() -> void:
	modify_play_btn_size(expand_btn_font_size1,normal_btn_font_size1,move_time_sec)

func _on_options_mouse_entered() -> void:
	AudioManager.rollover_sfx.play()
	modify_options_btn_size(normal_btn_font_size2,expand_btn_font_size2,move_time_sec)

func _on_options_mouse_exited() -> void:
	modify_options_btn_size(expand_btn_font_size2,normal_btn_font_size2,move_time_sec)

func _on_quit_mouse_entered() -> void:
	AudioManager.rollover_sfx.play()
	modify_quit_btn_size(normal_btn_font_size2,expand_btn_font_size2,move_time_sec)

func _on_quit_mouse_exited() -> void:
	modify_quit_btn_size(expand_btn_font_size2,normal_btn_font_size2,move_time_sec)
