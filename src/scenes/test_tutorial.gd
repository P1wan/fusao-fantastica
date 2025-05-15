extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var cam: Camera2D = $Camera2D
@onready var ui: CanvasLayer = $Camera2D/UI
@onready var hint: Label = $Camera2D/UI/HintLabel

func _ready():
	# Access the autoloaded game_manager directly
	var game_manager = GameMaster
	if game_manager:
		game_manager.register_ui(hint)
		print("UI label registered successfully")
	else:
		print("ERROR: game_manager singleton not properly set up!")

func _process(_delta):
	cam.position = player.global_position
	hint.position = player.global_position + Vector2(-45,-64)
