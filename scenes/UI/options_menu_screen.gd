extends CanvasLayer

@onready var main = get_node("../") as Main
@onready var backBtn = $Back
@onready var music_bus_id: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id: int = AudioServer.get_bus_index("SFX")

func _on_music_slider_value_changed(value) -> void:
	if not AudioManager.click_sfx.playing:
		AudioManager.click_sfx.play()
	AudioServer.set_bus_volume_db(music_bus_id,linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < 0.05)

func _on_sfx_slider_value_changed(value) -> void:
	if not AudioManager.click_sfx.playing:
		AudioManager.click_sfx.play()
	AudioServer.set_bus_volume_db(sfx_bus_id,linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < 0.05)

func _on_back_pressed() -> void:
	AudioManager.click_sfx.play()
	await get_tree().create_timer(0.5).timeout
	hide()

func change_back_font_size(size: int) -> void:
	backBtn.add_theme_font_size_override("font_size",size)

func modify_back_btn_size(from_size: int, to_size: int, time_sec: float) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_method(change_back_font_size,from_size,to_size,time_sec)
	await tween.finished

func _on_back_mouse_entered() -> void:
	AudioManager.rollover_sfx.play()
	modify_back_btn_size(main.normal_btn_font_size2,main.expand_btn_font_size2,main.expand_time_sec)

func _on_back_mouse_exited() -> void:
	modify_back_btn_size(main.expand_btn_font_size2,main.normal_btn_font_size2,main.shrink_time_sec)
