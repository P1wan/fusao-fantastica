extends Node2D
@onready var anim = $AnimationPlayer

func _ready() -> void:
    anim.play("intro")
    anim.animation_finished.connect(_on_anim_finished)

func _on_anim_finished(anim_name: String) -> void:
    if anim_name == "intro":
        get_tree().change_scene_to_file("res://src/scenes/levels/Level1.tscn")
