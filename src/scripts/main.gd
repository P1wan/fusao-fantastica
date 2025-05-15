# Main.gd
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var scroll_controller = $ScrollController

func _ready():
	scroll_controller.register_player(player)
	var game_manager = GameMaster
	if game_manager:
		var hint_label = scroll_controller.hint
		game_manager.register_ui(hint_label)
	else:
		print("ERROR: game_manager singleton not properly set up!")

func _process(_delta):
	pass
