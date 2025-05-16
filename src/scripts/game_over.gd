extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/AudioManager").play_music("elron_theme")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://src/scenes/main_menu.tscn")
