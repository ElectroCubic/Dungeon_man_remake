extends Node

@onready var bgm_player = $BGMPlayer
@onready var walking_sfx = $WalkingSfx
@onready var click_sfx = $ClickSfx
@onready var rollover_sfx = $RolloverSfx

func _ready():
	bgm_player.play()

func play_walking_sfx():
	walking_sfx.play()
