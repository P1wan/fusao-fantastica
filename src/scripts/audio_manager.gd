extends Node

const MUSIC   := {
	"menu": preload("res://assets/sound/music/time_for_adventure.mp3"),
	"silent_forest": preload("res://assets/sound/music/04 - Silent Forest.ogg"),
	"fusion_theme": preload("res://assets/sound/music/FusionTheme.ogg"),
	"elron_theme": preload("res://assets/sound/music/ElronTheme.ogg")
}
const SFX     := {
	"jump": preload("res://assets/sound/sfx/jump.wav"),
	"click": preload("res://assets/sound/sfx/Confirm.wav"),
	"walk": preload("res://assets/sound/sfx/Footsteps.wav"),
	"drag": preload("res://assets/sound/sfx/Drag.wav"),
	"pause": preload("res://assets/sound/sfx/Pause.wav"),
	"menu_in": preload("res://assets/sound/sfx/Menu_In.wav"),
	"transform": preload("res://assets/sound/sfx/Transform.wav"),
	"cancel": preload("res://assets/sound/sfx/Cancel.wav"),
	"bump": preload("res://assets/sound/sfx/Bump.wav"),
	"coin": preload("res://assets/sound/sfx/coin.wav"),
	"explosion": preload("res://assets/sound/sfx/explosion.wav"),
	"hurt": preload("res://assets/sound/sfx/hurt.wav"),
	"power_up": preload("res://assets/sound/sfx/power_up.wav"),
	"tap": preload("res://assets/sound/sfx/tap.wav")
}

var music := AudioStreamPlayer.new()
var one_shot := AudioStreamPlayer.new()

func _ready():
	music.bus = "Music"
	one_shot.bus = "SFX"
	add_child(music)
	add_child(one_shot)

func play_music(track):
	music.stream = MUSIC[track]
	music.play()

func stop_music():
	music.stop()

func play_sfx(track):
	one_shot.stream = SFX[track]
	one_shot.play()
