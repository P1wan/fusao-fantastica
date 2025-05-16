# Main.gd
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var cam: Camera2D = $ScrollController/Camera2D
@onready var ui: CanvasLayer = $ScrollController/Camera2D/UI
@onready var hint: Label = $ScrollController/Camera2D/UI/HintLabel
@onready var pause_menu = $ScrollController/Camera2D/UI/PauseMenu
@onready var level_end = $LevelEnd

var is_paused := false
var at_game_over := false

func _ready():
	# Access the autoloaded game_manager directly
	var game_manager = GameMaster
	if game_manager:
		game_manager.register_ui(hint)
		print("UI label registered successfully")
	else:
		print("ERROR: game_manager singleton not properly set up!")
	# Connect LevelEnd signal
	level_end.body_entered.connect(_on_level_end_body_entered)

func _process(_delta):
	cam.position = player.global_position
	hint.position = player.global_position + Vector2(-45,-64)

	# Check for pause input or game over menu
	if at_game_over:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().change_scene_to_file("res://src/scenes/main_menu.tscn")
		return
	if Input.is_action_just_pressed("ui_cancel"):
		if is_paused:
			_on_retomar_pressed()
		else:
			_pause_game()

func _pause_game():
	get_tree().paused = true
	is_paused = true
	get_node("/root/AudioManager").play_sfx("pause")
	pause_menu.visible = true
	# Show pause menu here if needed

func _on_retomar_pressed() -> void:
	get_tree().paused = false
	is_paused = false
	get_node("/root/AudioManager").play_sfx("click")
	pause_menu.visible = false
	# Hide pause menu here if needed

func _on_sair_pressed() -> void:
	get_tree().quit()

# Call this from the main menu when entering the game
func play_menu_in_sfx():
	get_node("/root/AudioManager").play_sfx("menu_in")

func _on_level_end_body_entered(body):
	if body == player:
		get_tree().change_scene_to_file("res://src/scenes/game_over.tscn")
