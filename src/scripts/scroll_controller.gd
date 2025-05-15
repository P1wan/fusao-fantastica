extends Node2D

var speed = 50
var scroll_speed = 0
var scroll_offset = Vector2.ZERO

@onready var cam: Camera2D = $Camera2D
@onready var hint: Label = $Camera2D/UI/HintLabel
@onready var player: Node2D = null
@onready var tilemap: TileMapLayer = get_node("../TileMapLayer")

func register_player(p: Node2D):
	player = p

func register_ui(label: Label) -> void:
	# For compatibility with game_manager
	pass

func _process(delta: float) -> void:
	if player:
		var cam_pos = player.global_position
		# Clamp camera x to tilemap bounds
		var used_rect = tilemap.get_used_rect()
		var cell_size = tilemap.tile_set.tile_size
		var left = used_rect.position.x * cell_size.x
		var right = (used_rect.position.x + used_rect.size.x) * cell_size.x
		var half_screen = cam.get_viewport_rect().size.x * 0.5
		cam_pos.x = clamp(cam_pos.x, left + half_screen, right - half_screen)
		cam.position = cam_pos
		hint.position = player.global_position + Vector2(-45, -64)
	
	var axis = Input.get_axis("ui_left", "ui_right")
	
	if axis != 0:
		scroll_speed = axis * speed
	else:
		scroll_speed = 0
		
	scroll_speed = clamp(scroll_speed, -speed, speed)
	
	scroll_offset.x += scroll_speed * delta