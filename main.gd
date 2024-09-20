extends Node2D

@onready var playBtn := $MainUI/Play
@onready var optionsBtn := $MainUI/Options
@onready var quitBtn := $MainUI/Quit
@export var normal_btn_font_size1: int = 56
@export var expand_btn_font_size1: int = 78
@export var normal_btn_font_size2: int = 42
@export var expand_btn_font_size2: int = 56
@export_range(0.0,1.0,0.1) var expand_time_sec: float = 0.1
@export_range(0.0,1.0,0.1) var shrink_time_sec: float = 0.075

func change_play_font_size(size: int) -> void:
	playBtn.add_theme_font_size_override("font_size",size)

func change_options_font_size(size: int) -> void:
	optionsBtn.add_theme_font_size_override("font_size",size)

func change_quit_font_size(size: int) -> void:
	quitBtn.add_theme_font_size_override("font_size",size)

func modify_play_btn_size(from_size: int, to_size: int, time_sec: float) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(change_play_font_size,from_size,to_size,time_sec)
	await tween.finished

func modify_options_btn_size(from_size: int, to_size: int, time_sec: float) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(change_options_font_size,from_size,to_size,time_sec)
	await tween.finished

func modify_quit_btn_size(from_size: int, to_size: int, time_sec: float) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(change_quit_font_size,from_size,to_size,time_sec)
	await tween.finished

func _on_play_mouse_entered() -> void:
	modify_play_btn_size(normal_btn_font_size1,expand_btn_font_size1,expand_time_sec)

func _on_play_mouse_exited() -> void:
	modify_play_btn_size(expand_btn_font_size1,normal_btn_font_size1,shrink_time_sec)

func _on_play_pressed() -> void:
	Global.intro_scene = true
	TransitionLayer.change_scene("res://scenes/intro_screen.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_quit_mouse_entered() -> void:
	modify_quit_btn_size(normal_btn_font_size2,expand_btn_font_size2,expand_time_sec)

func _on_quit_mouse_exited() -> void:
	modify_quit_btn_size(expand_btn_font_size2,normal_btn_font_size2,shrink_time_sec)

func _on_options_mouse_entered() -> void:
	modify_options_btn_size(normal_btn_font_size2,expand_btn_font_size2,expand_time_sec)

func _on_options_mouse_exited() -> void:
	modify_options_btn_size(expand_btn_font_size2,normal_btn_font_size2,shrink_time_sec)

func _on_title_text_mouse_entered() -> void:
	$MainUI/TitleText.add_theme_color_override("font_color",Color.RED)

func _on_title_text_mouse_exited() -> void:
	$MainUI/TitleText.remove_theme_color_override("font_color")
