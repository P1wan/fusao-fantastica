extends Control

@onready var button := $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/AudioManager").play_music("menu")
	button.pressed.connect(_on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/cutscene.tscn")
